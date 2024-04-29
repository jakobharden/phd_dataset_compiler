## Check if directory is a valid upv project directory and return the directory structure
##
## Usage: [r_sta, r_pds] = fio_read_project(p_pdp)
##
## p_pdp ... upv project directory path, <str>
## r_sta ... return: check state (true = valid, false = not valid), <bool>
## r_pds ... return upv project directory structure, <struct>
##   .obj_type ... object type, always "struct_project", <str>
##   .pname   ... project name, <str>
##   .dp_main ... main project directory path, <str>
##   .dp_ch1  ... channel 1 directory path, <str>
##   .dp_ch2  ... channel 2 directory path, <str>
##   .fp_ss1  ... channel 1, settings file path, <str>
##   .fp_ss2  ... channel 2, settings file path, <str>
##   .fp_mm1  ... channel 1, measurements file path, <str>
##   .fp_mm2  ... channel 2, measurements file path, <str>
##   .fp_tt1  ... channel 1, temperature file path, <str>
##   .fp_tt2  ... channel 2, temperature file path, <str>
##   .dn_main ... main project directory name, <str>
##   .dn_ch1  ... channel 1 directory name, <str>
##   .dn_ch2  ... channel 2 directory name, <str>
##   .fn_ss1  ... channel 1, settings file name, <str>
##   .fn_ss2  ... channel 2, settings file name, <str>
##   .fn_mm1  ... channel 1, measurements file name, <str>
##   .fn_mm2  ... channel 2, measurements file name, <str>
##   .fn_tt1  ... channel 1, temperature file name, <str>
##   .fn_tt2  ... channel 2, temperature file name, <str>
##
## see also: fio_read_channel, fio_read_settings, fio_read_measurements,
##           fio_read_signal, fio_read_temperature
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
function [r_sta, r_pds] = fio_read_project(p_pdp)
  
  ## init return value
  r_sta = false;
  r_pds = [];
  
  ## check arguments
  if (nargin < 1)
    help fio_read_project;
    warning('Less arguments given!');
    return;
  endif
  if (isempty(p_pdp))
    warning("Project directory path is empty!");
    return;
  endif
  if (exist(p_pdp, "dir") != 7)
    warning("Project directory path does not exist!\n  path = %s", p_pdp);
    return;
  endif
  
  ## get channel 1 directory, c-wave
  [dp_exist, dp_ch1, dn_ch1] = hlp_check_dir(p_pdp, 1);
  if not(dp_exist)
    return;
  endif
  
  ## get channel 2 directory, s-wave
  [dp_exist, dp_ch2, dn_ch2] = hlp_check_dir(p_pdp, 2);
  if not(dp_exist)
    return;
  endif
  
  ## get measurement file, channel 1
  [fp_exist, fn_mm1, fp_mm1] = hlp_check_file(dp_ch1, 'measurements.txt');
  if not(fp_exist)
    return;
  endif
  
  ## get measurement file, channel 2
  [fp_exist, fn_mm2, fp_mm2] = hlp_check_file(dp_ch2, 'measurements.txt');
  if not(fp_exist)
    return;
  endif
  
  ## get settings file, channel 1
  [fp_exist, fn_ss1, fp_ss1] = hlp_check_file(dp_ch1, 'settings.txt');
  if not(fp_exist)
    return;
  endif
  
  ## get settings file, channel 2
  [fp_exist, fn_ss2, fp_ss2] = hlp_check_file(dp_ch2, 'settings.txt');
  if not(fp_exist)
    return;
  endif
  
  ## set return state
  r_sta = true;
  
  ## get temperature file, channel 1, not mandatory
  [fp_exist, fn_tt1, fp_tt1] = hlp_check_file(dp_ch1, 'tst.tem');
  if not(fp_exist)
    printf('Specimen temperature data file for channel 1 does not exist!\n   path = %s\n', fullfile(dp_ch1, 'tst.tem'));
  endif
  
  ## get temperature file, channel 2, not mandatory
  [fp_exist, fn_tt2, fp_tt2] = hlp_check_file(dp_ch2, 'tst.tem');
  if not(fp_exist)
    printf('Specimen temperature data file for channel 2 does not exist!\n   path = %s\n', fullfile(dp_ch2, 'tst.tem'));
  endif
  
  ## get project information file, not mandatory
  [fp_exist, fn_pif, fp_pif] = hlp_check_file(p_pdp, 'projinfo.txt');
  if not(fp_exist)
    printf('Project information file does not exist!\n   path = %s\n', fullfile(p_pdp, 'projinfo.txt'));
  endif
  
  ## create empty structure
  r_pds = hlp_empty_struct(p_pdp);
  
  ## update structure
  r_pds.dp_ch1 = dp_ch1;
  r_pds.dp_ch2 = dp_ch2;
  r_pds.fp_ss1 = fp_ss1;
  r_pds.fp_ss2 = fp_ss2;
  r_pds.fp_mm1 = fp_mm1;
  r_pds.fp_mm2 = fp_mm2;
  r_pds.fp_tt1 = fp_tt1;
  r_pds.fp_tt2 = fp_tt2;
  r_pds.fp_pif = fp_pif;
  r_pds.dn_ch1 = dn_ch1;
  r_pds.dn_ch2 = dn_ch2;
  r_pds.fn_ss1 = fn_ss1;
  r_pds.fn_ss2 = fn_ss2;
  r_pds.fn_mm1 = fn_mm1;
  r_pds.fn_mm2 = fn_mm2;
  r_pds.fn_tt1 = fn_tt1;
  r_pds.fn_tt2 = fn_tt2;
  r_pds.fn_pif = fn_pif;
  
  ## print directory structure on screen
  if (r_sta)
    printf('Project directory:   %s\n', r_pds.dp_main);
    printf('Channel directory (channel 1): %s\n', r_pds.dp_ch1);
    printf('Channel directory (channel 2): %s\n', r_pds.dp_ch2);
    printf('Settings file (channel 1):     %s\n', r_pds.fp_ss1);
    printf('Settings file (channel 2):     %s\n', r_pds.fp_ss2);
    printf('Measurements file (channel 1): %s\n', r_pds.fp_mm1);
    printf('Measurements file (channel 2): %s\n', r_pds.fp_mm2);
    if not(isempty(r_pds.fn_tt1))
      printf('Temperature file (channel 1):  %s\n', r_pds.fp_tt1);
    else
      printf('Temperature file (channel 1): missing\n');
    endif
    if not(isempty(r_pds.fn_tt2))
      printf('Temperature file (channel 2):  %s\n', r_pds.fp_tt2);
    else
      printf('Temperature file (channel 2): missing\n');
    endif
    if not(isempty(r_pds.fn_pif))
      printf('Project information file:      %s\n', r_pds.fp_pif);
    else
      printf('Project information file: missing\n');
    endif
  endif
  
endfunction

###############################################################################
## Helper function: get channel directories
## p_pdp ... project directory path, <str>
## p_cid ... channel id (1 or 2), <int>
## r_err ... return: error state, <bool>
## r_dp  ... return: channel directory path, <str>
## r_dn  ... return: channel directory name, <str>
function [r_err, r_dp, r_dn] = hlp_check_dir(p_pdp, p_cid)
  
  ## init return value
  r_err = true;
  
  ## check whether directory exists or not
  dn1 = sprintf('Channel %u', p_cid);
  dn2 = sprintf('channel_%u', p_cid);
  dp1 = fullfile(p_pdp, dn1);
  dp2 = fullfile(p_pdp, dn2);
  if (exist(dp1, 'dir') == 7)
    r_dp = dp1;
    r_dn = dn1;
  elseif (exist(dp2, 'dir') == 7)
    r_dp = dp2;
    r_dn = dn2;
  else
    r_err = false;
    r_dp = '';
    r_dn = '';
    warning('Cannot find channel %d directory!\n   path = %s or\n   path = %s', p_cid, dp1, dp2);
  endif
  
endfunction

###############################################################################
## Helper function: check project file
## p_dp  ... directory path, <str>
## p_fn  ... file name, <str>
## r_err ... return: error state, <bool>
## r_fn  ... return: file name, <str>
## r_fp  ... return: file path, <str>
function [r_err, r_fn, r_fp] = hlp_check_file(p_dp, p_fn)
  
  ## init return value
  r_err = true;
  
  ## check whether file exists or not
  fp = fullfile(p_dp, p_fn);
  if (exist(fp, 'file') == 2)
    r_fp = fp;
    r_fn = p_fn;
  else
    r_err = false;
    r_fp = '';
    r_fn = '';
    warning('Cannot find file!\n   path = %s', fp);
  endif
  
endfunction

###############################################################################
## Helper function: create empty project data structure
## p_pdp ... project directory path, <str>
## r_pds ... return: empty project data structure, <struct>
function [r_pds] = hlp_empty_struct(p_pdp)
  
  ## extract project directory name
  [tmp_dir, tmp_file, tmp_ext] = fileparts(p_pdp);
  
  r_pds.obj = "struct_project";
  r_pds.ver = [1, 0];
  r_pds.pname = tmp_file;
  r_pds.dp_main = p_pdp;
  r_pds.dp_ch1 = '';
  r_pds.dp_ch2 = '';
  r_pds.fp_ss1 = '';
  r_pds.fp_ss2 = '';
  r_pds.fp_mm1 = '';
  r_pds.fp_mm2 = '';
  r_pds.fp_tt1 = '';
  r_pds.fp_tt2 = '';
  r_pds.fp_pif = '';
  r_pds.dn_main = tmp_file;
  r_pds.dn_ch1 = '';
  r_pds.dn_ch2 = '';
  r_pds.fn_ss1 = '';
  r_pds.fn_ss2 = '';
  r_pds.fn_mm1 = '';
  r_pds.fn_mm2 = '';
  r_pds.fn_tt1 = '';
  r_pds.fn_tt2 = '';
  r_pds.fn_pif = '';
    
endfunction
