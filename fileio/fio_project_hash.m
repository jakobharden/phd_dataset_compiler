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
## Create sha256 hash files for all data files of a upv project
##
## Usage: fio_project_hash(p_pd)
##
## p_pdp ... project directory path, string
##
## see also: fio_read_project, fio_read_channel, fio_read_settings,
##           fio_read_measurements, fio_read_temperature, fio_read_signal
##
function fio_project_hash(p_pdp)
  
  ## check arguments
  if (nargin < 1)
    help fio_project_hash;
    return;
  endif
  
  # read project file list
  pfl = fio_project_filelist(p_pdp)
  
  # hash files
  for i = 1 : size(pfl, 1)
    hlp_proc_file(pfl(i).fp)
  endfor
  
endfunction

############################################################################################################################################
## Helper function: process signal files of one channel (add header to all files)
## p_fp  ... file path, string
## p_lic ... license information, cell array
function hlp_proc_file(p_fp)
  
  ## generate hash (sha256)
  [~, sha256] = fio_hash_sha256(p_fp);
  if (isempty(sha256))
    return;
  endif
  
  ## output file path
  ofp = cstrcat(p_fp, ".sha256");
  
  ## write hash file
  fid = fopen(ofp, "w");
  
  ## check for errors
  if (fid < 0)
    error("Cannot open hash output file for writing!\n  path = %s", ofp);
  endif
  
  ## write sha256 hash
  fprintf(fid, "%s\n", sha256);
  
  ## close file
  fclose(fid);
  
  ## print state
  printf('create hash file: %s\n', ofp);
  
endfunction
