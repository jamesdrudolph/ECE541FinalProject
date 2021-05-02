	embedded_soc u0 (
		.clk_clk            (<connected-to-clk_clk>),            //         clk.clk
		.led_export         (<connected-to-led_export>),         //         led.export
		.reset_reset_n      (<connected-to-reset_reset_n>),      //       reset.reset_n
		.switches_export    (<connected-to-switches_export>),    //    switches.export
		.buttons_export     (<connected-to-buttons_export>),     //     buttons.export
		.nios_input_export  (<connected-to-nios_input_export>),  //  nios_input.export
		.nios_output_export (<connected-to-nios_output_export>)  // nios_output.export
	);

