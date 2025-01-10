//MOVE ALL ASSIGNMENTS T ALWAYS BLOCK
//resetn here = start , will never be called unless resetn state
module BlackEn (clock, resetn, x, y, doneBlackEn);
	input resetn, clock;
	
	output reg [7:0] x;
	output reg [6:0] y;
	output reg doneBlackEn;
	
	always@(posedge clock) begin
		if ((resetn)&&(!doneBlackEn)) begin
		
			//End of row reached
			if ((x >= 159)&&(y < 119)) begin //159?
				y <= (y+1);
				x <= 8'b0;
			end	
			
			//Normal count
			else begin
				x <= (x+1);
				y <= y;
			end

			if ((x==158)&&(y==119)) begin	//WHY 158
				doneBlackEn <= 1'b1;
				//resetDone = 1;
			end
		end
		else if (!resetn) begin
			doneBlackEn <= 0;
			x <= 8'b0;
			y <= 7'b0;
		end	
	end// end of countX/Y iteration
endmodule