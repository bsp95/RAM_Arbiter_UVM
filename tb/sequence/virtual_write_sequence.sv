class virtual_write_seq extends virtual_sequence;
  `uvm_object_utils(virtual_write_seq)
  
  function new(string name = "virtual_write_seq");
    super.new(name);
  endfunction

  task body();
    master_write_seq wr_seq[NUM_MASTERS];

    foreach(wr_seq[i])
      wr_seq[i] = master_write_seq::type_id::create(
                    $sformatf("wr_seq_%0d", i));

    // all 4 masters write simultaneously
    fork
      wr_seq[0].start(p_sequencer.m_seqr[0]);
      wr_seq[1].start(p_sequencer.m_seqr[1]);
      wr_seq[2].start(p_sequencer.m_seqr[2]);
      wr_seq[3].start(p_sequencer.m_seqr[3]);
    join

  endtask

endclass
