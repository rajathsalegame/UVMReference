//A few flavours of apb sequences
`ifndef APB_SEQUENCES_SV
`define APB_SEQUENCES_SV
//------------------------
//Base APB sequence derived from uvm_sequence and parameterized with sequence item of type apb_rw
//------------------------
class apb_base_seq extends uvm_sequence#(apb_rw);
  `uvm_object_utils(apb_base_seq)
  function new(string name ="");
    super.new(name);
  endfunction
  //Main Body method that gets executed once sequence is started
  task body();
     apb_rw rw_trans;
     // NEW: RW TEST
     // This sequence creates 5 pairs of transactions.
     // Each pair consists of a write transaction to a random address.
     // Then, a read transaction is issued to the same address.
     repeat(5) begin
       // Create a write transaction
       rw_trans = apb_rw::type_id::create(.name("rw_trans"), .contxt(get_full_name()));
       start_item(rw_trans);
       assert(rw_trans.randomize() with { apb_cmd == apb_rw::WRITE; });
       finish_item(rw_trans);
       
       // Save the address used for the write transaction
       bit [31:0] used_address = rw_trans.addr;
       
       // Create a read transaction to the same address
       rw_trans = apb_rw::type_id::create(.name("rw_trans"), .contxt(get_full_name()));
       start_item(rw_trans);
       assert(rw_trans.randomize() with { apb_cmd == apb_rw::READ; addr == used_address; });
       finish_item(rw_trans);
     end
  endtask
  
endclass
`endif