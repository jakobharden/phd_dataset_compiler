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
## Create mixture recipe database file (GNU octave binary file)
##
## Usage: struct_make_recdb(p_ofp)
##
## p_ofp ... output file path (database file path), optional, <str>
##             default: ./struct_hdf/db/db_rec.oct
##
## item ... return: mixture recipe data structure, <struct>
##   .obj ... object type, always "struct_rec"
##   .ver ... version number [major_ver, minor_ver], [<uint>]
##   .r01 ... related materials, <ARE/struct>
##   .d01 ... recipe id, <ADE/struct>
##   .a01 ... recipe code, <AAE/struct>
##   .s01 ... mixture components, [<struct>]
##   .s02 ... mixture parameters, [<struct>]
##
## Mixture ID's/Codes:
##    1, WC040_D25_B1: cement paste, d=25mm, wc=0.40, CEM I 42.5 N (batch no. 34A)
##    2, WC045_D25_B1: cement paste, d=25mm, wc=0.45, CEM I 42.5 N (batch no. 34A)
##    3, WC050_D25_B1: cement paste, d=25mm, wc=0.50, CEM I 42.5 N (batch no. 34A)
##    4, WC055_D25_B1: cement paste, d=25mm, wc=0.55, CEM I 42.5 N (batch no. 34A)
##    5, WC060_D25_B1: cement paste, d=25mm, wc=0.60, CEM I 42.5 N (batch no. 34A)
##    6, WC040_D50_B1: cement paste, d=50mm, wc=0.40, CEM I 42.5 N (batch no. 34A)
##    7, WC045_D50_B1: cement paste, d=50mm, wc=0.45, CEM I 42.5 N (batch no. 34A)
##    8, WC050_D50_B1: cement paste, d=50mm, wc=0.50, CEM I 42.5 N (batch no. 34A)
##    9, WC055_D50_B1: cement paste, d=50mm, wc=0.55, CEM I 42.5 N (batch no. 34A)
##   10, WC060_D50_B1: cement paste, d=50mm, wc=0.60, CEM I 42.5 N (batch no. 34A)
##   11, WC040_D70_B1: cement paste, d=70mm, wc=0.40, CEM I 42.5 N (batch no. 34A)
##   12, WC045_D70_B1: cement paste, d=70mm, wc=0.45, CEM I 42.5 N (batch no. 34A)
##   13, WC050_D70_B1: cement paste, d=70mm, wc=0.50, CEM I 42.5 N (batch no. 34A)
##   14, WC055_D70_B1: cement paste, d=70mm, wc=0.55, CEM I 42.5 N (batch no. 34A)
##   15, WC060_D70_B1: cement paste, d=70mm, wc=0.60, CEM I 42.5 N (batch no. 34A)
##   16, WC040_D25_B2: cement paste, d=25mm, wc=0.40, CEM I 42.5 N (batch no. 35A)
##   17, WC045_D25_B2: cement paste, d=25mm, wc=0.45, CEM I 42.5 N (batch no. 35A)
##   18, WC050_D25_B2: cement paste, d=25mm, wc=0.50, CEM I 42.5 N (batch no. 35A)
##   19, WC055_D25_B2: cement paste, d=25mm, wc=0.55, CEM I 42.5 N (batch no. 35A)
##   20, WC060_D25_B2: cement paste, d=25mm, wc=0.60, CEM I 42.5 N (batch no. 35A)
##   21, WC040_D50_B2: cement paste, d=50mm, wc=0.40, CEM I 42.5 N (batch no. 35A)
##   22, WC045_D50_B2: cement paste, d=50mm, wc=0.45, CEM I 42.5 N (batch no. 35A)
##   23, WC050_D50_B2: cement paste, d=50mm, wc=0.50, CEM I 42.5 N (batch no. 35A)
##   24, WC055_D50_B2: cement paste, d=50mm, wc=0.55, CEM I 42.5 N (batch no. 35A)
##   25, WC060_D50_B2: cement paste, d=50mm, wc=0.60, CEM I 42.5 N (batch no. 35A)
##   26, WC040_D70_B2: cement paste, d=70mm, wc=0.40, CEM I 42.5 N (batch no. 35A)
##   27, WC045_D70_B2: cement paste, d=70mm, wc=0.45, CEM I 42.5 N (batch no. 35A)
##   28, WC050_D70_B2: cement paste, d=70mm, wc=0.50, CEM I 42.5 N (batch no. 35A)
##   29, WC055_D70_B2: cement paste, d=70mm, wc=0.55, CEM I 42.5 N (batch no. 35A)
##   30, WC060_D70_B2: cement paste, d=70mm, wc=0.60, CEM I 42.5 N (batch no. 35A)
##
## see also: init, struct_dataset
##
function struct_make_recdb(p_ofp)
  
  ## read database file path from global variable, see also init.m
  global dsc_dbpath_rec
  
  ## check arguments
  if (nargin < 1)
    p_ofp = dsc_dbpath_rec;
  endif
  if isempty(p_ofp)
    p_ofp = dsc_dbpath_rec;
  endif
  
  ## values, often used
  descr1 = 'accuracy = +/- 0.5 g';
  descr2 = 'accuracy = +/- 0.5 g';
  par_descr = 'water-cement-ratio, mass of water divided by mass of cement';
  
  ## recipe id's/codes
  reccodes(1).id = 1;
  reccodes(1).code = 'WC040_D25_B1';
  reccodes(2).id = 2;
  reccodes(2).code = 'WC045_D25_B1';
  reccodes(3).id = 3;
  reccodes(3).code = 'WC050_D25_B1';
  reccodes(4).id = 4;
  reccodes(4).code = 'WC055_D25_B1';
  reccodes(5).id = 5;
  reccodes(5).code = 'WC060_D25_B1';
  reccodes(6).id = 6;
  reccodes(6).code = 'WC040_D50_B1';
  reccodes(7).id = 7;
  reccodes(7).code = 'WC045_D50_B1';
  reccodes(8).id = 8;
  reccodes(8).code = 'WC050_D50_B1';
  reccodes(9).id = 9;
  reccodes(9).code = 'WC055_D50_B1';
  reccodes(10).id = 10;
  reccodes(10).code = 'WC060_D50_B1';
  reccodes(11).id = 11;
  reccodes(11).code = 'WC040_D70_B1';
  reccodes(12).id = 12;
  reccodes(12).code = 'WC045_D70_B1';
  reccodes(13).id = 13;
  reccodes(13).code = 'WC050_D70_B1';
  reccodes(14).id = 14;
  reccodes(14).code = 'WC055_D70_B1';
  reccodes(15).id = 15;
  reccodes(15).code = 'WC060_D70_B1';
  reccodes(16).id = 16;
  reccodes(16).code = 'WC040_D25_B2';
  reccodes(17).id = 17;
  reccodes(17).code = 'WC045_D25_B2';
  reccodes(18).id = 18;
  reccodes(18).code = 'WC050_D25_B2';
  reccodes(19).id = 19;
  reccodes(19).code = 'WC055_D25_B2';
  reccodes(20).id = 20;
  reccodes(20).code = 'WC060_D25_B2';
  reccodes(21).id = 21;
  reccodes(21).code = 'WC040_D50_B2';
  reccodes(22).id = 22;
  reccodes(22).code = 'WC045_D50_B2';
  reccodes(23).id = 23;
  reccodes(23).code = 'WC050_D50_B2';
  reccodes(24).id = 24;
  reccodes(24).code = 'WC055_D50_B2';
  reccodes(25).id = 25;
  reccodes(25).code = 'WC060_D50_B2';
  reccodes(26).id = 26;
  reccodes(26).code = 'WC040_D70_B2';
  reccodes(27).id = 27;
  reccodes(27).code = 'WC045_D70_B2';
  reccodes(28).id = 28;
  reccodes(28).code = 'WC050_D70_B2';
  reccodes(29).id = 29;
  reccodes(29).code = 'WC055_D70_B2';
  reccodes(30).id = 30;
  reccodes(30).code = 'WC060_D70_B2';
  
  ## init empty data structure
  item_empty.obj = 'struct_rec';
  item_empty.ver = uint16([1, 0]);
  item_empty.d01 = struct_objdata('recipe_id', 'uint', [], [], 'recipe id');
  item_empty.a01 = struct_objattrib('recipe_code', [], 'recipe code');
  item_empty.s01 = []; # mixture components
  item_empty.s02 = []; # mixture parameters
  
  ## recipe, id = 1
  id = 1;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 320.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(2, 800.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.40, [], par_descr);
  
  ## recipe, id = 2
  id = 2;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 360.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(2, 800.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.45, [], par_descr);
  
  ## recipe, id = 3
  id = 3;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 400.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(2, 800.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.50, [], par_descr);
  
  ## recipe, id = 4
  id = 4;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 440.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(2, 800.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.55, [], par_descr);
  
  ## recipe, id = 5
  id = 5;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 480.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(2, 800.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.60, [], par_descr);
  
  ## recipe, id = 6
  id = 6;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 640.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(2, 1600.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.40, [], par_descr);
  
  ## recipe, id = 7
  id = 7;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 720.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(2, 1600.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.45, [], par_descr);
  
  ## recipe, id = 8
  id = 8;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 800.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(2, 1600.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.50, [], par_descr);
  
  ## recipe, id = 9
  id = 9;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 880.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(2, 1600.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.55, [], par_descr);
  
  ## recipe, id = 10
  id = 10;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 960.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(2, 1600.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.60, [], par_descr);
  
  ## recipe, id = 11
  id = 11;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 880.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(2, 2200.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.40, [], par_descr);
  
  ## recipe, id = 12
  id = 12;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 990.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(2, 2200.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.45, [], par_descr);
  
  ## recipe, id = 13
  id = 13;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 1100.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(2, 2200.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.50, [], par_descr);
  
  ## recipe, id = 14
  id = 14;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 1210.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(2, 2200.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.55, [], par_descr);
  
  ## recipe, id = 15
  id = 15;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 1320.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(2, 2200.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.60, [], par_descr);
      
  
  ## recipe, id = 16
  id = 16;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 320.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(3, 800.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.40, [], par_descr);
  
  ## recipe, id = 17
  id = 17;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 360.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(3, 800.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.45, [], par_descr);
  
  ## recipe, id = 18
  id = 18;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 400.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(3, 800.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.50, [], par_descr);
  
  ## recipe, id = 19
  id = 19;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 440.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(3, 800.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.55, [], par_descr);
  
  ## recipe, id = 20
  id = 20;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 480.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(3, 800.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.60, [], par_descr);
  
  ## recipe, id = 21
  id = 21;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 640.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(3, 1600.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.40, [], par_descr);
  
  ## recipe, id = 22
  id = 22;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 720.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(3, 1600.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.45, [], par_descr);
  
  ## recipe, id = 23
  id = 23;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 800.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(3, 1600.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.50, [], par_descr);
  
  ## recipe, id = 24
  id = 24;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 880.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(3, 1600.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.55, [], par_descr);
  
  ## recipe, id = 25
  id = 25;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 960.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(3, 1600.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.60, [], par_descr);
  
  ## recipe, id = 26
  id = 26;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 880.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(3, 2200.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.40, [], par_descr);
  
  ## recipe, id = 27
  id = 27;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 990.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(3, 2200.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.45, [], par_descr);
  
  ## recipe, id = 28
  id = 28;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 1100.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(3, 2200.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.50, [], par_descr);
  
  ## recipe, id = 29
  id = 29;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 1210.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(3, 2200.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.55, [], par_descr);
  
  ## recipe, id = 30
  id = 30;
  item(id) = item_empty;
  item(id).d01.v = reccodes(id).id;
  item(id).a01.v = reccodes(id).code;
  [item(id).s01(1), ~] = struct_mix_component(1, 1320.0, descr1);
  [item(id).s01(2), ~] = struct_mix_component(3, 2200.0, descr2);
  item(id).s02(1) = struct_objdata('w/c-ratio', 'double', 0.60, [], par_descr);
  
  ## save structure
  save('-binary', p_ofp, 'item', 'item_empty', 'reccodes');
  
endfunction
