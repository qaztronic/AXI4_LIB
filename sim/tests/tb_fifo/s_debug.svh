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

class s_debug #(fifo_cfg_t CFG) extends uvm_sequence #(fifo_sequence_item #(CFG));
  `uvm_object_param_utils(s_debug #(CFG))

  // --------------------------------------------------------------------
  function new(string name = "s_debug");
    super.new(name);
  endfunction

  // --------------------------------------------------------------------
  task body();
    logic wr_full = 0;
    logic rd_empty = 1;
    int count;
    fifo_sequence_item #(CFG) item;
    fifo_sequence_item #(CFG) c_item;
    item = fifo_sequence_item #(CFG)::type_id::create("item");

    repeat(64)
    begin
      $cast(c_item, item.clone);
      start_item(c_item);
      assert(c_item.randomize());
      if(wr_full)
        c_item.command = FIFO_RD;
      else if(rd_empty)
        c_item.command = FIFO_WR;
      finish_item(c_item);
      uvm_report_info(get_name(), c_item.convert2string());
      wr_full  = c_item.wr_full;
      rd_empty = c_item.rd_empty;
    end

    count = c_item.count;
    repeat(count)
    begin
      $cast(c_item, item.clone);
      start_item(c_item);
      assert(c_item.randomize());
      c_item.command = FIFO_RD;
      finish_item(c_item);
    end
  endtask: body

// --------------------------------------------------------------------
endclass
