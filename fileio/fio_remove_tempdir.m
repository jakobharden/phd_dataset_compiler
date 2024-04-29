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
## Remove temporary project data directory from system temp directory
##
## p_tdp ... temporary project directory path (full qualified)
##
## see also: fio_unzip_tempdir
##
function fio_remove_tempdir(p_tdp)
  
  ## check arguments
  if (nargin < 1)
    help fio_remove_tempdir;
    return;
  endif
  
  ## check whether temporary directory is in a temporary path (for safety)
  if not(strfind(p_tdp, '/tmp')) && not(strfind(p_tdp, '/mnt/octave_temp'))
    warning('Temporary project path is not in /tmp  or /mnt/octave_temp!');
    return;
  endif
  
  ## check if temporary project directory path exists
  if (exist(p_tdp, "dir") != 7)
    help fio_remove_tempdir;
    warning("Temporary project directory does not exist!\n  path = %s", p_tdp);
    return;
  endif
  
  ## remove temporary project directory
  [errno, msgtmp] = system(sprintf("rm -r %s", p_tdp));
  if (errno > 0)
    help fio_remove_tempdir;
    warning("Error occured while removing temporary project directory!\n  ERR: ", msgtmp);
  endif
  
  ## print status
  printf('Removed temporary data from ramdisk:\n  dir: %s\n', p_tdp);
  
endfunction
