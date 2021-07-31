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
  tb_dut_config cfg_h;
  // coverage coverage_h;
  fifo_scoreboard #(FIFO_CFG) scoreboard_h;
  fifo_agent #(FIFO_CFG) agent_h;

  // --------------------------------------------------------------------
  function new (string name, uvm_component parent);
    super.new(name,parent);
  endfunction : new

  // --------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(tb_dut_config)::get(this, "", "tb_dut_config", cfg_h))
      `uvm_fatal(get_name(), "Couldn't get config object!")

    agent_h = fifo_agent #(FIFO_CFG)::type_id::create("agent_h", this);
    agent_h.vif = cfg_h.vif;
    scoreboard_h = fifo_scoreboard #(FIFO_CFG)::type_id::create("scoreboard_h", this);
  endfunction : build_phase

  // --------------------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    agent_h.monitor_h.ap.connect(scoreboard_h.analysis_export);
  endfunction : connect_phase

// --------------------------------------------------------------------
endclass
