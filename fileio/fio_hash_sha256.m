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
## Create sha256 hash string of given file
## 
## Usage: [r_hs] = fio_hash_sha256(p_fp)
## 
## p_fp ... full qualified file path, <str>
## r_hs ... return: sha256 hash string (64 characters), <str>
## r_hr ... return: sha256 hash string (raw sha256sum output), <str>
## 
## see also: 
## 
function [r_hs, r_hr] = fio_hash_sha256(p_fp)
  
  ## init return value
  r_hs = "";
  r_hr = "";
  
  ## check arguments
  if (nargin < 1)
    help fio_hash_sha256;
    warning("Less arguments given!");
    return;
  endif
  
  ## generate sha256 hash
  fex = exist(p_fp, 'file');
  if ((fex == 2) || (fex == 3))
    [r1, r2] = system(sprintf("sha256sum -b \"%s\"", p_fp));
    r_hs = r2(1:64);
    r_hr = r2;
  endif
  
endfunction
  
