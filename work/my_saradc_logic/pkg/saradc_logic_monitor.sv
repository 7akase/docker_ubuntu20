class saradc_logic_monitor extends uvclib_monitor_base#(saradc_logic_item);
`uvm_component_utils(saradc_logic_monitor)

function new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

endclass