## Extract structure of dataset (GNU octave binary) as text
##
## Usage: [r_sl] = struct_exp_structure(p_fp, p_mo)
##
## p_fp  ... file path to data structure or data structure, <str> or <struct>
## p_mo  ... mode, <str>
##             'tagonly' ... print tag only (default)
##             'all'     ... print all contents
##
## see also: struct_import
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
function [r_sl] = struct_exp_structure(p_fp, p_mo)
  
  ## check arguments
  if (nargin < 1)
    p_fp = [];
  endif
  if (nargin < 2)
    p_mo = 'tagonly';
  endif
  
  ## get input file path (if not available)
  if isempty(p_fp)
    [fn, fp, fi] = uigetfile('*.oct', 'Load data structure', '/mnt/data/0_test_series/ts1_cem1_paste/oct');
    p_fp = fullfile(fp, fn);
  endif
  
  ## load data structure
  ds = fio_struct_load(p_fp);
  
  ## extract structure
  [r_sl] = hlp_extract(ds, p_mo);
  
  ## save TeX file
  ofp = sprintf('%s.tex', p_fp);
  hlp_tex_struct(r_sl, ofp);
  
endfunction

###############################################################################
function [r_sl] = hlp_extract(p_ds, p_mo)
  
  ## level 1
  ds1 = p_ds;
  [r_sl, ds1, e1] = hlp_coll_struct([], ds1, '', '', '');
  fl1 = fieldnames(ds1);
  for i = 1 : max(size(fl1))
    fn1 = fl1{i};
    switch (fn1)
      case {'obj', 'ver'}
        continue;
    endswitch
    ## level 2
    ds2 = getfield(ds1, fn1);
    [r_sl, ds2, e1] = hlp_coll_struct(r_sl, ds2, fn1, '', '');
    if e1
      continue;
    endif
    fl2 = fieldnames(ds2);
    for ii = 1 : max(size(fl2))
      fn2 = fl2{ii};
      switch (fn2)
        case {'obj', 'ver'}
          continue;
      endswitch
      ds3 = getfield(ds2, fn2);
      [r_sl, ds3, e1] = hlp_coll_struct(r_sl, ds3, fn1, fn2, '');
      if e1
        continue;
      endif
      ## level 3, only for tests
      if strcmpi(fn1, 'tst')
        fl3 = fieldnames(ds3);
        for iii = 1 : max(size(fl3))
          fn3 = fl3{iii};
          switch (fn3)
            case {'obj', 'ver'}
              continue;
          endswitch
          ds4 = getfield(ds3, fn3);
          [r_sl, ds4, e1] = hlp_coll_struct(r_sl, ds4, fn1, fn2, fn3);
          if e1
            continue;
          endif
        endfor
      endif
    endfor
  endfor
  
  hlp_print_struct(r_sl);
  
endfunction

############################################################################################################################################
## Helper function: collect structure information
## p_sl ... 
function [r_sl, r_ds, r_e1] = hlp_coll_struct(p_sl, p_ds, p_sl1, p_sl2, p_sl3)
  
  ## set error flag 1
  r_e1 = false;
  
  ## check whether data structure is empty or not
  if isempty(p_ds)
    r_sl = p_sl;
    r_ds = [];
    r_e1 = true;
    return;
  endif
  
  ## make structure a scalar structure
  sz_arr = max(size(p_ds));
  if (sz_arr > 1)
    r_ds = p_ds(1);
    is_arr = true;
  else
    r_ds = p_ds;
    is_arr = false;
  endif
  
  ## check structure object type and version
  if isfield(p_ds, 'obj')
    obj = r_ds.obj;
  else
    obj = '';
  endif
  if isfield(p_ds, 'ver')
    ver = r_ds.ver;
  else
    ver = [];
  endif
  
  ## check, whether structure is an atmic data structure
  switch (obj)
    case 'AAE'
      ## atomic attribute element
      if is_arr
        atag = 'attribute_array';
        avtp = 'array';
        auni = '';
        ades = sprintf('array contains %d elements', sz_arr);
      else
        atag = r_ds.t;
        avtp = '';
        auni = '';
        ades = r_ds.d;
      endif
    case 'ARE'
      ## atomic reference element
      if is_arr
        atag = 'reference_array';
        avtp = 'array';
        auni = '';
        ades = sprintf('array contains %d elements', sz_arr);
      else
        atag = r_ds.t;
        avtp = '';
        auni = '';
        ades = r_ds.d;
      endif
    case 'ADE'
      ## atomic data element
      if is_arr
        atag = 'data_array';
        avtp = sprintf('array(%s)', r_ds.vt);
        auni = p_ds(1).u;
        ades = sprintf('array contains %d elements', sz_arr);
      else
        atag = r_ds.t;
        avtp = r_ds.vt;
        auni = r_ds.u;
        ades = r_ds.d;
      endif
    otherwise
      if is_arr
        atag = '';
        avtp = 'node_array';
        auni = '';
        ades = sprintf('array contains %d elements', sz_arr);
      else
        atag = '';
        avtp = 'node';
        auni = '';
        ades = 'structure node';
      endif
  endswitch
  
  ## create information structure
  ds.sl0 = 'ds';
  ds.sl1 = p_sl1;
  ds.sl2 = p_sl2;
  ds.sl3 = p_sl3;
  ds.obj = obj;
  ds.ver = ver;
  ds.at = atag;
  ds.av = avtp;
  ds.au = auni;
  ds.ad = ades;
  
  if isempty(p_sl)
    r_sl = ds;
  else
    r_sl = [p_sl, ds];
  endif
  
endfunction

############################################################################################################################################
## Helper function: print dataset structure on screen
## p_sl ... structure information listing
function hlp_print_struct(p_sl)
  
  for i = 1 : size(p_sl, 2)
    sli = p_sl(i);
    spath = hlp_struct_path(sli.sl0, sli.sl1, sli.sl2, sli.sl3);
    if isempty(sli.at)
      at = '';
    else
      at = sprintf(' TAG(%s)', sli.at);
    endif
    if isempty(sli.av)
      av = '';
    else
      av = sprintf(' VALUETYPE(%s)', sli.av);
    endif
    if isempty(sli.au)
      au = '';
    else
      au = sprintf(' UNIT(%s)', sli.au);
    endif
    printf('%s OBJ(%s) VER(%d, %d)%s%s%s DESCR(%s)\n', spath, sli.obj, sli.ver(1), sli.ver(2), at, av, au, sli.ad);
  endfor
  
endfunction

############################################################################################################################################
## Helper function: get structure path
## p_sl0 ... name of structure level 0 (structure root), <str>
## p_sl1 ... name of structure level 1, <str>
## p_sl2 ... name of structure level 2, <str>
## p_sl3 ... name of structure level 3, <str>
## r_sp  ... return: dotted structure path, <str>
function [r_sp] = hlp_struct_path(p_sl0, p_sl1, p_sl2, p_sl3)
  
  if isempty(p_sl0)
    r_sp = '';
  else
    if isempty(p_sl1)
      r_sp = p_sl0;
    else
      if isempty(p_sl2)
        r_sp = sprintf('%s.%s', p_sl0, p_sl1);
      else
        if isempty(p_sl3)
          r_sp = sprintf('%s.%s.%s', p_sl0, p_sl1, p_sl2);
        else
          r_sp = sprintf('%s.%s.%s.%s', p_sl0, p_sl1, p_sl2, p_sl3);
        endif
      endif
    endif
  endif
  
endfunction

############################################################################################################################################
## Helper function: save data structure to TeX file
## p_sl ... structure information listing, <struct>
## p_of ... output file path, <str>
function hlp_tex_struct(p_sl, p_of)
  
  #colhead = 'Path & Object & Version & Tag & Type & Unit & Description';
  colhead = 'Path & Object & Tag & Description';
  
  tlst = {};
  for i = 1 : size(p_sl, 2)
    sli = p_sl(i);
    spath = hlp_tex_save_str(hlp_struct_path(sli.sl0, sli.sl1, sli.sl2, sli.sl3));
    if isempty(sli.at)
      at = '\textemdash';
    else
      at = hlp_tex_save_str(sli.at);
    endif
    if isempty(sli.av)
      av = '\textemdash';
    else
      av = hlp_tex_save_str(sli.av);
    endif
    if isempty(sli.au)
      au = '\textemdash';
    else
      au = hlp_tex_save_str(sli.au, 'unit');
    endif
    if isempty(sli.ad)
      ad = '\textemdash';
    else
      ad = hlp_tex_save_str(sli.ad);
    endif
    objstr = hlp_tex_save_str(sli.obj);
    verstr = sprintf('%d.%d', sli.ver(1), sli.ver(2));
    %tlst = [tlst, sprintf('%s & %s & %s & %s & %s & %s & %s\\\\', spath, objstr, verstr, at, av, au, ad)];
    tlst = [tlst, sprintf('%s & %s & %s & %s\\\\', spath, objstr, at, ad)];
  endfor
  
  fid = fopen(p_of, 'w');
  for i = 1 : size(tlst, 2)
    fprintf(fid, '%s\n', tlst{i});
  endfor
  fclose(fid);
  
endfunction

function [r_tex] = hlp_tex_save_str(p_str, p_mod)
  
  if (nargin < 2)
    p_mod = 'std';
  endif
  
  if strcmpi(p_mod, 'unit')
    r_tex = ['$', p_str, '$'];
  else
    r_tex = strrep(p_str, '_', '\_');
  endif
  
endfunction
