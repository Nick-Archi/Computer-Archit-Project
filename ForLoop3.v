// ECE 5367
// Author: Nicholas Archibong and Rakshak Talwar
/*
	Description: 
	
*/


module ForLoop3(clk, rst, finish);

	input clk, rst;
	output reg finish;
	
	integer i, j, k;
	parameter c = 0;
	
	reg[1:0] state1, state2, state3;
	
	parameter s0 = 0, sDone = 1;
	
	always@(posedge clk) begin
	
		if(rst == 0) begin
			i <= 0;
			j <= 0;
			k <= 0;
			state1 <= 0;
			state2 <= 0;
			state3 <= 0;
		end
		
		else begin
			
			case(state1)
				s0: begin
					if(i < c) begin
						state2 <= s0;
						
						case(state2) 
							s0: begin
								if(j < c) begin
											state3 <= s0;
									
									case(state3)
										s0: begin
											if(k < c) begin
												k <= k + 1;
											end
											
											else begin
												state2 <= s0;
												j <= j + 1;
												k <= 0;
											end
										end // end of state3
									endcase // endcase for k...
								end
								
								else begin
									state1 <= 0;
									i <= i + 1;
									j <= 0;
								end
							end // end of state2
						endcase // endcase for j...
					end
					
					else begin
						state1 <= sDone;
						finish <= 1;
					end
				end // end s0 for state1
				
				sDone: begin
					
				end // end of sDone
				
			endcase // endcase for i
			
		end
	
	
	end



endmodule