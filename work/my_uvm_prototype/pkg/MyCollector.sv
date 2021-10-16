class MyCollector extends uvclib_collector_base#(MyItem);
`uvm_component_utils(MyCollector)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info(this.get_name(), "is created.", UVM_DEBUG)
    endfunction

    extern task get_response();;
    endclass

    task MyCollector::get_response();
        MyItem rsp;
        rsp = MyItem::type_id::create("dut_response");
        forever begin
            @vif.cb;
            rsp.rdata = vif.rdata;
        analysis_port.write(rsp);
    end
endtask