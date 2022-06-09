///////////////////////////////////////////////////////////////////////////////
/*-----------------------------------------------------------------------------



File name    : ei_AXIS_aligned_sparse.sv



Title        : ei_AXI_STREAM_ALIGNED_SPARSE_MIXED_STREAM_file



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

class ei_AXIS_ALIGNED_SPARSE_MIXED_STREAM extends ei_AXIS_master_transaction;

    //extended class properties
    bit flag_aligned;
    bit flag_sparse;

  rand bit [2:0] temp_pos_no = $urandom_range(5,7);

  constraint sparse_stream {TSTRB == $countones(temp_pos_no);}

 ////////////////////////////////////////////////////////////////////////////////
  // Method name(callback method) :    post_randomize;

  // Parameters passed            : - none

  // Returned parameters          : - none

  // Description : to randomize TSTRB according to the aligned and sparse stream 
  //               according to the  protocol

  ////////////////////////////////////////////////////////////////////////////////
function void post_randomize();

    TDEST.rand_mode(0);
    

    //if sparse flag selected it will generate sparse stream
    if(flag_sparse)begin
    //TSTRB = 'hff;
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
    
    //no of transfer randomly
    if(num_of_trans == 0)begin
      count = $urandom_range(4,10);
    end
    
       count--;  


     if(count == 0)begin
        
        TLAST = 1;
        count = $urandom_range(4,10);

        //select randomly aligned or sparse stream flag 
        if($urandom_range(0,1))begin
            flag_sparse = 1'b1;
            flag_aligned = 1'b0;
        end
        else begin
            flag_aligned = 1'b1;
            flag_sparse = 1'b0;
        end
        end
      
      
      else begin
      TLAST = 0;
      end
      
      if(num_of_trans>0)begin
        TID = temp_TID;
        TDEST = temp_TDEST;
      end
  
    num_of_trans++;

endfunction : post_randomize

endclass : ei_AXIS_ALIGNED_SPARSE_MIXED_STREAM
