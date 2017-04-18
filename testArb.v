// ECE 5367
// Author: Nicholas Archibong
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
	reg[1:0] state1, state2, state3;
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
		i <= 0; j <= 0; k <= 0;
		state1 <= 0; state2 <= 0; state3 <= 0;
		
		aChunk <= matrixALen/8;
		bChunk <= matrixBLen/8;
			
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
						
			//aChunk = (matrixALen/8) - 1;
			
			// start loading of data...
			for(rSet=0; rSet < aRow; rSet=rSet+1) begin
				
				chunkA = aChunk/(rSet + 1) - 1; // updates the chunk with the previous values
				
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
	
	// computation 
	always@(posedge clk) begin
		
		if(aCol != bRow) begin
			$display("Columns in A != Rows in B!");			
		end
		
		else begin
			
			case(state1)
				s0: begin
					if(i < aRow) begin
						state2 <= s0;
						
						case(state2)
							s0: begin
								if(j < bCol) begin
									state3 <= s0;
									
									case(state3)
										s0: begin
											if(k < aCol) begin 
												res1[i][j] <= res1[i][j] + (a1[i][k] * b1[k][j]);
												k <= k + 1;
											end // end for if(k1 < aCol)
											
											else begin
												state2 <= s0;
												j <= j + 1;
												k <= 0;
											end // end for else(k1 < aCol)
											
										end // end for s0 of state1_3
										
									endcase // endcase for state1_3
									
								end // end for if(j1 < bCol)
								
								else begin
									state1 <= s0;
									i <= i + 1; 
									j <= 0; 
								end // end for else(j1 < bCol)
								
							end // end for s0 of state1_2
							
						endcase // endcase for state1_2
						
					end // end for (i1 < firstBound)
					
					else begin
						state1 <= sDone;
						finish1 <= 1;
					end // end for else (i1 < firstBound)
					
				end // end for s0 of state1_1
			
			endcase // endcase for state1_1
			
		end
		
	end	
	
	

endmodule 
