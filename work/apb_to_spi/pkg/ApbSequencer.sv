class ApbSequencer extends uvm_sequencer#(ApbItem);
`uvm_component_utils(ApbSequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info(this.get_name(), "is created.", UVM_DEBUG)
    endfunction
endclass