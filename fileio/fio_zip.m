## Compress directory to zip archive
##
## p_dp ... project directory path (full qualified), <str>
## r_zp ... return: project directory archive path, <str>
##
## see also: fio_unzip
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
function [r_zp] = fio_zip(p_dp)
  
  ## init return values
  r_zp = '';
  
  ## check arguments
  if (nargin < 1)
    help fio_zip;
    error('Less arguments given!');
  endif
  
  ## check if directory path exists
  if (exist(p_dp, "dir") != 7)
    help fio_zip;
    error("Directory does not exist!\n  path = %s", p_dp);
  endif
  
  ## extract archive name from directory name
  [pdir, pname, pext] = fileparts(p_dp);
  r_zp = sprintf('%s.zip', fullfile(pdir, pname));
  
  ## check if unzip is installed
  cmdzip = hlp_zipbin();
  
  ## create archive in same directory
  [errno, errmsg] = system(sprintf("cd %s && %s -r -9 %s.zip %s/", pdir, cmdzip, pname, pname));
  if (errno > 0)
    help fio_zip;
    error("Error occured while archiving directory!\n  ERR: ", errmsg);
  endif
  
  ## check if project archive exists
  if (exist(r_zp, "file") != 2)
    help fio_zip;
    error("Archive does not exist!\n  path = %s", r_zp);
  endif
  
  ## print status
  printf('Compressed directory:\n  source: %s\n  target: %s\n', p_dp, r_zp);
  
endfunction

###############################################################################
## r_cmdzip ... return: full qualified path to unzip executable
function [r_cmdzip] = hlp_zipbin()
  
  [errno, r_cmdzip] = system("which zip");
  r_cmdzip = strtrim(r_cmdzip);
  if (errno > 0)
    help fio_zip;
    error("unzip is not available on this system!");
  endif
  
endfunction
