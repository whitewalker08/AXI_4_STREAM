/*-----------------------------------------------------------------------------



File name    : ei_AXIS_video_frame.sv



Title        : ei_AXI_VIDEO_FRAME_TEST_class_file



Project      : AXIS_SV_VIP  



Created On   : 08-06-2022



Developers   : einfochips Ltd



Purpose      : this class is extended from ei_AXIS_master_transaction class
              and used randomize signals to generate diffrent types of tescase   
              according to the protocol .          

              
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

class ei_AXI_VIDEO_FRAME_TEST extends ei_AXIS_master_transaction;

    //extended class properties
    longint count_vs = 0;



////////////////////////////////////////////////////////////////////////////////
  // Method name(callback method) :    post_randomize;

  // Parameters passed            : - none

  // Returned parameters          : - none

  // Description : to randomize TSTRB according to the aligned stream of video frame
  //               according to the  protocol

  ////////////////////////////////////////////////////////////////////////////////
  function void post_randomize();
   
    TDEST.rand_mode(0);
    TSTRB = 0;
    for(int i=0;i<(`number_bytes);i++)begin
       TSTRB[i] = 1;
    end
    TKEEP = (2**(`number_bytes)-1);
    
    if(num_of_trans == 0)
      count_vs = 6220800;    //no of bytes in one video frame 
      //count_vs = 1000;
//      max_count = count;
    if(count_vs > 0)begin
      count_vs--;
      if(count_vs == 0)begin
        TLAST = 1;
        count_vs = 6220800;
      //count_vs = 1000;
//        max_count = count;

      end
      
      else begin
      TLAST = 0;
      end
      
      if(num_of_trans>0)begin
        TID = temp_TID;
        TDEST = temp_TDEST;
      end
    end
    
    num_of_trans++;
    
  endfunction : post_randomize

endclass : ei_AXI_VIDEO_FRAME_TEST