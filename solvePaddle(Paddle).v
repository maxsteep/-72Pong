module Paddle(clock, resetn, startSolve, UserInput, isActive, yPaddleCoord, isSolved);
	input clock;//UNUSED RIGHT NOW
	input resetn;
	input startSolve;
	input [1:0] UserInput;
	input isActive;
	
	output reg [6:0] yPaddleCoord;
	output reg isSolved;
	
	
	always@(posedge clock) begin//posedge framecounter //CHANGE FROM POSEDGE CLOCK - RECHECK RECHECK
		if (resetn) begin
				yPaddleCoord <= 6'd56;
				isSolved <= 0;
		end
		else begin	//pulse
				if ((startSolve)&&(!isSolved)&&(isActive)) begin
					case(UserInput)
						2'b00:  begin	//DO WE NEED AN FSM FOR CORRENT USER INPUT PARSE
									yPaddleCoord <= yPaddleCoord;
									isSolved <= 1;	//??? order of things that happen check
								end
						2'b10:  if (yPaddleCoord > 7) begin	//up to 0
									yPaddleCoord <= yPaddleCoord - 8;
									isSolved <= 1;
								end
								else begin
									yPaddleCoord <= yPaddleCoord;
									isSolved <= 1;
								end
						2'b01:	if (yPaddleCoord < 112)	begin //down to 119
									yPaddleCoord <= yPaddleCoord + 8;
									isSolved <= 1;
								end
								else begin
									yPaddleCoord <= yPaddleCoord;
									isSolved <= 1;
								end
						default: begin
									yPaddleCoord <= yPaddleCoord;
									isSolved <= 0;
								end
					endcase
				end
				else if(!isActive) begin
					isSolved <= 0;
				end
		end
	end
endmodule	