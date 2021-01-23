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

class avf_monitor #(axis_cfg_t CONFIG) extends uvm_component;
  `uvm_component_param_utils(avf_monitor #(CONFIG));

  virtual axis_if #(CONFIG) vif;
  video_frame_config c_h;
  uvm_analysis_port #(avf_sequence_item) ap;
  uvm_analysis_port #(avf_sequence_item) req;

  // --------------------------------------------------------------------
  function new (string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // --------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    ap = new("ap", this);
    req = new("req", this);
  endfunction : build_phase

  // --------------------------------------------------------------------
  task run_phase(uvm_phase phase);
    avf_sequence_item req_item;
    avf_sequence_item ap_item;
    bit sof_received = 0;
    int l, p;
    int offset;

    forever @(vif.cb_m iff vif.cb_m.aresetn === 1)
    begin
      if(vif.cb_s.tvalid & ~vif.cb_m.tready)
      begin
        req_item = avf_sequence_item::type_id::create("req_item");
        req_item.kind = AVF_REQUEST;
        req.write(req_item);
      end

      if(vif.cb_s.tvalid & vif.cb_m.tready)
      begin
        if(vif.cb_s.tuser[0]) // SOF
        begin
          ap_item = avf_sequence_item::type_id::create("ap_item");
          ap_item.kind = AVF_TRANSACTION;
          ap_item.f_h = new();
          ap_item.f_h.init( c_h.pixels_per_line
                          , c_h.lines_per_frame
                          , c_h.bits_per_pixel
                          , c_h.pixels_per_clk
                          , c_h.name
                          );
          sof_received = 1;
          p = 0;
          l = 0;
        end

        if(sof_received)
        begin

          for(int i = 0; i < ap_item.f_h.pixels_per_clk; i++, p++)
          begin
            offset = i * ap_item.f_h.bytes_per_pixel * 8;
            for(int k = 0; k < ap_item.f_h.bytes_per_pixel; k++)
              ap_item.f_h.lines[l].pixel[p][k * 8 +: 8] = vif.cb_s.tdata[offset + (k * 8) +: 8];
          end

          if(p >= ap_item.f_h.pixels_per_line)
          begin
            p = 0;
            l++;
          end

          if(vif.cb_s.tuser[2])  // EOF
          begin
            ap.write(ap_item);
            sof_received = 0;
          end
        end
      end
    end
  endtask : run_phase

// --------------------------------------------------------------------
endclass
