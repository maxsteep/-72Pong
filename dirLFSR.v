module dirLFSR(
clock, resetn, dirLFSRDone, dirLFSROut
);

input  clock;
input  resetn;

output reg dirLFSRDone;
output reg [2:0] dirLFSROut;
  
wire feedback = dirLFSROut[2] ^ dirLFSROut[1] ;

always @(posedge clock)// or negedge resetn)
  if (resetn) begin
    dirLFSROut <= 2'hf;
	dirLFSRDone <= 1'b0;
  end
  else begin
    dirLFSROut <= {dirLFSROut[1:0], feedback} ;
	dirLFSRDone <= 1'b1;
	
	if (dirLFSRDone)
		dirLFSRDone <= 1'b0;
  end

endmodule