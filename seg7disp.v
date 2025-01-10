//compact verilog style
//driving anode, reversed bits (in comparison to lab 2) to accomodate for the bit-order of the input
module seg7disp (input [3:0] HEXbinValue, output reg [6:0] HEXdispOut);
	always @* begin
	    case(HEXbinValue)
			4'b0000: HEXdispOut = 7'b1000000; //to display 0
			4'b0001: HEXdispOut = 7'b1111001; //to display 1
			4'b0010: HEXdispOut = 7'b0100100; //to display 2
			4'b0011: HEXdispOut = 7'b0110000; //to display 3
			4'b0100: HEXdispOut = 7'b0011001; //to display 4
			4'b0101: HEXdispOut = 7'b0010010; //to display 5
			4'b0110: HEXdispOut = 7'b0000010; //to display 6
			4'b0111: HEXdispOut = 7'b1111000; //to display 7
			4'b1000: HEXdispOut = 7'b0000000; //to display 8
			4'b1001: HEXdispOut = 7'b0010000; //to display 9
			4'b1010: HEXdispOut = 7'b0001000; //to display A
			4'b1011: HEXdispOut = 7'b0000011; //to display b
			4'b1100: HEXdispOut = 7'b1000110; //to display C
			4'b1101: HEXdispOut = 7'b0100001; //to display d
			4'b1110: HEXdispOut = 7'b0000110; //to display E
			4'b1111: HEXdispOut = 7'b0001110; //to display F
			
		    default: HEXdispOut = 7'b1111111; //nothing
	  endcase
	  //HEXdispOut = ~HEXdispOut; //curious
	end
endmodule