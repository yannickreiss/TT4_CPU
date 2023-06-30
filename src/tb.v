`default_nettype none
`timescale 1ns/1ps

module tb(
	  input [7:0] in,
	  output [7:0] out
);

initial begin
   $dumpfile ("tb.vcd");
   $dumpvars (0, tb);
   #1;
   
end

   wire [7:0] inputs = in;
   wire [7:0] outputs = out;

   yannickreiss_switch_diamond switch_diamond (
					       .io_in (inputs),
					       .io_out (outputs)
					       );
endmodule // tb
