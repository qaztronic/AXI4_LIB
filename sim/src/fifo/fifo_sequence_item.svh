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

class fifo_sequence_item #(fifo_cfg_t CFG) extends uvm_sequence_item;
  `uvm_object_param_utils(fifo_sequence_item #(CFG))

  // // --------------------------------------------------------------------
  // localparam UB = $clog2(D);

  // --------------------------------------------------------------------
  rand int delay;
  rand fifo_command_t command;
  rand logic [CFG.W-1:0] wr_data;

  // --------------------------------------------------------------------
  logic         wr_full;
  logic         rd_empty;
  logic [CFG.W-1:0] rd_data;
  logic [CFG.UB:0]  count;

  // --------------------------------------------------------------------
  constraint delay_c
  {
    delay dist {0 := 90, [1:2] := 7, [3:7] := 3};
  }

  // --------------------------------------------------------------------
  function new(string name = "");
    super.new(name);
  endfunction : new

  // --------------------------------------------------------------------
  function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    fifo_sequence_item #(CFG) tested;
    bit same;

    if (rhs==null)
      `uvm_fatal(get_type_name(), "| %m | comparison to a null pointer");

    if (!$cast(tested,rhs))
      same = 0;
    else
      same  = super.do_compare(rhs, comparer);

    return same;
  endfunction : do_compare

  // --------------------------------------------------------------------
  function void do_copy(uvm_object rhs);
    fifo_sequence_item #(CFG) item;
    assert(rhs != null) else
      `uvm_fatal(get_type_name(), "| %m | copy null transaction");
    super.do_copy(rhs);
    assert($cast(item,rhs)) else
      `uvm_fatal(get_type_name(), "| %m | failed cast");
    delay     = item.delay;
    command   = item.command;
    wr_full   = item.wr_full;
    rd_empty  = item.rd_empty;
    wr_data   = item.wr_data;
    rd_data   = item.rd_data;
    count     = item.count;
  endfunction : do_copy

  // --------------------------------------------------------------------
  function string convert2string();
    string s0, s1, s2, s3;
    s0 = $sformatf( "| %m | wr | rd | full | empty |\n");
    s1 = $sformatf( "| %m | %1h  | %1h  | %1h    | %1h     |\n"
                  , (command == FIFO_WR) || (command == FIFO_BOTH)
                  , (command == FIFO_RD) || (command == FIFO_BOTH)
                  , wr_full
                  , rd_empty
                  );
    s2 = $sformatf("| %m | wr_data: %h\n" , wr_data);
    s3 = $sformatf("| %m | rd_data: %h\n" , rd_data);

    if(command == FIFO_NULL)
      return {s1, s0};
    else if(command == FIFO_BOTH)
      return {s3, s2, s1, s0};
    else if(command == FIFO_WR)
      return {s2, s1, s0};
    else if(command == FIFO_RD)
      return {s3, s1, s0};
  endfunction : convert2string

// --------------------------------------------------------------------
endclass
