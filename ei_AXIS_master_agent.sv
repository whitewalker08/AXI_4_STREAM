/*-----------------------------------------------------------------------------



File name    : ei_AXIS_master_agent.sv



Title        : AXI stream master agent file



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

//class for master agent
class ei_AXIS_master_agent#(bit a_cfg = 1'b1);
  //declare handle of driver class
  ei_driver drv;
  //declare handle of generator class
  ei_AXIS_master_generator gen;
  //declare handle of monitor class
  ei_AXIS_master_monitor mon;
  ei_AXIS_coverage cov;

  //virtual instance of interface
  virtual AXIS_interface vif;
  //event declare
  event done;
  //mailbox of master generator to driver
  mailbox#(ei_AXIS_master_transaction) gen2drv;
  // //mailbox of master monitor to referance 
  mailbox#(ei_AXIS_master_transaction) mon2scb;
  mailbox mon2cov;
  //method declare
  function new(mailbox#(ei_AXIS_master_transaction) mon2scb);
    this.mon2scb = mon2scb;
  endfunction
   ////////////////////////////////////////////////////////////////////////////////

  // Method name         :   build();

  // Parameters passed   : - none

  // Returned parameters : - none

  // Description         :   to construct the mailbox of master and slave 
  
  ////////////////////////////////////////////////////////////////////////////////
  //build method declare
  function void build();
    if(a_cfg) begin
      //allocate memory to mailbox of master generator to driver
      gen2drv = new();
      mon2cov = new();
      //passing the mailbox and allocate to memory to generator 
      gen = new(gen2drv);
      //passing the mailbox and allocate to memory to driver 
      drv = new(gen2drv);
      //passing the mailbox and allocate to memory to monitor 
      mon = new(mon2scb,mon2cov);
      cov = new(mon2cov);
      //assigning the event
      gen.drv_done = this.done;
      drv.drv_done = this.done;
      //connect virtual interface to driver
      drv.vif = this.vif;
      //connect virtual interface to monitor
      mon.vif = this.vif;
    end
    else begin
      //passing the mailbox and allocate to memory to monitor 
      mon = new(mon2scb,mon2cov);
      cov = new(mon2cov);
      //connect virtual interface to monitor
      mon.vif = this.vif;
    end
  endfunction : build

////////////////////////////////////////////////////////////////////////////////

  // Method name         :   run_t();

  // Parameters passed   : - none

  // Returned parameters : - none

  // Description         :   to run generator , driver and monitor method 
  //                         parallelly.
  
  ////////////////////////////////////////////////////////////////////////////////
  
  //task created
  task run_t();
    if(a_cfg) begin
      //run the method
      fork
        gen.run_t();
        drv.run_t();
        mon.run_t();
	cov.sample_values();
      join
    end
    else begin
      //monitor method run
      mon.run_t();
    end
  endtask : run_t
endclass :ei_AXIS_master_agent
