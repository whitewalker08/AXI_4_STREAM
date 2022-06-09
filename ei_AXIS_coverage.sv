
covergroup ei_AXIS_covergroup with sample(bit last);

sparse_cp : coverpoint sparse_stream iff(last)
{
    bins bin_low = {2};
    bins bin_med = {[30:35]};
    bins bin_high = {100};
}

aligned_cp : coverpoint aligned_stream iff(last)
{
    bins bin_low = {2};
    bins bin_med = {[30:35]};
    bins bin_high = {100};
}

unaligned_cp : coverpoint unaligned_stream iff(last)
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

aligned_cp_X_len_cp: cross aligned_cp,len_cp;
unaligned_cp_X_len_cp: cross unaligned_cp,len_cp;
sparse_cp_X_len_cp: cross sparse_cp,len_cp;

endgroup : ei_AXIS_covergroup