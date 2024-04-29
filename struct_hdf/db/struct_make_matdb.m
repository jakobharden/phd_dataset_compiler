## Create material database file (GNU octave binary file)
##
## Usage: struct_make_matdb(p_ofp)
##
## p_ofp ... output file path (database file path), optional, <str>
##             default: ./struct_hdf/db/db_mat.oct
##
## item ... database item, <struct>
##   .obj ... object type, always "struct_mat", <str>
##   .ver ... version number [major_ver, minor_ver], [<uint>]
##   .d01 ... material id, <ADE/struct>
##   .a01 ... material name, <AAE/struct>
##   .a02 ... vendor name, <AAE/struct>
##   .a03 ... product name, <AAE/struct>
##   .a04 ... material category, <AAE/struct>
##   .a05 ... material description, <AAE/struct>
##   .a06 ... material storage place, <AAE/struct>
##   .a07 ... material storage condition, <AAE/struct>
##   .s01 ... materiala property structure array, content depends on material, [<struct>]
##
## see also: init, struct_dataset
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
function struct_make_matdb(p_ofp)
  
  ## read database file path from global variable, see also init.m
  global dsc_dbpath_mat
  
  ## check arguments
  if (nargin < 1)
    p_ofp = dsc_dbpath_mat;
  endif
  if isempty(p_ofp)
    p_ofp = dsc_dbpath_mat;
  endif
  
  ## init empty data structure
  item_empty.obj = 'struct_mat';
  item_empty.ver = uint16([1, 0]);
  item_empty.d01 = struct_objdata('material_id', 'uint', [], '', 'material id');
  item_empty.a01 = struct_objattrib('name', [], 'material name');
  item_empty.a02 = struct_objattrib('vendor', [], 'vendor name');
  item_empty.a03 = struct_objattrib('product', [], 'product name');
  item_empty.a04 = struct_objattrib('category', [], 'material category');
  item_empty.a05 = struct_objattrib('description', [], 'material description');
  item_empty.a06 = struct_objattrib('storage_place', [], 'material storage place');
  item_empty.a07 = struct_objattrib('storage_condition', [], 'material storage condition');
  item_empty.s01 = [];
  
  ## Water from tap, id = 1
  id = 1;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = "Water";
  item(id).a02.v = "Holding Graz - water supply system (Graz, Austria)";
  item(id).a03.v = "tap water";
  item(id).a04.v = "water, liquid";
  item(id).a05.v = "tap water from the laboratory water supply system";
  item(id).a06.v = 'water container connected to laboratory water supply system';
  item(id).a07.v = 'room temperature';
  
  ## CEM I, batch 34A, id = 2
  id = 2;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = "CEMI34A";
  item(id).a02.v = "VOeZ - Vereinigung der Oesterreichischen Zementindustrie (Vienna, Austria)";
  item(id).a03.v = "Ordinary Portland Cement, CEM I-42.5 N, batch no. 34A";
  item(id).a04.v = "cement, powder";
  item(id).a05.v = "n.n.";
  item(id).a06.v = 'laboratory room, plastic bag inside a plastic cask';
  item(id).a07.v = 'laboratory room temperature';
  item(id).s01(1) = struct_objdata('class', 'string', 'Ordinary Portland Cement (OPC)', [], 'cement class');
  item(id).s01(2) = struct_objdata('type', 'string', 'EN 197-1 -- CEM I - 42.5 N', [], 'cement type');
  item(id).s01(3) = struct_objdata('batch_number', 'string', '34A', [], 'production batch number');
  item(id).s01(4) = struct_objdata('chemical_info', 'string', 'low-grade chromate', [], 'chemical information');
  item(id).s01(5) = struct_objdata('standard', 'string', 'OeNORM EN 197-1', [], 'related standard document identifier');
  
  ## CEM I, batch 35A, id = 3
  id = 3;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = "CEMI35A";
  item(id).a02.v = "VOeZ - Vereinigung der Oesterreichischen Zementindustrie (Vienna, Austria)";
  item(id).a03.v = "Ordinary Portland Cement, CEM I-42.5 N, batch no. 35A";
  item(id).a04.v = "cement, powder";
  item(id).a05.v = "n.n.";
  item(id).a06.v = 'laboratory room, plastic bag inside a plastic cask';
  item(id).a07.v = 'laboratory room temperature';
  item(id).s01(1) = struct_objdata('class', 'string', 'Ordinary Portland Cement (OPC)', [], 'cement class');
  item(id).s01(2) = struct_objdata('type', 'string', 'EN 197-1 -- CEM I - 42.5 N', [], 'cement type');
  item(id).s01(3) = struct_objdata('batch_number', 'string', '35A', [], 'production batch number');
  item(id).s01(4) = struct_objdata('chemical_info', 'string', 'low-grade chromate', [], 'chemical information');
  item(id).s01(5) = struct_objdata('standard', 'string', 'OeNORM EN 197-1', [], 'related standard document identifier');
  
  ## Air, id = 4
  id = 4;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = "Air";
  item(id).a02.v = "n.n.";
  item(id).a03.v = "Room air";
  item(id).a04.v = "air, aeriform";
  item(id).a05.v = "room air between actuator and sensor";
  item(id).a06.v = 'laboratory room';
  item(id).a07.v = 'laboratory room temperature';
  
  ## Water from tap, id = 5
  id = 5;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = "Water in rubber baloon";
  item(id).a02.v = "Holding Graz - water supply system (Graz, Austria)";
  item(id).a03.v = "tap water";
  item(id).a04.v = "water, liquid";
  item(id).a05.v = "tap water from the laboratory water supply system contained in a rubber baloon";
  item(id).a06.v = 'water container connected to laboratory water supply system';
  item(id).a07.v = 'laboratory room temperature';
  
  ## Aluminium, id = 6
  id = 6;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = "Aluminium";
  item(id).a02.v = "n.n.";
  item(id).a03.v = "Aluminium cylinder";
  item(id).a04.v = "aluminium, solid";
  item(id).a05.v = "Shaped by D. Reiter (TU-Graz)";
  item(id).a06.v = 'laboratory room';
  item(id).a07.v = 'laboratory room temperature';
  item(id).s01(1) = struct_objdata('shape', 'string', 'Cylinder', '', 'specimen shape');
  item(id).s01(2) = struct_objdata('diameter', 'double', 48.01, 'mm', 'specimen diameter');
  item(id).s01(3) = struct_objdata('height', 'double', 49.80, 'mm', 'specimen height');
  item(id).s01(4) = struct_objdata('weight', 'double', 125.0, 'g', 'specimen weight');
  
  ## No material used, face-to-face test, id = 7
  id = 7;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = "Unused";
  item(id).a02.v = "n.n.";
  item(id).a03.v = "n.n.";
  item(id).a04.v = "n.n.";
  item(id).a05.v = "No material used! This is a face-to-face test. Actuator and sensor are directly connected to each other.";
  item(id).a06.v = 'n.n.';
  item(id).a07.v = 'n.n.';

  ## save structure
  save('-binary', p_ofp, 'item', 'item_empty');
  
endfunction
