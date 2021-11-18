class ApbTestSequenceBase extends uvm_sequence#(ApbItem);
    rand int repeat_count;
    uvm_phase phase;

    `uvm_object_utils_begin(ApbTestSequenceBase)
        `uvm_field_int(repeat_count, UVM_DEFAULT)
    `uvm_object_utils_end

    constraint C_REPEAT_COUNT { repeat_count inside { [1:8] }; }

    function new(string name="");
        super.new(name);
    endfunction

    task pre_body();
        phase = get_starting_phase();
        if(phase != null)
            phase.raise_objection(this, "ApbTestSequenceBase");

        this.randomize();

        `CBLUE
        `uvm_info(get_type_name(), $sformatf("repeat_count is %0d", repeat_count), UVM_DEBUG);
        `CEND
    endtask

    task post_body();
        if(phase != null)
            phase.drop_objection(this, "ApbTestSequenceBase");
    endtask
endclass

