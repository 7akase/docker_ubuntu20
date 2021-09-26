class saradc_logic_env extends uvm_env;
saradc_logic_agent agent0;

`uvm_component_utils(saradc_logic_env)

function new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

extern function void build_phase(uvm_phase phase);
endclass

function void saradc_logic_env::build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent0 = saradc_logic_agent::type_id::create("agent0",this);
endfunction