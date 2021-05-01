
module embedded_soc (
	clk_clk,
	led_export,
	reset_reset_n,
	switches_export,
	buttons_export,
	nios_input_export_export,
	nios_output_export_export);	

	input		clk_clk;
	output	[9:0]	led_export;
	input		reset_reset_n;
	input	[9:0]	switches_export;
	input	[3:0]	buttons_export;
	input	[31:0]	nios_input_export_export;
	output	[31:0]	nios_output_export_export;
endmodule
