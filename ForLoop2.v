// ECE 5367
// Author: Nicholas Archibong and Rakshak Talwar
/*
	Description: 
	
*/

module ForLoop2(clk, rst, finish);

	input clk, rst;
	
	output reg finish;
	
	integer i, j;
	parameter c = 2;
	
	reg[1:0] state1, state2;
	
	parameter s0 = 0, s1 = 1, sDone = 2;
	
	initial begin
		i <= 0;
		state1 <= s0;
		j <= 0;
		finish <= 0;
		state2 <= s0;
	end
	
	always@(posedge clk) begin
		
		case(state1)
		
			s0: begin
				if(i < c) begin
					state2 <= s0;
					
					case(state2)
						s0: begin
							if(j < c) begin
								j <= j + 1;
							end
							
							else begin
								state1 <= s0;
								i <= i + 1;
								j <= 0;
							end
														
						end
						
					endcase
				end
				
				else begin
					state1 <= sDone;
				end
			end
			
			sDone: begin
				finish <= 1;
			end
		
		endcase
		
		
	end


endmodule
