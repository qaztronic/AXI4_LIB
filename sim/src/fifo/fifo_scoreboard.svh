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

class fifo_scoreboard #(fifo_cfg_t CFG) extends uvm_subscriber #(fifo_sequence_item #(CFG));
  `uvm_component_param_utils(fifo_scoreboard #(CFG));

  // --------------------------------------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // --------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
  endfunction : build_phase

  // --------------------------------------------------------------------
  mailbox #(fifo_sequence_item #(CFG)) mb = new();
  fifo_sequence_item #(CFG) c_t;
  fifo_sequence_item #(CFG) item;
  int m_matches = 0;
  int m_mismatches = 0;
  int result;

  function void write(fifo_sequence_item #(CFG) t);

    // $cast(c_t, t.clone);

    // if((c_t.command == FIFO_WR) || (c_t.command == FIFO_BOTH))
      // result = mb.try_put(c_t);

    // if((c_t.command == FIFO_RD) || (c_t.command == FIFO_BOTH))
      // result = mb.try_get(item);

    // if(c_t.command == FIFO_NULL)
      // uvm_report_info(get_name(), $sformatf("^^^ %16.t | %m | FIFO_NULL!!! | %s", $time, {20{"-"}}));

    // if(~c_t.compare(item))
    // begin
      // uvm_report_info(get_name(), $sformatf("^^^ %16.t | %m | MISMATCH!!! | %s", $time, {20{"-"}}));
      // uvm_report_info(get_name(), c_t.convert2string);
      // uvm_report_info(get_name(), item.convert2string);
      // m_mismatches++;
    // end
    // else
      // m_matches++;
  endfunction : write

  // --------------------------------------------------------------------
  function void report_phase(uvm_phase phase);
    uvm_report_info(get_name(), $sformatf("Matches   : %0d", m_matches));
    uvm_report_info(get_name(), $sformatf("Mismatches: %0d", m_mismatches));
  endfunction

// --------------------------------------------------------------------
endclass
