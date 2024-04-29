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
## Decompress zip archive to directory
##
## p_zp ... archive file path (full qualified), <str>
## r_dp ... return: decompressed directory path, <str>
##
## see also: fio_zip
##
function [r_dp] = fio_unzip(p_zp)
  
  ## init return values
  r_dp = '';
  
  ## check arguments
  if (nargin < 1)
    help fio_unzip;
    error('Less arguments given!');
  endif
  
  ## check if archive file exists
  if (exist(p_zp, "file") != 2)
    help fio_unzip;
    error("Project zip archive does not exist!\n  path = %s", p_zp);
  endif
  
  ## extract directory name from archive file name
  [zdir, zname, zext] = fileparts(p_zp);
  r_dp = fullfile(zdir, zname);
  
  ## check if unzip is installed
  cmdzip = hlp_unzipbin();
  
  ## decompress archive file to same directory
  [errno, errmsg] = system(sprintf("cd %s && %s -o %s", zdir, cmdzip, p_zp));
  if (errno > 0)
    help fio_unzip;
    error("Error occured while unzipping project zip archive!\n  ERR: ", errmsg);
  endif
  
  ## check if directory path exists
  if (exist(r_dp, "dir") != 7)
    help fio_unzip;
    error("Project directory does not exist!\n  path = %s", r_dp);
  endif
  
  ## print status
  printf('Decompressed archive:\n  source: %s\n  target: %s\n', p_zp, r_dp);
  
endfunction

###############################################################################
## r_cmdzip ... return: full qualified path to unzip executable
function [r_cmdzip] = hlp_unzipbin()
  
  [errno, r_cmdzip] = system("which unzip");
  r_cmdzip = strtrim(r_cmdzip);
  if (errno > 0)
    help fio_unzip;
    error("unzip is not available on this system!");
  endif
  
endfunction
