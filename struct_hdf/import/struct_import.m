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
## Import measurement data and compile dataset (GNU octave binary file)
##
## Usage 1: [r_ds] = struct_import(p_stp, p_src)
##
## Usage 2: [r_ds] = struct_import(), return empty dataset data structure
##
## p_stp ... data source type, <str>
##             "paste":      paste test
##             "ref_air":    reference test, air
##             "ref_water":  reference test, water
##             "ref_alucyl": reference test, aluminium cylinder
##             "ref_f2f":    reference test, face-to-face test, actuator and sensor are directly connected to each other
## p_src ... project data source path (zip archive or directory) <str>
##             Usage 1: full qualified project archive file path (*.zip), <str>
##             Usage 2: full qualified project directory path, <str>
##
## see also: struct_dataset
##
function [r_ds] = struct_import(p_stp, p_src)
  
  ## check arguments
  if (nargin == 0)
    r_ds = struct_dataset();
    return;
  endif
  if (nargin < 2)
    help struct_import;
    error('Less arguments given!');
  endif
  
  ## check, whether archive or directory is provided
  is_archive = false;
  if (exist(p_src, "file") == 2)
    [zdir, zname, zext] = fileparts(p_src);
    if strcmpi(zext, '.zip')
      is_archive = true;
    else
      help struct_import;
      error('Archive file extension is not ".zip"!');
    endif
  endif
  
  if (is_archive)
    ## extract project archive to temporary directory
    [sdp, tdp] = fio_unzip_tempdir(p_src);
    disp('Start import from project archive.');
  else
    ## import from existing directory
    tdp = p_src;
    disp('Start import from project directory.');
  endif
  
  ## parse project information file
  pinf = fio_projinfo_read(fullfile(tdp, 'projinfo.txt'));
  
  ## import test series metadata
  ds_ser = struct_metaser(pinf.ser_code);
  
  ## import data set metadata
  ds_set = struct_metaset(pinf.set_code);
  
  ## get output file path
  if (is_archive)
    ofp = fullfile(sdp, sprintf('%s.oct', ds_set.a17.v));
  else
    [pardir, subdir, dirext] = fileparts(p_src);
    ofp = fullfile(pardir, sprintf('%s.oct', ds_set.a17.v));
  endif
  
  ## get project directory structure
  [rstat, pds] = fio_read_project(tdp);
  if (rstat == false)
    help struct_import;
    error('Cannot parse project directory file structure!');
  endif
  
  ## create dataset
  switch (p_stp)
    case 'paste'
      r_ds = hlp_ds_paste(ds_ser, ds_set, pinf, pds);
    case {'ref_air', 'ref_water', 'ref_alucyl', 'ref_f2f'}
      r_ds = hlp_ds_ref(ds_ser, ds_set, pinf, pds, p_stp);
    otherwise
      ## remove temporary directory
      if (is_archive)
        fio_remove_tempdir(tdp);
      endif
      help struct_import;
      error('Unknown source type! type = %s', p_stp);
  endswitch
  
  ## remove temporary directory
  if (is_archive)
    fio_remove_tempdir(tdp);
  endif
  
  ## save structure to file
  fio_struct_save(r_ds, ofp, 'save_meta_json')
  
endfunction

############################################################################################################################################
## Helper function: create dataset for paste tests
## p_ds_ser ... series metadata data structure, <struct>
## p_ds_set ... dataset metadata data structure, <struct>
## p_pinf   ... project information data structure, <struct>
## p_pds    ... project directory data structure, <struct>
function [r_ds] = hlp_ds_paste(p_ds_ser, p_ds_set, p_pinf, p_pds)
  
  ## read static information from global variable, see also init.m
  global dsc_db_static
  
  ## get author id
  aut_id = p_ds_ser.r01.i;
    
  ## import mixture information, create data structure
  ## data source: project information file
  ds_mix = struct_mix(...
    aut_id, ...
    p_pinf.mix_dev, ...
    p_pinf.mix_id, ...
    p_pinf.mix_rc, ...
    p_pinf.mix_tm, ...
    p_pinf.mix_op, ...
    p_pinf.mix_mt, ...
    p_pinf.mix_sl);
    
  ## import specimen information (specimen I), create data structure
  ## data source: project information file
  ds_spm(1) = struct_spm_paste(...
    aut_id, ...
    p_pinf.spm_mi, ...
    p_pinf.spm_dev, ...
    p_pinf.spm_tm, ...
    p_pinf.spm1_id, ...
    p_pinf.spm1_sc, ...
    p_pinf.spm_op);
    
  ## import specimen information (specimen II), create data structure
  ## data source: project information file
  ds_spm(2) = struct_spm_paste(...
    aut_id, ...
    p_pinf.spm_mi, ...
    p_pinf.spm_dev, ...
    p_pinf.spm_tm, ...
    p_pinf.spm2_id, ...
    p_pinf.spm2_sc, ...
    p_pinf.spm_op);
    
  ## create empty test collection data structure
  ds_tst = dsc_db_static.struct_test;
    
  ## import fresh paste density test data, create data structure
  ## data source: project information file
  if (p_pinf.fpd_exst)
    ds_tst.s01 = struct_test_fpd(...
      aut_id, ...
      p_pinf.fpd_mi, ...
      p_pinf.fpd_dev, ...
      p_pinf.fpd_tm, ...
      p_pinf.fpd_wg, ...
      p_pinf.fpd_wb, ...
      p_pinf.fpd_vb, ...
      p_pinf.fpd_op);
  endif
  
  ## import solid specimen density test data, create data structure
  ## data source: project information file
  if (p_pinf.ssd_exst)
    ## create data structure ssd1, channel 1, specimen I
    ds_tst.s02 = struct_test_ssd1(...
      aut_id, ...
      p_pinf.ssd1_si, ...
      p_pinf.ssd_dev, ...
      p_pinf.ssd_tm, ...
      p_pinf.ssd1_md, ...
      p_pinf.ssd1_mf, ...
      p_pinf.ssd_tw, ...
      p_pinf.ssd_op);
    ## create data structure ssd2, channel 2, specimen II
    ds_tst.s03 = struct_test_ssd1(...
      aut_id, ...
      p_pinf.ssd2_si, ...
      p_pinf.ssd_dev, ...
      p_pinf.ssd_tm, ...
      p_pinf.ssd2_md, ...
      p_pinf.ssd2_mf, ...
      p_pinf.ssd_tw, ...
      p_pinf.ssd_op);
  endif
  
  ## import ultrasonic measurement distance test data, create data structure
  ## data source: project information file
  if (p_pinf.umd_exst)
    ## create data structure umd1, channel 1, specimen I
    ds_tst.s04 = struct_test_umd1(...
      aut_id, ...
      p_pinf.umd1_si, ...
      p_pinf.umd_dev, ...
      p_pinf.umd_tm, ...
      p_pinf.umd1_dt, ...
      p_pinf.umd_ds, ...
      p_pinf.umd_op);
    ## create data structure umd2, channel 2, specimen II
    ds_tst.s05 = struct_test_umd1(...
      aut_id, ...
      p_pinf.umd2_si, ...
      p_pinf.umd_dev, ...
      p_pinf.umd_tm, ...
      p_pinf.umd2_dt, ...
      p_pinf.umd_ds, ...
      p_pinf.umd_op);
  endif
  
  ## import environment temperature measurement data, create data structure
  ## data source: project information file
  if (p_pinf.env_exst)
    ds_tst.s09 = struct_test_env1(...
      aut_id, ...
      p_pinf.env_dev, ...
      p_pinf.env_tm, ...
      p_pinf.env_te, ...
      p_pinf.env_op);
  endif
  
  ## import specimen temperature measurement data, create data structure
  ## data source: project information file (p_pinf), project directory structure (p_pds)
  if (p_pinf.tem_exst)
    ds_tst.s08 = struct_test_tem(...
      aut_id, ...
      p_pinf.tem_si, ...
      p_pinf.tem_dev, ...
      p_pinf.utt_tm, ...
      p_pds.fp_tt1, ...
      p_pinf.tem_op);
  endif
  
  ## import ultrasonic transmission test data, create data structures
  ## data source: project information file (p_pinf), project directory structure (p_pds)
  if (p_pinf.utt_exst)
    ## get device id's, general
    [~, devid_utt] = struct_dev(p_pinf.utt_dev);
    ## get device id's, channel 1
    [~, devid_utt1] = struct_dev(p_pinf.utt1_dev);
    ## get device id's, channel 2 
    [~, devid_utt2] = struct_dev(p_pinf.utt2_dev);
    ## create data structure utt1, channel 1, specimen I
    ds_tst.s06 = struct_test_utt(...
      aut_id, ...
      p_pinf.utt1_si, ...
      unique([devid_utt, devid_utt1]), ...
      p_pinf.utt_tm, ...
      p_pinf.utt_t0, ...
      p_pds.dp_ch1, ...
      p_pinf.utt_op);
    ## create data structure utt2, channel 2, specimen II
    ds_tst.s07 = struct_test_utt(...
      aut_id, ...
      p_pinf.utt2_si, ...
      unique([devid_utt, devid_utt2]), ...
      p_pinf.utt_tm, ...
      p_pinf.utt_t0, ...
      p_pds.dp_ch2, ...
      p_pinf.utt_op);
  endif
  
  ## create dataset data structure
  r_ds = struct_dataset(p_ds_ser, p_ds_set, ds_mix, ds_spm, ds_tst);
  
endfunction

############################################################################################################################################
## Helper function: create dataset for reference tests
## p_ds_ser ... series metadata data structure, <struct>
## p_ds_set ... dataset metadata data structure, <struct>
## p_pinf   ... project information data structure, <struct>
## p_pds    ... project directory data structure, <struct>
## p_stp    ... source type, <str>
function [r_ds] = hlp_ds_ref(p_ds_ser, p_ds_set, p_pinf, p_pds, p_stp)
  
  ## read static information from global variable, see also init.m
  global dsc_db_static
  
  ## get channel description
  descr1 = dsc_db_static.gdef.descr_spm1;
  descr2 = dsc_db_static.gdef.descr_spm2;
  
  ## get author id
  aut_id = p_ds_ser.r01.i;
  
  ## import specimen information (specimen I,specimen II), create data structure
  ## data source: project information file
  ds_spm = struct_spm_ref(p_stp, aut_id, p_pinf.spm_mi, p_pinf.spm_dev, p_pinf.spm_tm, p_pinf.spm_id, p_pinf.spm_sc, p_pinf.spm_op);
    
  ## create empty test collection data structure
  ds_tst = dsc_db_static.struct_test;
  
  ## import specimen density test data (specimen I, specimen II), create data structure
  ## data source: project information file
  switch (p_stp)
    case 'ref_alucyl'
      descr = 'Same aluminium cylinder was used for compression- and shear wave measurements.';
      ds_tst.s02 = struct_test_ssd2(aut_id, p_pinf.ssd_si, p_pinf.ssd_dev, p_pinf.ssd_tm, p_pinf.ssd_wght, p_pinf.ssd_dia, ...
        p_pinf.ssd_len, p_pinf.env_op, descr);
      ds_tst.s03 = ds_tst.s02;
    otherwise
      ds_tst.s02 = [];
      ds_tst.s03 = [];
  endswitch
  
  ## import ultrasonic measurement distance test data (specimen I, specimen II), create data structure
  ## data source: project information file
  if (p_pinf.umd_exst)
    switch (p_stp)
      case 'ref_alucyl'
        descr = 'Distance between actuator and sensor is equal to height of aluminium cylinder. Same aluminium cylinder was used for compression- and shear wave measurements.';
        ds_tst.s04 = struct_test_umd2(aut_id, p_pinf.umd_si, p_pinf.umd_dev, p_pinf.umd_tm, p_pinf.umd_dist, p_pinf.umd_op, descr);
        ds_tst.s05 = ds_tst.s04;
      otherwise
        ds_tst.s04 = struct_test_umd2(aut_id, p_pinf.umd1_si, p_pinf.umd_dev, p_pinf.umd_tm, p_pinf.umd1_dist, p_pinf.umd_op, descr1);
        ds_tst.s05 = struct_test_umd2(aut_id, p_pinf.umd2_si, p_pinf.umd_dev, p_pinf.umd_tm, p_pinf.umd2_dist, p_pinf.umd_op, descr2);
    endswitch
  endif
  
  ## import environment temperature measurement data, create data structure
  ## data source: project information file
  if (p_pinf.env_exst)
    ds_tst.s09 = struct_test_env2(aut_id, p_pinf.env_dev, p_pinf.env_tm, p_pinf.env_te, p_pinf.env_hu, p_pinf.env_op);
  endif
  
  ## import ultrasonic transmission test data, create data structures
  ## data source: project information file (p_pinf), project directory structure (p_pds)
  if (p_pinf.utt_exst)
    ## get device id's, general
    [~, devid_utt] = struct_dev(p_pinf.utt_dev);
    ## get device id's, channel 1
    [~, devid_utt1] = struct_dev(p_pinf.utt1_dev);
    ## get device id's, channel 2 
    [~, devid_utt2] = struct_dev(p_pinf.utt2_dev);
    ## create data structure utt1, channel 1, specimen I
    ds_tst.s06 = struct_test_utt(...
      aut_id, ...
      p_pinf.utt1_si, ...
      unique([devid_utt, devid_utt1]), ...
      p_pinf.utt_tm, ...
      p_pinf.utt_t0, ...
      p_pds.dp_ch1, ...
      p_pinf.utt_op, ...
      descr1);
    ## create data structure utt2, channel 2, specimen II
    ds_tst.s07 = struct_test_utt(...
      aut_id, ...
      p_pinf.utt2_si, ...
      unique([devid_utt, devid_utt2]), ...
      p_pinf.utt_tm, ...
      p_pinf.utt_t0, ...
      p_pds.dp_ch2, ...
      p_pinf.utt_op, ...
      descr2);
  endif
  
  ## create dataset data structure
  r_ds = struct_dataset(p_ds_ser, p_ds_set, [], ds_spm, ds_tst);
  
endfunction
