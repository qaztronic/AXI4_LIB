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

package fifo_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // --------------------------------------------------------------------
  typedef struct packed {
    int W;
    int D;
    int UB;
  } fifo_cfg_t;

  // --------------------------------------------------------------------
  typedef enum {FIFO_RD, FIFO_WR, FIFO_BOTH, FIFO_NULL} fifo_command_t;

  // --------------------------------------------------------------------
  // `include "tb_dut_config.svh"
  `include "fifo_sequence_item.svh"
  `include "fifo_sequencer.svh"
  // typedef uvm_sequencer #(fifo_sequence_item #(CFG)) fifo_sequencer;
  `include "fifo_driver.svh"
  `include "fifo_monitor.svh"
  `include "fifo_scoreboard.svh"
  `include "fifo_agent.svh"
  // `include "tb_env.svh"
  // `include "s_debug.svh"
  // `include "t_top_base.svh"
  // `include "t_debug.svh"

// --------------------------------------------------------------------
endpackage
