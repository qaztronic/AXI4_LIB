//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2019 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

// --------------------------------------------------------------------
module
  axis_down_shift_tuser_mux
  #(
    U = 1, // TUSER width
    logic [U-1:0] TUSER_MASK[3] = '{ {U{1'b0}},  // first
                                     {U{1'b0}},  // middle
                                     {U{1'b0}} } // last
  )
  (
    axis_if axis_in,
    axis_if axis_out,
    input   aclk,
    input   aresetn
  );

// --------------------------------------------------------------------
endmodule

// --------------------------------------------------------------------
module
  axis_down_shift
  #(
    N,     // axis_in tdata bus width in bytes
    S,     // tdata size divisor
    I = 1, // TID width
    D = 1, // TDEST width
    U = 1, // TUSER width
    logic [U-1:0] TUSER_MASK[3] = '{ {U{1'b0}},  // first
                                     {U{1'b0}},  // middle
                                     {U{1'b0}} } // last
  )
  (
    axis_if axis_in,
    axis_if axis_out,
    input   aclk,
    input   aresetn
  );

// --------------------------------------------------------------------
// synthesis translate_off
  initial
  begin
    assert(S > 1) else $fatal;
    assert(N % S == 0) else $fatal;
  end
// synthesis translate_on
// --------------------------------------------------------------------

  // --------------------------------------------------------------------
  localparam N_OUT = (N / S); // width of axis_out.tdata in bytes
  localparam W = N_OUT * 8;   // width of axis_out.tdata in bits
  localparam UB = (W*(S-1))-1;

  // --------------------------------------------------------------------
  axis_if #(.N(N_OUT), .I(I), .D(D), .U(U)) a_down(.*);
  wire almost_last;

  // --------------------------------------------------------------------
  enum reg [2:0]
    {
      FIRST   = 3'b001,
      MIDDLE  = 3'b010,
      LAST    = 3'b100
    } state, next_state;

  // --------------------------------------------------------------------
  always_ff @(posedge aclk)
    if(~aresetn)
      state <= FIRST;
    else
      state <= next_state;

  // --------------------------------------------------------------------
  always_comb
    case(state)
      FIRST:    if(axis_in.tvalid & a_down.tready)
                  if(almost_last)
                    next_state <= LAST;
                  else
                    next_state <= MIDDLE;
                else
                  next_state <= FIRST;

      MIDDLE:   if(almost_last & a_down.tready)
                  next_state <= LAST;
                else
                  next_state <= MIDDLE;

      LAST:     if(a_down.tready)
                  next_state <= FIRST;
                else
                  next_state <= LAST;

      default:  next_state <= FIRST;
    endcase

  // --------------------------------------------------------------------
  reg [$clog2(S)-1:0] index;
  assign almost_last = (index >= S - 2);

  always_ff @(posedge aclk)
    if(next_state == FIRST)
      index <= 0;
    else if(a_down.tready)
      index <= index + 1;

  // --------------------------------------------------------------------
  reg  [UB:0]  remainder;
  wire [W-1:0] tdata_pass  = axis_in.tdata[W-1:0];
  wire [W-1:0] tdata_shift = remainder[W-1:0];

  always_ff @(posedge aclk)
    if(state == FIRST)
      remainder <= axis_in.tdata[(N*8)-1:W];
    else if(a_down.tready)
      remainder <= { {W{1'b0}}, remainder[UB:W]};

  // --------------------------------------------------------------------
  reg [U-1:0] tuser;

    generate
      for(genvar j = 0; j < U; j++)
      begin: tuser_gen
        always_comb
          case(state)
            FIRST:    tuser[j] = TUSER_MASK[0][j] ? axis_in.tuser[j] : 0;
            MIDDLE:   tuser[j] = TUSER_MASK[1][j] ? axis_in.tuser[j] : 0;
            LAST:     tuser[j] = TUSER_MASK[2][j] ? axis_in.tuser[j] : 0;
            default:  tuser[j] = 0;
          endcase
      end
    endgenerate

  // --------------------------------------------------------------------
  assign axis_in.tready = (state == LAST) & (next_state != LAST);
  // assign a_down.tstrb  = axis_in.tstrb;
  // assign a_down.tkeep  = axis_in.tkeep;
  assign a_down.tid    = axis_in.tid;
  assign a_down.tdest  = axis_in.tdest;
  assign a_down.tvalid = axis_in.tvalid;
  assign a_down.tlast  = (state == LAST) ? axis_in.tlast : 0;
  assign a_down.tuser  = tuser;
  assign a_down.tdata  = (state == FIRST) ? tdata_pass : tdata_shift;

  // --------------------------------------------------------------------
  axis_register_slice #(.N(N_OUT), .I(I), .D(D), .U(U))
    slice_i(.axis_in(a_down), .*);

// --------------------------------------------------------------------
endmodule
