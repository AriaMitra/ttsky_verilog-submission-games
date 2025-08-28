module rock_paper(
	input [1:0] u, 
	input clk, 
	input reset, 
	output reg [1:0] win
);
	//00 is rock, 01 is paper, 11 is scissors
	//win → 00 is u win, 01 is draw, 11 is computer wins
  reg [1:0] r;
	wire [2:0] ran;
	LFSR_3 v1 (.clk(clk), .reset(reset), .randd(ran));
	always @ (posedge clk) begin
    r <= ran[1:0];
		if (u == 2'b00) begin
			if (r == 0)
				win <= 2'b01;
			else if (r == 3)
				win <= 2'b00;
			else 
				win <=2'b11;
		end else if(u == 2'b01) begin
			if(r == 1)
				win <=2'b01;
			else if(r == 3)
				win <=2'b11;
			else 
				win<=2'b00;
    end else begin
      if(r ==3)
        win<=2'b01;
      else if (r == 0)
        win<=2'b11;
      else
        win<=2'b00;
		end
	end
endmodule
			
