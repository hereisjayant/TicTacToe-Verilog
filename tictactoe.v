/*******************************************************************************
Copyright (c) 2012, Stanford University
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. All advertising materials mentioning features or use of this software
   must display the following acknowledgement:
   This product includes software developed at Stanford University.
4. Neither the name of Stanford Univerity nor the
   names of its contributors may be used to endorse or promote products
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY STANFORD UNIVERSITY ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*******************************************************************************/

// TicTacToe
// Generates a move for X in the game of tic-tac-toe
// Inputs:
//   xin, oin - (9-bit) current positions of X and O.
// Out:
//   oout - (9-bit) one hot position of next O.
//
// Inputs and outputs use a board mapping of:
//
//   0 | 1 | 2
//  ---+---+---
//   3 | 4 | 5
//  ---+---+---
//   6 | 7 | 8
//
// The top-level circuit instantiates strategy modules that each generate
// a move according to their strategy and a selector module that selects
// the highest-priority strategy module with a move.
//
// The win strategy module picks a space that will win the game if any exists.
//
// The block strategy module picks a space that will block the opponent
// from winning.
//
// The empty strategy module picks the first open space - using a particular
// ordering of the board.
//-----------------------------------------------------------------------------

// The following module, RArb, is combinational logic.  The input is a set
// of "requests" r -- one request per bit of r.  The output "g" is a set of
// grant signals.  If "r" is not all zeros, then a single bit of "g" will be
// set to 1.  Which bit?  The bit of "g" that will be set to 1 will be the
// bit that is in the same position as the first bit of "r" that is set to
// 1 starting from the highest index bit position in "r".
//
// Note that r is declared as "input [n-1:0]".  This means it contains "n"
// bits with index values from n-1 for the leftmost bit down to 0 for the
// right most bit.  By default n is set to 8, but we can change n when we
// instantiate the RArb module.  For example, using the notation "RArb #(9)"
// we change n to 9 when we instantiate RArb inside the module Empty.
//
// Suppose now that input r = 8'b00101111. Then, the bit with highest index,
// bit 7, has a value of 1'b0 and the bit with lowest index has value 1'b1.
// The output "g" will be 8'b00100000.  You may want to create a small
// testbench script and simulating just this module with different input
// values until you are sure you understand how the output "g" depends upon
// the input "r".
//
// The textbook describes the this module in Chapter 8 (Figure 8.31).
module RArb(r, g) ;
  parameter n=8 ;
  input  [n-1:0] r ;
  output [n-1:0] g ;
  wire   [n-1:0] c = {1'b1,(~r[n-1:1] & c[n-1:1])} ;
  assign g = r & c ;
endmodule // RArb

//Figure 9.12
module TicTacToe(xin, oin, xout, status) ;
  input [8:0] xin, oin ;
  output [8:0] xout ;
  output [1:0] status;
  wire [8:0] adedge, win, block, empty ;


  PlayAdjacentEdge addedgex(xin, oin, adedge);
  TwoInArray winx(xin, oin, win) ;           // win if we can
  TwoInArray blockx(oin, xin, block) ;       // try to block o from winning
  Empty      emptyx(~(oin | xin), empty) ;   // otherwise pick empty space
  Select4    comb(win, adedge, block, empty, xout) ; // pick highest priority
  checkStatus status_checker(xin, oin, status); //this checks the game status

endmodule // TicTacToe

module checkStatus(xin, oin, status);
  input [8:0] xin, oin;
  output [1:0] status;

  reg [1:0] status;
  wire [7:0] winx_ln;
  wire [7:0] wino_ln;

//used for draw, if all positions are 1 ipAND would be 1
  wire ipAND = &(xin & oin);
  wire ipOR = &(xin | oin);
  //checks if x wins or o wins
  check_win win_x(xin, winx_ln);
  check_win win_o(oin, wino_ln);

  always @ ( * ) begin
    casex ({|winx_ln, |wino_ln, ipAND, ipOR})
    //case when the DUT Wins
    {1'b1,1'b0,1'bx, 1'bx}: status = 2'b10 ;
    //case when the DUT loses:
    {1'b0,1'b1, 1'bx, 1'bx}: status = 2'b01;
    //case when the game is a tie:
    {1'b0, 1'b0, 1'bx, 1'b1}: status = 2'b11;
    //case where the game is still on:
    {1'b0, 1'b0, 1'b0, 1'bx}: status = 2'b00;
      default: status = 2'bxx;
    endcase
  end


endmodule

module PlayAdjacentEdge(ain, bin, cout );
  input [8:0] ain, bin;
  output reg [8:0] cout;

  always @* begin
    casex( {ain, bin} )
      18'b000_010_000__100_000_001: cout = 9'b000_100_000;  //checks the first case
      18'b000_010_000__001_000_100: cout = 9'b000_001_000;  //checks the the other case case

      //NOTE: the following case is not a part of PlayAdjacentEdge, its for the bonus:
      18'b000_010_000__010_000_001: cout = 9'b001_000_000;
      default: cout = 9'b0; //if the preconditions are not met, does nothing!
    endcase
  end
  endmodule


//Figure 9.13
module TwoInArray(ain, bin, cout) ;
  input [8:0] ain, bin ;
  output [8:0] cout ;

  wire [8:0] rows, cols ;
  wire [2:0] ddiag, udiag ;

  // check each row
  TwoInRow topr(ain[2:0],bin[2:0],rows[2:0]) ;
  TwoInRow midr(ain[5:3],bin[5:3],rows[5:3]) ;
  TwoInRow botr(ain[8:6],bin[8:6],rows[8:6]) ;

  // check each column
  TwoInRow leftc({ain[6],ain[3],ain[0]},
                  {bin[6],bin[3],bin[0]},
                  {cols[6],cols[3],cols[0]}) ;
  TwoInRow midc({ain[7],ain[4],ain[1]},
                  {bin[7],bin[4],bin[1]},
                  {cols[7],cols[4],cols[1]}) ;
  TwoInRow rightc({ain[8],ain[5],ain[2]},
                  {bin[8],bin[5],bin[2]},
                  {cols[8],cols[5],cols[2]}) ;

  // check both diagonals
  TwoInRow dndiagx({ain[8],ain[4],ain[0]},{bin[8],bin[4],bin[0]},ddiag) ;
  TwoInRow updiagx({ain[6],ain[4],ain[2]},{bin[6],bin[4],bin[2]},udiag) ;

  //OR together the outputs
  assign cout = rows | cols |
         {ddiag[2],1'b0,1'b0,1'b0,ddiag[1],1'b0,1'b0,1'b0,ddiag[0]} |
         {1'b0,1'b0,udiag[2],1'b0,udiag[1],1'b0,udiag[0],1'b0,1'b0} ;
endmodule // TwoInArray

//Figure 9.14
module TwoInRow(ain, bin, cout) ;
  input [2:0] ain, bin ;
  output [2:0] cout ;

  assign cout[0] = ~bin[0] & ~ain[0] & ain[1] & ain[2] ;
  assign cout[1] = ~bin[1] & ain[0] & ~ain[1] & ain[2] ;
  assign cout[2] = ~bin[2] & ain[0] & ain[1] & ~ain[2] ;
endmodule // TwoInRow

//Figure 9.15
module Empty(in, out) ;
  input [8:0] in ;
  output [8:0] out ;

  RArb #(9) ra({in[4],in[0],in[2],in[6],in[8],in[1],in[3],in[5],in[7]},
          {out[4],out[0],out[2],out[6],out[8],out[1],out[3],out[5],out[7]}) ;
endmodule // Empty

//Figure 9.16
module Select4(a, b, c, d, out) ;
  input [8:0] a, b, c, d;
  output [8:0] out ;
  wire [35:0] x ;

  RArb #(36) ra({a,b,c,d},x) ;

  assign out = x[35:27] | x[26:18] | x[17:9] | x[8:0] ;
endmodule // Select4

//Figure 9.18
module TestTic ;
  reg [8:0] xin, oin ;
  wire [8:0] xout, oout ;

  TicTacToe dut(xin, oin, xout) ;
  TicTacToe opponent(oin, xin, oout) ;

  initial begin
    // all zeros, should pick middle
    xin = 0 ; oin = 0 ;
    #100 $display("%b %b -> %b", xin, oin, xout) ;
    // can win across the top
    xin = 9'b101 ; oin = 0 ;
    #100 $display("%b %b -> %b", xin, oin, xout) ;
    // near-win: can't win across the top due to block
    xin = 9'b101 ; oin = 9'b010 ;
    #100 $display("%b %b -> %b", xin, oin, xout) ;
    // block in the first column
    xin = 0 ; oin = 9'b100100 ;
    #100 $display("%b %b -> %b", xin, oin, xout) ;
    // block along a diagonal
    xin = 0 ; oin = 9'b010100 ;
    #100 $display("%b %b -> %b", xin, oin, xout) ;
    // start a game - x goes first
    xin = 0 ; oin = 0 ;
    repeat (6) begin
      #100
      $display("%h %h %h", {xin[0],oin[0]},{xin[1],oin[1]},{xin[2],oin[2]}) ;
      $display("%h %h %h", {xin[3],oin[3]},{xin[4],oin[4]},{xin[5],oin[5]}) ;
      $display("%h %h %h", {xin[6],oin[6]},{xin[7],oin[7]},{xin[8],oin[8]}) ;
      $display(" ") ;
      xin = (xout | xin) ;
      #100
      $display("%h %h %h", {xin[0],oin[0]},{xin[1],oin[1]},{xin[2],oin[2]}) ;
      $display("%h %h %h", {xin[3],oin[3]},{xin[4],oin[4]},{xin[5],oin[5]}) ;
      $display("%h %h %h", {xin[6],oin[6]},{xin[7],oin[7]},{xin[8],oin[8]}) ;
      $display(" ") ;
      oin = (oout | oin) ;
    end
  end
endmodule
