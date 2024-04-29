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
## Export data structure fields to TeX file
##
## Usage: [r_ec] = struct_exp_tex(p_ds, p_dn, p_of)
##
## Note: only atomic data structures are exported
##
## p_ds ... data structure, <struct>
## p_dn ... data structure name (used as variable name prefix), <str>
## p_of ... output file path without extension, full qualified, <str>
## r_ec ... return: error code, <bool>
##            true:  success
##            false: failure
##
## see also: 
##
function [r_ec] = struct_exp_tex(p_ds, p_dn, p_of)
  
  ## check arguments
  if (nargin < 3)
    help struct_exp_tex;
    error('Less arguments given!');
  endif
  
  ## list field names
  fldlst = fieldnames(p_ds);
  
  ## open TeX file
  fid = fopen([p_of, '.tex'], 'w');
  printf('struct_exp_tex: opened file, %s\n', p_of);
  if (fid < 0)
    r_ec = false;
    warning('struct_exp_tex: error while opening file for writing!');
    return;
  else
    r_ec = true;
  endif
  
  ## collect TeX code listing
  for i = 1 : max(size(fldlst))
    fn_i = fldlst{i};
    vn_i = sprintf('%s%s', p_dn, fn_i);
    ds_i = getfield(p_ds, fn_i);
    if isfield(ds_i, 'obj')
      switch (ds_i.obj)
        case 'AAE'
          ## atomic attribute element
          hlp_append(fid, struct_objattrib_totex(ds_i, vn_i));
        case 'ARE'
          ## atomic reference element
          hlp_append(fid, struct_objref_totex(ds_i, vn_i));
        case 'ADE'
          ## atomic data element
          hlp_append(fid, struct_objdata_totex(ds_i, vn_i));
      endswitch
      printf('struct_exp_tex: wrote var = %s\n', vn_i);
    endif
  endfor
  
  ## close TeX file
  fclose(fid);
  printf('struct_exp_tex: closed file, %s\n', p_of);
  
endfunction

############################################################################################################################################
## Helper function: append TeX code listing to file
function hlp_append(p_fid, p_tc)
  
  for i = 1 : size(p_tc, 1)
    fprintf(p_fid, '%s\n', p_tc{i});
  endfor
  
endfunction