class virtual_sequencer extends uvm_sequencer;

  `uvm_component_utils(virtual_sequencer)

   master_sequencer m_seqr[NUM_MASTERS];
   
   function new(string name,uvm_component parent);
      super.new(name,parent);
   endfunction
endclass
