class saradc_logic_sequencer extends uvm_sequencer#(saradc_logic_item);
`uvm_component_utils(saradc_logic_sequencer)

function new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

endclass