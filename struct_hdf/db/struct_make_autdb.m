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
## Create author database file (GNU octave binary file)
##
## Usage: struct_make_autdb(p_ofp)
##
## p_ofp ... output file path (database file path), optional, <str>
##             default: ./struct_hdf/db/db_aut.oct
##
## item ... author data structure, <struct>
##   .obj ... object type, always "struct_aut", <str>
##   .ver ... version number [major_ver, minor_ver], [<uint>]
##   .d01 ... author id, <ADE/struct>
##   .a01 ... name, <AAE/struct>
##   .a02 ... given name, <AAE/struct>
##   .a03 ... family name, <AAE/struct>
##   .a04 ... initials, <AAE/struct>
##   .a05 ... title before the name, <AAE/struct>
##   .a06 ... title behind the name, <AAE/struct>
##   .a07 ... organization name, <AAE/struct>
##   .a08 ... department name, <AAE/struct>
##   .a09 ... role in organization/department, <AAE/struct>
##   .a10 ... country, <AAE/struct>
##   .a11 ... state or province, <AAE/struct>
##   .a12 ... city, <AAE/struct>
##   .a13 ... zip code, postal code, <AAE/struct>
##   .a14 ... street name, <AAE/struct>
##   .a15 ... email address, <AAE/struct>
##   .a16 ... name identifier type, <AAE/struct>
##   .a17 ... name identifier type URI, <AAE/struct>
##   .a18 ... name identifier, <AAE/struct>
##   .a19 ... author description, <AAE/struct>
##
## see also: init, struct_dataset
##
function [r_ds] = struct_make_autdb(p_ofp)
  
  ## read database file path from global variable, see also init.m
  global dsc_dbpath_aut
  
  ## check arguments
  if (nargin < 1)
    p_ofp = dsc_dbpath_aut;
  endif
  if isempty(p_ofp)
    p_ofp = dsc_dbpath_aut;
  endif
  
  ## init empty data structure
  item_empty.obj = 'struct_aut';
  item_empty.ver = uint16([1, 0]);
  item_empty.d01 = struct_objdata('author_id', 'uint', [], '', 'author id');
  item_empty.a01 = struct_objattrib('name', [], 'full name');
  item_empty.a02 = struct_objattrib('givenname', [], 'given name, first name');
  item_empty.a03 = struct_objattrib('familyname', [], 'family name, surname');
  item_empty.a04 = struct_objattrib('initials', [], 'initials');
  item_empty.a05 = struct_objattrib('title_pfx', [], 'title before the name (prefix)');
  item_empty.a06 = struct_objattrib('title_sfx', [], 'title behind the name (suffix)');
  item_empty.a07 = struct_objattrib('organization', [], 'organization name');
  item_empty.a08 = struct_objattrib('department', [], 'department name');
  item_empty.a09 = struct_objattrib('role', [], 'role in organization/department');
  item_empty.a10 = struct_objattrib('country', [], 'country');
  item_empty.a11 = struct_objattrib('state_province', [], 'state or province');
  item_empty.a12 = struct_objattrib('city', [], 'city name');
  item_empty.a13 = struct_objattrib('zipcode', [], 'zip code, postal code');
  item_empty.a14 = struct_objattrib('street', [], 'street name');
  item_empty.a15 = struct_objattrib('email', [], 'email address');
  item_empty.a16 = struct_objattrib('name_identifier_type', [], 'name identifier type, e.g. ORCID');
  item_empty.a17 = struct_objattrib('name_identifier_type_uri', [], 'name identifier type uri, e.g. https://orcid.org/');
  item_empty.a18 = struct_objattrib('name_identifier', [], 'name identifier, e.g. ORCID id');
  item_empty.a19 = struct_objattrib('description', [], 'author description');
  
  ## author, id = 1
  id = 1;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Harden, Jakob';
  item(id).a02.v = 'Jakob';
  item(id).a03.v = 'Harden';
  item(id).a04.v = 'JH';
  item(id).a05.v = 'Dipl.-Ing.';
  item(id).a06.v = 'BSc.';
  item(id).a07.v = 'Graz University of Technology';
  item(id).a08.v = 'IMBT/TVFA';
  item(id).a09.v = 'University assistant, Junior scientist';
  item(id).a10.v = 'Austria';
  item(id).a11.v = 'Styria';
  item(id).a12.v = 'Graz';
  item(id).a13.v = '8010';
  item(id).a14.v = 'Inffeldgasse 24/I';
  item(id).a15.v = 'jakob.harden@tugraz.at';
  item(id).a16.v = 'ORCID';
  item(id).a17.v = 'https://orcid.org/';
  item(id).a18.v = '0000-0002-5752-1785';
  item(id).a19.v = 'Member of workgroup for non-destructive testing';
  
  ## save structure
  save('-binary', p_ofp, 'item', 'item_empty');
  
endfunction
