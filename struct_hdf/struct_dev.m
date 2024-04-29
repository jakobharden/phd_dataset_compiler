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
## Create main device data structure
##
## Usage 1: [r_ds, r_id] = struct_dev(p_id), create device structure by given device id(s)
## p_id ... device id or array of device id's, <uint> or [<uint>]
## r_ds ... return: device data structure(s), <struct> or [<struct>]
##   fields: see ./struct_hdf/struct_make_devdb.m
## r_id ... return: device id's, <uint> or [<uint>]
##
## Usage 2: [r_ds, r_id] = struct_dev(p_id), create array of device id's by given predefined device group name
## p_id ... device group name (see function file ./struct_hdf/struct_make_devdb.m), <str>
## r_ds ... return: device data structure(s), <struct> or [<struct>]
##   fields: see ./struct_hdf/struct_make_devdb.m
## r_id ... return: device id's, <uint> or [<uint>]

##
## see also: struct_make_devdb
##
function [r_ds, r_id] = struct_dev(p_id)
  
  ## read static information from global variable, see also init.m
  global dsc_db_dev
  
  ## init return values
  r_ds = dsc_db_dev.item_empty;
  r_id = [];
  
  ## check arguments
  if (nargin == 0)
    return;
  endif
  if (nargin < 1)
    help struct_dev;
    error('Less arguments given!');
  endif
  
  ## get device id's
  if isnumeric(p_id) # usage 1
    devid = p_id;
  else # usage 2
    devid = hlp_predef(p_id);
  endif
  
  ## return data structure(s)
  r_ds = dsc_db_dev.item(devid);
  
  ## return references
  r_id = devid;
  
endfunction

###############################################################################
## Helper function: create predefined device set
## p_gn ... predefined device group name, <str>
## r_id ... return: array of device id's, [<int>]
function [r_id] = hlp_predef(p_gn)
  
  ## read device database from global variable
  ## read by init.m from file ./struct_hdf/struct_devdb.oct
  global dsc_db_dev
  
  ## find group in group list
  r_id = [];
  for i = 1 : max(size(dsc_db_dev.devgroup))
    if (strcmpi(p_gn, dsc_db_dev.devgroup(i).name))
      r_id = dsc_db_dev.devgroup(i).devid;
      break;
    endif
  endfor
  
  ## check device id's
  if isempty(r_id)
    help struct_dev;
    error("Unknown predefined device group name: %s!", p_gn);
  endif
  
endfunction
