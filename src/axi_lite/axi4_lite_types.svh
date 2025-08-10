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

// -----------------------------------------------------------------------------
typedef struct packed {
  logic [C.A-1:0] addr;
} axi4_lite_ar_t;

typedef struct packed {
  logic [C.A-1:0] addr;
} axi4_lite_aw_t;

typedef struct packed {
  logic [1:0] resp;
} axi4_lite_b_t;

typedef struct packed {
  logic [        1:0] resp;
  logic [(8*C.N)-1:0] data;
} axi4_lite_r_t;

typedef struct packed {
  logic [(8*C.N)-1:0] data;
} axi4_lite_w_0_t;

typedef struct packed {
  logic [    C.N-1:0] strb;
  logic [(8*C.N)-1:0] data;
} axi4_lite_w_1_t;

// -----------------------------------------------------------------------------
/* verilator lint_off UNUSEDPARAM */
localparam AR_W = $bits(axi4_lite_ar_t);
localparam AW_W = $bits(axi4_lite_aw_t);
localparam  B_W = $bits(axi4_lite_b_t);
localparam  R_W = $bits(axi4_lite_r_t);
localparam  W_W = (C.USE_STRB == 0) ? $bits(axi4_lite_w_0_t) : $bits(axi4_lite_w_1_t);
/* verilator lint_on UNUSEDPARAM */
