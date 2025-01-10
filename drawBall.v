module drawBall(clock, resetn, gameStart, enable, xBallCoordIn, yBallCoordIn, xBallOut, yBallOut, doneBallDraw);
	input clock;
	input resetn;
	input gameStart;
	input enable;
	
	input [7:0] xBallCoordIn;
	input [6:0] yBallCoordIn;
	
	reg [2:0] counter;
	
	output reg [7:0] xBallOut;
	output reg [6:0] yBallOut;
	output reg doneBallDraw;
	
	always@(posedge clock) begin
		if(resetn) begin
			xBallOut <= 0;
			yBallOut <= 0;
			doneBallDraw <= 0;
			counter <= 0;
		end
		else if(enable) begin
			if(!doneBallDraw) begin
				if(counter == 2'b00) begin	//0
					xBallOut <= xBallCoordIn;
					yBallOut <= yBallCoordIn;
					counter <= counter + 1'b1;
				end
				else if(counter == 2'b01) begin	//1
					xBallOut <= xBallCoordIn + 1'b1;
					yBallOut <= yBallCoordIn;
					counter <= counter + 1'b1;
				end
				else if(counter == 2'b10) begin	//2
					xBallOut <= xBallCoordIn;
					yBallOut <= yBallCoordIn + 1'b1;
					counter <= counter + 1'b1;
				end
				else if(counter == 2'b11) begin	//3
					xBallOut <= xBallCoordIn + 1'b1;
					yBallOut <= yBallCoordIn + 1'b1;
					counter <= counter + 1'b1;
				end
				else 
					doneBallDraw <= 1;
			end
			else begin
				counter <= 0;
				doneBallDraw <= 0;
			end
		end
	end
endmodule
