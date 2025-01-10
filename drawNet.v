module drawNet (clock, gameStart, resetn, netDone, yNetOut);
	input clock;
	input resetn;
	input gameStart;
	
	//output reg [7:0] xNetOut;
	output reg netDone;
	output reg [6:0] yNetOut;
	
	reg [6:0] counterY;
	reg [1:0] counterC;
	
	always@(posedge clock) begin
		if (resetn) begin
			netDone <= 1'b0;
			yNetOut <= 0;
			counterY <= 0;
			counterC <= 0;
		end
		else if((gameStart)&&(!netDone)) begin
			if(counterY < 120) begin
				yNetOut = counterY;
				counterY = counterY + 1'b1;
				counterC = counterC + 1'b1;
				if(counterC == 2'd2) begin
					counterC = 1'b0;
					counterY = counterY + 2'd2;
				end //else
					//counterY <= counterY + 1'b1;
					
			end
			else
				netDone <= 1'b1;
		end
	end
endmodule