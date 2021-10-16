module dut(
    input logic clk,
    input logic rstn,
    input logic in,
    output logic [7:0] out
);

assign out[7:0] = {8{in}};

endmodule