// ECE 5367Author(s): Nicholas Archibong, Rakshak TalwarAuthor: Nicholas Archibong
/*
	Description: Code that allows for the calculation of any size matrix
		makes usage of sequential computing...
	
	Constrictions:
	* User must do the calculation for the matrices before hand
	
*/

module testArb(a, b, clk, rst, res);

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
	* finish(n) -> determine when (n)th/nd always@ finishes
	*/
	reg finish1;
	
	/*
	* state(n) -> moves around the FSM
	* a1, b1, res1, defined as matrices...by creating indices
	*/
	reg[1:0] state1;
	reg[7:0] a1[0:aRow-1][0:aCol-1];
	reg[7:0] b1[0:bRow-1][0:bCol-1];
	reg[7:0] res1[0:aRow-1][0:bCol-1];
	
	parameter s0 = 0, sDone = 1;

	// counters to set the matrices to 0...
	integer rSet, cSet;

	/*
	* i, j, k move through the indices.
	*/
	integer i, j, k;

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

	initial begin
		i <= 0; j <= 0; k <= 0;
		state1 <= 0;
		
		numElemA <= matrixALen/8;
		numElemB <= matrixBLen/8;
			
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

	end	
	
	// always block used to monitor the rst signal for loading...
	always@(posedge clk) begin
		if(!rst) begin
			$display("Loading in data...\n");
						
			//numElemA = (matrixALen/8) - 1;
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
	
	// computation 
	always@(posedge clk) begin
		
		if(aCol != bRow) begin
			$display("Columns in A != Rows in B!");			
		end
		
		else begin
			
			case(state1)
				s0: begin
					if(i < aRow) begin
						if(j < bCol) begin
							if(k < aCol) begin 
								res1[i][j] <= res1[i][j] + (a1[i][k] * b1[k][j]);
								k <= k + 1;
							end // end for if(k1 < aCol)
											
							else begin
								j <= j + 1;
								k <= 0;
							end // end for else(k1 < aCol)
									
						end // end for if(j1 < bCol)
								
						else begin
							state1 <= s0;
							i <= i + 1; 
							j <= 0; 
						end // end for else(j1 < bCol)		
					end // end for (i1 < firstBound)
					
					else begin
						state1 <= sDone;
						finish1 <= 1;
					end // end for else (i1 < firstBound)
					
				end // end for s0 of state1_1
				
				sDone: begin
					// done
				end
			
			endcase // endcase for state1_1
			
		end
		
	end	
	
	

endmodule 
