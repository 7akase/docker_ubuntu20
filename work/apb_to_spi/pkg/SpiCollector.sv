//class SpiCollector extends uvclib_collector_base#(SpiItem);
class SpiCollector extends uvm_component;
    `uvm_component_utils(SpiCollector)

    virtual SpiIf                           vif;    // overwritten by top module.
    uvm_analysis_port #(SpiItem)            analysis_port;
    uvm_analysis_imp #(SpiItem,SpiCollector) from_driver;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_port = new("analysis_port",this);
        from_driver = new("from_driver",this);
        `uvm_info(this.get_name(), "is created.", UVM_DEBUG)
    endfunction

    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern function void write(SpiItem item);
endclass

/**
 * Parameters:
 *  phase - uvm_phase
 * Detail:
 *  Check if virtual interface *vif* is assigned properly.
 * See Also:
 *  MyAgent
*/
function void SpiCollector::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if( !uvm_config_db #(COL_VIF)::get(this, get_full_name(), "vif", vif))
		`uvm_error("NO-VIF", {"VIF error for ", get_full_name(),".vif"})
endfunction

/**
 * Parameters:
 *  phase - uvm_phase
 * Detail:
 *  Get signals from DUT (RTL) through interface and pass it as a transaction (TLM).
*/
task SpiCollector::run_phase(uvm_phase phase);
    SpiItem rsp;
    rsp = SpiItem::type_id::create("dut_response");
    forever begin
        //-----------------------------------------------(from here)
        // RTL to TLM conversion
        @(posedge vif.SS[0])
        vif.slave_write(0, vif.addr, vif.wdata, vif.err);
        rsp.t     = $realtime();
        rsp.addr  = vif.addr;
        rsp.wdata = vif.wdata;
        rsp.err   = vif.err;
        analysis_port.write(rsp);
        `CRED
        $display($sformatf("time %f, SPI transaction done.", $realtime));
        `CEND
        //-----------------------------------------------(to here)
    end
endtask

/**
 * Parameters:
 *  item - SpiItem
 * Detail:
 *  callback for analysis_port (uvm_analysis_port).
*/
function void SpiCollector::write(SpiItem item);
    `uvm_info(this.get_full_name(), "received from ap.", UVM_DEBUG)
endfunction