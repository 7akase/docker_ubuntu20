interface MyIf(input bit clk);
logic       rstn;
logic       in;
logic       wdata;
logic [7:0] rdata;

clocking cb @(posedge clk); endclocking

task reset();
    rstn = 1'b0;
    @(negedge clk);
    @(negedge clk);
    rstn = 1'b1;
endtask

endinterface