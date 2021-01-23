module 
  write_mixed_width_ram // 1024x8 write and 256x32 read
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
      ram[waddr / 4][waddr % 4] <= wdata;
    q <= ram[raddr];
  end
endmodule

