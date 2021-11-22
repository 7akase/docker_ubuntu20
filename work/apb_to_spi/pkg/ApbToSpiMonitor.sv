`uvm_analysis_imp_decl(_from_driver);
`uvm_analysis_imp_decl(_from_collector);

class ApbToSpiMonitor extends uvm_monitor;
    uvm_analysis_imp_from_driver    #(ApbItem, ApbToSpiMonitor) analysis_export_from_driver;
    uvm_analysis_imp_from_collector #(SpiItem, ApbToSpiMonitor) analysis_export_from_collector;
    uvm_analysis_port               #(ApbItem)                  item_collected_port;

    string str_in, str_rsp, log;
    `uvm_component_utils_begin(ApbToSpiMonitor)
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

    extern function void write_from_driver   (ApbItem data);
    extern function void write_from_collector(SpiItem data);
    extern function void extract_phase(uvm_phase phase);
endclass

function void ApbToSpiMonitor::write_from_driver(ApbItem data);
    string s;
    s = data.sprint();
    log = {log, "stimulus: ", s, "\n"};
endfunction

function void ApbToSpiMonitor::write_from_collector(SpiItem data);
    string s;
    s = data.sprint();
    log = {log, "response: ", s, "\n"};
endfunction

function void ApbToSpiMonitor::extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    $display("input:  %s\n", log);
endfunction