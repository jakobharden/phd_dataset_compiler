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
## Stringify atomic data element
##
## Usage: [r_str] = struct_objdata_tostring(p_ds, p_mo)
##
## p_ds  ... data structure "objdata", <ADE/struct>
## p_mo  ... mode, <str>
##             'tag' ... print tag only
##             'value' ... print value only
##             'type' ... print value type only
##             'unit' ... print unit only
##             'description' ... print desription as string 
##             'all' ... print all contents (default)
## r_str ... return: string representation of structure element(s), <str>
##
## see also: struct_objdata
##
function [r_str] = struct_objdata_tostring(p_ds, p_mo)
  
  ## check arguments
  if (nargin < 2)
    p_mo = 'all';
  endif
  if (nargin < 1)
    help struct_objdata_tostring;
    error('Less arguments given!');
  endif
  
  ## check type of data structure
  if not(isfield(p_ds, 't') && isfield(p_ds, 'vt') && isfield(p_ds, 'v') && isfield(p_ds, 'u'))
    warning('Data structure is not of type "DATA"!');
    r_str = '';
    return;
  endif
  
  ## switch output mode
  switch (p_mo)
    case 'tag'
      r_str = p_ds.t;
    case 'value'
      r_str = hlp_tostring_value(p_ds);
    case 'type'
      r_str = p_ds.vt;
    case 'unit'
      r_str = p_ds.u;
    case {'description', 'descr', 'de'}
      r_str = p_ds.d;
    otherwise
      ## convert value to string
      v = hlp_tostring_value(p_ds);
      ## check description
      if isempty(p_ds.d)
        d = '';
      else
        d = sprintf(' ... %s', p_ds.d);
      endif
      ## check unit
      if (strcmp(p_ds.u, '/') || isempty(p_ds.u))
        u = '';
      else
        u = sprintf(' [%s]', p_ds.u);
      endif
      r_str = sprintf('%s = %s%s <%s>%s', p_ds.t, v, u, p_ds.vt, d);
  endswitch
  
endfunction

############################################################################################################################################
## Helper function: stringify value of data structure
## p_ds  ... data structure, <struct>
## r_str ... return: string representation of value, <str>
function [r_str] = hlp_tostring_value(p_ds)
  
  ## switch value type
  switch (p_ds.vt)
    case {'str', 's', 1} # string
      r_str = p_ds.v;
    case {'str_arr', 'str1', 's1'} # string array (cell array 1D)
      r_str = sprintf('{%s, ...}', p_ds.v{1});
    case {'str_mat', 'str2', 's2'} # string array (cell array 2D)
      r_str = sprintf('{{%s, ...}}', p_ds.v{1, 1});
    case {'boolean', 'bool', 'b'} # boolean
      if p_ds.v
        r_str = 'true';
      else
        r_str = 'false';
      endif
    case {'boolean_arr', 'bool_arr', 'bool1', 'b1'} # boolean array
      if p_ds.v(1)
        r_str = '[true, ...]';
      else
        r_str = '[false, ...]';
      endif
    case {'boolean_mat', 'bool_mat', 'bool2', 'b2'} # boolean matrix
      if p_ds.v(1, 1)
        r_str = '[[true, ...]]';
      else
        r_str = '[[false, ...]]';
      endif
    case {'uint', 'u'} # unsigned integer
      r_str = sprintf('%u', p_ds.v);
    case {'uint_arr', 'uint1', 'u1'} # unsigned integer array
      r_str = sprintf('[%u, ...]', p_ds.v(1));
    case {'uint_mat', 'uint2', 'u2'} # unsigned integer matrix
      r_str = sprintf('[[%u, ...]]', p_ds.v(1, 1));
    case {'int', 'i'} # integer
      r_str = sprintf('%d', p_ds.v);
    case {'int_arr', 'int1', 'i1'} # integer array
      r_str = sprintf('[%d, ...]', p_ds.v(1));
    case {'int_mat', 'int2', 'i2'} # integer matrix
      r_str = sprintf('[[%d, ...]]', p_ds.v(1, 1));
    case {'single', 'sng', 'float', 'f'} # single precision
      r_str = sprintf('%.6f', p_ds.v);
    case {'single_arr', 'sng_arr', 'sng1', 'float_arr', 'float1', 'f1'} # single precision array
      r_str = sprintf('[%.6f, ...]', p_ds.v(1));
    case {'single_mat', 'sng_mat', 'sng2', 'float_mat', 'float2', 'f2'} # single precision matrix
      r_str = sprintf('[[%.6f, ...]]', p_ds.v(1, 1));
    case {'double', 'dbl', 'd'} # double precision
      r_str = sprintf('%.6f', p_ds.v);
    case {'double_arr', 'double1', 'dbl_arr', 'dbl1', 'd1'} # double precision array
      r_str = sprintf('[%.6f, ...]', p_ds.v(1));
    case {'double_mat', 'double2', 'dbl_mat', 'dbl2', 'd2'} # double precision matrix
      r_str = sprintf('[[%.6f, ...]]', p_ds.v(1, 1));
    otherwise
      r_str = '???';
  endswitch
  
endfunction
