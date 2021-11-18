module dut(
    input  var logic        PCLK,
           var logic        PRESETn,
           var logic [31:0] PADDR,
           var logic [1:0]  PSELx,
           var logic        PENABLE,
           var logic        PWRITE,
           var logic [31:0] PWDATA,
    output var logic        PREADY,
           var logic [31:0] PRDATA,
           var logic        PSLVERR
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
  
    always_ff @(posedge PCLK) begin
        if(!PRESETn) begin
            state <= IDLE;
        end else begin
            state <= state_next;
        end
    end

    always_comb begin
        if(!PRESETn || !selected) begin
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
    // PADDR
    logic [31:0] paddr_prev;
    always_ff @(posedge PCLK) begin
        if(!PRESETn || !selected) begin
            paddr_prev <= 32'h0000_0000;
        end else begin
            paddr_prev <= PADDR;
        end
    end

    logic err_paddr_changed;
    assign err_paddr_changed = selected && PENABLE && !PWRITE && paddr_prev != PADDR;

    // ----------------------------------------------------
    // PSELx (input)
    assign selected = PSELx[1] == 1'b1;  // PSELx should be one-hot.
    // assign selected = &(PSELx ^ !(2'b1 << 1));

    // ----------------------------------------------------
    // PENABLE (input)

    // ----------------------------------------------------
    // PWRITE (input)

    // ----------------------------------------------------
    // PWDATA (input)
    logic [31:0] pwdata_fetch_value;
    logic        pwdata_fetch_done;
    always_ff @(posedge PCLK)begin
        if(!PRESETn || !selected) begin
            pwdata_fetch_value <= 32'h0000_0000;
            pwdata_fetch_done <= 1'b0;
        end else begin
            if(selected && PWRITE) begin
                pwdata_fetch_value <= PWDATA;
                pwdata_fetch_done <= 1'b1;
            end
        end
    end

    logic [31:0] pwdata_prev;
    always_ff @(posedge PCLK) begin
        if(!PRESETn) begin
            pwdata_prev = 32'h0000_0000;
        end else begin
            pwdata_prev <= PWRITE ? PWDATA : 32'h0000_0000;
        end
    end

    logic err_pwdata_changed;
    assign err_pwdata_changed = selected && PENABLE && PWRITE && pwdata_prev != PWDATA;

    // ----------------------------------------------------
    // PRDATA (input)
    logic prdata_prepared;
    logic prdata_valid;
    always_ff @(posedge PCLK) begin
        if(!PRESETn || !selected) begin
            PRDATA <= 32'h0000_0000;
            prdata_valid <= 1'b0;
        end else begin
            if(prdata_prepared) begin
                if(PADDR > 32'h0000_0000) begin
                    PRDATA <= 32'hcafe_0123;
                end else begin
                    PRDATA <= 32'h0123_cafe;
                end
                prdata_valid <= 1'b1;
            end
        end
    end

    always_ff @(posedge PCLK) begin
        if(!PRESETn || !selected) begin
            prdata_prepared <= 1'b0;
        end else begin
            if(PENABLE) begin
                prdata_prepared <= 1'b1;
            end
        end
    end 

    // ----------------------------------------------------
    // PREADY
    always_ff @(posedge PCLK) begin
        if(!PRESETn || !selected) begin
            PREADY <= 1'b0;
        end else begin
            if((!PWRITE && prdata_prepared) ||
               ( PWRITE && pwdata_fetch_done)) begin
                PREADY <= 1'b1;
            end
            /*
            case(state)
                IDLE   : PREADY <= 1'b0;
                SETUP  : PREADY <= 1'b1;
                ACCESS : PREADY <= (selected && !done) ? 1'b1 : 1'b0;
            endcase
            */
        end
    end

    // ----------------------------------------------------
    // PSLVERR
    always_ff @(posedge PCLK) begin
        if(!PRESETn) begin
            PSLVERR <= 1'b0;
        end else begin
            PSLVERR <= err_paddr_changed
                     | err_pwdata_changed;
        end
    end

    // ----------------------------------------------------
    // PSLVERR
    assign done = (!PWRITE && prdata_valid) || 
                  (PWRITE && pwdata_fetch_done);
endmodule