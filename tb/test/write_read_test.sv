class write_read_test extends base_test;
  `uvm_component_utils(write_read_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    virtual_write_seq v_wr;
    virtual_read_seq  v_rd;

    phase.raise_objection(this);

    // all 4 masters write
    v_wr = virtual_write_seq::type_id::create("v_wr");
    v_wr.start(e.v_seqr);

    // all 4 masters read
    v_rd = virtual_read_seq::type_id::create("v_rd");
    v_rd.start(e.v_seqr);

    phase.drop_objection(this);
  endtask

endclass
