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
## Unzip project zip file to ramdisk (faster file IO)
##
## Note: if the ramdisk directory /mnt/octave_temp does not exist, fall back to /tmp
##
## p_zip ... project zip file path (full qualified), <str>
## r_sdp ... return: source project directory path (archive directory path), <str>
## r_tdp ... return: temporary project directory path, <str>
##
## see also: fio_remove_tempdir
##
function [r_sdp, r_tdp] = fio_unzip_tempdir(p_zip)
  
  ## init return values
  r_sdp = '';
  r_tdp = '';
  
  ## check arguments
  if (nargin < 1)
    help fio_unzip_tempdir;
    error('Less arguments given!');
  endif
  
  ## check if project zip file exists
  if (exist(p_zip, "file") != 2)
    help fio_unzip_tempdir;
    error("Project zip archive does not exist!\n  path = %s", p_zip);
  endif
  
  ## extract directory name from zip file name
  [zdir, zname, zext] = fileparts(p_zip);
  r_sdp = zdir;
  
  ## check if unzip is installed
  cmdzip = hlp_unzipbin();
  
  ## get temporary project directory path
  if (exist('/mnt/octave_temp', 'dir') == 7)
    tmpdir = '/mnt/octave_temp';
  else
    tmpdir = '/tmp';
  endif
  r_tdp = fullfile(tmpdir, zname);
  
  ## unzip project zip file to temporary directory
  [errno, errmsg] = system(sprintf("cd %s && %s -o %s", tmpdir, cmdzip, p_zip));
  if (errno > 0)
    help fio_unzip_tempdir;
    error("Error occured while unzipping project directory to temporary directory!\n  ERR: ", errmsg);
  endif
  
  ## check if temporary project directory path exists
  if (exist(r_tdp, "dir") != 7)
    help fio_unzip_tempdir;
    error("Temporary project directory does not exist!\n  path = %s", r_tdp);
  endif
  
  ## print status
  printf('Decompressed archive to ramdisk:\n  source: %s\n  target: %s\n', p_zip, r_tdp);
  
endfunction

###############################################################################
## r_cmdzip ... return: full qualified path to unzip executable
function [r_cmdzip] = hlp_unzipbin()
  
  [errno, r_cmdzip] = system("which unzip");
  r_cmdzip = strtrim(r_cmdzip);
  if (errno > 0)
    help fio_unzip_tempdir;
    error("unzip is not available on this system!");
  endif
  
endfunction
