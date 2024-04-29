## Read temperature data file from upv project
##
## Usage: [r_sta, r_tds] = fio_read_temperature(p_tfp, p_cid, p_pnm)
##
## p_tfp ... temperature data file path, <str>
## p_cid ... channel id, optional, <int>
## p_pnm ... project name, optional, <str>
## r_sta ... return: state (true = success, false = failure), <bool>
## r_tds ... return: temperature data, <struct>
##   .obj_type ... object type (always "struct_temperature"), <str>
##   .pname    ... project name, <str>
##   .cid      ... channel id, <int>
##   .fpath    ... temperature data file path, <str>
##   .fdir     ... temperature data file directory, <str>
##   .fname    ... temperature data file name, <str>
##   .fhash    ... temperature file sha256 hash, <str>
##   .ts       ... time series, [<dbl>]
##   .ms       ... magnitude series, [[<dbl>]]
##
## see also: fio_read_project, fio_hash_sha256
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
function [r_sta, r_tds] = fio_read_temperature(p_tfp, p_cid, p_pnm)
  
  ## init return values
  r_sta = false;
  r_tds = [];
  
  ## check arguments
  if (nargin < 3)
    p_pnm = '';
  endif
  if (nargin < 2)
    p_cid = 0;
  endif
  if (nargin < 1)
    help fio_read_temperature;
    warning('Less arguments given!');
    return;
  endif
  
  ## check file path
  if (isempty(p_tfp))
    warning('Temperature measurement file path must not be empty!');
    return;
  endif
  
  ## extract file name
  [fd, fn, fe] = fileparts(p_tfp);
  fname = sprintf('%s%s', fn, fe);
  
  ## hash file
  fhash = fio_hash_sha256(p_tfp);
  
  ## open file
  fid = fopen(p_tfp, 'r');
  
  ## check for errors
  if (fid < 0)
    warning('Cannot read temperature measurement file! path = %s', p_tfp);
    return;
  endif
  
  ## read file, create structure
  r_tds.obj_type = 'struct_temperature';
  r_tds.pname = p_pnm;
  r_tds.cid = p_cid;
  r_tds.fpath = p_tfp;
  r_tds.fdir = fd;
  r_tds.fname = fname;
  r_tds.fhash = fhash;
  r_tds.ts = [];
  r_tds.ms = [];
  while not(feof(fid))
    ## read line
    data = strtrim(fgetl(fid));
    ## skip comment lines
    if (data(1) == '#')
      continue;
    endif
    ## skip version line
    if not(isempty(strfind(data, 'Version')))
      continue;
    endif
    ## skip empty lines
    if isempty(data)
      continue;
    endif
    [ct1, ct2, ct3, ct4, tm, nval, err] = sscanf(data, "%f %f %f %f %f", "C");
    switch (nval)
      case 2
        r_tds.ts = [r_tds.ts; tm];
        r_tds.ms = [r_tds.ms; ct1, 0.0, 0.0, 0.0];
      case 3
        r_tds.ts = [r_tds.ts; tm];
        r_tds.ms = [r_tds.ms; ct1, ct2, 0.0, 0.0];
      case 4
        r_tds.ts = [r_tds.ts; tm];
        r_tds.ms = [r_tds.ms; ct1, ct2, ct3, 0.0];
      case 5
        r_tds.ts = [r_tds.ts; tm];
        r_tds.ms = [r_tds.ms; ct1, ct2, ct3, ct4];
    endswitch
  endwhile
  
  ## close file
  fclose(fid);
  
  ## return state
  r_sta = true;
  
endfunction
