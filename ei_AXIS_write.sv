class ei_AXIS_ONLY_WRITE_TEST extends ei_AXIS_master_transaction;


  ////////////////////////////////////////////////////////////////////////////////

  // Method name(callback method)     : post_randomize();

  // Parameters passed                : - none

  // Returned parameters              : - none

  // Description                      : this function will perform post_randomization 
  //                                    function                      
  
  ////////////////////////////////////////////////////////////////////////////////
   function void post_randomize();
   
    //TVALID = 1;
    //TREADY = 1;
    TDEST.rand_mode(0);
    TSTRB = 0;
    for(int i=0;i<(`number_bytes);i++)begin
      /*pos_byte = $random;
      if($urandom_range(0,1))begin
        TDATA[8*i+7-:8] = pos_byte;*/
        TSTRB[i] = 1'b1;
      //end
    end
    TKEEP = (2**(`number_bytes)-1);
    
    if(num_of_trans == 0)
      count = 1;
      
    if(count > 0)begin
      //$display("inside count>0");
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
    
    /*else begin
      count = $urandom_range(1,10);
      TLAST = 1;
    end*/
    num_of_trans++;
    
  endfunction
  

endclass : ei_AXIS_ONLY_WRITE_TEST

