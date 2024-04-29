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
## Save figure to file
##
## Usage: [r_fs] = fio_save_figure(p_fh, p_fp, p_ff)
##
## p_fh ... figure handle
## p_fp ... figure file path
## p_ff ... figure file format
## r_fs ... return file state (output of stat), empty if file does not exist
##
## see also: saveas, hgsave
function [r_fs] = fio_save_figure(p_fh, p_fp, p_ff)
  
  ## init return value
  r_fs = [];
  
  ## check arguments
  if (nargin < 2)
    help fio_save_figure;
    return;
  endif
  if (nargin < 3)
    p_ff = 'ofig';
  endif
  
  ## check figure handle
  if (!ishghandle(p_fh))
    warning("Figure handle is no proper graphics handle!");
    return;
  endif
  
  switch (p_ff)
    case {'', 'pdf', 'png', 'jpg', 'ps', 'eps', 'emf'}
      saveas(p_fh, p_fp, p_ff);
    case {'obj', 'ofig', 'fig'}
      hgsave(p_fh, p_fp);
  endswitch
  
  ## return output file state
  r_fs = stat(p_fp);
  
endfunction
