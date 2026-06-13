class env extends uvm_env;

`uvm_component_utils(env)

master_agent m_agents[NUM_MASTERS];
virtual_sequencer v_seqr;

function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  foreach(m_agents[i])
    m_agents[i] = master_agent::type_id::create($sformatf("m_agent_%0d",i),this);
    v_seqr = virtual_sequencer::type_id::create("v_seqr",this);
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  foreach(m_agents[i])
    v_seqr.m_seqr[i] = m_agents[i].sqr;
endfunction

endclass
