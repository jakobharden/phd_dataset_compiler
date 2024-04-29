## Create data structure for temperature measurement with thermocouples
##
## Usage 1: [r_ds] = struct_test_tem(p_ai, p_si, p_di, p_tm, p_fp, p_op, p_de), return initialized data structure
##
## Usage 2: [r_ds] = struct_test_tem(), return empty data structure
##
## p_ai ... related author id's, <uint> or [<uint>]
## p_si ... related specimen id, <uint>
## p_di ... related device id's or device group name, <uint> or [<uint>] or <str>
## p_tm ... date and time, unit sec (utc, seconds since epoch), <dbl>
## p_fp ... measurement file path, <str>
## p_op ... operator name, <str>
## p_de ... description, optional, <str>
## r_ds ... return: test data, <struct>
##   .obj ... object type, always "struct_test_tem", <str>
##   .ver ... version number [major_ver, minor_ver], [<uint>]
##   .r01 ... related authors, <ARE/struct>
##   .r02 ... related specimen, <ARE/struct>
##   .r03 ... related devices, <ARE/struct>
##   .r04 ... related location, <ARE/struct>
##   .d01 ... date and time, <ADE/struct>
##   .d02 ... maturity time array, <ADE/struct>
##   .d03 ... measurement magnitude array, thermocouple 1, <ADE/struct>
##   .d04 ... measurement magnitude array, thermocouple 2, <ADE/struct>
##   .d05 ... measurement magnitude array, thermocouple 3, <ADE/struct>
##   .d06 ... measurement magnitude array, thermocouple 4, <ADE/struct>
##   .a01 ... test name, <AAE/struct>
##   .a02 ... operator name, <AAE/struct>
##   .a03 ... procedure, <AAE/struct>
##   .a04 ... calculation, <AAE/struct>
##   .a05 ... description, <AAE/struct>
##   .a06 ... placement, thermocouple 1, <AAE/struct>
##   .a07 ... placement, thermocouple 2, <AAE/struct>
##   .a08 ... placement, thermocouple 3, <AAE/struct>
##   .a09 ... placement, thermocouple 4, <AAE/struct>
##   .a10 ... data directory path, <AAE/struct>
##   .a11 ... data file path, <AAE/struct>
##   .a12 ... data file name, <AAE/struct>
##   .a13 ... data file hash, <AAE/struct>
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
function [r_ds] = struct_test_tem(p_ai, p_si, p_di, p_tm, p_fp, p_op, p_de)
  
  ## read static information from global variable, see also init.m
  global dsc_db_static
  
  ## init return values
  r_ds = dsc_db_static.struct_test_tem;
  
  ## check arguments
  if (nargin == 0)
    return;
  endif
  if (nargin < 7)
    p_de = [];
  endif
  if (nargin < 6)
    help struct_test_tem;
    error('Less arguments given!');
  endif
  
  ## get device id's
  [~, devid] = struct_dev(p_di);
  
  ## get description
  if isempty(p_de)
    p_de = dsc_db_static.gdef.descr;
  endif
  
  # read temperature data from file
  ts = [];
  ms1 = [];
  ms2 = [];
  ms3 = [];
  ms4 = [];
  fdir = '';
  fpath = '';
  fname = '';
  fhash = '';
  if isempty(p_fp)
    warning("Data file path is empty! Skip reading measurement data.");
  else
    ## parse temperature data file
    [r_state, r_data] = fio_read_temperature(p_fp);
    if not(r_state)
      help struct_test_tem;
      error('Cannot read specimen temperature measurement data file!\n   path = %s', p_fp);
    endif
    ## skip first row (--> arrary(2:end, i)), first row contains only a number representing the column index
    ts = uint32(r_data.ts(2:end));
    ms1 = single(r_data.ms(2:end, 1));
    ms2 = single(r_data.ms(2:end, 2));
    ms3 = single(r_data.ms(2:end, 3));
    ms4 = single(r_data.ms(2:end, 4));
    fdir = r_data.fdir;
    fpath = r_data.fpath;
    fname = r_data.fname;
    fhash = r_data.fhash;
  endif
  
  ## update data structure
  r_ds.r01.i = p_ai;
  r_ds.r02.i = p_si;
  r_ds.r03.i = devid;
  r_ds.r04.i = 1;
  r_ds.d01.v = p_tm;
  r_ds.d02.v = ts;
  r_ds.d03.v = ms1;
  r_ds.d04.v = ms2;
  r_ds.d05.v = ms3;
  r_ds.d06.v = ms4;
  ## r_ds.a01.v test name, predefined, see struct_make_static.m
  r_ds.a02.v = p_op;
  ## r_ds.a03.v procedure, predefined, see struct_make_static.m
  ## r_ds.a04.v calculation, predefined, see struct_make_static.m
  r_ds.a05.v = p_de;
  ## r_ds.a06.v placement of thermocouple 1, predefined, see struct_make_static.m
  ## r_ds.a07.v placement of thermocouple 2, predefined, see struct_make_static.m
  ## r_ds.a08.v placement of thermocouple 3, predefined, see struct_make_static.m
  ## r_ds.a09.v placement of thermocouple 4, predefined, see struct_make_static.m
  r_ds.a10.v = fdir;
  r_ds.a11.v = fpath;
  r_ds.a12.v = fname;
  r_ds.a13.v = fhash;
  
endfunction
