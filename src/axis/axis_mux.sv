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

import axis_pkg::*;

module axis_mux #(axis_cfg_t CONFIG)
( input   select
, axis_if axis_in[1:0]
, axis_if axis_out
, input   aclk
, input   aresetn
);

  // --------------------------------------------------------------------
  axis_if #(CONFIG) axis_mux_out(.*);

  assign axis_in[0].tready = select ? 0                   : axis_mux_out.tready;
  assign axis_in[1].tready = select ? axis_mux_out.tready : 0;

  assign axis_mux_out.tvalid = select ? axis_in[1].tvalid : axis_in[0].tvalid;
  assign axis_mux_out.tdata  = select ? axis_in[1].tdata  : axis_in[0].tdata;
  assign axis_mux_out.tstrb  = select ? axis_in[1].tstrb  : axis_in[0].tstrb;
  assign axis_mux_out.tkeep  = select ? axis_in[1].tkeep  : axis_in[0].tkeep;
  assign axis_mux_out.tlast  = select ? axis_in[1].tlast  : axis_in[0].tlast;
  assign axis_mux_out.tid    = select ? axis_in[1].tid    : axis_in[0].tid;
  assign axis_mux_out.tdest  = select ? axis_in[1].tdest  : axis_in[0].tdest;
  assign axis_mux_out.tuser  = select ? axis_in[1].tuser  : axis_in[0].tuser;

  // --------------------------------------------------------------------
  axis_register_slice #(CONFIG)
    axis_register_slice_i
    ( .axis_in(axis_mux_out) // slave
    , .axis_out(axis_out)    // master
    , .*
    );

// --------------------------------------------------------------------
endmodule
