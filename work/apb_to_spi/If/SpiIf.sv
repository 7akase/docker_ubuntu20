interface SpiIf #(CPOL=0, CPHA=0, SLAVES=1);
    logic [SLAVES-1:0] SS;
    logic              SCLK;
    logic              MISO;
    logic              MOSI;
    logic [7:0]        addr;
    logic [7:0]        wdata;
    logic [7:0]        rdata;
    logic              err;

    modport master(
        output SCLK,
        output SS, MOSI,
        input  MISO,
        output err
    );
    modport slave(
        input  SCLK,
        input  SS, MOSI,
        output MISO,
        output addr,
        output wdata,
        input  rdata,
        output err
    );

    // ----------------------------------------------------
    // SCLK
    logic clk_master_tx;
    logic clk_master_rx;
    logic clk_slave_tx;
    logic clk_slave_rx;

    assign clk_master_tx = CPOL == 0 ? !SCLK :  SCLK;
    assign clk_master_rx = CPOL == 0 ?  SCLK : !SCLK;
    assign clk_slave_tx  = CPOL == 0 ? !SCLK :  SCLK;
    assign clk_slave_rx  = CPOL == 0 ?  SCLK : !SCLK;

    clocking cb_master_tx @(posedge clk_master_tx); endclocking
    clocking cb_master_rx @(posedge clk_master_rx); endclocking
    clocking cb_slave_tx  @(posedge clk_slave_tx);  endclocking
    clocking cb_slave_rx  @(posedge clk_slave_rx);  endclocking

    // ----------------------------------------------------
    // Write Operation
    task master_write(input integer slave_id, logic [7:0] addr, logic [7:0] value, output logic err);       
        SS[slave_id] = 1'b0;
        for(int i=7; i>=0; i--) begin
            MOSI = addr[i];
            @cb_master_tx;
        end

        for(int i=7; i>=0; i--) begin
            MOSI = value[i];
            @cb_master_tx;
        end
        SS[slave_id] = 1'b1;
    endtask

    task slave_write(input integer slave_id, output logic [7:0] addr, logic [7:0] value, logic err);
        @(negedge SS[0]);
        err = 1'b0;
        fork 
            @(posedge SS[0]) err = 1'b1;  // Return error if SS rises during transaction.
            begin : normal_operation
                for(int i=7; i>=0; i--) begin
                    @cb_slave_rx; addr[i] = MOSI;
                end
                for(int i=7; i>=0; i--) begin
                    @cb_slave_rx; value[i] = MOSI;
                end
            end
        join_any
    endtask

    // ----------------------------------------------------
    // Read Operation
    task master_read(input integer slave_id, logic [31:0] addr, output logic [31:0] value, err);
        SS[slave_id] = 1'b0;
        for(int i=7; i>=0; i--) begin
            MOSI = addr[i];
            @cb_master_tx;
        end

        for(int i=7; i>=0; i--) begin
            MOSI = value[i];
            @cb_master_tx;
        end
        SS[slave_id] = 1'b1;
    endtask
endinterface