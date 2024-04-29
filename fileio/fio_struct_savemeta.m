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
## Extract metadata from project data structure and save metadata to JSON file
##
## Usage 1: [r_fp] = fio_struct_savemeta(p_src), read dataset from variable
##
## Usage 2: [r_fp] = fio_struct_savemeta(p_src), load dataset from file
##
## p_src ... project data structure or full qualified file path, <struct> or <str>
## r_fp  ... return: file path to metadata file (JSON format), <str>
##
## see also: fio_struct_save, fio_struct_load
##
function [r_fp] = fio_struct_savemeta(p_src)
  
  ## init return values
  r_fp = '';
  
  ## check arguments
  if (nargin < 1)
    help fio_struct_savemeta;
    error('Less arguments given');
  endif
  
  ## load dataset
  ds = fio_struct_load(p_src);
  
  ## generate output file path for matadata
  if isstruct(p_src)
    r_fp = sprintf('./%s.oct.json', ds.ser.f04.v);
  else
    r_fp = sprintf('%s.json', p_src);
  endif
  
  ## generate metadata in JSON format
  mjson = struct_extract_metajson(ds);
  
  ## write metadata to JSON file
  if not(isempty(mjson))
    fid = fopen(r_fp, 'w');
    ## check whether file is open or not
    if (isempty(fid) || (fid < 1))
      error("Cannot open metadata (JSON) file for writing!\n   path = %s", r_fp);
    endif
    for i = 1 : max(size(mjson))
      fprintf(fid, '%s\n', mjson{i});
    endfor
    fclose(fid);
    printf('Metadata written to JSON file.\n   path = %s\n', r_fp);
  endif
  
endfunction
