/*-----------------------------------------------------------------------------



File name    : ei_AXIS_master_generator.sv



Title        : AXI_stream_master_generator_class_file



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

//class for master generator
class ei_AXIS_master_generator;
  
  //master transaction class 
  ei_AXIS_master_transaction blueprint;

  //mailbox master generator to driver
  mailbox#(ei_AXIS_master_transaction) gen2drv; 

  //variable to generate No. of transactionss
  int unsigned num_of_tran;   
  int count;
  //event for synchronization
  event drv_done;
  
  //static int trans_count;
  
  ////////////////////////////////////////////////////////////////////////////////
  // Method name :       new();

  // Parameters passed : mailbox gen2drv

  // Returned parameters : - none

  // Description : to construct object of blueprint class
  //              connect mailbox of class to actual mailbox.
  //              declare Number of transecation

////////////////////////////////////////////////////////////////////////////////
  function new( mailbox#(ei_AXIS_master_transaction) gen2drv);
    blueprint = new();
    this.gen2drv = gen2drv;
    num_of_tran = (`no_of_trans);
  endfunction

////////////////////////////////////////////////////////////////////////////////

  // Method name         : run_t();

  // Parameters passed   : - none

  // Returned parameters : - none

  // Description         : to run master generator ,it will generate No. of packets by 
  //                      randomization and transfer it to the master driver through mailbox
  //                      
  
  ////////////////////////////////////////////////////////////////////////////////
  task run_t();
    ei_AXIS_master_transaction temp;
    do begin
      blueprint.randomize();
      //$display(blueprint.count);
      if(blueprint.TLAST==1)begin
        count++;
      end
     // $display(blueprint.TLAST_count);
      //$display(blueprint.TLAST);
      //$display("randomized");
      //blueprint.CovADDR.sample();


      // blueprint.print();

      
      
      //trans_count++;
      temp = new blueprint;
      
      if(ei_AXIS_config::verbosity == "MEDIUM")begin
        $display("=====================================================");
        $display("@%0t [MASTER-GEN] : Generated data is sent to the driver through mailbox",$time);
        $display("@%0t [MASTER-GEN] : Transaction sent to driver !",$time);
        $display("=====================================================");
      end

      if(ei_AXIS_config::verbosity == "HIGH")begin
        $display("=====================================================");
        $display("@%0t [MASTER-GEN] : Generated data by Generator:",$time);
        blueprint.print();
        $display("@%0t [MASTER-GEN] : Transaction sent to driver !",$time);
        $display("====================================================");
      end  

      //put randomized packet into mailbox      
      gen2drv.put(temp);
      
      //event for synchronization        
      @(drv_done);
   
                   
    end while(count!=num_of_tran);
    #300;
    $finish;
  endtask : run_t


////////////////////////////////////////////////////////////////////////////////

  // Method name         : wrap_up();

  // Parameters passed   : - none

  // Returned parameters : - none

  // Description         : this function will perform wrap_up task 
  //                      final block task NO. of transaction generated
  //                      
  
  ////////////////////////////////////////////////////////////////////////////////
  function void wrap_up(); 

    $display("NO. of Transaction Generated = %0d",num_of_tran);

  endfunction 
endclass
