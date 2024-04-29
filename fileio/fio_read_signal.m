## Read signal data from upv project
##
## Usage: [r_sta, r_sds] = fio_read_signal(p_chs, p_sid)
##
## p_chs ... upv project channel structure, <struct>
## p_sid ... signal file id, <int>
## r_sta ... return: state (true = success, false = failure), <bool>
## r_sds ... return: signal data structure, <struct>
##
## see also: fio_read_signaldata
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
function [r_sta, r_sds] = fio_read_signal(p_chs, p_sid)
  
  ## init return values
  r_sta = false;
  r_sds = [];
  
  ## check arguments
  if (nargin < 2)
    help fio_read_signal;
    return;
  endif
  sz = size(p_chs.struct_mm.files, 1);
  if ((p_sid < 1) || (p_sid > sz))
    warning("Signal file id (%d) exceeds list index [%d,...,%d]!", p_sid, 1, sz);
    return;
  endif
  
  ## signal file path
  sfp = fullfile(p_chs.dpath, p_chs.struct_mm.files{p_sid});
  
  ## read signal data
  [r_sta, r_sds] = fio_read_signaldata(sfp, p_sid, p_chs.cid, p_chs.pname);
  
endfunction
