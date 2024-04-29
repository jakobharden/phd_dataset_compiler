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
## Create data structure for the environment temperature test 1 (temperature only)
##
## Usage 1: [r_ds] = struct_test_env1(p_ai, p_di, p_tm, p_te, p_op, p_de), return initialized data structure
##
## Usage 2: [r_ds] = struct_test_env1(), return empty data structure
##
## p_ai ... author id's, <uint> or [<uint>]
## p_di ... device id's, <uint> or [<uint>]
## p_tm ... date and time, unit sec (utc, seconds since epoch), <dbl>
## p_te ... environment temperature (room air), unit °C, <dbl>
## p_op ... operator name, <str>
## p_de ... description, optional, <str>
## r_ds ... return: test data structure, <struct>
##   .obj ... object type, always "struct_test_env1", <str>
##   .ver ... version number [major_ver, minor_ver], [<uint>]
##   .r01 ... related authors, <ARE/struct>
##   .r02 ... related devices, <ARE/struct>
##   .r03 ... related location, <ARE/struct>
##   .d01 ... date and time, <ADE/struct>
##   .d02 ... temperature, <ADE/struct>
##   .a01 ... test name, <AAE/struct>
##   .a02 ... operator, <AAE/struct>
##   .a03 ... procedure, <AAE/struct>
##   .a04 ... calculation, <AAE/struct>
##   .a05 ... description, <AAE/struct>
##
## see also: struct_objdata, struct_objref, struct_objattrib
##
function [r_ds] = struct_test_env1(p_ai, p_di, p_tm, p_te, p_op, p_de)
  
  ## read static information from global variable, see also init.m
  global dsc_db_static
  
  ## init return values
  r_ds = dsc_db_static.struct_test_env1;
  
  ## check arguments
  if (nargin == 0)
    return;
  endif
  if (nargin < 6)
    p_de = [];
  endif
  if (nargin < 5)
    help struct_test_env1;
    error('Less arguments given!');
  endif
  
  ## get device id's
  [~, devid] = struct_dev(p_di);
  
  ## get description
  if isempty(p_de)
    p_de = dsc_db_static.gdef.descr;
  endif
  
  ## update data structure
  r_ds.r01.i = p_ai;
  r_ds.r02.i = devid;
  r_ds.r03.i = 1;
  r_ds.d01.v = p_tm;
  r_ds.d02.v = p_te;
  ## r_ds.a01.v test name, predefined, see struct_make_static.m
  r_ds.a02.v = p_op;
  ## r_ds.a03.v procedure, predefined, see struct_make_static.m
  ## r_ds.a04.v calculation, predefined, see struct_make_static.m
  r_ds.a05.v = p_de;
  
endfunction
