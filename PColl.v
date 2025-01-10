module PColl(clock, resetn, gameStart, enable, yLeftPaddleCoordIn, yRightPaddleCoordIn, xBallCoordIn, yBallCoordIn, PCollInner, PCollOut, PCollDone);
	input clock;
	input resetn;
	input gameStart;
	input enable;
	
	input [6:0] yLeftPaddleCoordIn;
	input [6:0] yRightPaddleCoordIn;
	input [7:0] xBallCoordIn;
	input [6:0] yBallCoordIn;
	
	output reg PCollInner;
	output reg [2:0] PCollOut;
	output reg PCollDone;
	
	always@(*) begin
		if(resetn) begin
			PCollOut <= 3'b000;
			PCollInner <= 1'b0;
			PCollDone <= 1'b0;
		end
		else if(enable) begin
			case(xBallCoordIn) 
				8'b00100111: begin //39
					if(yLeftPaddleCoordIn == (yBallCoordIn + 2'd2)) begin					//top left paddle hit
						PCollOut <= 3'b01;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end
					else if((yLeftPaddleCoordIn + 4'd8) == (yBallCoordIn + 2'd2)) begin	//bottom left paddle hit
						PCollOut <= 3'b101;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
					else if ((yLeftPaddleCoordIn + 4'd1) == (yBallCoordIn + 2'd2)) begin	//inner top left paddle hit
						PCollOut <= 3'b01;
						PCollInner <= 1'b1;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;					
						if (PCollInner)
							PCollInner <= 1'b0;
					end
					else if((yLeftPaddleCoordIn + 4'd7) == (yBallCoordIn + 2'd2)) begin	//inner bottom left paddle hit
						PCollOut <= 3'b101;
						PCollInner <= 1'b1;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
						if (PCollInner)
							PCollInner <= 0;
					end
				end
				8'b00101000: begin //40
					if(yLeftPaddleCoordIn == (yBallCoordIn + 2'd2))	begin				//top left paddle hit
						PCollOut <= 3'b01;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end
					else if((yLeftPaddleCoordIn + 4'd8) == (yBallCoordIn + 2'd2)) begin	//bottom left paddle hit
						PCollOut <= 3'b101;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
					
					//inner collision begin
					//top left paddle hit
					else if((yLeftPaddleCoordIn + 4'd1) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b01;
						PCollInner <= 1'b1;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
						if (PCollInner)
							PCollInner <= 1'b0;
					end
					else if((yLeftPaddleCoordIn + 4'd2) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b01;
						PCollInner <= 1'b1;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
						if (PCollInner)
							PCollInner <= 1'b0;
					end
					//center left paddle hit
					else if((yLeftPaddleCoordIn + 4'd3) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b110;
						PCollInner <= 1'b1;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
						if (PCollInner)
							PCollInner <= 1'b0;
					end
					else if((yLeftPaddleCoordIn + 4'd4) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b110;
						PCollInner <= 1'b1;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
						if (PCollInner)
							PCollInner <= 1'b0;
					end
					else if((yLeftPaddleCoordIn + 4'd5) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b110;
						PCollInner <= 1'b1;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
						if (PCollInner)
							PCollInner <= 1'b0;
					end
					//bottom left paddle hit
					else if((yLeftPaddleCoordIn + 4'd6) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b101;
						PCollInner <= 1'b1;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
						if (PCollInner)
							PCollInner <= 1'b0;
					end
					else if((yLeftPaddleCoordIn + 4'd7) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b101;
						PCollInner <= 1'b1;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
						if (PCollInner)
							PCollInner <= 1'b0;
					end
					//inner collision end
				end
				8'b00101001: begin //41												//side paddle compare
					//top left paddle hit
					if(yLeftPaddleCoordIn == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b01;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
					else if((yLeftPaddleCoordIn + 4'd1) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b01;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
					else if((yLeftPaddleCoordIn + 4'd2) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b01;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
					//center left paddle hit
					else if((yLeftPaddleCoordIn + 4'd3) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b110;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
					else if((yLeftPaddleCoordIn + 4'd4) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b110;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
					else if((yLeftPaddleCoordIn + 4'd5) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b110;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
					//bottom left paddle hit
					else if((yLeftPaddleCoordIn + 4'd6) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b101;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
					else if((yLeftPaddleCoordIn + 4'd7) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b101;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
					else if((yLeftPaddleCoordIn + 4'd8) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b101;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
				end
				//left end---------------------------------------------------------------
				
				//right start------------------------------------------------------------
				8'b01110111: begin //119
					//9 cases
					//top right paddle hit
					if(yRightPaddleCoordIn == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b10;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
					else if((yRightPaddleCoordIn + 4'd1) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b10;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
					else if((yRightPaddleCoordIn + 4'd2) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b10;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
					//center right paddle hit
					else if((yRightPaddleCoordIn + 4'd3) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b11;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
					else if((yRightPaddleCoordIn + 4'd4) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b11;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
					else if((yRightPaddleCoordIn + 4'd5) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b11;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
					//bottom right paddle hit
					else if((yRightPaddleCoordIn + 4'd6) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b100;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
					else if((yRightPaddleCoordIn + 4'd7) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b100;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
					else if((yRightPaddleCoordIn + 4'd8) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b100;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
				end
				8'b01111000: begin //120
					if((yRightPaddleCoordIn) == (yBallCoordIn + 2'd2)) begin			//top right paddle hit
						PCollOut <= 3'b10;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
					else if((yRightPaddleCoordIn + 4'd8) == (yBallCoordIn + 2'd2)) begin	//bottom right paddle hit
						PCollOut <= 3'b100;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
					
					//inner collision begin
					//top right paddle hit
					else if((yRightPaddleCoordIn + 4'd1) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b10;
						PCollInner <= 1'b1;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
						if (PCollInner)
							PCollInner <= 1'b0;
					end
					else if((yRightPaddleCoordIn + 4'd2) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b10;
						PCollInner <= 1'b1;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
						if (PCollInner)
							PCollInner <= 1'b0;
					end
					//center right paddle hit
					else if((yRightPaddleCoordIn + 4'd3) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b11;
						PCollInner <= 1'b1;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
						if (PCollInner)
							PCollInner <= 1'b0;
					end
					else if((yRightPaddleCoordIn + 4'd4) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b11;
						PCollInner <= 1'b1;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
						if (PCollInner)
							PCollInner <= 1'b0;
					end
					else if((yRightPaddleCoordIn + 4'd5) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b11;
						PCollInner <= 1'b1;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
						if (PCollInner)
							PCollInner <= 1'b0;
					end
					//bottom right paddle hit
					else if((yRightPaddleCoordIn + 4'd6) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b100;
						PCollInner <= 1'b1;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
						if (PCollInner)
							PCollInner <= 1'b0;
					end
					else if((yRightPaddleCoordIn + 4'd7) == (yBallCoordIn + 2'd2)) begin
						PCollOut <= 3'b100;
						PCollInner <= 1'b1;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
						if (PCollInner)
							PCollInner <= 1'b0;
					end
					//inner collision end
				end
				8'b01111001: begin //121
					if((yRightPaddleCoordIn) == (yBallCoordIn + 2'd2)) begin				//top right paddle hit
						PCollOut <= 3'b10;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
					else if((yRightPaddleCoordIn + 4'd8) == (yBallCoordIn + 2'd2)) begin //bottom right paddle hit
						PCollOut <= 3'b100;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
					end	
						
					else if((yRightPaddleCoordIn + 4'd1) == (yBallCoordIn + 2'd2))  begin	//inner right paddle hit
						PCollOut <= 3'b10;
						PCollInner <= 1'b1;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
						if (PCollInner)
							PCollInner <= 1'b0;
					end
					else if((yRightPaddleCoordIn + 4'd7) == (yBallCoordIn + 2'd2))  begin  //inner right paddle hit
						PCollOut <= 3'b100;
						PCollInner <= 1'b1;
						PCollDone <= 1'b1;
						if(PCollDone)
							PCollDone <= 1'b0;
						if (PCollInner)
							PCollInner <= 1'b0;
					end
				end
				default: begin	//default case no p coll
							PCollOut <= 3'b000;
							PCollInner <= 1'b0;
							PCollDone <= 1'b1;
							if(PCollDone)
								PCollDone <= 1'b0;
						 end
			//end
			endcase
		end
	end
endmodule