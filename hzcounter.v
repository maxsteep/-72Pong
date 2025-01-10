module hz4Counter (clock, resetn, gameStart, frameCounter);
	input clock;
	input resetn;
	input gameStart;
	
	reg [26:0] counter;
	
	output reg frameCounter;
	
	always@(posedge clock) begin
		if((gameStart)||(resetn))
			begin
				if (frameCounter) begin
					counter <= 0;
					frameCounter <= 0;
				end
				else begin
					case(resetn)
						1: begin
							counter <= 0;
							frameCounter <= 0;
						end
						0: begin
							counter <= counter + 1'b1;
							frameCounter <= (counter == 26'd3333333) ? 1'b1 : 1'b0;
						end						
						default: begin
									counter <= 0;
									frameCounter <= 0;
								end
					endcase
				end
			end
	end
	
	//for smooth motion desk next to us had d1250000 - 1,250,000
	//50,000,000 per second - 60HZ on screen, need 15fps - 15 "toggles" per second - therefore we need 3.333.333,33		
endmodule