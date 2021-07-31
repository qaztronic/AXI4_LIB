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

class fifo_driver #(fifo_cfg_t CFG) extends uvm_driver #(fifo_sequence_item #(CFG));
   `uvm_component_param_utils(fifo_driver #(CFG))

  // --------------------------------------------------------------------
  virtual fifo_if #(.W(CFG.W), .D(CFG.D)) vif;

  //--------------------------------------------------------------------
  function void set_default;
    vif.cb.wr_en <= 0;
    vif.cb.rd_en <= 0;
    vif.cb.wr_data <= 'x;
  endfunction: set_default

  //--------------------------------------------------------------------
  virtual task run_phase(uvm_phase phase);
    fifo_sequence_item #(CFG) item;
    super.run_phase(phase);

    set_default();

    forever
    begin
      wait(~vif.cb.reset);
      vif.zero_cycle_delay();
      seq_item_port.get_next_item(item);

      repeat(item.delay) @(vif.cb);

      if((item.command == FIFO_WR) || (item.command == FIFO_BOTH))
      begin
        if(vif.wr_full)
          `uvm_error(get_name(), "writing to full FIFO!")
        vif.cb.wr_data <= item.wr_data;
        vif.cb.wr_en <= 1;
      end

      if((item.command == FIFO_RD) || (item.command == FIFO_BOTH))
      begin
        if(vif.rd_empty)
          `uvm_error(get_name(), "reading empty FIFO!")
        item.rd_data = vif.cb.rd_data;
        vif.cb.rd_en <= 1;
      end

      @(vif.cb);
      item.wr_full = vif.wr_full;
      item.rd_empty = vif.rd_empty;
      item.count = vif.count;
      set_default();
      seq_item_port.item_done();
    end
  endtask : run_phase

  //--------------------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

// --------------------------------------------------------------------
endclass
