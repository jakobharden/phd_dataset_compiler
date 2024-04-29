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
## Add copyright header to all data files of a upv project
##
## Usage: fio_project_filelist(p_pdp)
##
## p_pdp ... project directory path, <str>
## r_pfl ... project file list, [<struct>]
##   .obj_type ... object type, <str>, always 'struct_project_filelist'
##   .dp ... directory path, <str>
##   .fn ... file name, <str>
##   .fp ... full file path, <str>
##
## see also: fio_read_project, fio_read_measurements
##
function [r_pfl] = fio_project_filelist(p_pdp)
  
  ## init return value
  r_pfl = [];
  
  ## check arguments
  if (nargin < 1)
    help fio_project_filelist;
    error('Less arguments given');
  endif
  
  ## read project structure
  [err, ps] = fio_read_project(p_pdp);
  if not(err)
    error('Cannot read project directory structure!\n  path = %s', p_pdp);
  endif
  
  ## read measurement files from channels
  [err, mm1] = fio_read_measurements(ps.fp_mm1, 1, ps.pname);
  [err, mm2] = fio_read_measurements(ps.fp_mm2, 2, ps.pname);
  
  ## collect all project files
  r_pfl = [r_pfl; hlp_item(ps.dp_ch1, ps.fn_ss1, ps.fp_ss1)];
  r_pfl = [r_pfl; hlp_item(ps.dp_ch1, ps.fn_ss2, ps.fp_ss2)];
  r_pfl = [r_pfl; hlp_item(ps.dp_ch2, ps.fn_mm1, ps.fp_mm1)];
  r_pfl = [r_pfl; hlp_item(ps.dp_ch2, ps.fn_mm2, ps.fp_mm2)];
  if not(isempty(ps.fp_pif))
    r_pfl = [r_pfl; hlp_item(ps.dp_main, ps.fn_pif, ps.fp_pif)];
  endif
  if not(isempty(ps.fp_tt1))
    r_pfl = [r_pfl; hlp_item(ps.dp_ch1, ps.fn_tt1, ps.fp_tt1)];
  endif
  if not(isempty(ps.fp_tt2))
    r_pfl = [r_pfl; hlp_item(ps.dp_ch2, ps.fn_tt2, ps.fp_tt2)];
  endif
  for i = 1 : size(mm1.files, 1)
    r_pfl = [r_pfl; hlp_item(ps.dp_ch1, mm1.files{i}, fullfile(ps.dp_ch1, mm1.files{i}))];
  endfor
  for i = 1 : size(mm2.files, 1)
    r_pfl = [r_pfl; hlp_item(ps.dp_ch2, mm2.files{i}, fullfile(ps.dp_ch2, mm2.files{i}))];
  endfor
  
endfunction

############################################################################################################################################
## Helper function: create file list item
## p_dp ... directory path, <str>
## p_fn ... file name, <str>
## p_fp ... full file path, <str>
## r_it ... file list item, <struct>
##
function [r_it] = hlp_item(p_dp, p_fn, p_fp)
  
  r_it.dp = p_dp;
  r_it.fn = p_fn;
  r_it.fp = p_fp;
  
endfunction
