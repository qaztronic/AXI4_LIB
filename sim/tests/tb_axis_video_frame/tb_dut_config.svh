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

class tb_dut_config #(axis_cfg_t CONFIG);

  avf_config #(CONFIG) m_cfg_h; // master
  avf_config #(CONFIG) s_cfg_h; // slave

  // --------------------------------------------------------------------
  function void init
  ( int pixels_per_line
  , int lines_per_frame
  , int bits_per_pixel
  );
    m_cfg_h.init( pixels_per_line
                , lines_per_frame
                , bits_per_pixel
                );
    s_cfg_h.init( pixels_per_line
                , lines_per_frame
                , bits_per_pixel
                );
  endfunction: init

  // --------------------------------------------------------------------
  function new(virtual axis_if #(CONFIG) vif);
    m_cfg_h = new(vif, UVM_ACTIVE);
    s_cfg_h = new(vif, UVM_ACTIVE);
  endfunction : new

// --------------------------------------------------------------------
endclass
