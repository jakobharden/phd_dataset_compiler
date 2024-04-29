## Remove sha256 hash files from project directory
##
## Usage: fio_project_unhash(p_pd)
##
## p_pd ... project directory path, string
##
## see also: fio_project_hash
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
function fio_project_unhash(p_pd)
  
  ## check arguments
  if (nargin < 1)
    help fio_project_unhash;
    return;
  endif
  
  ## read project structure
  [err, ps] = fio_read_project(p_pd);
  if not(err)
    error('Cannot read project directory structure!\n  path = %s', p_pd);
  endif
  
  ## read measurement files from channels
  [err, mm1] = fio_read_measurements(ps.fp_mm1, 1, ps.pname);
  [err, mm2] = fio_read_measurements(ps.fp_mm2, 2, ps.pname);
  
  ## process all project files
  hlp_proc_file(ps.fp_ss1);
  hlp_proc_file(ps.fp_ss2);
  hlp_proc_file(ps.fp_mm1);
  hlp_proc_file(ps.fp_mm2);
  hlp_proc_file(ps.fp_tt1);
  hlp_proc_file(ps.fp_tt2);
  hlp_proc_file(ps.fp_pif);
  for i = 1 : size(mm1.files, 1)
    fp = cstrcat(ps.dp_ch1, filesep(), mm1.files{i});
    hlp_proc_file(fp);
  endfor
  for i = 1 : size(mm2.files, 1)
    fp = cstrcat(ps.dp_ch2, filesep(), mm2.files{i});
    hlp_proc_file(fp);
  endfor
  
endfunction

############################################################################################################################################
## Helper function: delete sha256 hash file
## p_fp  ... file path, string
function hlp_proc_file(p_fp)
  
  if not(isempty(p_fp))
    delfp = strcat(p_fp, '.sha256');
    delete(delfp);
  endif
  
endfunction
