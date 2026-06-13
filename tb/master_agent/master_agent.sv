class master_agent extends uvm_agent;
`uvm_component_utils(master_agent)

master_driver drv;
master_monitor mon;
master_sequencer sqr;

uvm_analysis_port #(master_txn) ap;

function new(string name,uvm_component parent);
  super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  ap = new("ap",this);
  mon = master_monitor::type_id::create("mon",this);
  if(get_is_active() == UVM_ACTIVE) begin
    drv = master_driver::type_id::create("drv",this);
    sqr = master_sequencer::type_id::create("sqr",this);
  end
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  mon.ap.connect(ap);
  if(get_is_active() == UVM_ACTIVE)
    drv.seq_item_port.connect(sqr.seq_item_export);
endfunction

endclass
