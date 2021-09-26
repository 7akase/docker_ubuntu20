class saradc_logic_item extends uvm_sequence_item;

rand logic       rst;
rand logic       d;
rand logic [7:0] data_out;
rand logic [7:0] cdac_control;

logic d_value[] = '{ 0, 1, 0, 1 };

`uvm_object_utils_begin(saradc_logic_item)
    `uvm_field_int(rst          , UVM_DEFAULT)
    `uvm_field_int(d            , UVM_DEFAULT)
    `uvm_field_int(data_out     , UVM_DEFAULT)
    `uvm_field_int(cdac_control , UVM_DEFAULT)
`uvm_object_utils_end

constraint C_D { d inside { d_value }; }

function new(string name="saradc_logic_item");
    super.new(name);
endfunction

endclass