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
## Create main data structure (data set)
##
## Usage 1: [r_ds] = struct_dataset(p_ser, p_set, p_mix, p_spm, p_tst), return initialized data structure
##
## Usage 2: [r_ds] = struct_dataset(), return empty data structure
##
## p_ser  ... test series matadata data structure, <struct>
## p_set  ... data set matadata data structure, <struct>
## p_mix  ... mixture or material data structure, <struct>
## p_spm  ... specimen data structure, <struct>
## p_tst  ... test collection data structure, <struct>
## r_ds   ... return: dataset data structure (top level) <struct>
##   .obj      ... object type, always "struct_dataset", <str>
##   .ver      ... version number [major_ver, minor_ver], [<uint>]
##   .meta_ser ... substructure, test series metadata, <struct>
##   .meta_set ... substructure, data set metadata, <struct>
##   .loc      ... substructure, location information, <struct>
##   .lic      ... substructure, license information, <struct>
##   .aut      ... substructure, author information, <struct>
##   .dev      ... substructure, device information, <struct>
##   .mat      ... substructure, material information, <struct>
##   .rec      ... substructure, mixture recipe information, <struct>
##   .mix      ... substructure, mixture information, <struct>
##   .spm      ... substructure, specimen information, <struct>
##   .tst      ... substructure, test collection, <struct>
##
## see also: struct_metaser, struct_metaset, struct_aut, struct_mat, struct_mix, struct_spm, struct_dev, struct_test
##
function [r_ds] = struct_dataset(p_ser, p_set, p_mix, p_spm, p_tst)
  
  ## read static information from global variable, see also init.m
  global dsc_db_static
  
  ## init empty data structure
  r_ds = dsc_db_static.struct_dataset;
  
  ## check arguments
  if (nargin == 0)
    return;
  endif
  if (nargin < 4)
    help struct_dataset;
    error('Less arguments given!');
  endif
  
  ## check fresh paste density test
  autid1 = [];
  devid1 = [];
  locid1 = [];
  if not(isempty(p_tst.s01))
    autid1 = [p_tst.s01.r01.i];
    devid1 = [p_tst.s01.r03.i];
    locid1 = [p_tst.s01.r04.i];
  endif
  
  ## check solid specimen density test, specimen I
  autid2 = [];
  devid2 = [];
  locid2 = [];
  if not(isempty(p_tst.s02))
    autid2 = [p_tst.s02.r01.i];
    devid2 = [p_tst.s02.r03.i];
    locid2 = [p_tst.s02.r04.i];
  endif
  
  ## check solid specimen density test, specimen II
  autid3 = [];
  devid3 = [];
  locid3 = [];
  if not(isempty(p_tst.s03))
    autid3 = [p_tst.s03.r01.i];
    devid3 = [p_tst.s03.r03.i];
    locid3 = [p_tst.s03.r04.i];
  endif
  
  ## check ultrasonic measurement distance test, specimen I
  autid4 = [];
  devid4 = [];
  locid4 = [];
  if not(isempty(p_tst.s04))
    autid4 = [p_tst.s04.r01.i];
    devid4 = [p_tst.s04.r03.i];
    locid4 = [p_tst.s04.r04.i];
  endif
  
  ## check ultrasonic measurement distance test, specimen II
  autid5 = [];
  devid5 = [];
  locid5 = [];
  if not(isempty(p_tst.s05))
    autid5 = [p_tst.s05.r01.i];
    devid5 = [p_tst.s05.r03.i];
    locid5 = [p_tst.s05.r04.i];
  endif
  
  ## check ultrasonic transmission test, specimen I
  autid6 = [];
  devid6 = [];
  locid6 = [];
  if not(isempty(p_tst.s06))
    autid6 = [p_tst.s06.r01.i];
    devid6 = [p_tst.s06.r03.i];
    locid6 = [p_tst.s06.r04.i];
  endif
  
  ## check ultrasonic transmission test, specimen II
  autid7 = [];
  devid7 = [];
  locid7 = [];
  if not(isempty(p_tst.s07))
    autid7 = [p_tst.s07.r01.i];
    devid7 = [p_tst.s07.r03.i];
    locid7 = [p_tst.s07.r04.i];
  endif
  
  ## check specimen temperature test
  autid8 = [];
  devid8 = [];
  locid8 = [];
  if not(isempty(p_tst.s08))
    autid8 = [p_tst.s08.r01.i];
    devid8 = [p_tst.s08.r03.i];
    locid8 = [p_tst.s08.r04.i];
  endif
  
  ## check environment temperature test
  autid9 = [];
  devid9 = [];
  locid9 = [];
  if not(isempty(p_tst.s09))
    autid9 = [p_tst.s09.r01.i];
    devid9 = [p_tst.s09.r02.i];
    locid9 = [p_tst.s09.r03.i];
  endif
  
  ## check mixture/material information
  autid_mix = [];
  devid_mix = [];
  locid_mix = [];
  recds = [];
  matds = [];
  if not(isempty(p_mix))
    ## check structure type (mixture or material)
    if (struct_checktype(p_mix, 'struct_mix'))
      autid_mix = [p_mix.r01.i];
      devid_mix = [p_mix.r02.i];
      locid_mix = [p_mix.r04.i];
      ## collect recipes
      rec_ids = [p_mix.r03.i];
      if not(isempty(rec_ids))
        [recds, ~] = struct_rec(rec_ids);
        ## collect materials from recipes
        [matds, ~] = struct_mat([[recds.s01.r01].i]);
      endif
    elseif (struct_checktype(p_mix, 'struct_mat'))
      matds = p_mix;
    endif
  endif
  
  ## check specimen information
  autid_spm = [];
  devid_spm = [];
  locid_spm = [];
  if not(isempty(p_spm))
    autid_spm = [p_spm.r01].i;
    devid_spm = [p_spm.r03].i;
    locid_spm = [p_spm.r04].i;
    ## collect material from specimen (specimen is not a mix)
    if strcmpi(p_spm(1).obj, 'struct_spm_ref')
      matds = struct_mat([p_spm.r02].i);
    endif
  endif
  
  ## check test series metadata
  autid_ser = [];
  licid_ser = [];
  if not(isempty(p_ser))
    autid_ser = p_ser.r01.i;
    licid_ser = p_ser.r02.i;
  endif
  
  ## check data set metadata
  autid_set = [];
  locid_set = [];
  licid_set = [];
  if not(isempty(p_set))
    autid_set = p_set.r01.i;
    locid_set = p_set.r03.i;
    licid_set = p_set.r04.i;
  endif
  
  ## collect devices
  devid = unique([devid1, devid2, devid3, devid4, devid5, devid6, devid7, devid8, devid9, devid_mix, devid_spm]);
  [devds, ~] = struct_dev(devid);
  
  ## collect authors
  autid = unique([autid1, autid2, autid3, autid4, autid5, autid6, autid7, autid8, autid9, autid_mix, autid_spm, autid_ser, autid_set]);
  [autds, ~] = struct_aut(autid);
  
  ## collect licenses
  if (licid_ser != licid_set)
    error('Licence id of test series and dataset must be equal!');
  endif
  [licds, ~] = struct_lic(licid_set);
  
  ## collect locations
  locid = unique([locid1, locid2, locid3, locid4, locid5, locid6, locid7, locid8, locid9, locid_mix, locid_spm, locid_set]);
  [locds, ~] = struct_loc(locid);
  
  ## update data structure
  r_ds.meta_ser = p_ser;
  r_ds.meta_set = p_set;
  r_ds.loc = locds;
  r_ds.lic = licds;
  r_ds.aut = autds;
  r_ds.dev = devds;
  r_ds.mat = matds;
  r_ds.rec = recds;
  r_ds.mix = p_mix;
  r_ds.spm = p_spm;
  r_ds.tst = p_tst;
  
  ## update table of contents in dataset metadata (r_ds.meta_set.a06.v)
  r_ds.meta_set.a06.v = hlp_metaset_toc(r_ds);
  
endfunction

###############################################################################
## Helper function: append item to list
## p_ds ... dataset, <struct>
## r_toc ... return: string containing the TOC of all tests performed, <str>
function [r_toc] = hlp_metaset_toc(p_ds)
  
  ## init TOC
  toc_idx = 1;
  toc_subidx = 1;
  r_toc = {};
  
  ## test series data set TOC
  r_toc(toc_idx) = 'Data set ... dataset';
  toc_idx = toc_idx + 1;
  
  ## test series metadata
  if not(isempty(p_ds.meta_ser))
    r_toc(toc_idx) = sprintf('(%d) Test series metadata ... dataset.meta_ser', toc_idx - 1);
    toc_idx = toc_idx + 1;
  endif
  ## dataset metadata
  if not(isempty(p_ds.meta_set))
    r_toc(toc_idx) = sprintf('(%d) Data set metadata ... dataset.meta_set', toc_idx - 1);
    toc_idx = toc_idx + 1;
  endif
  ## location information
  if not(isempty(p_ds.loc))
    r_toc(toc_idx) = sprintf('(%d) Location information ... dataset.loc', toc_idx - 1);
    toc_idx = toc_idx + 1;
  endif
  ## license information
  if not(isempty(p_ds.lic))
    r_toc(toc_idx) = sprintf('(%d) License information ... dataset.lic', toc_idx - 1);
    toc_idx = toc_idx + 1;
  endif
  ## author information
  if not(isempty(p_ds.aut))
    r_toc(toc_idx) = sprintf('(%d) Author information ... dataset.aut', toc_idx - 1);
    toc_idx = toc_idx + 1;
  endif
  ## device information
  if not(isempty(p_ds.dev))
    r_toc(toc_idx) = sprintf('(%d) Device information ... dataset.dev', toc_idx - 1);
    toc_idx = toc_idx + 1;
  endif
  ## material information
  if not(isempty(p_ds.mat))
    r_toc(toc_idx) = sprintf('(%d) Material information ... dataset.mat', toc_idx - 1);
    toc_idx = toc_idx + 1;
  endif
  ## mixture recipe information
  if not(isempty(p_ds.rec))
    r_toc(toc_idx) = sprintf('(%d) Mixture recipe information ... dataset.rec', toc_idx - 1);
    toc_idx = toc_idx + 1;
  endif
  ## mixture information
  if not(isempty(p_ds.mix))
    r_toc(toc_idx) = sprintf('(%d) Mixture information ... dataset.mix', toc_idx - 1);
    toc_idx = toc_idx + 1;
  endif
  ## specimen information
  if not(isempty(p_ds.spm))
    r_toc(toc_idx) = sprintf('(%d) Specimen information ... dataset.spm', toc_idx - 1);
    toc_idx = toc_idx + 1;
  endif
  ## test collection
  if not(isempty(p_ds.tst))
    r_toc(toc_idx) = sprintf('(%d) Test collection ... dataset.tst', toc_idx - 1);
  endif
  ## test collection, FPD test data
  if not(isempty(p_ds.tst.s01))
    r_toc(toc_idx + toc_subidx) = sprintf('(%d.%d) %s ... dataset.tst.s01', toc_idx - 1, toc_subidx, p_ds.tst.s01.a01.v);
    toc_subidx = toc_subidx + 1;
  endif
  ## test collection, SSD test data for specimen I
  if not(isempty(p_ds.tst.s02))
    r_toc(toc_idx + toc_subidx) = sprintf('(%d.%d) %s ... dataset.tst.s02', toc_idx - 1, toc_subidx, p_ds.tst.s02.a01.v);
    toc_subidx = toc_subidx + 1;
  endif
  ## test collection, SSD test data for specimen II
  if not(isempty(p_ds.tst.s03))
    r_toc(toc_idx + toc_subidx) = sprintf('(%d.%d) %s ... dataset.tst.s03', toc_idx - 1, toc_subidx, p_ds.tst.s03.a01.v);
    toc_subidx = toc_subidx + 1;
  endif
  ## test collection, UMD test data for specimen I
  if not(isempty(p_ds.tst.s04))
    r_toc(toc_idx + toc_subidx) = sprintf('(%d.%d) %s ... dataset.tst.s04', toc_idx - 1, toc_subidx, p_ds.tst.s04.a01.v);
    toc_subidx = toc_subidx + 1;
  endif
  ## test collection, UMD test data for specimen II
  if not(isempty(p_ds.tst.s05))
    r_toc(toc_idx + toc_subidx) = sprintf('(%d.%d) %s ... dataset.tst.s05', toc_idx - 1, toc_subidx, p_ds.tst.s05.a01.v);
    toc_subidx = toc_subidx + 1;
  endif
  ## test collection, UTT test data for specimen I
  if not(isempty(p_ds.tst.s06))
    r_toc(toc_idx + toc_subidx) = sprintf('(%d.%d) %s ... dataset.tst.s06', toc_idx - 1, toc_subidx, p_ds.tst.s06.a01.v);
    toc_subidx = toc_subidx + 1;
  endif
  ## test collection, UTT test data for specimen II
  if not(isempty(p_ds.tst.s07))
    r_toc(toc_idx + toc_subidx) = sprintf('(%d.%d) %s ... dataset.tst.s07', toc_idx - 1, toc_subidx, p_ds.tst.s07.a01.v);
    toc_subidx = toc_subidx + 1;
  endif
  ## test collection, TEM test data
  if not(isempty(p_ds.tst.s08))
    r_toc(toc_idx + toc_subidx) = sprintf('(%d.%d) %s ... dataset.tst.s08', toc_idx - 1, toc_subidx, p_ds.tst.s08.a01.v);
    toc_subidx = toc_subidx + 1;
  endif
  ## test collection, ENV test data
  if not(isempty(p_ds.tst.s09))
    r_toc(toc_idx + toc_subidx) = sprintf('(%d.%d) %s ... dataset.tst.s09', toc_idx - 1, toc_subidx, p_ds.tst.s09.a01.v);
  endif
  
endfunction
