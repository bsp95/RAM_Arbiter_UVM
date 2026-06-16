class master_base_seq extends uvm_sequence#(master_txn);
`uvm_object_utils(master_base_seq)

int unsigned num_txns = 10;   // override this from test if needed
int base_addr;
int base_data;

function new(string name = "master_base_seq");
  super.new(name);
endfunction

endclass
