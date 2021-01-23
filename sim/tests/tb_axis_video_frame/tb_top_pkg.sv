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

package tb_top_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import axis_pkg::*;
  import avf_pkg::*;

  // --------------------------------------------------------------------
  localparam AVF_B = 2; // BYTES_PER_PIXEL
  localparam AVF_T = 4; // pixels per clock
  localparam AVF_AW = 32; // active width
  localparam AVF_AH = 16; // active height
  localparam AVF_N = AVF_B * AVF_T;
  localparam AVF_U = 3;

  // --------------------------------------------------------------------
  localparam axis_cfg_t AVF_CONFIG =
  '{  N: AVF_N
   ,  I: 0
   ,  D: 0
   ,  U: AVF_U
   ,  USE_TSTRB : 0
   ,  USE_TKEEP : 0
  };

  // --------------------------------------------------------------------
  `include "tb_dut_config.svh"
  `include "tb_env.svh"
  `include "s_debug.svh"
  `include "t_top_base.svh"
  `include "t_debug.svh"

// --------------------------------------------------------------------
endpackage
