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

module
  axis_alias
  #(  CONNECT_TREADY  = 1
  ,   CONNECT_TVALID  = 1
  ,   CONNECT_TLAST   = 1
  ,   CONNECT_TUSER   = 1
  )
  ( axis_if axis_in
  , axis_if axis_out
  );

  // --------------------------------------------------------------------
  generate
    if(CONNECT_TREADY == 1)
    begin: tready_gen
      assign axis_in.tready = axis_out.tready;
    end
  endgenerate

  // --------------------------------------------------------------------
  generate
    if(CONNECT_TVALID == 1)
    begin: tvalid_gen
      assign axis_out.tvalid = axis_in.tvalid;
    end
  endgenerate

  // --------------------------------------------------------------------
  generate
    if(CONNECT_TLAST == 1)
    begin: tlast_gen
      assign axis_out.tlast = axis_in.tlast;
    end
  endgenerate

  // --------------------------------------------------------------------
  generate
    if(CONNECT_TUSER == 1)
    begin: tuser_gen
      assign axis_out.tuser = axis_in.tuser;
    end
  endgenerate

  // --------------------------------------------------------------------
  assign axis_out.tdata  = axis_in.tdata;
  assign axis_out.tstrb  = axis_in.tstrb;
  assign axis_out.tkeep  = axis_in.tkeep;
  assign axis_out.tid    = axis_in.tid;
  assign axis_out.tdest  = axis_in.tdest;

// --------------------------------------------------------------------
endmodule
