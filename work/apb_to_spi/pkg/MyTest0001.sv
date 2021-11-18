class MyTest0001 extends uvm_test;
    MyEnv env0;
    `uvm_component_utils(MyTest0001)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        `uvm_info("debug", get_full_name(), UVM_DEBUG);
        /*uvm_config_db#(uvm_object_wrapper)::set(
            this,
            "env0.agent0.sequencer.run_phase",
            "default_sequence",
            MyTestSequence0001::type_id::get()
        );*/
        super.build_phase(phase);
        env0 = MyEnv::type_id::create("env0", this);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_root uvm_root_hdl;
        ApbSequencer sequencer;
        ApbTestSequence0001 test1;

        uvm_root_hdl = uvm_root::get();
        $cast(sequencer, uvm_root_hdl.find("uvm_test_top.env0.agent0.sequencer"));
        if(sequencer == null) begin
            `uvm_error(get_type_name(), "The sequencer was not found.");
        end

        test1 = ApbTestSequence0001::type_id::create("test1");

        phase.raise_objection(this);
        $display("---------------------------------------------------------\n");
        test1.start(sequencer);
        $display("---------------------------------------------------------\n");
        phase.drop_objection(this);
    endtask
endclass