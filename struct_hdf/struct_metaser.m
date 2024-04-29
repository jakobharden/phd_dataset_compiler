## Create test series metadata data structure
##
## Usage 1: [r_ds, r_id] = struct_metaser(p_id), return initialized data structure
##
## Usage 2: [r_ds, r_id] = struct_metaser(), return empty data structure
##
## p_id ... series id or series code, <uint> or <str>
## r_ds ... return: test series metadata data structure, <struct>
##   fields: see ./struct_hdf/struct_make_metaserdb.m
## r_id ... return: test series id, <uint>
##
## see also: struct_make_metaserdb
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
function [r_ds, r_id] = struct_metaser(p_id)
  
  ## read static information from global variable, see also init.m
  global dsc_db_metaser
  
  ## init return values
  r_ds = dsc_db_metaser.item_empty;
  r_id = [];
  
  ## check arguments
  if (nargin == 0)
    return;
  endif
  if (nargin < 1)
    help struct_metaser;
    error('Less arguments given!');
  endif
  
  ## get test series id
  if isnumeric(p_id)
    serid = p_id;
  else
    serid = hlp_predef(p_id);
  endif
  
  ## return data structure(s)
  r_ds = dsc_db_metaser.item(serid);
  
  ## return references
  r_id = serid;
  
endfunction

###############################################################################
## Helper function: get test series id from test series code
## p_sc ... predefined test series code, <str>
## r_id ... return: series id, [<int>]
function [r_id] = hlp_predef(p_sc)
  
  ## read device database from global variable
  ## read by init.m from file ./struct_hdf/db_metaser.oct
  global dsc_db_metaser
  
  ## find test series in test series list
  r_id = [];
  for i = 1 : max(size(dsc_db_metaser.sercodes))
    if (strcmpi(p_sc, dsc_db_metaser.sercodes(i).code))
      r_id = dsc_db_metaser.sercodes(i).id;
      break;
    endif
  endfor
  
  ## check test series id
  if isempty(r_id)
    help struct_metaser;
    error("Unknown predefined test series code: %s!", p_sc);
  endif
  
endfunction
