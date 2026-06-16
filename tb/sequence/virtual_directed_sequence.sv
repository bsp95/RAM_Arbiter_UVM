
// virtual_directed_write_seq.sv
class virtual_directed_write_seq extends virtual_sequence;
  `uvm_object_utils(virtual_directed_write_seq)

  function new(string name = "virtual_directed_write_seq");
    super.new(name);
  endfunction

  task body();
    directed_write_seq wr[4];

    // configure each master's write sequence
    wr[0] = directed_write_seq::type_id::create("wr0");
    wr[0].base_addr  = 8'h00;       // master 0 owns 0x00-0x03
    wr[0].base_data  = 32'hA0000000;
    wr[0].num_txns   = 4;

    wr[1] = directed_write_seq::type_id::create("wr1");
    wr[1].base_addr  = 8'h10;       // master 1 owns 0x10-0x13
    wr[1].base_data  = 32'hB0000000;
    wr[1].num_txns   = 4;

    wr[2] = directed_write_seq::type_id::create("wr2");
    wr[2].base_addr  = 8'h20;       // master 2 owns 0x20-0x23
    wr[2].base_data  = 32'hC0000000;
    wr[2].num_txns   = 4;

    wr[3] = directed_write_seq::type_id::create("wr3");
    wr[3].base_addr  = 8'h30;       // master 3 owns 0x30-0x33
    wr[3].base_data  = 32'hD0000000;
    wr[3].num_txns   = 4;

    // all 4 masters write simultaneously → contention on bus
    `uvm_info("VSEQ", "=== DIRECTED WRITE PHASE START ===", UVM_LOW)
    fork
      wr[0].start(p_sequencer.m_seqr[0]);
      wr[1].start(p_sequencer.m_seqr[1]);
      wr[2].start(p_sequencer.m_seqr[2]);
      wr[3].start(p_sequencer.m_seqr[3]);
    join
    `uvm_info("VSEQ", "=== DIRECTED WRITE PHASE DONE ===", UVM_LOW)

  endtask
endclass

// virtual_directed_read_seq.sv
class virtual_directed_read_seq extends virtual_sequence;
  `uvm_object_utils(virtual_directed_read_seq)

  function new(string name = "virtual_directed_read_seq");
    super.new(name);
  endfunction

  task body();
    directed_read_seq rd[4];

    // same addr and expected data as write
    rd[0] = directed_read_seq::type_id::create("rd0");
    rd[0].base_addr = 8'h00;
    rd[0].base_data = 32'hA0000000;
    rd[0].num_txns  = 4;

    rd[1] = directed_read_seq::type_id::create("rd1");
    rd[1].base_addr = 8'h10;
    rd[1].base_data = 32'hB0000000;
    rd[1].num_txns  = 4;

    rd[2] = directed_read_seq::type_id::create("rd2");
    rd[2].base_addr = 8'h20;
    rd[2].base_data = 32'hC0000000;
    rd[2].num_txns  = 4;

    rd[3] = directed_read_seq::type_id::create("rd3");
    rd[3].base_addr = 8'h30;
    rd[3].base_data = 32'hD0000000;
    rd[3].num_txns  = 4;

    `uvm_info("VSEQ", "=== DIRECTED READ PHASE START ===", UVM_LOW)
    fork
      rd[0].start(p_sequencer.m_seqr[0]);
      rd[1].start(p_sequencer.m_seqr[1]);
      rd[2].start(p_sequencer.m_seqr[2]);
      rd[3].start(p_sequencer.m_seqr[3]);
    join
    `uvm_info("VSEQ", "=== DIRECTED READ PHASE DONE ===", UVM_LOW)

  endtask
endclass
