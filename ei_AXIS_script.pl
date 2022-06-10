#!/usr/bin/perl


print("----------------------Start-------------------------------\n");
jump_statement:
print("----------------------------------------------------------\n");
print("\nplease enter Lower limit of burst : ");
$lower_limit = <STDIN>;
chomp $lower_limit;

print("\nplease enter upper limit of burst : ");
$upper_limit = <STDIN>;
chomp $upper_limit;

print("\nplease enter Number of transactions : ");
$trans = <STDIN>;
chomp $trans;

system("vcs -full64 -debug_access+r -sverilog +define+lower_limit=$lower_limit +define+upper_limit=$upper_limit +define+no_of_trans=$trans testbench.sv");

print("-----------------------TESTCASES------------------------\n");
print("1.AXIS_SANITY_TEST\n");
print("2.AXIS_RANDOM_LENGTH_TEST\n");
print("3.AXIS_UNALIGNED_STREAM_TEST\n");
print("4.AXIS_SPARSE_STREAM_TEST\n");
print("5.AXIS_SINGLE_WRITE_WITH_POSITION_TEST\n");
print("6.AXIS_ALIGNED_SPARSE_MIXED_STREAM\n");
print("7.AXIS_STREAM_ALIGNED_UNALIGNED_MIXED_STREAM\n");
print("8.AXIS_STREAM_SPARSE_UNALIGNED_MIXED_STREAM\n");
print("9.AXIS_STREAM_SPARSE_ALIGNED_UNALIGNED_MIXED_STREAM\n");
print("10.AXIS_VIDEO_FRAME_TEST\n");
print("11.RESET_TEST\n");
print("12.ALL_TESTCASES\n");
print("------------------------------------------------\n");
print("Please Enter the testcase no from above : ");

$user=<STDIN>;



if($user==1) {
system("./simv +testname=AXIS_WRITE_SEQ   ");#case-1
system("urg -dir simv.vdb");#command for generating coverage report
system("mv /home/mihir.darji/SV_PROJECT/AXIS_V6/simv.vdb /home/mihir.darji/SV_PROJECT/AXIS_V6/simv1.vdb");
}



if($user==2) {
system("./simv   ");#case-2
system("urg -dir simv.vdb");#command for generating coverage report
system("mv /home/mihir.darji/SV_PROJECT/AXIS_V6/simv.vdb /home/mihir.darji/SV_PROJECT/AXIS_V6/simv2.vdb");
}



if($user==3) {
system("./simv +testname=AXIS_UNALIGNED_STREAM   ");#case-3
system("urg -dir simv.vdb");#command for generating coverage report
system("mv /home/mihir.darji/SV_PROJECT/AXIS_V6/simv.vdb /home/mihir.darji/SV_PROJECT/AXIS_V6/simv3.vdb ");
}



if($user==4){
system("./simv +testname=AXIS_SPARSE_STREAM   ");#case-4
system("urg -dir simv.vdb");#command for generating coverage report
system("mv /home/mihir.darji/SV_PROJECT/AXIS_V6/simv.vdb /home/mihir.darji/SV_PROJECT/AXIS_V6/simv4.vdb ");
}



if($user==5) {
system("./simv +testname=AXIS_SINGLE_TRANSFER_WITH_POSITION   ");
system("urg -dir simv.vdb");#command for generating coverage report
system("mv /home/mihir.darji/SV_PROJECT/AXIS_V6/simv.vdb /home/mihir.darji/SV_PROJECT/AXIS_V6/simv5.vdb ");



}



if($user==6) {
system("./simv +testname=AXIS_ALIGNED_SPARSE_STREAM   ");
system("urg -dir simv.vdb");#command for generating coverage report
system("mv /home/mihir.darji/SV_PROJECT/AXIS_V6/simv.vdb /home/mihir.darji/SV_PROJECT/AXIS_V6/simv6.vdb ");



}



if($user==7) {
system("./simv +testname=AXIS_ALIGNED_UNALIGNED_STREAM   ");
system("urg -dir simv.vdb");#command for generating coverage report
system("mv /home/mihir.darji/SV_PROJECT/AXIS_V6/simv.vdb /home/mihir.darji/SV_PROJECT/AXIS_V6/simv7.vdb ");




}



if($user==8) {
system("./simv +testname=AXIS_SPARSE_UNALIGNED_STREAM   ");
system("urg -dir simv.vdb");#command for generating coverage report
system("mv /home/mihir.darji/SV_PROJECT/AXIS_V6/simv.vdb /home/mihir.darji/SV_PROJECT/AXIS_V6/simv8.vdb ");



}



if($user==9) {
system("./simv +testname=AXIS_SPARSE_ALIGNED_UNALIGNED_STREAM   ");
system("urg -dir simv.vdb");#command for generating coverage report
system("mv /home/mihir.darji/SV_PROJECT/AXIS_V6/simv.vdb /home/mihir.darji/SV_PROJECT/AXIS_V6/simv9.vdb ");



}



if($user==10) {
system("./simv +testname=AXIS_VIDEO_FRAME   ");
# system("urg -dir simv.vdb");#command for generating coverage report
system("mv /home/mihir.darji/SV_PROJECT/AXIS_V6/simv.vdb /home/mihir.darji/SV_PROJECT/AXIS_V6/simv10.vdb ");



}



if($user==11) {
system("./simv +testname=reset_test   ");
system("urg -dir simv.vdb");#command for generating coverage report
system("mv /home/mihir.darji/SV_PROJECT/AXIS_V6/simv.vdb /home/mihir.darji/SV_PROJECT/AXIS_V6/simv11.vdb ");



}



if($user==12) {
system("./simv +testname=AXIS_WRITE_SEQ");#case-1
# system("urg -dir simv.vdb");#command for generating coverage report
system("mv /home/mihir.darji/SV_PROJECT/AXIS_V6/simv.vdb /home/mihir.darji/SV_PROJECT/AXIS_V6/simv1.vdb ");



system("./simv");#case-2
#system("urg -dir simv.vdb");#command for generating coverage report
system("mv /home/mihir.darji/SV_PROJECT/AXIS_V6/simv.vdb /home/mihir.darji/SV_PROJECT/AXIS_V6/simv2.vdb ");



system("./simv +testname=AXIS_UNALIGNED_STREAM");#case-3
# system("urg -dir simv.vdb");#command for generating coverage report
system("mv /home/mihir.darji/SV_PROJECT/AXIS_V6/simv.vdb /home/mihir.darji/SV_PROJECT/AXIS_V6/simv3.vdb ");



system("./simv +testname=AXIS_SPARSE_STREAM");#case-4
#system("urg -dir simv.vdb");#command for generating coverage report
system("mv /home/mihir.darji/SV_PROJECT/AXIS_V6/simv.vdb /home/mihir.darji/SV_PROJECT/AXIS_V6/simv4.vdb ");



system("./simv +testname=AXIS_SINGLE_TRANSFER_WITH_POSITION");
# system("urg -dir simv.vdb");#command for generating coverage report
system("mv /home/mihir.darji/SV_PROJECT/AXIS_V6/simv.vdb /home/mihir.darji/SV_PROJECT/AXIS_V6/simv5.vdb ");




system("./simv +testname=AXIS_ALIGNED_SPARSE_STREAM");
#system("urg -dir simv.vdb");#command for generating coverage report
system("mv /home/mihir.darji/SV_PROJECT/AXIS_V6/simv.vdb /home/mihir.darji/SV_PROJECT/AXIS_V6/simv6.vdb ");





system("./simv +testname=AXIS_ALIGNED_UNALIGNED_STREAM");
# system("urg -dir simv.vdb");#command for generating coverage report
system("mv /home/mihir.darji/SV_PROJECT/AXIS_V6/simv.vdb /home/mihir.darji/SV_PROJECT/AXIS_V6/simv7.vdb ");




system("./simv +testname=AXIS_SPARSE_UNALIGNED_STREAM");
#system("urg -dir simv.vdb");#command for generating coverage report
system("mv /home/mihir.darji/SV_PROJECT/AXIS_V6/simv.vdb /home/mihir.darji/SV_PROJECT/AXIS_V6/simv8.vdb ");




system("./simv +testname=AXIS_SPARSE_ALIGNED_UNALIGNED_STREAM");
# system("urg -dir simv.vdb");#command for generating coverage report
system("mv /home/mihir.darji/SV_PROJECT/AXIS_V6/simv.vdb /home/mihir.darji/SV_PROJECT/AXIS_V6/simv9.vdb ");



system("./simv +testname=reset_test");
#system("urg -dir simv.vdb");#command for generating coverage report
system("mv /home/mihir.darji/SV_PROJECT/AXIS_V6/simv.vdb /home/mihir.darji/SV_PROJECT/AXIS_V6/simv10.vdb ");



#command to generate combined coverage report for all testcases
system("urg -full64 -dir simv1.vdb -dir simv2.vdb -dir simv3.vdb -dir simv4.vdb -dir simv5.vdb -dir simv6.vdb -dir simv7.vdb -dir simv8.vdb -dir simv9.vdb -dir simv10.vdb -dbname mergedir/merged");



#system("urg -full64 -dir simv1.vdb -dir simv2.vdb -dir simv3.vdb -dir simv4.vdb -dir simv5.vdb -dir simv6.vdb -dir simv7.vdb -dir simv8.vdb -dir simv9.vdb -dir simv10.vdb -dir simv11.vdb -dir simv12.vdb -dir simv13.vdb -dir simv14.vdb -dir simv15.vdb -dir simv16.vdb -dir simv17.vdb -dbname mergedir/merged");
}


print "------------------------- END ----------------------\n";


print "===============================================================";
print "If you want to see waveform of above Testcase ,Please type : 1\n";
print "If you want to run next TestCase, Please type : 2\n";
print "If you want to simulate into command prompt(./simv), Please type : 3\n";
print "If you want to terminate Process hit ENTER\n";
print "===============================================================";





$user_continues=<STDIN>;



if($user_continues==1)
{
system("./simv -gui");
print "\n";
}
if($user_continues==2)
{
goto jump_statement;
print "\n";
}
if($user_continues==3)
{
system("./simv");
print "\n";
}




print("-------------------------END--------------------------\n");

