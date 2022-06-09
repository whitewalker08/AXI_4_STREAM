/*-----------------------------------------------------------------------------



File name    : ei_AXIS_master_transaction.sv



Title        : AXI_stream_master_transaction_class_file



Project      : AXIS_SV_VIP  



Created On   : 02-06-2022



Developers   : einfochips Ltd



Purpose      : this class has all the signals that are required in a packet 
                it has the logic for the randomization of each element in the packet              

               

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




//typedef class ei_AXIS_master_generator;
//typedef bit [7:0] positional_byte;

  
class ei_AXIS_master_transaction;
  
  int count;
  //int TLAST_count;
  int max_count;

  static int num_of_trans;
  //rand logic TVALID;
  //rand logic TREADY;
  logic [7:0] temp_TID;
  logic [3:0] temp_TDEST;
  bit [7:0] pos_byte;
  bit [`DATA_WIDTH-1:0] TDATA_queue[$];
  //int max_count;
  rand logic [(8*(`number_bytes)-1):0] TDATA;
  rand logic [`number_bytes-1:0] TSTRB;
  rand logic [`number_bytes-1:0] TKEEP;
  bit TLAST;
  rand logic [7:0] TID;
  rand logic [3:0] TDEST;
  rand logic [16:0] TUSER;

 ////////////////////////////////////////////////////////////////////////////////
  // Method name :     pre_randomize();

  // Parameters passed : none

  // Returned parameters : - none

  // Description : to update the values of temporary TID and TDEST for future purpose
  //              

  ////////////////////////////////////////////////////////////////////////////////

  function void pre_randomize();
    if(num_of_trans > 0)begin
      temp_TID = TID;
      temp_TDEST = TDEST;  
    end
    
    

  endfunction : pre_randomize

  ////////////////////////////////////////////////////////////////////////////////
  // Method name :    post_randomize;

  // Parameters passed : none

  // Returned parameters : - none

  // Description : to randomize according to the sanity and according to the 
  //               protocol

  ////////////////////////////////////////////////////////////////////////////////
  
  function void post_randomize();
   
    //TVALID = 1;
    //TREADY = 1;
    TDEST.rand_mode(0);
    TSTRB = 0;
    for(int i=0;i<(`number_bytes);i++)begin
      // pos_byte = $random;
      // if($urandom_range(0,1))begin
      //   TDATA[8*i+7-:8] = pos_byte;
      //   TSTRB[i] = 1'b0;
      //end
      // else begin
      //   TSTRB[i] = 1;
      // end
       TSTRB[i] = 1;
    end
    TKEEP = (2**(`number_bytes)-1);
    
    if(num_of_trans == 0)
      count = $urandom_range(3,10);
      max_count = count;
    if(count > 0)begin
      //$display("inside count>0");
      count--;
      if(count == 0)begin
        TLAST = 1;
        count = $urandom_range(3,10);
        max_count = count;
        //TLAST_count++;
        //$display("TLAST_count% 0d:",TLAST_count);
      end
      
      else begin
      TLAST = 0;
      end
      
      if(num_of_trans>0)begin
        TID = temp_TID;
        TDEST = temp_TDEST;
      end
    end
    
    /*else begin
      count = $urandom_range(1,10);
      TLAST = 1;
    end*/
    num_of_trans++;
    
  endfunction : post_randomize

  ////////////////////////////////////////////////////////////////////////////////
  // Method name :    print;

  // Parameters passed : none

  // Returned parameters : - none

  // Description : print method is for display randomized and transfered packet

  ////////////////////////////////////////////////////////////////////////////////
  function void print();
    //$display("TVALID = %0b ",TVALID);
    $display("TDATA = %0b",TDATA);
    $display("TSTRB = %0b",TSTRB);
    $display("TKEEP = %0b",TKEEP);
    $display("TLAST = %0b",TLAST);
    $display("TID = %0b",TID);
    $display("TUSER = %0b",TUSER);

  endfunction : print
  
endclass : ei_AXIS_master_transaction
  
  
  
