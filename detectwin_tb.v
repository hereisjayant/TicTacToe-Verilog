module detectwin_tb ();
  // No inputs or outputs, because it is a testbench



   reg [8:0] ain, bin;

   wire [7:0] output_line;

    DetectWinner winner(ain, bin, output_line);

    initial begin

     // NOTE: In the following cases we consider ain as winner.
      $display("These are the winning cases");
      // Case 1:  expected output win_line(0) = 1 means a win in row 8 7 6
      ain= 9'b111_010_001;
      bin= 9'b000_101_110;
      // wait five simulation timesteps to allow those changes to happen
      #5;
      // print the current values to the Modelsim command line
      $display("output is %b, expected output is %b", output_line, 8'b00000001);

      // Case 2:  expected output win_line(1) = 1 means a win in row 5 4 3
      ain= 9'b010_111_100;
      bin= 9'b101_000_011;
      // wait five simulation timesteps to allow those changes to happen
      #5;
      // print the current values to the Modelsim command line
      $display("output is %b, expected output is %b", output_line, 8'b00000010);

      // Case 3:  expected output win_line(2) = 1 means a win in row 2 1 0
      ain= 9'b000_000_111;
      bin= 9'b000_000_000;
      // wait five simulation timesteps to allow those changes to happen
      #5;
      // print the current values to the Modelsim command line
      $display("output is %b, expected output is %b", output_line, 8'b00000100);

      // Case 4:  expected output win_line(3) = 1 means a win in col 8 5 2
      ain= 9'b100_100_100;
      bin= 9'b000_000_000;
      // wait five simulation timesteps to allow those changes to happen
      #5;
      // print the current values to the Modelsim command line
      $display("output is %b, expected output is %b", output_line, 8'b00001000);


      // NOTE: from here onwards we are using bin as an winner.
      // Case 5: expected output win_line(4) = 1 means a win in col 7 4 1
      bin= 9'b010_010_010;
      ain= 9'b000_000_000;
      // wait five simulation timesteps to allow those changes to happen
      #5;
      // print the current values to the Modelsim command line
      $display("output is %b, expected output is %b", output_line, 8'b00010000);

      // Case 6:  expected output win_line(5) = 1 means a win in col 6 3 0
      bin= 9'b001_001_001;
      ain= 9'b000_000_000;
      // wait five simulation timesteps to allow those changes to happen
      #5;
      // print the current values to the Modelsim command line
      $display("output is %b, expected output is %b", output_line, 8'b00100000);

      // Case 7:  expected output win_line(6) = 1 means a win along the downward diagonal 8 4 0
      bin= 9'b100_010_001;
      ain= 9'b000_000_000;
      // wait five simulation timesteps to allow those changes to happen
      #5;
      // print the current values to the Modelsim command line
      $display("output is %b, expected output is %b", output_line, 8'b01000000);

      // Case 8:  expected output win_line(7) = 1 means a win along the upward diagonal 2 4 6
      bin= 9'b001_010_100;
      ain= 9'b000_000_000;
      // wait five simulation timesteps to allow those changes to happen
      #5;
      // print the current values to the Modelsim command line
      $display("output is %b, expected output is %b", output_line, 8'b10000000);


      //NOTE: From here onwards we consider cases with no winners.

      // Case 9:  expected output win_line = 0 means no winners
      bin= 9'b001_100_011;
      ain= 9'b110_011_100;
      // wait five simulation timesteps to allow those changes to happen
      #5;
      // print the current values to the Modelsim command line
      $display("output is %b, expected output is %b", output_line, 8'b00000000);

      // Case 10:  expected output win_line = 0 means no winners
      bin= 9'b110_011_100;
      ain= 9'b001_100_011;
      // wait five simulation timesteps to allow those changes to happen
      #5;
      // print the current values to the Modelsim command line
      $display("output is %b, expected output is %b", output_line, 8'b00000000);

      // Case 11:  expected output win_line = 0 means no winners
      bin= 9'b110_001_100;
      ain= 9'b001_110_011;
      // wait five simulation timesteps to allow those changes to happen
      #5;
      // print the current values to the Modelsim command line
      $display("output is %b, expected output is %b", output_line, 8'b00000000);

      // Case 12:  expected output win_line = 0 means no winners
      bin= 9'b001_110_011;
      ain= 9'b110_001_100;
      // wait five simulation timesteps to allow those changes to happen
      #5;
      // print the current values to the Modelsim command line
      $display("output is %b, expected output is %b", output_line, 8'b00000000);

      // Case 13:  expected output win_line = 0 means no winners
      bin= 9'b010_001_101;
      ain= 9'b101_110_010;
      // wait five simulation timesteps to allow those changes to happen
      #5;
      // print the current values to the Modelsim command line
      $display("output is %b, expected output is %b", output_line, 8'b00000000);

      $stop;
  end
endmodule
