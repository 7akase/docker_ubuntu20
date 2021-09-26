class saradc_logic_test_base extends uvm_test;
saradc_logic_env env0;

`uvm_component_utils(saradc_logic_test_base)

function new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

extern function void build_phase(uvm_phase phase);
endclass

function void saradc_logic_test_base::build_phase(uvm_phase phase);
    super.build_phase(phase);
    env0 = saradc_logic_env::type_id::create("env0", this);
endfunction