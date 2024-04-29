## Create test series metadata database file (GNU octave binary file)
##
## Usage: struct_make_metaserdb(p_ofp)
##
## p_ofp ... output file path (database file path), optional, <str>
##             default: ./struct_hdf/db/db_metaser.oct
##
## item ... return: test series matadata structure, <struct>
##   .obj ... object type, always "struct_metaser"
##   .ver ... version number [major_ver, minor_ver], [<uint>]
##   .r01 ... author reference, <ARE/struct>
##   .r02 ... license reference, <ARE/struct>
##   .d01 ... test series id, <ADE/struct>
##   .a01 ... test series code, <AAE/struct>
##   .a02 ... test series name, <AAE/struct>
##   .a03 ... test series description, [<AAE/struct>]
##   .a04 ... test series abstract, [<AAE/struct>]
##   .a05 ... test series context, [<AAE/struct>]
##   .a06 ... test series start date, [<AAE/struct>]
##   .a07 ... test series end date, [<AAE/struct>]
##
## Test series ID's/Codes:
##    1, "ts1": Test series 1, ultrasonic transmission tests, cement pastes, OPC CEM I 42.5 N
##    2, "ts2": Test series 2, hydration temperature tests, cement pastes, OPC CEM I 42.5 N
##    3, "ts3": Test series 3, ultrasonic transmission tests, reference tests, air, 110 kHz s-wave sensor tests
##    4, "ts4": Test series 4, ultrasonic transmission tests, cement pastes, OPC CEM I 42.5 N, s-wave sensor 110 kHz
##    5, "ts5": Test series 5, ultrasonic transmission tests, reference tests, air
##    6, "ts6": Test series 6, ultrasonic transmission tests, reference tests, water
##    7, "ts7": Test series 7, ultrasonic transmission tests, reference tests, aluminium cylinder
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
function struct_make_metaserdb(p_ofp)
  
  ## read database file path from global variable, see also init.m
  global wavupv_dbpath_metaser
  
  ## check arguments
  if (nargin < 1)
    p_ofp = wavupv_dbpath_metaser;
  endif
  if isempty(p_ofp)
    p_ofp = wavupv_dbpath_metaser;
  endif
  
  ## test series id's/codes/names
  for i = 1 : 7
    sercodes(i).id = i;
    sercodes(i).code = sprintf('ts%d', i);
    sercodes(i).name = sprintf('Test series %d', i);
  endfor
  
  ## empty item
  item_empty.obj = 'struct_metaser';
  item_empty.ver = uint16([1, 0]);
  item_empty.r01 = struct_objref('author', [], 'aut', 'author reference');
  item_empty.r02 = struct_objref('license', [], 'lic', 'license reference');
  item_empty.d01 = struct_objdata('series_id', 'uint', [], [], 'test series id');
  item_empty.a01 = struct_objattrib('series_code', [], 'test series code');
  item_empty.a02 = struct_objattrib('series_name', [], 'test series name');
  item_empty.a03 = struct_objattrib('description', [], 'test series description');
  item_empty.a04 = struct_objattrib('abstract', [], 'test series abstract');
  item_empty.a05 = struct_objattrib('context', [], 'test series context');
  item_empty.a06 = struct_objattrib('date_start', [], 'test series start date');
  item_empty.a07 = struct_objattrib('date_end', [], 'test series end date');
  
  ## test series 1
  id = 1;
  item(id) = item_empty;
  item(id).r01.i = 1;
  item(id).r02.i = 2;
  item(id).d01.v = sercodes(id).id;
  item(id).a01.v = sercodes(id).code;
  item(id).a02.v = sercodes(id).name;
  item(id).a03.v = "Ultrasonic pulse transmission tests performed on cement pastes at early stages";
  item(id).a04.v = "The test series was created to receive information about the material behaviour of cement pastes at early stages. \
The approach for this test series was to vary the parameters water-cement-ratio and distance-between-actuator-and-sensor. \
This results in a two-dimensional test parameter grid (water-cement-ratio versus distance-between-actuator-and-sensor). \
For each point of the parameter grid, tests were performed several times to check the stability of the testing method. \
The materials tested were blends from ordinary Portland cement and tap water. The test methods used were ultrasonic pulse transmission \
method with combined compression- and shear wave measurements, gravimetric density tests (fresh paste density, solid specimen density) \
and hydration temperature tests. All test data and metadata are summarized into datasets using GNU octave's open binary file format.";
  item(id).a05.v = sprintf("%s is part of the PhD thesis of Jakob Harden", sercodes(id).name);
  item(id).a06.v = '2020-03-10';
  item(id).a07.v = '2021-03-30';
  
  ## test series 2
  id = id + 1;
  item(id) = item_empty;
  item(id).r01.i = 1;
  item(id).r02.i = 2;
  item(id).d01.v = sercodes(id).id;
  item(id).a01.v = sercodes(id).code;
  item(id).a02.v = sercodes(id).name;
  item(id).a03.v = "Hydration temperature tests performed on cement pastes at early stages";
  item(id).a04.v = "The test series was created in order to get information about the distribution of the hydration temperature \
of cement pastes at early stages (first 24 hours). The approach for the test series was to measure the hydration temperature at \
different locations of a cylindric specimen created from different blends of cement and water. \
The materials tested were blends from ordinary portland cement (CEM I 42.5 N) and tap water. \
The test method used was a temperature test with thermocouples and a temperature logger. \
All test data and metadata are summarized into datasets using GNU Octave's open binary file format.";
  item(id).a05.v = sprintf("%s is part of the PhD thesis of Jakob Harden", sercodes(id).name);
  item(id).a06.v = '2020-07-18';
  item(id).a07.v = '2020-07-22';
  
  ## test series 3
  id = id + 1;
  item(id) = item_empty;
  item(id).r01.i = 1;
  item(id).r02.i = 2;
  item(id).d01.v = sercodes(id).id;
  item(id).a01.v = sercodes(id).code;
  item(id).a02.v = sercodes(id).name;
  item(id).a03.v = "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 3, Reference Tests on Air";
  item(id).a04.v = "The test series was created to receive information about the impact of the behaviour of two different piezoelectric \
shear wave sensors on the measurement results of ultrasonic pulse transmission tests. The approach for the test series was to vary the \
parameters pulse-width, the distance-between-actuator-and-sensor and the shear-wave-sensor-type. This results in a three-dimensional \
test parameter grid (pulse-width versus distance-between-actuator-and-sensor versus shear-wave-sensor-type). Tests were performed for \
each grid point in order to receive information needed to optimize the pulse width but also a possible dependency between material and \
sensor behaviour. The material tested was the air of the laboratory environment. The test method used was the ultrasonic pulse \
transmission method with combined compression- and shear wave measurements. All test data and metadata are summarized into datasets \
using GNU Octave's open binary file format.";
  item(id).a05.v = sprintf("%s is part of the PhD thesis of Jakob Harden", sercodes(id).name);
  item(id).a06.v = '2020-10-30';
  item(id).a07.v = '2020-10-30';
  
  ## test series 4
  id = id + 1;
  item(id) = item_empty;
  item(id).r01.i = 1;
  item(id).r02.i = 2;
  item(id).d01.v = sercodes(id).id;
  item(id).a01.v = sercodes(id).code;
  item(id).a02.v = sercodes(id).name;
  item(id).a03.v = "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 4, Cement Paste at Early Stages";
  item(id).a04.v = "The test series was created to receive information about the impact of the behaviour of the piezoelectric shear \
wave sensor on the measurement results of ultrasonic transmission tests performed on cement pastes at early stages. The approach for \
the test series was to vary the parameters water-cement-ratio and pulse-width. This results in a two-dimensional test parameter grid \
(water-cement-ratio versus pulse-width). Tests were performed for each grid point in order to receive information needed to optimize \
the pulse width for the shear wave sensors, but also a possible dependency between material behaviour and pulse width. The materials \
tested were blends from ordinary Portland cement and tap water. The test methods used were ultrasonic pulse transmission method with \
combined compression- and shear wave measurements, gravimetric density tests (fresh paste density, solid specimen density) and hydration \
temperature tests. All test data and metadata are summarized into datasets using GNU Octave's open binary file format.";
  item(id).a05.v = sprintf("%s is part of the PhD thesis of Jakob Harden", sercodes(id).name);
  item(id).a06.v = '2020-10-30';
  item(id).a07.v = '2021-01-29';
  
  
  ## test series 5
  id = id + 1;
  item(id) = item_empty;
  item(id).r01.i = 1;
  item(id).r02.i = 2;
  item(id).d01.v = sercodes(id).id;
  item(id).a01.v = sercodes(id).code;
  item(id).a02.v = sercodes(id).name;
  item(id).a03.v = "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 5, Reference Tests on Air";
  item(id).a04.v = "The test series was created in order to validate the stability and functionality of the test device and to create a data \
reference for aeriform materials (air). The approach for the test series was to vary the parameters number-of-samples-recorded, \
pulse-voltage and distance-between-actuator-and-sensor. This results in a three-dimensional test parameter grid. Tests were performed several \
times for each grid point (number-of-samples-recorded versus pulse-voltage versus distance-between-actuator-and-sensor) in order to \
receive statistical information about the stability of the test results. The material tested was the air in the laboratory room. \
The test method used was the ultrasonic pulse transmission method with combined compression- and shear wave measurements. \
All test data and metadata are summarized into datasets using GNU Octave's open binary file format.";
  item(id).a05.v = sprintf("%s is part of the PhD thesis of Jakob Harden", sercodes(id).name);
  item(id).a06.v = '2020-03-05';
  item(id).a07.v = '2020-03-06';
  
  ## test series 6
  id = id + 1;
  item(id) = item_empty;
  item(id).r01.i = 1;
  item(id).r02.i = 2;
  item(id).d01.v = sercodes(id).id;
  item(id).a01.v = sercodes(id).code;
  item(id).a02.v = sercodes(id).name;
  item(id).a03.v = "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 6, Reference Tests on Water";
  item(id).a04.v = "The test series was created in order to validate the stability and functionality of the test device and to create a data \
reference for liquid materials (water). The approach for the test series was to vary the parameters number-of-samples-recorded, \
pulse-voltage and distance-between-actuator-and-sensor. This results in a three-dimensional test parameter grid. Tests were performed several \
times for each grid point (number-of-samples-recorded versus pulse-voltage versus distance-between-actuator-and-sensor) in order to \
receive statistical information about the stability of the test results. The material tested was water from the tap of the laboratory \
water supply system. The test method used was the ultrasonic pulse transmission method with combined compression- and shear wave \
measurements. All test data and metadata are summarized into datasets using GNU Octave's open binary file format.";
  item(id).a05.v = sprintf("%s is part of the PhD thesis of Jakob Harden", sercodes(id).name);
  item(id).a06.v = '2020-03-05';
  item(id).a07.v = '2020-03-06';
  
  ## test series 7
  id = id + 1;
  item(id) = item_empty;
  item(id).r01.i = 1;
  item(id).r02.i = 2;
  item(id).d01.v = sercodes(id).id;
  item(id).a01.v = sercodes(id).code;
  item(id).a02.v = sercodes(id).name;
  item(id).a03.v = "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 7, Reference Tests on Aluminium Cylinder";
  item(id).a04.v = "The test series was created in order to validate the stability and functionality of the test device and to create a data \
reference for metals (aluminium cylinder). The approach for the test series was to vary the parameters number-of-samples-recorded and \
pulse-voltage. This results in a two-dimensional test parameter grid. Tests were performed several times for each grid point \
(number-of-samples-recorded versus pulse-voltage) in order to receive statistical information about the stability of the test results. \
The material tested was an aluminium cylinder with a diameter of 50 millimetres and a height of 50 millimetres. \
The test method used was the ultrasonic pulse transmission method with combined compression- and shear wave \
measurements. All test data and metadata are summarized into datasets using GNU Octave's open binary file format.";
  item(id).a05.v = sprintf("%s is part of the PhD thesis of Jakob Harden", sercodes(id).name);
  item(id).a06.v = '2020-03-06';
  item(id).a07.v = '2020-03-06';
  
  ## save structure
  save('-binary', p_ofp, 'item', 'item_empty', 'sercodes');
  
endfunction
