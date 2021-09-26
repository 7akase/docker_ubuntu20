class saradc_logic_driver extends uvclib_driver_base #(saradc_logic_item);
`uvm_component_utils(saradc_logic_driver)

function new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

extern task get_and_drive();
endclass

task saradc_logic_driver::get_and_drive();
    seq_item_port.get_next_item(req);
    @(posedge vif.clk) begin
        vif.d <= req.d;
        vif.rst <= req.rst;
    end
    repeat(4) begin
        @(posedge vif.clk) begin
            vif.d <= ~vif.d;
        end
    end
    seq_item_port.item_done();
endtask