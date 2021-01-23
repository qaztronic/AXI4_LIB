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

class avf_master_driver #(axis_cfg_t CONFIG)
  extends uvm_driver #(avf_sequence_item);
   `uvm_component_param_utils(avf_master_driver #(CONFIG))

  // --------------------------------------------------------------------
  localparam int N = CONFIG.N;
  virtual axis_if #(CONFIG) vif;
  video_frame_class f_h;

  //--------------------------------------------------------------------
  function void set_default;
    vif.cb_m.tvalid <= 0;
    vif.cb_m.tdata  <= 'x;
    vif.cb_m.tstrb  <= {N{1'b1}};
    vif.cb_m.tkeep  <= {N{1'b1}};
    vif.cb_m.tlast  <= 'x;
    vif.cb_m.tid    <= 0;
    vif.cb_m.tdest  <= 0;
    vif.cb_m.tuser  <= 'x;
  endfunction: set_default

  //--------------------------------------------------------------------
  virtual task run_phase(uvm_phase phase);
    avf_sequence_item item;
    logic [(8*N)-1:0] tdata;
    int offset;

    super.run_phase(phase);

    set_default();

    forever
    begin
      wait(vif.aresetn);
      seq_item_port.get_next_item(item);

      while(item.frame_buffer.try_get(f_h))
      begin
        vif.zero_cycle_delay();
        repeat(item.delay_h.get(item.sof_delay))
          @(vif.cb_m);
        vif.cb_m.tvalid <= 1;

        foreach(f_h.lines[l])
          for(int p = 0; p < f_h.pixels_per_line; p += f_h.pixels_per_clk)
          begin
            if(l == 0 && p == 0)
              vif.cb_m.tuser[0] <= 1;
            else
              vif.cb_m.tuser[0] <= 0;

            if(p == 0)
              vif.cb_m.tuser[1] <= 1;
            else
              vif.cb_m.tuser[1] <= 0;

            if(p + f_h.pixels_per_clk >= f_h.pixels_per_line && l + 1 >= f_h.lines_per_frame)
              vif.cb_m.tuser[2] <= 1;
            else
              vif.cb_m.tuser[2] <= 0;

            if(p + f_h.pixels_per_clk >= f_h.pixels_per_line)
              vif.cb_m.tlast <= 1;
            else
              vif.cb_m.tlast <= 0;

            for(int i = 0; i < f_h.pixels_per_clk; i++)
            begin
              offset = i * f_h.bytes_per_pixel * 8;
              for(int k = 0; k < f_h.bytes_per_pixel; k++)
                tdata[offset + (k * 8) +: 8] = f_h.lines[l].pixel[p + i][k * 8 +: 8];
            end

            vif.cb_m.tdata <= tdata;
            @(vif.cb_m iff vif.cb_m.tready);

            vif.cb_m.tvalid <= 0;
            repeat(item.get_delay(vif.cb_s.tlast, vif.cb_s.tuser[2]))
              @(vif.cb_m);
            vif.cb_m.tvalid <= 1;
          end

        vif.cb_m.tuser[2] <= 0;
        vif.cb_m.tlast    <= 0;
        vif.cb_m.tvalid   <= 0;
      end

      seq_item_port.item_done();
    end
  endtask : run_phase

  //--------------------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

// --------------------------------------------------------------------
endclass
