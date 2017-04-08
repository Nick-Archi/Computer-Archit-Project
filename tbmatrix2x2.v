// ECE 5367
// Author: Nicholas Archibong
/*
	Description:
	 
	
*/

`timescale 1ns/1ns

module tbmatrix2x2();

	reg[31:0] a, b;
	reg clk, rst;
	
	wire[31:0] res;
	
	matrix2x2 uut(a, b, clk, rst, res);
	
	always begin
		clk <= 0;
		#10;
		clk <= 1;
		#10;
	end
	
	initial begin
	
		rst <= 0;
		a = 0;
		b = 0;		
		#100;
		
		rst <= 1;
		a = {8'd1,8'd2,8'd3,8'd4};
		b = {8'd5,8'd6,8'd7,8'd8};
		
		
	end


endmodule

