class SpiItem extends uvm_sequence_item;
    real                t;
    rand logic [7:0]    addr;
    rand int            slave_id;
    rand logic          write;
    rand logic [7:0]    wdata;    // from master to slave
    rand logic [7:0]    rdata;    // from slave to master
    rand bit            err;

    // logic wdata_value[] = '{ 0, 1, 0, 1 };

    `uvm_object_utils_begin(SpiItem)
        `uvm_field_real(t          , UVM_DEFAULT)
        `uvm_field_int(addr        , UVM_DEFAULT)
        `uvm_field_int(slave_id    , UVM_DEFAULT)
        `uvm_field_int(write       , UVM_DEFAULT)
        `uvm_field_int(wdata       , UVM_DEFAULT)
        `uvm_field_int(rdata       , UVM_DEFAULT)
        `uvm_field_int(err         , UVM_DEFAULT)
    `uvm_object_utils_end

    constraint C_PSELX { slave_id inside { [0:1] }; }

    function new(string name="SpiItem");
        super.new(name);
        t = 0;
        `uvm_info(this.get_full_name(), "is created.", UVM_DEBUG)
    endfunction
endclass