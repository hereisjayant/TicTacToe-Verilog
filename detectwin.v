// DetectWinner
// Detects whether either ain or bin has three in a row
// Inputs:
//   ain, bin - (9-bit) current positions of type a and b
// Out:
//   win_line - (8-bit) if A/B wins, one hot indicates along which row, col or diag
//   win_line(0) = 1 means a win in row 8 7 6 (i.e., either ain or bin has all ones in this row)
//   win_line(1) = 1 means a win in row 5 4 3
//   win_line(2) = 1 means a win in row 2 1 0
//   win_line(3) = 1 means a win in col 8 5 2
//   win_line(4) = 1 means a win in col 7 4 1
//   win_line(5) = 1 means a win in col 6 3 0
//   win_line(6) = 1 means a win along the downward diagonal 8 4 0
//   win_line(7) = 1 means a win along the upward diagonal 2 4 6

module DetectWinner( input [8:0] ain, bin, output [7:0] win_line );

  wire [7:0] win_line_a, win_line_b;
  check_win win_a (ain,win_line_a); //created an instance of check_win for ain
  check_win win_b (bin,win_line_b); //created an instance of check_win for bin
  assign win_line = win_line_a|win_line_b;
  // CPEN 211 LAB 3, PART 1: your implementation goes here
endmodule

module check_win(input [8:0] xin, output reg [7:0] win_line);

always @* begin
  case( xin )
    9'b111000000: win_line = 8'b00000001;  //   win_line(0) = 1 means a win in row 8 7 6
    9'b000111000: win_line = 8'b00000010;  //   win_line(1) = 1 means a win in row 8 7 6
    9'b000000111: win_line = 8'b00000100;  //   win_line(2) = 1 means a win in row 8 7 6
    9'b100100100: win_line = 8'b00001000;  //   win_line(3) = 1 means a win in col 8 5 2
    9'b010010010: win_line = 8'b00010000;  //   win_line(4) = 1 means a win in col 7 4 1
    9'b001001001: win_line = 8'b00100000;  //   win_line(5) = 1 means a win in col 6 3 0
    9'b100010001: win_line = 8'b01000000;  //   win_line(6) = 1 means a win along the downward diagonal 8 4 0
    9'b001010100: win_line = 8'b10000000;  //   win_line(7) = 1 means a win along the upward diagonal 2 4 6
    default: win_line = 8'b0;
  endcase
end
endmodule // check_win
