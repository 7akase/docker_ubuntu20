class MyDriver extends uvm_driver #(MyItem,MyItem);
    `uvm_component_utils(MyDriver)

    virtual MyIf vif;    // overwritten by top module.
    uvm_analysis_port #(MyItem) analysis_port;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_port = new("analysis_port", this);
        `uvm_info(this.get_name(), "is created.", UVM_DEBUG)
    endfunction

    extern function void build_phase(uvm_phase phase);
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
function void MyDriver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if( !uvm_config_db#(DRV_VIF)::get(this, "", "vif", vif))
		`uvm_error("NO-VIF", {"VIF error for ", get_full_name(),".vif"})
endfunction

/**
 * Parameters:
 *  phase - uvm_phase
 * Detail:
 *  Get next transaction (TLM) and pass it to DUT (RTL) through interface.
*/
task MyDriver::run_phase(uvm_phase phase);
    forever begin
        seq_item_port.get_next_item(req);
        req.t = $realtime();
        analysis_port.write(req);

    	//-----------------------------------------------
    	// TLM to RTL conversion (from here)
        //-----------------------------------------------
        vif.reset();
        vif.wdata <= req.wdata;
        for(int i=0; i<req.len; i++) begin
            @(negedge vif.clk) begin
                vif.wdata <= req.wdata[i];
            end
        end
    	//-----------------------------------------------
    	// TLM to RTL conversion (to here)
        //-----------------------------------------------
        seq_item_port.item_done();
	end
endtask
