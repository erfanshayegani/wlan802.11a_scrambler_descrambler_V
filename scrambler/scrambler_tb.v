`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:18:21 12/29/2020
// Design Name:   scrambler
// Module Name:   S:/erfan/SUT/Term7/FPGA/PROJECT_WLAN/scrambler/scrambler/scrambler_tb.v
// Project Name:  scrambler
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: scrambler
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module scrambler_tb;

	// Inputs
	reg clk;
	reg reset;
	reg data;

	// Outputs
	wire scrambled_data;

	// Instantiate the Unit Under Test (UUT)
	scrambler uut (
		.clk(clk), 
		.reset(reset), 
		.data(data), 
		.scrambled_data(scrambled_data)
	);
	integer op1,k,opout;
	// pointers to files must be of type integer
	
	initial 
	begin
		clk = 0;reset = 0;data = 0;
	end
   
	always #10 clk = ~clk; 
	initial #20 reset = 1;
	
	initial
	begin
		op1 = $fopen("data_tb.txt","r"); // this is the data (raw data needs to be scrambled)
		opout = $fopen("tb_outttt.txt","w"); // this will update the file and if it doesn't exist,it creates it first
		// u can use "a" instead of "w" to append to the EOF.
	end
	
	always@(posedge clk)
	begin
	k = $fscanf(op1,"%b\n",data); //reads a line, in the next clk goes to the next line and ... (\n)
	#10 $fwrite(opout,"%b",scrambled_data); // after 10 ns after each posedge it writes the output to the file
	// since I did not put \n, it writes to the file in one row! serialized
	// If I had put \n the output file would have contained a coloumn instead of a row
	$display("output is %b \n",scrambled_data); // since I have put this line after #10 fwrite ...
	// and we know inside the initial and always blocks are executed in series, this line outputs its vars
	// after 10ns after each posedge! in fact these last 2 lines are done simulatanesously
	
	if ($feof(op1))
		$finish;
		// this one terminates the simul when ot reaches the last bit of the file
		//imagine last bits are 0010101
		// when it reaches the last1, $feof returns 1 so we have to terminate the simul
	
	// note that inside always blocks executes in series so the correct place for this line(feof) is here.
	// we should get the last bit and then, terminate the simul.
	end


endmodule

