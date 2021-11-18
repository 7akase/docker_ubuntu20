class MyAgent extends uvm_agent;
    ApbSequencer   sequencer;
    ApbDriver     driver;
    ApbCollector  collector;
    ApbMonitor     monitor;

    `uvm_component_utils_begin(MyAgent)
        `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_component_utils_end

    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info(this.get_name(), "is created.", UVM_DEBUG)
    endfunction

    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
endclass

function void MyAgent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(is_active == UVM_ACTIVE) begin
        sequencer = ApbSequencer::type_id::create("sequencer", this);
        driver    = ApbDriver::type_id::create("driver", this);
    end
    collector = ApbCollector::type_id::create("collector", this);
    monitor   = ApbMonitor::type_id::create("monitor", this);
endfunction

function void MyAgent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(is_active == UVM_ACTIVE) begin
        driver.seq_item_port.connect(sequencer.seq_item_export);
    end
    driver.analysis_port.connect(monitor.analysis_export_from_driver);
    collector.analysis_port.connect(monitor.analysis_export_from_collector);
endfunction
