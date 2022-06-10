

/*-----------------------------------------------------------------------------



File name    : ei_AXIS_master_monitor.sv



Title        : AXI_stream_master_monitor_class_file



Project      : AXIS_SV_VIP  



Created On   : 02-06-2022



Developers   : einfochips Ltd



Purpose      : to sample all the signals from the interface, masking the data according to 
              TSTRB signal and send it to the scoreboard              

               

-------------------------------------------------------------------------------

Copyright (c) 2000-2006 eInfochips           - All rights reserved



This software is authored by eInfochips and is eInfochips intellectual

property, including the copyrights in all countries in the world. This

software is provided under a license to use only with all other rights,

including ownership rights, being retained by eInfochips



This file may not be distributed, copied, or reproduced in any manner,

electronic or otherwise, without the express written consent of

eInfochips

-------------------------------------------------------------------------------

Revision: 1.0

-------------------------------------------------------------------------------



-----------------------------------------------------------------------------*/



//short name for the interface
`define VMM vif.master_monitor_cb 

class ei_AXIS_master_monitor;
  
  //virtual interface declared for master interface
  virtual AXIS_interface vif; 
  //mailbox for monitor to scorebard communication
  mailbox #(ei_AXIS_master_transaction) mon2scb;
  mailbox mon2cov;

  //instance of transaction class handle
  ei_AXIS_master_transaction tr;
  
  //local queue to store the TDATA
  
  static int sparse_stream;
  static int aligned_stream;
  static int unaligned_stream;
  
  bit [`number_bytes] first_TSTRB;
  bit [`number_bytes] last_TSTRB;
  //local queue to store the TDATA
  bit [`DATA_WIDTH-1:0] TDATA_queue[$];
  bit [`number_bytes-1:0] TSTRB_queue[$];
  bit [`number_bytes-1:0] valid_TSTRB_queue[$];
  ei_AXIS_coverage_packet cov_pkt;

  int num_trans;
  ////////////////////////////////////////////////////////////////////////////////
  // Method name :       new();

  // Parameters passed : mailbox mon2scb

  // Returned parameters : - none

  // Description : to construct object of master monitor class
  //              connect mailbox of class to environment mailbox.
  //              

  ////////////////////////////////////////////////////////////////////////////////

  function new(mailbox#(ei_AXIS_master_transaction) mon2scb,mailbox mon2cov);
    this.mon2scb = mon2scb;
    this.mon2cov = mon2cov; 
    //ei_AXIS_covergroup = new();
  endfunction

  ////////////////////////////////////////////////////////////////////////////////

  // Method name         : run_t();

  // Parameters passed   : - none

  // Returned parameters : - none

  // Description         : to run master monitor class ,it will get the TDATA from the interface 
  //                       it will mask it with the TSTRB signal and then it will update the queue.          
  //                       after that it will send the packet to the scoreboard
  
  ////////////////////////////////////////////////////////////////////////////////

/*covergroup ei_AXIS_covergroup with function sample(bit last);

sparse_cp : coverpoint sparse_stream iff(last)
{
    bins bin_low = {2};
    bins bin_med = {[30:35]};
    bins bin_high = {100};
}

aligned_cp : coverpoint aligned_stream iff(last)
{
    bins bin_low = {2};
    bins bin_med = {[30:35]};
    bins bin_high = {100};
}

unaligned_cp : coverpoint unaligned_stream iff(last)
{
    bins bin_low = {2};
    bins bin_med = {[30:35]};
    bins bin_high = {100};
}

len_cp:coverpoint num_trans iff(last)
{
    bins bin_single = {1};
    bins bin_low = {[2:10]};
    bins bin_med = {[50:100]};
    bins bin_high = {[101:1000]};
}

aligned_cp_X_len_cp: cross aligned_cp,len_cp 
	{
	    ignore_bins ignore_bin = aligned_cp_X_len_cp with (len_cp==1); 
	}
unaligned_cp_X_len_cp: cross unaligned_cp,len_cp
	{
	    ignore_bins ignore_bin1 = unaligned_cp_X_len_cp with (len_cp==1); 
	}

sparse_cp_X_len_cp: cross sparse_cp,len_cp 
	{
	    ignore_bins ignore_bin2 = sparse_cp_X_len_cp with (len_cp==1); 
	}

endgroup : ei_AXIS_covergroup*/




  task run_t();
    for(int i=1;i<=`number_bytes;i++)begin
      valid_TSTRB_queue.push_back((2**i)-1);
    end
    //$display(valid_TSTRB_queue);
    tr = new();
    cov_pkt = new();

    //ei_AXIS_covergroup = new();
     forever begin
      
      fork : process_monitor
        begin : monitor_logic
          
          do begin
        //$display("in do begin");
        //waiting for handshaking
            @(posedge vif.ACLK iff(`VMM.TVALID == 1 & `VMM.TREADY==1))
        //$display("out of begin");
            //tr.TVALID = `VMM.TVALID;
            //tr.TREADY = `VMM.TREADY;
        	  tr.TDATA = `VMM.TDATA;
        	  tr.TSTRB = `VMM.TSTRB;
        	  tr.TLAST = `VMM.TLAST;
          

        //for total number of bytes in TDATA it will get the data according to TSTRB 
        	for(int i=0; i<`number_bytes; i++)begin
          		if(`VMM.TSTRB[i]==1)begin
            		TDATA_queue.push_back(`VMM.TDATA[8*i+7-:8]);
          		end
        	end
        //after TLAST send the packet to scoreboard
          TSTRB_queue.push_back(`VMM.TSTRB);
          num_trans++;
      	  end while(`VMM.TLAST != 1);
          first_TSTRB = TSTRB_queue[0];
          last_TSTRB = TSTRB_queue[$size(TSTRB_queue)-1];
          
          if(first_TSTRB == ((2**$size(first_TSTRB))-1) && last_TSTRB == ((2**$size(first_TSTRB))-1))begin
            
            for(int i=($size(TSTRB_queue)-2);i>=1;i--)begin
              if(TSTRB_queue[i] == ((2**$size(first_TSTRB))-1))begin
                if(i==1)begin
                  aligned_stream++;
                end
                continue;
              end  
              else begin
                sparse_stream++;
                break;
              end
               
            end
            
          end
          
          else if(first_TSTRB != ((2**$size(first_TSTRB))-1) || (last_TSTRB) != ((2**$size(first_TSTRB))-1))begin
            //$display("inside");
            //$display(valid_TSTRB_queue);
            //$displayb("%0b",first_TSTRB);
            if(((~first_TSTRB) inside {valid_TSTRB_queue})&((last_TSTRB) inside {valid_TSTRB_queue}))begin
             // $display("inside");
            for(int i=($size(TSTRB_queue)-2);i>=1;i--)begin
              if(TSTRB_queue[i] == ((2**$size(first_TSTRB))-1))begin
                if(i==1)begin
                  unaligned_stream++;
                end
                continue;
              end  
              else begin
                sparse_stream++;
                break;
              end
               
              end
            

            
              
            end
            else begin
              sparse_stream++;
            end
            end
            
            
           /* bit flag_unaligned;
            
            for(int i=$size(first_TSTRB)-1;i>=1;i--)begin
              
              if(first_TSTRB[i] == 0)begin
                if(i==1)begin
                  flag_unaligned = 1;
                end
                continue;
              end
              
              else if(first_TSTRB[i] == 1 & first_TSTRB[i-1] != 0)begin
                if(i==1)begin
                  flag_unaligned = 1;
                end
                continue;
              end
              
              else begin
                sparse_stream++;
                break;
              end
            
            end
            
            if(flag_unaligned)begin
              for(int i=($size(TSTRB_queue)-2);i>=1;i--)begin
                if(TSTRB_queue[i] == ((2**$size(first_TSTRB))-1))begin
                  if(i==1)begin
                    unaligned_stream++;
                     $display("@%0t",$time);
                  end
                  continue;
                end
                
                else begin
                  sparse_stream++;
                  break;
                end
                  
              end  
            end
          end
          
          
          else if(first_TSTRB != ((2**$size(first_TSTRB))-1) && last_TSTRB !=((2**$size(first_TSTRB))-1))begin
            
            bit flag_last_strb;
            bit flag_unaligned;
            
            for(int i=$size(first_TSTRB)-1;i>=1;i--)begin
              
              if(first_TSTRB[i] == 0)begin
                if(i==1)begin
                  flag_last_strb = 1;
                end
                continue;
              end
              
              else if(first_TSTRB[i] == 1 & first_TSTRB[i-1] != 0)begin
                if(i==1)begin
                  flag_last_strb = 1;
                end
                continue;
              end
              
              else begin
                sparse_stream++;
                break;
              end
            
            end
           
            if(flag_last_strb == 1)begin
              for(int i=0;i<=$size(last_TSTRB)-2;i++)begin
              
              if(last_TSTRB[i] == 0)begin
                continue;
              end
              
                else if(last_TSTRB[i] == 1 & last_TSTRB[i+1] != 0)begin
                  if(i==6)begin
                  flag_unaligned = 1;
                end
                continue;
              end
              
              else begin
                sparse_stream++;
                break;
              end
            
            end
            end
            
            if(flag_unaligned == 1)begin
              for(int i=($size(TSTRB_queue)-2);i>=1;i--)begin
                if(TSTRB_queue[i] == ((2**$size(first_TSTRB))-1))begin
                  if(i==1)begin
                    unaligned_stream++;
                     $display("@%0t",$time);
                  end
                  continue;
                end
                
                else begin
                  sparse_stream++;
                  break;
                end
                  
              end 
            end
          end
          
          else if(first_TSTRB == ((2**$size(first_TSTRB))-1) && last_TSTRB !=((2**$size(first_TSTRB))-1))begin
            bit flag_unaligned;
            for(int i=0;i<=$size(last_TSTRB)-2;i++)begin
              
              if(last_TSTRB[i] == 0)begin
                if(i==6)begin
                  flag_unaligned = 1;
                end
                continue;
              end
              
              else if(last_TSTRB[i] == 1 & last_TSTRB[i+1] != 0)begin
                if(i==6)begin
                  flag_unaligned = 1;
                end
                continue;
              end
              
              else begin
                sparse_stream++;
                break;
              end
            
            end
            
            if(flag_unaligned)begin
              for(int i=($size(TSTRB_queue)-2);i>=1;i--)begin
                if(TSTRB_queue[i] == ((2**$size(first_TSTRB))-1))begin
                  if(i==1)begin
                    unaligned_stream++;
                    $display("@%0t",$time);
                  end
                  continue;
                end
                
                else begin
                  sparse_stream++;
                  break;
                end
                  
              end  
            end
            */
            
          
          
      
          
         
      
 	  tr.TDATA_queue = TDATA_queue;
      	  TDATA_queue.delete();
          TSTRB_queue.delete();

	  cov_pkt.TLAST = `VMM.TLAST;
	  cov_pkt.num_trans = num_trans;
	  cov_pkt.sparse_stream = sparse_stream;
	  cov_pkt.aligned_stream = aligned_stream;
	  cov_pkt.unaligned_stream = unaligned_stream;

	  mon2cov.put(cov_pkt);
          num_trans = 0;
      	  mon2scb.put(tr);
      //$display("mon putted");
        /*if(ei_AXIS_config::verbosity == "LOW")begin
        $display("=====================================================");
        $display("[MASTER-MON] : data send to The Scoreboard !");
        $display("=====================================================");
        
        end
        */

        
        if(ei_AXIS_config::verbosity == "MEDIUM")begin
        	$display("=====================================================");
        	$display("[MASTER-MON] : Converting pin level signals to packet level Signal");
        	$display("[MASTER-MON] : data send to The Scoreboard !");
        	$display("=====================================================");

        end

        if(ei_AXIS_config::verbosity == "HIGH")begin
          $display("=====================================================");
          $display("[MASTER-MON] : Converting pin level signals to packet level Signal");
          tr.print();
          $display("[MASTER-MON] : data send to The Scoreboard !");
          $display("====================================================");
        end
          
        end
        
         thread_reset:begin
          forever begin
            @(`VMM);
            if(vif.ARESETn == 0)begin
              $display("reset asserted");
              //disable process_monitor_logic.thread_write_phase;
              //disable process_monitor_logic.thread_read_phase;
              //disable process_monitor_logic;
              $display("clearing the packet");
              TDATA_queue.delete();
              TSTRB_queue.delete();
              break;
            end
          end
 
        end : thread_reset
      
      join_any
      disable process_monitor;


    end
  endtask : run_t
  
  
  
endclass : ei_AXIS_master_monitor
