/*-----------------------------------------------------------------------------



File name    : ei_AXIS_master_driver.sv



Title        : AXI_stream_master_driver_class_file



Project      : AXIS_SV_VIP  



Created On   : 02-06-2022



Developers   : einfochips Ltd



Purpose      : to Drive all signals recived from master generator to the interface  

               

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
//class for  master Driver
`define VMD vif.master_driver_cb 
class  ei_driver;
	virtual AXIS_interface vif;

    //event for synchronization
  	event drv_done;

    //create instance of ei_AXIS_master_transaction class
	  ei_AXIS_master_transaction tr;
	
    //mailbox master generator to driver
	  mailbox#(ei_AXIS_master_transaction) gen2drv;
    
  ////////////////////////////////////////////////////////////////////////////////
  // Method name :       new();

  // Parameters passed : mailbox gen2drv

  // Returned parameters : - none

  // Description :
  //              connect mailbox of class to actual mailbox.

////////////////////////////////////////////////////////////////////////////////
	function new(mailbox#(ei_AXIS_master_transaction) gen2drv);
		this.gen2drv = gen2drv;  
	endfunction


////////////////////////////////////////////////////////////////////////////////

  // Method name         : run_t();

  // Parameters passed   : - none

  // Returned parameters : - none

  // Description         : to run master driver ,put values from packet to the interface
  //                       (packet level to pin level conversion)
  
  ////////////////////////////////////////////////////////////////////////////////
  
	task run_t();
				forever begin
              //$display(vif.ACLK);
          gen2drv.get(tr);
          
          fork : process_master_driver
              
          begin : master_driver_logic
              
              
                //$display("handshake");
                //$display("DRIVER vif",vif.ACLK);
                @(posedge vif.ACLK iff (vif.ARESETn==1));
                //$display("ACLK");
                
             

                //drive singnals into interface through virtual interface
                `VMD.TVALID <= 1;         
                `VMD.TDATA <= tr.TDATA;
                `VMD.TSTRB <= tr.TSTRB;
                `VMD.TKEEP <= tr.TKEEP;
                `VMD.TUSER <= tr.TUSER;
                
                if(tr.TLAST == 1)begin
                  end
                
                else begin
                    `VMD.TID <= tr.TID;
                    `VMD.TDEST <= tr.TDEST;
                  end
          
                `VMD.TLAST <= tr.TLAST;
                // $display("ready");
           		if(ei_AXIS_config::verbosity == "MEDIUM")begin
                  $display("=====================================================");
                  $display("@%0t [MASTER-DRV] : Converting Packet level signals to pin level Signal",$time);
                  $display("@%0t [MASTER-DRV] : data driven to The Interface !",$time);
                  $display("=====================================================");
                end

        		if(ei_AXIS_config::verbosity == "HIGH")begin
                  $display("=====================================================");
                  $display("@%0t [MASTER-DRV] : Converting Packet level signals to pin level Signal",$time);
                  tr.print();
                  $display("@%0t [MASTER-DRV] : data driven to The Interface !",$time);
                  $display("====================================================");
                end
                

                
                wait(vif.TREADY==1)
                //$display("after ready");
                @(posedge vif.ACLK)
                `VMD.TLAST <= 0;
                `VMD.TVALID <= 0;
                `VMD.TDATA <= 'hz;
                
                //$display("event finished");
            
          end
            //$display("event finished");
          begin : reset_logic
			forever begin
              @(`VMD);
			  if(vif.ARESETn == 1'b0) begin
                `VMD.TVALID <= 0;
                `VMD.TDATA <= 'hz;
                `VMD.TSTRB <= 'hz;
                `VMD.TKEEP <= 'hz;
                `VMD.TID <= 'hz;
                `VMD.TLAST <= 0;
                break;
              end
            end
          end
          
          join_any
          
          disable process_master_driver;
          ->drv_done;


      end
      
  endtask: run_t
  
endclass: ei_driver
  