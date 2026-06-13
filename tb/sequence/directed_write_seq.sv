class directed_write_seq extends uvm_sequence #(master_txn);
  `uvm_object_utils(directed_write_seq)

  // set these before starting
  int unsigned master_id   = 0;
  int unsigned num_txns    = 4;
  logic [7:0]  base_addr   = 8'h00;
  logic [31:0] base_data   = 32'hA0000000;

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

      `uvm_info("DIR_WR",
        $sformatf("Master%0d WRITE addr=0x%0h data=0x%0h",
        master_id, txn.addr, txn.wrdata), UVM_LOW)
    end
  endtask

endclass
