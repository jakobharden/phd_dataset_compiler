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
## Create mixture component data structure
##
## Usage 1: [r_ds, r_id] = struct_rec(p_ri), return initialized data structure
##
## Usage 2: [r_ds, r_id] = struct_rec(), return empty data structure
##
## p_ri ... recipe id/code, <uint> or <str>
## r_ds ... return: recipe data structure, <struct>
##   .obj ... object type, always "struct_rect", <str>
##   .ver ... version number [major_ver, minor_ver], [<uint>]
##   .r01 ... related materials, <ARE/struct>
##   .d01 ... recipe id, <ADE/struct>
##   .d02 ... recipe code, <ADE/struct>
##   .d03 ... parameters, <ADE/struct>
## r_id ... return: recipe id's, <uint> or [<uint>]
##
## see also: struct_mix, struct_dataset
##
function [r_ds, r_id] = struct_rec(p_ri)
  
  ## read static information from global variable, see also init.m
  global dsc_db_rec
  
  ## check arguments
  if (nargin == 0)
    r_ds = dsc_db_rec.item_empty;
    return;
  endif
  
  ## check recipe id/code
  r_id = [];
  if not(isnumeric(p_ri))
    for i = 1 : max(size(dsc_db_rec.item))
      if strcmpi(dsc_db_rec.item(i).a01.v, p_ri)
        r_id = i;
        break;
      endif
    endfor
  else
    r_id = p_ri;
  endif
  if isempty(r_id)
    help struct_rec;
    error('Recipe id/code not found in recipe database!');
  endif
  
  ## return data structure
  r_ds = dsc_db_rec.item(r_id);
  
endfunction
