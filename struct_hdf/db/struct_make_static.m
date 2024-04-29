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
## Create information file used to initialize the static content of data structures
##
## Usage: struct_make_static(p_ofp)
##
## p_ofp ... output file path (database file path), optional, <str>
##             default: ./struct_hdf/db/db_static.oct
##
## Note 1: If new variables are added or variable names are modified,
##         increment the major version, otherwise increment the minor version only.
##         Example: major changes, ver = [1, 0] --> ver = [2, 0]
##         Example: minor changes, ver = [1, 0] --> ver = [1, 1]
##         
##
## Note 2: Assure, that the object type ("obj") name equals the function file name
##         used to create the data structure.
##         Example: obj = "struct_xxx" for "struct_xxx.m"
##
## see also: init, struct_dataset
##
function struct_make_static(p_ofp)
  
 ## read database file path from global variable, see also init.m
  global dsc_dbpath_static
  
  ## check arguments
  if (nargin < 1)
    p_ofp = dsc_dbpath_static;
  endif
  if isempty(p_ofp)
    p_ofp = dsc_dbpath_static;
  endif
  
  ## general definitions and defaults
  gdef.rights = 'Harden, Jakob';
  gdef.rightsholder = 'Graz University of Technology (Graz, Austria)';
  gdef.operator = 'Harden, Jakob (jakob.harden@tugraz.at)';
  gdef.descr = 'No additional information available';
  gdef.descr_spm1 = 'Compression wave measurement, mold I';
  gdef.descr_spm2 = 'Shear wave measurement, mold II';
  
  ## Table contains values of water density from +15°C to +30.9°C
  ## Source: https://www.simetric.co.uk/si_water.htm
  gdef.tab_density_water = [...
    0.999099, 0.999084, 0.999069, 0.999054, 0.999038, 0.999023, 0.999007, 0.998991, 0.998975, 0.998959, ...
    0.998943, 0.998926, 0.998910, 0.998893, 0.998877, 0.998860, 0.998843, 0.998826, 0.998809, 0.998792, ...
    0.998774, 0.998757, 0.998739, 0.998722, 0.998704, 0.998686, 0.998668, 0.998650, 0.998632, 0.998613, ...
    0.998595, 0.998576, 0.998558, 0.998539, 0.998520, 0.998501, 0.998482, 0.998463, 0.998444, 0.998424, ...
    0.998405, 0.998385, 0.998365, 0.998345, 0.998325, 0.998305, 0.998285, 0.998265, 0.998244, 0.998224, ...
    0.998203, 0.998183, 0.998162, 0.998141, 0.998120, 0.998099, 0.998078, 0.998056, 0.998035, 0.998013, ...
    0.997992, 0.997970, 0.997948, 0.997926, 0.997904, 0.997882, 0.997860, 0.997837, 0.997815, 0.997792, ...
    0.997770, 0.997747, 0.997724, 0.997701, 0.997678, 0.997655, 0.997632, 0.997608, 0.997585, 0.997561, ...
    0.997538, 0.997514, 0.997490, 0.997466, 0.997442, 0.997418, 0.997394, 0.997369, 0.997345, 0.997320, ...
    0.997296, 0.997271, 0.997246, 0.997221, 0.997196, 0.997171, 0.997146, 0.997120, 0.997095, 0.997069, ...
    0.997044, 0.997018, 0.996992, 0.996967, 0.996941, 0.996914, 0.996888, 0.996862, 0.996836, 0.996809, ...
    0.996783, 0.996756, 0.996729, 0.996703, 0.996676, 0.996649, 0.996621, 0.996594, 0.996567, 0.996540, ...
    0.996512, 0.996485, 0.996457, 0.996429, 0.996401, 0.996373, 0.996345, 0.996317, 0.996289, 0.996261, ...
    0.996232, 0.996204, 0.996175, 0.996147, 0.996118, 0.996089, 0.996060, 0.996031, 0.996002, 0.995973, ...
    0.995944, 0.995914, 0.995885, 0.995855, 0.995826, 0.995796, 0.995766, 0.995736, 0.995706, 0.995676, ...
    0.995646, 0.995616, 0.995586, 0.995555, 0.995525, 0.995494, 0.995464, 0.995433, 0.995402, 0.995371];
  
  ## struct_dataset
  struct_dataset.obj = 'struct_dataset';
  struct_dataset.ver = uint16([1, 0]);
  struct_dataset.meta_ser = [];
  struct_dataset.meta_set = [];
  struct_dataset.loc = [];
  struct_dataset.lic = [];
  struct_dataset.aut = [];
  struct_dataset.dev = [];
  struct_dataset.mat = [];
  struct_dataset.rec = [];
  struct_dataset.mix = [];
  struct_dataset.spm = [];
  struct_dataset.tst = [];
  
  ## struct_mix
  proc = {...
    '(1) weigh mixture components (cement, water) according to mixture recipe', ...
    '(2) prepare mixer', ...
    '(3) pour cement in mixer bowl', ...
    '(4) add water and start counter clock', ...
    '(5) blend for 60 sec', ...
    '(6) 30 sec scratching debris from wall of mixer bowl with a metal spoon', ...
    '(7) blend for 90 sec'};
  struct_mix.obj = 'struct_mix';
  struct_mix.ver = uint16([1, 0]);
  struct_mix.r01 = struct_objref('author', [], 'aut', 'author reference');
  struct_mix.r02 = struct_objref('device', [], 'dev', 'device reference');
  struct_mix.r03 = struct_objref('recipe', [], 'rec', 'recipe reference');
  struct_mix.r04 = struct_objref('location', [], 'loc', 'location reference');
  struct_mix.d01 = struct_objdata('mixture_id', 'uint', [], [], 'mixture id');
  struct_mix.d02 = struct_objdata('datetime', 'double', [], 'utc', [], 'date and time, seconds since epoch (UTC)');
  struct_mix.d03 = struct_objdata('mixing_time', 'uint', [], 'sec', 'mixing/blending time');
  struct_mix.d04 = struct_objdata('speed_level', 'uint', [], [], 'mixer speed level');
  struct_mix.d05 = struct_objdata('agitator_speed', 'uint', [], 'RPM', 'mixer agitator speed');
  struct_mix.d06 = struct_objdata('attachment_speed', 'uint', [], 'RPM', 'mixer attachment speed');
  struct_mix.a01 = struct_objattrib('operator', [], 'operator name');
  struct_mix.a02 = struct_objattrib('procedure', proc, 'procedure description');
  struct_mix.a03 = struct_objattrib('description', [], 'general description');
  
  ## struct_mix_component
  struct_mix_component.obj = 'struct_mix_component';
  struct_mix_component.ver = uint16([1, 0]);
  struct_mix_component.r01 = struct_objref('material', [], 'mat', 'material reference');
  struct_mix_component.d01 = struct_objdata('weight', 'double', [], 'g', 'material weight');
  struct_mix_component.a01 = struct_objattrib('description', [], 'general description');
  
  ## struct_spm_paste
  proc = {...
    '(1) apply release agent on surfaces of mold I and mold II', ...
    '(2) assemble mold I and mold II', ...
    '(3) pour paste in mold I, fill up to approx. half height of mold I', ...
    '(4) pour paste in mold II, fill up to approx. half height of mold II', ...
    '(5) shake mold I for approx. 10 sec (vertical movements)', ...
    '(6) shake mold II for approx. 10 sec (vertical movements)', ...
    '(7) pour paste in mold I, fill up to approx. 2.5 cm below top edge of mold I', ...
    '(8) pour paste in mold II, fill up to approx. 2.5 cm below top edge of mold II', ...
    '(9) shake mold I for approx. 10 sec (vertical movements)', ...
    '(10) shake mold II for approx. 10 sec (vertical movements)', ...
    '(11) cover top of specimen in mold I with rubber foam strips', ...
    '(12) cover top of specimen in mold II with rubber foam strips', ...
    '(13) place thermocouples'};
  struct_spm_paste.obj = 'struct_spm_paste';
  struct_spm_paste.ver = uint16([1, 0]);
  struct_spm_paste.r01 = struct_objref('author', [], 'aut', 'author reference');
  struct_spm_paste.r02 = struct_objref('mixture', [], 'mix', 'mixture reference');
  struct_spm_paste.r03 = struct_objref('device', [], 'dev', 'device reference');
  struct_spm_paste.r04 = struct_objref('location', [], 'loc', 'location reference');
  struct_spm_paste.d01 = struct_objdata('specimen_id', 'uint', [], [], 'specimen id');
  struct_spm_paste.d02 = struct_objdata('datetime', 'double', [], 'utc', 'date and time, seconds since epoch (UTC)');
  struct_spm_paste.a01 = struct_objattrib('specimen_code', [], 'specimen code');
  struct_spm_paste.a02 = struct_objattrib('operator', [], 'operator name');
  struct_spm_paste.a03 = struct_objattrib('procedure', proc, 'procedure description');
  struct_spm_paste.a04 = struct_objattrib('description', [], 'general description');
  
  ## struct_spm_ref
  struct_spm_ref.obj = 'struct_spm_ref';
  struct_spm_ref.ver = uint16([1, 0]);
  struct_spm_ref.r01 = struct_objref('author', [], 'aut', 'author reference');
  struct_spm_ref.r02 = struct_objref('material', [], 'mat', 'material reference');
  struct_spm_ref.r03 = struct_objref('device', [], 'dev', 'device reference');
  struct_spm_ref.r04 = struct_objref('location', [], 'loc', 'location reference');
  struct_spm_ref.d01 = struct_objdata('specimen_id', 'uint', [], [], 'specimen id');
  struct_spm_ref.d02 = struct_objdata('datetime', 'double', [], 'utc', 'date and time, seconds since epoch (UTC)');
  struct_spm_ref.a01 = struct_objattrib('specimen_code', [], 'specimen code');
  struct_spm_ref.a02 = struct_objattrib('operator', [], 'operator name');
  struct_spm_ref.a03 = struct_objattrib('procedure', [], 'procedure description');
  struct_spm_ref.a04 = struct_objattrib('description', [], 'general description');
  
  ## struct_test
  struct_test.obj = 'struct_test';
  struct_test.ver = uint16([1, 0]);
  struct_test.s01 = [];
  struct_test.s02 = [];
  struct_test.s03 = [];
  struct_test.s04 = [];
  struct_test.s05 = [];
  struct_test.s06 = [];
  struct_test.s07 = [];
  struct_test.s08 = [];
  struct_test.s09 = [];
  
  ## struct_test_env1
  proc = {'(1) Read temperature from display of temperature logger mounted on the wall'};
  calc = {'Not required'};
  struct_test_env1.obj = 'struct_test_env1';
  struct_test_env1.ver = uint16([1, 0]);
  struct_test_env1.r01 = struct_objref('author', [], 'aut', 'author reference');
  struct_test_env1.r02 = struct_objref('device', [], 'dev', 'device reference');
  struct_test_env1.r03 = struct_objref('location', [], 'loc', 'location reference');
  struct_test_env1.d01 = struct_objdata('datetime', 'double', [], 'utc', 'date and time, seconds since epoch (UTC)');
  struct_test_env1.d02 = struct_objdata('temperature', 'double', [], '°C', 'environment temperature at test start');
  struct_test_env1.a01 = struct_objattrib('testname', 'Environment temperature (room air)', 'test name');
  struct_test_env1.a02 = struct_objattrib('operator', [], 'operator name');
  struct_test_env1.a03 = struct_objattrib('procedure', proc, 'procedure description');
  struct_test_env1.a04 = struct_objattrib('calculation', calc, 'calculation description, formula');
  struct_test_env1.a05 = struct_objattrib('description', [], 'general description');
  
  ## struct_test_env2
  proc = {'(1) Read temperature and humidity from display of temperature/humidity logger mounted on the wall'};
  calc = {'Not required'};
  struct_test_env2.obj = 'struct_test_env2';
  struct_test_env2.ver = uint16([1, 0]);
  struct_test_env2.r01 = struct_objref('author', [], 'aut', 'author reference');
  struct_test_env2.r02 = struct_objref('device', [], 'dev', 'device reference');
  struct_test_env2.r03 = struct_objref('location', [], 'loc', 'location reference');
  struct_test_env2.d01 = struct_objdata('datetime', 'double', [], 'utc', 'date and time, seconds since epoch (UTC)');
  struct_test_env2.d02 = struct_objdata('temperature', 'double', [], '°C', 'environment temperature at test start');
  struct_test_env2.d03 = struct_objdata('humidity', 'double', [], '%', 'environment humidity at test start');
  struct_test_env2.a01 = struct_objattrib('testname', 'Environment temperature and humidity (room air)', 'test name');
  struct_test_env2.a02 = struct_objattrib('operator', [], 'operator name');
  struct_test_env2.a03 = struct_objattrib('procedure', proc, 'procedure description');
  struct_test_env2.a04 = struct_objattrib('calculation', calc, 'calculation description, formula');
  struct_test_env2.a05 = struct_objattrib('description', [], 'general description');
  
  
  ## struct_test_fpd
  proc = {...
    '(1) moist inner surface of graduated beaker using a wet towel', ...
    '(2) pour paste in beaker, fill beaker to approx. half height', ...
    '(3) shake beaker for approx. 10 sec (vertical movements)', ...
    '(4) pour paste in beaker, fill to top edge', ...
    '(5) shake beaker for approx. 10 sec (vertical movements)', ...
    '(6) assure that beaker is fully filled (plus 2-3 mm over the top edge)', ...
    '(7) scrape off excess material along the beaker edge with a trowel', ...
    '(8) tare balance', ...
    '(9) measure gross weight (beaker plus paste)'};
  calc = {...
    'specimen_density = specimen_weight / beaker_volume', ...
    'specimen_weight = gross_weight - beaker_weight'};
  struct_test_fpd.obj = 'struct_test_fpd';
  struct_test_fpd.ver = uint16([1, 0]);
  struct_test_fpd.r01 = struct_objref('author', [], 'aut', 'author reference');
  struct_test_fpd.r02 = struct_objref('mixture', [], 'mix', 'mixture reference');
  struct_test_fpd.r03 = struct_objref('device', [], 'dev', 'device reference');
  struct_test_fpd.r04 = struct_objref('location', [], 'loc', 'location reference');
  struct_test_fpd.d01 = struct_objdata('datetime', 'double', [], 'utc', 'date and time, seconds since epoch (UTC)');
  struct_test_fpd.d02 = struct_objdata('beaker_volume', 'double', [], 'cm^3', 'beaker volume');
  struct_test_fpd.d03 = struct_objdata('gross_weight', 'double', [], 'g', 'gross weight, measurement result');
  struct_test_fpd.d04 = struct_objdata('beaker_weight', 'double', [], 'g', 'beaker weight, net weight, measurement result');
  struct_test_fpd.d05 = struct_objdata('specimen_weight', 'double', [], 'g', 'specimen weight, calculated value');
  struct_test_fpd.d06 = struct_objdata('specimen_density', 'double', [], 'g/cm^3', 'specimen density, calculated value');
  struct_test_fpd.a01 = struct_objattrib('testname', 'Fresh paste density test', 'test name');
  struct_test_fpd.a02 = struct_objattrib('operator', [], 'operator name');
  struct_test_fpd.a03 = struct_objattrib('procedure', proc, 'procedure description');
  struct_test_fpd.a04 = struct_objattrib('calculation', calc, 'calculation description, formula');
  struct_test_fpd.a05 = struct_objattrib('description', [], 'general description');
  
  ## struct_test_ssd1
  proc = {...
    '(1) remove loose parts from specimen edges', ...
    '(2) tare balance', ...
    '(3) weigh dry mass of specimen', ...
    '(4) lower basket into the water container and attach it to the balance', ...
    '(5) tare balance', ...
    '(6) put specimen on basket, make sure that it is completely covered with water', ...
    '(7) wait until air bubbles have disappeared from the specimen surface and it is hanging quietly in the water', ...
    '(8) weigh floating mass of specimen'};
  calc = {...
    'specimen_density = specimen_weight / specimen_volume', ...
    'specimen_volume = water_density / water_weight_displaced', ...
    'water_density = hlp_density_water(water_temperature), see function file struct_hdf/struct_test_ssd1.m', ...
    'water_weight_displaced = specimen_weight - floating_specimen_weight'};
  struct_test_ssd1.obj = 'struct_test_ssd1';
  struct_test_ssd1.ver = uint16([1, 0]);
  struct_test_ssd1.r01 = struct_objref('author', [], 'aut', 'author reference');
  struct_test_ssd1.r02 = struct_objref('specimen', [], 'spm', 'specimen reference');
  struct_test_ssd1.r03 = struct_objref('device', [], 'dev', 'device reference');
  struct_test_ssd1.r04 = struct_objref('location', [], 'loc', 'location reference');
  struct_test_ssd1.d01 = struct_objdata('datetime', 'double', [], 'utc', 'date and time, seconds since epoch (UTC)');
  struct_test_ssd1.d02 = struct_objdata('specimen_weight', 'double', [], 'g', 'specimen weight, measurement result');
  struct_test_ssd1.d03 = struct_objdata('floating_specimen_weight', 'double', [], 'g', 'floating specimen weight, measurement result');
  struct_test_ssd1.d04 = struct_objdata('water_temperature', 'double', [], '°C', 'water temperature of water basin, measurement result or estimation based on environment temperature');
  struct_test_ssd1.d05 = struct_objdata('water_density', 'double', [], 'g/cm^3', 'density of water in basin, calculated value');
  struct_test_ssd1.d06 = struct_objdata('water_weight_displaced', 'double', [], 'g', 'weight of displaced water, calculated value');
  struct_test_ssd1.d07 = struct_objdata('specimen_volume', 'double', [], 'cm^3', 'specimen volume, calculated value');
  struct_test_ssd1.d08 = struct_objdata('specimen_density', 'double', [], 'g/cm^3', 'specimen density, calculated value');
  struct_test_ssd1.a01 = struct_objattrib('testname', 'Solid specimen density test 1 (gravimetric, immersion weighing)', 'test name');
  struct_test_ssd1.a02 = struct_objattrib('operator', [], 'operator name');
  struct_test_ssd1.a03 = struct_objattrib('procedure', proc, 'procedure description');
  struct_test_ssd1.a04 = struct_objattrib('calculation', calc, 'calculation description, formula');
  struct_test_ssd1.a05 = struct_objattrib('description', [], 'general description');
  
  
  ## struct_test_ssd2
  proc = {...
    '(1) tare balance', ...
    '(2) weigh mass of specimen', ...
    '(3) measure diameter of specimen (cylinder)', ...
    '(4) measure length of specimen (cylinder)'};
  calc = {...
  'specimen_volume = specimen_diameter^2 * PI * specimen_length / (4 * 1000)'
  'specimen_density = specimen_weight / specimen_volume'};
  struct_test_ssd2.obj = 'struct_test_ssd2';
  struct_test_ssd2.ver = uint16([1, 0]);
  struct_test_ssd2.r01 = struct_objref('author', [], 'aut', 'author reference');
  struct_test_ssd2.r02 = struct_objref('specimen', [], 'spm', 'specimen reference');
  struct_test_ssd2.r03 = struct_objref('device', [], 'dev', 'device reference');
  struct_test_ssd2.r04 = struct_objref('location', [], 'loc', 'location reference');
  struct_test_ssd2.d01 = struct_objdata('datetime', 'double', [], 'utc', 'date and time, seconds since epoch (UTC)');
  struct_test_ssd2.d02 = struct_objdata('specimen_weight', 'double', [], 'g', 'specimen weight, measurement result');
  struct_test_ssd2.d03 = struct_objdata('specimen_diameter', 'double', [], 'mm', 'specimen diameter, diameter of cylinder');
  struct_test_ssd2.d04 = struct_objdata('specimen_length', 'double', [], 'mm', 'specimen length, length of cylinder');
  struct_test_ssd2.d05 = [];
  struct_test_ssd2.d06 = [];
  struct_test_ssd2.d07 = struct_objdata('specimen_volume', 'double', [], 'cm^3', 'specimen volume, calculated value');
  struct_test_ssd2.d08 = struct_objdata('specimen_density', 'double', [], 'g/cm^3', 'specimen density, calculated value');
  struct_test_ssd2.a01 = struct_objattrib('testname', 'Solid specimen density test 2 (gravimetric, mass, volume)', 'test name');
  struct_test_ssd2.a02 = struct_objattrib('operator', [], 'operator name');
  struct_test_ssd2.a03 = struct_objattrib('procedure', proc, 'procedure description');
  struct_test_ssd2.a04 = struct_objattrib('calculation', calc, 'calculation description, formula');
  struct_test_ssd2.a05 = struct_objattrib('description', [], 'general description');
  

  ## struct_test_tem
  proc = {...
    '(1) strip ends of thermocouples, approx. 2cm long', ...
    '(2) twist both strands together and bend them over, approx 1cm long', ...
    '(3) repeat (1) and (2) for all thermocouples (4 in total)', ...
    '(4) place thermocouple 1 (T1) in the center of the specimen', ...
    '(5) place thermocouple 2 (T2) on the side panel, next to the sensor, vertical center of specimen height', ...
    '(6) place thermocouple 3 (T3) on the mid of the lateral surface of the spacer, vertical center of specimen height', ...
    '(7) place thermocouple 4 (T4) outside but right next to the mold'};
  calc = {'Not required'};
  struct_test_tem.obj = 'struct_test_tem';
  struct_test_tem.ver = uint16([1, 0]);
  struct_test_tem.r01 = struct_objref('author', [], 'aut', 'author reference');
  struct_test_tem.r02 = struct_objref('specimen', [], 'spm', 'specimen reference');
  struct_test_tem.r03 = struct_objref('device', [], 'dev', 'device reference');
  struct_test_tem.r04 = struct_objref('location', [], 'loc', 'location reference');
  struct_test_tem.d01 = struct_objdata('datetime', 'double', [], 'utc', 'date and time, seconds since epoch (UTC)');
  struct_test_tem.d02 = struct_objdata('tem_maturity', 'uint_arr', [], 'sec', 'temperature measurement time array, specimen maturity [num_signals x 1]');
  struct_test_tem.d03 = struct_objdata('tem_tcpl1', 'single_arr', [], '°C', 'thermocouple-1, temperature magnitude array [num_signals x 1]');
  struct_test_tem.d04 = struct_objdata('tem_tcpl2', 'single_arr', [], '°C', 'thermocouple-2, temperature magnitude array [num_signals x 1]');
  struct_test_tem.d05 = struct_objdata('tem_tcpl3', 'single_arr', [], '°C', 'thermocouple-3, temperature magnitude array [num_signals x 1]');
  struct_test_tem.d06 = struct_objdata('tem_tcpl4', 'single_arr', [], '°C', 'thermocouple-4, temperature magnitude array [num_signals x 1]');
  struct_test_tem.a01 = struct_objattrib('testname', 'Specimen temperature test', 'test name');
  struct_test_tem.a02 = struct_objattrib('operator', [], 'operator name');
  struct_test_tem.a03 = struct_objattrib('procedure', proc, 'procedure description');
  struct_test_tem.a04 = struct_objattrib('calculation', calc, 'calculation description, formula');
  struct_test_tem.a05 = struct_objattrib('description', [], 'general description');
  struct_test_tem.a06 = struct_objattrib('placement_tcpl1', 'in the center of the specimen, in paste', 'placement of thermocouple 1');
  struct_test_tem.a07 = struct_objattrib('placement_tcpl2', 'on the side panel, next to the sensor, vertical center of specimen height, in paste', 'placement of thermocouple 2');
  struct_test_tem.a08 = struct_objattrib('placement_tcpl3', 'on the mid of the lateral surface of the spacer, vertical center of specimen height, in paste', 'placement of thermocouple 3');
  struct_test_tem.a09 = struct_objattrib('placement_tcpl4', 'outside but right next to the mold, in air', 'placement of thermocouple 4');
  struct_test_tem.a10 = struct_objattrib('data_dirpath', [], 'temperature data directory path, full qualified path');
  struct_test_tem.a11 = struct_objattrib('data_filepath', [], 'temperature data file path');
  struct_test_tem.a12 = struct_objattrib('data_filename', [], 'temperature data file name');
  struct_test_tem.a13 = struct_objattrib('data_filehash', [], 'temperature data file hash, sha-256');
  
  ## struct_test_umd1
  proc = {...
    '(1) apply steel washer in hutches on both sides of specimen', ...
    '(2) measure total distance using a sliding caliper (thickness of specimen plus 2 times thickness of washer)'};
  calc = {'specimen_thickness = total_distance - (2 * spacer_thickness)'};
  struct_test_umd1.obj = 'struct_test_umd1';
  struct_test_umd1.ver = uint16([1, 0]);
  struct_test_umd1.r01 = struct_objref('author', [], 'aut', 'author reference');
  struct_test_umd1.r02 = struct_objref('specimen', [], 'spm', 'specimen reference');
  struct_test_umd1.r03 = struct_objref('device', [], 'dev', 'device reference');
  struct_test_umd1.r04 = struct_objref('location', [], 'loc', 'location reference');
  struct_test_umd1.d01 = struct_objdata('datetime', 'double', [], 'utc', 'date and time, seconds since epoch (UTC)');
  struct_test_umd1.d02 = struct_objdata('total_distance', 'double', [], 'mm', 'total distance, mesurement result');
  struct_test_umd1.d03 = struct_objdata('spacer_thickness', 'double', [], 'mm', 'thickness of spacer disks, steel washer, measurement result');
  struct_test_umd1.d04 = struct_objdata('specimen_thickness', 'double', [], 'mm', 'distance between actuator and sensor, calculated value');
  struct_test_umd1.a01 = struct_objattrib('testname', 'Ultrasonic measurement distance test 1 (caliper, spacer)', 'test name');
  struct_test_umd1.a02 = struct_objattrib('operator', [], 'operator name');
  struct_test_umd1.a03 = struct_objattrib('procedure', proc, 'procedure description');
  struct_test_umd1.a04 = struct_objattrib('calculation', calc, 'calculation description, formula');
  struct_test_umd1.a05 = struct_objattrib('description', [], 'general description');
  
  ## struct_test_umd2
  proc = {'(1) measure distance between actuator and sensor using a sliding caliper'};
  calc = {'Not required'};
  struct_test_umd2.obj = 'struct_test_umd2';
  struct_test_umd2.ver = uint16([1, 0]);
  struct_test_umd2.r01 = struct_objref('author', [], 'aut', 'author reference');
  struct_test_umd2.r02 = struct_objref('specimen', [], 'spm', 'specimen reference');
  struct_test_umd2.r03 = struct_objref('device', [], 'dev', 'device reference');
  struct_test_umd2.r04 = struct_objref('location', [], 'loc', 'location reference');
  struct_test_umd2.d01 = struct_objdata('datetime', 'double', [], 'utc', 'date and time, seconds since epoch (UTC)');
  struct_test_umd2.d02 = [];
  struct_test_umd2.d03 = [];
  struct_test_umd2.d04 = struct_objdata('specimen_thickness', 'double', [], 'mm', 'distance between actuator and sensor');
  struct_test_umd2.a01 = struct_objattrib('testname', 'Ultrasonic measurement distance test 2 (caliper)', 'test name');
  struct_test_umd2.a02 = struct_objattrib('operator', [], 'operator name');
  struct_test_umd2.a03 = struct_objattrib('procedure', proc, 'procedure description');
  struct_test_umd2.a04 = struct_objattrib('calculation', calc, 'calculation description, formula');
  struct_test_umd2.a05 = struct_objattrib('description', [], 'general description');
  
  ## struct_test_utt
  proc = {...
    '(1) check assembly of the test device (molds, cables)', ...
    '(2) assure that cables between pulse generator and actuators and cables between oscilloscope and sensors are not in close vicinity of each other', ...
    '(3) start software on computer and configure test settings', ...
    '(4) start test', ...
    '(5) wait for the test to end', ...
    '(6) remove specimen from molds by disassembling molds'};
  calc = {'Not required'};
  struct_test_utt.obj = 'struct_test_utt';
  struct_test_utt.ver = uint16([1, 0]);
  struct_test_utt.r01 = struct_objref('author', [], 'aut', 'author reference');
  struct_test_utt.r02 = struct_objref('specimen', [], 'spm', 'specimen reference');
  struct_test_utt.r03 = struct_objref('device', [], 'dev', 'device reference');
  struct_test_utt.r04 = struct_objref('location', [], 'loc', 'location reference');
  struct_test_utt.d01 = struct_objdata('datetime', 'double', [], 'utc', 'date and time, seconds since epoch (UTC)');
  struct_test_utt.d02 = struct_objdata('zerotime', 'uint', [], 'sec', 'time span between adding water to cement and test start');
  struct_test_utt.d03 = struct_objdata('interval_steps', 'uint_arr', [], [], 'number of interval steps, number of measurements');
  struct_test_utt.d04 = struct_objdata('interval_length', 'uint_arr', [], 'sec', 'interval length, time span between measurements');
  struct_test_utt.d05 = struct_objdata('pulse_voltage', 'double', [], 'V', 'device setting, pulse generator voltage');
  struct_test_utt.d06 = struct_objdata('pulse_width', 'double', [], 'sec', 'device setting, pulse generator puse width');
  struct_test_utt.d07 = struct_objdata('sampling_rate', 'uint', [], 'Hz', 'device setting, oscilloscope sampling rate');
  struct_test_utt.d08 = struct_objdata('recorded_block_size', 'uint', [], [], 'recording block size, number of recorded samples');
  struct_test_utt.d09 = struct_objdata('num_init_samples', 'uint', [], [], 'number of initial samples before trigger point');
  struct_test_utt.d10 = struct_objdata('num_signals', 'uint', [], [], 'number of recorded signals');
  struct_test_utt.d11 = struct_objdata('sig_maturity', 'uint_arr', [], 'sec', 'signal/specimen maturity array [num_signals x 1]');
  struct_test_utt.d12 = struct_objdata('sig_times', 'single_arr', [], 'sec', 'signal sample time array [num_samples x 1]');
  struct_test_utt.d13 = struct_objdata('sig_magnitudes', 'single_mat', [], 'V', 'signal magnitude matrix [num_samples x num_signals]');
  struct_test_utt.a01 = struct_objattrib('testname', 'Ultrasonic pulse transmission test', 'test name');
  struct_test_utt.a02 = struct_objattrib('operator', [], 'operator name');
  struct_test_utt.a03 = struct_objattrib('procedure', proc, 'procedure description');
  struct_test_utt.a04 = struct_objattrib('calculation', calc, 'calculation description, formula');
  struct_test_utt.a05 = struct_objattrib('description', [], 'general description');
  struct_test_utt.a06 = struct_objattrib('ss_filepath', [], 'settings file path, full qualified path');
  struct_test_utt.a07 = struct_objattrib('ss_filename', [], 'settings file name');
  struct_test_utt.a08 = struct_objattrib('ss_filehash', [], 'settings file hash, sha-256');
  struct_test_utt.a09 = struct_objattrib('mm_filepath', [], 'measurements file path, full qualified path');
  struct_test_utt.a10 = struct_objattrib('mm_filename', [], 'measurements file name');
  struct_test_utt.a11 = struct_objattrib('mm_filehash', [], 'measurements file hash, sha-256');
  struct_test_utt.a12 = struct_objattrib('data_dirpath', [], 'signal data directory path, full qualified path');
  struct_test_utt.a13 = struct_objattrib('data_filepath', [], 'signal data file path list, full qualified paths {num_signals x 1}');
  struct_test_utt.a14 = struct_objattrib('data_filename', [], 'signal data file name list {num_signals x 1}');
  struct_test_utt.a15 = struct_objattrib('data_filehash', [], 'signal data file hash list, sha-256 {num_signals x 1}');
  
  ## Project information file, parameter settings for all cement paste tests
  ## columns: {hint, tag, type, default, templr, templw, itype}
  ##   hint    ... hint for interactive input, <str>
  ##   tag     ... tag (parameter name), <str>
  ##   type    ... value type, <str>
  ##   default ... default value (can be empty), <any_GNU_octave_value>
  ##   templr  ... read template string (see textscan for details)
  ##   templw  ... write template string (see fscanf for details)
  ##   itype   ... interactive input type, <int>
  ##                 1 = generic input
  ##                 2 = selection menu, use menu item label as value
  ##                 3 = selection menu, use menu item id as value
  ##                 4 = datetime input
  ##                 5 = recipe_id
  ##                 6 = author_id
  pinfo_parmset1 = {};
  i = 1;
  pinfo_parmset1(i, :) = {'[series section]', [], [], [], [], [], []}; i = i + 1;
  pinfo_parmset1(i, :) = {'[ser] test series code', 'ser_code', 'str', {'ts1', 'ts4'}, '%q', '%s', 2}; i = i + 1;
  
  pinfo_parmset1(i, :) = {'[dataset section]', [], [], [], [], [], []}; i = i + 1;
  pinfo_parmset1(i, :) = {'[set] dataset code', 'set_code', 'str', '', '%q', '%s', 1}; i = i + 1;
  
  pinfo_parmset1(i, :) = {'[mixture section]', [], [], [], [], [], []}; i = i + 1;
  pinfo_parmset1(i, :) = {'[mix] mixture id', 'mix_id', 'uint', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[mix] device list name (mix)', 'mix_dev', 'str', {'mix'}, '%q', '%s', 2}; i = i + 1;
  pinfo_parmset1(i, :) = {'[mix] date and time, utc [sec]', 'mix_tm', 'dbl', [], '%f', '%.3f', 4}; i = i + 1;
  pinfo_parmset1(i, :) = {'[mix] recipe code', 'mix_rc', 'str', '', '%q', '%s', 2}; i = i + 1;
  pinfo_parmset1(i, :) = {'[mix] mixing time [sec]', 'mix_mt', 'uint', 180, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[mix] speed level', 'mix_sl', 'uint', {1, 2, 3}, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[mix] operator', 'mix_op', 'str', gdef.operator, '%q', '%s', 1}; i = i + 1;
  
  pinfo_parmset1(i, :) = {'[specimen section]', [], [], [], [], [], []}; i = i + 1;
  pinfo_parmset1(i, :) = {'[spm] device list name', 'spm_dev', 'str', {'spm25', 'spm50', 'spm70a', 'spm70b'}, '%q', '%s', 2}; i = i + 1;
  pinfo_parmset1(i, :) = {'[spm] date and time, utc [sec]', 'spm_tm', 'dbl', [], '%f', '%.3f', 4}; i = i + 1;
  pinfo_parmset1(i, :) = {'[spm] mix id', 'spm_mi', 'uint', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[spm] specimen 1 id', 'spm1_id', 'uint', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[spm] specimen 1 code', 'spm1_sc', 'str', '', '%q', '%s', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[spm] specimen 2 id', 'spm2_id', 'uint', 2, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[spm] specimen 2 code', 'spm2_sc', 'str', '', '%q', '%s', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[spm] operator', 'spm_op', 'str', gdef.operator, '%q', '%s', 1}; i = i + 1;
  
  pinfo_parmset1(i, :) = {'[fresh paste density section]', [], [], [], [], [], []}; i = i + 1;
  pinfo_parmset1(i, :) = {'[fpd] test exists (true, false)', 'fpd_exst', 'bool', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[fpd] mixture id', 'fpd_mi', 'uint', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[fpd] device list name', 'fpd_dev', 'str', {'fpd'}, '%q', '%s', 2}; i = i + 1;
  pinfo_parmset1(i, :) = {'[fpd] date and time, utc [sec]', 'fpd_tm', 'dbl', [], '%f', '%.3f', 4}; i = i + 1;
  pinfo_parmset1(i, :) = {'[fpd] gross weight [g]', 'fpd_wg', 'dbl', [], '%f', '%.2f', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[fpd] beaker weight [g]', 'fpd_wb', 'dbl', 466.2, '%f', '%.2f', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[fpd] beaker volume', 'fpd_vb', 'dbl', 1000.0, '%f', '%.2f', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[fpd] operator', 'fpd_op', 'str', gdef.operator, '%q', '%s', 1}; i = i + 1;
  
  pinfo_parmset1(i, :) = {'[solid specimen density section]', [], [], [], [], [], []}; i = i + 1;
  pinfo_parmset1(i, :) = {'[ssd] test exists (true, false)', 'ssd_exst', 'bool', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[ssd] device list name', 'ssd_dev', 'str', {'rsd1', 'rsd2'}, '%q', '%s', 2}; i = i + 1;
  pinfo_parmset1(i, :) = {'[ssd] date and time, utc [sec]', 'ssd_tm', 'dbl', [], '%f', '%.3f', 4}; i = i + 1;
  pinfo_parmset1(i, :) = {'[ssd] water temperature [°C]', 'ssd_tw', 'dbl', 20.0, '%f', '%.2f', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[ssd1] specimen id', 'ssd1_si', 'uint', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[ssd1] mass dry [g]', 'ssd1_md', 'dbl', [], '%f', '%.3f', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[ssd1] mass floating [g]', 'ssd1_mf', 'dbl', [], '%f', '%.3f', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[ssd2] specimen id', 'ssd2_si', 'uint', 2, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[ssd2] mass dry [g]', 'ssd2_md', 'dbl', [], '%f', '%.3f', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[ssd2] mass floating [g]', 'ssd2_mf', 'dbl', [], '%f', '%.3f', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[ssd] operator', 'ssd_op', 'str', gdef.operator, '%q', '%s', 1}; i = i + 1;
  
  pinfo_parmset1(i, :) = {'[ultrasonic measurement distance section]', [], [], [], [], [], []}; i = i + 1;
  pinfo_parmset1(i, :) = {'[umd] test exists (true, false)', 'umd_exst', 'bool', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[umd] device list name', 'umd_dev', 'str', {'umd'}, '%q', '%s', 2}; i = i + 1;
  pinfo_parmset1(i, :) = {'[umd] date and time, utc [sec]', 'umd_tm', 'dbl', [], '%f', '%.3f', 4}; i = i + 1;
  pinfo_parmset1(i, :) = {'[umd] spacer thickness [mm]', 'umd_ds', 'dbl', 2.375, '%f', '%.2f', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[umd1] specimen id', 'umd1_si', 'uint', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[umd1] total distance 1 (specimen + 2*spacer) [mm]', 'umd1_dt', 'dbl', [], '%f', '%.2f', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[umd2] specimen id', 'umd2_si', 'uint', 2, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[umd2] total distance 2 (specimen + 2*spacer) [mm]', 'umd2_dt', 'dbl', [], '%f', '%.2f', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[umd] operator', 'umd_op', 'str', gdef.operator, '%q', '%s', 1}; i = i + 1;
  
  pinfo_parmset1(i, :) = {'[ultrasonic transmission test section]', [], [], [], [], [], []}; i = i + 1;
  pinfo_parmset1(i, :) = {'[utt] test exists (true, false)', 'utt_exst', 'bool', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[utt] device list name', 'utt_dev', 'str', {'utt'}, '%q', '%s', 2}; i = i + 1;
  pinfo_parmset1(i, :) = {'[utt] date and time, utc [sec]', 'utt_tm', 'dbl', [], '%f', '%.3f', 4}; i = i + 1;
  pinfo_parmset1(i, :) = {'[utt] zerotime, [sec]', 'utt_t0', 'uint', 0, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[utt1] specimen id', 'utt1_si', 'uint', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[utt1] device list name', 'utt1_dev', 'str', {'fc250'}, '%q', '%s', 2}; i = i + 1;
  pinfo_parmset1(i, :) = {'[utt2] specimen id', 'utt2_si', 'uint', 2, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[utt2] device list name', 'utt2_dev', 'str', {'fs250', 'fs110'}, '%q', '%s', 2}; i = i + 1;
  pinfo_parmset1(i, :) = {'[utt] operator', 'utt_op', 'str', gdef.operator, '%q', '%s', 1}; i = i + 1;
  
  pinfo_parmset1(i, :) = {'[specimen temperature section]', [], [], [], [], [], []}; i = i + 1;
  pinfo_parmset1(i, :) = {'[tem] test exists (true, false)', 'tem_exst', 'bool', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[tem] specimen id', 'tem_si', 'uint', 2, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[tem] device list name', 'tem_dev', 'str', {'tem1', 'tem2'}, '%q', '%s', 2}; i = i + 1;
  pinfo_parmset1(i, :) = {'[tem] operator', 'tem_op', 'str', gdef.operator, '%q', '%s', 1}; i = i + 1;
  
  pinfo_parmset1(i, :) = {'[environment temperature section]', [], [], [], [], [], []}; i = i + 1;
  pinfo_parmset1(i, :) = {'[env] test exists (true, false)', 'env_exst', 'bool', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[env] device list name', 'env_dev', 'str', {'env'}, '%q', '%s', 2}; i = i + 1;
  pinfo_parmset1(i, :) = {'[env] date and time, utc [sec]', 'env_tm', 'dbl', [], '%f', '%.3f', 4}; i = i + 1;
  pinfo_parmset1(i, :) = {'[env] environment temperature [°C]', 'env_te', 'dbl', 20.0, '%f', '%.2f', 1}; i = i + 1;
  pinfo_parmset1(i, :) = {'[env] operator', 'env_op', 'str', gdef.operator, '%q', '%s', 1}; i = i + 1;
  
  ## Project information file, parameter settings for aluminium cylinder reference test
  ## columns: {hint, tag, type, default, templr, templw, itype}
  ##   hint    ... hint for interactive input, <str>
  ##   tag     ... tag (parameter name), <str>
  ##   type    ... value type, <str>
  ##   default ... default value (can be empty), <any_GNU_octave_value>
  ##   templr  ... read template string (see textscan for details)
  ##   templw  ... write template string (see fscanf for details)
  ##   itype   ... interactive input type, <int>
  ##                 1 = generic input
  ##                 2 = selection menu, use menu item label as value
  ##                 3 = selection menu, use menu item id as value
  ##                 4 = datetime input
  ##                 5 = recipe_id
  ##                 6 = author_id
  pinfo_parmset2 = {};
  i = 1;
  pinfo_parmset2(i, :) = {'[series section]', [], [], [], [], [], []}; i = i + 1;
  pinfo_parmset2(i, :) = {'[ser] test series code', 'ser_code', 'str', {'ts7'}, '%q', '%s', 2}; i = i + 1;
  
  pinfo_parmset2(i, :) = {'[dataset section]', [], [], [], [], [], []}; i = i + 1;
  pinfo_parmset2(i, :) = {'[set] dataset code', 'set_code', 'str', '', '%q', '%s', 1}; i = i + 1;
  
  pinfo_parmset2(i, :) = {'[specimen section]', [], [], [], [], [], []}; i = i + 1;
  pinfo_parmset2(i, :) = {'[spm] device list name', 'spm_dev', 'str', {'spm50ns'}, '%q', '%s', 2}; i = i + 1;
  pinfo_parmset2(i, :) = {'[spm] date and time, utc [sec]', 'spm_tm', 'dbl', [], '%f', '%.3f', 4}; i = i + 1;
  pinfo_parmset2(i, :) = {'[spm] material id', 'spm_mi', 'uint', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset2(i, :) = {'[spm] specimen id', 'spm_id', 'uint', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset2(i, :) = {'[spm] specimen code', 'spm_sc', 'str', '', '%q', '%s', 1}; i = i + 1;
  pinfo_parmset2(i, :) = {'[spm] operator', 'spm_op', 'str', gdef.operator, '%q', '%s', 1}; i = i + 1;
  
  pinfo_parmset2(i, :) = {'[solid specimen density section]', [], [], [], [], [], []}; i = i + 1;
  pinfo_parmset2(i, :) = {'[ssd] test exists (true, false)', 'ssd_exst', 'bool', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset2(i, :) = {'[ssd] device list name', 'ssd_dev', 'str', {'rsd1', 'rsd2'}, '%q', '%s', 2}; i = i + 1;
  pinfo_parmset2(i, :) = {'[ssd] date and time, utc [sec]', 'ssd_tm', 'dbl', [], '%f', '%.3f', 4}; i = i + 1;
  pinfo_parmset2(i, :) = {'[ssd] specimen id', 'ssd_si', 'uint', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset2(i, :) = {'[ssd] weight [g]', 'ssd_wght', 'dbl', [], '%f', '%.3f', 1}; i = i + 1;
  pinfo_parmset2(i, :) = {'[ssd] diameter [mm]', 'ssd_dia', 'dbl', [], '%f', '%.3f', 1}; i = i + 1;
  pinfo_parmset2(i, :) = {'[ssd] length [mm]', 'ssd_len', 'dbl', [], '%f', '%.3f', 1}; i = i + 1;
  pinfo_parmset2(i, :) = {'[ssd] operator', 'ssd_op', 'str', gdef.operator, '%q', '%s', 1}; i = i + 1;
  
  pinfo_parmset2(i, :) = {'[ultrasonic measurement distance section]', [], [], [], [], [], []}; i = i + 1;
  pinfo_parmset2(i, :) = {'[umd] test exists (true, false)', 'umd_exst', 'bool', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset2(i, :) = {'[umd] device list name', 'umd_dev', 'str', {'umd'}, '%q', '%s', 2}; i = i + 1;
  pinfo_parmset2(i, :) = {'[umd] date and time, utc [sec]', 'umd_tm', 'dbl', [], '%f', '%.3f', 4}; i = i + 1;
  pinfo_parmset2(i, :) = {'[umd] specimen id', 'umd_si', 'uint', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset2(i, :) = {'[umd] distance [mm]', 'umd_dist', 'dbl', [], '%f', '%.2f', 1}; i = i + 1;
  pinfo_parmset2(i, :) = {'[umd] operator', 'umd_op', 'str', gdef.operator, '%q', '%s', 1}; i = i + 1;
  
  pinfo_parmset2(i, :) = {'[ultrasonic transmission test section]', [], [], [], [], [], []}; i = i + 1;
  pinfo_parmset2(i, :) = {'[utt] test exists (true, false)', 'utt_exst', 'bool', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset2(i, :) = {'[utt] device list name', 'utt_dev', 'str', {'utt'}, '%q', '%s', 2}; i = i + 1;
  pinfo_parmset2(i, :) = {'[utt] date and time, utc [sec]', 'utt_tm', 'dbl', [], '%f', '%.3f', 4}; i = i + 1;
  pinfo_parmset2(i, :) = {'[utt] zerotime, [sec]', 'utt_t0', 'uint', 0, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset2(i, :) = {'[utt1] specimen id', 'utt1_si', 'uint', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset2(i, :) = {'[utt1] device list name', 'utt1_dev', 'str', {'fc250'}, '%q', '%s', 2}; i = i + 1;
  pinfo_parmset2(i, :) = {'[utt2] specimen id', 'utt2_si', 'uint', 2, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset2(i, :) = {'[utt2] device list name', 'utt2_dev', 'str', {'fs250', 'fs110'}, '%q', '%s', 2}; i = i + 1;
  pinfo_parmset2(i, :) = {'[utt] operator', 'utt_op', 'str', gdef.operator, '%q', '%s', 1}; i = i + 1;
  
  pinfo_parmset2(i, :) = {'[environment temperature/humidity section]', [], [], [], [], [], []}; i = i + 1;
  pinfo_parmset2(i, :) = {'[env] test exists (true, false)', 'env_exst', 'bool', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset2(i, :) = {'[env] device list name', 'env_dev', 'str', {'env'}, '%q', '%s', 2}; i = i + 1;
  pinfo_parmset2(i, :) = {'[env] date and time, utc [sec]', 'env_tm', 'dbl', [], '%f', '%.3f', 4}; i = i + 1;
  pinfo_parmset2(i, :) = {'[env] environment temperature [°C]', 'env_te', 'dbl', 20.0, '%f', '%.2f', 1}; i = i + 1;
  pinfo_parmset2(i, :) = {'[env] environment humidity [%]', 'env_hu', 'dbl', 20.0, '%f', '%.2f', 1}; i = i + 1;
  pinfo_parmset2(i, :) = {'[env] operator', 'env_op', 'str', gdef.operator, '%q', '%s', 1}; i = i + 1;
  
  ## Project information file, parameter settings for air and water reference tests
  ## columns: {hint, tag, type, default, templr, templw, itype}
  ##   hint    ... hint for interactive input, <str>
  ##   tag     ... tag (parameter name), <str>
  ##   type    ... value type, <str>
  ##   default ... default value (can be empty), <any_GNU_octave_value>
  ##   templr  ... read template string (see textscan for details)
  ##   templw  ... write template string (see fscanf for details)
  ##   itype   ... interactive input type, <int>
  ##                 1 = generic input
  ##                 2 = selection menu, use menu item label as value
  ##                 3 = selection menu, use menu item id as value
  ##                 4 = datetime input
  ##                 5 = recipe_id
  ##                 6 = author_id
  pinfo_parmset3 = {};
  i = 1;
  pinfo_parmset3(i, :) = {'[series section]', [], [], [], [], [], []}; i = i + 1;
  pinfo_parmset3(i, :) = {'[ser] test series code', 'ser_code', 'str', {'ts3', 'ts5', 'ts6'}, '%q', '%s', 2}; i = i + 1;
  
  pinfo_parmset3(i, :) = {'[dataset section]', [], [], [], [], [], []}; i = i + 1;
  pinfo_parmset3(i, :) = {'[set] dataset code', 'set_code', 'str', '', '%q', '%s', 1}; i = i + 1;
  
  pinfo_parmset3(i, :) = {'[specimen section]', [], [], [], [], [], []}; i = i + 1;
  pinfo_parmset3(i, :) = {'[spm] device list name', 'spm_dev', 'str', ...
    {'spm25', 'spm50', 'spm70a', 'spm70b', 'spm00ns', 'spm20ns', 'spm25ns', 'spm50ns', 'spm70ns', 'spm90ns'}, '%q', '%s', 2}; i = i + 1;
  pinfo_parmset3(i, :) = {'[spm] date and time, utc [sec]', 'spm_tm', 'dbl', [], '%f', '%.3f', 4}; i = i + 1;
  pinfo_parmset3(i, :) = {'[spm] material id', 'spm_mi', 'uint', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset3(i, :) = {'[spm] specimen id', 'spm_id', 'uint', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset3(i, :) = {'[spm] specimen code', 'spm_sc', 'str', '', '%q', '%s', 1}; i = i + 1;
  pinfo_parmset3(i, :) = {'[spm] operator', 'spm_op', 'str', gdef.operator, '%q', '%s', 1}; i = i + 1;
  
  pinfo_parmset3(i, :) = {'[ultrasonic measurement distance section]', [], [], [], [], [], []}; i = i + 1;
  pinfo_parmset3(i, :) = {'[umd] test exists (true, false)', 'umd_exst', 'bool', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset3(i, :) = {'[umd] device list name', 'umd_dev', 'str', {'umd'}, '%q', '%s', 2}; i = i + 1;
  pinfo_parmset3(i, :) = {'[umd] date and time, utc [sec]', 'umd_tm', 'dbl', [], '%f', '%.3f', 4}; i = i + 1;
  pinfo_parmset3(i, :) = {'[umd1] specimen id', 'umd1_si', 'uint', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset3(i, :) = {'[umd1] distance 1 [mm]', 'umd1_dist', 'dbl', [], '%f', '%.2f', 1}; i = i + 1;
  pinfo_parmset3(i, :) = {'[umd2] specimen id', 'umd2_si', 'uint', 2, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset3(i, :) = {'[umd2] distance 2 [mm]', 'umd2_dist', 'dbl', [], '%f', '%.2f', 1}; i = i + 1;
  pinfo_parmset3(i, :) = {'[umd] operator', 'umd_op', 'str', gdef.operator, '%q', '%s', 1}; i = i + 1;
  
  pinfo_parmset3(i, :) = {'[ultrasonic transmission test section]', [], [], [], [], [], []}; i = i + 1;
  pinfo_parmset3(i, :) = {'[utt] test exists (true, false)', 'utt_exst', 'bool', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset3(i, :) = {'[utt] device list name', 'utt_dev', 'str', {'utt'}, '%q', '%s', 2}; i = i + 1;
  pinfo_parmset3(i, :) = {'[utt] date and time, utc [sec]', 'utt_tm', 'dbl', [], '%f', '%.3f', 4}; i = i + 1;
  pinfo_parmset3(i, :) = {'[utt] zerotime, [sec]', 'utt_t0', 'uint', 0, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset3(i, :) = {'[utt1] specimen id', 'utt1_si', 'uint', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset3(i, :) = {'[utt1] device list name', 'utt1_dev', 'str', {'fc250'}, '%q', '%s', 2}; i = i + 1;
  pinfo_parmset3(i, :) = {'[utt2] specimen id', 'utt2_si', 'uint', 2, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset3(i, :) = {'[utt2] device list name', 'utt2_dev', 'str', {'fs250', 'fs110'}, '%q', '%s', 2}; i = i + 1;
  pinfo_parmset3(i, :) = {'[utt] operator', 'utt_op', 'str', gdef.operator, '%q', '%s', 1}; i = i + 1;
  
  pinfo_parmset3(i, :) = {'[environment temperature/humidity section]', [], [], [], [], [], []}; i = i + 1;
  pinfo_parmset3(i, :) = {'[env] test exists (true, false)', 'env_exst', 'bool', 1, '%u', '%u', 1}; i = i + 1;
  pinfo_parmset3(i, :) = {'[env] device list name', 'env_dev', 'str', {'env'}, '%q', '%s', 2}; i = i + 1;
  pinfo_parmset3(i, :) = {'[env] date and time, utc [sec]', 'env_tm', 'dbl', [], '%f', '%.3f', 4}; i = i + 1;
  pinfo_parmset3(i, :) = {'[env] environment temperature [°C]', 'env_te', 'dbl', 20.0, '%f', '%.2f', 1}; i = i + 1;
  pinfo_parmset3(i, :) = {'[env] environment humidity [%]', 'env_hu', 'dbl', 20.0, '%f', '%.2f', 1}; i = i + 1;
  pinfo_parmset3(i, :) = {'[env] operator', 'env_op', 'str', gdef.operator, '%q', '%s', 1}; i = i + 1;
  
  ## Project information file header
  pinfo_header = {...
    '## PROJECT INFORMATION FILE', ...
    '## Data types:', ...
    '##   [str]  ... string', ...
    '##   [bool] ... boolean', ...
    '##   [uint] ... unsigned integer', ...
    '##   [int]  ... signed integer', ...
    '##   [sng]  ... single precision floating point value', ...
    '##   [dbl]  ... double precision floating point value'};
  
  ## License header
  license_header = {...
    sprintf('## LIC Copyright 2022 %s, %s', gdef.rights, gdef.rightsholder), ...
    '## LIC This file is part of the PhD thesis of Jakob Harden.'};
  
  ## Save structure
  save('-binary', p_ofp, ...
    'struct_dataset', ...
    'struct_mix', ...
    'struct_mix_component', ...
    'struct_spm_paste', ...
    'struct_spm_ref', ...
    'struct_test', ...
    'struct_test_env1', ...
    'struct_test_env2', ...
    'struct_test_fpd', ...
    'struct_test_ssd1', ...
    'struct_test_ssd2', ...
    'struct_test_tem', ...
    'struct_test_umd1', ...
    'struct_test_umd2', ...
    'struct_test_utt', ...
    'gdef', ...
    'pinfo_parmset1', ...
    'pinfo_parmset2', ...
    'pinfo_parmset3', ...
    'pinfo_header', ...
    'license_header');
  
endfunction
