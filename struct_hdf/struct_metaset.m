## Create data set metadata data structure
##
## Usage 1: [r_ds, r_id] = struct_metaset(p_id), return initialized data structure
##
## Usage 2: [r_ds, r_id] = struct_metaset(), return empty data structure
##
## p_id ... data set id or data set code, <uint> or <str>
## r_ds ... return: data set metadata data structure, <struct>
##   fields: see ./struct_hdf/struct_make_metasetdb.m
## r_id ... return: data set id, <uint>
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
function [r_ds, r_id] = struct_metaset(p_id)
  
  ## read static information from global variable, see also init.m
  global dsc_db_metaset
  
  ## init return values
  r_ds = dsc_db_metaset.item_empty;
  r_id = [];
  
  ## check arguments
  if (nargin == 0)
    return;
  endif
  if (nargin < 1)
    help struct_metaset;
    error('Less arguments given!');
  endif
  
  ## get test series id
  if isnumeric(p_id)
    dsid = p_id;
  else
    dsid = hlp_predef(p_id);
  endif
  
  ## return data structure(s)
  r_ds = dsc_db_metaset.item(dsid);
  
  ## return references
  r_id = dsid;
  
endfunction

###############################################################################
## Helper function: get data set id from data set code
## p_dc ... predefined data set code, <str>
## r_id ... return: data set id, [<int>]
function [r_id] = hlp_predef(p_dc)
  
  ## read device database from global variable
  ## read by init.m from file ./struct_hdf/db_metaset.oct
  global dsc_db_metaset
  
  ## find data set in data set list
  r_id = [];
  for i = 1 : max(size(dsc_db_metaset.setcodes))
    if (strcmpi(p_dc, dsc_db_metaset.setcodes(i).code))
      r_id = dsc_db_metaset.setcodes(i).id;
      break;
    endif
  endfor
  
  ## check data set id
  if isempty(r_id)
    help struct_metaset;
    error("Unknown predefined data set code: %s!", p_dc);
  endif
  
endfunction
