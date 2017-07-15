/* reset, one write, one read */
`timescale 1 ns / 100 ps

module ringbuffer_tb_wr1 ();
   
   parameter BITS = 7;
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
      $dumpfile ("ringbuffer-tb_wr1.vcd");
      $dumpvars (1, ringbuffer_tb_wr1);

      reset = 1;
      write_done = 0;
      read_done = 0;
      
      #1 reset = 0;
      #1 reset = 1;
      #1 write_done = 1;
      #1 read_done = 1;
      #1
      if ((write_addr != 1) || (read_addr !=1) || (empty != 1) || (full == 1)) begin
	 $display("#ERR after reset, one write, one read: write_addr %x read_addr %x empty %d full %d", write_addr, read_addr, empty, full);
	 $stop; // if we call vvp -N this will cause an exitcode of 1
      end
      $finish;
   end
endmodule
