module drawPaddle(clock, resetn, xIn, yIn, startDrawPaddle, isActive, xPaddleOut, yPaddleOut, donePaddle);
	input clock;
	input resetn;
	input [7:0] xIn;
	input [6:0] yIn;
	input startDrawPaddle;
	input isActive;
	
	output reg [7:0] xPaddleOut;
	output reg [6:0] yPaddleOut;
	output reg donePaddle;
	
	reg [3:0] counterY;//2:0 ?? - the bit size check
	reg [1:0] counterX;
	
	always@(posedge clock) begin
		if (resetn) begin
			counterY <= 0;
			counterX <= 0;
			donePaddle <= 0;
			xPaddleOut <= 8'b0;
			yPaddleOut <= 7'b0;
		end 
		else if ((startDrawPaddle)&&(isActive)) begin
			if (!donePaddle) 					  begin
				if ((counterX > 1)&&(counterY < 7)) begin
					xPaddleOut <= xPaddleOut;
					yPaddleOut <= yIn + counterY;
					counterY <= (counterY + 1'b1);
					counterX <= 0;
					//drive x
				end
				else begin 
					yPaddleOut <= yIn + counterY;	//We want this 
					xPaddleOut <= xIn + counterX;
					counterX <= (counterX + 1'b1);
					counterY <= counterY;
					//drive y
				end
				
				if((counterY == 3'd7) && (counterX == 3'd1)) begin
					donePaddle <= 1'b1;
					counterY <= 0;
					counterX <= 0;
				end
				//else 
					//donePaddle <= 1'b0;
			end	
			else begin
					counterY <= 0;
					counterX <= 0;
					donePaddle <= 0;
					xPaddleOut <= 0;
					yPaddleOut <= 0;
			end		
		end
	end
endmodule