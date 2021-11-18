class MyRegBlock extends uvm_reg_block;
    rand MyRegBlockCfg cfg;
    `uvm_object_utils(MyRegBlock)

    function new(string name="MyRegBlock");
        super.new(name);
    endfunction

    extern function void build();
endclass

function void MyRegBlock::build();
    // name, base_addr, n_bytes, endian, byte_addressing
    this.default_map = create_map("", 0, 1, UVM_LITTLE_ENDIAN, 0);
    this.cfg = MyRegBlockCfg::type_id::create("cfg",,get_full_name());
    this.cfg.configure(this, "top.reg_map");
    this.cfg.build();
    this.default_map.add_submap(this.cfg.default_map, `UVM_REG_ADDR_WIDTH'h0);
endfunction
