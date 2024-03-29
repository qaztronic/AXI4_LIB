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

virtual class t_top_base extends uvm_test;
  `uvm_component_utils(t_top_base);
  tb_env env_h;

  // --------------------------------------------------------------------
  function new (string name, uvm_component parent);
    super.new(name,parent);
  endfunction : new

  // --------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    env_h = tb_env::type_id::create("env_h",this);
  endfunction : build_phase

// --------------------------------------------------------------------
endclass
