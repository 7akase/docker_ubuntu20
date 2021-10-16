class MyItem extends uvm_sequence_item;
    rand logic       rstn;
    rand logic [7:0] wdata;    // from Driver to DUT
    rand logic [7:0] rdata;    // from DUT to Collector

    logic rdata_value[] = '{ 0, 1, 0, 1 };

    `uvm_object_utils_begin(MyItem)
        `uvm_field_int(rstn         , UVM_DEFAULT)
        `uvm_field_int(wdata        , UVM_DEFAULT)
        `uvm_field_int(rdata        , UVM_DEFAULT)
    `uvm_object_utils_end

    constraint C_D { rdata inside { rdata_value }; }

    function new(string name="MyItem");
        super.new(name);
        `uvm_info(this.get_name(), "is created.", UVM_DEBUG)
    endfunction
endclass