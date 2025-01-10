module solveBall(clock, resetn, gameStart, enable, ibsDone, SECollIn, PCollIn, xIBSIn, yIBSIn, directionIBSIn, PCollInner,
				 SECollDone, PCollDone, SECollInner,
				 ballTestSolved, ballSolved, xBallCoordOut, yBallCoordOut, xTestBallCoordOut, yTestBallCoordOut);
	input clock;
	input resetn;
	input gameStart;
	input enable;
	//input left;
	//input right;
	//input top;
	//input bottom;
	// left, right, top, bottom,
	input ibsDone;
	input [2:0] SECollIn;	//NOT DIRECTION, rather which edge has been triggered
	input [2:0] PCollIn;	//NOT DIRECTION, rather which edge has been triggered
	input [7:0] xIBSIn;		//initial coord
	input [6:0] yIBSIn;		//initial coord
	input [2:0] directionIBSIn;	//dir
	input PCollInner;
	input SECollDone;
	input PCollDone;
	
	input SECollInner;	//check for exotic inputs
	
	output reg ballTestSolved;
	output reg ballSolved;
	output reg [7:0] xBallCoordOut;
	output reg [6:0] yBallCoordOut;
	output reg [7:0] xTestBallCoordOut;
	output reg [6:0] yTestBallCoordOut;
	
	reg [2:0] currentDirection;
	
	always@(posedge clock) begin
		if(resetn) begin
			xBallCoordOut <= 8'b0;
			yBallCoordOut <= 7'b0;
			ballSolved <= 1'b0;
			xTestBallCoordOut <= 1'b0;
			yTestBallCoordOut <= 1'b0;
			ballTestSolved <= 1'b0;
		end
		else if(enable) begin
			if(((!SECollIn)||(!PCollIn))&&(ibsDone)) begin	//init case and SEC left right case - BOTH CASES RESPAWN IN THE MIDDLE!!
				//update using dirIBS
				//load and increment initial coord, load initial direction -- increment since init has already been drawn
				//HAVE TO LOAD ONCE PER IBS
				xBallCoordOut <= xIBSIn;
				//xTestBallCoordOut <= xIBSIn;	//DOES THIS MAKE SENSE?
				yBallCoordOut <= yIBSIn;
				//yTestBallCoordOut <= yIBSIn;
				currentDirection <= directionIBSIn;
				case(currentDirection)
					3'b01: begin
						xBallCoordOut <= xBallCoordOut - 4'd2;
						yBallCoordOut <= yBallCoordOut - 4'd2;
						ballSolved <= 1'b1;
					end
					3'b10: begin
						xBallCoordOut <= xBallCoordOut + 4'd2;
						yBallCoordOut <= yBallCoordOut - 4'd2;
						ballSolved <= 1'b1;
					end
					3'b11: begin
						xBallCoordOut <= xBallCoordOut + 4'd2;
						yBallCoordOut <= yBallCoordOut + 4'd2;
						ballSolved <= 1'b1;
					end
					3'b100: begin
						xBallCoordOut <= xBallCoordOut - 4'd2;
						yBallCoordOut <= yBallCoordOut + 4'd2;
						ballSolved <= 1'b1;
					end
					default: begin	//keep an eye for sync issues, i.e. whether directionIBSIn ever arrives as 000
						xBallCoordOut <= 8'b0;
						yBallCoordOut <= 7'b0;
						ballSolved <= 1'b0;
						xTestBallCoordOut <= 1'b0;
						yTestBallCoordOut <= 1'b0;
					end
				endcase
				if(ballSolved)
					ballSolved <= 1'b0;
			end
			
			//SEColl-----------------------------------------------
			else if((SECollIn==3'b01)||(SECollIn==3'b11)) begin	//SEC top bottom case
				//update direction using SECIn
				case(SECollIn) 	//will switch FSM - not true ball next_Direction, rather which edge has been triggered
					3'b01: begin	//top
						if (currentDirection == 3'b10) begin
							if(SECollInner) begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= (yTestBallCoordOut + 1'b1);
								currentDirection <= 3'b11;
								ballSolved <= 1'b1;
							end
							else begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b11;
								ballSolved <= 1'b1;
							end
						end	
						else if (currentDirection == 3'b01) begin
							if(SECollInner) begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= (yTestBallCoordOut + 1'b1);
								currentDirection <= 3'b100;
								ballSolved <= 1'b1;
							end
							else begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b100;
								ballSolved <= 1'b1;
							end
						end	
					end
					3'b11: begin	//bottom
						if (currentDirection == 3'b11) begin
							if(SECollInner) begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= (yTestBallCoordOut - 1'b1);
								currentDirection <= 3'b10;
								ballSolved <= 1'b1;
							end
							else begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b10;
								ballSolved <= 1'b1;
							end
						end	
						else if (currentDirection == 3'b100) begin
							if(SECollInner) begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= (yTestBallCoordOut - 1'b1);
								currentDirection <= 3'b01;
								ballSolved <= 1'b1;
							end
							else begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b01;
								ballSolved <= 1'b1;
							end
						end	
					end				
					default: begin	//keep an eye for sync issues, i.e. whether directionIBSIn ever arrives as 000
						xBallCoordOut <= 8'b0;
						yBallCoordOut <= 7'b0;
						ballSolved <= 1'b0;
						xTestBallCoordOut <= 1'b0;
						yTestBallCoordOut <= 1'b0;
					end
				endcase
	
				if(ballSolved)
					ballSolved <= 1'b0;
			end
			//SEColl------------------------------------------------
			//PColl
			else if(PCollIn) begin
				//PCollInner comes into play
				//update direction using PCollIn
				case(PCollIn)
					//begin left	
					3'b01: begin	//top left
						if (currentDirection == 3'b01) begin
							if(PCollInner) begin
								xBallCoordOut <= xTestBallCoordOut + 1'b1;
								yBallCoordOut <= (yTestBallCoordOut - 1'b1);
								currentDirection <= 3'b10;
								ballSolved <= 1'b1;
							end
							else begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b10;
								ballSolved <= 1'b1;
							end
						end	
						
						else if (currentDirection == 3'b101) begin
							if(PCollInner) begin
								xBallCoordOut <= xTestBallCoordOut + 1'b1;
								yBallCoordOut <= (yTestBallCoordOut - 1'b1);
								currentDirection <= 3'b10;
								ballSolved <= 1'b1;
							end
							else begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b10;
								ballSolved <= 1'b1;
							end
						end	
						
						else if (currentDirection == 3'b100) begin
							if(PCollInner) begin
								xBallCoordOut <= xTestBallCoordOut + 1'b1;
								yBallCoordOut <= (yTestBallCoordOut - 1'b1);
								currentDirection <= 3'b11;
								ballSolved <= 1'b1;
							end
							else begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b11;
								ballSolved <= 1'b1;
							end
						end	
					end
					3'b110: begin	//middle left
						if (currentDirection == 3'b01) begin
							if(PCollInner) begin
								xBallCoordOut <= xTestBallCoordOut + 1'b1;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b10;
								ballSolved <= 1'b1;
							end
							else begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b10;
								ballSolved <= 1'b1;
							end
						end	
						
						else if (currentDirection == 3'b101) begin
							if(PCollInner) begin
								xBallCoordOut <= xTestBallCoordOut + 1'b1;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b110;
								ballSolved <= 1'b1;
							end
							else begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b110;
								ballSolved <= 1'b1;
							end
						end	
						
						else if (currentDirection == 3'b100) begin
							if(PCollInner) begin
								xBallCoordOut <= xTestBallCoordOut + 1'b1;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b11;
								ballSolved <= 1'b1;
							end
							else begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b11;
								ballSolved <= 1'b1;
							end
						end	
					end
					3'b101: begin	//left bottom
						if (currentDirection == 3'b01) begin
							if(PCollInner) begin
								xBallCoordOut <= xTestBallCoordOut + 1'b1;
								yBallCoordOut <= (yTestBallCoordOut + 1'b1);
								currentDirection <= 3'b10;
								ballSolved <= 1'b1;
							end
							else begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b10;
								ballSolved <= 1'b1;
							end
						end	
						
						else if (currentDirection == 3'b101) begin
							if(PCollInner) begin
								xBallCoordOut <= xTestBallCoordOut + 1'b1;
								yBallCoordOut <= (yTestBallCoordOut + 1'b1);
								currentDirection <= 3'b11;
								ballSolved <= 1'b1;
							end
							else begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b11;
								ballSolved <= 1'b1;
							end
						end	
						
						else if (currentDirection == 3'b100) begin
							if(PCollInner) begin
								xBallCoordOut <= xTestBallCoordOut + 1'b1;
								yBallCoordOut <= (yTestBallCoordOut + 1'b1);
								currentDirection <= 3'b11;
								ballSolved <= 1'b1;
							end
							else begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b11;
								ballSolved <= 1'b1;
							end
						end	
					end
					//end left
					//begin right paddle
					3'b10: begin	//top right
						if (currentDirection == 3'b10) begin
							if(PCollInner) begin
								xBallCoordOut <= xTestBallCoordOut - 1'b1;
								yBallCoordOut <= (yTestBallCoordOut - 1'b1);
								currentDirection <= 3'b01;
								ballSolved <= 1'b1;
							end
							else begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b01;
								ballSolved <= 1'b1;
							end
						end	
						
						else if (currentDirection == 3'b110) begin
							if(PCollInner) begin
								xBallCoordOut <= xTestBallCoordOut - 1'b1;
								yBallCoordOut <= (yTestBallCoordOut - 1'b1);
								currentDirection <= 3'b01;
								ballSolved <= 1'b1;
							end
							else begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b01;
								ballSolved <= 1'b1;
							end
						end	
						
						else if (currentDirection == 3'b11) begin
							if(PCollInner) begin
								xBallCoordOut <= xTestBallCoordOut - 1'b1;
								yBallCoordOut <= (yTestBallCoordOut - 1'b1);
								currentDirection <= 3'b100;
								ballSolved <= 1'b1;
							end
							else begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b100;
								ballSolved <= 1'b1;
							end
						end	
					end	//case end 3 cases before end
					3'b11: begin	//middle right
						if (currentDirection == 3'b10) begin
							if(PCollInner) begin
								xBallCoordOut <= xTestBallCoordOut - 1'b1;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b01;
								ballSolved <= 1'b1;
							end
							else begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b01;
								ballSolved <= 1'b1;
							end
						end	
						
						else if (currentDirection == 3'b110) begin
							if(PCollInner) begin
								xBallCoordOut <= xTestBallCoordOut - 1'b1;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b101;
								ballSolved <= 1'b1;
							end
							else begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b101;
								ballSolved <= 1'b1;
							end
						end	
						
						else if (currentDirection == 3'b11) begin
							if(PCollInner) begin
								xBallCoordOut <= xTestBallCoordOut - 1'b1;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b100;
								ballSolved <= 1'b1;
							end
							else begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b100;
								ballSolved <= 1'b1;
							end
						end	
					end
					3'b100: begin	//bottom right
						if (currentDirection == 3'b10) begin
							if(PCollInner) begin
								xBallCoordOut <= xTestBallCoordOut - 1'b1;
								yBallCoordOut <= yTestBallCoordOut + 1'b1;
								currentDirection <= 3'b01;
								ballSolved <= 1'b1;
							end
							else begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b01;
								ballSolved <= 1'b1;
							end
						end	
						
						else if (currentDirection == 3'b110) begin
							if(PCollInner) begin
								xBallCoordOut <= xTestBallCoordOut - 1'b1;
								yBallCoordOut <= yTestBallCoordOut + 1'b1;
								currentDirection <= 3'b100;
								ballSolved <= 1'b1;
							end
							else begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b100;
								ballSolved <= 1'b1;
							end
						end	
						
						else if (currentDirection == 3'b11) begin
							if(PCollInner) begin
								xBallCoordOut <= xTestBallCoordOut - 1'b1;
								yBallCoordOut <= yTestBallCoordOut + 1'b1;
								currentDirection <= 3'b100;
								ballSolved <= 1'b1;
							end
							else begin
								xBallCoordOut <= xTestBallCoordOut;
								yBallCoordOut <= yTestBallCoordOut;
								currentDirection <= 3'b100;
								ballSolved <= 1'b1;
							end
						end	
					end
					//end right
					default: begin	//keep an eye for sync issues, i.e. whether directionIBSIn ever arrives as 000
							xBallCoordOut <= 8'b0;
							yBallCoordOut <= 7'b0;
							ballSolved <= 1'b0;
							xTestBallCoordOut <= 1'b0;
							yTestBallCoordOut <= 1'b0;
						end
				endcase
				if(ballSolved)
					ballSolved <= 1'b0;
			end
			//end Pcoll
			else begin		//normal, not reset, not coll case
				//keep going in the same direction, increment - not reset, not edge coll, not paddle coll
				if((!SECollDone)&&(!PCollDone)) begin
					xTestBallCoordOut <= xBallCoordOut;	//makes sure that temp and current are on the same page
					yTestBallCoordOut <= yBallCoordOut;
					
					case(currentDirection)
						3'b01: begin
							xTestBallCoordOut <= xTestBallCoordOut - 4'd2;
							yTestBallCoordOut <= yTestBallCoordOut - 4'd2;
							ballTestSolved <= 1'b1;
						end
						3'b10: begin
							xTestBallCoordOut <= xTestBallCoordOut + 4'd2;
							yTestBallCoordOut <= yTestBallCoordOut - 4'd2;
							ballTestSolved <= 1'b1;
						end
						3'b11: begin
							xTestBallCoordOut <= xTestBallCoordOut + 4'd2;
							yTestBallCoordOut <= yTestBallCoordOut + 4'd2;
							ballTestSolved <= 1'b1;
						end
						3'b100: begin
							xTestBallCoordOut <= xTestBallCoordOut - 4'd2;
							yTestBallCoordOut <= yTestBallCoordOut + 4'd2;
							ballTestSolved <= 1'b1;
						end
						3'b101: begin
							xTestBallCoordOut <= xTestBallCoordOut + 4'd2;
							yTestBallCoordOut <= yTestBallCoordOut;
							ballTestSolved <= 1'b1;
						end
						3'b110: begin
							xTestBallCoordOut <= xTestBallCoordOut - 4'd2;
							yTestBallCoordOut <= yTestBallCoordOut;
							ballTestSolved <= 1'b1;
						end
						default: begin
							xBallCoordOut <= 8'b0;
							yBallCoordOut <= 7'b0;
							ballSolved <= 1'b0;
							ballTestSolved <= 1'b0;
							xTestBallCoordOut <= 1'b0;
							yTestBallCoordOut <= 1'b0;
						end
					endcase
					if(ballTestSolved)
						ballTestSolved <= 1'b0;
				end
				else if ((SECollDone)&&(PCollDone)) begin	//visited collision functions, found nothing, test coordinates approved
					xBallCoordOut <= xTestBallCoordOut;
					yBallCoordOut <= yTestBallCoordOut;
					ballSolved <= 1'b1;
					if(ballSolved)
						ballSolved <= 1'b0;
				end
			end
		end
	end
endmodule
	