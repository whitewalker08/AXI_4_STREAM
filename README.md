# AXI STREAM 4 PROTOCOL

SPECIFICATIONS : https://zipcpu.com/doc/axi-stream.pdf

**SPECIFICATIONS READING - PHASE**

 following topics we go through one by one
 
**1.INTRODUCTION**
> About the AXI4-Stream protocol 
>Data streams

**2.Interface Signals**
> 1. Signal list 
> 2. Transfer signaling 
> 3. Data signaling 
> 4. Byte qualifiers 
> 5. Packet boundaries
> 6. Source and destination signaling 
> 7. Clock and Reset 
> 8. User signaling 

**3.Default Signaling Requirements**
> 1. Default value signaling 
> 2. Compatibility considerations

**IMPORTANT TOPICS**
> Hanshaking mechanism
> Transfer signaling
> Packet boundaries
> Byte qualifiers
>> **STREAM TYPE**
> Aligned
> Unaligned
> Sparse



***SPECIFICATIONS Query solve - PHASE***
> * 1 querysheet [question & answer]

***Documentation update- PHASE***
> * 1 feature plan
> * 3 Test plan
> * 4 coverage plan
> * 5 functional Verification Plan


**CODING GUIDELINES FROM MENTORS**
>Transaction should not be randomized in the generator, and it should be randomized by testcase.

>Testcase should be able to get access to environment 

>Transaction class should not be extended to write testcases 

>Testcase should be written in such a way that user should be able to generate the type of transaction user wants. 

>Test configuration class should be there to control testcases. 

>All the constraints should be written in the transaction class required for testcases. 

>VIP will be encrypted for user so there should be one display methods which will guide user that what kind of options are there for user for each testcase 

**FILE STRUCTURE**
./AXI_stream/
├── Development
│   ├── bin
│   ├── env
│   │   └── ei_AXIS_environment.sv
│   ├── scripts
│   ├── src
│   │   ├── ei_AXIS_coverage_packet.sv
│   │   ├── ei_AXIS_coverage.sv
│   │   ├── ei_AXIS_include_all.svh
│   │   ├── ei_AXIS_interconnect.sv
│   │   ├── ei_AXIS_master_agent.sv
│   │   ├── ei_AXIS_master_driver.sv
│   │   ├── ei_AXIS_master_generator.sv
│   │   ├── ei_AXIS_master_interface.sv
│   │   ├── ei_AXIS_master_monitor.sv
│   │   ├── ei_AXIS_master_transaction.sv
│   │   ├── ei_AXIS_scoreboard.sv
│   │   ├── ei_AXIS_slave_agent.sv
│   │   ├── ei_AXIS_slave_driver.sv
│   │   ├── ei_AXIS_slave_interface.sv
│   │   └── ei_AXIS_slave_monitor.sv
│   ├── tb
│   │   └── testbench.sv
│   └── test
│       ├── ei_AXIS_aligned_stream.sv
│       ├── ei_AXIS_config.sv
│       ├── ei_AXIS_error.sv
│       ├── ei_AXIS_single_transfer_with_pos.sv
│       ├── ei_AXIS_sparse_aligned.sv
│       ├── ei_AXIS_sparse_aligned_unaligned.sv
│       ├── ei_AXIS_sparse_stream.sv
│       ├── ei_AXIS_test.sv
│       ├── ei_AXIS_unaligned_stream.sv
│       └── ei_AXIS_write.sv
├── Documentation
│   ├── Coverage_Report
│   └── Verification_Plan
│       ├── coverage\ and\ assertion
│       │   └── Coverage_Plan\ &\ Assertion_plan_Template.xlsx
│       ├── Features\ Plan
│       │   └── Features_Template\ (2).xlsx
│       ├── functional\ verification\ plan
│       ├── Query\ tracking
│       │   └── Query_Tracking_Sheet_Template.xlsx
│       └── Test\ Plan
│           └── Functional_Test_Plan_Template\ .xlsx
└── README.md


