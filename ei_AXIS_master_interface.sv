


/*-----------------------------------------------------------------------------



File name    : ei_AXIS_master_interface.sv



Title        : AXI stream master interface



Project      : AXIS_SV_VIP  



Created On   : 01-06-2022



Developers   : einfochips Ltd



Purpose      : to provide connection of master to interconnect
               

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

//interface with two ports ACLK and ARESETn


interface AXIS_interface(input bit ACLK,ARESETn);
  
  //all the required signals according to the protocol for master
  
  logic TVALID;
  logic TREADY;

  
  logic [(8*(`number_bytes)-1):0] TDATA;
  logic [`number_bytes-1:0] TSTRB;
  logic [`number_bytes-1:0] TKEEP;
  logic TLAST;
  logic [7:0] TID;
  logic [3:0] TDEST;
  logic [16:0] TUSER;

  //clocking block declare for master_driver
  clocking master_driver_cb @(posedge ACLK);
    //default skew input and output
    default input #0 output #0;
    output TVALID;
    output TDATA;
    output TSTRB;
    output TKEEP;
    output TLAST;
    output TID;
    output TDEST;
    output TUSER;
    input TREADY;
  endclocking : master_driver_cb

   //clocking block declare for master_monitor
  clocking master_monitor_cb @(posedge ACLK);
     //default skew input and output
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

  endclocking :master_monitor_cb
  // modport declarations for signal direction
  modport MTR_DRV(clocking master_driver_cb,input ACLK,input ARESETn);      	
  modport MTR_MON(clocking master_monitor_cb,input ACLK,input ARESETn);

/*
//TVALID is LOW for the first cycle after ARESETn goes HIGH 
property TVALID_assert;
 @(posedge ACLK) (!ARESETn) |-> ##0 (!TVALID);
 //$display($time,,,,"***** TVALID_assert Property passed ! *****");
 endproperty


property TVALID_asserted(valid, signal);
 @(posedge ACLK) (valid) |-> $stable(signal);
 endproperty

TVALID_asserted_TID : assert property (TVALID_asserted(TVALID , TID)) 
$display($time,,,,"TID stable , TVALID asserted Property passed !");

TVALID_asserted_TSTRB : assert property (TVALID_asserted(TVALID , TSTRB)) 
$display($time,,,,"TSTRB stable , TVALID asserted Property passed !");

TVALID_asserted_TLAST : assert property (TVALID_asserted(TVALID , TLAST)) 
$display($time,,,,"TLAST stable , TVALID asserted Property passed !");

TVALID_asserted_TKEEP : assert property (TVALID_asserted(TVALID , TKEEP)) 
$display($time,,,,"TKEEP stable , TVALID asserted Property passed !");


// When TVALID is asserted, then it must remain asserted until TREADY is HIGH

property TREADY_high;
 @(posedge ACLK) $rose(TVALID) |-> TVALID[*0:$] ##0 TREADY;
 //$display($time,,,,"===== TREADY_high Property passed ! =====");
endproperty

property unknown(valid , data);
@(posedge ACLK) valid |-> !($isunknown(data));
endproperty

task error_print();
$display("%0m ---> @%0t ################ [Assertion Failed] ################ ",$time);

endtask
TID_unknown : assert property (unknown(TVALID , TID)) else error_print();
TDATA_unknown : assert property (unknown(TVALID , TDATA))else error_print();
TDEST_unknown : assert property (unknown(TVALID , TDEST))else error_print();
TSTRB_unknown : assert property (unknown(TVALID , TSTRB)) else error_print();
TLAST_unknown : assert property (unknown(TVALID , TLAST))else error_print();
TKEEP_unknown : assert property (unknown(TVALID , TKEEP))else error_print();




// all the signals should immediatley deasserted when reset is asserted



property reset_asserted(reset, signal);
@(ARESETn) (ARESETn==0) |-> (!signal);
endproperty

TVALID_Assert : assert property (reset_asserted(ARESETn, TVALID));
TREADY_Assert : assert property (reset_asserted(ARESETn, TREADY));
TID_Assert : assert property (reset_asserted(ARESETn, TID));
TDEST_Assert : assert property (reset_asserted(ARESETn, TDEST));
TSTRB_Assert : assert property (reset_asserted(ARESETn, TSTRB));
TLAST_Assert : assert property (reset_asserted(ARESETn, TLAST));
TKEEP_Assert : assert property (reset_asserted(ARESETn, TKEEP));
TDATA_Assert : assert property (reset_asserted(ARESETn, TDATA));

*/
endinterface : AXIS_interface
