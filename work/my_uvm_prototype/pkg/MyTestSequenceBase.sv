class MyTestSequenceBase extends uvm_sequence#(MyItem);
    rand int num_data;
    uvm_phase phase;

    `uvm_object_utils_begin(MyTestSequenceBase)
        `uvm_field_int(num_data, UVM_DEFAULT)
    `uvm_object_utils_end

    constraint C_NUM_DATA { num_data inside { [16:32] }; }

    function new(string name="");
        super.new(name);
    endfunction

    task pre_body();
        phase = get_starting_phase();
        if(phase != null)
            phase.raise_objection(this, "MyTestSequenceBase");;
    endtask

    task post_body();
        if(phase != null)
            phase.drop_objection(this, "MyTestSequenceBase");
    endtask
endclass

