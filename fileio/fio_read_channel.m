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
## Read channel directory from upv project
##
## p_pds ... project directory structure, <struct>
## p_cid ... channel id, <int>
##           p_cid = 1: read first channel (P-wave)
##           p_cid = 2: read second channel (S-wave)
##           p_cid = 3: read both channels (P-wave and S-wave)
## r_sta  ... return: state (true = success, false = failure), <bool>
## r_chs  ... return: channel structure(s), <struct>
##   r_chs.obj_type  ... object type, always "struct_channel", <str>
##   r_chs.pname     ... project name, <str>
##   r_chs.cid       ... channel id, <int>
##   r_chs.dpath     ... channel directory path, <str>
##   r_chs.struct_mm ... channel measurements structure, <struct>
##   r_chs.struct_ss ... channel settings structure, <struct>
##   r_chs.struct_tt ... channel temperature structure, <struct>
##
## see also: fio_read_project
##
function [r_sta, r_chs] = fio_read_channel(p_pds, p_cid)
  
  ## init return values
  r_sta = false;
  r_chs = [];
  
  ## check arguments
  if (nargin < 2)
    help fio_read_channel;
    return;
  endif
  
  ## switch channel id
  switch (p_cid)
    case 1
      [r_sta, r_chs] = hlp_read_channel(p_pds, 1);
    case 2
      [r_sta, r_chs] = hlp_read_channel(p_pds, 2);
    case 3
      [r_st1, r_cs1] = hlp_read_channel(p_pds, 1);
      [r_st2, r_cs2] = hlp_read_channel(p_pds, 2);
      r_sta = r_st1 && r_st2;
      if (r_sta)
        r_chs = [r_cs1, r_cs2];
      endif
    otherwise
      help fio_read_channel;
      error("Unknown channel id!");
  endswitch
  
endfunction

############################################################################################################################################
## Helper function: read distinct channel and create channel structure
## p_pds ... project directory structure
## p_cid ... channel id
## r_sta  ... return state (true = success, false = failure)
## r_chs  ... return channel structure
function [r_sta, r_chs] = hlp_read_channel(p_pds, p_cid)
  
  ## init return values
  r_sta = false;
  r_chs = [];
  
  ## switch channel id
  switch (p_cid)
    case 1
      fp_ch = p_pds.dp_ch1;
      fp_mm = p_pds.fp_mm1;
      fp_ss = p_pds.fp_ss1;
      fp_tt = p_pds.fp_tt1;
    case 2
      fp_ch = p_pds.dp_ch2;
      fp_mm = p_pds.fp_mm2;
      fp_ss = p_pds.fp_ss2;
      fp_tt = p_pds.fp_tt2;
  endswitch
  
  ## create measurements structure
  [err, mds] = fio_read_measurements(fp_mm, p_cid, p_pds.pname);
  if not(err)
    return;
  endif
  
  ## create settings structure
  [err, sds] = fio_read_settings(fp_ss, p_cid, p_pds.pname);
  if not(err)
    return;
  endif
  
  ## create temperature structure
  [err, tds] = fio_read_temperature(fp_tt, p_cid, p_pds.pname);
  if not(err)
    disp("No temperature data available!");
  endif
  
  ## create channel structure
  r_chs.obj_type = "struct_channel";
  r_chs.pname = p_pds.pname;
  r_chs.cid = p_cid;
  r_chs.dpath = fp_ch;
  r_chs.struct_mm = mds;
  r_chs.struct_ss = sds;
  r_chs.struct_tt = tds;
  
  ## return state
  r_sta = true;
  
endfunction
