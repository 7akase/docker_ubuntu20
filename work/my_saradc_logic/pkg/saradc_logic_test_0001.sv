class saradc_logic_test_0001 extends saradc_logic_test_base;
`uvm_component_utils(saradc_logic_test_0001)

function new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

extern function void build_phase(uvm_phase phase);
endclass

function void saradc_logic_test_0001::build_phase(uvm_phase phase);
    uvm_config_db#(uvm_object_wrapper)::set(
        this,
        "env0.agent0.sequencer.run_phase",
        "default_sequence",
        saradc_logic_sequence_test1::type_id::get()
    );
    super.build_phase(phase);
endfunction