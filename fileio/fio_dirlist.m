## Enlist binary project files in directory
##
## Usage: [r_lst] = fio_dirlist(p_dir, p_ext)
##
## p_dir ... project file directory
## p_ext ... filter file extension
## r_lst ... return project file listing
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
function [r_lst] = fio_dirlist(p_dir, p_ext)
  
  ## check arguments
  if (nargin < 2)
    help fio_dirlist;
    return;
  endif
  
  ## check whether project file directory exists
  if (exist(p_dir, "dir") != 7)
    help fio_dirlist;
    error("Project file directory does not exist!\n  path = %s", p_dir);
  endif
  
  ## enlist directory content
  r_lst = dir(strcat(p_dir, filesep(), "*.", p_ext));
  
  ## filter list
  sz = max(size(r_lst));
  for i = sz : -1 : 1
    if (r_lst(i).isdir)
      r_lst(i) = [];
    endif
  endfor
  
endfunction