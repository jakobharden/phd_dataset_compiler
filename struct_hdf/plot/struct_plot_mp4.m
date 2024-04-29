## Plot ultrasonic measurement data (compression and shear wave) to MP4 video file
##
## Usage: [r_ofp] = struct_plot_mp4(p_dat, p_mod, p_prp)
##
## p_dat ... main data structure (from struct_import), <struct>
## p_mod ... plot mode, <int>
##             p_mod = 0: plot compression and shear wave to one output file, single graph
##             p_mod = 1: plot compression and shear wave to one output file, dual graph
##             p_mod = 10: plot compression wave only
##             p_mod = 20: plot shear wave only
##             p_mod = 30: plot compression and shear wave to separate output files
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
function [r_ofp] = struct_plot_mp4(p_dat, p_mod, p_prp)
  
  if (nargin < 1)
    help struct_plot_mp4;
    error('Less arguments given!');
  endif
  if (nargin < 2)
    p_mod = 0;
  endif
  if (nargin < 3)
    p_prp = hlp_plot_prop_default();
  endif
  
  ## plot to MP4 file by given mode
  switch (p_mod)
    case 0
      r_ofp = './upv_cs_combine.mp4';
      hlp_plot0(r_ofp, p_prp, p_dat.tst.s06.f25.v, p_dat.tst.s07.f25.v);
    case 1
      r_ofp = './upv_cs_separate.mp4';
      hlp_plot1(r_ofp, p_prp, p_dat.tst.s06.f25.v, p_dat.tst.s07.f25.v);
    case 10
      r_ofp = './upv_c.mp4';
      hlp_plot2(r_ofp, p_prp, 1, p_dat.tst.s06.f25.v);
    case 20
      r_ofp = './upv_s.mp4';
      hlp_plot2(r_ofp, p_prp, 2, p_dat.tst.s07.f25.v);
    case 30
      r_ofp = './upv_c.mp4';
      hlp_plot2(r_ofp, p_prp, 1, p_dat.tst.s06.f25.v);
      r_ofp = './upv_s.mp4';
      hlp_plot2(r_ofp, p_prp, 2, p_dat.tst.s07.f25.v);
    otherwise
      r_ofp = './upv_cs0.mp4';
      hlp_plot0(r_ofp, p_prp, p_dat.tst.s06.f25.v, p_dat.tst.s07.f25.v);
  endswitch
  
endfunction

################################################################################
function [r_tdp] = hlp_create_tempdir()
  
  ## create temporary directory path (octave temp ramdisk)
  r_tdp = '/mnt/octave_temp/plotupv_mp4';
  mkdir(r_tdp);
  
endfunction

################################################################################
function [r_prp] = hlp_plot_prop_default()
  
  r_prp.fwidth = 800;
  r_prp.fheight = 600;
  r_prp.frate = 5;
  r_prp.lcol_ch1 = [1, 0, 0]; # red
  r_prp.lcol_ch2 = [0, 0, 1]; # blue
  r_prp.bcol_ch1 = [1, 1, 1]; # white
  r_prp.bcol_ch2 = [1, 1, 1]; # white
  r_prp.lwid_ch1 = 0.5;
  r_prp.lwid_ch2 = 0.5;
  r_prp.ylim_ch1 = [-10, 10];
  r_prp.ylim_ch2 = [-10, 10];
  r_prp.xlim_ch1 = [10, 1000000; 24, 10000; 36, 5000; 80, 3500; 120, 2000];
  r_prp.xlim_ch2 = [30, 1000000; 50, 30000; 90, 7000; 120, 3500; 150, 2000];
  r_prp.xlbl = 'sample index [#]';
  r_prp.ylbl = 'voltage [V]';
  
endfunction

################################################################################
function [r_fh] = hlp_create_figure(p_prp)
  
  r_fh = figure(...
    'visible', 'off', ...
    'menubar', 'none', ...
    'position', [100, 100, p_prp.fwidth, p_prp.fheight]);
  
endfunction

################################################################################
function [r_ah] = hlp_create_axes(p_prp, p_chn, p_sub)
  
  ## get bg color
  switch (p_chn)
    case 1
      bcol = p_prp.bcol_ch1;
    case 2
      bcol = p_prp.bcol_ch2;
    otherwise
      bcol = p_prp.bcol_ch1;
  endswitch
  
  ## check whether subplot is requested or not
  if p_sub
    r_ah = subplot(2, 1, p_chn);
    set(r_ah, 'color', bcol);
    set(r_ah, 'xlabel', p_prp.xlbl);
    set(r_ah, 'ylabel', p_prp.ylbl);
  else
    r_ah = axes('color', bcol);
    set(r_ah, 'xlabel', p_prp.xlbl);
    set(r_ah, 'ylabel', p_prp.ylbl);
  endif
  
endfunction

################################################################################
function [r_ph] = hlp_create_plot(p_prp, p_chn, p_ah, p_xx, p_yy)
  
  ## get line properties
  switch (p_chn)
    case 1
      lcol = p_prp.lcol_ch1;
      lwid = p_prp.lwid_ch1;
    case 2
      lcol = p_prp.lcol_ch2;
      lwid = p_prp.lwid_ch2;
    otherwise
      lcol = p_prp.lcol_ch1;
      lwid = p_prp.lwid_ch1;
  endswitch
  
  if isempty(p_xx)
    r_ph = plot(p_ah, p_yy, 'linewidth', lwid, 'color', lcol);
  else
    r_ph = plot(p_ah, p_xx, p_yy, 'linewidth', lwid, 'color', lcol);
  endif
  
endfunction

################################################################################
function hlp_update_plot(p_ph, p_xx, p_yy)
  
  if isempty(p_xx)
    set(p_ph, 'ydata', p_yy);
  else
    set(p_ph, 'xdata', p_xx);
    set(p_ph, 'ydata', p_yy);
  endif
  
endfunction

################################################################################
function hlp_create_mp4(p_prp, p_tdp, p_ofp)
  
  ## get system command (ffmpeg)
  cmd1 = 'ffmpeg';
  cmd2 = sprintf('-r %d', p_prp.frate);
  cmd3 = sprintf('-i %s/img%%03d.png', p_tdp);
  cmd4 = sprintf('-vcodec %s', 'libx264');
  cmd5 = sprintf('-vf scale=%d:-1', p_prp.fwidth);
  cmd6 = sprintf('%s', p_ofp);
  cmd = cstrcat(cmd1, ' ', cmd2, ' ', cmd3, ' ', cmd4, ' ', cmd5, ' ', cmd6);
  
  ## run system command (create mp4 file)
  system(cmd);
  
  ## remove temporary directory path from octave temp ramdisk
  delete(fullfile(p_tdp, 'img*.png'));
  rmdir(p_tdp);
  
endfunction

################################################################################
function [r_lim] = hlp_ylim(p_v1, p_v2)
  
  if (nargin < 2)
    vmax = max(abs(p_v1));
  else
    vmax1 = max(abs(p_v1));
    vmax2 = max(abs(p_v2));
    vmax = max([vmax1, vmax2]);
  endif
  
  r_lim = [-vmax, vmax];
  
endfunction

################################################################################
function [r_lim] = hlp_xlim(p_prp, p_chn, p_idx, p_maxns)
  
  switch (p_chn)
    case 1
      vlim = p_prp.xlim_ch1;
    case 2
      vlim = p_prp.xlim_ch2;
    otherwise
      vlim = p_prp.xlim_ch2;
  endswitch
  
  for i = 1 : size(vlim, 1)
    ns = min([vlim(i, 2), p_maxns]);
    r_lim = [900, ns];
    if (vlim(i, 1) > p_idx)
      break;
    endif
  endfor
  
endfunction

################################################################################
## helper function: plot mode 0, c+s, one graph
function hlp_plot0(p_ofp, p_prp, p_d1, p_d2)
  
  ## number of samples
  nsmp = size(p_d1, 1);
  
  ## number of signals
  nsig = size(p_d1, 2);
  
  ## create temporary directory in octave temp ramdisk
  tmpdir = hlp_create_tempdir();
  
  ## create figure
  fh = hlp_create_figure(p_prp);
  
  ## create axes
  ah = hlp_create_axes(p_prp, 0, false);
  for i = 1 : nsig
    yy1 = p_d1(:, i);
    yy2 = p_d2(:, i);
    if (i == 1)
      hold on;
      ph1 = hlp_create_plot(p_prp, 1, ah, [], yy1);
      ph2 = hlp_create_plot(p_prp, 2, ah, [], yy2);
      hold off;
      ylim(hlp_ylim(yy1, yy2));
      xlim(ah, hlp_xlim(p_prp, 0, i, nsmp));
      title(sprintf('Maturity: %d [min]', (i-1)*5));
    else
      hlp_update_plot(ph1, [], yy1);
      hlp_update_plot(ph2, [], yy2);
      ylim(ah, hlp_ylim(yy1, yy2));
      xlim(ah, hlp_xlim(p_prp, 0, i, nsmp));
      title(sprintf('Maturity: %d [min]', (i-1)*5));
    endif
    # write image
    tmp_fn = fullfile(tmpdir, sprintf('img%03d.png', i - 1));
    imwrite(getframe(fh).cdata, tmp_fn);
  endfor
  
  # close figure
  close(fh);
  
  # create MP4 file from images
  hlp_create_mp4(p_prp, tmpdir, p_ofp);
  
endfunction

################################################################################
## helper function: plot mode 0, c+s, separate graphs
function hlp_plot1(p_ofp, p_prp, p_d1, p_d2)
  
  ## number of samples
  nsmp = size(p_d1, 1);
  
  ## number of signals
  nsig = size(p_d1, 2);
  
  ## create temporary directory in octave temp ramdisk
  tmpdir = hlp_create_tempdir();
  
  # create figure
  fh = hlp_create_figure(p_prp);
  
  # plot data
  for i = 1 : nsig
    yy1 = p_d1(:, i);
    yy2 = p_d2(:, i);
    if (i == 1)
      hold on;
      ah1 = hlp_create_axes(p_prp, 1, true);
      ph1 = hlp_create_plot(p_prp, 1, ah1, [], yy1);
      ah2 = hlp_create_axes(p_prp, 2, true);
      ph2 = hlp_create_plot(p_prp, 2, ah2, [], yy2);
      hold off;
      ylim(ah1, hlp_ylim(yy1));
      ylim(ah2, hlp_ylim(yy2));
      xlim(ah1, hlp_xlim(p_prp, 1, i, nsmp));
      xlim(ah2, hlp_xlim(p_prp, 2, i, nsmp));
      title(sprintf('Maturity: %d [min]', (i-1)*5));
    else
      hlp_update_plot(ph1, [], yy1);
      hlp_update_plot(ph2, [], yy2);
      ylim(ah1, hlp_ylim(yy1));
      ylim(ah2, hlp_ylim(yy2));
      xlim(ah1, hlp_xlim(p_prp, 1, i, nsmp));
      xlim(ah2, hlp_xlim(p_prp, 2, i, nsmp));
      title(sprintf('Maturity: %d [min]', (i-1)*5));
    endif
    # write image
    tmp_fn = fullfile(tmpdir, sprintf('img%03d.png', i - 1));
    imwrite(getframe(fh).cdata, tmp_fn);
  endfor
  
  # close figure
  close(fh);
  
  # create MP4 file from images
  hlp_create_mp4(p_prp, tmpdir, p_ofp);
  
endfunction

################################################################################
## helper function: plot mode 2, compression or shear wave only
function hlp_plot2(p_ofp, p_prp, p_chn, p_dat)
  
  ## number of samples
  nsmp = size(p_dat, 1);
  
  ## number of signals
  nsig = size(p_dat, 2);
  
  ## create temporary directory in octave temp ramdisk
  tmpdir = hlp_create_tempdir();
  
  ## create figure
  fh = hlp_create_figure(p_prp);
  
  ## create axes
  ah = hlp_create_axes(p_prp, p_chn, false);
  for i = 1 : nsig
    yy = p_dat(:, i);
    if (i == 1)
      hold on;
      ph = hlp_create_plot(p_prp, p_chn, ah, [], yy);
      hold off;
      ylim(hlp_ylim(yy));
      if (p_chn == 1)
        xlim(hlp_xlim(p_prp, 1, i, nsmp));
      else
        xlim(hlp_xlim(p_prp, 2, i, nsmp));
      endif
      title(sprintf('Maturity: %d [min]', (i-1)*5));
    else
      hlp_update_plot(ph, [], yy);
      ylim(ah, hlp_ylim(yy));
      if (p_chn == 1)
        xlim(hlp_xlim(p_prp, 1, i, nsmp));
      else
        xlim(hlp_xlim(p_prp, 2, i, nsmp));
      endif
      title(sprintf('Maturity: %d [min]', (i-1)*5));
    endif
    # write image
    tmp_fn = fullfile(tmpdir, sprintf('img%03d.png', i - 1));
    imwrite(getframe(fh).cdata, tmp_fn);
  endfor
  
  # close figure
  close(fh);
  
  # create MP4 file from images
  hlp_create_mp4(p_prp, tmpdir, p_ofp);
  
endfunction
