class saradc_logic_sequence_test1 extends saradc_logic_sequence_base;
`uvm_object_utils(saradc_logic_sequence_test1)

function new(string name="saradc_logic_sequence_test1");
    super.new(name);
endfunction

extern virtual task body();
endclass

task saradc_logic_sequence_test1::body();
    repeat(num_data)
        `uvm_do_with(req, {rst == 0;})
endtask