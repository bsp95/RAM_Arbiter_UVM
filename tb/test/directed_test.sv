class directed_test extends base_test;
  `uvm_component_utils(directed_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    virtual_directed_write_seq v_wr;
    virtual_directed_read_seq  v_rd;

    phase.raise_objection(this);

    // phase 1: all masters write known data
    v_wr = virtual_directed_write_seq::type_id::create("v_wr");
    v_wr.start(e.v_seqr);

    // small gap between write and read phases
    #100;

    // phase 2: all masters read back same addresses
    v_rd = virtual_directed_read_seq::type_id::create("v_rd");
    v_rd.start(e.v_seqr);

    phase.drop_objection(this);
  endtask

endclass
