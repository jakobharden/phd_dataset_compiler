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
## Plot UPV data (compression and shear wave) as 2D-plot
##
## Usage: [r_fh] = struct_plot_2d(p_src, p_sidx, p_mod, p_xam, p_yam, p_imin, p_imax)
##
## p_src  ... data set data structure or full qualified path to data structure file, <struct>
## p_sidx ... signal index, <uint>
## p_mod  ... plot mode, <int>
##              p_mod = 0: plot compression and shear wave, side-by-side in one window
##              p_mod = 1: plot compression wave
##              p_mod = 2: plot shear wave
## p_xam  ... x axis mode, time series mode, <uint>
##              p_xam = 0: sample index
##              p_xam = 1: sample time in sec
##              p_xam = 2: sample time in usec (1e-6 sec)
##              p_xam = 3: sample time in msec (1e-3 sec)
## p_yam  ... y axis mode, magnitude series mode, <uint>
##              p_yam = 0: magnitude in V
##              p_yam = 1: magnitude in mV (1e-3 Volts)
## p_imin ... min. sample index, <uint>
## p_imax ... max. sample index, <uint>
##
## see also: fio_struct_load, struct_exp_data
##
function [r_fh] = struct_plot_2d(p_src, p_sidx, p_mod, p_xam, p_yam, p_imin, p_imax)
  
  if (nargin < 2)
    help struct_plot_2d;
    error('Less arguments given!');
  endif
  if (nargin < 3)
    p_mod = 0;
  endif
  if (nargin < 4)
    p_xam = 0;
  endif
  if (nargin < 5)
    p_yam = 0;
  endif
  if (nargin < 6)
    p_imin = 1;
  endif
  if (nargin < 7)
    p_imax = 1000000;
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
      r_fh = hlp_plot1(ms1, ts1, 1, p_sidx, p_xam, p_yam, p_imin, p_imax);
    case 2
      ## channel 2, shear wave
      ms2 = struct_exp_data(ds, 'tst.utt2.ms');
      ts2 = struct_exp_data(ds, 'tst.utt2.ts');
      i02 = struct_exp_data(ds, 'tst.utt2.i0');
      t02 = struct_exp_data(ds, 'tst.utt2.t0');
      mat2 = struct_exp_data(ds, 'tst.utt2.mat');
      matt02 = mat2;
      matt02.v = mat2.v + t02.v;
      r_fh = hlp_plot1(ms2, ts2, 2, p_sidx, p_xam, p_yam, p_imin, p_imax);
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
      switch (p_mod)
        case 3
          ## both channels, vertically stacked
          r_fh = hlp_plot2(ms1, ms2, ts1, ts2, p_sidx, p_xam, p_yam, p_imin, p_imax);
        case 4
          ## both channels, overlay
          r_fh = hlp_plot3(ms1, ms2, ts1, ts2, p_sidx, p_xam, p_yam, p_imin, p_imax);
      endswitch
  endswitch
  
endfunction

################################################################################
## helper function: plot c/s-wave, overlay
function [r_fh] = hlp_plot3(p_ms1, p_ms2, p_ts1, p_ts2, p_sidx, p_xam, p_yam, p_imin, p_imax)
  
  ## number of samples
  nsmp = size(p_ms1.v, 1);
  
  xmin = max([p_imin, 1]);
  xmax = min([p_imax, nsmp]);
  
  ## prepare data
  ms1 = p_ms1.v(:, p_sidx);
  ms2 = p_ms2.v(:, p_sidx);
  ts1 = p_ts1.v;
  ts2 = p_ts2.v;
  
  ## get labels
  [ptit1, xlbl, ylbl, leg1] = hlp_get_labels(1, p_sidx, p_xam, p_yam);
  [ptit2, xlbl, ylbl, leg2] = hlp_get_labels(2, p_sidx, p_xam, p_yam);
  
  ## switch x axis mode
  switch (p_xam)
    case 1 # time in sec
      xx1 = ts1;
      xx2 = ts2;
    case 2 # time in usec
      xx1 = ts1 / 10;
      xx2 = ts2 / 10;
    case 3 # time in msec
      xx1 = ts1 / 10000;
      xx2 = ts2 / 10000;
    otherwise # sample index
      xx1 = linspace(1, nsmp, nsmp);
      xx2 = xx1;
  endswitch
  
  ## switch y axis mode
  switch (p_yam)
    case 1 # magnitude in mV
      ms1 = ms1 * 1000;
      ms2 = ms2 * 1000;
    otherwise # magnitude in V
      1;
  endswitch
  
  r_fh = figure();
  hold on;
  title(sprintf('%s; %s', ptit1, ptit2));
  xlabel(xlbl);
  ylabel(ylbl);
  plot(xx1, ms1, leg1);
  plot(xx2, ms2, leg2);
  hold off;
  
endfunction

################################################################################
## helper function: plot c/s-wave, vertically stacked
function [r_fh] = hlp_plot2(p_ms1, p_ms2, p_ts1, p_ts2, p_sidx, p_xam, p_yam, p_imin, p_imax)
  
  ## number of samples
  nsmp = size(p_ms1.v, 1);
  
  xmin = max([p_imin, 1]);
  xmax = min([p_imax, nsmp]);
  
  ## prepare data
  ms1 = p_ms1.v(:, p_sidx);
  ms2 = p_ms2.v(:, p_sidx);
  ts1 = p_ts1.v;
  ts2 = p_ts2.v;
  
  ## get labels
  [ptit1, xlbl1, ylbl1, leg1] = hlp_get_labels(1, p_sidx, p_xam, p_yam);
  [ptit2, xlbl2, ylbl2, leg2] = hlp_get_labels(2, p_sidx, p_xam, p_yam);
  
  ## switch x axis mode
  switch (p_xam)
    case 1 # time in sec
      xx1 = ts1;
      xx2 = ts2;
    case 2 # time in usec
      xx1 = ts1 / 10;
      xx2 = ts2 / 10;
    case 3 # time in msec
      xx1 = ts1 / 10000;
      xx2 = ts2 / 10000;
    otherwise # sample index
      xx1 = linspace(1, nsmp, nsmp);
      xx2 = xx1;
  endswitch
  
  ## switch y axis mode
  switch (p_yam)
    case 1 # magnitude in mV
      ms1 = ms1 * 1000;
      ms2 = ms2 * 1000;
    otherwise # magnitude in V
      1;
  endswitch
  
  r_fh = figure();
  subplot(2, 1, 1);
  title(ptit1);
  xlabel(xlbl1);
  ylabel(ylbl1);
  plot(xx1, ms1, leg1);
  subplot(2, 1, 2);
  title(ptit2);
  xlabel(xlbl2);
  ylabel(ylbl2);
  plot(xx2, ms2, leg2);
  
endfunction

################################################################################
## helper function: plot c/s-wave
function [r_fh] = hlp_plot1(p_ms, p_ts, p_cn, p_sidx, p_xam, p_yam, p_imin, p_imax)
  
  ## number of samples
  nsmp = size(p_ms.v, 1);
  
  xmin = max([p_imin, 1]);
  xmax = min([p_imax, nsmp]);
  
  ## prepare data
  ms = p_ms.v(:, p_sidx);
  ts = p_ts.v;
  
  ## get labels
  [ptit, xlbl, ylbl, leg] = hlp_get_labels(p_cn, p_sidx, p_xam, p_yam);
  
  ## switch x axis mode
  switch (p_xam)
    case 1 # time in sec
      xx = ts;
    case 2 # time in usec
      xx = ts / 10;
    case 3 # time in msec
      xx = ts / 10000;
    otherwise # sample index
      xx = linspace(1, nsmp, nsmp);
  endswitch
  
  ## switch y axis mode
  switch (p_yam)
    case 1 # magnitude in mV
      ms = ms * 1000;
    otherwise # magnitude in V
      1;
  endswitch
  
  r_fh = figure();
  title(ptit);
  xlabel(xlbl);
  ylabel(ylbl);
  plot(xx, ms, leg);
  
endfunction

############################################################################################################################################
## Helper function: get labels
## p_cn   ... channel number, <uint>
## p_sidx ... signal index, <uint>
## p_xam  ... x axis mode, <uint>
## p_yam  ... y axis mode, <uint>
## r_ti   ... return: plot title, <str>
## r_xl   ... return: x axis label, sample time/index, <str>
## r_yl   ... return: y axis label, maturity time/index, <str>
## r_leg  ... return: legend, line format, line color, <str>
function [r_ti, r_xl, r_yl, r_leg] = hlp_get_labels(p_cn, p_sidx, p_xam, p_yam)
  
  ## switch channel number
  switch (p_cn)
    case 1 # c-wave
      tp = 'C-wave';
      lsty = '-r';
    case 2 # c-wave
      tp = 'S-wave';
      lsty = '-b';
  endswitch
  r_ti = sprintf('Signal: %s %d', tp, p_sidx);
  r_leg = sprintf('%s;%s %d;', lsty, tp, p_sidx);
  
  ## switch x axis mode
  switch (p_xam)
    case 1 # time in sec
      r_xl = 'Time [sec]';
    case 2 # time in usec
      r_xl = 'Time [usec]';
    case 3 # time in msec
      r_xl = 'Time [msec]';
    otherwise # sample index
      r_xl = 'Sample [#]';
  endswitch
  
  ## switch y axis mode
  switch (p_yam)
    case 1 # magnitude in mV
      r_yl = 'Magnitude [mV]';
    otherwise # magnitude in V
      r_yl = 'Magnitude [V]';
  endswitch
  
endfunction
