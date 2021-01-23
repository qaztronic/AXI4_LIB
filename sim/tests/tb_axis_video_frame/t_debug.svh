// --------------------------------------------------------------------
// Copyright 2020 qaztronic
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Licensed under the Solderpad Hardware License v 2.1 (the “License”);
// you may not use this file except in compliance with the License, or,
// at your option, the Apache License version 2.0. You may obtain a copy
// of the License at
//
// https://solderpad.org/licenses/SHL-2.1/
//
// Unless required by applicable law or agreed to in writing, any work
// distributed under the License is distributed on an “AS IS” BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
// implied. See the License for the specific language governing
// permissions and limitations under the License.
// --------------------------------------------------------------------

class t_debug extends t_top_base;
   `uvm_component_utils(t_debug)

  // --------------------------------------------------------------------
  function new(string name = "t_debug", uvm_component parent);
    super.new(name, parent);
  endfunction

  // --------------------------------------------------------------------
  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_phase run_phase = uvm_run_phase::get();
    run_phase.phase_done.set_drain_time(this, 100ns);
  endfunction

  // --------------------------------------------------------------------
  function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    $display("^^^ %16.t | %m | Test Done!!!", $time);
    $stop;
  endfunction : final_phase

  // --------------------------------------------------------------------
  virtual task run_phase(uvm_phase phase);
    s_debug seq = s_debug::type_id::create("seq");
    s_avf_slave_base s_seq = s_avf_slave_base::type_id::create("s_seq");
    s_seq.sequencer_h = env_h.s_agent_h.sequencer_h;
    fork
      s_seq.start(env_h.s_agent_h.sequencer_h);
    join_none
    seq.init(env_h.cfg_h.m_cfg_h.c_h);
    phase.raise_objection(this);
    seq.start(env_h.m_agent_h.sequencer_h);
    phase.drop_objection(this);
  endtask : run_phase

// --------------------------------------------------------------------
endclass : t_debug
