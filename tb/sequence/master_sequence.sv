class master_base_seq extends uvm_sequence#(master_txn);
`uvm_object_utils(master_base_seq)

int unsigned num_txns = 10;   // override this from test if needed

function new(string name = "master_base_seq");
  super.new(name);
endfunction

endclass

class master_write_seq extends master_base_seq;
 `uvm_object_utils(master_write_seq)

function new(string name = "master_write_seq");
  super.new(name);
endfunction

task body();
master_txn txn;
repeat(num_txns) begin
 txn = master_txn::type_id::create("txn");
 start_item(txn);
assert( txn.randomize() with {wrenable == 1'b1;});
 finish_item(txn);
end
endtask
endclass

class master_read_seq extends master_base_seq;
 `uvm_object_utils(master_read_seq)

function new(string name = "master_read_seq");
  super.new(name);
endfunction
task body();
master_txn txn;
repeat(num_txns) begin
 txn = master_txn::type_id::create("txn");
 start_item(txn);
assert( txn.randomize() with {wrenable == 1'b0;});
 finish_item(txn);
end
endtask
endclass
