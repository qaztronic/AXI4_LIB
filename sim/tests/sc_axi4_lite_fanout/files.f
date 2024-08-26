#
+librescan
+libext+.v+.sv+.vh+.svh
-y .
+incdir+../../src/BFMs
+incdir+../../../src/axi_framework
--top-module top

#
../../src/BFMs/axi4_lite_piker_bfm_pkg.sv
../../src/BFMs/axi4_lite_piker_bfm_if.sv

#
../../../src/axi_framework/axi4_if.sv
../../../src/axi_framework/axi4_m_to_read_fifos.sv
../../../src/axi_framework/axi4_m_to_write_fifos.sv
../../../src/axi_framework/axi4_s_to_read_fifos.sv
../../../src/axi_framework/axi4_s_to_write_fifos.sv

../../../src/axi_lite/axi4_lite_fanout_rd.sv
../../../src/axi_lite/axi4_lite_fanout_wr.sv
../../../src/axi_lite/axi4_lite_fanout.sv
../../../src/axi_lite/axi4_lite_register_file.sv
../../../src/axi_lite/axi4_lite_register_if.sv

../../../src/basal/FIFOs/tiny_sync_fifo.sv
../../../src/basal/misc/recursive_mux.sv

./top.sv
