//class ApbCollector extends uvclib_collector_base#(ApbItem);
class ApbCollector extends uvm_component;
    `uvm_component_utils(ApbCollector)

    virtual ApbIf                           vif;    // overwritten by top module.
    uvm_analysis_port #(ApbItem)            analysis_port;
    uvm_analysis_imp #(ApbItem,ApbCollector) from_driver;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_port = new("analysis_port",this);
        from_driver = new("from_driver",this);
        `uvm_info(this.get_name(), "is created.", UVM_DEBUG)
    endfunction

    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern function void write(ApbItem item);
endclass

/**
 * Parameters:
 *  phase - uvm_phase
 * Detail:
 *  Check if virtual interface *vif* is assigned properly.
 * See Also:
 *  MyAgent
*/
function void ApbCollector::connect_phase(uvm_phase phase);
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
task ApbCollector::run_phase(uvm_phase phase);
    ApbItem rsp;
    rsp = ApbItem::type_id::create("dut_response");
    forever begin
        //-----------------------------------------------(from here)
        // RTL to TLM conversion
        @vif.cb_apb;
        if(vif.PENABLE && vif.PREADY) begin
            rsp.t = $realtime();
            rsp.paddr  = vif.PADDR;
            rsp.slave_id = vif.PSELx;
            rsp.pwrite = vif.PWRITE;
            rsp.pwdata = vif.PWDATA;
            rsp.prdata = vif.PRDATA;
            rsp.pslverr = vif.PSLVERR;
            analysis_port.write(rsp);
            `CRED
            $display($sformatf("time %f, APB transaction done.", $realtime));
            `CEND
        end
        //-----------------------------------------------(to here)
    end
endtask

/**
 * Parameters:
 *  item - ApbItem
 * Detail:
 *  callback for analysis_port (uvm_analysis_port).
*/
function void ApbCollector::write(ApbItem item);
    `uvm_info(this.get_full_name(), "received from ap.", UVM_DEBUG)

endfunction