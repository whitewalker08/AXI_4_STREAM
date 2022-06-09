/*-----------------------------------------------------------------------------



File name    : ei_AXIS_slave_agent.sv



Title        : AXI_stream_slave_agent_class_file



Project      : AXIS_SV_VIP  



Created On   : 02-06-2022



Developers   : einfochips Ltd



Purpose      : to connect all the components like generator,driver,monitor in single class
               and use in environment.

               

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


//class for slave agent
class ei_AXIS_slave_agent#(bit a_cfg = 1'b1);

  // static to get access in monitor class 
  //static bit [`DATA_WIDTH-1:0]AXIS_slave_mem[int]; 

    //virtual instance of interface
    virtual AXIS_slave_interface vif;

    //declare handle of driver class
    ei_AXIS_slave_driver drv;

    //declare handle of monitor class
    ei_AXIS_slave_monitor mon;

     //mailbox of slave monitor to scoreboard
    mailbox#(ei_AXIS_master_transaction) mon_slv2scb;

     //constructor method declare
    function new(mailbox#(ei_AXIS_master_transaction) mon_slv2scb);
        this.mon_slv2scb = mon_slv2scb;
    endfunction 

    //build method declare
    function void build();
      if(a_cfg)begin
            //allocate memory to driver
            drv = new();
             //connect virtual interface to driver
            drv.vif = this.vif;
        end
        //passing the mailbox and allocate to memory to monitor 
        mon = new(mon_slv2scb);
        //connect virtual interface to monitor
        mon.vif = this.vif;

    endfunction  
     ////////////////////////////////////////////////////////////////////////////////

  // Method name         : run_t();

  // Parameters passed   : - none

  // Returned parameters : - none

  // Description         : to run master agent ,slave agent method parallelly.
  
  ////////////////////////////////////////////////////////////////////////////////
    task automatic run_t();
        //if agent type is 1 means active agent
        if(a_cfg)begin
            //both tasks driver and monitor working parallelly
            fork 
                drv.run_t();
                mon.run_t();
            join
        end
        //if agent type is 0 means passive agent
        else begin
            mon.run_t();
        end
    endtask :run_t

endclass :ei_AXIS_slave_agent