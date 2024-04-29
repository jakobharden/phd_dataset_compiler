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
## Stringify atomic reference element
##
## Usage: [r_str] = struct_objref_tostring(p_ds, p_mo)
##
## p_ds  ... data structure "objref", <ARE/struct>
## p_mo  ... mode, <str>
##             'tag' ... print tag only
##             'target' ... print reference target only
##             'id' ... print referenced element id only, as string
##             'target_id' ... print target and id of referenced element, format <target>(<id>)
##             'description' ... print desription as string 
##             'all' ... print all contents (default)
## r_str ... return: string representation of structure element(s), <str>
##
## see also: struct_objdata
##
function [r_str] = struct_objref_tostring(p_ds, p_mo)
  
  ## check arguments
  if (nargin < 2)
    p_mo = 'all';
  endif
  if (nargin < 1)
    help struct_objdata_tostring;
    error('Less arguments given!');
  endif
  
  ## check type of data structure
  if not(isfield(p_ds, 't') && isfield(p_ds, 'i') && isfield(p_ds, 'r'))
    warning('Data structure is not of type "REFERENCE"!');
    r_str = '';
    return;
  endif
  
  ## switch output mode
  switch (p_mo)
    case 'tag'
      r_str = p_ds.t;
    case 'target'
      r_str = hlp_catref(p_ds.r);
    case 'id'
      r_str = p_ds.i;
    case {'description', 'descr', 'de'}
      r_str = p_ds.d;
    otherwise
      ## check description
      if isempty(p_ds.d)
        d = '';
      else
        d = sprintf(' ... %s', p_ds.d);
      endif
      r_str = sprintf('%s --> %s(%s)%s', p_ds.t, hlp_catref(p_ds.r), hlp_catid(p_ds.i), d);
  endswitch
  
endfunction

############################################################################################################################################
## Helper function: concatenate reference list (cell array) to single string
## p_arr ... reference object (cell array of strings), {<str>}
## r_str ... return: string representation of reference object, <str>
function [r_str] = hlp_catref(p_arr)
  
  r_str = '';
  for i = 1 : max(size(p_arr))
    if (i > 1)
      r_str = [r_str, '.', p_arr{i}];
    else
      r_str = p_arr{i};
    endif
  endfor
  
endfunction

############################################################################################################################################
## Helper function: concatenate reference id's (uint array) to single string
## p_arr ... reference id's (uint or uint array), <uint> or [<uint>]
## r_str ... return: string representation of reference id's, <str>
function [r_str] = hlp_catid(p_arr)
  
  r_str = '';
  for i = 1 : max(size(p_arr))
    if (i > 1)
      r_str = [r_str, ',', sprintf('%d', p_arr(i))];
    else
      r_str = sprintf('%d', p_arr(i));
    endif
  endfor
  
endfunction
