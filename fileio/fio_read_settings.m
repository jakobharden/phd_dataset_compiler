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
## Read settings file from upv project
##
## Usage: [r_sta, r_sds] = fio_read_settings(p_sfp, p_cid, p_pnm)
##
## p_sfp ... settings file path, <str>
## p_cid ... channel id, optional, <int>
## p_pnm ... project name, optional, <str>
## r_sta ... return: state (true = success, false = failure), <bool>
## r_sds ... return: settings data structure, <struct>
##   .obj_type          ... object type (always "struct_settings"), <str>
##   .cid               ... channel id, <int>
##   .fpath             ... settings file path, <str>
##   .fdir              ... settings file directory, <str>
##   .fname             ... settings file name, <str>
##   .fhash             ... settings file sha256 hash, <str>
##   .version           ... FreshCon version, <str>
##   .expname           ... experiment name, <str>
##   .fnprefix          ... filename prefix, <str>
##   .contname          ... container name, <str>
##   .sen1name          ... first sensor name, <str>
##   .sen2name          ... second sensor name, <str>
##   .distance_m        ... distance [m], <dbl>
##   .delay_sec         ... delay time [sec], <int>
##   .refenergy         ... reference energy, <dbl>
##   .num_tests         ... number of tests, <int>
##   .test_interval_min ... test interval [min], <int>
##   .num_intervals     ... number of test intervals, <int>
##   .len_intervals_sec ... length of test intervals [sec], <int>
##   .signals_per_test  ... number of signals per test, <int>
##   .zerotime_sec      ... zerotime [sec], <dbl>
##   .pulser_voltage_v  ... pulser voltage [V], <dbl>
##   .pulse_width_sec   ... pulse width [sec], <dbl>
##
## see also: fio_read_project
##
function [r_sta, r_sds] = fio_read_settings(p_sfp, p_cid, p_pnm)
  
  ## init return values
  r_sta = false;
  r_sds = [];
  
  ## check arguments
  if (nargin < 3)
    p_pnm = 'None';
  endif
  if (nargin < 2)
    p_cid = 0;
  endif
  if (nargin < 1)
    help fio_read_settings;
    warning('Less arguments given!');
    return;
  endif
  
  ## extract file name
  [fd, fn, fe] = fileparts(p_sfp);
  fname = sprintf('%s%s', fn, fe);
  
  ## hash file
  fhash = fio_hash_sha256(p_sfp);
  
  ## open file
  fid = fopen(p_sfp, "r");
  
  ## check for errors
  if (fid < 0)
    warning("Cannot read settings file! path = %s", p_sfp);
    return;
  endif
  
  ## skip comment lines
  lstr = '';
  while not(feof(fid))
    lstr = strtrim(fgetl(fid));
    ## skip comment lines
    if (lstr(1) == '#')
      continue;
    else
      break;
    endif
  endwhile
  
  ## read file, create structure
  r_sds.obj_type = "struct_settings";
  r_sds.pname = p_pnm;
  r_sds.cid = p_cid;
  r_sds.fpath = p_sfp;
  r_sds.fdir = fd;
  r_sds.fname = fname;
  r_sds.fhash = fhash;
  r_sds.version = hlp_extract_parstr(lstr, "FreshCon Version");
  r_sds.expname = hlp_extract_parstr(fgetl(fid), "Experiment Name");
  r_sds.fnprefix = hlp_extract_parstr(fgetl(fid), "Filename");
  r_sds.contname = hlp_extract_parstr(fgetl(fid), "Container Name");
  r_sds.sen1name = hlp_extract_parstr(fgetl(fid), "First Sensor");
  r_sds.sen2name = hlp_extract_parstr(fgetl(fid), "Second Sensor");
  r_sds.distance_m = hlp_extract_parnum(fgetl(fid), "Distance [m]");
  r_sds.delay_sec = hlp_extract_parnum(fgetl(fid), "Delay Time [sec]");
  r_sds.refenergy = hlp_extract_parnum(fgetl(fid), "Ref. Energy");
  r_sds.num_tests = hlp_extract_parnum(fgetl(fid), "No. of Tests");
  r_sds.test_interval_sec = hlp_extract_parnum(fgetl(fid), "Test Interval [min]") * 60;
  tmp_intv = hlp_extract_parstr(fgetl(fid), "Intervals");
  tmp_intv_split = strsplit(tmp_intv, ':');
  r_sds.num_intervals = str2num(tmp_intv_split{1});
  r_sds.len_intervals_sec = str2num(tmp_intv_split{2});
  r_sds.signals_per_test = hlp_extract_parnum(fgetl(fid), "Signals per Test");
  r_sds.zerotime_sec = hlp_extract_parnum(fgetl(fid), "Zerotime [min]") * 60;
  r_sds.pulser_voltage_v = hlp_extract_parnum(fgetl(fid), "Pulser Voltage [V]");
  r_sds.pulse_width_sec = hlp_extract_parnum(fgetl(fid), "Pulse Width [us]") / 1e6;
  
  ## close file
  fclose(fid);
  
  ## return state
  r_sta = true;
  
endfunction

############################################################################################################################################
## Helper function: extract parameter value from file line, string value
## p_fl ... file line string
## p_pn ... parameter name
## r_pv ... return parameter value
function [r_pv] = hlp_extract_parstr(p_fl, p_pn)
  
  ## init return value
  r_pv = "";
  
  ## check arguments
  if (isempty(p_fl))
    warning("Line read from file is empty! parameter: %s", p_pn);
    return;
  endif
  
  sz = max(size(p_fl));
  iv = max(size(p_pn)) + 2;
  if (sz >= iv)
    r_pv = strtrim(p_fl(iv:end));
  else
    warning("Parameter value is empty! parameter: %s", p_pn);
  endif
  
endfunction

############################################################################################################################################
## Helper function: extract parameter value from file line, numeric value
## p_fl ... file line string
## p_pn ... parameter name string
## r_pv ... return parameter value
function [r_pv] = hlp_extract_parnum(p_fl, p_pn)
  
  ## init return value
  r_pv = 0;
  
  ## extract parameter value as string
  [tmp] = hlp_extract_parstr(p_fl, p_pn);
  
  ## convert string to number
  if (!isempty(tmp))
    r_pv = str2num(tmp);
  endif
  
endfunction
