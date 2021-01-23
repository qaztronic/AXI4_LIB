module byte_enabled_simple_dual_port_ram
(
input we, clk,
input [5:0] waddr, raddr, // address width = 6
input [3:0] be, // 4 bytes per word
input [31:0] wdata, // byte width = 8, 4 bytes per word
output reg [31:0] q // byte width = 8, 4 bytes per word
);
// use a multi-dimensional packed array
//to model individual bytes within the word
logic [3:0][7:0] ram[0:63]; // # words = 1 << address width
always_ff@(posedge clk)
begin
if(we) begin
if(be[0]) ram[waddr][0] <= wdata[7:0];
if(be[1]) ram[waddr][1] <= wdata[15:8];
if(be[2]) ram[waddr][2] <= wdata[23:16];
if(be[3]) ram[waddr][3] <= wdata[31:24];
end
q <= ram[raddr];
end
endmodule
