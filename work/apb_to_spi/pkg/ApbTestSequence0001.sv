class ApbTestSequence0001 extends ApbTestSequenceBase;
    `uvm_object_utils(ApbTestSequence0001)

    function new(string name="ApbTestSequence0001");
        super.new(name);
    endfunction

    virtual task body();
        repeat(repeat_count) begin
            `uvm_do_with(req, {rstn == 1; slave_id == 1;})
        end
    endtask
endclass