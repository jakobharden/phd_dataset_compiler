## Export structure element (substructure) of data structure
##
## Usage: [r_ds] = struct_exp_data(p_ds, p_sp)
##
## Note: p_ds must always contain the entire data structure (a complete dataset)!
##
## p_ds ... data structure, <struct>
## p_sp ... structure path, predefined, <str>
##          p_sp = 'meta_ser'      ... return test series metadata substructure
##          p_sp = 'meta_ser_code' ... return test series code
##          p_sp = 'meta_set'      ... return dataset metadata substructure
##          p_sp = 'meta_set_code' ... return dataset code
##          p_sp = 'loc'           ... return location information substructure
##          p_sp = 'lic'           ... return license information substructure
##          p_sp = 'aut'           ... return author information substructure
##          p_sp = 'dev'           ... return device information substructure
##          p_sp = 'mat'           ... return material information substructure
##          p_sp = 'rec'           ... return mixture recipe information substructure
##          p_sp = 'mix'           ... return mixture information substructure
##          p_sp = 'spm'           ... return specimen information substructure
##          p_sp = 'spm1_code'     ... return specimen code, specimen I
##          p_sp = 'spm2_code'     ... return specimen code, specimen II
##          p_sp = 'tst'           ... return test collection substructure
##          p_sp = 'tst.fpd'       ... return FPD test substructure
##          p_sp = 'tst.fpd.den'   ... return FPD test result, fresh paste density, <ADE/struct>
##          p_sp = 'tst.ssd1'      ... return SSD test substructure, specimen I
##          p_sp = 'tst.ssd1.den'  ... return SSD test result, specimen I, solid specimen density, <ADE/struct>
##          p_sp = 'tst.ssd2'      ... return SSD test substructure, specimen II
##          p_sp = 'tst.ssd2.den'  ... return SSD test result, specimen II, solid specimen density, <ADE/struct>
##          p_sp = 'tst.umd1'      ... return UMD test substructure, specimen I
##          p_sp = 'tst.umd1.dist' ... return UMD test result, specimen I, distance betwwen actuator and sensor, <ADE/struct>
##          p_sp = 'tst.umd2'      ... return UMD test substructure, specimen II
##          p_sp = 'tst.umd2.dist' ... return UMD test result, specimen II, distance betwwen actuator and sensor, <ADE/struct>
##          p_sp = 'tst.utt1'      ... return UTT test substructure, specimen I
##          p_sp = 'tst.utt1.i0'   ... return UTT test result, specimen I, sample zero time index (sample index, ts(i0)=0), <ADE/struct>
##          p_sp = 'tst.utt1.t0'   ... return UTT test result, specimen I, maturity zero time (time between mixing and start of test), <ADE/struct>
##          p_sp = 'tst.utt1.mat'  ... return UTT test result, specimen I, specimen maturity array, <ADE/struct>
##          p_sp = 'tst.utt1.ts'   ... return UTT test result, specimen I, signal time array, <ADE/struct>
##          p_sp = 'tst.utt1.ms'   ... return UTT test result, specimen I, signal magnitude matrix, <ADE/struct>
##          p_sp = 'tst.utt1.pw'   ... return UTT test result, specimen I, pulse width, <ADE/struct>
##          p_sp = 'tst.utt1.sr'   ... return UTT test result, specimen I, sampling rate, <ADE/struct>
##          p_sp = 'tst.utt2'      ... return UTT test substructure, specimen II
##          p_sp = 'tst.utt2.i0'   ... return UTT test result, specimen II, sample zero time index (sample index, ts(i0)=0), <ADE/struct>
##          p_sp = 'tst.utt2.t0'   ... return UTT test result, specimen II, maturity zero time (time between mixing and start of test), <ADE/struct>
##          p_sp = 'tst.utt2.mat'  ... return UTT test result, specimen II, specimen maturity array, <ADE/struct>
##          p_sp = 'tst.utt2.ts'   ... return UTT test result, specimen II, signal time array, <ADE/struct>
##          p_sp = 'tst.utt2.ms'   ... return UTT test result, specimen II, signal magnitude matrix, <ADE/struct>
##          p_sp = 'tst.utt2.pw'   ... return UTT test result, specimen II, pulse width, <ADE/struct>
##          p_sp = 'tst.utt2.sr'   ... return UTT test result, specimen II, sampling rate, <ADE/struct>
##          p_sp = 'tst.tem'       ... return TEM test substructure
##          p_sp = 'tst.tem.mat'   ... return TEM test result, time series, specimen maturity, <ADE/struct>
##          p_sp = 'tst.tem.ms1'   ... return TEM test result, magnitude series, thermocouple 1, <ADE/struct>
##          p_sp = 'tst.tem.ms2'   ... return TEM test result, magnitude series, thermocouple 2, <ADE/struct>
##          p_sp = 'tst.tem.ms3'   ... return TEM test result, magnitude series, thermocouple 3, <ADE/struct>
##          p_sp = 'tst.tem.ms4'   ... return TEM test result, magnitude series, thermocouple 4, <ADE/struct>
##          p_sp = 'tst.env'       ... return ENV test substructure
##          p_sp = 'tst.env.temp'  ... return ENV test result, environment temperature, <ADE/struct>
## r_ds ... return: substructure of data structure, <struct>
##
## see also: struct_import, struct_dataset
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
function [r_ds] = struct_exp_data(p_ds, p_sp)
  
  ## check arguments
  if (nargin < 2)
    help struct_exp_data;
    error('Less arguments given!');
  endif
  if isempty(p_ds)
    help struct_exp_data;
    error('Data structure is empty!');
  endif
  if isempty(p_sp)
    help struct_exp_data;
    error('Structure path is empty!');
  endif
  
  ## init return result
  r_ds = [];
  
  ## switch structure path
  switch (p_sp)
    case {'meta_ser'}
      r_ds = p_ds.meta_ser;
    case {'meta_ser_code'}
      r_ds = p_ds.meta_ser.a01;
    case {'meta_set'}
      r_ds = p_ds.meta_set;
    case {'meta_set_code'}
      r_ds = p_ds.meta_set.a01;
    case {'loc'}
      r_ds = p_ds.loc;
    case {'lic'}
      r_ds = p_ds.lic;
    case {'aut'}
      r_ds = p_ds.aut;
    case {'dev'}
      r_ds = p_ds.dev;
    case {'mat'}
      r_ds = p_ds.mat;
    case {'mix'}
      r_ds = p_ds.mix;
    case {'rec'}
      r_ds = p_ds.rec;
    case {'spm'}
      r_ds = p_ds.spm;
    case {'spm1_code'}
      r_ds = p_ds.spm(1).a01;
    case {'spm2_code'}
      r_ds = p_ds.spm(2).a01;
    case {'tst'}
      r_ds = p_ds.tst;
    case {'tst.fpd', 'tst.s01'}
      if not(isempty(p_ds.tst.s01))
        r_ds = p_ds.tst.s01;
      endif
    case {'tst.fpd.den', 'tst.s01.d06'}
      if not(isempty(p_ds.tst.s01))
        r_ds = p_ds.tst.s01.d06;
      endif
    case {'tst.ssd1','tst.s02'}
      r_ds = p_ds.tst.s02;
    case {'tst.ssd1.den','tst.s02.d08'}
      r_ds = p_ds.tst.s02.d08;
    case {'tst.ssd2', 'tst.s03'}
      r_ds = p_ds.tst.s03;
    case {'tst.ssd2.den','tst.s03.d08'}
      r_ds = p_ds.tst.s03.d08;
    case {'tst.umd1', 'tst.s04'}
      r_ds = p_ds.tst.s04;
    case {'tst.umd1.dist', 'tst.s04.d04'}
      r_ds = p_ds.tst.s04.d04;
    case {'tst.umd2', 'tst.s05'}
      r_ds = p_ds.tst.s05;
    case {'tst.umd2.dist', 'tst.s05.d04'}
      r_ds = p_ds.tst.s05.d04;
    case {'tst.utt1', 'tst.s06'}
      r_ds = p_ds.tst.s06;
    case {'tst.utt1.i0', 'tst.s06.d09'}
      r_ds = p_ds.tst.s06.d09;
    case {'tst.utt1.t0', 'tst.s06.d02'}
      r_ds = p_ds.tst.s06.d02;
    case {'tst.utt1.mat', 'tst.s06.d11'}
      r_ds = p_ds.tst.s06.d11;
    case {'tst.utt1.ts', 'tst.s06.d12'}
      r_ds = p_ds.tst.s06.d12;
    case {'tst.utt1.ms', 'tst.s06.d13'}
      r_ds = p_ds.tst.s06.d13;
    case {'tst.utt1.pw', 'tst.s06.d06'}
      r_ds = p_ds.tst.s06.d06;
    case {'tst.utt1.sr', 'tst.s06.d07'}
      r_ds = p_ds.tst.s06.d07;
    case {'tst.utt2', 'tst.s07'}
      r_ds = p_ds.tst.s07;
    case {'tst.utt2.i0', 'tst.s07.d09'}
      r_ds = p_ds.tst.s07.d09;
    case {'tst.utt2.t0', 'tst.s07.d02'}
      r_ds = p_ds.tst.s07.d02;
    case {'tst.utt2.mat', 'tst.s07.d11'}
      r_ds = p_ds.tst.s07.d11;
    case {'tst.utt2.ts', 'tst.s07.d12'}
      r_ds = p_ds.tst.s07.d12;
    case {'tst.utt2.ms', 'tst.s07.d13'}
      r_ds = p_ds.tst.s07.d13;
    case {'tst.utt2.pw', 'tst.s07.d06'}
      r_ds = p_ds.tst.s07.d06;
    case {'tst.utt2.sr', 'tst.s07.d07'}
      r_ds = p_ds.tst.s07.d07;
    case {'tst.tem', 'tst.s08'}
      if not(isempty(p_ds.tst.s08))
        r_ds = p_ds.tst.s08;
      endif
    case {'tst.tem.mat', 'tst.s08.d02'}
      if not(isempty(p_ds.tst.s08))
        r_ds = p_ds.tst.s08.d02;
      endif
    case {'tst.tem.ms1', 'tst.s08.d03'}
      if not(isempty(p_ds.tst.s08))
        r_ds = p_ds.tst.s08.d03;
      endif
    case {'tst.tem.ms2', 'tst.s08.d04'}
      if not(isempty(p_sp.tst.s08))
        r_ds = p_sp.tst.s08.d04;
      endif
    case {'tst.tem.ms3', 'tst.s08.d05'}
      if not(isempty(p_ds.tst.s08))
        r_ds = p_ds.tst.s08.d05;
      endif
    case {'tst.tem.ms4', 'tst.s08.d06'}
      if not(isempty(p_ds.tst.s08))
        r_ds = p_ds.tst.s08.d06;
      endif
    case {'tst.env', 'tst.s09'}
      r_ds = p_ds.tst.s09;
    case {'tst.env.temp', 'tst.s09.d02'}
      r_ds = p_ds.tst.s09.d02;
    otherwise
      help struct_exp_data;
      warning('Structure element path not defined! Return empty data structure.');
  endswitch
  
endfunction
