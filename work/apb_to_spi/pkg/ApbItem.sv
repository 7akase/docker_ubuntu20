class ApbItem extends uvm_sequence_item;
    real                t;
    rand logic          rstn;
    rand logic [31:0]   paddr;
    rand int            slave_id;
    rand logic          pwrite;
    rand logic [31:0]   pwdata;    // from master to slave
    rand logic [31:0]   prdata;    // from slave to master
    rand bit            pslverr;

    // logic wdata_value[] = '{ 0, 1, 0, 1 };

    `uvm_object_utils_begin(ApbItem)
        `uvm_field_real(t           , UVM_DEFAULT)
        `uvm_field_int(rstn         , UVM_DEFAULT)
        `uvm_field_int(paddr        , UVM_DEFAULT)
        `uvm_field_int(slave_id     , UVM_DEFAULT)
        `uvm_field_int(pwrite       , UVM_DEFAULT)
        `uvm_field_int(pwdata       , UVM_DEFAULT)
        `uvm_field_int(prdata       , UVM_DEFAULT)
        `uvm_field_int(pslverr      , UVM_DEFAULT)
    `uvm_object_utils_end

    //constraint C_D { wdata inside { rdata_value }; }
    constraint C_ADDR  { paddr%4 == 0; }
    constraint C_PSELX { slave_id inside { [0:1] }; }

    function new(string name="ApbItem");
        super.new(name);
        t = 0;
        `uvm_info(this.get_full_name(), "is created.", UVM_DEBUG)
    endfunction
endclass