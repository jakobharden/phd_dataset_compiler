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
## Create license information database file (GNU octave binary file)
##
## Usage: struct_make_licdb(p_ofp)
##
## p_ofp ... output file path (database file path), optional, <str>
##             default: ./struct_hdf/db/db_lic.oct
##
## item ... license data structure, <struct>
##   .obj ... object type, always "struct_lic", <str>
##   .ver ... version number [major_ver, minor_ver], [<uint>]
##   .r01 ... author reference, <ARE/struct>
##   .d01 ... license id, <ADE/struct>
##   .a01 ... license code, <AAE/struct>
##   .a02 ... rights holder, <AAE/struct>
##   .a03 ... rights, <AAE/struct>
##   .a04 ... rights URI, <AAE/struct>
##   .a05 ... rights identifier scheme, <AAE/struct>
##   .a06 ... rights identifier scheme URI, <AAE/struct>
##   .a07 ... license description, <AAE/struct>
##   .a08 ... license icon (spdx), <AAE/struct>
##   .a09 ... license id (spdx), <AAE/struct>
##
## see also: init, struct_dataset
##
function [r_ds] = struct_make_licdb(p_ofp)
  
  ## read database file path from global variable, see also init.m
  global dsc_dbpath_lic
  
  ## check arguments
  if (nargin < 1)
    p_ofp = dsc_dbpath_lic;
  endif
  if isempty(p_ofp)
    p_ofp = dsc_dbpath_lic;
  endif
  
  ## init empty data structure
  item_empty.obj = 'struct_lic';
  item_empty.ver = uint16([1, 0]);
  item_empty.r01 = struct_objref('author', [], 'aut', 'author reference');
  item_empty.d01 = struct_objdata('license_id', 'uint', [], [], 'license id');
  item_empty.a01 = struct_objattrib('license_code', [], 'license code');
  item_empty.a02 = struct_objattrib('rightsholder', [], 'rights holder');
  item_empty.a03 = struct_objattrib('rights', [], 'rights description, e.g. Creative Commons Attribution 4.0 International');
  item_empty.a04 = struct_objattrib('rights_uri', [], 'rights URI, e.g. https://spdx.org/licenses/CC-BY-4.0.html');
  item_empty.a05 = struct_objattrib('rights_identifier_scheme', [], 'rights identifier scheme, e.g. SPDX');
  item_empty.a06 = struct_objattrib('rights_identifier_scheme_uri', [], 'rights identifier scheme URI, e.g. https://spdx.org/licenses/');
  item_empty.a07 = struct_objattrib('license_description', [], 'license description');
  item_empty.a08 = struct_objattrib('spdx_icon', [], 'license icon (spdx)');
  item_empty.a09 = struct_objattrib('spdx_id', [], 'license id (spdx)');
  
  ## license: all rights reserved, id = 1
  id = 1;
  item(id) = item_empty;
  item(id).r01.i = 1;
  item(id).d01.v = id;
  item(id).a01.v = 'Copyright (C)';
  item(id).a02.v = 'Graz University of Technology (Graz, Austria)';
  item(id).a03.v = 'All rights reserved';
  item(id).a04.v = 'https://www.tugraz.at/home/';
  item(id).a05.v = 'n.n.';
  item(id).a06.v = 'n.n.';
  item(id).a07.v = 'This material must not be used for any purpose without explicit permission of author and rightsholder.';
  item(id).a08.v = 'copyright';
  item(id).a09.v = 'copyright';
  
  ## license: creative commons CC-BY-4.0, id = 2
  id = 2;
  item(id) = item_empty;
  item(id).r01.i = 1;
  item(id).d01.v = id;
  item(id).a01.v = 'CC-BY-4.0';
  item(id).a02.v = 'Graz University of Technology (Graz, Austria)';
  item(id).a03.v = 'Creative Commons Attribution 4.0 International';
  item(id).a04.v = 'https://spdx.org/licenses/CC-BY-4.0.html';
  item(id).a05.v = 'SPDX';
  item(id).a06.v = 'https://spdx.org/licenses/';
  item(id).a07.v = "You are free to: Share - copy and redistribute the material in any medium or format. Adapt - remix, transform, and \
build upon the material for any purpose, even commercially. The licensor cannot revoke these freedoms as long as you follow the license \
terms. \
Under the following terms: Attribution - You must give appropriate credit, provide a link to the license, and indicate if changes were \
made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use. \
No additional restrictions - You may not apply legal terms or technological measures that legally restrict others from doing anything the \
license permits.";
  item(id).a08.v = 'cc-by-icon';
  item(id).a09.v = 'cc-by-4.0';
  
  ## license: creative commons CC-BY-SA-4.0, id = 3
  id = 3;
  item(id) = item_empty;
  item(id).r01.i = 1;
  item(id).d01.v = id;
  item(id).a01.v = 'CC-BY-SA-4.0';
  item(id).a02.v = 'Graz University of Technology (Graz, Austria)';
  item(id).a03.v = 'Creative Commons Attribution Share Alike 4.0 International';
  item(id).a04.v = 'https://spdx.org/licenses/CC-BY-SA-4.0.html';
  item(id).a05.v = 'SPDX';
  item(id).a06.v = 'https://spdx.org/licenses/';
  item(id).a07.v = "You are free to: Share - copy and redistribute the material in any medium or format. Adapt - remix, transform, \
and build upon the material for any purpose, even commercially. \
Under the following terms: Attribution - You must give appropriate credit, provide a link to the license, and indicate if changes were \
made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use. \
ShareAlike - If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the \
original. No additional restrictions - You may not apply legal terms or technological measures that legally restrict others from doing \
anything the license permits.";
  item(id).a08.v = 'cc-by-sa-icon';
  item(id).a09.v = 'cc-by-sa-4.0';
  
  ## save structure
  save('-binary', p_ofp, 'item', 'item_empty');
  
endfunction
