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

class avf_slave_sequencer extends uvm_sequencer #(avf_sequence_item);
  `uvm_component_utils(avf_slave_sequencer)

  uvm_analysis_export #(avf_sequence_item) m_request_export;
  uvm_tlm_analysis_fifo #(avf_sequence_item) m_request_fifo;

  // --------------------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    m_request_fifo = new("m_request_fifo", this);
    m_request_export = new("m_request_export", this);
  endfunction

  // --------------------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    m_request_export.connect(m_request_fifo.analysis_export);
  endfunction

// --------------------------------------------------------------------
endclass
