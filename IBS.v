module IBS(clock, resetn, gameStart, enable, SEColl, spawnLFSRIn, dirLFSRIn, ibsDone, xIBSOut, yIBSOut, directionIBS);
	input clock;
	input resetn;
	input gameStart;
	input enable;
	
	input [2:0] SEColl;
	input [6:0] spawnLFSRIn;
	input [2:0] dirLFSRIn;
	
	output reg ibsDone;
	output reg [7:0] xIBSOut;
	output reg [6:0] yIBSOut;
	output reg [2:0] directionIBS;
	//00 left top
	//01 right top
	//10 right bottom - less likely - 000
	//11 left bottom
	
	reg [2:0] tempDir;
	reg initFlag;
	
	always@(posedge clock) begin
		if (resetn) begin
			ibsDone <= 0;
			xIBSOut <= 8'd79;
			yIBSOut <= 7'b0;
			directionIBS <= 0;
			initFlag <= 0;	
		end
		else if(enable) begin
			if((SEColl!=3'b100)&&(SEColl!=3'b10)&&(!initFlag)) begin		//only initFlag matters - SENDS TRUE DIRECTION - ONLY VISITED ON RESET
				yIBSOut <= spawnLFSRIn;
				
				if ((dirLFSRIn==3'b001)||(dirLFSRIn==3'b010)) begin
					directionIBS <= 3'b01;
					ibsDone <= 1;
				end
				else if ((dirLFSRIn==3'b011)||(dirLFSRIn==3'b100)) begin
					directionIBS <= 3'b10;
					ibsDone <= 1;
				end
				else if ((dirLFSRIn==3'b000)||(dirLFSRIn==3'b101)) begin
					directionIBS <= 3'b11;
					ibsDone <= 1;
				end
				else if ((dirLFSRIn==3'b110)||(dirLFSRIn==3'b111)) begin
					directionIBS <= 3'b100;
					ibsDone <= 1;
				end
				
				initFlag <= 1;		
			end 
			else if((SEColl==3'b100)||(SEColl==3'b10)) begin	//left right SE coll - sends
				yIBSOut <= spawnLFSRIn;
				//BALL DOES NOT REFLECT FROM LEFT AND RIGHT SCREEN EDGES!!!!!!!!!!!!!!!!!!!
				//DIRECTION IS TRUE THEREFORE WE SIMPLY RESPAWN IN THE CENTER AND DO CONSTRAINT IN THE L D
				//load dir from 3bit lsfr, if constraint to 2 in losers direction
				
				//below we load 8 dir random and constraint to 4 valid
				if ((dirLFSRIn==3'b001)||(dirLFSRIn==3'b010))
					tempDir <= 3'b01;
				else if ((dirLFSRIn==3'b011)||(dirLFSRIn==3'b100))
					tempDir <= 3'b10;
				else if ((dirLFSRIn==3'b000)||(dirLFSRIn==3'b101))
					tempDir <= 3'b11;
				else if ((dirLFSRIn==3'b110)||(dirLFSRIn==3'b111))
					tempDir <= 3'b100;
				//end below we load 8 dir random and constraint to 4 valid
				
				if(SEColl==3'b100) begin	//left, further twice constrained in the loser direction
					if ((tempDir==3'b01)||(tempDir==3'b100)) begin
						directionIBS <= tempDir;
						ibsDone <= 1;
					end
					else if (tempDir==3'b10) begin
						directionIBS <= 3'b01;
						ibsDone <= 1;
					end
					else if (tempDir==3'b11) begin
						directionIBS <= 3'b100;
						ibsDone <= 1;
					end
				end	
				
				if(SEColl==3'b10) begin //right, further twice constrained in the loser direction
					if ((tempDir==3'b10)||(tempDir==3'b11)) begin
						directionIBS <= tempDir;
						ibsDone <= 1;
					end
					else if (tempDir==3'b01) begin
						directionIBS <= 3'b10;
						ibsDone <= 1;
					end
					else if (tempDir==3'b100) begin
						directionIBS <= 3'b11;
						ibsDone <= 1;
					end
				end	
			end
		end
		else begin	//triple checking to null ibsDone
			if(ibsDone)
				ibsDone <= 0;
		end
	end
endmodule