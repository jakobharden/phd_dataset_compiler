## Read list of project paths from file and return project directory structure array
##
## Usage: [r_sta, r_pds] = fio_read_list_project(p_lfp)
##
## p_lfp ... project list file path
## r_sta ... return read state (true = success, false = failure)
## r_pds ... return FreshCon project directory structure array
##
## see also: fio_read_project
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
function [r_sta, r_pds] = fio_read_list_project(p_lfp)
  
  ## init return value
  r_sta = false;
  r_pds = [];
  
  ## check arguments
  if (nargin < 1)
    help fio_read_list_project;
    return;
  endif
  
  ## read list file
  fplst = cell();
  if (exist(p_lfp, "file") == 2)
    fid = fopen(p_lfp, "r");
    while (!feof(fid))
      fp = strrep(fgetl(fid), "\"", "");
      fplst = [fplst; fp];
    endwhile
    fclose(fid);
  else
    error("Project list file does not exist! path = %s", p_lfp);
  endif
  
  ## create project directory structure array
  for i = 1 : size(fplst, 1)
    [ista, ipds] = fio_read_project(fplst{i});
    if (ista)
      r_pds = [r_pds; ipds];
    else
      warning("Project directory path does not exist! path = %s", fplst{i});
    endif
  endfor
  
  ## return state
  r_sta = !isempty(r_pds);
  
endfunction
