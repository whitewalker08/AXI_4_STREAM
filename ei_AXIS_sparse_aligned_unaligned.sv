/*-----------------------------------------------------------------------------



File name    : ei_AXIS_sparse_aligned_unaligned.sv



Title        : ei_AXI_STREAM_SPARSE_ALIGNED_UNALIGNED_MIXED_STREAM_class_file



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

class ei_AXI_STREAM_SPARSE_ALIGNED_UNALIGNED_MIXED_STREAM extends ei_AXIS_master_transaction;

  bit flag_unaligned;
  bit flag_sparse;
  bit flag_aligned;
  bit [1:0] sel;

  rand bit [2:0] temp_pos_no = $urandom_range(5,7);

  constraint sparse_stream {TSTRB == $countones(temp_pos_no);}

  ////////////////////////////////////////////////////////////////////////////////

  // Method name(callback method)     : post_randomize();

  // Parameters passed                : - none

  // Returned parameters              : - none

  // Description                      : this function will perform post_randomization 
  //                                    function where randomly TSTRB will generate 
  //                                    for aligned stream , unaligned stream 
  //                                    sparse stream randomly.                    
  
  ////////////////////////////////////////////////////////////////////////////////
 
  
  function void post_randomize();
   
    TDEST.rand_mode(0);
    

    //generate sparse stream strobe according to flag 
    if(flag_sparse)begin
    /*for(int i=0;i<(`number_bytes);i++)begin
      pos_byte = $random;
      if($urandom_range(0,1))begin
        TDATA[8*i+7-:8] = pos_byte;
        TSTRB[i] = 1'b0;
      end
    end*/
    end
   else begin
   TSTRB = 8'hff;
   end
    TKEEP = (2**(`number_bytes)-1);
    
    if(num_of_trans == 0)begin
      //count for stream lenght
      count = $urandom_range(4,10);
    	max_count = count;
    end
      
    

    
    if(count > 0)begin
      //generate unaligned stream strobe according to flag 
      if(flag_unaligned)begin
      if(count==max_count)begin
        TSTRB  = 8'hff;
        for(int i=0;i<$urandom_range(1,6);i++)begin
            TSTRB[i] = 1'b0;
        end
      end
      end
       count--;
      //$display("inside count>0");
        if(count == 0)begin
            TLAST = 1;
            //count for stream lenght
            count = $urandom_range(4,10);
            max_count = count;
            if(flag_unaligned)begin
            TSTRB = 0;
            for(int i=0;i<$urandom_range(1,6);i++)begin
                TSTRB[i] = 1'b1;
            end
            end
            //randomly select stream type according to the flag 
            sel = $urandom_range(0,2);
            if(sel==1)begin
                flag_unaligned = 1;
                flag_sparse = 0;
            end
            else if(sel==0)begin
                flag_unaligned = 0;
                flag_sparse = 1;
            end

            else if(sel==2)begin
                flag_unaligned = 0;
                flag_sparse = 0;
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
    
    
    /*else begin
      count = $urandom_range(1,10);
      TLAST = 1;
    end*/
    num_of_trans++;
endfunction
  
  

endclass : ei_AXI_STREAM_SPARSE_ALIGNED_UNALIGNED_MIXED_STREAM
