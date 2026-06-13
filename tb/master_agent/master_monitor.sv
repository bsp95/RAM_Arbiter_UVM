class master_monitor extends uvm_monitor;
`uvm_component_utils(master_monitor)
virtual master_if vif;
uvm_analysis_port #(master_txn)ap;

function new(string name,uvm_component parent);
 super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  ap = new("ap",this);
  if(!uvm_config_db#(virtual master_if)::get(this,"","vif",vif))
   `uvm_fatal("NO_VIF","Virtual interface not found")
endfunction

task run_phase(uvm_phase phase);
@(negedge vif.rst);
forever begin
  master_txn txn;
@(posedge vif.clk);
#1;
if(vif.req && vif.grant) begin
txn = master_txn::type_id::create("txn");
txn.addr	= vif.addr;
txn.wrenable	= vif.wrenable;
txn.wrdata	= vif.wrdata;

if(!vif.wrenable) begin
  @(posedge vif.clk);
  #1;
  txn.rdata = vif.rdata;
end
`uvm_info("MASTER_MON", $sformatf("Observed txn: %s", txn.convert2string()), UVM_MEDIUM)
ap.write(txn);
end
end
endtask
endclass
