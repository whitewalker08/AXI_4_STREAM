/*-----------------------------------------------------------------------------



File name    : ei_AXIS_top.sv



Title        : AXI stream top module



Project      : AXIS_SV_VIP  



Created On   : 01-06-2022



Developers   : einfochips Ltd



Purpose      : to instantiate interface and interconnect 
               Driving the clock
               connect master and slave interface to interconnect
               generate waveform

               

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

//including all the required files
`include "ei_AXIS_include_all.svh"

module ei_AXIS_top;
  
  
  //clock and reset bit
  bit ACLK;
  bit ARESETn = 1;
  bit dummy3;
  
  
  //toggling the clock
  always #5 ACLK = ~ACLK;
  
  //physical instance of master interface and slave interface
  AXIS_slave_interface pintf_s(ACLK,ARESETn);
  AXIS_interface pintf(ACLK,ARESETn); 
  
  //instance of program block test
  AXIS_test test(pintf,pintf_s);
  
  
  //instance of interconnect
  ei_AXIS_interconnect intr;

  
  initial begin
    
    //constructing the interconnect and connecting with physical interface
    intr = new();
    intr.vif_m = pintf;
    intr.vif_S = pintf_s;
    
    //run task of interconnect
    intr.run_t();
  end
  
  
  //final block to generate passed and failed transactions
  final begin
    $display("Number of Passed Transaction = %0d", ei_AXIS_scoreboard::passed_transactions);
    $display("Number of Failed Transaction = %0d", ei_AXIS_scoreboard::failed_transactions);
    $display("Number of sparse stream = %0d",ei_AXIS_master_monitor::sparse_stream);
    $display("Number of aligned stream = %0d",ei_AXIS_master_monitor::aligned_stream);
    $display("Number of unaligned stream = %0d",ei_AXIS_master_monitor::unaligned_stream);
  end
  
  //stimulus generation
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
  initial begin
    dummy3 = $value$plusargs("testname=%s",ei_AXIS_config::testname);
  end

  initial begin
    if(ei_AXIS_config::testname == "reset_test")begin
      #1789
      ARESETn = 0;
      #100
      ARESETn = 1;
    end
  end

  

endmodule : ei_AXIS_top

/*-------------------------------------------------------------------------

  Copyright (c) 2000-2006 eInfochips. - All rights reserved

 

  This software is authored by eInfochips and is eInfochips intellectual

  property, including the copyrights in all countries in the world. This

  software is provided under a license to use only with all other rights,

  including ownership rights, being retained by eInfochips.

 

  This file may not be distributed, copied, or reproduced in any manner,

  electronic or otherwise, without the express written consent of eInfochips.

  -------------------------------------------------------------------------

*/
