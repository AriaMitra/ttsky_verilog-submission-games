module rock_paper(
	input [1:0] u, 
	input clk, 
	input reset, 
	output reg [1:0] win
);
	//00 is rock, 01 is paper, 11 is scissors
	//win → 00 is u win, 01 is draw, 11 is computer wins
  reg [1:0] rand;
	wire [2:0] ran;
  LFSR_3 v1 (.clk(clk), .reset(reset), .rand(ran));
	always @ (posedge clk) begin
    rand <= ran[1:0];
		if (u == 2'b00) begin
			if (rand == 0)
				win <= 2'b01;
			else if (rand == 3)
				win <= 2'b00;
			else 
				win <=2'b11;
		end else if(u == 2'b01) begin
			if(rand == 1)
				win <=2'b01;
			else if(rand == 3)
				win <=2'b11;
			else 
				win<=2'b00;
    end else begin
      if(rand ==3)
        win<=2'b01;
      else if (rand == 0)
        win<=2'b11;
      else
        win<=2'b00;
		end
	end
endmodule
			
