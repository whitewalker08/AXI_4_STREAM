/*-----------------------------------------------------------------------------



File name    : ei_AXIS_environment.sv



Title        : AXI_stream_environment_class_file



Project      : AXIS_SV_VIP  



Created On   : 02-06-2022



Developers   : einfochips Ltd



Purpose      : to connect the two agent and other components and run the agent.

               

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
//class for environment
class ei_AXIS_environment;
    //declare master_agent handle 
    ei_AXIS_master_agent#(.a_cfg(1'b1)) m_agt;
     //declare slave_agent handle 
    ei_AXIS_slave_agent#(.a_cfg(1'b1)) s_agt;
    //declare handle of scoboard
    ei_AXIS_scoreboard scb;
  	//declare instance of interconnect
  	//ei_AXIS_interconnect intr;

  //mailbox slave monitor to scoreboard
  mailbox#(ei_AXIS_master_transaction) mon_slv2scb;
  //mailbox master monitor to scoreboard
  mailbox#(ei_AXIS_master_transaction) mon2scb;

    //vitual instance of slave interface  
    virtual AXIS_slave_interface vif_s;
    //vitual instance of master interface
	virtual AXIS_interface vif_m;

  ////////////////////////////////////////////////////////////////////////////////

  // Method name         :   build();

  // Parameters passed   : - none

  // Returned parameters : - none

  // Description         :   to construct the mailbox of master and slave and run the 
  //                         build method.
  
  ////////////////////////////////////////////////////////////////////////////////
    
    //build method declare
    function void build();

        //allocate the momory to master mon to sco mailbox
        mon2scb = new();
        //allocate the momory to slave mon to sco mailbox
        mon_slv2scb = new();
        //instance of the master and slave mailbox to the scoreboard 
        scb = new(.mon2scb(mon2scb),.mon_slv2scb(mon_slv2scb));
        //passing the master mailbox and allocate memory to master agent 
        m_agt = new(mon2scb);
         //passing the slave mailbox and allocate memory to master agent 
        s_agt = new(mon_slv2scb);
        //connect the master interface to master agent
        m_agt.vif = this.vif_m;
        //connect the slave interface to slave agent
        s_agt.vif = this.vif_s;
        //intr = new();
      	//intr.vif_m = vif_m;
      	//intr.vif_S = vif_s;
        //run the build method
      	m_agt.build();
      	s_agt.build();

    endfunction 

 ////////////////////////////////////////////////////////////////////////////////

  // Method name         : run_t();

  // Parameters passed   : - none

  // Returned parameters : - none

  // Description         : to run master agent ,slave agent and scoreboar method 
  //                       parallelly.
  
  ////////////////////////////////////////////////////////////////////////////////
    
    //task declare
    task run_t();
        
       //run the all task
        fork
            //intr.run_t();
            m_agt.run_t();
            s_agt.run_t();
            scb.run_t();
        join

    endtask : run_t

endclass :ei_AXIS_environment 