## Stringify atomic attribute element
##
## Usage: [r_str] = struct_objattrib_tostring(p_ds, p_mo)
##
## p_ds  ... data structure "objattrib", <AAE/struct>
## p_mo  ... mode, <str>
##             'tag' ... print tag only
##             'value' ... print value only
##             'description' ... print desription as string 
##             'all' ... print all contents (default)
## r_str ... return: string representation of structure element(s), <str>
##
## see also: struct_objattrib
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
function [r_str] = struct_objattrib_tostring(p_ds, p_mo)
  
  ## check arguments
  if (nargin < 2)
    p_mo = 'all';
  endif
  if (nargin < 1)
    help struct_objattrib_tostring;
    error('Less arguments given!');
  endif
  
  ## check type of data structure
  if (not(isfield(p_ds, 't') && isfield(p_ds, 'v')) || isfield(p_ds, 'vt'))
    warning('Data structure is not of type "ATTRIBUTE"!');
    r_str = '';
    return;
  endif
  
  ## switch output mode
  switch (p_mo)
    case 'tag' # return tag only
      r_str = p_ds.t;
    case 'value' # return value only
      if iscellstr(p_ds.v)
        ## if cell array, concatenate elements, separated by semicolons
        r_str = '';
        for i = 1 : max(size(p_ds.v))
          if (i == 1)
            r_str = p_ds.v{i};
          else
            r_str = [r_str, '; ' , p_ds.v{i}];
          endif
        endfor
      else
        r_str = p_ds.v;
      endif
    case {'description', 'descr', 'de'}
      r_str = p_ds.d;
    case 'all' # return all, tag and value
      ## check description
      if isempty(p_ds.d)
        d = '';
      else
        d = sprintf(' ... %s', p_ds.d);
      endif
      if iscellstr(p_ds.v)
        ## if cell array, show first element only
        nitems = max(size(p_ds.v));
        r_str = sprintf('%s = %s (1st of %d items)%s', p_ds.t, p_ds.v{1}, nitems, d);
      else
        r_str = sprintf('%s = %s%s', p_ds.t, p_ds.v, d);
      endif
  endswitch
  
endfunction
