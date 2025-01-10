module testtr(clock);
	input clock;
	reg[4:0]a;
    reg [5:0] b;
	integer    seed,i,j;
	
    initial begin
      for (i=0; i<6; i=i+1)
        begin
           a=$urandom%10; 
           #100;
           b=$urandom%20;
          // $display("A %d, B: %d",a,b);    
        end 
     // $finish;
   end
endmodule