class saradc_logic_agent extends uvm_agent;
saradc_logic_sequencer  sequencer;
saradc_logic_driver     driver;
saradc_logic_collector  collector;
saradc_logic_monitor    monitor;

`uvm_component_utils_begin(saradc_logic_agent)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
`uvm_component_utils_end

function new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass

function void saradc_logic_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(is_active == UVM_ACTIVE) begin
        sequencer = saradc_logic_sequencer::type_id::create("sequencer", this);
        driver    = saradc_logic_driver::type_id::create("driver", this);
    end
    collector = saradc_logic_collector::type_id::create("collector", this);
    monitor   = saradc_logic_monitor::type_id::create("monitor", this);
endfunction

function void saradc_logic_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(is_active == UVM_ACTIVE) begin
        driver.seq_item_port.connect(sequencer.seq_item_export);
    end
    collector.analysis_port.connect(monitor.analysis_export);
endfunction
