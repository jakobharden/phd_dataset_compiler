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
## Load project data structure from file or variable
##
## Usage 1: [r_ds] = fio_struct_load(p_src), load dataset data structure from variable
##
## Usage 2: [r_ds] = fio_struct_load(p_src), load dataset data structure from file
##
## Note: if p_src is a variable containing the data structure, the data structure
##       is returned as given, otherwise the data structure is loaded from the given
##       file path p_src
##
## p_src ... project data structure or full qualified file path, <struct> or <str>
## r_ds  ... return: project data structure, <struct>
##
## see also: fio_struct_save, struct_import
##
function [r_ds] = fio_struct_load(p_src)
  
  ## check arguments
  if (nargin < 1)
    help fio_struct_load;
    error('Less arguments given');
  endif
  
  ## check argument type
  if isstruct(p_src)
    r_ds = p_src;
  else
    ## check whether data structure file exists or not
    if (exist(p_src, 'file') != 3)
      help fio_struct_load;
      error('Data structure file does not exist!\n   path = %s', p_src);
    else
      r_ds = load(p_src, "dataset").dataset;
    endif
  endif
  
endfunction
