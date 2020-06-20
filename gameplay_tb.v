module gameplay_tb ;
  reg [8:0] xin, oin ;
  wire [8:0] xout, oout ;

  TicTacToe dut(xin, oin, xout) ; //let x be the DUT
  TicTacToe opponent(oin, xin, oout) ; //let o be the user

  initial begin
    xin = 9'b000_010_000 ; oin = 9'b100_000_001 ; //case 1
    #100 $display("%b %b -> %b | expected output = 000_100_000", xin, oin, xout) ;
    // can win across the top
    xin = 9'b000_010_000; oin = 9'b001_000_100 ; //case 2
    #100 $display("%b %b -> %b | expected output = 000_001_000", xin, oin, xout) ;


    end
endmodule
