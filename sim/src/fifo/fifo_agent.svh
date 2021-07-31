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

class fifo_agent #(fifo_cfg_t CFG) extends uvm_agent;
   `uvm_component_param_utils(fifo_agent #(CFG))

  // --------------------------------------------------------------------
  virtual fifo_if #(.W(CFG.W), .D(CFG.D)) vif;
  fifo_driver #(CFG) driver_h;
  // fifo_sequencer sequencer_h;
  fifo_sequencer #(CFG) sequencer_h;
  fifo_monitor #(CFG) monitor_h;

  // --------------------------------------------------------------------
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver_h = fifo_driver #(CFG)::type_id::create("driver_h", this);
    monitor_h = fifo_monitor #(CFG)::type_id::create("monitor_h", this);
    // sequencer_h = fifo_sequencer::type_id::create("sequencer_h", this);
    // sequencer_h = uvm_sequencer #(fifo_sequence_item #(CFG))::type_id::create("sequencer_h", this);
    sequencer_h = fifo_sequencer #(CFG)::type_id::create("sequencer_h", this);

  endfunction

  // --------------------------------------------------------------------
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    driver_h.vif = vif;
    monitor_h.vif = vif;

    driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
  endfunction

  // --------------------------------------------------------------------
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

// --------------------------------------------------------------------
endclass
