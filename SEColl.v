module SEColl(clock, resetn, gameStart, enable, xBallCoordIn, yBallCoordIn, SECollOut, SECollDone, SECollInner);
	input clock;
	input resetn;
	input gameStart;
	input enable;
	
	input [7:0] xBallCoordIn;
	input [6:0] yBallCoordIn;
	
	output reg [2:0] SECollOut;	//will switch FSM - not true ball next_Direction, rather which edge has been triggered
	output reg SECollDone;
	output reg SECollInner;
	
	//wire [6:0] top = 1'b0;
	//wire [6:0] bottom = 7'd119;
	
	always@(*) begin
		if(resetn) begin
			SECollOut <= 1'b0;	    //will switch FSM - not true ball next_Direction, rather which edge has been triggered
			SECollDone <= 1'b0;	
			SECollInner <= 1'b0;
		end
		else if(enable) begin
			if(yBallCoordIn == 7'b0) begin				//top
				SECollOut <= 3'b01;													//fsm to solveBall
				SECollDone <= 1'b1;
				if(SECollDone)
					SECollDone <= 1'b0;
			end
			else if(yBallCoordIn == 7'd127) begin		//top	inner
				SECollOut <= 3'b01;													//fsm to solveBall
				SECollDone <= 1'b1;
				SECollInner <= 1'b1;
				if(SECollDone)
					SECollDone <= 1'b0;
				if(SECollInner)
					SECollInner <= 1'b0;
			end
			else if(yBallCoordIn == 7'd119) begin		//bottom
				SECollOut <= 3'b11;													//fsm to solveBall
				SECollDone <= 1'b1;
				if(SECollDone)
					SECollDone <= 1'b0;
			end
			else if(yBallCoordIn == 7'd120) begin		//bottom	inner
				SECollOut <= 3'b11;													//fsm to solveBall
				SECollDone <= 1'b1;
				if(SECollDone)
					SECollDone <= 1'b0;
				SECollInner <= 1'b1;
				if(SECollInner)
					SECollInner <= 1'b0;
			end
			else if(xBallCoordIn == 8'b0) begin			//left
				SECollOut <= 3'b100;												//fsm to IBS, update score respawn ball
				SECollDone <= 1'b1;
				if(SECollDone)
					SECollDone <= 1'b0;
			end
			else if(xBallCoordIn == 8'd255) begin			//left	inner
				SECollOut <= 3'b100;												//fsm to IBS, update score respawn ball
				SECollDone <= 1'b1;
				if(SECollDone)
					SECollDone <= 1'b0;
				SECollInner <= 1'b1;
				if(SECollInner)
					SECollInner <= 1'b0;
			end
			else if(xBallCoordIn == 8'd160)	 begin		//right
				SECollOut <= 3'b10;													//fsm to IBS, update score respawn ball
				SECollDone <= 1'b1;
				if(SECollDone)
					SECollDone <= 1'b0;
			end
			else if(xBallCoordIn == 8'd160)	 begin		//right	inner
				SECollOut <= 3'b10;													//fsm to IBS, update score respawn ball
				SECollDone <= 1'b1;
				if(SECollDone)
					SECollDone <= 1'b0;
				SECollInner <= 1'b1;
				if(SECollInner)
					SECollInner <= 1'b0;
			end
			else begin	//no coll case
				SECollOut <= 3'b000;												//fsm to solveBall
				SECollDone <= 1'b1;
				if(SECollDone)
					SECollDone <= 1'b0;
			end
		end
	end
endmodule
//need done flag