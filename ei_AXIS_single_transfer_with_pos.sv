/*-----------------------------------------------------------------------------



File name    : ei_AXIS_aligned_unaligned.sv



Title        : ei_AXI_STREAM_ALIGNED_UNALIGNED_MIXED_STREAM_file



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

class ei_AXIS_SINGLE_WRITE_WITH_POSITION_TEST extends ei_AXIS_master_transaction;



  ////////////////////////////////////////////////////////////////////////////////

  // Method name(callback method)     : post_randomize();

  // Parameters passed                : - none

  // Returned parameters              : - none

 // Description                       : to randomize TSTRB according to the single transfer
 //                                    with position byte
                   
  
  ////////////////////////////////////////////////////////////////////////////////
   function void post_randomize();
   

    TDEST.rand_mode(0);
    TSTRB = 8'hff;

    //random strobe generate 
    for(int i=0;i<(`number_bytes);i++)begin
      pos_byte = $random;
      if($urandom_range(0,1))begin
        TDATA[8*i+7-:8] = pos_byte;
        TSTRB[i] = 1'b0;
      end
    end
    TKEEP = (2**(`number_bytes)-1);
    
    if(num_of_trans == 0)
      count = 1; //count for single transfer
      
    if(count > 0)begin
      count--;
      if(count == 0)begin
        TLAST = 1;
        count = 1;
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
    
  endfunction
  

endclass : ei_AXIS_SINGLE_WRITE_WITH_POSITION_TEST
