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

module axis_map_fifo #(axis_cfg_t CONFIG, int W)
  ( axis_if         axis_in
  , axis_if         axis_out
  , output  [W-1:0] wr_data
  , input   [W-1:0] rd_data
  );
  // --------------------------------------------------------------------
  localparam int WIDTH  = (CONFIG.N * 8)
                        + (CONFIG.N * CONFIG.USE_TSTRB)
                        + (CONFIG.N * CONFIG.USE_TKEEP)
                        + CONFIG.I
                        + CONFIG.D
                        + CONFIG.U
                        + 1;

// --------------------------------------------------------------------
// synthesis translate_off
  initial
  begin
    a_w: assert(W == WIDTH) else $fatal;
  end
// synthesis translate_on
// --------------------------------------------------------------------

  // --------------------------------------------------------------------
  generate
    begin: assign_gen
      if(CONFIG.USE_TSTRB & CONFIG.USE_TKEEP)
      begin
        assign wr_data =
          { axis_in.tlast
          , axis_in.tuser
          , axis_in.tstrb
          , axis_in.tkeep
          , axis_in.tdata
          };
        assign
          { axis_out.tlast
          , axis_out.tuser
          , axis_out.tstrb
          , axis_out.tkeep
          , axis_out.tdata
          } = rd_data;
      end
      else if(CONFIG.USE_TSTRB)
      begin
        assign wr_data =
          { axis_in.tlast
          , axis_in.tuser
          , axis_in.tstrb
          , axis_in.tdata
          };
        assign
          { axis_out.tlast
          , axis_out.tuser
          , axis_out.tstrb
          , axis_out.tdata
          } = rd_data;
      end
      else if(CONFIG.USE_TKEEP)
      begin
        assign wr_data =
          { axis_in.tlast
          , axis_in.tuser
          , axis_in.tkeep
          , axis_in.tdata
          };
        assign
          { axis_out.tlast
          , axis_out.tuser
          , axis_out.tkeep
          , axis_out.tdata
          } = rd_data;
      end
      else
      begin
        assign wr_data =
          { axis_in.tlast
          , axis_in.tuser
          , axis_in.tdata
          };
        assign
          { axis_out.tlast
          , axis_out.tuser
          , axis_out.tdata
          } = rd_data;
      end
    end
  endgenerate

// --------------------------------------------------------------------
endmodule
