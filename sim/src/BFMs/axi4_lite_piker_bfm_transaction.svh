// --------------------------------------------------------------------
// Copyright 2024 qaztronic
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Licensed under the Solderpad Hardware License v 2.1 (the "License");
// you may not use this file except in compliance with the License, or,
// at your option, the Apache License version 2.0. You may obtain a copy
// of the License at
//
// https://solderpad.org/licenses/SHL-2.1/
//
// Unless required by applicable law or agreed to in writing, any work
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
// implied. See the License for the specific language governing
// permissions and limitations under the License.
// --------------------------------------------------------------------

class axi4_lite_piker_bfm_transaction #(A=0, N=0);
  // --------------------------------------------------------------------
  rand bit unsigned [    A-1:0] axaddr;
  rand bit unsigned [(N*8)-1:0] xdata ;

  // --------------------------------------------------------------------
  bit read ;
  bit write;
  bit unsigned [2:0] axsize = 2;

  // --------------------------------------------------------------------
  constraint align {
    (axaddr & (1 << axsize) - 1) == '0;
  }

  constraint max_addr {
    axaddr < 2**A;
  }

// --------------------------------------------------------------------
endclass
