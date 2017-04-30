// ECE 5367
// Author(s): Nicholas Archibong, Rakshak Talwar
/*
	Description: Testbench for the sequential process of arbitary sized matrices. 
	Matrix size for the resultant and the multiplicant and multiplcand must be 
	known beforehand. 
	
*/

`timescale 1ns/1ns

module tbTestArb();

	parameter aRow = 5;
	parameter aCol = 5;
	parameter bRow = 5;
	parameter bCol = 5;

	reg[(aRow * aCol * 8) - 1:0] a;
	reg[(bRow * bCol * 8) - 1:0] b;
	reg clk, rst;
	wire[64:0] res;

	defparam uut.aRow = aRow;	
	defparam uut.aCol = aCol;	
	defparam uut.bRow = bRow;	
	defparam uut.bCol = bCol;

	defparam uut.matrixALen = aRow * aCol * 8;	
	defparam uut.matrixBLen = bRow * bCol * 8;	
	defparam uut.matrixRLen = aRow * bCol * 8;	

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
		
		a <= {8'd1,8'd2,8'd3,8'd4,8'd5,8'd1,8'd2,8'd3,8'd4,8'd5,
			  8'd1,8'd2,8'd3,8'd4,8'd5,8'd1,8'd2,8'd3,8'd4,8'd5,
			  8'd1,8'd2,8'd3,8'd4,8'd5};
		b <= {8'd1,8'd2,8'd3,8'd4,8'd5,8'd1,8'd2,8'd3,8'd4,8'd5,
			  8'd1,8'd2,8'd3,8'd4,8'd5,8'd1,8'd2,8'd3,8'd4,8'd5,
			  8'd1,8'd2,8'd3,8'd4,8'd5};
		
		/*
		a <= {8'd5,8'd4,8'd3,8'd0,8'd5,8'd3,8'd5,8'd1,8'd1,8'd4,
			8'd4,8'd3,8'd1,8'd3,8'd1,8'd1,8'd2,8'd2,8'd3,8'd5,
			8'd4,8'd5,8'd2,8'd4,8'd4,8'd5,8'd0,8'd1,8'd0,8'd2,
			8'd3,8'd0,8'd4,8'd1,8'd3,8'd5,8'd1,8'd2,8'd5,8'd1,
			8'd1,8'd0,8'd5,8'd3,8'd4,8'd1,8'd5,8'd1,8'd1,8'd2,
			8'd0,8'd0,8'd5,8'd5,8'd1,8'd4,8'd5,8'd0,8'd5,8'd0,
			8'd1,8'd3,8'd3,8'd2,8'd1,8'd4,8'd3,8'd5,8'd0,8'd3,
			8'd1,8'd3,8'd0,8'd0,8'd0,8'd5,8'd1,8'd4,8'd1,8'd1,
			8'd3,8'd4,8'd5,8'd3,8'd0,8'd2,8'd4,8'd0,8'd4,8'd1,
			8'd5,8'd1,8'd2,8'd1,8'd4,8'd3,8'd4,8'd1,8'd2,8'd5};
		b <= {8'd4,8'd5,8'd2,8'd5,8'd4,8'd2,8'd2,8'd2,8'd5,8'd3,
			8'd1,8'd4,8'd5,8'd5,8'd4,8'd5,8'd2,8'd0,8'd0,8'd4,
			8'd2,8'd4,8'd4,8'd1,8'd1,8'd0,8'd5,8'd2,8'd4,8'd0,
			8'd3,8'd4,8'd3,8'd0,8'd5,8'd0,8'd2,8'd5,8'd3,8'd3,
			8'd0,8'd2,8'd0,8'd0,8'd5,8'd4,8'd0,8'd0,8'd1,8'd3,
			8'd1,8'd4,8'd1,8'd0,8'd4,8'd5,8'd2,8'd4,8'd3,8'd3,
			8'd4,8'd4,8'd3,8'd1,8'd4,8'd3,8'd2,8'd3,8'd4,8'd3,
			8'd5,8'd0,8'd2,8'd2,8'd1,8'd3,8'd0,8'd1,8'd0,8'd2,
			8'd0,8'd1,8'd0,8'd3,8'd3,8'd2,8'd2,8'd1,8'd5,8'd1,
			8'd2,8'd3,8'd3,8'd5,8'd5,8'd3,8'd4,8'd1,8'd1,8'd0};
		*/
		
		#20

		rst <= 1;
		
	end	
	

endmodule