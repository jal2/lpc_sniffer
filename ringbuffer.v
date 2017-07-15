module ringbuffer #(parameter BITS = 5)
	(
		input write_done,
		input read_done,
		input reset,
		output reg [BITS-1:0] write_addr,
		output reg [BITS-1:0] read_addr,
		output reg empty,
		output reg full);

	always @(negedge reset or posedge write_done) begin
	   
		if (~reset) begin
		   write_addr <= 0;
		   empty <= 1;
		   full <= 0;
		end
	   
		else begin
		   if (~full) begin
		      write_addr <= write_addr + 1;
		      empty <= 0;
		      if ((write_addr + 1) == read_addr)
			full <= 1;
		   end
		end
	end

	always @(negedge reset or posedge read_done) begin
		if (~reset) begin
			read_addr <= 0;
		end
		else begin
			if (~empty) begin
			   read_addr <= read_addr + 1;
			   full <= 0;
			   if ((read_addr+1) == write_addr)
			     empty <= 1;
			end
		end
	end
endmodule
