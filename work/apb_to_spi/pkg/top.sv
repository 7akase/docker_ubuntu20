`include "ApbIf.sv"
`include "pkg.sv"

module top;
import uvm_pkg::*;
import pkg::*;
bit    clk;

default clocking cb @(posedge clk); endclocking

logic [5:0] pready_d;
always_ff @(posedge clk) begin
    pready_d[5:1] <= pready_d[4:0];
end

assign apbIf.PREADY = pready_d[3];

ApbIf apbIf(clk);
dut DUT(
    .PCLK       (apbIf.PCLK    ),
    .PRESETn    (apbIf.PRESETn ),
    .PADDR      (apbIf.PADDR   ),
    .PSELx      (apbIf.PSELx   ),  
    .PENABLE    (apbIf.PENABLE ),
    .PWRITE     (apbIf.PWRITE  ),
    .PWDATA     (apbIf.PWDATA  ),
    .PREADY     (apbIf.PREADY  ),
    .PRDATA     (apbIf.PRDATA  ),
    .PSLVERR    (apbIf.PSLVERR ));


initial begin
    uvm_config_db#(virtual ApbIf)::set(
        null,
        "*env0*",
        "vif",
        apbIf
    );
    run_test();
end

initial begin
    $dumpfile("my_dump_file");
    $dumpvars;
end

initial forever #5 clk = ~clk;
initial #2000 $stop();

endmodule
