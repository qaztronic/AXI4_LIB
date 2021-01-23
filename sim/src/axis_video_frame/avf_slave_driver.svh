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

class avf_slave_driver #(axis_cfg_t CONFIG)
  extends uvm_driver #(avf_sequence_item);
   `uvm_component_param_utils(avf_slave_driver #(CONFIG))

  // --------------------------------------------------------------------
  virtual axis_if #(CONFIG) vif;

  //--------------------------------------------------------------------
  function void set_default;
    vif.cb_s.tready <= 0;
  endfunction: set_default

  //--------------------------------------------------------------------
  virtual task run_phase(uvm_phase phase);
    avf_sequence_item item;
    super.run_phase(phase);

    set_default();

    forever
    begin
      wait(vif.aresetn);
      seq_item_port.get_next_item(item);
      vif.zero_cycle_delay();

      repeat(item.delay_h.get(item.slave_delay))
        @(vif.cb_m);

      vif.cb_s.tready <= 1;

      repeat(item.delay_h.get(item.slave_delay))
        @(vif.cb_m);

      vif.cb_s.tready <= 0;
      seq_item_port.item_done();
    end
  endtask : run_phase

  //--------------------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

// --------------------------------------------------------------------
endclass
