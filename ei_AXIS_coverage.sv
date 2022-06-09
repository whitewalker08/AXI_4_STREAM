/*-----------------------------------------------------------------------------



File name    : ei_AXIS_coverage.sv



Title        : ei_AXIS_coverage_file



Project      : AXIS_SV_VIP 



Created On   : 08-06-2022



Developers   : einfochips Ltd



Purpose      : to measure the functionality and feature of the cases and components



-------------------------------------------------------------------------------



Copyright (c) 2000-2006 eInfochips          - All rights reserved




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
//covergroup declare
covergroup ei_AXIS_covergroup with sample(bit last);

sparse_cp : coverpoint sparse_stream iff(last)
//bins declare
{
    bins bin_low = {2};
    bins bin_med = {[30:35]};
    bins bin_high = {100};
}

aligned_cp : coverpoint aligned_stream iff(last)
//bins declare
{
    bins bin_low = {2};
    bins bin_med = {[30:35]};
    bins bin_high = {100};
}

unaligned_cp : coverpoint unaligned_stream iff(last)
//bins declare
{
    bins bin_low = {2};
    bins bin_med = {[30:35]};
    bins bin_high = {100};
}

len_cp:coverpoint tr.count iff(last)
{
    bins bin_single = {1};
    bins bin_low = {10};
    bins bin_med = {[50:100]};
    bins bin_high = {[101:1000]};
}
//cross coverage
aligned_cp_X_len_cp: cross aligned_cp,len_cp;
unaligned_cp_X_len_cp: cross unaligned_cp,len_cp;
sparse_cp_X_len_cp: cross sparse_cp,len_cp;

endgroup : ei_AXIS_covergroup
