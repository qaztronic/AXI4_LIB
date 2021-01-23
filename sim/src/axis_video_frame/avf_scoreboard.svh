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

class avf_scoreboard extends uvm_subscriber #(avf_sequence_item);
  `uvm_component_utils(avf_scoreboard);

  // --------------------------------------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // --------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
  endfunction : build_phase

  // // --------------------------------------------------------------------
  // mailbox #(avf_sequence_item) mb = new();
  // avf_sequence_item c_t;
  // avf_sequence_item item;
  // int m_matches = 0;
  // int m_mismatches = 0;

  // function void write(avf_sequence_item t);

    // $cast(c_t, t.clone);

    // if((c_t.command = FIFO_WR) || (c_t.command = FIFO_BOTH))
      // mb.try_put(c_t);

    // if((c_t.command = FIFO_RD) || (c_t.command = FIFO_BOTH))
      // mb.try_get(item);

    // if(~c_t.compare(item))
    // begin
      // uvm_report_info(get_name(), $sformatf("^^^ %16.t | %m | MISMATCH!!! | %s", $time, {20{"-"}}));
      // uvm_report_info(get_name(), c_t.convert2string);
      // uvm_report_info(get_name(), item.convert2string);
      // m_mismatches++;
    // end
    // else
      // m_matches++;
  // endfunction : write

  // --------------------------------------------------------------------
  //
  function void print_video_frame(ref video_frame_class f_h);
    string s;
    $display("%s", {80{"="}});
    $display(f_h.convert2string());
  endfunction : print_video_frame

  // --------------------------------------------------------------------
  function void write(avf_sequence_item t);
    print_video_frame(t.f_h);
  endfunction : write

  // --------------------------------------------------------------------
  function void report_phase(uvm_phase phase);
    // uvm_report_info(get_name(), $sformatf("Matches   : %0d", m_matches));
    // uvm_report_info(get_name(), $sformatf("Mismatches: %0d", m_mismatches));
  endfunction

// --------------------------------------------------------------------
endclass : avf_scoreboard
