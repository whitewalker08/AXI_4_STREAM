


/*-----------------------------------------------------------------------------



File name    : ei_AXIS_master_driver.sv



Title        : AXI_stream_master_driver_class_file



Project      : AXIS_SV_VIP  



Created On   : 02-06-2022



Developers   : einfochips Ltd



Purpose      : to Drive all signals recived from master generator to the interface  

               

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
`define VSM vif.slave_monitor_cb
class ei_AXIS_slave_monitor;
  
  //virtual AXIS_slave_interface vif;
  virtual AXIS_slave_interface vif;
  mailbox#(ei_AXIS_master_transaction) mon_slv2scb;
  int count;

  ei_AXIS_master_transaction tr;
  
  //local queue to store TDATA
  bit [`DATA_WIDTH-1:0] TDATA_queue[$];

 ////////////////////////////////////////////////////////////////////////////////
  // Method name :       new();

  // Parameters passed : mailbox mon_slv2scb

  // Returned parameters : - none

  // Description : this will constrcut the slave monitor class and
  //               it will connect the mailbox from environment class

////////////////////////////////////////////////////////////////////////////////
 
	
  function new(mailbox#(ei_AXIS_master_transaction) mon_slv2scb);
        this.mon_slv2scb = mon_slv2scb;
  endfunction 

  ////////////////////////////////////////////////////////////////////////////////

  // Method name         : run_t();

  // Parameters passed   : - none

  // Returned parameters : - none

  // Description         : to run slave monitor, extraction of data according to TSTRB  
  
  //                       
  
  ////////////////////////////////////////////////////////////////////////////////
  
  task run_t();
    tr = new();
   forever begin
      
      fork : process_slave_monitor
        slave_monitor_logic:begin
      //count = ei_AXIS_slave_driver::count;
       do begin
        //$display("in do begin");
        //waiting for handshaking
         @(posedge vif.ACLK iff(`VSM.TVALID == 1 & `VSM.TREADY==1))
    
        //$display("out of begin");
        //tr.TVALID = `VSM.TVALID;
        //tr.TREADY = `VSM.TREADY;
        tr.TDATA = `VSM.TDATA;
        tr.TSTRB = `VSM.TSTRB;
        tr.TLAST = `VSM.TLAST;

        //for total number of bytes in TDATA it will get the data according to TSTRB 
        for(int i=0; i<`number_bytes; i++)begin
          if(`VSM.TSTRB[i]==1)begin
            TDATA_queue.push_back(`VSM.TDATA[8*i+7-:8]);
          end
        end
        //after TLAST send the packet to scoreboard
       end while(`VSM.TLAST != 1);
      
      
      
      
      //assign this local queue to the queue in transaction class
      tr.TDATA_queue = TDATA_queue;

      //empty the queue after operation
      TDATA_queue.delete();
      mon_slv2scb.put(tr);

       /* if(ei_AXIS_config::verbosity == "LOW")begin
        $display("=====================================================");
        $display("[SLAVE-MON] : data send to The Scoreboard !");
        $display("=====================================================");

        end*/
      
      if(ei_AXIS_config::verbosity == "MEDIUM")begin
        $display("=====================================================");
        $display("@%0t [SLAVE-MON] : Converting pin level signals to packet level Signal",$time);
        $display("@%0t [SLAVE-MON] : data send to The Scoreboard !",$time);
        $display("=====================================================");
      end

        if(ei_AXIS_config::verbosity == "HIGH")begin
        $display("=====================================================");
        $display("@%0t [SLAVE-MON] : Converting pin level signals to packet level Signal",$time);
        tr.print();
        $display("@%0t [SLAVE-MON] : data send to The Scoreboard !",$time);
        $display("====================================================");
        end
          
        end
        
       thread_reset:begin
          forever begin
            @(`VSM);
            if(vif.ARESETn == 0)begin
              $display("reset asserted");
              //disable process_monitor_logic.thread_write_phase;
              //disable process_monitor_logic.thread_read_phase;
              //disable process_monitor_logic;
              $display("clearing the packet");
              TDATA_queue.delete();
              break;
            end
 
          end
        end : thread_reset
      
      join_any
      
      disable process_slave_monitor;
        
        
        
    end
  endtask : run_t
  
endclass:ei_AXIS_slave_monitor
      