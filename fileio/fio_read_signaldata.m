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
## Read signal data file from upv project
##
## Usage: [r_sta, r_sds] = fio_read_signaldata(p_sfp, p_sid, p_cid, p_pnm)
##
## p_sfp ... signal file path, <str>
## p_sid ... signal id, optional, <int>
## p_cid ... channel id, optional, <int>
## p_pnm ... project name, optional, <str>
## r_sta ... return: state (true = success, false = failure)
## r_sds ... return: signal data structure
##   .obj_type ... object type, aways 'struct_signal', <str>
##   .cid   ... channel id, <int>
##   .sid   ... signal id, <int>
##   .fpath ... signal data file path, <str>
##   .fdir  ... measurements file directory, <str>
##   .fname ... measurements file name, <str>
##   .fhash ... measurements file sha256 hash, <str>
##   .ts    ... time series array, [<dbl>]
##   .ms    ... magnitude series array, [<dbl>]
##
function [r_sta, r_sds] = fio_read_signaldata(p_sfp, p_sid, p_cid, p_pnm)
  
  ## init return values
  r_sta = false;
  r_sds = [];
  
  ## check arguments
  if (nargin < 4)
    p_pnm = 'None';
  endif
  if (nargin < 3)
    p_cid = 0;
  endif
  if (nargin < 2)
    p_sid = 0;
  endif
  if (nargin < 1)
    help fio_read_signaldata;
    warning('Less arguments given!');
    return;
  endif
  
  ## extract file name
  [fd, fn, fe] = fileparts(p_sfp);
  fname = sprintf('%s%s', fn, fe);
  
  ## hash file
  fhash = fio_hash_sha256(p_sfp);
  
  ## count number of comment lines in front of data block
  ncl = hlp_num_cmt_lines(p_sfp);
  
  ## open signal data file
  fid = fopen(p_sfp, "r");
  
  ## check for errors
  if (fid < 0)
    warning("Cannot read signal data file! path = %s", p_sfp);
    return;
  endif
  
  ## skip comment lines counted before
  if (ncl > 0)
    fskipl(fid, ncl);
  endif
  
  ## read file
  tmp_data = [];
  tmp_data = dlmread(fid, '\t');
  
  ## close file
  fclose(fid);
  
  ## check signal data
  if (isempty(tmp_data))
    warning("Signal data file is empty! file path = %s", p_sfp);
  endif
  
  ## create signal data structure
  r_sds.obj_type = "struct_signal";
  r_sds.pname = p_pnm;
  r_sds.cid = p_cid;
  r_sds.sid = p_sid;
  r_sds.fpath = p_sfp;
  r_sds.fdir = fd;
  r_sds.fname = fname;
  r_sds.fhash = fhash;
  r_sds.ts = tmp_data(:, 1);
  r_sds.ms = tmp_data(:, 2);
  
  ## return state
  r_sta = true;
  
endfunction

###############################################################################
## Helper function: count comment lines in front of data block
## p_sfp ... signal file path, <str>
## r_ncl ... return: number of comment lines, <int>
##
function [r_ncl] = hlp_num_cmt_lines(p_sfp)
  
  ## init return value
  r_ncl = 0;
  
  ## open signal data file
  fid = fopen(p_sfp, "r");
  
  ## check for errors
  if (fid < 0)
    warning("Cannot read signal data file!\n  path = %s", p_sfp);
    return;
  endif
  
  # read until initial comment lines block end
  while not(feof(fid))
    ln = strtrim(fgetl(fid));
    if not(ln(1) == '#')
      break;
    endif
    r_ncl = r_ncl + 1;
  endwhile
  
  # close file
  fclose(fid);
  
endfunction
