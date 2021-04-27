//ALTSQRT CBX_SINGLE_OUTPUT_FILE="ON" PIPELINE=1 Q_PORT_WIDTH=8 R_PORT_WIDTH=9 WIDTH=16 clk q radical remainder
//VERSION_BEGIN 19.1 cbx_mgl 2019:09:22:11:02:15:SJ cbx_stratixii 2019:09:22:11:00:28:SJ cbx_util_mgl 2019:09:22:11:00:28:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Copyright (C) 2019  Intel Corporation. All rights reserved.
//  Your use of Intel Corporation's design tools, logic functions 
//  and other software and tools, and any partner logic 
//  functions, and any output files from any of the foregoing 
//  (including device programming or simulation files), and any 
//  associated documentation or information are expressly subject 
//  to the terms and conditions of the Intel Program License 
//  Subscription Agreement, the Intel Quartus Prime License Agreement,
//  the Intel FPGA IP License Agreement, or other applicable license
//  agreement, including, without limitation, that your use is for
//  the sole purpose of programming logic devices manufactured by
//  Intel and sold by Intel or its authorized distributors.  Please
//  refer to the applicable agreement for further details, at
//  https://fpgasoftware.intel.com/eula.



//synthesis_resources = ALTSQRT 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  mg44a
	( 
	clk,
	q,
	radical,
	remainder) /* synthesis synthesis_clearbox=1 */;
	input   clk;
	output   [7:0]  q;
	input   [15:0]  radical;
	output   [8:0]  remainder;

	wire  [7:0]   wire_mgl_prim1_q;
	wire  [8:0]   wire_mgl_prim1_remainder;

	ALTSQRT   mgl_prim1
	( 
	.clk(clk),
	.q(wire_mgl_prim1_q),
	.radical(radical),
	.remainder(wire_mgl_prim1_remainder));
	defparam
		mgl_prim1.pipeline = 1,
		mgl_prim1.q_port_width = 8,
		mgl_prim1.r_port_width = 9,
		mgl_prim1.width = 16;
	assign
		q = wire_mgl_prim1_q,
		remainder = wire_mgl_prim1_remainder;
endmodule //mg44a
//VALID FILE
