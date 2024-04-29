## Compress directory to zip archive, batch process directories from list
##
## p_fl ... list file path (full qualified), <str>
## r_ap ... return: archive file paths, {<str>}
##
## see also: fio_zip
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
function [r_ap] = fio_zip2(p_fl)
  
  ## init return values
  r_ap = {};
  
  ## check arguments
  if (nargin < 1)
    help fio_zip2;
    error('Less arguments given!');
  endif
  
  ## check whether archive file list exists or not
  if (exist(p_fl, "file") != 2)
    help fio_zip2;
    error("Directory file list does not exist!\n  path = %s", p_fl);
  endif
  
  ## read file list
  fid = fopen(p_fl, 'r');
  flst = textscan(fid, '%s');
  fclose(fid);
  
  ## iterate over file list
  for i = 1 : max(size(flst{1}))
    ap_i = fio_zip(flst{1}{i});
    r_ap = [r_ap, ap_i];
    #disp(flst{1}{i});
  endfor
  
endfunction
