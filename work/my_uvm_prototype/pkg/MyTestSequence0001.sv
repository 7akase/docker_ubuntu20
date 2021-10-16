class MyTestSequence0001 extends MyTestSequenceBase;
    `uvm_object_utils(MyTestSequence0001)

    function new(string name="MyTestSequence0001");
        super.new(name);
    endfunction

    virtual task body();
        repeat(num_data)
            `uvm_do_with(req, {rstn == 1;})
    endtask
endclass