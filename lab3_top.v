module lab3_top(
        input [3:0] KEY,
        input [9:0] SW,
        output [6:0] HEX0,
        output [6:0] HEX1,
        output [6:0] HEX2,
        output [6:0] HEX3,
        output [6:0] HEX4,
        output [6:0] HEX5,
        output [9:0] LEDR,
        input CLOCK_50,
        output VGA_CLK,
        output VGA_HS,
        output VGA_VS,
        output VGA_BLANK_N,
        output VGA_SYNC_N,
        output [7:0] VGA_R,
        output [7:0] VGA_G,
        output [7:0] VGA_B
      );

  wire [8:0] x, o;   // current board positions
  wire [8:0] next_o; // next position that O wants to play
  wire [7:0] win_line; // has someone won and if so along which line?
  wire [1:0] status;

  // The following module instance determines the next move played by O. The
  // logic is is described in the Lab 3 handout and in Section 9.4 of Dally.
  // The TicTacToe module is purely combinational logic.  We connect "o" to
  // "xin" instead of "oin" because we want GameLogic to play for O instead
  // of X.
  TicTacToe GameLogic( .xin(o), .oin(x), .xout(next_o), .status(status) );
  //this gives us the output of game status on HEX0
  sseg H0({2'b0,status},   HEX0);

  // The following module records past moves played by you and the module above.
  // It uses something called "sequential logic" we will learn about later.
  // The implementation can be found in game_state.v, but for this lab all you
  // need to know is that the "x" and "o" wires are driven by this block.
  GameState State(  // inputs
                    .o_move(next_o),
                    .x_move(SW[8:0]),
                    .reset(~KEY[0]),
                    .clk(CLOCK_50),
                    .winner(|win_line),
                    // outputs
                    .o(o),
                    .x(x) );

  // The following module will be implemented by you! It detects when someone
  // wins and along which line
  DetectWinner Wins( // inputs
                     .ain(x), .bin(o),
                     // outputs
                     .win_line(win_line) );

  // only set LEDs for positions that X can still play (combinational logic)
  assign LEDR = {1'b0, ~(x|o)};

  `ifndef MODEL_TECH
  // The following module interfaces with the VGA monitor.  The implementation
  // is in tictactoe_to_vga.v and vga.v.  You do not need to understand that
  // code to complete this lab although you are welcome to look at it.
  TicTacToe_to_VGA GFX(
          // inputs
          .x_positions( {x[0],x[1],x[2],x[3],x[4],x[5],x[6],x[7],x[8]} ),
          .o_positions( {o[0],o[1],o[2],o[3],o[4],o[5],o[6],o[7],o[8]} ),
          .next_position( 9'b0 ),
          .win_line( win_line ),
          .reset(~KEY[0]),
          .CLOCK_50(CLOCK_50),

          // outputs
          .VGA_CLK(VGA_CLK),
          .VGA_HS(VGA_HS),
          .VGA_VS(VGA_VS),
          .VGA_BLANK(VGA_BLANK_N),
          .VGA_SYNC(VGA_SYNC_N),
          .VGA_R(VGA_R),
          .VGA_G(VGA_G),
          .VGA_B(VGA_B)
        );
`endif
endmodule
//defining the codes for the HEX display

  `define N0 7'b100_0000 //0
  `define N1 7'b100_1111 //1
  `define N2 7'b010_0100 //2
  `define N3 7'b011_0000 //3
  `define N4 7'b001_1001 //4
  `define N5 7'b001_0010 //5
  `define N6 7'b000_0010 //6
  `define N7 7'b111_1000 //7
  `define N8 7'b000_0000 //8
  `define N9 7'b001_0000 //9

module sseg(in,segs);
  input [3:0] in;
  output [6:0] segs;

  reg [6:0] segs;

  //    0000
  //   5    1
  //   5    1
  //    6666
  //   4    2
  //   4    2
  //    3333
  //


  always @ ( * ) begin
    case (in)
      7'd0: segs = `N0;
      7'd1: segs = `N1;
      7'd2: segs = `N2;
      7'd3: segs = `N3;
      7'd4: segs = `N4;
      7'd5: segs = `N5;
      7'd6: segs = `N6;
      7'd7: segs = `N7;
      7'd8: segs = `N8;
      7'd9: segs = `N9;
      default: segs = 7'b0001110;  // this will output "F"
    endcase
  end

endmodule
