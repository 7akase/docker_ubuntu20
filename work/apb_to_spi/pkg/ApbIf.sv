interface ApbIf(input bit PCLK);
    logic        PRESETn;
    logic [31:0] PADDR;
    logic [1:0]  PSELx;
    logic        PENABLE;
    logic        PWRITE;
    logic [31:0] PWDATA;
    logic        PREADY;
    logic [31:0] PRDATA;
    logic        PSLVERR;

    modport master(
        output PRESETn, PADDR, PSELx, PENABLE, PWRITE, PWDATA,
        input  PREADY, PRDATA, PSLVERR
    );
    modport slave(
        input  PRESETn, PADDR, PSELx, PENABLE, PWRITE, PWDATA,
        output PREADY, PRDATA, PSLVERR
    );

    clocking cb_apb @(posedge PCLK); endclocking

    task reset();
        PRESETn = 1'b0;
        PADDR = 32'ha5a5_a5a5;
        PSELx = 2'h00;
        PENABLE = 1'b0;
        PWRITE = 1'b0;
        PWDATA = 32'ha5a5_a5a5;
        @(negedge PCLK);
        @(negedge PCLK);
        PRESETn = 1'b1;
        @(negedge PCLK);
    endtask

    task write(input integer slave_id, logic [31:0] addr, logic [31:0] value, output logic err);
        // http://verif-systemverilog.seesaa.net/article/232351897.html?seesaa_related=category
        PADDR = addr;
        PWRITE = 1'b1;
        PSELx = {1'b0};
        PENABLE = 1'b0;
        PSELx[slave_id] = 1'b1;
        PWDATA = value;
        @(negedge PCLK);
        PENABLE = 1'b1;
        @(negedge PCLK);
        while(PREADY != 1'b0) begin
            @(negedge PCLK);
        end
        err = PSLVERR;
        PSELx = {1'b0};
        PENABLE = 1'b0;
        @(negedge PCLK);
    endtask

    task read(input integer slave_id, logic [31:0] addr, output logic [31:0] value, logic err);
        // http://verif-systemverilog.seesaa.net/article/232353020.html?seesaa_related=category
        PADDR = addr;
        PWRITE = 1'b0;
        PSELx = {1'b0};
        PENABLE = 1'b0;
        PSELx[slave_id] = 1'b1;
        @(negedge PCLK);
        PENABLE = 1'b1;
        while(PREADY == 1'b0) begin
            @(negedge PCLK);
        end
        err = PSLVERR;
        value = PRDATA;
        @(negedge PCLK);
        PSELx = {1'b0};
        PENABLE = 1'b0;
        @(negedge PCLK);
    endtask
endinterface