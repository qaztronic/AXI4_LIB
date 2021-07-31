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

class t_debug extends t_top_base;
   `uvm_component_utils(t_debug)

  // --------------------------------------------------------------------
  tb_dut_config cfg_h;

  // --------------------------------------------------------------------
  function new(string name = "t_debug", uvm_component parent);
    super.new(name, parent);
    if (!uvm_config_db#(tb_dut_config)::get(this, "", "tb_dut_config", cfg_h))
      `uvm_fatal(get_name(), "Couldn't get config object!")
  endfunction

  // --------------------------------------------------------------------
  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_phase run_phase = uvm_run_phase::get();
    run_phase.phase_done.set_drain_time(this, 1000ns);
  endfunction

  // --------------------------------------------------------------------
  function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    $display("^^^ %16.t | %m | Test Done!!!", $time);
    $stop;
  endfunction : final_phase

  // --------------------------------------------------------------------
  virtual task run_phase(uvm_phase phase);
    s_debug #(FIFO_CFG) seq = s_debug #(FIFO_CFG)::type_id::create("seq");
    phase.raise_objection(this);
    seq.start(env_h.agent_h.sequencer_h);
    phase.drop_objection(this);
  endtask : run_phase

// --------------------------------------------------------------------
endclass
