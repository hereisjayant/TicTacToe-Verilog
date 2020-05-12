module lab3_RArb_tb ();
  // No inputs or outputs, because it is a testbench
   reg [7:0] r;

   wire [7:0] g;

    RArb test(r,g);

    initial begin
      // start out by setting our buttons to "not-pushed"
      r= 8'b00101010;

      // wait five simulation timesteps to allow those changes to happen
      #5;


      // print the current values to the Modelsim command line
      $display("Input is %b, we output is %b", r, g);


      // Try adding
      r=8'b00000010;
      #5;

      $display("Input is %b, we output is %b", r, g);
      // Try adding
      r=8'b00000000;
      #5;
      $display("Input is %b, we output is %b", r, g);

      #5;
      // Try adding
      r=8'b11111111;

      $display("Input is %b, we output is %b", r, g);
      #5;

      $stop;
  end
endmodule
