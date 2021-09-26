module saradc_logic(
    input logic clk,
    input logic rst,
    input logic d,
    output logic [7:0] data_out,
    output logic [7:0] cdac_control
);

assign data_out[7:0] = {8{d}};
assign cdac_control[7:0] = {8{d}};

endmodule