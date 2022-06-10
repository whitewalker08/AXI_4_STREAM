class ei_AXIS_coverage;

mailbox mon2cov;
ei_AXIS_coverage_packet cov_pkt;

covergroup ei_AXIS_covergroup with function sample(bit last);

sparse_cp : coverpoint cov_pkt.sparse_stream iff(last)
{
    bins bin_low = {2};
    bins bin_med = {[30:35]};
    bins bin_high = {100};
}

aligned_cp : coverpoint cov_pkt.aligned_stream iff(last)
{
    bins bin_low = {2};
    bins bin_med = {[30:35]};
    bins bin_high = {100};
}

unaligned_cp : coverpoint cov_pkt.unaligned_stream iff(last)
{
    bins bin_low = {2};
    bins bin_med = {[30:35]};
    bins bin_high = {100};
}

len_cp:coverpoint cov_pkt.num_trans iff(last)
{
    bins bin_single = {1};
    bins bin_low = {[2:10]};
    //bins bin_med = {[50:100]};
    //bins bin_high = {[101:1000]};
}

aligned_cp_X_len_cp: cross aligned_cp,len_cp 
	{
	    ignore_bins ignore_bin = aligned_cp_X_len_cp with (len_cp==1); 
	}
unaligned_cp_X_len_cp: cross unaligned_cp,len_cp
	{
	    ignore_bins ignore_bin1 = unaligned_cp_X_len_cp with (len_cp==1); 
	}

sparse_cp_X_len_cp: cross sparse_cp,len_cp 
	{
	    ignore_bins ignore_bin2 = sparse_cp_X_len_cp with (len_cp==1); 
	}

endgroup : ei_AXIS_covergroup

function new(mailbox mon2cov);
    this.mon2cov = mon2cov;
    ei_AXIS_covergroup = new();
endfunction

task sample_values();
    cov_pkt = new();
    forever begin
        mon2cov.get(cov_pkt);
        ei_AXIS_covergroup.sample(cov_pkt.TLAST);
    end
endtask : sample_values

endclass : ei_AXIS_coverage
