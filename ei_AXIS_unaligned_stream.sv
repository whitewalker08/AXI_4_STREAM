/*-----------------------------------------------------------------------------



File name    : ei_AXIS_unaligned_stream.sv



Title        : ei_AXI_UNALIGNED_STREAM_TEST_class_file



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


class ei_AXIS_UNALIGNED_STREAM_TEST extends ei_AXIS_master_transaction;

  

  ////////////////////////////////////////////////////////////////////////////////

  // Method name(callback method)     : post_randomize();

  // Parameters passed                : - none

  // Returned parameters              : - none

  // Description                      : this function will perform post_randomization 
  //                                    function where randomly TSTRB will generate 
  //                                    for unaligned stream.                    
  
  ////////////////////////////////////////////////////////////////////////////////
 
  
  function void post_randomize();

    TDEST.rand_mode(0);
    TSTRB = 0;
    for(int i=0;i<(`number_bytes);i++)begin
        TSTRB[i] = 1'b1;
    end
    TKEEP = (2**(`number_bytes)-1);
    
    if(num_of_trans == 0)begin
      //lenght of stream
      count = $urandom_range(4,10);
    	max_count = count;
    end
      
    

    
    if(count > 0)begin
        TSTRB = 8'hff;
      
      if(count==max_count)begin
        TSTRB  = 8'hff;
        for(int i=0;i<$urandom_range(1,6);i++)begin
            TSTRB[i] = 1'b0;
        end
    end
       count--;

     if(count == 0)begin
        TLAST = 1;
        //lenght of stream
        count = $urandom_range(4,10);
        max_count = count;
        TSTRB = 0;
       for(int i=0;i<$urandom_range(1,6);i++)begin
            TSTRB[i] = 1'b1;
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
  

endclass : ei_AXIS_UNALIGNED_STREAM_TEST

