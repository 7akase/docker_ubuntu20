`uvm_analysis_imp_decl(_from_driver);
`uvm_analysis_imp_decl(_from_collector);

class MyMonitor extends uvm_monitor;
    uvm_analysis_imp_from_driver    #(MyItem, MyMonitor) analysis_export_from_driver;
    uvm_analysis_imp_from_collector #(MyItem, MyMonitor) analysis_export_from_collector;
    uvm_analysis_port               #(MyItem)            item_collected_port;

    string str_in, str_rsp, log;
    `uvm_component_utils_begin(MyMonitor)
        `uvm_field_string(str_in, UVM_DEFAULT);
        `uvm_field_string(str_rsp, UVM_DEFAULT);
        `uvm_field_string(log, UVM_DEFAULT);
    `uvm_component_utils_end

    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_export_from_driver    = new("analysis_export_from_driver"   , this);
        analysis_export_from_collector = new("analysis_export_from_collector", this);
        item_collected_port            = new("item_colleted_port",this);

        `uvm_info(this.get_name(), "is created.", UVM_DEBUG)
    endfunction

    extern function void write_from_driver   (MyItem data);
    extern function void write_from_collector(MyItem data);
    extern function void extract_phase(uvm_phase phase);
endclass

function void MyMonitor::write_from_driver(MyItem data);
    string s;
    s = data.sprint();
    log = {log, "stimulus: ", s, "\n"};
endfunction

function void MyMonitor::write_from_collector(MyItem data);
    string s;
    s = data.sprint();
    log = {log, "response: ", s, "\n"};
endfunction

function void MyMonitor::extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    $display("input:  %s\n", log);
endfunction