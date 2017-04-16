// ECE 5367
// Author: Nicholas Archibong
/*
	Description: Code that allows for the calculation of any size matrix
		makes usage of parallel computing...
	
	Constrictions:
	* User must do the calculation for the matrices before hand
	
*/

module testArbParallel(a, b, clk, rst, res);

	/*
	* ** Constraint! Calculations must be done beforehand	
	* # of Rows and Cols for matrix a and b
	* defualted to 2... user gets to change the selection
	*/
	parameter aRow = 2;
	parameter aCol = 2;
	parameter bRow = 2;
	parameter bCol = 2;
	
	/*
	* ** Constraint! Calculations must be done beforehand
	* defaulted to 32... user gets to change selection
	* length is calculated as (rows X cols) * 8bits
	*/
	parameter matrixALen = 32;
	parameter matrixBLen = 32;
	parameter matrixRLen = 32;
	
	input clk, rst;
	
	/*
	* Determine the length of each matrix...
	* signed because maximum int is 32...
	*/
	input signed [matrixALen - 1: 0] a;
	input signed [matrixBLen - 1: 0] b;
	
	output reg signed [matrixRLen - 1: 0] res;
	
	/*
	* firstbound -> used to split matrix A in half...
	* finish(n) -> determine when (n)th/nd always@ finishes
	*/
	integer firstBound;
	reg finish1, finish2;
	
	/*
	* state(n) -> moves around the (n)th/nd always@ 
	* a1, b1, res1, defined as matrices...
	*/
	reg[1:0] state1_1, state1_2, state1_3, state2_1, state2_2, state2_3;
	reg[7:0] a1[0:aRow-1][0:aCol-1];
	reg[7:0] b1[0:bRow-1][0:bCol-1];
	reg[7:0] res1[0:aRow-1][0:bCol-1];
	
	parameter s0 = 0, sDone = 1;
	
	// counters to set the matrices to 0...
	integer rSet, cSet;
	
	/*
	* i(n), j(n), k(n) move through the indices in their...
	*	respective always@ states
	*/
	integer i1, j1, k1;
	integer i2, j2, k2;
	
	/*
	* aChunk -> # of elements in matrix A
	* bChunk -> # of elements in matrix B
	* chunkA -> used to decrement through elements in matrix A
	* chunkB -> used to decrement through elements in matrix B
	*/
	integer aChunk;
	integer bChunk;
	
	integer chunkA;
	integer chunkB;
	
	
	initial begin
		i1 <= 0; j1 <= 0; k1 <= 0;
		state1_1 <= 0; state1_2 <= 0; state1_3 <= 0;
		state2_1 <= 0; state2_2 <= 0; state2_3 <= 0;
		
		aChunk <= matrixALen/8;
		bChunk <= matrixBLen/8;
	
		firstBound = aRow / 2; // calculate where to split the matrix
		
		// load values with 0s
        for(rSet=0; rSet < aRow; rSet=rSet+1)
            for(cSet=0; cSet < aCol; cSet=cSet+1)
				a1[rSet][cSet] = 0;
		
		for(rSet=0; rSet < bRow; rSet=rSet+1)
            for(cSet=0; cSet < bCol; cSet=cSet+1)
				b1[rSet][cSet] = 0;
				
		for(rSet=0; rSet < aRow; rSet=rSet+1)
            for(cSet=0; cSet < bCol; cSet=cSet+1)
				res1[rSet][cSet] = 0;
				
		// i2 must start at the other half of matrix A
		i2 <= firstBound; j2 <= 0; k2 <= 0;
				
		
	end
	
	// always block used to monitor the rst signal for loading...
	always@(posedge clk) begin
		if(!rst) begin
			$display("Loading in data...\n");
						
			//aChunk = (matrixALen/8) - 1;
			
			// start loading of data...
			for(rSet=0; rSet < aRow; rSet=rSet+1) begin
				
				chunkA = aChunk/(rSet + 1) - 1;
				
				for(cSet=0; cSet < aCol; cSet=cSet+1) begin
					a1[rSet][cSet] = a[8*chunkA +: 8];
					chunkA = chunkA - 1;
					end
			end
			
			for(rSet=0; rSet < bRow; rSet=rSet+1) begin
				
				chunkB = bChunk/(rSet + 1) - 1;
				
				for(cSet=0; cSet < bCol; cSet=cSet+1) begin
					b1[rSet][cSet] = b[8*chunkB +: 8];
					chunkB = chunkB - 1;
					end
			end			
			
		end
	end
	
	// computation for one half of matrix A...
	always@(posedge clk) begin
		
		if(aCol != bRow) begin
			$display("Columns in A != Rows in B!");			
		end
		
		else begin
			
			case(state1_1)
				s0: begin
					if(i1 < firstBound) begin
						state1_2 <= s0;
						
						case(state1_2)
							s0: begin
								if(j1 < bCol) begin
									state1_3 <= s0;
									
									case(state1_3)
										s0: begin
											if(k1 < aCol) begin
												res1[i1][j1] <= res1[i1][j1] + (a1[i1][k1] * b1[k1][j1]);
												k1 <= k1 + 1;
											end // end for if(k1 < aCol)
											
											else begin
												state1_2 <= s0;
												j1 <= j1 + 1;
												k1 <= 0;
											end // end for else(k1 < aCol)
											
										end // end for s0 of state1_3
										
									endcase // endcase for state1_3
									
								end // end for if(j1 < bCol)
								
								else begin
									state1_1 <= s0;
									i1 <= i1 + 1; 
									j1 <= 0; 
								end // end for else(j1 < bCol)
								
							end // end for s0 of state1_2
							
						endcase // endcase for state1_2
						
					end // end for (i1 < firstBound)
					
					else begin
						state1_1 <= sDone;
						finish1 <= 1;
					end // end for else (i1 < firstBound)
					
				end // end for s0 of state1_1
			
			endcase // endcase for state1_1
			
		end
		
	end
	
	// second always for computation of the other half
	always@(posedge clk) begin

		if(aCol != bRow) begin
			$display("Columns in A != Rows in B!");			
		end
		
		else begin
			
			case(state2_1)
				s0: begin
					if(i2 < aRow) begin
						state2_2 <= s0;
						
						case(state2_2)
							s0: begin
								if(j2 < bCol) begin
									state2_3 <= s0;
									
									case(state2_3)
										s0: begin
											if(k2 < aCol) begin
												res1[i2][j2] <= res1[i2][j2] + (a1[i2][k2] * b1[k2][j2]);
												k2 <= k2 + 1;
											end // end for if(k2 < aCol)
											
											else begin
												state2_2 <= s0;
												j2 <= j2 + 1;
												k2 <= 0;
											end // end for else(k2 < aCol)
											
										end // end for s0 of state2_3
										
									endcase // endcase for state2_3
									
								end // end for if(j2 < bCol)
								
								else begin
									state2_1 <= s0;
									i2 <= i2 + 1; 
									j2 <= 0; 
								end // end for else(j2 < bCol)
								
							end // end for s0 of state2_2
							
						endcase // endcase for state2_2
						
					end // end for (i2 < firstBound)
					
					else begin
						state2_1 <= sDone;
						finish2 <= 1;
					end // end for else (i2 < firstBound)
					
				end // end for s0 of state2_1
			
			endcase // endcase for state2_1
			
		end	
	
	end
	
	
endmodule