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

class s_avf_slave_base
  extends uvm_sequence #(avf_sequence_item);
  `uvm_object_utils(s_avf_slave_base)

  avf_slave_sequencer sequencer_h;
  avf_sequence_item item;

  // --------------------------------------------------------------------
  task body();
    forever
    begin
      sequencer_h.m_request_fifo.get(item);
      start_item(item);
      finish_item(item);
    end
  endtask: body

  // --------------------------------------------------------------------
  function new(string name = "s_avf_slave_base");
    super.new(name);
  endfunction

// --------------------------------------------------------------------
endclass : s_avf_slave_base
