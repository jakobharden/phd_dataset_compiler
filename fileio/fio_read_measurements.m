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
## Read measurements file from upv project
##
## Usage: [r_sta, r_mds] = fio_read_measurements(p_mfp, p_cid, p_pnm)
##
## p_mfp ... measurements file path, <str>
## p_cid ... channel id, optional, <int>
## p_pnm ... project name, optional, <str>
## r_sta ... return: state (true = success, false = failure), <bool>
## r_mds ... return: measurements data structure, <struct>
##   .obj_type ... object type (always "struct_measurements"), <str>
##   .pname    ... project name, <str>
##   .cid      ... channel id, <int>
##   .fpath    ... measurements file path, <str>
##   .fdir     ... measurements file directory, <str>
##   .fname    ... measurements file name, <str>
##   .fhash    ... measurements file sha256 hash, <str>
##   .files    ... signal file name list {nm x 1}, nm = number of measurements, {<str>}
##   .times    ... signal measurement time list in seconds [nm x 1], [<int>]
##
## see also: fio_read_project
function [r_sta, r_mds] = fio_read_measurements(p_mfp, p_cid, p_pnm)
  
  ## init return values
  r_sta = false;
  r_mds = [];
  
  ## check arguments
  if (nargin < 3)
    p_pnm = '';
  endif
  if (nargin < 2)
    p_cid = 0;
  endif
  if (nargin < 1)
    help fio_read_measurements;
    warning('Less arguments given!');
    return;
  endif
  
  ## extract file name
  [fd, fn, fe] = fileparts(p_mfp);
  fname = sprintf('%s%s', fn, fe);
  
  ## hash file
  fhash = fio_hash_sha256(p_mfp);
  
  ## open file
  fid = fopen(p_mfp, "r");
  
  ## check for errors
  if (fid < 0)
    warning("Cannot read measurements file! path = %s", p_mfp);
    return;
  endif
  
  ## read file, create structure
  r_mds.obj_type = "struct_measurements";
  r_mds.pname = p_pnm;
  r_mds.cid = p_cid;
  r_mds.fpath = p_mfp;
  r_mds.fdir = fd;
  r_mds.fname = fname;
  r_mds.fhash = fhash;
  r_mds.files = {};
  r_mds.times = [];
  while not(feof(fid))
    ## read line
    lstr = strtrim(fgetl(fid));
    ## skip comment lines
    if (lstr(1) == '#')
      continue;
    endif
    ## scan line
    [tmp_fn, tmp_h, tmp_m, tmp_s, tmp_cnt, ~] = sscanf(lstr, "%s %d:%d:%d", "C");
    if (tmp_cnt == 4)
      r_mds.files = [r_mds.files; tmp_fn];
      r_mds.times = [r_mds.times; double(tmp_h) * 3600 + double(tmp_m) * 60 + double(tmp_s)];
    else
      warning("Wrong line format in measurements file! Skipping line.");
    endif
  endwhile
  
  ## close file
  fclose(fid);
  
  ## return state
  r_sta = true;
  
endfunction
