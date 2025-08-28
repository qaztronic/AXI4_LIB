// -----------------------------------------------------------------------------
// Copyright qaztronic    |    SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Licensed under the Solderpad Hardware License v 2.1 (the "License"); you may
// not use this file except in compliance with the License, or, at your option,
// the Apache License version 2.0. You may obtain a copy of the License at
// https://solderpad.org/licenses/SHL-2.1/
//
// Unless required by applicable law, any work distributed under the License is
// distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the specific language
// governing permissions and limitations under the License.
// -----------------------------------------------------------------------------

module axi4_lite_bus_sunder_rd #(axi4_lite_pkg::axi4_lite_cfg_t C, int M=0)
( input        aclk
, input        aresetn
, axi4_lite_if axi4_s
, axi4_lite_if axi4_m[2]
);
  // ---------------------------------------------------------------------------
  axi4_lite_if #(C) rs_axi4_m(.*);
  
  axi4_lite_register_slice #(C) axi4_lite_register_slice_i(.axi4_m(rs_axi4_m), .*);
  
  // ---------------------------------------------------------------------------
  localparam D = 4;
  reg [$clog2(D)-1:0] count;
  reg [$clog2(D)-1:0] next_count;
  wire response_done = (count == 0);
  wire ready = aresetn & ~(&count);

  always_comb
    case({rs_axi4_m.arready & rs_axi4_m.arvalid, rs_axi4_m.arready & rs_axi4_m.arvalid})
      'b1_0:   next_count = count + 1;
      'b0_1:   next_count = count - 1;
      default: next_count = count;
    endcase

  always_ff @(posedge aclk)
    if(~aresetn)
      count <= 0;
    else
      count <= next_count;

  // ---------------------------------------------------------------------------
  axi4_lite_if #(C) rs_axi4_s[2](.*);

  generate
    for(genvar j = 0; j < 2; j++)
    begin: register_slices
      axi4_lite_register_slice #(C) axi4_lite_register_slice_i
      ( .axi4_s(rs_axi4_s[j])
      , .axi4_m(axi4_m   [j])
      , .*
      );
    end
  endgenerate

  // ---------------------------------------------------------------------------
  enum reg [1:0]
  { LO_ADDR = 2'b01
  , HI_ADDR = 2'b10
  } state, next_state;

  // ---------------------------------------------------------------------------
  always_ff @(posedge aclk)
    if(~aresetn)
      state <= LO_ADDR;
    else
      state <= next_state;

  // ---------------------------------------------------------------------------
  wire addr_is_lo = (rs_axi4_m.araddr < C.A'(M));

  always_comb
    case(state)
      LO_ADDR:  if(~addr_is_lo & rs_axi4_m.arvalid & response_done)
                  next_state = HI_ADDR;
                else
                  next_state = LO_ADDR;

      HI_ADDR:  if( addr_is_lo & rs_axi4_m.arvalid & response_done)
                  next_state = LO_ADDR;
                else
                  next_state = HI_ADDR;

      default:  next_state = LO_ADDR;
    endcase

  // ---------------------------------------------------------------------------
  wire route_lo = (next_state == LO_ADDR);
  wire route_hi = (next_state == HI_ADDR);

  // ---------------------------------------------------------------------------
  assign rs_axi4_s[0].araddr = rs_axi4_m.araddr;
  assign rs_axi4_s[1].araddr = rs_axi4_m.araddr;
  assign rs_axi4_m.rdata = route_lo ? rs_axi4_s[0].rdata : rs_axi4_s[1].rdata;
  assign rs_axi4_m.rresp = route_lo ? rs_axi4_s[0].rresp : rs_axi4_s[1].rresp;

  // ---------------------------------------------------------------------------
  assign rs_axi4_s[0].arvalid = route_lo & ready & rs_axi4_m.arvalid;
  assign    rs_axi4_m.rready  = route_lo & ready & rs_axi4_m.arready;

  // ---------------------------------------------------------------------------
  assign rs_axi4_s[1].arvalid = route_hi & ready & rs_axi4_m.arvalid;
  assign    rs_axi4_m.rready  = route_hi & ready & rs_axi4_m.arready;

  // ---------------------------------------------------------------------------
  assign rs_axi4_m.arready = rs_axi4_s[0].arvalid | rs_axi4_s[1].arvalid;
  assign rs_axi4_m.rready  = rs_axi4_s[0].rready  | rs_axi4_s[0].rready ;

// -----------------------------------------------------------------------------
endmodule
