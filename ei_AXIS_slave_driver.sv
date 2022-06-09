`define VSD vif.slave_driver_cb

/*-----------------------------------------------------------------------------



File name    : ei_AXIS_slave_driver.sv



Title        : AXI_stream_slave_driver_class_file



Project      : AXIS_SV_VIP  



Created On   : 02-06-2022



Developers   : einfochips Ltd



Purpose      : to Drive TREADY signal whenever the slave is free  

               

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

//class for AXI stream slave driver
class ei_AXIS_slave_driver;
   
   //ei_AXIS_master_transaction tr;
   //virtual AXIS_slave_interface vif;

   //virtual instance for axi slave interface
   virtual AXIS_slave_interface vif;

   bit [1:0] sel;
   //bit [`DATA_WIDTH-1:0] AXIS_slave_mem[int];

   //event done_write;
   //static int count;
   
   //function new();
     //tr = new();
   //endfunction

   ////////////////////////////////////////////////////////////////////////////////

  // Method name         : run_t();

  // Parameters passed   : - none

  // Returned parameters : - none

  // Description         : to run slave driver , whenever TVALID is detected it should drive
  //                       the TREADY signal for one clock pulse
  
  ////////////////////////////////////////////////////////////////////////////////
   task run_t();
           
           
           forever begin
             
             fork:process_slave_driver
               
             slave_driver_logic:begin
             sel = $urandom_range(0,2);
             
             if(sel==1)begin
               @(posedge vif.ACLK iff(`VSD.TVALID==1 && vif.ARESETn==1));
             //$display("entered ready");
             @(posedge vif.ACLK);
             `VSD.TREADY <= 1;
                if(ei_AXIS_config::verbosity == "MEDIUM")begin
               $display("=====================================================");
       		   $display("[SLAVE-DRV] : TREADY driven to The Interface !");
               $display("=====================================================");
             end
             
             if(ei_AXIS_config::verbosity == "HIGH")begin
               $display("=====================================================");
               $display("[SLAVE-DRV] : TREADY driven to The Interface !");
               $display("====================================================");
             end
               
             @(posedge vif.ACLK);
             //$display("ready 0");
             `VSD.TREADY <= 0;
             end
             else if(sel==0)begin
               @(posedge vif.ACLK iff(vif.ARESETn==1));
             `VSD.TREADY <= 1;
                if(ei_AXIS_config::verbosity == "MEDIUM")begin
               $display("=====================================================");
       		   $display("[SLAVE-DRV] : TREADY driven to The Interface !");
               $display("=====================================================");
             end
             
             if(ei_AXIS_config::verbosity == "HIGH")begin
               $display("=====================================================");
               $display("[SLAVE-DRV] : TREADY driven to The Interface !");
               $display("====================================================");
             end
               
             @(posedge vif.ACLK);
             //$display("ready 0");
             `VSD.TREADY <= 0;
             end
             
             else if(sel == 2)begin
               if(vif.ARESETn == 1)begin
               `VSD.TREADY <= 1;
                if(ei_AXIS_config::verbosity == "MEDIUM")begin
               $display("=====================================================");
       		   $display("[SLAVE-DRV] : TREADY driven to The Interface !");
               $display("=====================================================");
             end
             
             if(ei_AXIS_config::verbosity == "HIGH")begin
               $display("=====================================================");
               $display("[SLAVE-DRV] : TREADY driven to The Interface !");
               $display("====================================================");
             end
             end
             end
               end
             

              begin : reset_logic
                forever begin
                  @(`VSD);
                  if(vif.ARESETn == 1'b0) begin
                          
                    `VSD.TREADY <= 0;
                    break;
                  end
                end
              end
             
             join_any
          
          disable process_slave_driver;
            


        /*if(ei_AXIS_config::verbosity == "LOW")begin
        $display("=====================================================");
        $display("[SLAVE-DRV] : TREADY driven to The Interface !");
        $display("=====================================================");

        end*/
       
           end
     
   endtask : run_t
   
 endclass : ei_AXIS_slave_driver
     
     