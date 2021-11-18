class MyEnv extends uvm_env;
    MyAgent agent0;
    `uvm_component_utils(MyEnv)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info(this.get_name(), "is created.", UVM_MEDIUM)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent0 = MyAgent::type_id::create("agent0",this);
    endfunction
endclass