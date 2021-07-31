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

class tb_dut_config;

  virtual fifo_if #(.W(W), .D(D)) vif;
  protected uvm_active_passive_enum is_active; // UVM_ACTIVE or UVM_PASSIVE

  // --------------------------------------------------------------------
  function new
  (  virtual fifo_if #(.W(W), .D(D)) vif
  ,  uvm_active_passive_enum is_active = UVM_ACTIVE
  );
    this.vif = vif;
    this.is_active = is_active;
  endfunction : new

  // --------------------------------------------------------------------
  function uvm_active_passive_enum get_is_active();
    return is_active;
  endfunction : get_is_active

// --------------------------------------------------------------------
endclass
