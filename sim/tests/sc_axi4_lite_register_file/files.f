#
+librescan
+libext+.v+.sv+.vh+.svh
-y .
+incdir+../../src/BFMs
--top-module top

#
../../../src/axi_lite/axi4_lite_pkg.sv
../../../src/axi_lite/axi4_lite_if.sv

../../../src/kit/axi4_bus_wr_fifo_if.sv
../../../src/kit/axi4_bus_rd_fifo_if.sv
../../../src/kit/axi4_s_bus_wr_fifos.sv
../../../src/kit/axi4_s_bus_rd_fifos.sv

# ../../../src/axi_lite/axi4_lite_default_slave.sv

#
# ../../../src/axi_framework/axi4_if.sv
# ../../../src/axi_framework/axi4_m_to_read_fifos.sv
# ../../../src/axi_framework/axi4_m_to_write_fifos.sv
# ../../../src/axi_framework/axi4_s_to_read_fifos.sv
# ../../../src/axi_framework/axi4_s_to_write_fifos.sv

# ../../../src/axi_lite/.sv
# ../../../src/axi_lite/.sv

# ../../../src/axi_lite/axi4_lite_fanout_rd.sv
# ../../../src/axi_lite/axi4_lite_fanout_wr.sv
# ../../../src/axi_lite/axi4_lite_fanout.sv
../../../src/axi_lite/axi4_lite_register_file.sv
../../../src/axi_lite/axi4_lite_register_if.sv

../../../src/basal/FIFOs/tiny_sync_fifo.sv
../../../src/basal/misc/recursive_mux.sv

./top.sv
