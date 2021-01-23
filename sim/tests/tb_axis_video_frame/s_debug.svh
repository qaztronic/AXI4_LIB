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

class s_debug extends s_avf_base;
  `uvm_object_utils(s_debug)

  // --------------------------------------------------------------------
  task body();
    avf_api_h.put_frame("counting");
    avf_api_h.put_frame("constant", 16'habba);
    avf_api_h.put_frame("horizontal");
    avf_api_h.put_frame("vertical");
    avf_api_h.put_frame("random");

    avf_api_h.send_frame_buffer(m_sequencer, this);
  endtask: body

// --------------------------------------------------------------------
endclass
