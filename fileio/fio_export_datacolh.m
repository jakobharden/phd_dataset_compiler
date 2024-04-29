## Export data to CSV file and column heads to text file
##
## Usage: [r_fp_dat, r_fp_col] = fio_export_datacolh(p_fp, p_dat, p_col)
##
## p_fp  ... export file path without extension, <str>
## p_dat ... number array, [[<float>]]
## p_col ... column headers, {<str>}
## r_fp_dat ... return file path to data CSV file, <str>
## r_fp_col ... return file path to column headers text file, <str>
##
## see also: 
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
function [r_fp_dat, r_fp_col] = fio_export_datacolh(p_fp, p_dat, p_col)
  
  ## check arguments
  if (nargin < 2)
    help fio_export_datacolh;
    error('Less arguments given!');
  endif
  
  ## write data to CSV file
  if not(isempty(p_dat))
    r_fp_dat = cstrcat(p_fp, '.csv');
    csvwrite(r_fp_dat, p_dat);
  else
    warning('No data available for export!');
  endif
  
  ## write column headers to text file
  if (nargin > 2) && not(isempty(p_col))
    r_fp_col = cstrcat(p_fp, '.col');
    fid = fopen(r_fp_col, 'w');
    for i = 1 : (max(size(p_col)) - 1)
      fprintf(fid, '\"%s\",', p_col{i});
    endfor
    fprintf(fid, '\"%s\"\n', p_col{end});
    fclose(fid);
  else
    warning('No column headers available for export!');
  endif
  
endfunction
