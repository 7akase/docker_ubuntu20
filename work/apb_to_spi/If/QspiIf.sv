interface QspiIf #(CPOL=0, CPHA=0, SLAVES=1, QSPI=4, NPHA_INST=8, NPHA_ADDR, NPHA_ALT=1, NPHA_DMY=2, NPHA_VALUE=8);
    logic [SLAVES-1:0]            SS;
    logic                         SCLK;
    logic [QSPI-1:0]              MISO;
    logic [QSPI-1:0]              MOSI;
    logic [QSPI*NPHA_ADDR-1:0]    addr;
    logic [QSPI*NPHA_VALUE-1:0]   wdata;
    logic [QSPI*NPHA_VALUE-1:0]   rdata;
    logic                         err;

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
    task master_write(input  integer                    slave_id,
                             logic [QSPI*NPHA_ADDR-1:0] inst,
                             logic [QSPI*NPHA_ALT -1:0] alt,
                             logic [QSPI*NPHA_DATA-1:0] value,
                      output logic                      err);

        SS[slave_id] = 1'b0;

        // Instruction Phase
        for(int i=NPHA_INST-1; i>=0; i--) begin
            for(int j=QSPI-1; j>=0; i--) begin
                MOSI[j] = inst[QSPI*i+j];
            end
            @cb_master_tx;
        end

        // Address Phase
        for(int i=NPHA_ADDR-1; i>=0; i--) begin
            for(int j=QSPI-1; j>=0; i--) begin
                MOSI[j] = addr[QSPI*i+j];
            end
            @cb_master_tx;
        end

        // Alternate Phase
        for(int i=NPHA_ALT-1; i>=0; i--) begin
            for(int j=QSPI-1; j>=0; i--) begin
                MOSI[j] = alt[QSPI*i+j];
            end
            @cb_master_tx;
        end

        // Dummy Phase
        for(int i=NPHA_DMY-1; i>=0; i--) begin
            @cb_master_tx;
        end

        // Data Phase
        for(int i=NPHA_DATA-1; i>=0; i--) begin
            for(int j=QSPI-1; j>=0; i--) begin
                MOSI[j] = value[QSPI*i+j];
            end
            @cb_master_tx;
        end

        SS[slave_id] = 1'b1;
    endtask

    task slave_write(input  integer                    slave_id,
                            logic [QSPI*NPHA_ADDR-1:0] inst,
                            logic [QSPI*NPHA_ALT -1:0] alt,
                            logic [QSPI*NPHA_DATA-1:0] value,
                     output logic                      err);
        @(negedge SS[0]);
        err = 1'b0;
        fork 
            @(posedge SS[0]) err = 1'b1;  // Return error if SS rises during transaction.
            begin : normal_operation
                // Instruction Phase
                for(int i=NPHA_INST-1; i>=0; i--) begin
                    for(int j=QSPI-1; j>=0; i--) begin
                        @cb_slave_rx; inst[QSPI*i+j] = MOSI;
                    end
                end

                // Address Phase
                for(int i=NPHA_ADDR-1; i>=0; i--) begin
                    for(int j=QSPI-1; j>=0; i--) begin
                        @cb_slave_rx; addr[QSPI*i+j] = MOSI;
                    end
                    @cb_master_tx;
                end

                // Alternate Phase
                for(int i=NPHA_ALT-1; i>=0; i--) begin
                    for(int j=QSPI-1; j>=0; i--) begin
                        @cb_slave_rx; alt[QSPI*i+j] = MOSI;
                    end
                    @cb_master_tx;
                end

                // Dummy Phase
                for(int i=NPHA_DMY-1; i>=0; i--) begin
                    @cb_slave_rx;
                end

                // Data Phase
                for(int i=NPHA_DATA-1; i>=0; i--) begin
                    for(int j=QSPI-1; j>=0; i--) begin
                        @cb_slave_rx; value[QSPI*i+j] = MOSI;
                    end
                    @cb_master_tx;
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