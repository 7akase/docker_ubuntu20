interface saradc_logic_if(input bit clk);
logic       rst, d;
logic [7:0] data_out;
logic [7:0] cdac_control;

clocking cb @(posedge clk); endclocking
endinterface
