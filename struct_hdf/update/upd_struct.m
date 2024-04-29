## Update existing dataset data structure
##
## Usage: upd_struct(p_ts)
##
## p_ts ... test series id, <uint>
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
function upd_struct(p_ts)
  
  ## read file path list
  lstfile = sprintf('./struct_hdf/update/ts%d.fplst', p_ts);
  fid = fopen(lstfile, 'r');
  [fplst, count, errmsg] = textscan(fid, '%s');
  fplst = fplst{1,1};
  
  for i = 1 : numel(fplst)
    ## load dataset
    ds = load(fplst{i}, 'dataset').dataset;
    ## update dataset
    dsu = hlp_upd_metaser_title_abstract(ds, p_ts);
    dsu = hlp_upd_typocorr(dsu);
    ## save dataset
    fio_struct_save(dsu, fplst{i}, 'none');
  endfor
  
endfunction

function [r_ds] = hlp_upd_metaser_title_abstract(p_ds, p_ts)
  ## Update title and abstract in test series metadata (ds.meta_ser)
  ## p_ds ... dataset data structure, <struct>
  ## p_ts ... test series id, <str>
  ## r_ds ... return: updated dataset data structure, <struct>
  
  global wavupv_db_metaser;
  
  r_ds = p_ds;
  
  r_ds.meta_ser.a03.v = wavupv_db_metaser.item(p_ts).a03.v;
  r_ds.meta_ser.a04.v = wavupv_db_metaser.item(p_ts).a04.v;
  disp('updated test series title and abstract');

endfunction

function [r_ds] = hlp_upd_typocorr(p_ds)
  ## Correct typographic errors
  ## p_ds ... dataset data structure, <struct>
  ## r_ds ... return: updated dataset data structure, <struct>

  global wavupv_db_static;
  
  r_ds = p_ds;
  
  r_ds.tst.s06.d06.d = wavupv_db_static.struct_test_utt.d06.d;
  r_ds.tst.s07.d06.d = wavupv_db_static.struct_test_utt.d06.d;
  if not(isempty(r_ds.tst.s04.d02))
    if strcmp(r_ds.tst.s04.obj, 'struct_test_umd1')
      r_ds.tst.s04.d02.d = wavupv_db_static.struct_test_umd1.d02.d;
      disp('corrected typo: s04, umd1');
    endif
  endif
  if not(isempty(r_ds.tst.s05.d02))
    if strcmp(r_ds.tst.s05.obj, 'struct_test_umd1')
      r_ds.tst.s05.d02.d = wavupv_db_static.struct_test_umd1.d02.d;
      disp('corrected typo: s05, umd1');
    endif
  endif
  
endfunction
