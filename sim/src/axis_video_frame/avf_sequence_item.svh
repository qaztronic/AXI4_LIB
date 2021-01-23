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

// --------------------------------------------------------------------
typedef enum {AVF_REQUEST, AVF_TRANSACTION} avf_sequence_item_t;

// --------------------------------------------------------------------
class avf_sequence_item
  extends uvm_sequence_item;
  `uvm_object_utils(avf_sequence_item)

  // --------------------------------------------------------------------
  avf_sequence_item_t kind = AVF_TRANSACTION;
  video_frame_class f_h;
  mailbox #(video_frame_class) frame_buffer;
  random_delay delay_h;
  random_delay_type_e sof_delay = REGULAR;
  random_delay_type_e eol_delay = REGULAR;
  random_delay_type_e eof_delay = REGULAR;
  random_delay_type_e pixel_delay = SPORADIC;
  random_delay_type_e slave_delay = REGULAR;

  // --------------------------------------------------------------------
  function int unsigned get_delay(bit eol, bit eof);
    if(eof)
      return(delay_h.get(eof_delay));
    else if(eol)
      return(delay_h.get(eol_delay));
    else
      return(delay_h.get(pixel_delay));
  endfunction : get_delay

  // --------------------------------------------------------------------
  function new(string name = "");
    super.new(name);
    delay_h = new();
  endfunction : new

  // // --------------------------------------------------------------------
  // function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    // avf_sequence_item tested;
    // bit same;

    // if (rhs==null)
      // `uvm_fatal(get_type_name(), "| %m | comparison to a null pointer");

    // if (!$cast(tested,rhs))
      // same = 0;
    // else
      // same  = super.do_compare(rhs, comparer);

    // return same;
  // endfunction : do_compare

  // // --------------------------------------------------------------------
  // function void do_copy(uvm_object rhs);
    // avf_sequence_item item;
    // assert(rhs != null) else
      // `uvm_fatal(get_type_name(), "| %m | copy null transaction");
    // super.do_copy(rhs);
    // assert($cast(item,rhs)) else
      // `uvm_fatal(get_type_name(), "| %m | failed cast");
    // delay     = item.delay;
    // command   = item.command;
    // wr_full   = item.wr_full;
    // rd_empty  = item.rd_empty;
    // wr_data   = item.wr_data;
    // rd_data   = item.rd_data;
    // count     = item.count;
  // endfunction : do_copy

  // // --------------------------------------------------------------------
  // function string convert2string();
    // string s0, s1, s2, s3;
    // s0 = $sformatf( "| %m | wr | rd | full | empty |\n");
    // s1 = $sformatf( "| %m | %1h  | %1h  | %1h    | %1h     |\n"
                  // , (command == FIFO_WR) || (command == FIFO_BOTH)
                  // , (command == FIFO_RD) || (command == FIFO_BOTH)
                  // , wr_full
                  // , rd_empty
                  // );
    // s2 = $sformatf("| %m | wr_data: %h\n" , wr_data);
    // s3 = $sformatf("| %m | rd_data: %h\n" , rd_data);

    // if(command == FIFO_NULL)
      // return {s1, s0};
    // else if(command == FIFO_BOTH)
      // return {s3, s2, s1, s0};
    // else if(command == FIFO_WR)
      // return {s2, s1, s0};
    // else if(command == FIFO_RD)
      // return {s3, s1, s0};
  // endfunction : convert2string

// --------------------------------------------------------------------
endclass : avf_sequence_item
