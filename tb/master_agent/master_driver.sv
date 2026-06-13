class master_driver extends uvm_driver #(master_txn);
`uvm_component_utils(master_driver)

virtual master_if vif;
function new(string name,uvm_component parent);
 super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(virtual master_if)::get(this,"","vif",vif))
     `uvm_fatal("NO_VIF", "Virtual interface not found")
endfunction

task run_phase(uvm_phase phase);
  vif.req 	<= 1'b0;
  vif.addr	<= '0;
  vif.wrdata	<= '0;
  vif.wrenable	<= 1'b0;

@(negedge vif.rst);
@(posedge vif.clk);

forever begin
  master_txn txn;
  seq_item_port.get_next_item(txn);
  drive_txn(txn);
  seq_item_port.item_done();
end

endtask

task drive_txn(master_txn txn);
 @(posedge vif.clk);
#1;
vif.req <= 1'b1;
@(posedge vif.clk iff vif.grant == 1'b1);
#1;
vif.addr	<= txn.addr;
vif.wrenable	<= txn.wrenable;
vif.wrdata	<= txn.wrdata;

@(posedge vif.clk);
if(!txn.wrenable)
txn.rdata = vif.rdata;
`uvm_info("MASTER_DRV", $sformatf("Driving txn: %s", txn.convert2string()), UVM_MEDIUM)
#1;
vif.req		<= 1'b0;
vif.addr	<= '0;
vif.wrdata	<= '0;
vif.wrenable 	<= 1'b0;
endtask

endclass
