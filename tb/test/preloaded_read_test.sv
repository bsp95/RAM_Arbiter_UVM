class preloaded_read_test extends base_test;
  `uvm_component_utils(preloaded_read_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    virtual_directed_read_seq v_rd;

    phase.raise_objection(this);

    // no write phase needed — RAM already has data
    `uvm_info("TEST", "RAM preloaded — starting read verification", UVM_LOW)

    v_rd = virtual_directed_read_seq::type_id::create("v_rd");
    v_rd.start(e.v_seqr);

    phase.drop_objection(this);
  endtask

endclass
