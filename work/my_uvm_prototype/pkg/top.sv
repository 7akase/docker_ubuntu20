`include "MyIf.sv"
`include "pkg.sv"

module top;
import uvm_pkg::*;
import pkg::*;
bit    clk;

MyIf sif(clk);
dut DUT(
        .clk            (sif.clk            ), 
        .rstn           (sif.rstn           ),
        .in             (sif.wdata          ),
        .out            (sif.rdata          ));

initial begin
    uvm_config_db#(virtual MyIf)::set(
        null,
        "*env0*",
        "vif",
        sif
    );
    run_test();
end

initial begin
    $dumpfile("my_dump_file");
    $dumpvars;
end

initial forever #10 clk = ~clk;

endmodule
