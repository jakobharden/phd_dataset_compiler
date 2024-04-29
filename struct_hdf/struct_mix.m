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
## Create mixture data structure
##
## Usage 1: [r_ds] = struct_mix(p_ai, p_di, p_mi, p_ri, p_tm, p_op, p_mt, p_sl, p_de), return initialized data structure
##
## Usage 2: [r_ds] = struct_mix(), return empty data structure
##
## p_ai ... author id, <uint>
## p_di ... device id's or device group name, [<uint>] or <str>
## p_mi ... mixture id, <uint>
## p_ri ... recipe id or code (see function file ./struct_hdf/struct_make_recdb.m), <uint> or <str>
## p_tm ... date/time (utc, seconds since epoch), <dbl>
## p_op ... operator name, <str>
## p_mt ... mixing/blending time, unit sec, <int>
## p_sl ... mixer speed level, one of [1, 2, 3], <int>
## p_de ... description, optional, <str>
## r_ds ... return: mixture data structure, <struct>
##   .obj ... object type, always "struct_mix"
##   .ver ... version number [major_ver, minor_ver], [<uint>]
##   .r01 ... related author, <ARE/struct>
##   .r02 ... related devices, <ARE/struct>
##   .r03 ... related recipe, <ARE/struct>
##   .r04 ... related location, <ARE/struct>
##   .d01 ... mixture id, <ADE/struct>
##   .d02 ... date and time, <ADE/struct>
##   .d03 ... mixing/blending time, <ADE/struct>
##   .d04 ... mixer speed level, <ADE/struct>
##   .d05 ... mixer agitator speed, <ADE/struct>
##   .d06 ... mixer attachment speed, <ADE/struct>
##   .a01 ... operator name, <AAE/struct>
##   .a02 ... procedure, <AAE/struct>
##   .a03 ... description, <AAE/struct>
##
## see also: struct_dataset, struct_make_recdb
##
function [r_ds] = struct_mix(p_ai, p_di, p_mi, p_ri, p_tm, p_op, p_mt, p_sl, p_de)
  
  ## read static information from global variable, see also init.m
  global dsc_db_static
  
  ## init return values
  r_ds = dsc_db_static.struct_mix;
  
  ## check arguments
  if (nargin == 0)
    return;
  endif
  if (nargin < 9)
    p_de = [];
  endif
  if (nargin < 8)
    help struct_mix;
    error('Less arguments given!');
  endif
  
  ## check mixer speed level
  if (p_sl < 1) || (p_sl > 3)
    help struct_mix;
    error('Mixer speed level must be a integer number out of [1, 2, 3]!');
  endif
  
  ## get related device id's
  [~, devid] = struct_dev(p_di);
  
  ## get related recipe id
  [~, recid] = struct_rec(p_ri);
  
  ## get description
  if isempty(p_de)
    p_de = 'blending/mixing time accuracy = +/-5 sec';
  else
    p_de = sprintf('%s, blending/mixing time accuracy = +/-5 sec', p_de);
  endif
  
  ## mixing speed, see also struct_dev.m, device id = 28, Hobart mixer
  [dev_mixer, ~] = struct_dev(28);
  agitator_speed_list = dev_mixer.s01(1).v;
  attachment_speed_list = dev_mixer.s01(2).v;
  
  ## update data structure
  r_ds.r01.i = p_ai;
  r_ds.r02.i = devid;
  r_ds.r03.i = recid;
  r_ds.r04.i = 1;
  r_ds.d01.v = p_mi;
  r_ds.d02.v = p_tm;
  r_ds.d03.v = p_mt;
  r_ds.d04.v = p_sl;
  r_ds.d05.v = agitator_speed_list(p_sl);
  r_ds.d06.v = attachment_speed_list(p_sl);
  r_ds.a01.v = p_op;
  r_ds.a03.v = p_de;
  
endfunction
