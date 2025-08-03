// -------------------------------------------------------------------------------
// Copyright qaztronic
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Licensed under the Solderpad Hardware License v 2.1 (the "License"); you may
// not use this file except in compliance with the License, or, at your option,
// the Apache License version 2.0. You may obtain a copy of the License at
//
// https://solderpad.org/licenses/SHL-2.1/
//
// Unless required by applicable law or agreed to in writing, any work distributed
// under the License is distributed on an "AS IS" BASIS,WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
// -------------------------------------------------------------------------------
// --------------------------------------------------------------------

bit [(8*N)-1:0] tdata;
bit sof;
bit eof;
bit sol;
bit eol;

assign axis_bus.tdata = tdata;
assign axis_bus.tlast = eol;
assign axis_bus.tuser = {{eof, sol, sof}};

// --------------------------------------------------------------------
int vf[][];

initial
begin : video_frame
  vf = new[H];

  foreach(vf[i])
    vf[i] = new[W];

  foreach(vf[i,j])
    vf[i][j] = $urandom;
end

// --------------------------------------------------------------------

task fork_strobe_sof;
  fork
  begin
    sof = 1;
    wait(axis_bus.tvalid);
    @(negedge aclk) sof = 0;
  end
  join_none
endtask

// --------------------------------------------------------------------

task fork_strobe_eof;
  fork
  begin
    eof = 1;
    wait(axis_bus.tvalid);
    @(negedge aclk) eof = 0;
  end
  join_none
endtask

// --------------------------------------------------------------------

task fork_strobe_sol;
  fork
  begin
    sol = 1;
    wait(axis_bus.tvalid);
    @(negedge aclk) sol = 0;
  end
  join_none
endtask

// --------------------------------------------------------------------

task fork_strobe_eol;
  fork
  begin
    eol = 1;
    wait(axis_bus.tvalid);
    @(negedge aclk) eol = 0;
  end
  join_none
endtask

// --------------------------------------------------------------------
task automatic send_frame;
  @(negedge aclk);
  fork_strobe_sof();

  foreach(vf[i])
  begin
    fork_strobe_sol();

    foreach(vf[i][j])
    begin
      axis_bus.tvalid = 1;
/* verilator lint_off WIDTHTRUNC */
      tdata  = vf[i][j];
/* verilator lint_on WIDTHTRUNC */

      if(j == vf[i].size() - 1)
      begin
        fork_strobe_eol();

        if(i == vf.size() - 1)
          fork_strobe_eof();
      end

      wait(axis_bus.tready);
      @(negedge aclk);
      axis_bus.tvalid = 0;
    end

    axis_bus.tvalid = 0;
    repeat(B) @(negedge aclk);
  end

  axis_bus.tvalid = 0;
endtask

