// ECE 5367
// Author: Nicholas Archibong
/*
	Description:
	 Simulation of parallel computing example with 2x2 matrix
	
*/

module matrix2x2Parallel(a, b, clk, rst, res);
	
	input[31:0] a, b;
	input clk, rst;

	output reg[31:0] res;
	
	reg[1:0] state;
	reg flag;
	reg[7:0] a1[0:1][0:1];
	reg[7:0] b1[0:1][0:1];
	reg[7:0] res1[0:1][0:1];
		
	parameter s0 = 0, s1 = 1, s2 = 2, s3 = 3;
	
	always@(posedge clk) begin
	
		if(rst == 0) begin
			state <= 0;
			flag <= 0;
			res <= 32'b0;
			{a1[0][0], a1[0][1], a1[1][0], a1[1][1]} = 0;
			{b1[0][0], b1[0][1], b1[1][0], b1[1][1]} = 0;
			{res1[0][0], res1[0][1], res1[1][0], res1[1][1]} = 0;
			
		end
		
		else begin
			case(state)
			
			s0: begin
				{a1[0][0], a1[0][1], a1[1][0], a1[1][1]} = a;
				{b1[0][0], b1[0][1], b1[1][0], b1[1][1]} = b;
				state <= s1;
			end
			
			s1: begin
				res1[0][0] <= (a1[0][0] * b1[0][0]) + (a1[0][1] * b1[1][0]); // position (1,1)
				res1[1][0] <= (a1[1][0] * b1[0][0]) + (a1[1][1] * b1[1][0]); // position (2,1)
				state <= s2;
			end
			
			s2: begin
				res1[0][1] <= (a1[0][0] * b1[0][1]) + (a1[0][1] * b1[1][1]); // position (1,2)
				res1[1][1] <= (a1[1][0] * b1[0][1]) + (a1[1][1] * b1[1][1]); // position (2,2)
				state <= s3;				
			end
			
			s3: begin
				flag <= 1;
				res <= {res1[0][0], res1[0][1], res1[1][0], res1[1][1]};
			end
			
						
			default: begin
			state <= 0;
			flag <= 0;
			res <= 32'b0;	
			{a1[0][0], a1[0][1], a1[1][0], a1[1][1]} = 0;
			{b1[0][0], b1[0][1], b1[1][0], b1[1][1]} = 0;	
			{res1[0][0], res1[0][1], res1[1][0], res1[1][1]} = 0;
			
			end
			
			endcase
				
		end
	
	
	end

endmodule