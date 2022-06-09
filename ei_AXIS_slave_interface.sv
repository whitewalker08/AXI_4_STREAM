
/*-----------------------------------------------------------------------------



File name    : ei_AXIS_slave_interface.sv



Title        : AXI stream slave interface



Project      : AXIS_SV_VIP  



Created On   : 01-06-2022



Developers   : einfochips Ltd



Purpose      : to provide connection of slave to interconnect
               

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




interface AXIS_slave_interface(input bit ACLK,ARESETn);
  
  //delcared all the signals required for slave
  
  logic TVALID;
  logic TREADY;
  
  logic [(8*(`number_bytes)-1):0] TDATA;
  
  //this commented TDATA_out is for our practice
  //logic [(8*(`number_bytes)-1):0] TDATA_out;
  
  logic [`number_bytes-1:0] TSTRB;
  logic [`number_bytes-1:0] TKEEP;
  logic TLAST;
  logic [7:0] TID;
  logic [3:0] TDEST;
  logic [16:0] TUSER;

  clocking slave_driver_cb @(posedge ACLK);

    default input #0 output #0;
      input TVALID;
      input TDATA;
      input TSTRB;
      input TKEEP;
      input TLAST;
      input TID;
      input TDEST;
      input TUSER;
      output TREADY;

  endclocking

  clocking slave_monitor_cb @(posedge ACLK);
    default input #0 output #0;
    input TVALID;
    input TDATA;
    input TSTRB;
    input TKEEP;
    input TLAST;
    input TID;
    input TDEST;
    input TUSER;
    input TREADY;

  endclocking
  
  modport SLV_DRV(clocking slave_driver_cb,input ACLK,input ARESETn);      		// modport declarations 
  modport SLV_MON(clocking slave_monitor_cb,input ACLK,input ARESETn);

endinterface : AXIS_slave_interface