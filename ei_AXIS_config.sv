/*-----------------------------------------------------------------------------



File name    : ei_AXIS_config.sv



Title        : AXI_stream_config_class_file



Project      : AXIS_SV_VIP  



Created On   : 02-06-2022



Developers   : einfochips Ltd



Purpose      : to connect the two agent and other components and run the agent.

               

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

////////////////////////////////    macros    /////////////////////////////////


`define DATA_WIDTH 64
`define number_bytes 8



////////////////////////////////////////////////////////////////////////////////


/////////////////////////    static properties    //////////////////////////////
class ei_AXIS_config;

    // static string for testcase
    static string testname;
    //static string for verbosity
    static string verbosity = "LOW";

endclass


////////////////////////////////////////////////////////////////////////////////