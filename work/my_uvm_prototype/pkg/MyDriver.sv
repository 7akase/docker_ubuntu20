class MyDriver extends uvclib_driver_base #(MyItem);
`uvm_component_utils(MyDriver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info(this.get_name(), "is created.", UVM_DEBUG)
    endfunction

    extern task get_and_drive();
endclass

task MyDriver::get_and_drive();
    seq_item_port.get_next_item(req);
    @(negedge vif.clk) begin
        vif.wdata <= req.wdata[0];
        vif.rstn  <= 1'b0;
    end
    repeat(4) begin
        @(negedge vif.clk) begin
            vif.wdata <= ~vif.wdata;
        end
    end
    seq_item_port.item_done();
endtask
