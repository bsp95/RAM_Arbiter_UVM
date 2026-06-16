class directed_write_seq extends master_base_seq;
  `uvm_object_utils(directed_write_seq)

  function new(string name = "directed_write_seq");
    super.new(name);
  endfunction

  task body();
    master_txn txn;

    for(int i = 0; i < num_txns; i++) begin
      txn = master_txn::type_id::create("txn");
      start_item(txn);

      // fixed values — no randomization
      txn.addr     = base_addr + i;         // e.g. 0x00,0x01,0x02,0x03
      txn.wrenable = 1'b1;                  // always write
      txn.wrdata   = base_data + i;         // e.g. 0xA0000000,0xA0000001...

      finish_item(txn);

    end
  endtask

endclass
class directed_read_seq extends master_base_seq;
  `uvm_object_utils(directed_read_seq)


  function new(string name = "directed_read_seq");
    super.new(name);
  endfunction

  task body();
    master_txn txn;

    for(int i = 0; i < num_txns; i++) begin
      txn = master_txn::type_id::create("txn");
      start_item(txn);

      txn.addr     = base_addr + i;   // same addr as write
      txn.wrenable = 1'b0;            // read
      txn.wrdata   = '0;

      finish_item(txn);

    end
  endtask

endclass
