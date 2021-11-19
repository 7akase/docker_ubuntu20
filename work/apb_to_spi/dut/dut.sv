module dut(
    ApbIf.slave  apb,
    SpiIf.master spi
);
    logic selected;
    logic done;
    
    // ----------------------------------------------------
    // State Machine    
    typedef enum logic [2:0] {
        IDLE    = 1, 
        SETUP   = 2,
        ACCESS  = 3
    } state_t;
    state_t state_next;
    state_t state;
  
    always_ff @(posedge apb.PCLK) begin
        if(!apb.PRESETn) begin
            state <= IDLE;
        end else begin
            state <= state_next;
        end
    end

    always_comb begin
        if(!apb.PRESETn || !selected) begin
            state_next = IDLE;
        end else begin
            case(state)
                IDLE    : state_next = SETUP;
                SETUP   : state_next = ACCESS;
                ACCESS  : state_next = done ? IDLE : ACCESS;
            default : state_next = IDLE;
            endcase
        end
    end

    // ----------------------------------------------------
    // apb.PADDR
    logic [31:0] paddr_prev;
    always_ff @(posedge apb.PCLK) begin
        if(!apb.PRESETn || !selected) begin
            paddr_prev <= 32'h0000_0000;
        end else begin
            paddr_prev <= apb.PADDR;
        end
    end

    logic err_paddr_changed;
    assign err_paddr_changed = selected && apb.PENABLE && !apb.PWRITE && paddr_prev != apb.PADDR;

    // ----------------------------------------------------
    // apb.PSELx (input)
    assign selected = apb.PSELx[1] == 1'b1;

    property pselx_onehot;  // apb.PSELx is prohibited not to be onehot.
        @(posedge apb.PENABLE) $onehot(apb.PSELx);
    endproperty

    assert property (pselx_onehot)
        else $display("*assertion failed: PSELx is prohibited not to be onehot.");
    // assign selected = &(apb.PSELx ^ !(2'b1 << 1));

    // ----------------------------------------------------
    // apb.PENABLE (input)

    // ----------------------------------------------------
    // apb.PWRITE (input)

    // ----------------------------------------------------
    // apb.PWDATA (input)
    logic [31:0] pwdata_fetch_value;
    logic        pwdata_fetch_done;
    always_ff @(posedge apb.PCLK)begin
        if(!apb.PRESETn || !selected) begin
            pwdata_fetch_value <= 32'h0000_0000;
            pwdata_fetch_done <= 1'b0;
        end else begin
            if(selected && apb.PWRITE) begin
                pwdata_fetch_value <= apb.PWDATA;
                pwdata_fetch_done <= 1'b1;
            end
        end
    end

    logic [31:0] pwdata_prev;
    always_ff @(posedge apb.PCLK) begin
        if(!apb.PRESETn) begin
            pwdata_prev = 32'h0000_0000;
        end else begin
            pwdata_prev <= apb.PWRITE ? apb.PWDATA : 32'h0000_0000;
        end
    end

    logic err_pwdata_changed;
    assign err_pwdata_changed = selected && apb.PENABLE && apb.PWRITE && pwdata_prev != apb.PWDATA;

    // ----------------------------------------------------
    // apb.PRDATA (input)
    logic prdata_prepared;
    logic prdata_valid;
    always_ff @(posedge apb.PCLK) begin
        if(!apb.PRESETn || !selected) begin
            apb.PRDATA <= 32'h0000_0000;
            prdata_valid <= 1'b0;
        end else begin
            if(prdata_prepared) begin
                if(apb.PADDR > 32'h0000_0000) begin
                    apb.PRDATA <= 32'hcafe_0123;
                end else begin
                    apb.PRDATA <= 32'h0123_cafe;
                end
                prdata_valid <= 1'b1;
            end
        end
    end

    always_ff @(posedge apb.PCLK) begin
        if(!apb.PRESETn || !selected) begin
            prdata_prepared <= 1'b0;
        end else begin
            if(apb.PENABLE) begin
                prdata_prepared <= 1'b1;
            end
        end
    end 

    // ----------------------------------------------------
    // apb.PREADY
    always_ff @(posedge apb.PCLK) begin
        if(!apb.PRESETn || !selected) begin
            apb.PREADY <= 1'b0;
        end else begin
            if((!apb.PWRITE && prdata_prepared) ||
               ( apb.PWRITE && pwdata_fetch_done)) begin
                apb.PREADY <= 1'b1;
            end
            /*
            case(state)
                IDLE   : apb.PREADY <= 1'b0;
                SETUP  : apb.PREADY <= 1'b1;
                ACCESS : apb.PREADY <= (selected && !done) ? 1'b1 : 1'b0;
            endcase
            */
        end
    end

    // ----------------------------------------------------
    // apb.PSLVERR
    always_ff @(posedge apb.PCLK) begin
        if(!apb.PRESETn) begin
            apb.PSLVERR <= 1'b0;
        end else begin
            apb.PSLVERR <= err_paddr_changed
                         | err_pwdata_changed;
        end
    end

    // ----------------------------------------------------
    // apb.PSLVERR
    assign done = (!apb.PWRITE && prdata_valid) || 
                  (apb.PWRITE && pwdata_fetch_done);

    // ----------------------------------------------------
    // spi.SCLK (output)
    logic spi_sclk_int;
    assign spi_sclk_int = (CPHA | !SS) & (CPOL ^ CPHA ^ !apb.PCLK);

    // ----------------------------------------------------
    // spi.SS (output)
    logic spi_wdata_updated;
    always_ff @(posedge apb.PCLK) begin
        if(!apb.PRESETn) begin
            spi.SS[0] <= 1'b1;
        end else begin
            spi.SS[0] <= !spi_wdata_updated;
        end
    end

    logic [4:0] spi_sclk_count;
    always_ff @(negedge apb.PCLK) begin
        if(!apb.PRESETn || spi.SS[0]) begin
            spi_sclk_count <= 5'd1;
        end else begin
            if(spi_sclk_count < 5'd16) begin
                spi_sclk_count <= spi_sclk_count + 5'd1;
            end else begin
                spi_sclk_count <= 5'd16;
            end
        end
    end

    // ----------------------------------------------------
    // spi.MOSI (output)
    logic [15:0] spi_wdata;  // This register holds data to SPI slave when SS is asserterd.
    always_ff @(posedge apb.PCLK) begin
        if(spi.SS[0]) begin  // fetch send data and prepare for first bit of MOSI.
            spi.MOSI          <= pwdata_fetch_value[15];
            spi_wdata         <= {pwdata_fetch_value[15:8], pwdata_fetch_value[7:0]};
            spi_wdata_updated <= 1'b1;
        end else begin
            if(spi_sclk_count < 5'd16) begin
                spi.MOSI          <= spi_wdata[15];
                spi_wdata         <= spi_wdata << 1;
                spi_wdata_updated <= 1'b1;
            end else begin
                spi.MOSI          <= 1'b0;
                spi_wdata_updated <= 1'b0;
            end
        end
    end

    // ----------------------------------------------------
    // spi.MISO (input)
    logic [7:0] spi_rdata;
    always_ff @(posedge apb.PCLK) begin
        if(spi.SS[0]) begin
            spi_rdata <= 8'h00;
        end
        if(spi_sclk_count >= 5'd8 && spi_sclk_count < 5'd16) begin
            spi_rdata <= {spi_rdata[6:0], spi.MOSI};
        end
    end

    // ----------------------------------------------------
    // spi_err (output)
    logic spi_err;
    always_ff @(posedge apb.PCLK) begin
        if(spi.SS[0]) begin
            spi_err <= 1'b0;
        end else begin
            if(spi_sclk_count > 7) begin
                spi_err <= 1'b1;
            end
        end
    end
endmodule