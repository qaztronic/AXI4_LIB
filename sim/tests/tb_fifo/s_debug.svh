//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2018 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

class s_debug #(fifo_cfg_t CFG) extends uvm_sequence #(fifo_sequence_item #(CFG));
  `uvm_object_param_utils(s_debug #(CFG))

  // --------------------------------------------------------------------
  function new(string name = "s_debug");
    super.new(name);
  endfunction

  // --------------------------------------------------------------------
  task body();
    logic wr_full = 0;
    logic rd_empty = 1;
    int count;
    fifo_sequence_item #(CFG) item;
    fifo_sequence_item #(CFG) c_item;
    item = fifo_sequence_item #(CFG)::type_id::create("item");

    repeat(64)
    begin
      $cast(c_item, item.clone);
      start_item(c_item);
      assert(c_item.randomize());
      if(wr_full)
        c_item.command = FIFO_RD;
      else if(rd_empty)
        c_item.command = FIFO_WR;
      finish_item(c_item);
      wr_full = c_item.wr_full;
      rd_empty = c_item.rd_empty;
    end

    count = c_item.count;
    repeat(count)
    begin
      $cast(c_item, item.clone);
      start_item(c_item);
      assert(c_item.randomize());
      c_item.command = FIFO_RD;
      finish_item(c_item);
    end
  endtask: body

// --------------------------------------------------------------------
endclass
