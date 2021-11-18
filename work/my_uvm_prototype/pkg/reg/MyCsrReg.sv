class MyCsrReg extends uvm_reg;
    rand uvm_reg_field ADC_EN;
    rand uvm_reg_field CP_EN;

    `uvm_object_utils(MyCsrReg);


    function new(string name="MyCsrReg");
        super.new(name, 32, build_coverage(NO_COVERAGE));
    endfunction

    extern void function build();

    extern task pre_body(); 
endclass

function void MyCtrlReg::build();
    this.ADC_EN = uvm_reg_field::type_id::create("ADC_EN", , get_full_name());
    this.CP_EN  = uvm_reg_field::type_id::create("CP_EN" , , get_full_name());

    // configure(parent, size, lsb_pos, access, volatile, reset, has_reset, is_rand, individually_accessibe);
    //                    par- si lsb acc vola res has is_  ind
    //                    ent  ze pos ess tile  et rst rand acc
    this.ADC_EN.configure(this, 1, 0, "RW", 0, 1'h0, 1,   0, 0)
    this.CP_EN.configure (this, 1, 0, "RW", 0, 1'h0, 1,   0, 0)
endtask
