`include "MyIf.sv"
`include "pkg.sv"

module top;
import uvm_pkg::*;
import pkg::*;
bit    clk;

MyIf myIf(clk);
dut DUT(
        .clk            (myIf.clk            ), 
        .rstn           (myIf.rstn           ),
        .in             (myIf.wdata          ),
        .out            (myIf.rdata          ));

initial begin
    uvm_config_db#(virtual MyIf)::set(
        null,
        "*env0*",
        "vif",
        myIf
    );
    run_test();
end

initial begin
    $dumpfile("my_dump_file");
    $dumpvars;
end

initial forever #5 clk = ~clk;

endmodule
