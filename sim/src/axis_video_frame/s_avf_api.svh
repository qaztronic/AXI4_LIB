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

class s_avf_api
  extends uvm_sequence #(avf_sequence_item);
  `uvm_object_utils(s_avf_api)

  avf_sequence_item item;
  mailbox #(video_frame_class) frame_buffer;

  // --------------------------------------------------------------------
  video_frame_config c_h;

  function void init(video_frame_config c_h);
    this.c_h = c_h;
  endfunction : init

  // --------------------------------------------------------------------
  task automatic put_frame(string pattern, int pixel = 0);
    video_frame_class f_h = new;
    f_h.init( c_h.pixels_per_line
            , c_h.lines_per_frame
            , c_h.bits_per_pixel
            , c_h.pixels_per_clk
            );
    case(pattern.tolower)
      "constant":   f_h.make_constant(pixel);
      "counting":   f_h.make_counting();
      "horizontal": f_h.make_horizontal();
      "vertical":   f_h.make_vertical();
      "random":     f_h.make_random();
      default:      `uvm_fatal(get_name(), "Pattern not supported!")
    endcase

    frame_buffer.put(f_h);
    uvm_report_info(get_name(), $sformatf("| put_frame(%s)", pattern.tolower));
  endtask: put_frame

  // --------------------------------------------------------------------
  task automatic frame_memh(string pattern, int pixel = 0);
    video_frame_class f_h = new;
    f_h.init( c_h.pixels_per_line
            , c_h.lines_per_frame
            , c_h.bits_per_pixel
            , c_h.pixels_per_clk
            );
    case(pattern.tolower)
      "constant":   f_h.make_constant(pixel);
      "counting":   f_h.make_counting();
      "horizontal": f_h.make_horizontal();
      "vertical":   f_h.make_vertical();
      "random":     f_h.make_random();
      default:      `uvm_fatal(get_name(), "Pattern not supported!")
    endcase
    f_h.do_writememh({pattern.tolower, ".mem"});
    uvm_report_info(get_name(), $sformatf("| frame_memh(%s)", pattern.tolower));
  endtask: frame_memh

  // --------------------------------------------------------------------
  task automatic put_memh(string file_name);
    video_frame_class f_h = new;
    f_h.init( c_h.pixels_per_line
            , c_h.lines_per_frame
            , c_h.bits_per_pixel
            , c_h.pixels_per_clk
            );
    f_h.load_memh(file_name);
    frame_buffer.put(f_h);
    uvm_report_info(get_name(), $sformatf("| put_memh(%s)", file_name));
  endtask: put_memh

  // --------------------------------------------------------------------
  task send_frame_buffer( uvm_sequencer_base seqr
                        , uvm_sequence_base parent = null
                        );
    this.start(seqr, parent);
  endtask

  // --------------------------------------------------------------------
  task body();
    item = avf_sequence_item::type_id::create("avf_sequence_item");
    start_item(item);
    if(frame_buffer.num() != 0)
      item.frame_buffer = this.frame_buffer;
    finish_item(item);
  endtask

  // --------------------------------------------------------------------
  function new(string name = "s_avf_api");
    super.new(name);
    frame_buffer = new;
  endfunction

// --------------------------------------------------------------------
endclass : s_avf_api
