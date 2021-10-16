class MySequencer extends uvm_sequencer#(MyItem);
`uvm_component_utils(MySequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info(this.get_name(), "is created.", UVM_DEBUG)
    endfunction

endclass