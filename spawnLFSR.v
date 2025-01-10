module spawnLFSR(
clock, resetn, spawnLFSRDone, spawnLFSROut
);

input  clock;
input  resetn;

output reg spawnLFSRDone;
output reg [6:0] spawnLFSROut;

reg [6:0] temp;
wire feedback = temp[6] ^ temp[1] ;

always @(posedge clock)// or negedge resetn)
  if (resetn) begin
    temp <= 6'hf;
	spawnLFSROut <= 7'b0;
	spawnLFSRDone <= 1'b0;
  end
  else begin
    temp <= ({temp[5:0], feedback} + 1'd2);
	if(temp == 119) begin
		spawnLFSROut <= temp - 2'd2;
		spawnLFSRDone <= 1'b1;
	end else if(temp == 118) begin
		spawnLFSROut <= temp - 1'b1;
		spawnLFSRDone <= 1'b1;
	end else begin
		spawnLFSROut <= temp;
		spawnLFSRDone <= 1'b1;
	end
	
	if (spawnLFSRDone)
		spawnLFSRDone <= 1'b0;
  end
endmodule