`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:36:32 12/29/2020 
// Design Name: 
// Module Name:    scrambler 
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
//////////////////////////////////////////////////////////////////////////////////
module scrambler(
    input wire clk,
    input wire reset,
    input wire data,
    output wire scrambled_data
    );

	reg [7:1]seed;
	wire seq;
	
	assign seq = seed[7] ^ seed[4];
	assign scrambled_data = data ^ seq;
	
	integer k;
	always@(posedge clk or negedge reset)
	begin
		if(!reset)
		begin
			seed <= 7'b101_1101;
		end
		else
		begin
			seed[1] <= seq;
			for (k=1;k<7;k=k+1)
				seed[k+1]<=seed[k];
		end
	
	end
endmodule
