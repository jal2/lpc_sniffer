/* simple memory read, 32bit */
`timescale 1 ns / 100 ps

module lpc_tb_read_mem3 ();

   reg [3:0]   lpc_ad;
   reg 	       lpc_clock;
   reg 	       lpc_frame;
   reg 	       lpc_reset;
   wire [3:0]  ct_dir;
   wire [31:0] addr;
   wire [31:0]  data;
   wire [2:0] 	data_size;
   wire        out_clock;

   localparam test_addr = 'haffe7fe5, test_data = 'h1234df6c;
   
   /* expected results */
   integer     expected_addr = test_addr;
   integer  expected_data = test_data;
   integer  expected_datasize = 4;
   integer  expected_ct_dir = 4;
   integer  expected_number = 1; // we expect one dataset

   /* the actual results we get */
   integer  result_addr;
   integer  result_data;
   integer  result_datasize;
   integer  result_ct_dir;
   integer  result_number = 0;
   
   lpc UUT (
	    .lpc_ad(lpc_ad),
	    .lpc_clock(lpc_clock),
	    .lpc_frame(lpc_frame),
	    .lpc_reset(lpc_reset),
	    .out_cyctype_dir(ct_dir),
	    .out_addr(addr),
	    .out_data(data),
	    .out_data_size(data_size),
	    .out_clock_enable(out_clock)
	    );

`include "lpc_lib.v"
   
   initial begin
      $dumpfile ("lpc-tb_read_mem3.vcd");
      $dumpvars (0, lpc_tb_read_mem3);

      lpc_assert_reset;
      
      lpc_clock = 0; // all tasks require to have lpc_clock zero before
      
      // LPC start: frame asserted for one cycle with ad == 0000
      lpc_start(1, 0, 0);

      // start with mem read access
      // bit 3:2 = 1 --> mem, bit 1 = 0 --> read
      lpc_ctdir(4'b0100);

      lpc_size(3); // 4 bytes
      
      lpc_addr32(test_addr);
      
      lpc_tar;

      lpc_sync; //no-wait sync
      
      lpc_data32(test_data);
      
      lpc_tar;
      
      // idle clock
      #1 lpc_clock = 1;
      #1 lpc_clock = 0;

      check_results;
      
      $finish;
      
   end // initial begin

   always @(posedge out_clock) begin
      watch_results;
   end
 
endmodule    
      
     
       
  
