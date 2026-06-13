class master_txn extends uvm_sequence_item;
`uvm_object_utils(master_txn)
rand logic [ADDR_WIDTH-1:0]addr;
rand logic [DATA_WIDTH-1:0]wrdata;
rand logic wrenable;
logic [DATA_WIDTH-1:0]rdata;

function new(string name ="master_txn");
super.new(name);
endfunction

function string convert2string();
 return $sformatf("addr=%0h wrenable=%0b wrdata=%0h rdata=%0h",addr,wrenable,wrdata,rdata);
endfunction

endclass
