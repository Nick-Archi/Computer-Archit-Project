// ECE 5367
// Author: Nicholas Archibong and Rakshak Talwar
/*
	Description: 
	
*/


module ForLoop(clk, rst, finish);

	input clk, rst;
	
	output reg finish;
	
	integer i, k;
	parameter c = 2;
	
	reg[1:0] state;
	
	parameter s0 = 0, s1 = 1, sDone = 2;
	
	initial begin
		i <= 0;
		state <= 0;
		k <= 2;
		finish <= 0;
	end
	
	always@(posedge clk) begin
		
		case(state)
			s0: begin
				
				if(i < c) begin
					i <= i + 1;
				
				end
				
				else begin
					state <= sDone;
				end							
				
			end
			
			sDone: begin
				finish <= 1;
			end
		
		endcase
		
	end


endmodule