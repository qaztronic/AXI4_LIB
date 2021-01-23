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

class tb_env extends uvm_env;
  `uvm_component_utils(tb_env);

  // --------------------------------------------------------------------
  tb_dut_config #(AVF_CONFIG) cfg_h;
  // coverage coverage_h;
  avf_scoreboard scoreboard_h;
  avf_master_agent #(AVF_CONFIG) m_agent_h;
  avf_slave_agent #(AVF_CONFIG) s_agent_h;

  // --------------------------------------------------------------------
  function new (string name, uvm_component parent);
    super.new(name,parent);
  endfunction : new

  // --------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    if (!uvm_config_db #(tb_dut_config #(AVF_CONFIG))::get(this, "", "tb_dut_config", cfg_h))
      `uvm_fatal(get_name(), "Couldn't get config object!")

    m_agent_h = avf_master_agent #(AVF_CONFIG)::type_id::create("m_agent_h", this);
    m_agent_h.cfg_h = cfg_h.m_cfg_h;
    m_agent_h.is_active = cfg_h.m_cfg_h.get_is_active();

    s_agent_h = avf_slave_agent #(AVF_CONFIG)::type_id::create("s_agent_h", this);
    s_agent_h.cfg_h = cfg_h.s_cfg_h;
    s_agent_h.is_active = cfg_h.s_cfg_h.get_is_active();

    scoreboard_h = avf_scoreboard::type_id::create("scoreboard_h", this);
  endfunction : build_phase

  // --------------------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    s_agent_h.monitor_h.ap.connect(scoreboard_h.analysis_export);
  endfunction : connect_phase

// --------------------------------------------------------------------
endclass
