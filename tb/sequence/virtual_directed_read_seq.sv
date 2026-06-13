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
    rd[0].master_id = 0;
    rd[0].base_addr = 8'h00;
    rd[0].base_data = 32'hA0000000;
    rd[0].num_txns  = 4;

    rd[1] = directed_read_seq::type_id::create("rd1");
    rd[1].master_id = 1;
    rd[1].base_addr = 8'h10;
    rd[1].base_data = 32'hB0000000;
    rd[1].num_txns  = 4;

    rd[2] = directed_read_seq::type_id::create("rd2");
    rd[2].master_id = 2;
    rd[2].base_addr = 8'h20;
    rd[2].base_data = 32'hC0000000;
    rd[2].num_txns  = 4;

    rd[3] = directed_read_seq::type_id::create("rd3");
    rd[3].master_id = 3;
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
