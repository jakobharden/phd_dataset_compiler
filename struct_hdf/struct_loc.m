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
## Create location information data structure by given location id
##
## Usage 1: [r_ds, r_id] = struct_loc(p_id), return initialized data structure
##
## Usage 2: [r_ds, r_id] = struct_loc(), return empty data structure
##
## p_id ... location id's, <uint> or [<uint>]
## r_ds ... return: location information structure(s), <struct> or [<struct>]
##   fields: see ./struct_hdf/struct_make_locdb.m
## r_id ... return: related location id's, <uint> or [<uint>]
##
## see also: struct_make_autdb
##
function [r_ds, r_id] = struct_loc(p_id)
  
  ## read static information from global variable, see also init.m
  global dsc_db_loc
  
  ## init return values
  r_ds = dsc_db_loc.item_empty;
  r_id = [];
  
  ## check arguments
  if (nargin == 0)
    return;
  endif
  if (nargin < 1)
    help struct_loc;
    error('Less arguments given!');
  endif
  
  ## return data structure(s)
  r_ds = dsc_db_loc.item(p_id);
  
  ## return references
  r_id = p_id;
  
endfunction
