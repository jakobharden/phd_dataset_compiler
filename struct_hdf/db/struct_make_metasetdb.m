## Create data set metadata database file (GNU octave binary file)
##
## Usage: struct_make_metasetdb(p_ofp)
##
## p_ofp ... output file path (database file path), optional, <str>
##             default: ./struct_hdf/db/db_metaset.oct
##
## item ... return: dataset matadata structure, <struct>
##   .obj ... object type, always "struct_metaset"
##   .ver ... version number [major_ver, minor_ver], [<uint>]
##   .r01 ... author reference, <ARE/struct>
##   .r02 ... test series reference, <ARE/struct>
##   .r03 ... location reference, <ARE/struct>
##   .r04 ... license reference, <ARE/struct>
##   .d01 ... data set id, <ADE/struct>
##   .a01 ... data set code, <AAE/struct>
##   .a02 ... data set name, <AAE/struct>
##   .a03 ... description, general, <AAE/struct>
##   .a04 ... description, abstract, [<AAE/struct>]
##   .a05 ... description, methods, [<AAE/struct>]
##   .a06 ... description, tableofcontents, [<AAE/struct>]
##   .a07 ... data set creator name, <AAE/struct>
##   .a08 ... data set collector name, <AAE/struct>
##   .a09 ... data set copyrighter name, <AAE/struct>
##   .a10 ... date created, <AAE/struct>
##   .a11 ... date collected, <AAE/struct>
##   .a12 ... date copyrighted, <AAE/struct>
##   .a13 ... data set size, number of files, <AAE/struct>
##   .a14 ... data set file format, <AAE/struct>
##   .a15 ... data set version, <AAE/struct>
##   .a16 ... data set context, <AAE/struct>
##   .a17 ... data set rawdata directory, <AAE/struct>
##   .a18 ... data set rawdata archive, <AAE/struct>
##
## see also: init, struct_dataset, struct_make_metaserdb
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
function struct_make_metasetdb(p_ofp)
  
  ## read database file path from global variable, see also init.m
  global dsc_dbpath_metaset
  
  ## check arguments
  if (nargin < 1)
    p_ofp = dsc_dbpath_metaset;
  endif
  if isempty(p_ofp)
    p_ofp = dsc_dbpath_metaset;
  endif
  
  ## empty item
  item_empty.obj = 'struct_metaset';
  item_empty.ver = uint16([1, 0]);
  item_empty.r01 = struct_objref('author', [], 'aut', 'author reference');
  item_empty.r02 = struct_objref('series', [], 'meta_ser', 'test series reference');
  item_empty.r03 = struct_objref('location', [], 'loc', 'location reference');
  item_empty.r04 = struct_objref('license', [], 'lic', 'license reference');
  item_empty.d01 = struct_objdata('dataset_id', 'uint', [], [], 'data set id');
  item_empty.a01 = struct_objattrib('dataset_code', [], 'data set code');
  item_empty.a02 = struct_objattrib('dataset_name', [], 'data set name');
  item_empty.a03 = struct_objattrib('description', [], 'description, general');
  item_empty.a04 = struct_objattrib('description_abstract', [], 'description, abstract');
  item_empty.a05 = struct_objattrib('description_methods', [], 'description, methods');
  item_empty.a06 = struct_objattrib('description_tableofcontents', [], 'description, tableofcontents');
  item_empty.a07 = struct_objattrib('created_by', [], 'data set creator name');
  item_empty.a08 = struct_objattrib('collected_by', [], 'data set collector name');
  item_empty.a09 = struct_objattrib('copyrighted_by', [], 'data set copyrighter name');
  item_empty.a10 = struct_objattrib('date_created', [], 'date created');
  item_empty.a11 = struct_objattrib('date_collected', [], 'date collected');
  item_empty.a12 = struct_objattrib('date_copyrighted', [], 'date copyrighted');
  item_empty.a13 = struct_objattrib('size', [], 'data set size, number of files');
  item_empty.a14 = struct_objattrib('format', [], 'data set file format');
  item_empty.a15 = struct_objattrib('version', [], 'data set version');
  item_empty.a16 = struct_objattrib('context', [], 'data set context');
  item_empty.a17 = struct_objattrib('rawdata_directory', [], 'data set rawdata directory');
  item_empty.a18 = struct_objattrib('rawdata_archive', [], 'data set rawdata archive');
  
  ## pre-init item, all data sets
  item_pre = item_empty;
  item_pre.r01.i = 1;
  item_pre.r03.i = 1;
  item_pre.r04.i = 2;
  item_pre.a03.v = "The data set was compiled with GNU octave 6.2.0 using the built in binary file format (*.oct).";
  item_pre.a07.v = "Harden, Jakob (jakob.harden@tugraz.at)";
  item_pre.a08.v = item_pre.a07.v;
  item_pre.a09.v = item_pre.a07.v;
  item_pre.a11.v = '2023-01-03';
  item_pre.a12.v = item_pre.a11.v;
  item_pre.a13.v = "1 file";
  item_pre.a14.v = "application/octet-stream";
  item_pre.a15.v = "1.0";
  item_pre.a16.v = "This data set is part of the PhD thesis of Jakob Harden.";
  
  ## pre-init item, test series 1, cement pastes, compression/shear wave sensor f_res = 250 kHz
  item_pre_ts1 = item_pre;
  item_pre_ts1.r02.i = 1;
  item_pre_ts1.a05.v = {"Ultrasonic pulse transmission tests (combined compression- and shear wave measurements)", ...
    "Density tests (gravimetric)", "Distance measurements", "Temperature tests (thermocouples, temperature logger)"};
  
  ## pre-init item, test series 2, cement pastes, hydration temperature
  item_pre_ts2 = item_pre;
  item_pre_ts2.r02.i = 2;
  item_pre_ts2.a05.v = {"Hydration temperature tests (thermocouples, temperature logger)"};
  
  ## pre-init item, test series 3, reference tests, compression wave sensor f_res = 500 kHz, shear wave sensor f_res = 110 kHz
  item_pre_ts3 = item_pre;
  item_pre_ts3.r02.i = 3;
  item_pre_ts3.a05.v = {"Ultrasonic pulse transmission tests (combined compression- and shear wave measurements)", ...
    "Distance measurements", "Room temperature and humidity test (temperature/humidity logger)"};

  ## pre-init item, test series 4, cement pastes, compression wave sensor f_res = 500 kHz, shear wave sensor f_res = 110 kHz
  item_pre_ts4 = item_pre;
  item_pre_ts4.r02.i = 4;
  item_pre_ts4.a05.v = {"Ultrasonic pulse transmission tests (combined compression- and shear wave measurements)", ...
    "Density tests (gravimetric)", "Distance measurements", "Temperature tests (thermocouples, temperature logger)"};
  
  ## pre-init item, test series 5, room air
  item_pre_ts5 = item_pre;
  item_pre_ts5.r02.i = 5;
  item_pre_ts5.a05.v = {"Ultrasonic pulse transmission tests (combined compression- and shear wave measurements)", ...
    "Distance measurements", "Room temperature and humidity test (temperature/humidity logger)"};
  
  ## pre-init item, test series 6, water in a rubber baloon
  item_pre_ts6 = item_pre;
  item_pre_ts6.r02.i = 6;
  item_pre_ts6.a05.v = {"Ultrasonic pulse transmission tests (combined compression- and shear wave measurements)", ...
    "Distance measurements", "Room temperature test (temperature logger)"};

  ## pre-init item, test series 7, aluminium cylinder
  item_pre_ts7 = item_pre;
  item_pre_ts7.r02.i = 7;
  item_pre_ts7.a05.v = {"Ultrasonic pulse transmission tests (combined compression- and shear wave measurements)", ...
    "Distance measurements", "Room temperature test (temperature logger)"};
  
  ## init item id
  id = 1;

  ## Test series 1, cement paste tests
  ## c-wave sensor f_res = 500 kHz
  ## s-wave sensor f_res = 500 kHz
  ipre = item_pre_ts1;
  ip1 = {"w/c-ratio = 0.60", "w/c-ratio = 0.55", "w/c-ratio = 0.50", "w/c-ratio = 0.45", "w/c-ratio = 0.40"};
  ip2 = {"distance = 25mm", "distance = 50mm", "distance = 70mm"};
  ip3 = {"pass = 1", "pass = 2", "pass = 3", "pass = 4", "pass = 5", "pass = 6"};
  item(id) = hlp_dsparam(ipre, id, "ts1_wc060_d25_1", "2020-03-10", ip1{1}, ip2{1}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc060_d25_2", "2020-03-11", ip1{1}, ip2{1}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc060_d25_3", "2020-03-12", ip1{1}, ip2{1}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc060_d25_4", "2020-07-28", ip1{1}, ip2{1}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc060_d25_5", "2020-10-07", ip1{1}, ip2{1}, ip3{5}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc060_d25_6", "2021-03-29", ip1{1}, ip2{1}, ip3{6}); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts1_wc060_d50_1", "2020-03-13", ip1{1}, ip2{2}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc060_d50_2", "2020-03-14", ip1{1}, ip2{2}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc060_d50_3", "2020-03-15", ip1{1}, ip2{2}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc060_d50_4", "2020-07-27", ip1{1}, ip2{2}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc060_d50_5", "2020-10-22", ip1{1}, ip2{2}, ip3{5}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc060_d50_6", "2021-03-22", ip1{1}, ip2{2}, ip3{6}); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts1_wc060_d70_1", "2020-03-16", ip1{1}, ip2{3}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc060_d70_2", "2020-03-17", ip1{1}, ip2{3}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc060_d70_3", "2020-03-18", ip1{1}, ip2{3}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc060_d70_4", "2020-07-21", ip1{1}, ip2{3}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc060_d70_5", "2020-12-29", ip1{1}, ip2{3}, ip3{5}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc060_d70_6", "2021-03-11", ip1{1}, ip2{3}, ip3{6}); id = id + 1;

  item(id) = hlp_dsparam(ipre, id, "ts1_wc055_d25_1", "2020-03-23", ip1{2}, ip2{1}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc055_d25_2", "2020-03-24", ip1{2}, ip2{1}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc055_d25_3", "2020-03-25", ip1{2}, ip2{1}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc055_d25_4", "2020-07-12", ip1{2}, ip2{1}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc055_d25_5", "2020-10-06", ip1{2}, ip2{1}, ip3{5}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc055_d25_6", "2021-03-28", ip1{2}, ip2{1}, ip3{6}); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts1_wc055_d50_1", "2020-03-26", ip1{2}, ip2{2}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc055_d50_2", "2020-03-27", ip1{2}, ip2{2}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc055_d50_3", "2020-03-28", ip1{2}, ip2{2}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc055_d50_4", "2020-07-23", ip1{2}, ip2{2}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc055_d50_5", "2020-10-19", ip1{2}, ip2{2}, ip3{5}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc055_d50_6", "2021-03-21", ip1{2}, ip2{2}, ip3{6}); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts1_wc055_d70_1", "2020-03-29", ip1{2}, ip2{3}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc055_d70_2", "2020-03-30", ip1{2}, ip2{3}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc055_d70_3", "2020-03-31", ip1{2}, ip2{3}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc055_d70_4", "2020-07-15", ip1{2}, ip2{3}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc055_d70_5", "2020-12-31", ip1{2}, ip2{3}, ip3{5}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc055_d70_6", "2021-03-09", ip1{2}, ip2{3}, ip3{6}); id = id + 1;

  item(id) = hlp_dsparam(ipre, id, "ts1_wc050_d25_1", "2020-04-05", ip1{3}, ip2{1}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc050_d25_2", "2020-04-06", ip1{3}, ip2{1}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc050_d25_3", "2020-04-07", ip1{3}, ip2{1}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc050_d25_4", "2020-07-10", ip1{3}, ip2{1}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc050_d25_5", "2020-10-05", ip1{3}, ip2{1}, ip3{5}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc050_d25_6", "2021-03-26", ip1{3}, ip2{1}, ip3{6}); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts1_wc050_d50_1", "2020-04-02", ip1{3}, ip2{2}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc050_d50_2", "2020-04-03", ip1{3}, ip2{2}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc050_d50_3", "2020-04-04", ip1{3}, ip2{2}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc050_d50_4", "2020-07-09", ip1{3}, ip2{2}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc050_d50_5", "2020-10-13", ip1{3}, ip2{2}, ip3{5}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc050_d50_6", "2021-03-18", ip1{3}, ip2{2}, ip3{6}); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts1_wc050_d70_1", "2020-04-08", ip1{3}, ip2{3}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc050_d70_2", "2020-04-10", ip1{3}, ip2{3}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc050_d70_3", "2020-04-11", ip1{3}, ip2{3}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc050_d70_4", "2020-07-14", ip1{3}, ip2{3}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc050_d70_5", "2021-01-04", ip1{3}, ip2{3}, ip3{5}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc050_d70_6", "2021-03-08", ip1{3}, ip2{3}, ip3{6}); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts1_wc045_d25_1", "2020-09-25", ip1{4}, ip2{1}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc045_d25_2", "2020-09-30", ip1{4}, ip2{1}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc045_d25_3", "2020-10-01", ip1{4}, ip2{1}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc045_d25_4", "2020-09-29", ip1{4}, ip2{1}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc045_d25_5", "2020-12-28", ip1{4}, ip2{1}, ip3{5}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc045_d25_6", "2021-03-25", ip1{4}, ip2{1}, ip3{6}); id = id + 1;

  item(id) = hlp_dsparam(ipre, id, "ts1_wc045_d50_1", "2020-08-31", ip1{4}, ip2{2}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc045_d50_2", "2020-09-01", ip1{4}, ip2{2}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc045_d50_3", "2020-09-02", ip1{4}, ip2{2}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc045_d50_4", "2020-10-12", ip1{4}, ip2{2}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc045_d50_5", "2020-12-21", ip1{4}, ip2{2}, ip3{5}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc045_d50_6", "2021-03-17", ip1{4}, ip2{2}, ip3{6}); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts1_wc045_d70_1", "2020-09-15", ip1{4}, ip2{3}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc045_d70_2", "2020-09-16", ip1{4}, ip2{3}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc045_d70_3", "2020-09-17", ip1{4}, ip2{3}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc045_d70_4", "2021-01-07", ip1{4}, ip2{3}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc045_d70_5", "2021-02-03", ip1{4}, ip2{3}, ip3{5}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc045_d70_6", "2021-03-04", ip1{4}, ip2{3}, ip3{6}); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts1_wc040_d25_1", "2020-09-21", ip1{5}, ip2{1}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc040_d25_2", "2020-09-22", ip1{5}, ip2{1}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc040_d25_3", "2020-09-23", ip1{5}, ip2{1}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc040_d25_4", "2020-09-28", ip1{5}, ip2{1}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc040_d25_5", "2020-12-22", ip1{5}, ip2{1}, ip3{5}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc040_d25_6", "2021-03-24", ip1{5}, ip2{1}, ip3{6}); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts1_wc040_d50_1", "2020-07-29", ip1{5}, ip2{2}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc040_d50_2", "2020-08-27", ip1{5}, ip2{2}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc040_d50_3", "2020-08-28", ip1{5}, ip2{2}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc040_d50_4", "2020-10-08", ip1{5}, ip2{2}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc040_d50_5", "2020-12-20", ip1{5}, ip2{2}, ip3{5}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc040_d50_6", "2021-03-15", ip1{5}, ip2{2}, ip3{6}); id = id + 1;

  item(id) = hlp_dsparam(ipre, id, "ts1_wc040_d70_1", "2020-09-07", ip1{5}, ip2{3}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc040_d70_2", "2020-09-08", ip1{5}, ip2{3}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc040_d70_3", "2020-09-14", ip1{5}, ip2{3}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc040_d70_4", "2021-02-01", ip1{5}, ip2{3}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc040_d70_5", "2021-02-03", ip1{5}, ip2{3}, ip3{5}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts1_wc040_d70_6", "2021-03-03", ip1{5}, ip2{3}, ip3{6}); id = id + 1;
  
  ## Test series 2
  ipre = item_pre_ts2;
  ip1 = {"w/c-ratio = 0.40", "w/c-ratio = 0.50", "w/c-ratio = 0.55", "w/c-ratio = 0.60"};
  ip2 = {"distance = 50mm"};
  item(id) = hlp_dsparam(ipre, id, "ts2_wc040_d50", "2020-07-20", ip1{1}, ip2{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts2_wc050_d50", "2020-07-18", ip1{2}, ip2{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts2_wc055_d50", "2020-07-22", ip1{3}, ip2{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts2_wc060_d50", "2020-07-20", ip1{4}, ip2{1}); id = id + 1;
  
  ## Test series 3, reference tests
  ## c-wave sensor f_res = 500 kHz
  ## s-wave sensor f_res = 110/500 kHz
  ipre = item_pre_ts3;
  idate = {"2020-10-30"};
  ip1 = {"distance = 0mm (face-to-face)", "distance = 20mm", "distance = 50mm"};
  ip2 = {"share-wave sensor resonance frequency = 110kHz", "share-wave sensor resonance frequency = 500kHz"};
  ip3 = {"pulse width = 2.5usec", "pulse width = 5.0usec", "pulse width = 7.5usec", "pulse width = 10.0usec", ...
    "pulse width = 12.5usec", "pulse width = 15.0usec"};
  item(id) = hlp_dsparam(ipre, id, "ts3_d00_f110_w025", idate{1}, ip1{1}, ip2{1}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d00_f110_w050", idate{1}, ip1{1}, ip2{1}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d00_f110_w075", idate{1}, ip1{1}, ip2{1}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d00_f110_w100", idate{1}, ip1{1}, ip2{1}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d00_f110_w125", idate{1}, ip1{1}, ip2{1}, ip3{5}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d00_f110_w150", idate{1}, ip1{1}, ip2{1}, ip3{6}); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts3_d00_f500_w025", idate{1}, ip1{1}, ip2{2}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d00_f500_w050", idate{1}, ip1{1}, ip2{2}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d00_f500_w075", idate{1}, ip1{1}, ip2{2}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d00_f500_w100", idate{1}, ip1{1}, ip2{2}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d00_f500_w125", idate{1}, ip1{1}, ip2{2}, ip3{5}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d00_f500_w150", idate{1}, ip1{1}, ip2{2}, ip3{6}); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts3_d20_f110_w025", idate{1}, ip1{2}, ip2{1}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d20_f110_w050", idate{1}, ip1{2}, ip2{1}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d20_f110_w075", idate{1}, ip1{2}, ip2{1}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d20_f110_w100", idate{1}, ip1{2}, ip2{1}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d20_f110_w125", idate{1}, ip1{2}, ip2{1}, ip3{5}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d20_f110_w150", idate{1}, ip1{2}, ip2{1}, ip3{6}); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts3_d20_f500_w025", idate{1}, ip1{2}, ip2{2}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d20_f500_w050", idate{1}, ip1{2}, ip2{2}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d20_f500_w075", idate{1}, ip1{2}, ip2{2}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d20_f500_w100", idate{1}, ip1{2}, ip2{2}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d20_f500_w125", idate{1}, ip1{2}, ip2{2}, ip3{5}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d20_f500_w150", idate{1}, ip1{2}, ip2{2}, ip3{6}); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts3_d50_f110_w025", idate{1}, ip1{3}, ip2{1}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d50_f110_w050", idate{1}, ip1{3}, ip2{1}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d50_f110_w075", idate{1}, ip1{3}, ip2{1}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d50_f110_w100", idate{1}, ip1{3}, ip2{1}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d50_f110_w125", idate{1}, ip1{3}, ip2{1}, ip3{5}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d50_f110_w150", idate{1}, ip1{3}, ip2{1}, ip3{6}); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts3_d50_f500_w025", idate{1}, ip1{3}, ip2{2}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d50_f500_w050", idate{1}, ip1{3}, ip2{2}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d50_f500_w075", idate{1}, ip1{3}, ip2{2}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d50_f500_w100", idate{1}, ip1{3}, ip2{2}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d50_f500_w125", idate{1}, ip1{3}, ip2{2}, ip3{5}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts3_d50_f500_w150", idate{1}, ip1{3}, ip2{2}, ip3{6}); id = id + 1;

  ## Test series 4, cement paste tests
  ## c-wave sensor f_res = 500 kHz
  ## s-wave sensor f_res = 110 kHz
  ipre = item_pre_ts4;
  ip1 = {"w/c-ratio = 0.40", "w/c-ratio = 0.45", "w/c-ratio = 0.50", "w/c-ratio = 0.55", "w/c-ratio = 0.60"};
  ip2 = {"distance = 50mm", "distance = 25mm"};
  ip3 = {"pulse width = 12.5usec", "pulse width = 7.5usec", "pulse width = 2.5usec", "pulse width = 10.0usec"};
  item(id) = hlp_dsparam(ipre, id, "ts4_wc040_d50_w125", "2020-10-30", ip1{1}, ip2{1}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc040_d50_w075", "2020-11-01", ip1{1}, ip2{1}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc040_d50_w025", "2020-11-02", ip1{1}, ip2{1}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc055_d50_w125", "2020-11-19", ip1{4}, ip2{1}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc055_d50_w075", "2020-11-20", ip1{4}, ip2{1}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc055_d50_w025", "2020-11-23", ip1{4}, ip2{1}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc050_d50_w125", "2020-11-30", ip1{3}, ip2{1}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc050_d50_w075", "2020-12-01", ip1{3}, ip2{1}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc050_d50_w025", "2020-12-03", ip1{3}, ip2{1}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc045_d50_w125", "2020-12-04", ip1{2}, ip2{1}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc045_d50_w075", "2020-12-05", ip1{2}, ip2{1}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc045_d50_w025", "2020-12-06", ip1{2}, ip2{1}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc060_d50_w125", "2020-12-07", ip1{5}, ip2{1}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc060_d50_w075", "2020-12-08", ip1{5}, ip2{1}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc060_d50_w025", "2020-12-09", ip1{5}, ip2{1}, ip3{3}); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts4_wc040_d50_w075_a", "2020-12-14", ip1{1}, ip2{1}, ip3{2}, "repetition of ts4_wc040_d50_w075"); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc050_d50_w125_a", "2020-12-15", ip1{3}, ip2{1}, ip3{1}, "repetition of ts4_wc050_d50_w125"); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc060_d50_w125_a", "2020-12-16", ip1{5}, ip2{1}, ip3{1}, "repetition of ts4_wc060_d50_w125"); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc045_d50_w075_a", "2021-01-14", ip1{2}, ip2{1}, ip3{2}, "repetition of ts4_wc045_d50_w075"); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts4_wc040_d50_w100", "2021-01-18", ip1{1}, ip2{1}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc045_d50_w100", "2021-01-19", ip1{2}, ip2{1}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc050_d50_w100", "2021-01-20", ip1{3}, ip2{1}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc055_d50_w100", "2021-01-21", ip1{4}, ip2{1}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc060_d50_w100", "2021-01-22", ip1{5}, ip2{1}, ip3{4}); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts4_wc040_d25_w100", "2021-01-25", ip1{1}, ip2{2}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc045_d25_w100", "2021-01-26", ip1{2}, ip2{2}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc050_d25_w100", "2021-01-27", ip1{3}, ip2{2}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc055_d25_w100", "2021-01-28", ip1{4}, ip2{2}, ip3{4}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts4_wc060_d25_w100", "2021-01-29", ip1{5}, ip2{2}, ip3{4}); id = id + 1;

  ## Test series 5, air
  ## c-wave sensor f_res = 500 kHz
  ## s-wave sensor f_res = 500 kHz
  ipre = item_pre_ts5;
  idate = {"2020-03-05", "2020-03-06"};
  ip1 = {"distance = 25mm", "distance = 50mm", "distance = 70mm", "distance = 90mm"};
  ip2 = {"blocksize = 16kSmp", "blocksize = 24kSmp","blocksize = 33kSmp","blocksize = 50kSmp"};
  ip3 = {"pulse voltage = 400V", "pulse voltage = 600V", "pulse voltage = 800V"};
  item(id) = hlp_dsparam(ipre, id, "ts5_d25_b16_v400", idate{1}, ip1{1}, ip2{1}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d25_b16_v600", idate{1}, ip1{1}, ip2{1}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d25_b16_v800", idate{1}, ip1{1}, ip2{1}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d25_b24_v400", idate{1}, ip1{1}, ip2{2}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d25_b24_v600", idate{1}, ip1{1}, ip2{2}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d25_b24_v800", idate{1}, ip1{1}, ip2{2}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d25_b33_v400", idate{1}, ip1{1}, ip2{3}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d25_b33_v600", idate{1}, ip1{1}, ip2{3}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d25_b33_v800", idate{1}, ip1{1}, ip2{3}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d25_b50_v400", idate{1}, ip1{1}, ip2{4}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d25_b50_v600", idate{1}, ip1{1}, ip2{4}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d25_b50_v800", idate{1}, ip1{1}, ip2{4}, ip3{3}); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts5_d50_b16_v400", idate{1}, ip1{2}, ip2{1}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d50_b16_v600", idate{1}, ip1{2}, ip2{1}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d50_b16_v800", idate{1}, ip1{2}, ip2{1}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d50_b24_v400", idate{1}, ip1{2}, ip2{2}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d50_b24_v600", idate{1}, ip1{2}, ip2{2}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d50_b24_v800", idate{1}, ip1{2}, ip2{2}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d50_b33_v400", idate{1}, ip1{2}, ip2{3}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d50_b33_v600", idate{1}, ip1{2}, ip2{3}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d50_b33_v800", idate{1}, ip1{2}, ip2{3}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d50_b50_v400", idate{1}, ip1{2}, ip2{4}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d50_b50_v600", idate{1}, ip1{2}, ip2{4}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d50_b50_v800", idate{1}, ip1{2}, ip2{4}, ip3{3}); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts5_d70_b16_v400", idate{1}, ip1{3}, ip2{1}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d70_b16_v600", idate{1}, ip1{3}, ip2{1}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d70_b16_v800", idate{1}, ip1{3}, ip2{1}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d70_b24_v400", idate{1}, ip1{3}, ip2{2}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d70_b24_v600", idate{1}, ip1{3}, ip2{2}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d70_b24_v800", idate{1}, ip1{3}, ip2{2}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d70_b33_v400", idate{1}, ip1{3}, ip2{3}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d70_b33_v600", idate{1}, ip1{3}, ip2{3}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d70_b33_v800", idate{1}, ip1{3}, ip2{3}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d70_b50_v400", idate{1}, ip1{3}, ip2{4}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d70_b50_v600", idate{1}, ip1{3}, ip2{4}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d70_b50_v800", idate{1}, ip1{3}, ip2{4}, ip3{3}); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts5_d90_b16_v400", idate{2}, ip1{4}, ip2{1}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d90_b16_v600", idate{2}, ip1{4}, ip2{1}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d90_b16_v800", idate{2}, ip1{4}, ip2{1}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d90_b24_v400", idate{2}, ip1{4}, ip2{2}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d90_b24_v600", idate{2}, ip1{4}, ip2{2}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d90_b24_v800", idate{2}, ip1{4}, ip2{2}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d90_b33_v400", idate{2}, ip1{4}, ip2{3}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d90_b33_v600", idate{2}, ip1{4}, ip2{3}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d90_b33_v800", idate{2}, ip1{4}, ip2{3}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d90_b50_v400", idate{2}, ip1{4}, ip2{4}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d90_b50_v600", idate{2}, ip1{4}, ip2{4}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts5_d90_b50_v800", idate{2}, ip1{4}, ip2{4}, ip3{3}); id = id + 1;
  
  ## Test series 6, water
  ## c-wave sensor f_res = 500 kHz
  ## s-wave sensor f_res = 500 kHz
  ipre = item_pre_ts6;
  idate = {"2020-03-05", "2020-03-06"};
  ip1 = {"distance = 25mm", "distance = 50mm", "distance = 70mm", "distance = 90mm"};
  ip2 = {"blocksize = 16kSmp", "blocksize = 24kSmp","blocksize = 33kSmp","blocksize = 50kSmp"};
  ip3 = {"pulse voltage = 400V", "pulse voltage = 600V", "pulse voltage = 800V"};
  item(id) = hlp_dsparam(ipre, id, "ts6_d25_b16_v400", idate{1}, ip1{1}, ip2{1}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d25_b16_v600", idate{1}, ip1{1}, ip2{1}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d25_b16_v800", idate{1}, ip1{1}, ip2{1}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d25_b24_v400", idate{1}, ip1{1}, ip2{2}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d25_b24_v600", idate{1}, ip1{1}, ip2{2}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d25_b24_v800", idate{1}, ip1{1}, ip2{2}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d25_b33_v400", idate{1}, ip1{1}, ip2{3}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d25_b33_v600", idate{1}, ip1{1}, ip2{3}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d25_b33_v800", idate{1}, ip1{1}, ip2{3}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d25_b50_v400", idate{1}, ip1{1}, ip2{4}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d25_b50_v600", idate{1}, ip1{1}, ip2{4}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d25_b50_v800", idate{1}, ip1{1}, ip2{4}, ip3{3}); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts6_d50_b16_v400", idate{1}, ip1{2}, ip2{1}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d50_b16_v600", idate{1}, ip1{2}, ip2{1}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d50_b16_v800", idate{1}, ip1{2}, ip2{1}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d50_b24_v400", idate{1}, ip1{2}, ip2{2}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d50_b24_v600", idate{1}, ip1{2}, ip2{2}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d50_b24_v800", idate{1}, ip1{2}, ip2{2}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d50_b33_v400", idate{1}, ip1{2}, ip2{3}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d50_b33_v600", idate{1}, ip1{2}, ip2{3}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d50_b33_v800", idate{1}, ip1{2}, ip2{3}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d50_b50_v400", idate{1}, ip1{2}, ip2{4}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d50_b50_v600", idate{1}, ip1{2}, ip2{4}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d50_b50_v800", idate{1}, ip1{2}, ip2{4}, ip3{3}); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts6_d70_b16_v400", idate{1}, ip1{3}, ip2{1}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d70_b16_v600", idate{1}, ip1{3}, ip2{1}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d70_b16_v800", idate{1}, ip1{3}, ip2{1}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d70_b24_v400", idate{1}, ip1{3}, ip2{2}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d70_b24_v600", idate{1}, ip1{3}, ip2{2}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d70_b24_v800", idate{1}, ip1{3}, ip2{2}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d70_b33_v400", idate{1}, ip1{3}, ip2{3}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d70_b33_v600", idate{1}, ip1{3}, ip2{3}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d70_b33_v800", idate{1}, ip1{3}, ip2{3}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d70_b50_v400", idate{1}, ip1{3}, ip2{4}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d70_b50_v600", idate{1}, ip1{3}, ip2{4}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d70_b50_v800", idate{1}, ip1{3}, ip2{4}, ip3{3}); id = id + 1;
  
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b16_v400_1", idate{2}, ip1{4}, ip2{1}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b16_v600_1", idate{2}, ip1{4}, ip2{1}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b16_v800_1", idate{2}, ip1{4}, ip2{1}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b24_v400_1", idate{2}, ip1{4}, ip2{2}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b24_v600_1", idate{2}, ip1{4}, ip2{2}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b24_v800_1", idate{2}, ip1{4}, ip2{2}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b33_v400_1", idate{2}, ip1{4}, ip2{3}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b33_v600_1", idate{2}, ip1{4}, ip2{3}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b33_v800_1", idate{2}, ip1{4}, ip2{3}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b50_v400_1", idate{2}, ip1{4}, ip2{4}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b50_v600_1", idate{2}, ip1{4}, ip2{4}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b50_v800_1", idate{2}, ip1{4}, ip2{4}, ip3{3}); id = id + 1;
  ## specimen for s-wave mold larger
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b16_v400_2", idate{2}, ip1{4}, ip2{1}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b16_v600_2", idate{2}, ip1{4}, ip2{1}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b16_v800_2", idate{2}, ip1{4}, ip2{1}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b24_v400_2", idate{2}, ip1{4}, ip2{2}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b24_v600_2", idate{2}, ip1{4}, ip2{2}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b24_v800_2", idate{2}, ip1{4}, ip2{2}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b33_v400_2", idate{2}, ip1{4}, ip2{3}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b33_v600_2", idate{2}, ip1{4}, ip2{3}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b33_v800_2", idate{2}, ip1{4}, ip2{3}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b50_v400_2", idate{2}, ip1{4}, ip2{4}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b50_v600_2", idate{2}, ip1{4}, ip2{4}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts6_d90_b50_v800_2", idate{2}, ip1{4}, ip2{4}, ip3{3}); id = id + 1;
  
  ## Test series 7
  ## c-wave sensor f_res = 500 kHz
  ## s-wave sensor f_res = 500 kHz
  ipre = item_pre_ts7;
  idate = {"2020-03-06"};
  ip1 = {"distance = 50mm"};
  ip2 = {"blocksize = 16kSmp", "blocksize = 24kSmp","blocksize = 33kSmp","blocksize = 50kSmp"};
  ip3 = {"pulse voltage = 400V", "pulse voltage = 600V", "pulse voltage = 800V"};
  item(id) = hlp_dsparam(ipre, id, "ts7_d50_b16_v400", idate{1}, ip1{1}, ip2{1}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts7_d50_b16_v600", idate{1}, ip1{1}, ip2{1}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts7_d50_b16_v800", idate{1}, ip1{1}, ip2{1}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts7_d50_b24_v400", idate{1}, ip1{1}, ip2{2}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts7_d50_b24_v600", idate{1}, ip1{1}, ip2{2}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts7_d50_b24_v800", idate{1}, ip1{1}, ip2{2}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts7_d50_b33_v400", idate{1}, ip1{1}, ip2{3}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts7_d50_b33_v600", idate{1}, ip1{1}, ip2{3}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts7_d50_b33_v800", idate{1}, ip1{1}, ip2{3}, ip3{3}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts7_d50_b50_v400", idate{1}, ip1{1}, ip2{4}, ip3{1}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts7_d50_b50_v600", idate{1}, ip1{1}, ip2{4}, ip3{2}); id = id + 1;
  item(id) = hlp_dsparam(ipre, id, "ts7_d50_b50_v800", idate{1}, ip1{1}, ip2{4}, ip3{3}); id = id + 1;
  
  ## data set id's/code's
  for i = 1 : max(size(item))
    setcodes(i).serid = item(i).r02.i;
    setcodes(i).id = item(i).d01.v;
    setcodes(i).code = item(i).a01.v;
  endfor
  
  ## save structure
  save('-binary', p_ofp, 'item', 'item_empty', 'setcodes');
  
endfunction

############################################################################################################################################
## Helper function: complete data set parameters
## p_pi ... pre-initialized database item, [<struct>]
## r_ci ... return: fully initialized database item, [<struct>]
function [r_ci] = hlp_dsparam(p_pi, p_iid, p_icode, p_idate, p_ipar1, p_ipar2, p_ipar3, p_ipar4)
  
  ## check arguments
  if (nargin < 8)
    p_ipar4 = [];
  endif
  if (nargin < 7)
    p_ipar3 = [];
  endif
  if (nargin < 6)
    p_ipar2 = [];
  endif
  if (nargin < 5)
    p_ipar1 = [];
  endif
  
  ## init return value, copy structure
  r_ci = p_pi;
  
  ## update structure fields
  r_ci.d01.v = p_iid;
  r_ci.a01.v = p_icode;
  r_ci.a02.v = sprintf("data set %s", p_icode);
  r_ci.a04.v = {'Data set parameters:'};
  if not(isempty(p_ipar1))
    r_ci.a04.v = [r_ci.a04.v, p_ipar1];
  else
    r_ci.a04.v = [r_ci.a04.v, 'not available'];
  endif
  if not(isempty(p_ipar2))
    r_ci.a04.v = [r_ci.a04.v, p_ipar2];
  endif
  if not(isempty(p_ipar3))
    r_ci.a04.v = [r_ci.a04.v, p_ipar3];
  endif
  if not(isempty(p_ipar4))
    r_ci.a04.v = [r_ci.a04.v, p_ipar4];
  endif
  r_ci.a10.v = p_idate;
  r_ci.a17.v = p_icode;
  r_ci.a18.v = sprintf("%s.zip", p_icode);

endfunction
