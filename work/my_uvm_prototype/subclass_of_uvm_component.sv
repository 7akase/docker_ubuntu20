class aaa extends uvm_component;
    string str_in, str_rsp;
    `uvm_component_utils_begin(aaa)
        `uvm_field_string(str_in, UVM_DEFAULT);
        `uvm_field_string(str_rsp, UVM_DEFAULT);
    `uvm_component_utils_end

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern function void extract_phase(uvm_phase phase);
endclass

function aaa::build_phase(uvm_phase phase);
    super.build_phase(phase);
    // add here.
endfunction

function aaa::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // add here.
endfunction

task aaa::run_phase(uvm_phase phase);
    super.build_phase(phase);
    // add here.
endfunction

task aaa::extract_phase(uvm_phase phase);
    super.build_phase(phase);
    // add here
    $display("input:    %s\n", str_in);
    $display("response: %s\n", str_rsp);.
endfunction