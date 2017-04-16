// ECE 5367
// Author: Nicholas Archibong
/*
	Description:
	 
	
*/

`timescale 1ns/1ns

module tbTestArbParallel();
	
	reg[128:0] a;
	reg[64:0] b;
	reg clk, rst;
	wire[64:0] res;
	
	
	defparam uut.aRow = 4;	
	defparam uut.aCol = 4;	
	defparam uut.bRow = 4;	
	defparam uut.bCol = 2;	

	defparam uut.matrixALen = 128;	
	defparam uut.matrixBLen = 64;	
	defparam uut.matrixRLen = 64;	
	
	
	testArbParallel uut(a, b, clk, rst, res);

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
		a <= {8'd1,8'd2,8'd3,8'd4,8'd7,8'd1,8'd2,8'd3,8'd1,8'd2,8'd3,8'd4,8'd7,8'd1,8'd2,8'd3};
		b <= {8'd5,8'd6,8'd7,8'd8,8'd9,8'd1,8'd2,8'd3};
		
		#20
		rst <= 1;
		
	end	



endmodule
