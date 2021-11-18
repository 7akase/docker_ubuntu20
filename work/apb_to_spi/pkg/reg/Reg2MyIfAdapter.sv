class Reg2MyIfAdapter extends uvm_reg_adapter;
    `uvm_object_utils(Reg2MyIfAdapter)

    function new(string name="Reg2MyIfAdapter");
        super.new(name);
    endfunction

    extern function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    // extern task pre_body();
    // extern task body();
    // extern task post_body();
endclass

function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    Reg2SpiItem pkt = Reg2SpiItem::type_id::create("pkt");
    pkt.write = 
endfunction
