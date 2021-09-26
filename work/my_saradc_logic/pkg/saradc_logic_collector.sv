class saradc_logic_collector extends uvclib_collector_base#(saradc_logic_item);
`uvm_component_utils(saradc_logic_collector)

function new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

extern task get_response();;
endclass

task saradc_logic_collector::get_response();
    saradc_logic_item data;
    data = saradc_logic_item::type_id::create("dut_response");
    forever begin
        @vif.cb;
        data.d = vif.rst ? 1'b0 : vif.d;  // synchronous rest
        data.data_out = vif.data_out;
        data.cdac_control = vif.cdac_control;
        analysis_port.write(data);
    end
endtask