// ECE 5367
// Author(s): Nicholas Archibong, Rakshak Talwar
/*
	Description: Parallel computing code that allows for the calculation of arbitrarily sized matrix
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
	* a1, b1, res1, defined as matrices...by creating indices
	*/
	reg[1:0] state1_1, state2_1;
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
	* numElemA -> # of elements in matrix A
	* numElemB -> # of elements in matrix B
	* chunkACtr -> used to decrement through elements in matrix A
	* chunkBCtr -> used to decrement through elements in matrix B
	*/
	integer numElemA;
	integer numElemB;
	
	integer chunkACtr;
	integer chunkBCtr;
	
	/*
		initial block to initialize our matrix and control variables
	*/
	initial begin
		i1 <= 0; j1 <= 0; k1 <= 0;
		state1_1 <= 0;
		state2_1 <= 0;
		
		numElemA <= matrixALen/8;
		numElemB <= matrixBLen/8;
	
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
						
			chunkACtr = numElemA - 1; // updates the chunk with the previous values
			// start loading of data...
			for(rSet=0; rSet < aRow; rSet=rSet+1) begin
				for(cSet=0; cSet < aCol; cSet=cSet+1) begin
					a1[rSet][cSet] = a[8*chunkACtr +: 8];
					chunkACtr = chunkACtr - 1;
					end
			end
			
			chunkBCtr = numElemB - 1;
			for(rSet=0; rSet < bRow; rSet=rSet+1) begin
				for(cSet=0; cSet < bCol; cSet=cSet+1) begin
					b1[rSet][cSet] = b[8*chunkBCtr +: 8];
					chunkBCtr = chunkBCtr - 1;
					end
			end
			
		end
	end
	
	// computation for one half of matrix A...
	always@(posedge clk) begin
		
		// warn the user if the matrices are incompatible for multiplication
		if(aCol != bRow) begin
			$display("Columns in A != Rows in B!");
		end
		
		else begin
			
			case(state1_1)
				s0: begin
					if(i1 < firstBound) begin
						if(j1 < bCol) begin
							if(k1 < aCol) begin
								res1[i1][j1] <= res1[i1][j1] + (a1[i1][k1] * b1[k1][j1]);
								k1 <= k1 + 1;
							end // end for if(k1 < aCol)
											
							else begin
								j1 <= j1 + 1;
								k1 <= 0;
							end // end for else(k1 < aCol)
						end // end for if(j1 < bCol)
								
						else begin
							state1_1 <= s0;
							i1 <= i1 + 1;
							j1 <= 0;
						end // end for else(j1 < bCol)
						
					end // end for (i1 < firstBound)
					
					else begin
						state1_1 <= sDone;
						finish1 <= 1;
					end // end for else (i1 < firstBound)
					
				end // end for s0 of state1_1
				
				sDone: begin
					// stay in this state...
				end
			
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
						if(j2 < bCol) begin
							if(k2 < aCol) begin
								res1[i2][j2] <= res1[i2][j2] + (a1[i2][k2] * b1[k2][j2]);
								k2 <= k2 + 1;
							end // end for if(k2 < aCol)
							else begin
								j2 <= j2 + 1;
								k2 <= 0;
							end // end for else(k2 < aCol)
						end // end for if(j2 < bCol)
						else begin
							state2_1 <= s0;
							i2 <= i2 + 1;
							j2 <= 0;
						end // end for else(j2 < bCol)
					end // end for (i2 < aRow)
					
					else begin
						state2_1 <= sDone;
						finish2 <= 1;
					end // end for else (i2 < aRow)
					
				end // end for s0 of state2_1
				
				sDone: begin
					// do nothing...
				end
			
			endcase // endcase for state2_1
			
		end
	
	end
	
	
endmodule