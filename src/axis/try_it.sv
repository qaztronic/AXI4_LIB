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

module try_it #(N = 1)
  ( input aclk
  , input aresetn
  , input tready
  , output  [(8*N)-1:0] tdata
  );
  import axis_pkg::*;

  // --------------------------------------------------------------------
  localparam W = N;
  localparam WPB = 1;
  localparam axis_cfg_t CONFIG =
    '{  N: N
     ,  I: 0
     ,  D: 0
     ,  U: 0
     ,  USE_TSTRB : 0
     ,  USE_TKEEP : 0
    };

  // --------------------------------------------------------------------
  axis_if #(CONFIG) axis_out(.*);

  // --------------------------------------------------------------------
  axis_test_patern #(CONFIG, W , WPB)
    axis_test_patern_i(.*);

  // --------------------------------------------------------------------
  assign axis_out.tvalid = 1;
  assign axis_out.tready = tready;
  assign axis_out.tstrb  = 0;
  assign axis_out.tkeep  = 0;
  assign axis_out.tlast  = 1;
  assign axis_out.tid    = 0;
  assign axis_out.tdest  = 0;
  assign axis_out.tuser  = 0;

  // --------------------------------------------------------------------
  assign tdata = axis_out.tdata;

// --------------------------------------------------------------------
endmodule
