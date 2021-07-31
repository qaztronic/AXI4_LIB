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

class fifo_monitor #(fifo_cfg_t CFG) extends uvm_component;
  `uvm_component_param_utils(fifo_monitor #(CFG));

  virtual fifo_if #(.W(CFG.W), .D(CFG.D)) vif;
  uvm_analysis_port #(fifo_sequence_item #(CFG)) ap;

  // --------------------------------------------------------------------
  function new (string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // --------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    ap = new("ap", this);
  endfunction : build_phase

  // --------------------------------------------------------------------
  task run_phase(uvm_phase phase);
    fifo_sequence_item #(CFG) item;
    fifo_sequence_item #(CFG) c_item;
    item = fifo_sequence_item #(CFG)::type_id::create("item");

    forever @(vif.cb iff vif.cb.reset === 0)
      if(vif.cb.wr_en || vif.cb.rd_en)
      begin
        $cast(c_item, item.clone);
        c_item.wr_full = vif.cb.wr_full;
        c_item.wr_data = vif.cb.wr_data;
        c_item.rd_empty = vif.cb.rd_empty;
        c_item.rd_data = vif.cb.rd_data;
        c_item.count = vif.cb.count;

        if(vif.cb.wr_en && vif.cb.rd_en)
          c_item.command = FIFO_BOTH;
        else if(vif.cb.wr_en)
          c_item.command = FIFO_WR;
        else if(vif.cb.rd_en)
          c_item.command = FIFO_RD;

        ap.write(c_item);
      end
  endtask : run_phase

// --------------------------------------------------------------------
endclass
