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

class axi4_lite_piker_bfm_driver #(A=0, N=0);
  // --------------------------------------------------------------------
  virtual axi4_lite_piker_bfm_if #(A,N) vif;

  // // --------------------------------------------------------------------
  // task axi4_lite_read
  // ( input  [    A-1:0] addr
  // , output [(N*8)-1:0] data
  // );
    // @(negedge vif.aclk);
    // vif.araddr  <= addr;
    // vif.arvalid <= 1;

    // wait(vif.arready);
    // @(negedge vif.aclk);
    // vif.araddr  <= 'x;
    // vif.arvalid <= 0;

    // wait(vif.rvalid);
    // @(negedge vif.aclk);
    // data = vif.rdata;
    // $display("[%0t] axi4_lite_read  @ araddr: %x | rdata: %x", $time, addr, vif.rdata);
    // vif.rready <= 1;

    // @(negedge vif.aclk);
    // vif.rready <= 0;
  // endtask

  // // --------------------------------------------------------------------
  // task axi4_lite_write
  // ( input [    A-1:0] addr
  // , input [(N*8)-1:0] data
  // );
    // @(negedge vif.aclk);
    // vif.awaddr  <= addr;
    // vif.awvalid <= 1   ;
    // vif.wdata   <= data;
    // vif.wvalid  <= 1   ;

    // fork
      // begin
        // wait(vif.awready);
        // @(negedge vif.aclk);
        // vif.awaddr = 'x;
        // vif.awvalid = 0;
      // end
      // begin
        // wait(vif.wready);
        // @(negedge vif.aclk);
        // vif.wdata = 'x;
        // vif.wvalid = 0;
      // end
    // join

    // wait(vif.bvalid);
    // @(negedge vif.aclk);
    // $display("[%0t] axi4_lite write @ awaddr: %x | wdata: %x", $time, addr, data);
    // vif.bready = 1;

    // @(negedge vif.aclk);
    // vif.bready = 0;
  // endtask

  // // --------------------------------------------------------------------
  // // --------------------------------------------------------------------
  // mailbox #(axi4_lite_piker_bfm_transaction #(A, N)) m2s_q, s2m_q;

  // // --------------------------------------------------------------------
  // task automatic  post_read
  // ( input  [A-1:0] addr
  // );
    // axi4_lite_piker_bfm_transaction #(A, N) tr;
    // tr = new();
    // tr.axaddr = addr;
    // tr.read   = 1;
    // m2s_q.put(tr);
  // endtask

  // // --------------------------------------------------------------------
  // task automatic read
  // ( input  [    A-1:0] addr
  // , output [(N*8)-1:0] data
  // );
    // axi4_lite_piker_bfm_transaction #(A, N) tr;

    // if(m2s_q.num() !== 0)
    // begin
      // $warning("read failed! | m2s_q.num() !== 0");
      // return;
    // end

    // post_read(addr);
    // s2m_q.get(tr);
    // $display("[%0t] read  @ awaddr: %x | wdata: %x", $time, tr.axaddr, tr.xdata);
  // endtask

  // // --------------------------------------------------------------------
  // task automatic run_driver;
    // $display("[%0t] %m | run_driver", $time);

    // fork
      // forever
      // begin : f_run_driver
        // axi4_lite_piker_bfm_transaction #(A, N) tr;
        // m2s_q.get(tr);
        // s2m_q.put(tr);
      // end
    // join_none
  // endtask

  // --------------------------------------------------------------------
  function new(virtual axi4_lite_piker_bfm_if #(A,N) vif);
    this.vif = vif;
    // m2s_q = new();
    // s2m_q = new();
    // run_driver();
  endfunction

// --------------------------------------------------------------------
endclass