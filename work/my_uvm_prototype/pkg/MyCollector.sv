//class MyCollector extends uvclib_collector_base#(MyItem);
class MyCollector extends uvm_component;
    `uvm_component_utils(MyCollector)

    virtual MyIf                vif;    // overwritten by top module.
    uvm_analysis_port #(MyItem) analysis_port;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_port = new("analysis_port",this);
        `uvm_info(this.get_name(), "is created.", UVM_DEBUG)
    endfunction

    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
endclass

/**
 * Parameters:
 *  phase - uvm_phase
 * Detail:
 *  Check if virtual interface *vif* is assigned properly.
 * See Also:
 *  MyAgent
*/
function void MyCollector::connect_phase(uvm_phase phase);
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
task MyCollector::run_phase(uvm_phase phase);
    MyItem rsp;
    rsp = MyItem::type_id::create("dut_response");
    forever begin
        //-----------------------------------------------
        // RTL to TLM conversion (from here)
        //-----------------------------------------------
        @vif.cb;
        rsp.rdata = vif.rdata;
        //-----------------------------------------------
        // RTL to TLM conversion (from here)
        //-----------------------------------------------
        analysis_port.write(rsp);
    end
endtask
