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
## Usage: struct_make_locdb(p_ofp)
##
## p_ofp ... output file path (database file path), optional, <str>
##             default: ./struct_hdf/db/db_loc.oct
##
## item ... location data structure, <struct>
##   .obj ... object type, always "struct_loc", <str>
##   .ver ... version number [major_ver, minor_ver], [<uint>]
##   .d01 ... location id, <ADE/struct>
##   .d02 ... geo location, <ADE/struct>
##   .a01 ... country, <AAE/struct>
##   .a02 ... state or province, <AAE/struct>
##   .a03 ... zip code, postal code, <AAE/struct>
##   .a04 ... city, <AAE/struct>
##   .a05 ... street, <AAE/struct>
##   .a06 ... house number, <AAE/struct>
##   .a07 ... location description, <AAE/struct>

##
## see also: init, struct_dataset
##
function [r_ds] = struct_make_locdb(p_ofp)
  
  ## read database file path from global variable, see also init.m
  global dsc_dbpath_loc
  
  ## check arguments
  if (nargin < 1)
    p_ofp = dsc_dbpath_loc;
  endif
  if isempty(p_ofp)
    p_ofp = dsc_dbpath_loc;
  endif
  
  ## init empty data structure
  item_empty.obj = 'struct_loc';
  item_empty.ver = uint16([1, 0]);
  item_empty.d01 = struct_objdata('location_id', 'uint', [], '', 'location id');
  item_empty.d02 = struct_objdata('geolocation', 'double_arr', [], 'deg', 'geo location, latitude, longitude');
  item_empty.a01 = struct_objattrib('country', [], 'country');
  item_empty.a02 = struct_objattrib('state_province', [], 'state or province');
  item_empty.a03 = struct_objattrib('city', [], 'city');
  item_empty.a04 = struct_objattrib('zipcode', [], 'zip code, postal code');
  item_empty.a05 = struct_objattrib('street', [], 'street name');
  item_empty.a06 = struct_objattrib('housenumber', [], 'house number');
  item_empty.a07 = struct_objattrib('description', [], 'location description');
  
  
  ## location: Inffeldgasse 24, 8010, Graz, Austria, id = 1
  id = 1;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).d02.v = [47.057675191423556, 15.456957633627812];
  item(id).a01.v = 'Austria';
  item(id).a02.v = 'Styria';
  item(id).a03.v = 'Graz';
  item(id).a04.v = '8010';
  item(id).a05.v = 'Inffeldgasse';
  item(id).a06.v = '24';
  item(id).a07.v = 'Cement-Lab, Concrete-Lab';
  
  
  ## save structure
  save('-binary', p_ofp, 'item', 'item_empty');
  
endfunction
