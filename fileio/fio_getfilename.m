## Get filename for output files
##
## Usage: [r_lst] = fio_dirlist(p_dir, p_ext)
##
## p_fn ... filename without extension, <str>
## p_fe ... filename extension without dot, <str>
## p_sm ... filename suffix mode, optional, <int>
##            p_sm: 1 = date, 2 = time, 3 = date/time, otherwise = no suffix
## r_fn ... return: filename with optional suffix and extension, <str>
##            filename format: <filename>_<suffix>.<extension>
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
function [r_fn] = fio_getfilename(p_fn, p_fe, p_sm)
  
  ## check arguments
  if (nargin < 2)
    help fio_getfilename;
    error('Less arguments given!');
  endif
  if (nargin < 3)
    p_sm = 0
  endif
  
  ## select suffix mode
  switch (p_sm)
  case 1
    sfx = strftime("_%Y%m%d", localtime(time()));
  case 2
    sfx = strftime("_%H%M%S", localtime(time()));
  case 3
    sfx = strftime("_%Y%m%dT%H%M%S", localtime(time()));
  otherwise
    sfx = '';
  endswitch
  
  r_fn = sprintf('%s%s.%s', p_fn, sfx, p_fe);
  
endfunction