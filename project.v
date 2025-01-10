// Project 'Atari Ping Pong 1972 very first computer game now in FPGA and shitty behold'
//KEY[3:2] left paddle - KEY3 move up, KEY2 down
//KEY[1:0] right paddle - KEY1 move up, KEY0 down

//SW[9] game reset = blacken entire screen 
//SW[0] game start = draw 2 white rectangles, wait for control input

//KEY[3:0] are inverted: {unpressed: value 1 / pressed: value 0}

//top purely connecting module

//startSolve IS NOT USED AT ALL, LEFT AND RIGHT VIA isActive ARE USED INSTEAD IT SEEMS TRIPLE CHECK!!!! in paddleSolve
`timescale 1ps/1ps

module project
	(
		CLOCK_50,						//	On Board 50 MHz

		SW,
		KEY,
		LEDR,
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
		// The ports below are for the VGA output.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,					//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	
	input [9:0]SW;
	input [3:0]KEY;
	
	output [9:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	// VGA
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;			//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	wire [2:0] colour;  //only need 000 black and 111 white - colourWire
	wire [7:0] x;		//plots a single pixel with given 8 bit address x
	wire [6:0] y;		//plots a single pixel with given 7 bit address y
	wire writeEn; 		//plot wire
	
	wire resetn; //initial high active state - blacken entire screen
	wire gameStart;  //draw 2 rectangles wait for user input
	wire [1:0] leftUserInput;	//left paddle wire connecting to controls
	wire [1:0] rightUserInput;	//right paddle wire connecting to controls
	
	assign resetn = SW[9];	//wipe the entire screen - draw huge black rectangle
	//active high
	assign leftUserInput = ~KEY[3:2];	//left paddle wire connecting to controls - hoping that negation does work this way with KEYs
	assign rightUserInput = ~KEY[1:0];	//right paddle wire connecting to controls
	assign gameStart = SW[0]; //plot - plot 2 rectangles in the pre arranged mid screen positions
	//proper left,right user input hereby tested and certified
	
	//counts through all 160x120 pixels to colour the entire screen black
	
	//converts the CLOCK_50 to 4hz - 15 fps, drives update mechanism/state on the control module
	
	//-----------DEBUG WIRES
	wire startSolveWire;
	wire startDrawWire;
	wire leftWire;
	wire doneBlackEnWire;
	wire doneDrawPaddleLeftWire;
	wire frameCounterWire;
	wire doneSolvedLeftWire;
	wire doneSolvedRightWire;
	wire doneDrawPaddleRightWire;
	wire rightWire;
	//END-----------DEBUG WIRES
	
	//the top un-connecting module
	drawLogic  plotter(.clock(CLOCK_50), .resetn(resetn), .gameStart(gameStart), .leftUserInput(leftUserInput), .rightUserInput(rightUserInput), 
						//debug wires start
					   .frameCounter(frameCounterWire),
					   .doneSolvedLeft(doneSolvedLeftWire), .doneSolvedRight(doneSolvedRightWire), 
					   .doneBlackEn(doneBlackEnWire), .left(leftWire), .right(rightWire),
					   .startSolve(startSolveWire), 
					   .startDraw(startDrawWire),
					   .doneDrawPaddleLeft(doneDrawPaddleLeftWire), .doneDrawPaddleRight(doneDrawPaddleRightWire),
					   //debug wires end
					   .xOut(x), .yOut(y), .colour(colour), .writeEn(writeEn));
	
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(1'b1),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
	//--------------------------------------------------------------DEBUG START--------------------------------------------------------

	assign LEDR[0] = writeEn;
	assign LEDR[1] = leftWire;
	assign LEDR[2] = rightWire;
	
	reg LEDR6fCtriggerWire;
	
	assign LEDR[3] = startSolveWire;
	assign LEDR[4] = doneSolvedLeftWire;
	assign LEDR[5] = doneSolvedRightWire;
	assign LEDR[6] = startDrawWire;
	assign LEDR[7] = doneDrawPaddleLeftWire;
	assign LEDR[8] = doneDrawPaddleRightWire;
	assign LEDR[9] = doneBlackEnWire;//reuse
	
	
	
	reg [3:0] frameCountInternalWire;
	always@(posedge CLOCK_50) begin
		if(SW[9]) begin
			LEDR6fCtriggerWire <= 1'b0;
			frameCountInternalWire <= 4'b0;
		end
		else if(frameCounterWire) begin
			LEDR6fCtriggerWire <= 1'b1;
			frameCountInternalWire <= frameCountInternalWire + 1'b1;
		end
	end
	
	seg7disp dHEX0 (
		.HEXbinValue(x[3:0]),
		.HEXdispOut(HEX0)
	);
	
	seg7disp dHEX1 (
		.HEXbinValue(x[7:4]),
		.HEXdispOut(HEX1)
	);
	
	seg7disp dHEX2 (
		.HEXbinValue(y[3:0]),
		.HEXdispOut(HEX2)
	);
	
	seg7disp dHEX3 (
		.HEXbinValue({1'b0,y[6:4]}),
		.HEXdispOut(HEX3)
	);
	
	seg7disp dHEX4 (
		.HEXbinValue({1'b0,colour}),
		.HEXdispOut(HEX4)
	);
	
	seg7disp dHEX5 (
		.HEXbinValue(frameCountInternalWire),
		.HEXdispOut(HEX5)
	);
	
	//------------------------------------------------------------DEBUG END--------------------------------------------------------
	
endmodule

module drawLogic (clock, resetn, gameStart, leftUserInput, rightUserInput,  //user input
				  //debug wires start
				  startSolve, startDraw, left, doneBlackEn, doneDrawPaddleLeft, frameCounter, doneSolvedLeft,
				  right, doneDrawPaddleRight, doneSolvedRight,
				  //debug wires end
				  xOut, yOut, colour, writeEn								//feed back to top
				  );	
	input clock;
	input resetn;
	input gameStart;
	
	input [1:0] leftUserInput;
	input [1:0] rightUserInput;
	
	//output [9:0] LEDR;
	//output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	output reg [7:0] xOut;
	output reg [6:0] yOut;
	output reg [2:0] colour;
	output reg writeEn;
	
	
	//framecounter
	output reg frameCounter;
	wire frameCounterWire;
	
	//blacken x y
	reg [7:0] xBlackenIn;
	reg [6:0] yBlackenIn;
	wire [7:0] xBlackenOutWire;
	wire [6:0] yBlackenOutWire;
	output reg doneBlackEn;
	wire doneBlackEnWire;
	//end blacken - activated on high resetn
	
	//paddle draw x y
	reg [7:0] xLeftPaddleInPlot;
	reg [6:0] yLeftPaddleInPlot; 
	reg [7:0] xRightPaddleInPlot;
	reg [6:0] yRightPaddleInPlot;
	wire [7:0] xLeftPaddleOutWire;
	wire [6:0] yLeftPaddleOutWire;
	wire [7:0] xRightPaddleOutWire;	
	wire [6:0] yRightPaddleOutWire;
	
	output reg doneDrawPaddleLeft;
	output reg doneDrawPaddleRight;
	wire doneDrawPaddleLeftWire;
	wire doneDrawPaddleRightWire;
	//end paddle draw x y
	
	//y paddle solver
	output reg doneSolvedLeft;
	output reg doneSolvedRight;	
	wire doneSolvedLeftWire;
	wire doneSolvedRightWire;	
	
	reg [6:0] yLeftPaddleInSolved;
	reg [6:0] yRightPaddleInSolved;
	wire [6:0] yLeftPaddleSolvedOutWire;
	wire [6:0] yRightPaddleSolvedOutWire;	
	//end y paddle solver
	
	//draw net in
	reg [6:0] yNetIn;
	wire [6:0] yNetOutWire;
	reg netDone;
	wire netDoneWire;
	//end draw net in
	
	//fsm flags
	output reg startSolve;
	output reg startDraw;
	output reg left;
	output reg right;
	
	reg [7:0] xInL; //initial x for left right paddles
	reg [7:0] xInR; //we reset and init this under resetn active state since they never change and only have to be init once, but different for l and r
	//end fsm flags
	
	//blackenenable signal following resetn
	//reg blackenEnable;
	//end blackenenable signal following resetn
	
	//---LFSR wires start---
	reg [2:0] dirLFSRIn;
	reg dirLFSRDone;
	wire [2:0] dirLFSROutWire;
	wire dirLFSRDoneWire;
	
	reg [6:0] spawnLFSRIn;
	reg spawnLFSRDone;
	wire [6:0] spawnLFSROutWire;
	wire spawnLFSRDoneWire;
	//---LFSR wires end---
	
	//---ibs wires start---
	reg ibsDoneIn;
	wire ibsDoneOutWire;
	reg [7:0] xIBSIn;
	wire [7:0] xIBSOutWire;
	reg [6:0] yIBSIn;
	wire [6:0] yIBSOutWire;
	reg [2:0] directionIBSIn;
	wire [2:0] directionIBSOutWire;
	//---ibs wires end---
	
	//---solveBall wires start---
	reg	ballTestSolved;
	wire ballTestSolvedWire;
	reg ballSolved;
	wire ballSolvedWire;
	reg [7:0] xBallCoordIn;
	wire [7:0] xBallCoordOutWire;
	reg [6:0] yBallCoordIn;
	wire [6:0] yBallCoordOutWire;
	reg [7:0] xTestBallCoordIn;
	wire [7:0] xTestBallCoordOutWire;
	reg [6:0] yTestBallCoordIn;
	wire [6:0] yTestBallCoordOutWire;
	//---solveBall wires end---
	
	//SEColl wires start--------
	reg [2:0] SECollIn;
	wire [2:0] SECollOutWire;
	reg SECollDone;
	wire SECollDoneWire;
	reg SECollInner;
	wire SECollInnerWire;
	//SEColl wires end--------
	
	//pcoll wires start---------
	reg PCollInner;
	wire PCollInnerWire;
	reg [2:0] PCollIn;
	wire [2:0] PCollOutWire;
	reg PCollDone;
	wire PCollDoneWire;
	//pcoll wires end-----------
	
	//begin new enable FSM controlled signals for modules
	 reg enableIBS;
	 reg enableSB;
	 reg enableSEC;
	 reg enablePC;
	 reg enableDB;
	//end new enable FSM controlled signals for modules
	
	//draw ball wires start-------
	reg [7:0] xBallIn;
	wire [7:0] xBallOutWire;
	reg [6:0] yBallIn;
    wire [6:0] yBallOutWire;
	reg doneBallDraw;
	wire doneBallDrawWire;
	//draw ball wires end---------
	
	always@(*) begin
		//if (frameCounter == 1'bx) - doesnt seem to work
		frameCounter <= frameCounterWire;
		//blackenEnable <= resetn;
		xBlackenIn <= xBlackenOutWire;
		yBlackenIn <= yBlackenOutWire;
		doneBlackEn <= doneBlackEnWire;
		
		xLeftPaddleInPlot <= xLeftPaddleOutWire;
		yLeftPaddleInPlot <= yLeftPaddleOutWire;
		xRightPaddleInPlot <= xRightPaddleOutWire;
		yRightPaddleInPlot <= yRightPaddleOutWire;
		
		doneDrawPaddleLeft <= doneDrawPaddleLeftWire;
		doneDrawPaddleRight <= doneDrawPaddleRightWire;
		
		doneSolvedLeft <= doneSolvedLeftWire;
		doneSolvedRight <= doneSolvedRightWire;
		
		yLeftPaddleInSolved <= yLeftPaddleSolvedOutWire;
		yRightPaddleInSolved <= yRightPaddleSolvedOutWire;
		
		yNetIn <= yNetOutWire;
		netDone <= netDoneWire;
		
		//---LFSR wires start---
		dirLFSRIn <= dirLFSROutWire;
		dirLFSRDone <= spawnLFSRDoneWire;
		
		spawnLFSRIn <= spawnLFSROutWire;
		spawnLFSRDone <= spawnLFSRDoneWire;
		//---LFSR wires end---
		
		//---ibs wires start---
		ibsDoneIn <= ibsDoneOutWire;
		xIBSIn <= xIBSOutWire;
		yIBSIn <= yIBSOutWire;
		directionIBSIn <= directionIBSOutWire;
		//---ibs wires end---
		
		//---solveBall wires start---

		ballTestSolved <= ballTestSolvedWire;
		ballSolved <= ballSolvedWire;
		xBallCoordIn <= xBallCoordOutWire;
		yBallCoordIn <= yBallCoordOutWire;
		xTestBallCoordIn <= xTestBallCoordOutWire;
		yTestBallCoordIn <= yTestBallCoordOutWire;
		//---solveBall wires end---
		
		//SEColl wires start--------

		SECollIn <= SECollOutWire;
		SECollDone <= SECollDoneWire;
		SECollInner <= SECollInnerWire;
		//SEColl wires end--------
		
		//pcoll wires start---------
		PCollInner <= PCollInnerWire;
		PCollIn <= PCollOutWire;
		PCollDone <= PCollDoneWire;
		//pcoll wires end-----------
		
		//draw ball wires start-------
		xBallIn <= xBallOutWire;
		yBallIn <= yBallOutWire;
		doneBallDraw <= doneBallDrawWire;
		//draw ball wires end---------
	end
	//dont need start BlackEn - resetn activated
	
	
	reg[4:0] current_state, next_state; //states
	
	localparam	S_BLACK		     = 5'd0,
				S_GAMESTART		 = 5'd1,	//Draws the net
				S_PLOTBLACKLEFT	 = 5'd2,
				S_PLOTBLACKRIGHT = 5'd3,
				S_SOLVELEFT	     = 5'd4,
				S_SOLVERIGHT 	 = 5'd5,
				S_PLOTWHITELEFT  = 5'd6,
				S_PLOTWHITERIGHT = 5'd7,
				
				S_IBS			 = 5'd8,
				S_SOLVEBALL      = 5'd9,
				S_SECOLL		 = 5'd10,
				S_PADDLECOLL     = 5'd11,
				S_PLOTBALLW      = 5'd12,
				S_PLOTBALLB      = 5'd13,
				
				S_WAITFC         = 5'd14;
	
	// Next state logic aka our state table	
	always@(*)
		begin: state_table
			case(current_state)
				S_BLACK : 			begin
										if(doneBlackEn)
											next_state = S_GAMESTART;
										else
											next_state = S_BLACK;
									end
				S_SOLVELEFT: 		begin
										if(doneSolvedLeft)
											next_state = S_SOLVERIGHT;
										else
											next_state = S_SOLVELEFT;
									end
				S_SOLVERIGHT: 		
									begin
										if(doneSolvedRight) begin
											next_state = S_PLOTWHITELEFT;
										end
										else
											next_state = S_SOLVERIGHT;
									end
				
				S_GAMESTART : 		
									begin
										if((netDone)&&(!resetn))
											next_state = S_SOLVELEFT;
										else
											next_state = S_GAMESTART;
									end
				S_PLOTBLACKLEFT: 	
									begin
										if(doneDrawPaddleLeft)
											next_state = S_PLOTBLACKRIGHT;
										else
											next_state = S_PLOTBLACKLEFT;
									end
				S_PLOTBLACKRIGHT:	
									begin
										if(doneDrawPaddleRight)
											next_state = S_PLOTBALLB;
										else
											next_state = S_PLOTBLACKRIGHT;
									end
				S_PLOTWHITELEFT:	
									begin
										if(doneDrawPaddleLeft)
											next_state = S_PLOTWHITERIGHT;
										else
											next_state = S_PLOTWHITELEFT;
									end
				S_PLOTWHITERIGHT: 	
									begin
										if(doneDrawPaddleRight)
											next_state = S_IBS;
										else
											next_state = S_PLOTWHITERIGHT;
									end
									
				S_IBS:				begin
										if(ibsDoneIn)
											next_state = S_SOLVEBALL;
										else
											next_state = S_IBS;
									end
									
				S_SOLVEBALL:		begin
										if(ballSolved)
											next_state = S_PLOTBALLW ;
										else if(ballTestSolved)
											next_state = S_SECOLL;
										else
											next_state = S_SOLVEBALL;
									end
			
				S_SECOLL:           begin
										if(SECollDone)
											next_state =  S_PADDLECOLL;
										else
											next_state = S_SECOLL;
									end
				
				S_PADDLECOLL:		begin
										if(PCollDone)
											next_state =  S_SOLVEBALL;
										else
											next_state = S_PADDLECOLL;
									end
			
				S_PLOTBALLW:		begin
										if(doneBallDraw)
											next_state =  S_WAITFC;
										else
											next_state = S_PLOTBALLW;
									end
			
				S_PLOTBALLB:		begin
										if(doneBallDraw)
											next_state =  S_SOLVELEFT;
										else
											next_state = S_PLOTBALLB;
									end
			
				S_WAITFC: 			
									begin
										if(frameCounter)
											next_state = S_PLOTBLACKLEFT;
										else
											next_state = S_WAITFC;
									end
				default: 			begin
										next_state = S_WAITFC;
									end
			endcase
		end
	
	// Output logic aka all of our datapath control signals
	always@(*)
		begin //enable_signals
			// By default make all our signals 0
			case(current_state)
				S_BLACK:  begin
							  startDraw <= 0;
							  startSolve <= 0;
							  left <= 0;
							  right <= 0;

							  enableIBS <= 0;
							  enableSB <= 0;
							  enableSEC <= 0;
							  enablePC <= 0;
							  enableDB <= 0;
							  
							  xOut <= xBlackenIn;
							  yOut <= yBlackenIn;
							  colour <= 000;
							  writeEn <= 1;
						  end
				S_GAMESTART: begin
							  startDraw <= 0;
							  startSolve <= 0;
							  left <= 0;
							  right <= 0;

							  enableIBS <= 0;
							  enableSB <= 0;
							  enableSEC <= 0;
							  enablePC <= 0;
							  enableDB <= 0;
							  
							  xOut <= 7'd80;
							  yOut <= yNetIn;
							  colour <= 111;
							  writeEn <= 1;
						end
				S_PLOTBLACKLEFT: begin
								  startDraw <= 1;
								  startSolve <= 0;
								  left <= 1;
								  right <= 0;

								  enableIBS <= 0;
							      enableSB <= 0;
								  enableSEC <= 0;
							      enablePC <= 0;
								  enableDB <= 0;
								  
								  xOut <= xLeftPaddleInPlot;
								  yOut <= yLeftPaddleInPlot;
								  colour <= 000;
								  writeEn <= 1;
							 end
				S_PLOTBLACKRIGHT: begin
									  startDraw <= 1;
									  startSolve <= 0;
									  left <= 0;
									  right <= 1;

									  enableIBS <= 0;
									  enableSB <= 0;
									  enableSEC <= 0;
									  enablePC <= 0;
									  enableDB <= 0;
									  
									  xOut <= xRightPaddleInPlot;
									  yOut <= yRightPaddleInPlot;
									  colour <= 000;
									  writeEn <= 1;							  
								  end
				S_SOLVELEFT: begin
								startDraw <= 0;
								startSolve <= 1;
								left <= 1;
								right <= 0;

								enableIBS <= 0;
							    enableSB <= 0;
							    enableSEC <= 0;
							    enablePC <= 0;
								enableDB <= 0;
								
								xOut <= xOut;
								yOut <= yOut;
								colour <= 000;
								writeEn <= 0;	
						     end
				S_SOLVERIGHT: begin
								startDraw <= 0;
								startSolve <= 1;
								left <= 0;
								right <= 1;

								enableIBS <= 0;
							    enableSB <= 0;
							    enableSEC <= 0;
							    enablePC <= 0;
								enableDB <= 0;
								
								xOut <= xOut;
								yOut <= yOut;
								colour <= 000;
								writeEn <= 0;
							  end
				S_PLOTWHITELEFT: begin
									startDraw <= 1;
									startSolve <= 0;
									left <= 1;
									right <= 0;
									
									enableIBS <= 0;
									enableSB <= 0;
									enableSEC <= 0;
									enablePC <= 0;
									enableDB <= 0;
									
									xOut <= xLeftPaddleInPlot;
									yOut <= yLeftPaddleInPlot;
									if (xLeftPaddleInPlot)
										writeEn <= 1;
									else
										writeEn <= 0;
									colour <= 111;
								 end
				S_PLOTWHITERIGHT: begin
									startDraw <= 1;
									startSolve <= 0;
									left <= 0;
									right <= 1;
									
									enableIBS <= 0;
									enableSB <= 0;
									enableSEC <= 0;
									enablePC <= 0;
									enableDB <= 0;
									
									xOut <= xRightPaddleInPlot;
									yOut <= yRightPaddleInPlot;
									if (xRightPaddleInPlot)
										writeEn <= 1;
									else
										writeEn <= 0;
									colour <= 111;
								 end
				//new states				 
				S_IBS:			begin
									startDraw <= 0;
									startSolve <= 0;
									left <= 0;
									right <= 0;

									enableIBS <= 1;
									enableSB <= 0;
									enableSEC <= 0;
									enablePC <= 0;
									enableDB <= 0;
									
									xOut <= xOut;
									yOut <= yOut;
									colour <= 000;
									writeEn <= 0;
				end
				S_SOLVEBALL:	begin
									startDraw <= 0;
									startSolve <= 0;
									left <= 0;
									right <= 0;

									enableIBS <= 0;
									enableSB <= 1;
									enableSEC <= 0;
									enablePC <= 0;
									enableDB <= 0;
									
									xOut <= xOut;
									yOut <= yOut;
									colour <= 000;
									writeEn <= 0;
				end
				S_SECOLL:		begin
									startDraw <= 0;
									startSolve <= 0;
									left <= 0;
									right <= 0;

									enableIBS <= 0;
									enableSB <= 0;
									enableSEC <= 1;
									enablePC <= 0;
									enableDB <= 0;
									
									xOut <= xOut;
									yOut <= yOut;
									colour <= 000;
									writeEn <= 0;
				end
				S_PADDLECOLL:	begin
									startDraw <= 0;
									startSolve <= 0;
									left <= 0;
									right <= 0;

									enableIBS <= 0;
									enableSB <= 0;
									enableSEC <= 0;
									enablePC <= 1;
									enableDB <= 0;
									
									xOut <= xOut;
									yOut <= yOut;
									colour <= 000;
									writeEn <= 0;
				end
				S_PLOTBALLW:	begin
									startDraw <= 0;
									startSolve <= 0;
									left <= 0;
									right <= 0;
	
									enableIBS <= 0;
									enableSB <= 0;
									enableSEC <= 0;
									enablePC <= 0;
									enableDB <= 1;
	
									xOut <= xBallIn;
									yOut <= yBallIn;
									colour <= 111;
									writeEn <= 1;
				end
				S_PLOTBALLB:	begin
									startDraw <= 0;
									startSolve <= 0;
									left <= 0;
									right <= 0;

									enableIBS <= 0;
									enableSB <= 0;
									enableSEC <= 0;
									enablePC <= 0;
									enableDB <= 1;
									
									xOut <= xBallIn;
									yOut <= yBallIn;
									colour <= 000;
									writeEn <= 1;
				end
				//end new states
				S_WAITFC: begin
							startDraw <= 0;
							startSolve <= 0;
							left <= 0;
							right <= 0;

							enableIBS <= 0;
							enableSB <= 0;
							enableSEC <= 0;
							enablePC <= 0;
							enableDB <= 0;
							
							xOut <= xOut;
							yOut <= yOut;
							colour <= 000;
							writeEn <= 0;
						  end
				
				default:  begin
						    startDraw <= 0;
							startSolve <= 0;
							left <= 0;
							right <= 0;

							enableIBS <= 0;
							enableSB <= 0;
							enableSEC <= 0;
							enablePC <= 0;
							enableDB <= 0;
							
							xOut <= 8'b0;
							yOut <= 7'b0;
							colour <= 000;
							writeEn <= 0;
						  end
			endcase
		end	
						  //counter activated doneBlackEn = 1;
						  //draw black entire screen
				

	// current_state registers
	always@ (posedge clock)
		begin: state_FFs
			if(resetn) begin
				current_state <= S_BLACK;
				xInL <= 8'd39; //inital x for left right paddles
				xInR <= 8'd118;
				
			end
			else
				current_state <= next_state;
		end // state_FFS
		
	hz4Counter hz4(.clock(clock), .resetn(resetn), .gameStart(gameStart), .frameCounter(frameCounterWire));
	
	BlackEn allCount(.clock(clock), .resetn(resetn), .x(xBlackenOutWire), .y(yBlackenOutWire), .doneBlackEn(doneBlackEnWire));
	
	Paddle leftSolver(.clock(clock), .resetn(resetn), .startSolve(startSolve), .UserInput(leftUserInput),
					  .isActive(left),
					  .yPaddleCoord(yLeftPaddleSolvedOutWire), .isSolved(doneSolvedLeftWire));  //left
					  
	Paddle rightSolver(.clock(clock), .resetn(resetn), .startSolve(startSolve), .UserInput(rightUserInput), 
					   .isActive(right),
					   .yPaddleCoord(yRightPaddleSolvedOutWire), .isSolved(doneSolvedRightWire));  //right
	
	drawPaddle  leftPlotter(.clock(clock), .resetn(resetn), .xIn(xInL), .yIn(yLeftPaddleInSolved), .startDrawPaddle(startDraw), 
							.isActive(left),
							.xPaddleOut(xLeftPaddleOutWire), .yPaddleOut(yLeftPaddleOutWire), .donePaddle(doneDrawPaddleLeftWire));
					 
	drawPaddle rightPlotter(.clock(clock), .resetn(resetn), .xIn(xInR), .yIn(yRightPaddleInSolved), .startDrawPaddle(startDraw), 
							.isActive(right),
							.xPaddleOut(xRightPaddleOutWire), .yPaddleOut(yRightPaddleOutWire), .donePaddle(doneDrawPaddleRightWire));
							
	drawNet net(.clock(clock), .resetn(resetn), .gameStart(gameStart), .netDone(netDoneWire), .yNetOut(yNetOutWire));
	
	dirLFSR dirR(.clock(clock), .resetn(resetn), .dirLFSROut(dirLFSROutWire), .dirLFSRDone(dirLFSRDoneWire));	
	
	spawnLFSR spawn(.clock(clock), .resetn(resetn), .spawnLFSROut(spawnLFSROutWire), .spawnLFSRDone(spawnLFSRDoneWire));	
	//WE DONT USE GAMESTART IN THE MODULES BELOW AT ALL
	IBS ballInit(.clock(clock), .resetn(resetn), .gameStart(gameStart), .enable(enableIBS), 
				.SEColl(SECollIn), .spawnLFSRIn(spawnLFSRIn), .dirLFSRIn(dirLFSRIn), 
				.ibsDone(ibsDoneOutWire), .xIBSOut(xIBSOutWire), .yIBSOut(yIBSOutWire), .directionIBS(directionIBSOutWire));
		
	//add all the wires below (input)
	solveBall solveB(.clock(clock), .resetn(resetn), .gameStart(gameStart), .enable(enableSB),
			  .ibsDone(ibsDoneIn), .SECollIn(SECollIn), .PCollIn(PCollIn), .xIBSIn(xIBSIn), .yIBSIn(yIBSIn), .directionIBSIn(directionIBSIn), 
			  .PCollInner(PCollInner),
			  .SECollDone(SECollDone), .PCollDone(PCollDone), .SECollInner(SECollInner),
			  
			  .ballTestSolved(ballTestSolvedWire), .ballSolved(ballSolvedWire), .xBallCoordOut(xBallCoordOutWire), 
			  .yBallCoordOut(yBallCoordOutWire), .xTestBallCoordOut(xTestBallCoordOutWire), .yTestBallCoordOut(yTestBallCoordOutWire));
	
	SEColl screenedgecoll(.clock(clock), .resetn(resetn), .gameStart(gameStart), .enable(enableSEC),
		.xBallCoordIn(xTestBallCoordIn), .yBallCoordIn(yTestBallCoordIn), 
		.SECollOut(SECollOutWire), .SECollDone(SECollDoneWire), .SECollInner(SECollInnerWire));
		
	PColl paddlecoll(.clock(clock), .resetn(resetn), .gameStart(gameStart), .enable(enablePC),
		.yLeftPaddleCoordIn(yLeftPaddleInSolved), .yRightPaddleCoordIn(yRightPaddleInSolved), .xBallCoordIn(xTestBallCoordIn), 
		.yBallCoordIn(yTestBallCoordIn), 
		.PCollInner(PCollInnerWire), .PCollOut(PCollOutWire), .PCollDone(PCollDoneWire));
		
	drawBall db(.clock(clock), .resetn(resetn), .gameStart(gameStart), .enable(enableDB),
			.xBallCoordIn(xBallCoordIn), .yBallCoordIn(yBallCoordIn), 
			.xBallOut(xBallOutWire), .yBallOut(yBallOutWire), .doneBallDraw(doneBallDrawWire));
	//END WE DONT USE GAMESTART IN THE MODULES BELOW AT ALL
endmodule
