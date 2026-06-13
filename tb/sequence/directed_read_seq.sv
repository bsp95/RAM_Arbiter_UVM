class directed_read_seq extends uvm_sequence #(master_txn);
  `uvm_object_utils(directed_read_seq)

  int unsigned master_id  = 0;
  int unsigned num_txns   = 4;
  logic [7:0]  base_addr  = 8'h00;
  logic [31:0] base_data  = 32'hA0000000;  // expected data

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

      // check rdata vs expected
      if(txn.rdata === (base_data + i))
        `uvm_info("DIR_RD",
          $sformatf("Master%0d READ PASS addr=0x%0h expected=0x%0h actual=0x%0h",
          master_id, txn.addr, base_data+i, txn.rdata), UVM_LOW)
      else
        `uvm_error("DIR_RD",
          $sformatf("Master%0d READ FAIL addr=0x%0h expected=0x%0h actual=0x%0h",
          master_id, txn.addr, base_data+i, txn.rdata))
    end
  endtask

endclass
