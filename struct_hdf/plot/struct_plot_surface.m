## Plot ultrasonic measurement data (compression and shear wave) as surface
##
## Usage: [r_fh] = struct_plot_surface(p_src, p_mod, p_sts, p_stm, p_xam, p_yam, p_xmin, p_ymin, p_xmax, p_ymax)
##
## p_dat ... data set data structure or full qualified path to data structure file, <struct>
## p_mod ... plot mode, <int>
##             p_mod = 0: plot compression and shear wave, single graph
##             p_mod = 1: plot compression wave
##             p_mod = 2: plot shear wave
## p_prp ... plot properties, <struct>
##   .fwidth   ... frame width in pixel, <int>
##   .fheight  ... frame height in pixel, <int>
##   .frate    ... frame rate in frames per second, <int>
##   .lcol_ch1 ... line color for the compression wave, <str>
##   .lcol_ch2 ... line color for the shear wave, <str>
##   .bcol_ch1 ... background color for the compression wave, <str>
##   .bcol_ch2 ... background color for the shear wave, <str>
##   .lwid_ch1 ... line width for the compression wave, <float>
##   .lwid_ch2 ... line width for the shear wave, <float>
##   .vlim_ch1 ... absolute value of voltage limit for the compression wave, <float>
##   .vlim_ch2 ... absolute value of voltage limit for the shear wave, <float>
## r_ofp ... return: output file path, <str>
##
## see also: struct_dataset, struct_import
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
function [r_fh] = struct_plot_surface(p_src, p_mod, p_sts, p_stm, p_xam, p_yam, p_xmin, p_ymin, p_xmax, p_ymax)
  
  if (nargin < 1)
    help struct_plot_surface;
    error('Less arguments given!');
  endif
  if (nargin < 2)
    p_mod = 0;
  endif
  if (nargin < 3)
    p_sts = 1;
  endif
  if (nargin < 4)
    p_stm = 1;
  endif
  if (nargin < 5)
    p_xam = 1;
  endif
  if (nargin < 6)
    p_yam = 1;
  endif
  if (nargin < 7)
    p_xmin = 0;
  endif
  if (nargin < 8)
    p_ymin = 0;
  endif
  if (nargin < 9)
    p_xmax = 1000000;
  endif
  if (nargin < 10)
    p_ymax = 1000;
  endif
  
  ## load data set
  ds = fio_struct_load(p_src);
  
  ## plot by given mode
  switch (p_mod)
    case 1
      ## channel 1, compression wave
      ms1 = struct_exp_data(ds, 'tst.utt1.ms');
      ts1 = struct_exp_data(ds, 'tst.utt1.ts');
      i01 = struct_exp_data(ds, 'tst.utt1.i0');
      t01 = struct_exp_data(ds, 'tst.utt1.t0');
      mat1 = struct_exp_data(ds, 'tst.utt1.mat');
      matt01 = mat1;
      matt01.v = mat1.v + t01.v;
      r_fh = hlp_plot1(ms1, ts1, matt01, i01, 1, p_sts, p_stm, p_xam, p_yam, p_xmin, p_ymin, p_xmax, p_ymax);
    case 2
      ## channel 2, shear wave
      ms2 = struct_exp_data(ds, 'tst.utt2.ms');
      ts2 = struct_exp_data(ds, 'tst.utt2.ts');
      i02 = struct_exp_data(ds, 'tst.utt2.i0');
      t02 = struct_exp_data(ds, 'tst.utt2.t0');
      mat2 = struct_exp_data(ds, 'tst.utt2.mat');
      matt02 = mat2;
      matt02.v = mat2.v + t02.v;
      r_fh = hlp_plot1(ms2, ts2, matt02, i02, 2, p_sts, p_stm, p_xam, p_yam, p_xmin, p_ymin, p_xmax, p_ymax);
    otherwise
      ## both channels, compressions- and shear wave
      ms1 = struct_exp_data(ds, 'tst.utt1.ms');
      ts1 = struct_exp_data(ds, 'tst.utt1.ts');
      i01 = struct_exp_data(ds, 'tst.utt1.i0');
      t01 = struct_exp_data(ds, 'tst.utt1.t0');
      mat1 = struct_exp_data(ds, 'tst.utt1.mat');
      matt01 = mat1;
      matt01.v = mat1.v + t01.v;
      ms2 = struct_exp_data(ds, 'tst.utt2.ms');
      ts2 = struct_exp_data(ds, 'tst.utt2.ts');
      i02 = struct_exp_data(ds, 'tst.utt2.i0');
      t02 = struct_exp_data(ds, 'tst.utt2.t0');
      mat2 = struct_exp_data(ds, 'tst.utt2.mat');
      matt02 = mat2;
      matt02.v = mat2.v + t02.v;
      r_fh = hlp_plot2(ms1, ms2, ts1, ts2, matt01, matt02, i01, i02, p_sts, p_stm, p_xam, p_yam, p_xmin, p_ymin, p_xmax, p_ymax);
  endswitch
  
endfunction

################################################################################
## helper function: plot c/s-wave, combined
function [r_fh] = hlp_plot2(p_ms1, p_ms2, p_ts1, p_ts2, p_mat1, p_mat2, p_i01, p_i02, p_sts, p_stm, p_xam, p_yam, p_xmin, p_ymin, p_xmax, p_ymax)
  
  ## number of samples
  nsmp = size(p_ms1.v, 1);
  
  ## number of signals
  nsig = size(p_ms1.v, 2);
  
  xmin = max([p_xmin, 1]);
  ymin = max([p_ymin, 1]);
  xmax = min([p_xmax, nsmp]);
  ymax = min([p_ymax, nsig]);
  
  ## subset index arrays
  dim_t = xmin : p_sts : xmax;
  dim_m = ymin : p_stm : ymax;
  
  ## get data subsets
  ms1 = p_ms1.v(dim_t, dim_m);
  ms2 = p_ms2.v(dim_t, dim_m);
  ts1 = p_ts1.v(dim_t);
  ts2 = p_ts2.v(dim_t);
  mat1 = p_mat1.v(dim_m);
  mat2 = p_mat2.v(dim_m);
  
  ## get labels
  p_zam = 1;
  [ptit1, xlbl1, ylbl1, zlbl1] = hlp_get_labels(1, p_xam, p_yam, p_zam);
  [ptit2, xlbl2, ylbl2, zlbl2] = hlp_get_labels(2, p_xam, p_yam, p_zam);
  
  ## switch x axis mode
  switch (p_xam)
    case 2 # time in usec
      mg11 = ts1 / 10;
      mg12 = ts2 / 10;
    case 3 # time in msec
      mg11 = ts1 / 10000;
      mg12 = ts2 / 10000;
    otherwise
      mg11 = linspace(1, nsmp, nsmp)(dim_t);
      mg12 = mg11;
  endswitch
  
  ## switch y axis mode
  switch (p_yam)
    case 2 # maturity in min
      mg21 = mat1 / 60;
      mg22 = mat2 / 60;
    case 2 # maturity in h
      mg21 = mat1 / 3600;
      mg22 = mat2 / 3600;
    otherwise
      mg21 = linspace(1, nsig, nsig)(dim_m);
      mg22 = mg21;
  endswitch
  
  ## switch z axis mode
  switch (p_zam)
    case 2 # magnitude in mV
      ms1 = ms1 * 1000;
      ms2 = ms2 * 1000;
    otherwise # magnitude in V
      1;
  endswitch
  
  [xx1, yy1] = meshgrid(mg21, mg11);
  [xx2, yy2] = meshgrid(mg22, mg12);
  
  r_fh = figure();
  subplot(2, 1, 1);
  title(ptit1);
  xlabel(xlbl1);
  ylabel(ylbl1);
  zlabel(zlbl1);
  surf(xx1, yy1, ms1, 'linestyle', 'none', 'facecolor', 'interp');
  subplot(2, 1, 2);
  title(ptit2);
  xlabel(xlbl2);
  ylabel(ylbl2);
  zlabel(zlbl2);
  surf(xx2, yy2, ms2, 'linestyle', 'none', 'facecolor', 'interp');
  
endfunction

################################################################################
## helper function: plot c/s-wave
function [r_fh] = hlp_plot1(p_ms, p_ts, p_mat, p_i0, p_cn, p_sts, p_stm, p_xam, p_yam, p_xmin, p_ymin, p_xmax, p_ymax)
  
  ## number of samples
  nsmp = size(p_ms.v, 1);
  
  ## number of signals
  nsig = size(p_ms.v, 2);
  
  xmin = max([p_xmin, 1]);
  ymin = max([p_ymin, 1]);
  xmax = min([p_xmax, nsmp]);
  ymax = min([p_ymax, nsig]);
  
  ## prepare data
  dim_t = xmin : p_sts : xmax; # subset index of sample time
  dim_m = ymin : p_stm : ymax; # subset index of signal maturity
  ms = p_ms.v(dim_t, dim_m);
  ts = p_ts.v(dim_t);
  mat = p_mat.v(dim_m);
  
  ## get labels
  p_zam = 1;
  [ptit, xlbl, ylbl, zlbl] = hlp_get_labels(p_cn, p_xam, p_yam, p_zam);
  
  ## switch x axis mode
  switch (p_xam)
    case 2 # time in usec
      mg1 = ts / 10;
    case 3 # time in msec
      mg1 = ts / 10000;
    otherwise # sample index
      mg1 = linspace(1, nsmp, nsmp)(dim_t);
  endswitch
  
  ## switch y axis mode
  switch (p_yam)
    case 2 # maturity in min
      mg2 = mat / 60;
    case 3 # maturity in h
      mg2 = mat / 3600;
    otherwise # maturity index
      mg2 = linspace(1, nsig, nsig)(dim_m);
  endswitch
  
  ## switch z axis mode
  switch (p_zam)
    case 2 # magnitude in mV
      ms = ms * 1000;
    otherwise # magnitude in V
      1;
  endswitch
  
  [xx, yy] = meshgrid(mg2, mg1);
  
  r_fh = figure();
  title(ptit);
  xlabel(xlbl);
  ylabel(ylbl);
  zlabel(zlbl);
  surf(xx, yy, ms, 'linestyle', 'none', 'facecolor', 'interp');
  
endfunction

############################################################################################################################################
## Helper function: get labels
## p_cn ... channel number, <uint>
## p_mx ... x axis mode, <uint>
## p_my ... y axis mode, <uint>
## r_ti ... return: plot title, <str>
## r_xl ... return: x axis label, sample time/index, <str>
## r_yl ... return: y axis label, maturity time/index, <str>
## r_zl ... return: z axis label, magnitude/voltage, <str>
function [r_ti, r_xl, r_yl, r_zl] = hlp_get_labels(p_cn, p_mx, p_my, p_mz)
  
  ## switch channel number
  switch (p_cn)
    case 1 # c-wave
      r_ti = 'C-wave';
    case 2 # c-wave
      r_ti = 'S-wave';
  endswitch
  
  ## switch x axis mode
  switch (p_mx)
    case 2 # time in usec
      r_xl = 'Time [usec]';
    case 3 # time in msec
      r_xl = 'Time [msec]';
    otherwise # sample index
      r_xl = 'Sample [#]';
  endswitch
  
  ## switch y axis mode
  switch (p_my)
    case 2 # maturity in min
      r_yl = 'Maturity [min]';
    case 3 # maturity in h
      r_yl = 'Maturity [h]';
    otherwise # maturity index
      r_yl = 'Maturity [#]';
  endswitch
  
  ## switch z axis mode
  switch (p_mz)
    case 2 # magnitude in mV
      r_zl = 'Magnitude [mV]';
    otherwise # magnitude in V
      r_zl = 'Magnitude [V]';
  endswitch
  
endfunction
