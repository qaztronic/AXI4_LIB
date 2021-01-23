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

class s_anf_base #(type T = shortreal) extends uvm_sequence #(avf_sequence_item);
  `uvm_object_param_utils(s_anf_base #(T))

  s_anf_api anf_api_h;

  // --------------------------------------------------------------------
  function void init(video_frame_config c_h);
    anf_api_h = s_anf_api #(T)::type_id::create("s_anf_api");
    anf_api_h.init(c_h);
  endfunction

  // --------------------------------------------------------------------
  function new(string name = "s_anf_base");
    super.new(name);
  endfunction

// --------------------------------------------------------------------
endclass
