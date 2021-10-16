module dut(
    input logic clk,
    input logic rstn,
    input logic in,
    output logic [7:0] out
);
    always @(posedge clk) begin
        if(!rstn) begin
            out[7:0] <= {0};
        end else begin
            out[7:0] <= {8{in}};
        end
    end
endmodule