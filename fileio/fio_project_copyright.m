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
## Add copyright header to all data files of a project
##
## Usage: fio_project_copyright(p_pd)
##
## p_pd ... project directory path, <str>
##
## see also: fio_read_project, fio_read_channel, fio_read_settings,
##           fio_read_measurements, fio_read_temperature, fio_read_signal
##
function fio_project_copyright(p_pd)
  
  global wavupv_db_static
  
  ## check arguments
  if (nargin < 1)
    p_pd = uigetdir('/mnt/data/0_test_series');
  endif
  if isempty(p_pd)
    p_pd = uigetdir('/mnt/data/0_test_series');
  endif
  if (exist(p_pd, 'dir') != 7)
    help fio_project_copyright;
    error('No project directory selected!');
  endif
  
  ## get project file list
  pfl = fio_project_filelist(p_pd);
  
  ## process files
  for i = 1 : size(pfl, 1)
    ## add copyright header
    fio_header_add(pfl(i).fp, wavupv_db_static.license_header);
    ## print state
    printf("add copyright header: path = %s\n", pfl(i).fp);
  endfor
  
endfunction
