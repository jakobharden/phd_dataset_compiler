## Create data structure for the solid specimen density test 1 (gravimetric, immersion weighing)
##
## Usage 1: [r_ds] = struct_test_ssd1(p_ai, p_si, p_di, p_tm, p_md, p_mf, p_tw, p_op, p_de), return initialized data structure
##
## Usage 2: [r_ds] = struct_test_ssd1(), return empty data structure
##
## p_ai ... related author id's, <uint> or [<uint>]
## p_si ... related specimen id (one of [1, 2]), <uint>
## p_di ... related device id's or device group name, <uint> or [<uint>] or <str>
## p_tm ... date and time (utc, seconds since epoch), <dbl>
## p_md ... specimen weight, unit g, <dbl>
## p_mf ... floating specimen weight, unit g, <dbl>
## p_tw ... water temperature of water container, unit °C, <dbl>
## p_op ... operator name, <str>
## p_de ... description, optional, <str>
## r_ds ... return: test data structure, <struct>
##   .obj ... object type, always "struct_test_ssd1", <str>
##   .ver ... version number [major_ver, minor_ver], [<uint>]
##   .r01 ... related authors, <ARE/struct>
##   .r02 ... related specimen, <ARE/struct>
##   .r03 ... related devices, <ARE/struct>
##   .r04 ... related location, <ARE/struct>
##   .d01 ... date and time, <ADE/struct>
##   .d02 ... specimen weight, <ADE/struct>
##   .d03 ... floating specimen weight, <ADE/struct>
##   .d04 ... water temperature, <ADE/struct>
##   .d05 ... water density, <ADE/struct>
##   .d06 ... water weight displaced, <ADE/struct>
##   .d07 ... specimen volume, <ADE/struct>
##   .d08 ... specimen density, <ADE/struct>
##   .a01 ... test name, <AAE/struct>
##   .a02 ... operator name, <AAE/struct>
##   .a03 ... procedure, <AAE/struct>
##   .a04 ... calculation, <AAE/struct>
##   .a05 ... description, <AAE/struct>
##
## see also: struct_objdata, struct_objref, struct_objattrib
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
function [r_ds] = struct_test_ssd1(p_ai, p_si, p_di, p_tm, p_md, p_mf, p_tw, p_op, p_de)
  
  ## read static information from global variable, see also init.m
  global dsc_db_static
  
  ## init return values
  r_ds = dsc_db_static.struct_test_ssd1;
  
  ## check arguments
  if (nargin == 0)
    return;
  endif
  if (nargin < 9)
    p_de = [];
  endif
  if (nargin < 8)
    help struct_test_ssd1;
    error('Less arguments given!');
  endif
  
  ## check device index list
  [~, devid] = struct_dev(p_di);
  
  ## get description
  if (isempty(p_de))
    switch (p_si)
      case 1
        p_de = dsc_db_static.gdef.descr_spm1;
      case 2
        p_de = dsc_db_static.gdef.descr_spm2;
      otherwise
        p_de = dsc_db_static.gdef.descr;
    endswitch
  endif
  
  ## update data structure
  r_ds.r01.i = p_ai;
  r_ds.r02.i = p_si;
  r_ds.r03.i = devid;
  r_ds.r04.i = 1;
  r_ds.d01.v = p_tm;
  r_ds.d02.v = p_md;
  r_ds.d03.v = p_mf;
  r_ds.d04.v = p_tw;
  r_ds.d05.v = hlp_density_water(r_ds.d04.v);
  r_ds.d06.v = r_ds.d02.v - r_ds.d03.v;
  r_ds.d07.v = r_ds.d06.v / r_ds.d05.v;
  r_ds.d08.v = r_ds.d02.v / r_ds.d07.v;
  ## r_ds.a01.v test name, predefined, see struct_make_static.m
  r_ds.a02.v = p_op;
  ## r_ds.a03.v procedure, predefined, see struct_make_static.m
  ## r_ds.a04.v calculation, predefined, see struct_make_static.m
  r_ds.a05.v = p_de;
  
endfunction

############################################################################################################################################
## Helper function: compute density of water for given water temperature
## Table contains values of water density from +15°C to +30.9°C
## Source: https://www.simetric.co.uk/si_water.htm
##
## p_tew ... water temperature, unit °C, <dbl>
## r_rho ... return: density of water, unit g/cm^3, <dbl>
##
function [r_rho] = hlp_density_water(p_tew)
  
  ## read static information from global variable
  ## read by init.m from file ./struct_hdf/db_static.oct
  global dsc_db_static
  
  idx = fix(p_tew * 10) - 149;
  if ((idx < 1) || (idx > 160))
    r_rho = dsc_db_static.gdef.tab_density_water(51); # rho_w at 20°C
  else
    r_rho = dsc_db_static.gdef.tab_density_water(idx);
  endif
  
endfunction
