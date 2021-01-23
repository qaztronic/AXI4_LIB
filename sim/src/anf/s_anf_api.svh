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

class s_anf_api #(type T = shortreal) extends s_avf_api;
  `uvm_object_param_utils(s_anf_api #(T))

  // --------------------------------------------------------------------
  function numeric_frame#(T) new_frame;
    numeric_frame #(T) f_h = new();
    f_h.init( '{c_h.lines_per_frame, c_h.pixels_per_line}
            , c_h.pixels_per_clk
            );
    return f_h;
  endfunction

  // --------------------------------------------------------------------
  task put_array(numeric_frame #(T) f_h);
    f_h.make_2d_frame();
    frame_buffer.put(f_h);
  endtask

  // --------------------------------------------------------------------
  task automatic put_test_pattern(string pattern, T value = 0.0);
    numeric_frame #(T) f_h = new();
    f_h.init( '{c_h.lines_per_frame, c_h.pixels_per_line}
            , c_h.pixels_per_clk
            );
    case(pattern.tolower)
      "constant":   f_h.a_h.make_2d_constant(value);
      // "counting":   f_h.make_counting();
      // "horizontal": f_h.make_horizontal();
      // "vertical":   f_h.make_vertical();
      // "random":     f_h.make_random();
      default:      `uvm_fatal(get_name(), "Pattern not supported!")
    endcase
    f_h.make_2d_frame();
    frame_buffer.put(f_h);
    uvm_report_info(get_name(), $sformatf("| put_test_pattern(%s)", pattern.tolower));
  endtask

  // --------------------------------------------------------------------
  task load_from_file(string file_name);
    byte mem[3:0];
    integer fd;
    integer code;
    int x, y;
    numeric_frame #(T) f_h = new();

    fd = $fopen(file_name, "rb");
    f_h.init( '{c_h.lines_per_frame, c_h.pixels_per_line}
            , c_h.pixels_per_clk
            );
    f_h = new_frame();

    for(int i = 0; $feof(fd) == 0; i++)
    begin
      code = $fread(mem, fd);
      y = i / c_h.pixels_per_line;
      x = i % c_h.pixels_per_line;
      f_h.lines[y].pixel[x] = {>>{mem}};
    end

    frame_buffer.put(f_h);
    $fclose(fd);
  endtask

  // --------------------------------------------------------------------
  function new(string name = "s_anf_api");
    super.new(name);
  endfunction

// --------------------------------------------------------------------
endclass
