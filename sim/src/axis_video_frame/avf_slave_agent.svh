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

class avf_slave_agent #(axis_cfg_t CONFIG)
  extends uvm_agent;
   `uvm_component_param_utils(avf_slave_agent #(CONFIG))

  // --------------------------------------------------------------------
  avf_config #(CONFIG) cfg_h;
  avf_slave_sequencer sequencer_h;
  avf_slave_driver #(CONFIG) driver_h;
  avf_monitor #(CONFIG) monitor_h;

  // --------------------------------------------------------------------
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(is_active == UVM_ACTIVE)
    begin
      driver_h = avf_slave_driver #(CONFIG)::type_id::create("driver_h", this);
      sequencer_h = avf_slave_sequencer::type_id::create("sequencer_h", this);
    end
    monitor_h = avf_monitor #(CONFIG)::type_id::create("monitor_h", this);
  endfunction

  // --------------------------------------------------------------------
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(is_active == UVM_ACTIVE)
    begin
      driver_h.vif = cfg_h.vif;
      driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
      monitor_h.req.connect(sequencer_h.m_request_export);
    end
    monitor_h.vif = cfg_h.vif;
    monitor_h.c_h = cfg_h.c_h;
  endfunction

  // --------------------------------------------------------------------
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

// --------------------------------------------------------------------
endclass
