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
class numeric_frame #(type T = shortreal) extends video_frame_class;
  numeric_array #(T) a_h;

  // --------------------------------------------------------------------
  function void init
  (
    array_shape_t shape,
    int pixels_per_clk = 1,
    string name = ""
 );
    a_h = new(shape);
    super.init
    (
      a_h.shape[1],
      a_h.shape[0],
      a_h.bits(),
      pixels_per_clk,
      name
    );
  endfunction

  // --------------------------------------------------------------------
  function void make_1d_frame;
    lines = new[lines_per_frame];
    foreach(lines[l])
    begin
      lines[l].pixel = new[pixels_per_line];
      foreach(lines[l].pixel[p])
        lines[l].pixel[p] = a_h.to_bits('{(l*lines_per_frame)+p});
    end
  endfunction

  // --------------------------------------------------------------------
  function void make_2d_frame;
    lines = new[lines_per_frame];
    foreach(lines[l])
    begin
      lines[l].pixel = new[pixels_per_line];
      foreach(lines[l].pixel[p])
        lines[l].pixel[p] = a_h.to_bits('{l,p});
    end
  endfunction

// --------------------------------------------------------------------
endclass
