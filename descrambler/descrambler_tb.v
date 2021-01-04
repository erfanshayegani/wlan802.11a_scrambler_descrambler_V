`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:51:53 12/30/2020
// Design Name:   descrambler
// Module Name:   S:/erfan/SUT/Term7/FPGA/PROJECT_WLAN/descrambler/descrambler/descrambler_tb.v
// Project Name:  descrambler
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: descrambler
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module descrambler_tb;

	// Inputs
	reg clk;
	reg reset;
	reg rx;

	// Outputs
	wire descrambled_data;

	// Instantiate the Unit Under Test (UUT)
	descrambler uut (
		.clk(clk), 
		.reset(reset), 
		.rx(rx), 
		.descrambled_data(descrambled_data)
	);
	integer op1,k,opout;
	// pointers to files must be of type integer
	
	initial 
	begin
		clk = 0;reset = 0;rx = 0;
	end
   
	always #10 clk = ~clk; 
	initial #20 reset = 1;
	
	initial
	begin
		op1 = $fopen("rx.txt","r"); // this is the data received to be descrambled
		// note that it must be a coloumn not a row, i mean like a 864*1 matrix not a 1*864
		// thats the way k = $fscanf(op1,"%b\n",rx); reads each line
		opout = $fopen("descrambled_data.txt","w"); // this will update the file and if it doesn't exist,it creates it first
		// u can use "a" instead of "w" to append to the EOF.
	end
	
	always@(posedge clk)
	begin
	k = $fscanf(op1,"%b\n",rx); // reads each line and places it in data at every posedge clk
	
	// after 10 ns after each posedge it writes the output to the file
	// since I did not put \n, it writes to the file in one row! serialized
	// If I had put \n the output file would have contained a coloumn instead of a row
	#10 $fwrite(opout,"%b",descrambled_data);
	$display("output is %b \n",descrambled_data);
	// since I have put this line after #10 fwrite ...
	// and we know inside the initial and always blocks are executed in series, this line outputs its vars
	// after 10ns after each posedge! in fact these last 2 lines are done simulatanesously!
	
	
	if ($feof(op1))
		$finish;
		// this one terminates the simul when ot reaches the last bit of the file
		//imagine last bits are 0010101
		// when it reaches the last1, $feof returns 1 so we have to terminate the simul
	 
	
	end
endmodule

