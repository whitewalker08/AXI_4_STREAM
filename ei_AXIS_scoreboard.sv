/*-----------------------------------------------------------------------------





File name : ei_AXIS_scoreboard.sv





Title : AXI stream scoreboard





Project : AXIS_SV_VIP





Created On : 01-06-2022





Developers : einfochips Ltd





Purpose : to compare generated TDATA from master with sampled TDATA of slave .
It also counts passed transactions and failed transactions.



-------------------------------------------------------------------------------



Copyright (c) 2000-2006 eInfochips - All rights reserved





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






class ei_AXIS_scoreboard;
  
  // mailbox from master monitor to scoreboard 
  mailbox#(ei_AXIS_master_transaction) mon2scb;  

  // mailbox from slave monitor to scoreboard
  mailbox#(ei_AXIS_master_transaction) mon_slv2scb;  
  
  // declaring handle of ei_AXIS_master_transaction
  ei_AXIS_master_transaction mdata;

  // declaring handle of ei_AXIS_master_transaction  
  ei_AXIS_master_transaction sdata; 


  // declaring varibles to count passed and failed transactions
  static int passed_transactions,failed_transactions;   

////////////////////////////////////////////////////////////////////////////////



// Method name : new();



// Parameters passed : mailbox mon2scb and mailbox mon_slv2scb



// Returned parameters : - none



// Description : to construct object of scoreboard class
// connect mailbox of class to actual mailbox.

////////////////////////////////////////////////////////////////////////////////
  
  function new(mailbox#(ei_AXIS_master_transaction) mon2scb, mailbox#(ei_AXIS_master_transaction) mon_slv2scb);
		this.mon2scb = mon2scb;   
		this.mon_slv2scb = mon_slv2scb;  
  endfunction
  

////////////////////////////////////////////////////////////////////////////////



// Method name : run_t();



// Parameters passed : - none



// Returned parameters : - none



// Description : to get generated tarnsaction packet from mon2sco mailbox
// to get sampled transaction packet from mon_slv2scb mailbox
// compare queue of master and slave

////////////////////////////////////////////////////////////////////////////////


  task run_t();
    
    forever begin 
      //$display("scb");
      // getting transaction packet from master monnitor to scoreboard mailbox
			mon2scb.get(mdata);   
      //$display("Scb");
			

      // getting transaction packet from slave monnitor to scoreboard mailbox
			mon_slv2scb.get(sdata);	  
      
       // comparing queue of data
      if (mdata.TDATA_queue == sdata.TDATA_queue) begin    
        
        if(ei_AXIS_config::verbosity == "LOW")begin
          $display("=====================================================");
          $display("@%0t [sco] : Transaction Pass !",$time);
          $display("=====================================================");

        end
        if(ei_AXIS_config::verbosity == "MEDIUM" || ei_AXIS_config::verbosity == "HIGH")begin
           $display("=====================================================");
           $display("@%0t [sco] : Generated data is matched with sampled data",$time);
           $display("@%0t [sco] :data received from Master :",$time);
          $display(mdata.TDATA_queue);
           $display("@%0t [sco] :data received from Slave :",$time);
           $display(sdata.TDATA_queue);
           $display("@%0t [sco] : Transaction Pass !",$time);
           $display("=====================================================");
        end


				//$display("[sco] : Generated data is matched with sampled data");
        // increasing pass count if data is same
        passed_transactions++;    
      end 
      
      else begin
        $display("@%0t [sco] : Transaction Fail !",$time);
        failed_transactions++;
        if(ei_AXIS_config::verbosity == "MEDIUM" || ei_AXIS_config::verbosity == "HIGH" )begin
           $display("=====================================================");
           $display("@%0t [sco] : Generated data is matched with sampled data",$time);
           $display("@%0t [sco] :data received from Master :",$time);
          $display(mdata.TDATA_queue);
           $display("@%0t [sco] :data received from Slave :",$time);
           $display(sdata.TDATA_queue);
          $display("@%0t [sco] : Transaction Fail !",$time);
           $display("=====================================================");
        end
        
      end
    end
  endtask : run_t 
  
endclass : ei_AXIS_scoreboard