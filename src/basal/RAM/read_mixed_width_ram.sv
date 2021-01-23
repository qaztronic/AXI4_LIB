module 
  read_mixed_width_ram // 256x32 write and 1024x8 read
  (
    input [7:0] waddr,
    input [31:0] wdata,
    input we, clk,
    input [9:0] raddr,
    output logic [7:0] q
  );
  logic [3:0][7:0] ram[0:255];
  always_ff@(posedge clk)
  begin
    if(we) 
      ram[waddr] <= wdata;
    q <= ram[raddr / 4][raddr % 4];
  end
endmodule
