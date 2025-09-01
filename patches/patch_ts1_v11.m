## Patch for the datasets of Test series 1 - cement paste at early stage of hydration
##
##   Applies to datasets: ts1_*.oct, DOI: https://doi.org/10.3217/bhs4g-m3z76
##   Input version:       1.0
##   Patched version:     1.1
##   Reasons:             1) correction of a device model identifier (wrong identifier), structure field a01 and a03, Testo-454 replaced by Testo-177T4
##                        2) added field a07 to device data structure (text/URL with product specifications)
##   Author:              Jakob harden (Graz University of Technology)
##   Date:                2025-02-03
##
## Usage: patch_ts1_v11(p_id, p_od)
##
## p_id ... input directory path containig the datasets to be patched (*.oct files), <str>
## p_od ... output directory path to save the patched datasets (*.oct files), <str>
##
## see also: fio_struct_save, struct_test_ssd2, struct_make_metasetdb
##
## Copyright 2025 Jakob Harden (jakob.harden@tugraz.at, Graz University of Technology, Graz, Austria)
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
function patch_ts1_v11(p_id, p_od)
  
  ## check input directory
  if not(exist(p_id, 'dir') == 7)
    error('Input directory path does not exist!');
  endif
  
  ## check input directory
  if not(exist(p_od, 'dir') == 7)
    error('Output directory path does not exist!');
  endif
  
  ## check wheter input and output dirctory is the same directory
  if (strcmp(p_id(end), filesep()))
    p_id(end) = [];
  endif
  if (strcmp(p_od(end), filesep()))
    p_od(end) = [];
  endif
  if (strcmp(p_id, p_od))
    error('Input and output directory must not be the same!');
  endif
  
  ## get dataset file paths
  flt = fullfile(p_id, '*.oct');
  dsl = dir(flt);
  
  ## loop over files, patch files
  for k = 1 : numel(dsl)
    idp = dsl(k).folder; # input directory path
    ifn = dsl(k).name; # input file name
    odp = p_od; # output directory path
    ofn = ifn; # output file name
    patch_ts7_v11_patch_dataset(idp, ifn, odp, ofn); # patch data set
  endfor
  
endfunction


function patch_ts1_v11_patch_dataset(p_idp, p_ifn, p_odp)
  ## Patch dataset
  ##
  ## p_idp ... input directory path, <str>
  ## p_ifn ... input file name, <str>
  ## p_odp ... output directory path, <str>
  ## p_ofn ... output file name, <str>
  
  ## load data set
  ds = load(fullfile(p_idp, p_ifn), 'dataset').dataset;
  
  ## check data set code
  switch (ds.meta_set.a01.v)
    case {}
  endswitch
  
  ## check data set version
  if not(strcmp(ds.meta_set.a15.v, '1.0'))
    error('This patch does not apply to data set version %s', ds.meta_set.a15.v);
  endif
  
  ## update field values
  ds.meta_set.a15.v = '1.1'; # data set metadata, data set version number
  ds.dev.
  
  ## save updated data set
  ofp = fullfile(p_odp, p_ifn);
  fio_struct_save(ds, ofp, 'save_meta_json');
  
  ## print message on screen
  printf('Patched data set %s. output path = %s\n', p_ifn, ofp);
  
endfunction
