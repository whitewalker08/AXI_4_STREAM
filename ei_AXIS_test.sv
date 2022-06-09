/*-----------------------------------------------------------------------------



File name    : ei_AXIS_test.sv



Title        : AXI_stream_test_program_file



Project      : AXIS_SV_VIP  



Created On   : 02-06-2022



Developers   : einfochips Ltd



Purpose      : to create envitonment and connect to the interfaces
               to run diffrent testcases
               ti run environment  

               

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
//program block of AXIS_test
//passing virtual interface handle of both physical interface as argument
program AXIS_test(AXIS_interface vif,AXIS_slave_interface vif_s); 

    // create instance of environment class
    ei_AXIS_environment env;  

    //Temp. dummy bit for testcases
    bit dummy1;
    //Temp. dummy bit for verbosity
    bit dummy2;  

    //instance of ei_AXIS_ONLY_WRITE_TEST class for testcase
    ei_AXIS_ONLY_WRITE_TEST seq_write; 
    ei_AXIS_UNALIGNED_STREAM_TEST unalign_stream; 
    ei_AXIS_SPARSE_STREAM_TEST sparse_stream;
    ei_AXIS_SINGLE_WRITE_WITH_POSITION_TEST single_write_with_pos;
    ei_AXIS_ALIGNED_SPARSE_MIXED_STREAM aligned_sparse;
    ei_AXI_STREAM_ALIGNED_UNALIGNED_MIXED_STREAM aligned_unaligned;
    ei_AXI_STREAM_SPARSE_UNALIGNED_MIXED_STREAM sparse_unaligned;
    ei_AXI_STREAM_SPARSE_ALIGNED_UNALIGNED_MIXED_STREAM sparse_aligned_unaligned;
    ei_AXI_VIDEO_FRAME_TEST video_frame;

    initial begin

      //construct environment
      env = new();  

      //connect master interface
      env.vif_m = vif; 
      //connect slave interface       
      env.vif_s = vif_s;      

      //build environment class
      env.build();  
        
      //command line argument for testcase
      dummy1 = $value$plusargs("testname=%s",ei_AXIS_config::testname);  
      dummy2 = $value$plusargs("verbosity=%s",ei_AXIS_config::verbosity);  

      if(ei_AXIS_config::testname=="AXIS_WRITE_SEQ") begin
            //Allocation of memory to the seq_write hendle
            seq_write = new();     
            //assign testcase class to the generator by blueprint method
            env.m_agt.gen.blueprint = seq_write;   
      end

      if(ei_AXIS_config::testname=="AXIS_SPARSE_STREAM") begin
            //Allocation of memory to the unalign_stream hendle
            sparse_stream = new();     
            //assign testcase class to the generator by blueprint method
            env.m_agt.gen.blueprint = sparse_stream;   
      end

      if(ei_AXIS_config::testname=="AXIS_SINGLE_TRANSFER_WITH_POSITION") begin
            //Allocation of memory to the unalign_stream hendle
            single_write_with_pos= new();     
            //assign testcase class to the generator by blueprint method
            env.m_agt.gen.blueprint = single_write_with_pos;   
      end

      if(ei_AXIS_config::testname=="AXIS_UNALIGNED_STREAM") begin
            //Allocation of memory to the unalign_stream hendle
            unalign_stream = new();     
            //assign testcase class to the generator by blueprint method
            env.m_agt.gen.blueprint = unalign_stream;   
      end

      if(ei_AXIS_config::testname=="AXIS_ALIGNED_SPARSE_STREAM") begin
            //Allocation of memory to the unalign_stream hendle
            aligned_sparse = new();     
            //assign testcase class to the generator by blueprint method
            env.m_agt.gen.blueprint = aligned_sparse;   
      end

      if(ei_AXIS_config::testname=="AXIS_ALIGNED_UNALIGNED_STREAM") begin
            //Allocation of memory to the unalign_stream hendle
            aligned_unaligned = new();     
            //assign testcase class to the generator by blueprint method
            env.m_agt.gen.blueprint = aligned_unaligned;   
      end

      if(ei_AXIS_config::testname=="AXIS_SPARSE_UNALIGNED_STREAM") begin
            //Allocation of memory to the seq_write hendle
            sparse_unaligned = new();     
            //assign testcase class to the generator by blueprint method
            env.m_agt.gen.blueprint = sparse_unaligned;   
      end

       if(ei_AXIS_config::testname=="AXIS_SPARSE_ALIGNED_UNALIGNED_STREAM") begin
            //Allocation of memory to the seq_write hendle
            sparse_aligned_unaligned = new();     
            //assign testcase class to the generator by blueprint method
            env.m_agt.gen.blueprint = sparse_aligned_unaligned;   
      end

     if(ei_AXIS_config::testname=="AXIS_VIDEO_FRAME") begin
            //Allocation of memory to the seq_write hendle
            video_frame = new();     
            //assign testcase class to the generator by blueprint method
            env.m_agt.gen.blueprint = video_frame;   
      end
      //run environment class
      env.run_t(); 
      //end
    end
endprogram
