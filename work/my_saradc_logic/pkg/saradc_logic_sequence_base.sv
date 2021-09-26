class saradc_logic_sequence_base extends uvm_sequence#(saradc_logic_item);
rand int num_data;
uvm_phase phase;

`uvm_object_utils_begin(saradc_logic_sequence_base)
    `uvm_field_int(num_data, UVM_DEFAULT)
`uvm_object_utils_end

constraint C_NUM_DATA { num_data inside { [16:32] }; }

function new(string name="");
    super.new(name);
endfunction

extern task pre_body();
extern task post_body();

endclass

task saradc_logic_sequence_base::pre_body();
    phase = get_starting_phase();
    if(phase != null)
        phase.raise_objection(this, "SARADC_LOGIC_SEQUENCE_BASE");;
endtask

task saradc_logic_sequence_base::post_body();
    if(phase != null)
        phase.drop_objection(this, "SARADC_LOGIC_SEQUENCE_BASE");
endtask