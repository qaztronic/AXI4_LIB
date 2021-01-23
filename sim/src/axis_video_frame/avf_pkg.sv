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

package avf_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import tb_pkg::*;
  import video_frame_pkg::*;
  import axis_pkg::*;

  // --------------------------------------------------------------------
  `include "avf_config.svh"
  `include "avf_sequence_item.svh"
  `include "avf_monitor.svh"
  `include "avf_scoreboard.svh"

  // --------------------------------------------------------------------
  typedef uvm_sequencer #(avf_sequence_item) avf_master_sequencer;
  `include "avf_master_driver.svh"
  `include "avf_master_agent.svh"

  // --------------------------------------------------------------------
  `include "avf_slave_sequencer.svh"
  `include "avf_slave_driver.svh"
  `include "avf_slave_agent.svh"
  `include "s_avf_slave_base.svh"

  // --------------------------------------------------------------------
  `include "s_avf_api.svh"
  `include "s_avf_base.svh"

// --------------------------------------------------------------------
endpackage : avf_pkg
