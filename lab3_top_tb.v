// synopsys translate_off

`timescale 1ps/1ps

module lab3_top_tb();

  reg CLOCK_50;
  wire [3:0] KEY;
  wire [9:0] SW;
  wire [9:0] LEDR;
  
  wire VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N;
  wire [7:0] VGA_R, VGA_G, VGA_B;
  wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

  initial forever begin
    CLOCK_50 = 1'b0; #10;
    CLOCK_50 = 1'b1; #10;
  end

  lab3_top dut( .CLOCK_50, .KEY, .SW, 
    .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .LEDR, 
		.VGA_CLK, .VGA_HS, .VGA_VS, .VGA_BLANK_N, .VGA_SYNC_N,
		.VGA_R, .VGA_G, .VGA_B
  );

  de1_gui gui(.SW, .KEY, .LEDR, .HEX5, .HEX4, .HEX3, .HEX2, .HEX1, .HEX0, 
    .x(dut.x), .o(dut.o), .win(dut.win_line) );

endmodule

// synopsys translate_on
