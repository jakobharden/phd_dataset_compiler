## Write project information file
##
## Usage 1: fio_projinfo_write(p_tp)
##   Write empty template file to working directory
##
## Usage 2: fio_projinfo_write(p_tp, p_dp)
##   Interactive input of project parameters
##   Write file to project directory
##
## Usage 3: fio_projinfo_write(p_tp, p_dp, p_fp)
##   CSV file input of project parameters
##   Write project information files to all project directories in given directory
##
## File name: output file name is always 'projinfo.txt'
## File location: in the folder where the upv channel directories are
## File format:
##   a) lines starting with '##' are comment lines
##   b) double-quote strings
##   c) line format: [type] <tag> = <value>
##                   recognized types: bool, uint, int, sng, dbl, str
##
## p_tp ... project info file type, <str>
##          "paste":        paste test
##          "ref_air":      reference test, air
##          "ref_water":    reference test, water
##          "ref_alucyl":   reference test, aluminium cylinder
##          "ref_fs110khz": reference test, shear wave sensors with resonance frequency fs = 110 kHz
## p_dp ... project directory path, full qualified, <str>
## p_fp ... project parameter list file path, full qualified (CSV file), <str>
##
## see also: struct_import
##.
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
function fio_projinfo_write(p_tp, p_dp, p_fp)
  
  ## read static information from global variable
  global wavupv_db_static
  ## read recipe information from global variable
  global wavupv_db_rec
  
  ## get parameter list
  switch (p_tp)
    case 'paste'
      pl = wavupv_db_static.pinfo_parmset1;
    case 'ref_alucyl'
      pl = wavupv_db_static.pinfo_parmset2;
   case {'ref_air', 'ref_water', 'ref_fs110khz'}
      pl = wavupv_db_static.pinfo_parmset3;
    otherwise
      error('Unknown parameter list type! type = %s', p_tp);
  endswitch
  
  ## check usage
  if (nargin == 0) # no input, write template file
    help fio_projinfo_write;
    error('Less arguments given!');
  elseif (nargin == 1) # interactive input
    ds = [];
    p_dp = './';
  elseif (nargin == 2) # interactive input
    hlp_write_intact(p_dp, pl);
  elseif (nargin == 3) # csv list input
    if isempty(p_dp)
      p_dp = uigetdir('/mnt/data/0_test_series');
    endif
    if isempty(p_fp)
      [fn, fp, fe] = uigetfile('*.csv');
      p_fp = fullfile(fp, fn);
    endif
    hlp_write_csv(p_dp, p_fp, pl);
  else
    help fio_projinfo_write;
    error('Unknown function usage mode!');
  endif
  
endfunction
  
############################################################################################################################################
## Helper function: interactively parse project parameters
## p_dp ... project directory path, full qualified, <str>
## p_pl ... parameter list, {{<str>}}, see struct_make_static.m for details
function hlp_write_intact(p_dp, p_pl)
  
  ## flush console window
  fflush(stdout);
  
  ## init return value
  ds = [];
  
  ## extract project name
  [fp, fn, fe] = fileparts(p_dp);
  
  ## parse user input
  sz = size(p_pl, 1);
  for i = 1 : sz
    tmphnt = p_pl{i, 1};
    tmpfld = p_pl{i, 2};
    tmptype = p_pl{i, 3};
    tmpdef = p_pl{i, 4};
    tmpitp = p_pl{i, 7};
    if (isempty(tmpfld)) # display headline
      disp(tmphnt);
    else # request user input
      tmpval = hlp_intact_param(tmphnt, tmptype, tmpfld, tmpdef, tmpitp);
      ds = setfield(ds, tmpfld, tmpval);
    endif
  endfor
  
  ## output file path
  ofp = fullfile(p_dp, 'projinfo.txt');
  
  ## open file for writing
  fid = fopen(ofp, "w");
  
  ## check if file is open
  if (isempty(fid) || (fid < 1))
    error("Cannot open project information file for writing!\n  path = %s", ofp);
  endif
  
  ## write datastructure to file
  hlp_write(fid, pl, ds);
  
  ## close file
  fclose(fid);
  
endfunction

############################################################################################################################################
## Helper function: interactively parse one project parameter
## p_hnt ... parameter hint, <str>
## p_tp  ... parameter value type, <str>
##           p_tp can be one of ('str', 'bool', 'uint', 'int', 'sng', 'dbl')
## p_tag ... parameter tag (name), <str>
## p_def ... default value of parameter, <any_GNU_octave_value>
## p_itp ... input type, (1 = input, 2 = menu, 3 = datetime), <int>
## r_val ... return: value from interactive input, <any_GNU_octave_value>
function [r_val] = hlp_intact_param(p_hnt, p_tp, p_tag, p_def, p_itp)
  
  ## check arguments
  if (nargin < 4)
    p_def = [];
  endif
  
  ## check whether required input is numeric or not
  is_num = true;
  if (strcmpi(p_tp, 'str'))
    is_num = false;
  endif
  
  ## init return values
  r_val = [];

  ## try 3 inputs
  for i = 1 : 3
    ## switch input type
    switch (p_itp)
      case 1 # generic input
        if (nargin > 3) && not(isempty(p_def)) # non-empty default value available
          if (is_num) # require numeric value
            r_val = input(sprintf('%s, %s <%d>: ', p_hnt, p_tag, p_def));
          else # require string value
            r_val = input(sprintf('%s, %s <%s>: ', p_hnt, p_tag, p_def), 's');
          endif
          if (isempty(r_val))
            r_val = p_def;
          endif
          break;
        else # non-empty default value not available
          if (is_num) # require numeric value
            r_val = input(sprintf('%s, %s: ', p_hnt, p_tag));
          else # require string value
            r_val = input(sprintf('%s, %s: ', p_hnt, p_tag), 's');
          endif
          if not(isempty(r_val))
            break;
          endif
        endif
      case 2 # menu tag input
        r_val = hlp_intact_menu_tag(p_hnt, p_def);
        break;
      case 3 # menu id input
        r_val = hlp_intact_menu_id(p_hnt, p_def)
        break;
      case 4 # datetime input
        r_val = hlp_intact_datetime(p_hnt);
        if not(isempty(r_val))
          break;
        endif
      case {5, 6} # recipe id, author id
        r_val = input(sprintf('%s, %s <%d>: ', p_hnt, p_tag, p_def));
      otherwise
        r_val = input(sprintf('%s, %s <%s>: ', p_hnt, p_tag, p_def));
    endswitch
  endfor
  
  ## check return value
  if (isempty(r_val))
    error('Input must not be empty!');
  endif
  
  ## check return value type
  switch (p_tp)
    case 'str'
      1;
    case 'bool'
      r_val = logical(r_val);
    case 'uint'
      r_val = uint32(r_val);
    case 'int'
      r_val = int32(r_val);
    case 'sng'
      r_val = single(r_val);
    case 'dbl'
      r_val = double(r_val);
    otherwise
      error('Unknown value type! type = %s', p_tp);
  endswitch
  
endfunction

############################################################################################################################################
## Helper function: get menu tag
## p_hnt ... parameter hint, <str>
## p_def ... menu entries, {<str>}
## r_val ... return: menu tag, <str>
function [r_val] = hlp_intact_menu_tag(p_hnt, p_def)
  
  ## selection list consists of one element
  if not(iscell(p_def))
    r_val = p_def;
    return;
  endif
  
  ## show menu
  mid = menu(p_hnt, p_def);
  if (mid > 0)
    r_val = p_def{mid};
  else
    r_val = p_def{1};
  endif

endfunction

############################################################################################################################################
## Helper function: get menu id
## p_hnt ... parameter hint, <str>
## p_def ... menu entries, {<str>}
## r_val ... return: menu id, <uint>
function [r_val] = hlp_intact_menu_id(p_hnt, p_def)
  
  ## show menu
  mid = menu(p_hnt, p_def);
  if (mid > 0)
    r_val = mid;
  else
    r_val = 1;
  endif

endfunction

############################################################################################################################################
## Helper function: get date and time from interactive input
## p_hnt ... parameter hint, <str>
## r_val ... return: date/time number (utc, seconds since epoch), <dbl>
function [r_val] = hlp_intact_datetime(p_hnt)
  
  lst_year = {'2020', '2021', '2022', '2023'};
  lst_month = {'01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'};
  lst_day = {'01', '02', '03', '04', '05', '06', '07', '08', '09', '10', ...
    '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', ...
    '23', '24', '25', '26', '27', '28', '29', '30', '31'};
  lst_hour = {'04', '05', '06', '07', '08', '09', '10', '11', '12', '13', ...
    '14', '15', '16', '17', '18', '19', '20'};
  lst_minute = {'00', '15', '30', '45'};
  
  ## init return value
  r_val = [];
  
  ## get date and time
  mid_year = menu(sprintf('%s (year)', p_hnt), lst_year);
  if (mid_year > 0)
    str_year = lst_year{mid_year};
  else
    return;
  endif
  mid_month = menu(sprintf('%s (month)', p_hnt), lst_month);
  if (mid_month > 0)
    str_month = lst_month{mid_month};
  else
    return;
  endif
  switch (mid_month)
    case {1, 3, 5, 7, 8, 10, 12}
      1;
    case {4, 6, 9, 11}
      lst_day(end) = [];
    case 2
      lst_day(end) = [];
      lst_day(end) = [];
      lst_day(end) = [];
  endswitch
  mid_day = menu(sprintf('%s (day)', p_hnt), lst_day);
  if (mid_day > 0)
    str_day = lst_day{mid_day};
  else
    return;
  endif
  mid_hour = menu(sprintf('%s (hour)', p_hnt), lst_hour);
  if (mid_hour > 0)
    str_hour = lst_hour{mid_hour};
  else
    return;
  endif
  mid_minute = menu(sprintf('%s (minute)', p_hnt), lst_minute);
  if (mid_minute > 0)
    str_minute = lst_minute{mid_minute};
  else
    return;
  endif
  
  ## get date string
  strdt = sprintf('%s-%s-%s %s:%s:00', str_year, str_month, str_day, str_hour, str_minute);
  
  ## return date number
  r_val = datenum(strdt, 31);
  
endfunction

############################################################################################################################################
## Helper function: write project information files using values from project parameter list
## p_dp ... project directory path, full qualified, <str>
## p_fp ... project parameter list file path, full qualified (CSV file), <str>
## p_pl ... parameter list, {{<str>}}, see struct_make_static.m for details
function hlp_write_csv(p_dp, p_fp, p_pl)
  
  ## get input format list
  fmt = '';
  fldnames = {};
  for i = 1 : size(p_pl, 1)
    ## skip headlines
    if isempty(p_pl{i, 2})
      continue;
    endif
    if isempty(fmt)
      fmt = p_pl{i, 5};
    else
      fmt = cstrcat(fmt, ',', p_pl{i, 5});
    endif
    fldnames = [fldnames, p_pl{i, 2}];
  endfor
  
  ## open project information file (CSV)
  fid = fopen(p_fp, "r");
  
  ## check whether project information file (CSV) is open or not
  if (isempty(fid) || (fid <= 0))
    error("Cannot open project parameter file for reading!\n path = %s", p_fp);
  endif
  
  ## read project information file (CSV)
  cont = textscan(fid, fmt, "Delimiter", ",");
  
  ## close project information file (CSV)
  fclose(fid);
  
  ## iterate over all content lines
  for j = 1 : size(cont{1,1}, 1)
    ## create data structure from current content line
    ds = [];
    for i = 1 : size(fldnames, 2)
      ## temp value
      tmpval = cont{1, i}(j);
      if iscell(tmpval)
        tmpval = tmpval{1, 1};
      endif
      ## set structure field
      ds = setfield(ds, fldnames{i}, tmpval);
    endfor
    ## get directory name from dataset metadata
    dsmeta = struct_metaset(ds.set_code);
    dn = dsmeta.a01.v;
    ## output file path
    ofp = fullfile(p_dp, dn, 'projinfo.txt');
    ## open file for writing
    fid = fopen(ofp, "w");
    ## check if file is open
    if (isempty(fid) || (fid < 1))
      error("Cannot open project information file for writing!\n  path = %s", ofp);
    endif
    ## write datastructure to file
    hlp_write(fid, p_pl, ds);
    ## close file
    fclose(fid);
  endfor
  
endfunction

############################################################################################################################################
## Helper function: write data structure to project information file
## p_fid ... file descriptor, <int>
## p_ds  ... project information data structure, <struct>
## p_pl  ... parameter list, {{<str>}}, see struct_make_static.m for details
function hlp_write(p_fid, p_pl, p_ds)
  
  ## read static information from global variable
  ## read by init.m from file ./struct_hdf/db_static.oct
  global wavupv_db_static
  
  ## write file header (license and data type information)
  for i = 1 : max(size(wavupv_db_static.license_header))
    fprintf(p_fid, sprintf('%s\n', wavupv_db_static.license_header{i}));
  endfor
  for i = 1 : max(size(wavupv_db_static.pinfo_header))
    fprintf(p_fid, sprintf('%s\n', wavupv_db_static.pinfo_header{i}));
  endfor
  
  ## write project parameters to file
  for i = 1 : size(p_pl, 1)
    tmphnt = p_pl{i, 1};
    tmpfld = p_pl{i, 2};
    tmptype = p_pl{i, 3};
    tmptmpl = p_pl{i, 6};
    if (isempty(tmptype)) # write section headline
      fprintf(p_fid, sprintf('## %s\n', tmphnt));
    else # write parameter line
      ## get field value from data structure
      have_val = false;
      if (nargin == 3)
        if not(isempty(tmpfld))
          if isfield(p_ds, tmpfld)
            fval = getfield(p_ds, tmpfld);
            have_val = true;
          endif
        endif
      endif
      if not(have_val)
        [fval] = hlp_emptyvalue(tmptype);
      endif
      ## write structure field to file line
      hlp_writevalue(p_fid, tmptype, tmpfld, fval);
    endif
  endfor
  
  fprintf(p_fid, '\n');
  
endfunction

############################################################################################################################################
## Helper function: get empty value by value type
function [r_ve] = hlp_emptyvalue(p_vt)
  
  ## switch value type
  switch (p_vt)
    case {'str'}
      r_ve = '';
    case {'bool'}
      r_ve = false;
    case {'uint'}
      r_ve = 0;
    case {'int'}
      r_ve = 0;
    case {'sng', 'dbl'}
      r_ve = 0.0;
  endswitch
  
endfunction

############################################################################################################################################
## Helper function: get empty value by value type
## p_fid ... file descriptor, id
## p_ft ... structure field data type
## p_fn ... structure field name
## p_fv ... structure field value
function hlp_writevalue(p_fid, p_ft, p_fn, p_fv)
  
  ## get value type separator space
  if (length(p_ft) == 3)
    sep1 = ' ';
  else
    sep1 = '';
  endif
  
  ## get field name separator space
  s2len = 12 - length(p_fn);
  if (s2len > 0)
    sep2 = repmat(' ', 1, s2len);
  else
    sep2 = '';
  endif
      
  ## switch value type
  switch (p_ft)
    case {'str'}
      fprintf(p_fid, sprintf("[%s]%s %s%s = \"%s\"\n", p_ft, sep1, p_fn, sep2, p_fv));
    case {'bool', 'uint'}
      fprintf(p_fid, sprintf("[%s]%s %s%s = %u\n", p_ft, sep1, p_fn, sep2, p_fv));
    case 'int'
      fprintf(p_fid, sprintf("[%s]%s %s%s = %d\n", p_ft, sep1, p_fn, sep2, p_fv));
    case {'sng', 'dbl'}
      fprintf(p_fid, sprintf("[%s]%s %s%s = %.8f\n", p_ft, sep1, p_fn, sep2, p_fv));
  endswitch
  
endfunction
