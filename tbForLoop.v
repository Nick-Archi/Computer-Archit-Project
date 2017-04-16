// ECE 5367
// Author: Nicholas Archibong
/*
	Description:
	 
	
*/

`timescale 1ns/1ns


module tbForLoop();

	reg clk, rst;
	wire finish;
	
	defparam uut.c = 2; // how to change a parameter in the module

	ForLoop uut(clk, rst, finish);
	//ForLoop2 uut(clk, rst, finish);	
	//ForLoop3 uut(clk, rst, finish);
	
	

	always begin
		clk <= 0;
		#10;
		clk <= 1;
		#10;
	end
	
	initial begin
		rst <= 0;
		
		#100
		rst <= 1;
	end

	
	
endmodule
