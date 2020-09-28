module gameplay_tb ;
  reg [8:0] xin, oin ;
  wire [8:0] xout, oout ;

  TicTacToe dut(xin, oin, xout) ; //let x be the DUT
  TicTacToe opponent(oin, xin, oout) ; //let o be the user

  initial begin
    //case 1
    //this is the case when the user has the 2 extremes of the downward diagonal
    xin = 9'b000_010_000 ; oin = 9'b100_000_001 ; //case 1
    #100 $display("%b %b -> %b | expected output = 000_100_000", xin, oin, xout) ;
    //expects the DUT to select position 5 on the board

    //case 2
    //this is the case when the user has the 2 extremes of the upwards diagonal
    xin = 9'b000_010_000; oin = 9'b001_000_100 ; //case 2
    #100 $display("%b %b -> %b | expected output = 000_001_000", xin, oin, xout) ;
    //expects the DUT to select position 3 on the board


    end
endmodule
