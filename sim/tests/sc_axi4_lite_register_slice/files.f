#
+librescan
+libext+.v+.sv+.vh+.svh
-y .
--top-module top

#
+incdir+../../../src/axi_lite
../../../src/axi_lite/axi4_lite_pkg.sv
../../../src/axi_lite/axi4_lite_if.sv

../../../src/axi_lite/axi4_lite_register_slice.sv
../../../src/axi_lite/axi4_lite_terminus.sv

../../../src/kit/axi4_bus_wr_fifo_if.sv
../../../src/kit/axi4_bus_rd_fifo_if.sv

../../../src/basal/FIFOs/tiny_sync_fifo.sv
../../../src/basal/misc/recursive_mux.sv

+incdir+../../src/BFMs

./top.sv
