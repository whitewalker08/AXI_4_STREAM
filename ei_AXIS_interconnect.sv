


/*-----------------------------------------------------------------------------



File name    : ei_AXIS_interconnect.sv



Title        : AXI stream interconnect



Project      : AXIS_SV_VIP  



Created On   : 01-06-2022



Developers   : einfochips Ltd



Purpose      : to connect slave and master interface
			   pass the signal values of slave to master and vice versa
               updating TDATA and related signals if required

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

//class for interconnect
//`define VMD vif_m.master_driver_cb 
//`define VSD vif_S.slave_driver_cb

class ei_AXIS_interconnect;
  
  //vitual instance of slave interface
  virtual AXIS_slave_interface vif_S;
  
  //virtual instance of master interface
  virtual AXIS_interface vif_m;
  
  
  //event drv_done;
  
  ////////////////////////////////////////////////////////////////////////////////

  // Method name         : run_t();

  // Parameters passed   : - none

  // Returned parameters : - none

  // Description         : to provide the outputs of the slave to master interface
  //                       to provide the outputs of master to slave interface
  //                       update the values of TDATA,TSTRB and TKEEP if required
  
  ////////////////////////////////////////////////////////////////////////////////
  
  task run_t();
    forever begin
      @(vif_m.TVALID,vif_S.TREADY)
      vif_S.TVALID <= vif_m.TVALID;
      vif_m.TREADY <= vif_S.TREADY;
      vif_S.TDATA <= vif_m.TDATA;
      vif_S.TLAST <= vif_m.TLAST;
      vif_S.TSTRB <= vif_m.TSTRB;
      vif_S.TKEEP <= vif_m.TKEEP;
      vif_S.TUSER <= vif_m.TUSER;
    end
  endtask:run_t
  
endclass : ei_AXIS_interconnect