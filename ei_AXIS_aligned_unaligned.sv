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

class ei_AXI_STREAM_ALIGNED_UNALIGNED_MIXED_STREAM extends ei_AXIS_master_transaction;

    //extended class properties
    bit flag_aligned;
    bit flag_unaligned;



////////////////////////////////////////////////////////////////////////////////
  // Method name(callback method) :    post_randomize;

  // Parameters passed            : - none

  // Returned parameters          : - none

  // Description : to randomize TSTRB according to the aligned and unaligned stream 
  //               according to the  protocol

  ////////////////////////////////////////////////////////////////////////////////
function void post_randomize();
    TDEST.rand_mode(0);
    TSTRB = 0;
    for(int i=0;i<(`number_bytes);i++)begin
        TSTRB[i] = 1'b1;
    end
    TKEEP = (2**(`number_bytes)-1);
    
    if(num_of_trans == 0)begin
      count = $urandom_range(4,10);
    	max_count = count;
    end
      
    

    
    if(count > 0)begin
        TSTRB = 8'hff;
      if(flag_unaligned)begin
      if(count==max_count)begin
        TSTRB  = 8'hff;
        for(int i=0;i<$urandom_range(1,6);i++)begin
            TSTRB[i] = 1'b0;
        end
      end
      end
       count--;

        if(count == 0)begin
            TLAST = 1;
            count = $urandom_range(4,10);
            max_count = count;
            if(flag_unaligned)begin
            TSTRB = 0;
            for(int i=0;i<$urandom_range(1,6);i++)begin
                TSTRB[i] = 1'b1;
            end
            end
            if($urandom_range(0,1))begin
                flag_unaligned = 1'b1;
                flag_aligned = 1'b0;
            end
            else begin
                flag_unaligned = 1'b0;
                flag_aligned = 1'b1;
            end
        end
        
        else begin
            TLAST = 0;
        end
     

    end
 
      
      if(num_of_trans>0)begin
        TID = temp_TID;
        TDEST = temp_TDEST;
      end
    
    num_of_trans++;
endfunction
endclass : ei_AXI_STREAM_ALIGNED_UNALIGNED_MIXED_STREAM
