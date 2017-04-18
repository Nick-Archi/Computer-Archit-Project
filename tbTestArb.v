// ECE 5367
// Author: Nicholas Archibong
/*
	Description:
	 
	
*/

`timescale 1ns/1ns

module tbTestArb();

	reg[127:0] a;
	reg[127:0] b;
	reg clk, rst;
	wire[64:0] res;

	defparam uut.aRow = 3;	
	defparam uut.aCol = 2;	
	defparam uut.bRow = 2;	
	defparam uut.bCol = 3;	

	defparam uut.matrixALen = 48;	
	defparam uut.matrixBLen = 48;	
	defparam uut.matrixRLen = 72;

	testArb uut(a, b, clk, rst, res);
	
	always begin
		clk <= 0;
		#10;
		clk <= 1;
		#10;
	end

	initial begin
		rst <= 0;
		
		//#20
		/*
		* 
		*/
		a <= {8'd1,8'd2,8'd1,8'd2,8'd1,8'd2};
		b <= {8'd1,8'd1,8'd1,8'd1,8'd1,8'd1};
		
		#20
		rst <= 1;
		
	end	
	

endmodule