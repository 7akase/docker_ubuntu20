class MyMonitor extends uvclib_monitor_base#(MyItem);
`uvm_component_utils(MyMonitor)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info(this.get_name(), "is created.", UVM_DEBUG)
    endfunction

endclass