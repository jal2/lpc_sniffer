/* reset, writes until full */
`timescale 1 ns / 100 ps

module ringbuffer_tb_full ();
   
   parameter BITS = 4;
   reg write_done;
   reg read_done;
   reg reset;
   wire [BITS-1:0] write_addr;
   wire [BITS-1:0] read_addr;
   wire 	   empty;
   wire 	   full;

   ringbuffer #(.BITS(BITS))
   DUT (
	.write_done(write_done),
	.read_done(read_done),
	.reset(reset),
	.write_addr(write_addr),
	.read_addr(read_addr),
	.empty(empty),
	.full(full)
	);

   initial begin
      $dumpfile ("ringbuffer-tb_full.vcd");
      $dumpvars (1, ringbuffer_tb_full);

      reset = 1;
      write_done = 0;
      read_done = 0;
      
      #1 reset = 0;
      #1 reset = 1;
      repeat (2 ** BITS) begin
	 #1 write_done = 1;
	 #1 write_done = 0;
      end
      if ((write_addr != 0) || (read_addr !=0) || (empty != 0) || (full != 1)) begin
	 $display("#ERR after filling the ringbuffer with writes: write_addr %x read_addr %x empty %d full %d", write_addr, read_addr, empty, full);
	 $stop; // if we call vvp -N this will cause an exitcode of 1
      end
      $finish;
   end
endmodule
