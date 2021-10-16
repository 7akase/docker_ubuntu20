class MyTest0001 extends uvm_test;
    MyEnv env0;
    `uvm_component_utils(MyTest0001)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        `uvm_info("debug", get_full_name(), UVM_DEBUG);
        uvm_config_db#(uvm_object_wrapper)::set(
            this,
            "env0.agent0.sequencer.run_phase",
            "default_sequence",
            MyTestSequence0001::type_id::get()
        );
        super.build_phase(phase);
        env0 = MyEnv::type_id::create("env0", this);
    endfunction
endclass