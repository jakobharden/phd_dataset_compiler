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
## Read project information file
##
## Usage: [r_ds] = fio_projinfo_read(p_fp)
##
## File name: input file name is always 'projinfo.txt'
## File location: in the folder where the upv channel directories are
## File format:
##   a) lines starting with ## are comment lines
##   b) double-quote strings
##   c) line format: [type] <tag> = <value>
##                   supported types: bool, uint, int, sng, dbl, str
##
## p_fp ... project information file path (full qualified), <str>
## r_ps ... return project information, <struct>
##
## see also: struct_import, fio_projinfo_write
##
function [r_ds] = fio_projinfo_read(p_fp)
  
  ## check arguments
  if (nargin < 1)
    fio_projinfo_read();
    return;
  endif
  
  ## init return value
  r_ds = [];
  
  ## open file
  fid = fopen(p_fp, "r");
  
  ## check if file is open
  if (isempty(fid) || (fid < 1))
    error("Cannot parse project information file!\n  path = %s", p_fp);
  endif
  
  ## read file
  while not(feof(fid))
    lstr = strtrim(fgetl(fid));
    # skip empty lines
    if isempty(lstr)
      continue;
    endif
    # skip comment lines
    if (lstr(1) == '#')
      continue;
    endif
    ## parse line
    [r_err, r_ltp, r_tag, r_val] = hlp_parse_line(lstr);
    # read data lines
    if (r_err)
      r_ds = setfield(r_ds, r_tag, r_val);
    endif
  endwhile
 
 ## close file
 fclose(fid);
  
endfunction

###############################################################################
function [r_err, r_ltp, r_tag, r_val] = hlp_parse_line(p_ls)
  
  r_err = true;
  if (strcmpi(p_ls(1:5), '[str]'))
    r_ltp = 1;
    tmplst = strsplit(p_ls(6:end), '=');
    r_tag = strtrim(tmplst{1});
    r_val = strtrim(strrep(tmplst{2}, '"', ''));
  elseif (strcmpi(p_ls(1:6), '[bool]'))
    r_ltp = 2;
    tmplst = strsplit(p_ls(7:end), '=');
    r_tag = strtrim(tmplst{1});
    r_val = fix(str2num(strtrim(tmplst{2})));
  elseif (strcmpi(p_ls(1:6), '[uint]'))
    r_ltp = 3;
    tmplst = strsplit(p_ls(7:end), '=');
    r_tag = strtrim(tmplst{1});
    r_val = fix(str2num(strtrim(tmplst{2})));
  elseif (strcmpi(p_ls(1:5), '[int]'))
    r_ltp = 4;
    tmplst = strsplit(p_ls(6:end), '=');
    r_tag = strtrim(tmplst{1});
    r_val = fix(str2num(strtrim(tmplst{2})));
  elseif (strcmpi(p_ls(1:5), '[sng]'))
    r_ltp = 5;
    tmplst = strsplit(p_ls(6:end), '=');
    r_tag = strtrim(tmplst{1});
    r_val = str2num(strtrim(tmplst{2}));
  elseif (strcmpi(p_ls(1:5), '[dbl]'))
    r_ltp = 6;
    tmplst = strsplit(p_ls(6:end), '=');
    r_tag = strtrim(tmplst{1});
    r_val = str2num(strtrim(tmplst{2}));
  else
    r_err = false;
    r_ltp = [];
    r_tag = [];
    r_val = [];
  endif
  
endfunction
