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
class video_frame_config;
  rand int pixels_per_line;
  rand int lines_per_frame;
  rand int bits_per_pixel;
  rand int bus_width;
  int bytes_per_pixel;
  int pixels_per_clk;
  string name;

  // --------------------------------------------------------------------
  function void init( int pixels_per_line
                    , int lines_per_frame
                    , int bits_per_pixel
                    , int bus_width
                    , string name = ""
                    );
    this.pixels_per_line  = pixels_per_line;
    this.lines_per_frame  = lines_per_frame;
    this.bits_per_pixel   = bits_per_pixel;
    this.bytes_per_pixel  = (bits_per_pixel % 8 == 0)
                          ? (bits_per_pixel / 8)
                          : (bits_per_pixel / 8) + 1;
    this.bus_width        = bus_width;
    this.pixels_per_clk   = bus_width / bytes_per_pixel;
    this.name             = name;

    // --------------------------------------------------------------------
    assert(bus_width % bytes_per_pixel == 0);
  endfunction : init

// --------------------------------------------------------------------
endclass
