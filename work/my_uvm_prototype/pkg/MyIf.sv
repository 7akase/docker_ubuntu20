interface MyIf(input bit clk);
logic       rstn;
logic       wdata;
logic [7:0] rdata;

clocking cb @(posedge clk); endclocking

task reset();
    wdata   = 1'b0;
    rstn    = 1'b0;
    @(negedge clk);
    @(negedge clk);
    rstn    = 1'b1;
endtask

endinterface