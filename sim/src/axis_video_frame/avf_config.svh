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

class avf_config #(axis_cfg_t CONFIG);
  // --------------------------------------------------------------------
  localparam int N = CONFIG.N;

  virtual axis_if #(CONFIG) vif;
  protected uvm_active_passive_enum is_active; // UVM_ACTIVE or UVM_PASSIVE
  video_frame_config c_h;

  // --------------------------------------------------------------------
  function void init
  ( int pixels_per_line
  , int lines_per_frame
  , int bits_per_pixel
  , string    name = ""
  );
    c_h = new();
    c_h.init( .pixels_per_line(pixels_per_line)
            , .lines_per_frame(lines_per_frame)
            , .bits_per_pixel(bits_per_pixel)
            , .bus_width(N)
            );
  endfunction: init

  // --------------------------------------------------------------------
  function new
  (  virtual axis_if #(CONFIG) vif
  ,  uvm_active_passive_enum is_active = UVM_ACTIVE
  );
    this.vif = vif;
    this.is_active = is_active;
  endfunction : new

  // --------------------------------------------------------------------
  function uvm_active_passive_enum get_is_active();
    return is_active;
  endfunction : get_is_active

// --------------------------------------------------------------------
endclass
