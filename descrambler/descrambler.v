`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:50:06 12/30/2020 
// Design Name: 
// Module Name:    descrambler 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
/////////////////////////////////////////////////////////////////////////////////
module descrambler(
    input wire clk,
    input wire reset,
    input wire rx,
    output wire descrambled_data
    );
	 
	reg [7:1]seed;
	reg [7:1]temp; // save 6 first bits of input here 
	wire seq;
	
	assign seq = seed[7] ^ seed[4];
	assign descrambled_data = rx ^ seq;
	
	reg [3:0]n; 
	integer k;
	always@(posedge clk or negedge reset)
	begin
		if(!reset)
		begin
			n <= 0; // this is our counter which helps us know which state we are in
		end
		/////////////////////for the first 7 clocks we store rx of last clk into temp in this clk///////////
		/////then at the posedge of the 8th clk, we initialize the seed! so the circuit starts working/////
		/// and jumps out of (n < 7) block into the else block.
		else if (n < 7)
		begin
			if (n == 6)
			begin 
				seed <={temp[7:2],rx};
				n <= n+1;
			end
			else
			begin
				temp[7-n] <= rx;
				n <= n+1;
			end
		end
		//////////////////////////////////
		else
		begin
			seed[1] <= seq;
			for (k=1;k<7;k=k+1)
				seed[k+1]<=seed[k];
		end
		
	end
endmodule
