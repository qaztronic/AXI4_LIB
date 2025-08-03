#
+librescan
+libext+.v+.sv+.vh+.svh
-y .
+incdir+../../src/BFMs
--timescale 100ps/1ps
--top-module top

#
../../../src/axis/axis_pkg.sv
../../../src/axis/axis_if.sv
../../../src/avs/asv_enforcer.sv

# ../../../src/axi_lite/axi4_lite_fanout_rd.sv
# ../../../src/axi_lite/axi4_lite_fanout_wr.sv
# ../../../src/axi_lite/axi4_lite_fanout.sv
# ../../../src/axi_lite/axi4_lite_register_file.sv
# ../../../src/axi_lite/axi4_lite_register_if.sv

# ../../../src/basal/FIFOs/tiny_sync_fifo.sv
# ../../../src/basal/misc/recursive_mux.sv

./top.sv
