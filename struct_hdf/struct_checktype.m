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
## Check object type and version of given data structure
##
## Usage 1: [r_sta, r_typ, r_ver] = struct_checktype(p_ds, p_typ, p_vma, p_vmi), check object type, major and minor version
##
## Usage 2: [r_sta, r_typ, r_ver] = struct_checktype(p_ds, p_typ, p_vma), check object type and major version
##
## Usage 3: [r_sta, r_typ, r_ver] = struct_checktype(p_ds, p_typ), check object type only
##
## Note: object type comparison is always case-insensitive!
##
## p_ds ... data structure, <struct>
## p_typ ... object type (field: p_ds.obj), <str>
## p_vma ... object major version number (field: p_ds.ver(1)), optional, <uint>
## p_vmi ... object minor version number (field: p_ds.ver(2)), optional, <uint>
## r_sta ... return: status, indicating whether object type matches or not, <bool>
## r_typ ... return: object type, <str>
## r_ver ... return: object version [major_version, minor_version], [<uint>]
##
## see also: struct_make_autdb
##
function [r_sta, r_typ, r_ver] = struct_checktype(p_ds, p_typ, p_vma, p_vmi)
  
  if (nargin < 2)
    help struct_checktype;
    error('Less arguments given!');
  endif
  
  ## init return values
  r_sta = false;
  r_typ = "";
  r_ver = uint16([]);
  
  ## check data structure fields
  if not(isfield(p_ds, "obj"))
    warning('Data structure has no "obj" (object type) field!');
    return;
  endif
  if not(isfield(p_ds, "ver"))
    warning('Data structure has no "ver" (object version) field!');
    return;
  endif
  
  ## check object type
  r_sta = strcmpi(p_ds.obj, p_typ);
  r_typ = p_ds.obj;
  r_ver = p_ds.ver;
  
  ## check version (if required)
  if (nargin == 3)
    ## check major version only
    r_sta = r_sta && (p_vma == p_ds.ver(1));
  elseif (nargin == 4)
    ## check major and minor version
    r_sta = r_sta && (p_vma == p_ds.ver(1)) && (p_vmi == p_ds.ver(2));
  endif
  
endfunction
