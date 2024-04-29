## Copyright 2023 Jakob Harden (jakob.harden@tugraz.at, Graz University of Technology, Graz, Austria)
## License: MIT
## This file is part of the PhD thesis of Jakob Harden.
## Save project data structure to file (GNU octave binary format)
##
## Usage 1: fio_struct_save(dataset, p_fp), save dataset to GNU octave binary file
##
## Usage 2: fio_struct_save(dataset, p_fp, p_sm), save dataset to GNU octave binary file and metadata to text file
##
## dataset ... data set data structure, <struct>
## p_fp    ... full qualified path to dataset file, <str>
## p_sm    ... save metadata to file, optional, <str>
##               'save_meta_json': ... save metadata in JSON format
##
## see also: fio_struct_load, fio_struct_savemeta
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
function fio_struct_save(dataset, p_fp, p_sm)
  
  ## check arguments
  if (nargin < 3)
    p_sm = 'save_meta_json';
  endif
  if (nargin < 2)
    help fio_struct_save;
    error('Less arguments given');
  endif
  
  ## save dataset to GNU octave binary file
  save('-binary', p_fp, 'dataset');
  
  ## extract and save matadata
  switch (p_sm)
    case {'save_meta_json'} # JSON format
      fp_json = strrep(p_fp, ".oct", ".json");
      struct_exp_metajson(dataset, fp_json);
  endswitch
  
endfunction
