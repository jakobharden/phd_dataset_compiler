## Create data structure for ultrasonic transmission test
##
## Usage 1: [r_ds] = struct_test_utt(p_ai, p_si, p_di, p_tm, p_t0, p_te, p_dp, p_op, p_de), return initialized data structure
##
## Usage 2: [r_ds] = struct_test_utt(), return empty data structure
##
## p_ai ... related author id's, <uint> or [<uint>]
## p_si ... related specimen id (one of [1, 2]), <uint>
## p_di ... related device id's or device group name, <uint> or [<uint>] or <str>
## p_tm ... date and time, unit sec (utc, seconds since epoch), <dbl>
## p_t0 ... zero time (time span between adding water to cement and test start), unit sec, <uint>
## p_dp ... measurements directory path (channel directory), <str>
## p_op ... operator name, <str>
## p_de ... description, optional, <str>
## r_ds ... return: test data structure, <struct>
##   .obj ... object type, always "struct_test_utt", <str>
##   .ver ... version number [major_ver, minor_ver], [<uint>]
##   .r01 ... related authors, <ARE/struct>
##   .r02 ... related specimen, <ARE/struct>
##   .r03 ... related devices, <ARE/struct>
##   .r04 ... related location, <ARE/struct>
##   .d01 ... date and time, <ADE/struct>
##   .d02 ... zero time, <ADE/struct>
##   .d03 ... number of interval steps, <ADE/struct>
##   .d04 ... interval length, <ADE/struct>
##   .d05 ... pulse voltage, <ADE/struct>
##   .d06 ... pulse width, <ADE/struct>
##   .d07 ... sampling rate, <ADE/struct>
##   .d08 ... recorded block size, <ADE/struct>
##   .d09 ... number of initial samples, <ADE/struct>
##   .d10 ... number of signals, <ADE/struct>
##   .d11 ... signal maturity time-array, <ADE/struct>
##   .d12 ... signal sample time-array, <ADE/struct>
##   .d13 ... signal sample magnitude-matrix, <ADE/struct>
##   .a01 ... test name, <AAE/struct>
##   .a02 ... operator name, <AAE/struct>
##   .a03 ... procedure, <AAE/struct>
##   .a04 ... calculation, <AAE/struct>
##   .a05 ... description, <AAE/struct>
##   .a06 ... settings file path, <AAE/struct>
##   .a07 ... settings file name, <AAE/struct>
##   .a08 ... settings file hash, <AAE/struct>
##   .a09 ... measurements file path, <AAE/struct>
##   .a10 ... measurements file name, <AAE/struct>
##   .a11 ... measurements file hash, <AAE/struct>
##   .a12 ... data directory path, <AAE/struct>
##   .a13 ... data file path list, <AAE/struct>
##   .a14 ... data file name list, <AAE/struct>
##   .a15 ... data file hash list, <AAE/struct>
##
## see also: struct_objdata, struct_objref, struct_objattrib
##
## Copyright 2023 Jakob Harden (jakob.harden@tugraz.at, Graz University of Technology, Graz, Austria)
## License: MIT
## This file is part of the PhD thesis of Jakob Harden.
## 
## Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
## documentation files (the “Software”), to deal in the Software without restriction, including without 
## limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of 
## the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
## 
## THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
## THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
## TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
##
function [r_ds] = struct_test_utt(p_ai, p_si, p_di, p_tm, p_t0, p_dp, p_op, p_de)
  
  ## read static information from global variable, see also init.m
  global dsc_db_static
  
  ## init return values
  r_ds = dsc_db_static.struct_test_utt;
  
  ## check arguments
  if (nargin == 0)
    return;
  endif
  if (nargin < 8)
    p_de = [];
  endif
  if (nargin < 7)
    help struct_test_utt;
    error('Less arguments given!');
  endif
  
  ## get device id's
  [~, devid] = struct_dev(p_di);
  
  ## get description
  if (isempty(p_de))
    switch (p_si)
      case 1
        p_de = dsc_db_static.gdef.descr_spm1;
      case 2
        p_de = dsc_db_static.gdef.descr_spm2;
      otherwise
        p_de = dsc_db_static.gdef.descr;
    endswitch
  endif
  
  ## read measurements file
  fp_mm = fullfile(p_dp, 'measurements.txt');
  [err, mmds] = fio_read_measurements(fp_mm);
  if not(err)
    help struct_test_utt;
    error('Cannot read measurements information file!\n   path = %s', fp_mm);
  endif
  ## print status
  printf('Read measurements information file\n');
  
  ## read settings file
  fp_ss = fullfile(p_dp, 'settings.txt');
  [err, ssds] = fio_read_settings(fp_ss);
  if not(err)
    help struct_test_utt;
    error('Cannot read settings information file\n   path = %s', fp_ss);
  endif
  ## get pulse voltage
  test_pv = ssds.pulser_voltage_v;
  ## get pulse width
  test_pw = ssds.pulse_width_sec;
  ## get array of interval steps
  test_intstep = ssds.num_intervals;
  ## get array of interval lengths
  test_intlen = ssds.len_intervals_sec;
  ## get number of signals
  test_nsig = ssds.signals_per_test;
  ## print status
  printf('Read settings information file\n');
  
  ## read signal files
  nsig = max(size(mmds.files));
  test_sigpath = {};
  test_sighash = {};
  test_sigts = [];
  test_sigms = [];
  for i = 1 : nsig
    ## signal file path
    sigfp_i = fullfile(p_dp, mmds.files{i});
    sighash_i = fio_hash_sha256(sigfp_i);
    ## read signal data file
    [err, sigds_i] = fio_read_signaldata(sigfp_i);
    if not(err)
      help struct_test_utt;
      error('Cannot read signal data file! path = %s', sigfp_i);
    endif
    ## update time series storage
    ## store only one array because sample time signature array stays the same for all signals
    if (i == 1)
      test_sigts = single(sigds_i.ts);
    endif
    ## update magnitude storage
    test_sigms = [test_sigms, single(sigds_i.ms)];
    ## update signal data file paths
    test_sigpath = [test_sigpath; sigfp_i];
    ## update signal data file hashes
    test_sighash = [test_sighash; sighash_i];
    ## print status
    printf('Read signal data file: %d of %d\n', i, nsig);
  endfor
  ## detect block size
  test_bs = max(size(test_sigts));
  ## detect sample rate
  test_sr = fix((test_bs - 1) / (test_sigts(end) - test_sigts(1)));
  ## detect pre-trigger samples, index where sample time signature is zero
  test_ismp = find(test_sigts == 0);
  if (isempty(test_ismp))
    test_ismp = 1;
  else
    test_ismp = test_ismp(1, 1) - 1;
  endif
  
  ## update data structure
  r_ds.r01.i = p_ai;
  r_ds.r02.i = p_si;
  r_ds.r03.i = devid;
  r_ds.r04.i = 1;
  r_ds.d01.v = p_tm;
  r_ds.d02.v = p_t0;
  r_ds.d03.v = test_intstep;
  r_ds.d04.v = test_intlen;
  r_ds.d05.v = test_pv;
  r_ds.d06.v = test_pw;
  r_ds.d07.v = test_sr;
  r_ds.d08.v = test_bs;
  r_ds.d09.v = test_ismp;
  r_ds.d10.v = test_nsig;
  r_ds.d11.v = mmds.times;
  r_ds.d12.v = test_sigts;
  r_ds.d13.v = test_sigms;
  ## r_ds.a01.v test name, predefined, see struct_make_static.m
  r_ds.a02.v = p_op;
  ## r_ds.a03.v procedure, predefined, see struct_make_static.m
  ## r_ds.a04.v calculation, predefined, see struct_make_static.m
  r_ds.a05.v = p_de;
  r_ds.a06.v = ssds.fpath;
  r_ds.a07.v = ssds.fname;
  r_ds.a08.v = ssds.fhash;
  r_ds.a09.v = mmds.fpath;
  r_ds.a10.v = mmds.fname;
  r_ds.a11.v = mmds.fhash;
  r_ds.a12.v = p_dp;
  r_ds.a13.v = test_sigpath;
  r_ds.a14.v = mmds.files;
  r_ds.a15.v = test_sighash;
  
endfunction
