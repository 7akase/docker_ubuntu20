class MyRegBlockCfg extends uvm_reg_block;
    rand MyCsrReg csr;
    `uvm_object_utils(MyRegBlockCfg)

    function new(string name="MyRegBlockCfg");
        super.new(name);
    endfunction

    extern function void build();
endclass

function void MyRegBlockCfg::build();
    // name, base_addr, n_bytes, endian, byte_addressing
    this.default_map = create_map("", 0, 1, UVM_LITTLE_ENDIAN, 0);
    
    //-----------------------------------------------
    // CSR register
    //-----------------------------------------------
    this.csr = MyCsrReg::type_id::create("csr",, get_full_name());
    this.csr.configure(this, null, "");
    this.csr.build();
    this.default_map.add_reg(this.csr, `UVM_REG_ADDR_WIDTH'h0, "RW", 0);
endfunction
