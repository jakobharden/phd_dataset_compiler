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
## Create specimen data structure for aluminium cylinder
##
## Usage 1: [r_ds] = struct_spm_ref(p_tp, p_ai, p_mi, p_di, p_tm, p_si, p_sc, p_op, p_de), return initialized data structure
##
## Usage 2: [r_ds] = struct_spm_ref(), return empty data structure
##
## p_tp ... reference test/specimen type, <str>
##           "ref_air":    reference test, air
##           "ref_water":  reference test, water
##           "ref_alucyl": reference test, aluminium cylinder
##           "ref_f2f":    reference test, face-to-face test, no sample/material used
## p_ai ... related author id's, <uint> or [<uint>]
## p_mi ... related material id, <uint>
## p_di ... related device id's or device group name, <uint> or [<uint>] or <str>
## p_tm ... date and time (utc, seconds since epoch), <dbl>
## p_si ... specimen id, <uint>
## p_sc ... specimen code, <str>
## p_op ... operator name, <str>
## p_de ... description, optional, <str>
## r_ds ... return: specimen data structure, <struct>
##   .obj ... object type, always "struct_spm_ref", <str>
##   .ver ... version number [major_ver, minor_ver], [<uint>]
##   .r01 ... related authors, <ARE/struct>
##   .r02 ... related material, <ARE/struct>
##   .r03 ... related devices, <ARE/struct>
##   .r04 ... related location, <ARE/struct>
##   .d01 ... specimen identification number, <ADE/struct>
##   .d02 ... date and time, <ADE/struct>
##   .a01 ... specimen code, <AAE/struct>
##   .a02 ... operator name, <AAE/struct>
##   .a03 ... procedure, <AAE/struct>
##   .a04 ... description, <AAE/struct>
##
## see also: struct_dataset
##
function [r_ds] = struct_spm_ref(p_tp, p_ai, p_mi, p_di, p_tm, p_si, p_sc, p_op, p_de)
  
  ## read static information from global variable, see also init.m
  global dsc_db_static
  
  ## init return values
  r_ds = dsc_db_static.struct_spm_ref;
  
  ## check arguments
  if (nargin == 0)
    return;
  endif
  if (nargin < 9)
    p_de = [];
  endif
  if (nargin < 8)
    help struct_spm_ref;
    error('Less arguments given!');
  endif
  
  ## check device id's
  [~, devid] = struct_dev(p_di);
  
  ## check description
  if isempty(p_de)
    p_de = dsc_db_static.gdef.descr;
  endif
  
  ## sampling procedure
  switch (p_tp)
    case {'ref_air'}
      proc = {...
        '(1) assemble mold I and mold II', ...
        '(2) assure that space between actuator and sensor is cleared (mold I and mold II)'};
    case 'ref_water'
      proc = {...
        '(1) assemble mold I and mold II', ...
        '(2) pour water in rubber 2 rubber baloons', ...
        '(3) place baloons between actuator and sensor (mold I and mold II)'};
    case 'ref_alucyl'
      proc = {...
        '(1) cover surfaces of actuators and sensors with a thin film of grease (mold I and mold II)', ...
        '(2) assemble mold I and mold II', ...
        '(3) place aluminium cylinders between actuator and sensor (mold I and mold II)'};
    case 'ref_f2f'
      ## face-to-face test
      proc = {...
        '(1) assemble mold I and mold II', ...
        '(2) assure that actuator and sensor are directly connected to each other (face-to-face test, mold I and mold II)'};
      p_de = 'No specimen between actuator and sensor. This is a face-to-face test. Actuator and sensor are directly connected to each other.';
    otherwise
      help struct_spm_ref;
      error('Unknown reference test/specimen type! type = %s', p_tp);
  endswitch
  
  # update data structure
  r_ds.r01.i = p_ai;
  r_ds.r02.i = p_mi;
  r_ds.r03.i = devid;
  r_ds.r04.i = 1;
  r_ds.d01.v = p_si;
  r_ds.d02.v = p_tm;
  r_ds.a01.v = p_sc;
  r_ds.a02.v = p_op;
  r_ds.a03.v = proc;
  r_ds.a04.v = p_de;
  
endfunction
