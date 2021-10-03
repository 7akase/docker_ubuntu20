`include "saradc_logic_if.sv"
`include "pkg.sv"

module top;
import uvm_pkg::*;
import pkg::*;
bit    clk;

saradc_logic_if sif(clk);
saradc_logic DUT(
        .clk            (sif.clk            ), 
        .rst            (sif.rst            ),
        .d              (sif.d              ),
        .data_out       (sif.data_out       ),
        .cdac_control   (sif.cdac_control   ));

initial begin
    uvm_config_db#(virtual saradc_logic_if)::set(
        null,
        "*agent0*",
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
