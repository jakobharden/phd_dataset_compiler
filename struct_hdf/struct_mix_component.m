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
## Usage 1: [r_ds, r_mi] = struct_mix_component(p_mi, p_cw, p_de), return initialized data structure
##
## Usage 2: [r_ds, r_mi] = struct_mix_component(), return empty data structure
##
## p_mi ... material id, <uint>
## p_cw ... component weight, unit g, <dbl>
## p_de ... description, optional, <str>
## r_ds ... return: mixture component data structure, <struct>
##   .obj ... object type, always "struct_mix_component", <str>
##   .ver ... version number [major_ver, minor_ver], [<uint>]
##   .r01 ... related material, <ARE/struct>
##   .d01 ... component weight, <ADE/struct>
##   .d02 ... description, <ADE/struct>
## r_mi ... return: related material id, <uint>
##
## see also: struct_mix, struct_dataset
##
function [r_ds, r_mi] = struct_mix_component(p_mi, p_cw, p_de)
  
  ## read static information from global variable, see also init.m
  global dsc_db_static
  
  ## init return values
  r_ds = dsc_db_static.struct_mix_component;
  r_mi = [];
  
  # check arguments
  if (nargin == 0)
    return;
  endif
  if (nargin < 3)
    p_de = [];
  endif
  if (nargin < 2)
    help struct_mix_component;
    error('Less arguments given!');
  endif
  
  ## check material id
  ## return empty data structure
  if (p_mi == 0)
    return;
  endif
  
  ## det description
  if isempty(p_de)
    p_de = dsc_db_static.gdef.descr;
  endif
  
  ## update data structure
  r_ds.r01.i = p_mi;
  r_ds.d01.v = p_cw;
  r_ds.a01.v = p_de;
  
  # return related material id
  r_mi = r_ds.r01.i;
  
endfunction
