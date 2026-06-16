class virtual_sequence extends uvm_sequence;
  `uvm_object_utils(virtual_sequence)
  `uvm_declare_p_sequencer(virtual_sequencer)
  
  function new(string name = "virtual_sequence");
    super.new(name);
  endfunction

endclass
