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
## Create device database file (GNU octave binary file)
##
## Usage: struct_make_devdb(p_ofp)
##
## p_ofp ... output file path (database file path), optional, <str>
##             default: ./struct_hdf/db/db_dev.oct
##
## item ... device data structure, <struct>
##   .obj ... object type, always "struct_dev", <str>
##   .ver ... version number [major_ver, minor_ver], [<uint>]
##   .d01 ... device id, <ADE/struct>
##   .a01 ... device name, <AAE/struct>
##   .a02 ... vendor name, <AAE/struct>
##   .a03 ... product name, <AAE/struct>
##   .a04 ... device category, <AAE/struct>
##   .a05 ... device usage, <AAE/struct>
##   .a06 ... device description, <AAE/struct>
##   .s01 ... device properties, device dependent, [<struct>]
##
## Predefined device group names:
##   'utt':    ultrasonic transmission test, oscilloscope, pulse trigger, pulse generator and wires
##   'fc500':  ultrasonic transmission test, fc=500kHz, sensor and sensor wires
##   'fs500':  ultrasonic transmission test, fs=500kHz, sensor and sensor wires
##   'fs110':  ultrasonic transmission test, fs=110kHz, sensor and sensor wires
##   'tem1':   temperature measurement devices (DAQ, thermo-couples type T)
##   'tem2':   temperature measurement devices (DAQ, thermo-couples type K)
##   'ssd1':   solid specimen density, scale Sartorius LC2200
##   'ssd2':   solid specimen density, scale Sartorius BP1200S
##   'ssd3':   solid specimen density, scale Sartorius LC2200, caliper
##   'fpd':    fresh paste density, scale Mettler Toledo MS1600, trowel
##   'umd1':   ultrasonic measurement distance (caliper, spacer)
##   'umd2':   ultrasonic measurement distance (caliper)
##   'mix':    mixing/blending devices
##   'spm25':  mold, 25mm distance
##   'spm50':  mold, 50mm distance
##   'spm70a': mold, 70mm distance, version 1
##   'spm70b': mold, 70mm distance, version 2
##   'spm25ns': mold, 25mm distance, no spacer
##   'spm50ns': mold, 50mm distance, no spacer
##   'spm70ns': mold, 70mm distance, no spacer
##   'spm90ns': mold, 90mm distance, no spacer
##   'spm00ns':  mold, 0mm distance, no spacer, face-to-face test
##   'spm20ns':  mold, 20mm distance, no spacer
##   'env':     environment temperature/humidity logger
##
## see also: init, struct_dataset
##
function struct_make_devdb(p_ofp)
  
  ## read database file path from global variable, see also init.m
  global dsc_dbpath_dev
  
  ## check arguments
  if (nargin < 1)
    p_ofp = dsc_dbpath_dev;
  endif
  if isempty(p_ofp)
    p_ofp = dsc_dbpath_dev;
  endif
  
  ## Device group names
  devgroup(1).name = "utt";
  devgroup(1).devid = [5, 6, 7, 8, 10, 12, 13];
  devgroup(2).name = "fc500";
  devgroup(2).devid = [1, 3, 14, 15];
  devgroup(3).name = "fs500";
  devgroup(3).devid = [2, 4, 16, 17];
  devgroup(4).name = "fs110";
  devgroup(4).devid = [2, 4, 18, 19];
  devgroup(5).name = "uttfc500";
  devgroup(5).devid = sort([devgroup(1).devid, devgroup(2).devid]);
  devgroup(6).name = "uttfs500";
  devgroup(6).devid = sort([devgroup(1).devid, devgroup(3).devid]);
  devgroup(7).name = "uttfs110";
  devgroup(7).devid = sort([devgroup(1).devid, devgroup(4).devid]);
  devgroup(8).name = "tem1";
  devgroup(8).devid = [9, 11];
  devgroup(9).name = "tem2";
  devgroup(9).devid = [31, 32];
  devgroup(10).name = "ssd1";
  devgroup(10).devid = [24];
  devgroup(11).name = "ssd2";
  devgroup(11).devid = [25];
  devgroup(12).name = "ssd3";
  devgroup(12).devid = [24, 27];
  devgroup(13).name = "fpd";
  devgroup(13).devid = [26, 29, 34];
  devgroup(14).name = "umd1";
  devgroup(14).devid = [27, 30];
  devgroup(15).name = "umd2";
  devgroup(15).devid = [27];
  devgroup(16).name = "mix";
  devgroup(16).devid = [26, 28];
  devgroup(17).name = "spm25";
  devgroup(17).devid = [20];
  devgroup(18).name = "spm50";
  devgroup(18).devid = [21];
  devgroup(19).name = "spm70a";
  devgroup(19).devid = [22];
  devgroup(20).name = "spm70b";
  devgroup(20).devid = [23];
  devgroup(21).name = "env";
  devgroup(21).devid = [33];
  devgroup(22).name = "spm25ns";
  devgroup(22).devid = [35];
  devgroup(23).name = "spm50ns";
  devgroup(23).devid = [36];
  devgroup(24).name = "spm70ns";
  devgroup(24).devid = [37];
  devgroup(25).name = "spm90ns";
  devgroup(25).devid = [38];
  devgroup(26).name = "spm00ns";
  devgroup(26).devid = [39];
  devgroup(27).name = "spm20ns";
  devgroup(27).devid = [40];
  
  ## init empty data structure
  item_empty.obj = 'struct_dev';
  item_empty.ver = uint16([1, 0]);
  item_empty.d01 = struct_objdata('device_id', 'uint', [], '', 'device id');
  item_empty.a01 = struct_objattrib('name', [], 'device name');
  item_empty.a02 = struct_objattrib('vendor', [], 'vendor name');
  item_empty.a03 = struct_objattrib('product', [], 'product name');
  item_empty.a04 = struct_objattrib('category', [], 'device category');
  item_empty.a05 = struct_objattrib('usage', [], 'device usage');
  item_empty.a06 = struct_objattrib('description', [], 'device description');
  item_empty.s01 = [];

  ## device, id = 1
  id = 1;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Wire-Pgen-Act1';
  item(id).a02.v = 'n.n.';
  item(id).a03.v = 'n.n.';
  item(id).a04.v = 'cable';
  item(id).a05.v = 'connecting pulse generator to Piezo actuator 1';
  item(id).a06.v = 'part of ultrasonic test device';
  item(id).s01(1) = struct_objdata('cable_type', 'string', 'coaxial', '', 'cable type');
  item(id).s01(2) = struct_objdata('number_wires', 'uint', 2, '', 'number of wires');
  item(id).s01(3) = struct_objdata('shielded', 'boolean', false, '', 'is shielded (true/false)');
  item(id).s01(4) = struct_objdata('connector_1', 'string', 'BNC', '', 'first connector type');
  item(id).s01(5) = struct_objdata('connector_2', 'string', 'Lemo', '', 'second connector type');
  item(id).s01(6) = struct_objdata('length', 'double', 1.0, 'm', 'cable length');
  item(id).s01(7) = struct_objdata('resistance', 'double', 50.0, 'Ohm/m', 'electric resistance');
  
  ## device, id = 2
  id = 2;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Wire-Pgen-Act2';
  item(id).a02.v = 'n.n.';
  item(id).a03.v = 'n.n.';
  item(id).a04.v = 'cable';
  item(id).a05.v = 'connecting pulse generator to Piezo actuator 2';
  item(id).a06.v = 'part of ultrasonic test device';
  item(id).s01(1) = struct_objdata('cable_type', 'string', 'coaxial', '', 'cable type');
  item(id).s01(2) = struct_objdata('number_wires', 'uint', 2, '', 'number of wires');
  item(id).s01(3) = struct_objdata('shielded', 'boolean', false, '', 'is shielded (true/false)');
  item(id).s01(4) = struct_objdata('connector_1', 'string', 'BNC', '', 'first connector type');
  item(id).s01(5) = struct_objdata('connector_2', 'string', 'Lemo', '', 'second connector type');
  item(id).s01(6) = struct_objdata('length', 'double', 1.0, 'm', 'cable length');
  item(id).s01(7) = struct_objdata('resistance', 'double', 50.0, 'Ohm/m', 'electric resistance per length unit');
  
  ## device, id = 3
  id = 3;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Wire-Osci-Sen1';
  item(id).a02.v = 'n.n.';
  item(id).a03.v = 'n.n.';
  item(id).a04.v = 'cable';
  item(id).a05.v = 'connecting oscilloscope to Piezo sensor 1';
  item(id).a06.v = 'part of ultrasonic test device';
  item(id).s01(1) = struct_objdata('cable_type', 'string', 'coaxial', '', 'cable type');
  item(id).s01(2) = struct_objdata('number_wires', 'uint', 2, '', 'number of wires');
  item(id).s01(3) = struct_objdata('shielded', 'boolean', false, '', 'is shielded (true/false)');
  item(id).s01(4) = struct_objdata('connector_1', 'string', 'BNC', '', 'first connector type');
  item(id).s01(5) = struct_objdata('connector_2', 'string', 'BNC', '', 'second connector type');
  item(id).s01(6) = struct_objdata('length', 'double', 1.0, 'm', 'cable length');
  item(id).s01(7) = struct_objdata('resistance', 'double', 50.0, 'Ohm/m', 'electric resistance per length unit');
  
  ## device, id = 4
  id = 4;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Wire-Osci-Sen2';
  item(id).a02.v = 'n.n.';
  item(id).a03.v = 'n.n.';
  item(id).a04.v = 'cable';
  item(id).a05.v = 'connecting oscilloscope to Piezo sensor 2';
  item(id).a06.v = 'part of ultrasonic test device';
  item(id).s01(1) = struct_objdata('cable_type', 'string', 'coaxial', '', 'cable type');
  item(id).s01(2) = struct_objdata('number_wires', 'uint', 2, '', 'number of wires');
  item(id).s01(3) = struct_objdata('shielded', 'boolean', false, '', 'is shielded (true/false)');
  item(id).s01(4) = struct_objdata('connector_1', 'string', 'BNC', '', 'first connector type');
  item(id).s01(5) = struct_objdata('connector_2', 'string', 'BNC', '', 'second connector type');
  item(id).s01(6) = struct_objdata('length', 'double', 1.0, 'm', 'cable length');
  item(id).s01(7) = struct_objdata('resistance', 'double', 50.0, 'Ohm/m', 'electric resistance per length unit');
  
  ## device, id = 5
  id = 5;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Wire-Osci-Trig';
  item(id).a02.v = 'n.n.';
  item(id).a03.v = 'n.n.';
  item(id).a04.v = 'cable';
  item(id).a05.v = 'connecting oscilloscope to pulse trigger';
  item(id).a06.v = 'part of ultrasonic test device';
  item(id).s01(1) = struct_objdata('cable_type', 'string', 'coaxial', '', 'cable type');
  item(id).s01(2) = struct_objdata('number_wires', 'uint', 2, '', 'number of wires');
  item(id).s01(3) = struct_objdata('shielded', 'boolean', false, '', 'is shielded (true/false)');
  item(id).s01(4) = struct_objdata('connector_1', 'string', 'BNC', '', 'first connector type');
  item(id).s01(5) = struct_objdata('connector_2', 'string', 'BNC', '', 'second connector type');
  
  ## device, id = 6
  id = 6;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Wire-Pgen-Trig';
  item(id).a02.v = 'n.n.';
  item(id).a03.v = 'n.n.';
  item(id).a04.v = 'cable';
  item(id).a05.v = 'connecting pulse generator to pulse trigger';
  item(id).a06.v = 'part of ultrasonic test device';
  item(id).s01(1) = struct_objdata('cable_type', 'string', 'coaxial', '', 'cable type');
  item(id).s01(2) = struct_objdata('number_wires', 'uint', 2, '', 'number of wires');
  item(id).s01(3) = struct_objdata('shielded', 'boolean', false, '', 'is shielded (true/false)');
  item(id).s01(4) = struct_objdata('connector_1', 'string', 'BNC', '', 'first connector type');
  item(id).s01(5) = struct_objdata('connector_2', 'string', 'BNC', '', 'second connector type');
  
  ## device, id = 7
  id = 7;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Wire-Osci-Com';
  item(id).a02.v = 'n.n.';
  item(id).a03.v = 'n.n.';
  item(id).a04.v = 'cable';
  item(id).a05.v = 'connecting oscilloscope to computer';
  item(id).a06.v = 'part of ultrasonic test device';
  item(id).s01(1) = struct_objdata('cable_type', 'string', 'twisted-pair', '', 'cable type');
  item(id).s01(2) = struct_objdata('number_wires', 'uint', 4, '', 'number of wires');
  item(id).s01(3) = struct_objdata('shielded', 'boolean', true, '', 'is shielded (true/false)');
  item(id).s01(4) = struct_objdata('connector_1', 'string', 'USB-A', '', 'first connector type');
  item(id).s01(5) = struct_objdata('connector_2', 'string', 'USB-B', '', 'second connector type');
  
  ## device, id = 8
  id = 8;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Wire-Trigger-Computer';
  item(id).a02.v = 'n.n.';
  item(id).a03.v = 'n.n.';
  item(id).a04.v = 'cable';
  item(id).a05.v = 'connecting pulse trigger to computer';
  item(id).a06.v = 'part of ultrasonic test device';
  item(id).s01(1) = struct_objdata('cable_type', 'string', 'twisted-pair', '', 'cable type');
  item(id).s01(2) = struct_objdata('number_wires', 'uint', 4, '', 'number of wires');
  item(id).s01(3) = struct_objdata('shielded', 'boolean', true, '', 'is shielded (true/false)');
  item(id).s01(4) = struct_objdata('connector_1', 'string', 'USB-A', '', 'first connector type');
  item(id).s01(5) = struct_objdata('connector_2', 'string', 'USB-B', '', 'second connector type');
  
  ## device, id = 9
  id = 9;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Thermocouple-T';
  item(id).a02.v = 'RS Components Handelsgesm.b.H. (Gmünd, Austria)';
  item(id).a03.v = 'Thermo Couple Type T';
  item(id).a04.v = 'cable';
  item(id).a05.v = 'connecting temperature DAQ to specimen or air';
  item(id).a06.v = 'part of ultrasonic test device';
  item(id).s01(1) = struct_objdata('couple_type', 'string', 'T', '', 'couple type');
  item(id).s01(2) = struct_objdata('cable_type', 'string', 'straight-pair', '', 'cable type');
  item(id).s01(3) = struct_objdata('number_wires', 'uint', 2, '', 'number of wires');
  item(id).s01(4) = struct_objdata('shielded', 'boolean', false, '', 'is shielded (true/false)');
  item(id).s01(5) = struct_objdata('connector_1', 'string', 'None', '', 'first connector type');
  item(id).s01(6) = struct_objdata('connector_2', 'string', 'None', '', 'second connector type');
  item(id).s01(7) = struct_objdata('length_min_max', 'double_arr', [0.4, 1.2], 'm', 'min/max cable length');
  
  ## device, id = 10
  id = 10;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'PS-4262';
  item(id).a02.v = 'Pico Technology (St Neots, Cambridgeshire, United Kingdom)';
  item(id).a03.v = 'PicoScope 4262';
  item(id).a04.v = 'DAQ';
  item(id).a05.v = 'ultrasonic pulse transmission test';
  item(id).a06.v = 'part of ultrasonic test device';
  item(id).s01(1) = struct_objdata('resolution_max', 'uint', 16, 'bit', 'max voltage resolution, vertical resolution');
  item(id).s01(2) = struct_objdata('samplerate_max', 'uint', 10000000, 'Hz', 'max sampling rate, horizontal resolution');
  item(id).s01(3) = struct_objdata('number_signal_ports', 'uint', 2, '', 'number of available signal ports');
  item(id).s01(4) = struct_objdata('number_trigger_ports', 'uint', 1, '', 'number of available trigger signal ports');
  item(id).s01(5) = struct_objdata('number_com_ports', 'uint', 1, '', 'number of available communication ports');
  item(id).s01(6) = struct_objdata('connector_signal_port1', 'string', 'BNC', '', 'signal port 1, connector type');
  item(id).s01(7) = struct_objdata('connector_signal_port2', 'string', 'BNC', '', 'signal port 2, connector type');
  item(id).s01(8) = struct_objdata('connector_trigger_port1', 'string', 'BNC', '', 'trigger signal port 1, connector type');
  item(id).s01(9) = struct_objdata('connector_com_port1', 'string', 'USB-B', '', 'communication port 1, connector type');
  item(id).s01(10) = struct_objdata('power_supply', 'string', 'power over USB, com_port1', '', 'device power supply description');
  
  ## device, id = 11
  id = 11;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'NI-9217';
  item(id).a02.v = 'National Instruments (Austin, TX, USA)';
  item(id).a03.v = 'cDAQ-9171';
  item(id).a04.v = 'DAQ';
  item(id).a05.v = 'specimen temperature measurement';
  item(id).a06.v = 'part of ultrasonic test device';
  item(id).s01(1) = struct_objdata('resolution_max', 'uint', 24, 'bit', 'max voltage resolution, vertical resolution');
  item(id).s01(2) = struct_objdata('samplerate_max', 'uint', 400, 'Hz', 'max sampling rate, horizontal resolution');
  item(id).s01(3) = struct_objdata('number_signal_ports', 'uint', 4, '', 'number of available signal ports');
  item(id).s01(4) = struct_objdata('number_com_ports', 'uint', 1, '', 'number of available communication ports');
  item(id).s01(5) = struct_objdata('connector_signal_port1', 'string', 'screw terminal', '', 'signal port 1, connector type');
  item(id).s01(6) = struct_objdata('connector_signal_port2', 'string', 'screw terminal', '', 'signal port 2, connector type');
  item(id).s01(7) = struct_objdata('connector_signal_port3', 'string', 'screw terminal', '', 'signal port 3, connector type');
  item(id).s01(8) = struct_objdata('connector_signal_port4', 'string', 'screw terminal', '', 'signal port 4, connector type');
  item(id).s01(9) = struct_objdata('connector_com_port1', 'string', 'USB-B', '', 'communication port 1, connector type');
  item(id).s01(10) = struct_objdata('power_supply', 'string', 'power over USB, com_port1', '', 'device power supply description');
  
  ## device, id = 12
  id = 12;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'HVP-1000';
  item(id).a02.v = 'piezosystem Jena (Jena, Germany)';
  item(id).a03.v = 'HVP-1000/200 high voltage pulse generator';
  item(id).a04.v = 'pulse generator';
  item(id).a05.v = 'ultrasonic pulse transmission test';
  item(id).a06.v = 'part of ultrasonic test device';
  item(id).s01(1) = struct_objdata('pulse_voltage_min_max', 'double_arr', [40.0, 1000.0], 'V', 'min/max pulse voltage');
  item(id).s01(2) = struct_objdata('pulse_current_max', 'double', 200.0, 'A', 'max pulse current');
  item(id).s01(3) = struct_objdata('number_output_ports', 'uint', 2, '', 'number of pulse output ports');
  item(id).s01(4) = struct_objdata('number_trigger_ports', 'uint', 1, '', 'number of trigger signal input ports');
  item(id).s01(5) = struct_objdata('connector_output_port1', 'string', 'Lemo', '', 'pulse output port 1, connector type');
  item(id).s01(6) = struct_objdata('connector_output_port2', 'string', 'Lemo', '', 'pulse output port 2, connector type');
  item(id).s01(7) = struct_objdata('connector_trigger_port1', 'string', 'BNC', '', 'trigger signal input port 1, connector type');
  item(id).s01(8) = struct_objdata('power_supply', 'string', 'net, 230V AC', '', 'device power supply description');
  
  ## device, id = 13
  id = 13;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'SMARTPULSE';
  item(id).a02.v = 'SmartMote (Hürth, Germany)';
  item(id).a03.v = 'USB Pulse Trigger Module v1.6';
  item(id).a04.v = 'pulse trigger';
  item(id).a05.v = 'ultrasonic pulse transmission test';
  item(id).a06.v = 'part of ultrasonic test device';
  item(id).s01(1) = struct_objdata('number_trigger_ports', 'uint', 2, '', 'number of trigger signal output ports');
  item(id).s01(2) = struct_objdata('number_com_ports', 'uint', 1, '', 'number of communication ports');
  item(id).s01(3) = struct_objdata('connector_trigger_port1', 'string', 'BNC', '', 'trigger signal output port 1, connector type');
  item(id).s01(4) = struct_objdata('connector_trigger_port2', 'string', 'BNC', '', 'trigger signal output port 2, connector type');
  item(id).s01(5) = struct_objdata('connector_com_port1', 'string', 'USB-B', '', 'communication port 1, connector type');
  item(id).s01(6) = struct_objdata('power_supply', 'string', 'power over USB, com_port1', '', 'device power supply description');
  
  ## device, id = 14
  id = 14;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Actuator-I';
  item(id).a02.v = 'Olympus IMS, now EVIDENT Europe GmbH (Hamburg, Germany)';
  item(id).a03.v = 'V101-RB videoscan transducer';
  item(id).a04.v = 'actuator, sensor';
  item(id).a05.v = 'ultrasonic pulse transmission test, compression wave measurement, actuator';
  item(id).a06.v = 'part of ultrasonic test device';
  item(id).s01(1) = struct_objdata('surface_shape', 'string', 'circle', '', 'sensor surface shape');
  item(id).s01(2) = struct_objdata('surface_diameter', 'double', 25.4, 'mm', 'sensor surface diameter');
  item(id).s01(3) = struct_objdata('resonance_frequency', 'double', 500000, 'Hz', 'sensor resonance frequency');
  item(id).s01(4) = struct_objdata('impedance', 'double', 50.0, 'Ohm', '', 'sensor impedance');
  item(id).s01(5) = struct_objdata('type', 'string', 'ferro-ceramic piezo-electric element', '', 'sensor material type');
  item(id).s01(6) = struct_objdata('strain_characteristic', 'string', 'longitudinal', '', 'sensor strain characteristic');
  item(id).s01(7) = struct_objdata('connector', 'string', 'BNC', '', 'sensor connector type');
  
  ## device, id = 15
  id = 15;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Sensor-I';
  item(id).a02.v = 'Olympus IMS, now EVIDENT Europe GmbH (Hamburg, Germany)';
  item(id).a03.v = 'V101-RB videoscan transducer';
  item(id).a04.v = 'actuator, sensor';
  item(id).a05.v = 'ultrasonic pulse transmission test, compression wave measurement, sensor';
  item(id).a06.v = 'part of ultrasonic test device';
  item(id).s01(1) = struct_objdata('surface_shape', 'string', 'circle', '', 'sensor surface shape');
  item(id).s01(2) = struct_objdata('surface_diameter', 'double', 25.4, 'mm', 'sensor surface diameter');
  item(id).s01(3) = struct_objdata('resonance_frequency', 'double', 500000, 'Hz', 'sensor resonance frequency');
  item(id).s01(4) = struct_objdata('impedance', 'double', 50.0, 'Ohm', '', 'sensor impedance');
  item(id).s01(5) = struct_objdata('type', 'string', 'ferro-ceramic piezo-electric element', '', 'sensor material type');
  item(id).s01(6) = struct_objdata('strain_characteristic', 'string', 'longitudinal', '', 'sensor strain characteristic');
  item(id).s01(7) = struct_objdata('connector', 'string', 'BNC', '', 'sensor connector type');
  
  ## device, id = 16
  id = 16;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Actuator-II';
  item(id).a02.v = 'Olympus IMS, now EVIDENT Europe GmbH (Hamburg, Germany)';
  item(id).a03.v = 'V150-RB videoscan transducer';
  item(id).a04.v = 'actuator, sensor';
  item(id).a05.v = 'ultrasonic pulse transmission test, shear wave measurement, actuator';
  item(id).a06.v = 'part of ultrasonic test device';
  item(id).s01(1) = struct_objdata('surface_shape', 'string', 'circle', '', 'sensor surface shape');
  item(id).s01(2) = struct_objdata('surface_diameter', 'double', 25.4, 'mm', 'sensor surface diameter');
  item(id).s01(3) = struct_objdata('resonance_frequency', 'double', 500000, 'Hz', 'sensor resonance frequency');
  item(id).s01(4) = struct_objdata('impedance', 'double', 50.0, 'Ohm', '', 'sensor impedance');
  item(id).s01(5) = struct_objdata('type', 'string', 'ferro-ceramic piezo-electric element', '', 'sensor material type');
  item(id).s01(6) = struct_objdata('strain_characteristic', 'string', 'transversal', '', 'sensor strain characteristic');
  item(id).s01(7) = struct_objdata('connector', 'string', 'BNC', '', 'sensor connector type');
  
  ## device, id = 17
  id = 17;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Sensor-II';
  item(id).a02.v = 'Olympus IMS, now EVIDENT Europe GmbH (Hamburg, Germany)';
  item(id).a03.v = 'V150-RB videoscan transducer';
  item(id).a04.v = 'actuator, sensor';
  item(id).a05.v = 'ultrasonic pulse transmission test, shear wave measurement, sensor';
  item(id).a06.v = 'part of ultrasonic test device';
  item(id).s01(1) = struct_objdata('surface_shape', 'string', 'circle', '', 'sensor surface shape');
  item(id).s01(2) = struct_objdata('surface_diameter', 'double', 25.4, 'mm', 'sensor surface diameter');
  item(id).s01(3) = struct_objdata('resonance_frequency', 'double', 500000, 'Hz', 'sensor resonance frequency');
  item(id).s01(4) = struct_objdata('impedance', 'double', 50.0, 'Ohm', 'sensor impedance');
  item(id).s01(5) = struct_objdata('type', 'string', 'ferro-ceramic piezo-electric element', '', 'sensor material type');
  item(id).s01(6) = struct_objdata('strain_characteristic', 'string', 'transversal', '', 'sensor strain characteristic');
  item(id).s01(7) = struct_objdata('connector', 'string', 'BNC', '', 'sensor connector type');
  
  ## device, id = 18
  id = 18;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Actuator-III';
  item(id).a02.v = 'PANAMETRICS, now EVIDENT Europe GmbH (Hamburg, Germany)';
  item(id).a03.v = 'V1548-RB videoscan transducer';
  item(id).a04.v = 'actuator, sensor';
  item(id).a05.v = 'ultrasonic pulse transmission test, shear wave measurement, actuator';
  item(id).a06.v = 'part of ultrasonic test device, loan from MPA Stuttgart (2020-2021)';
  item(id).s01(1) = struct_objdata('surface_shape', 'string', 'circle', '', 'sensor surface shape');
  item(id).s01(2) = struct_objdata('surface_diameter', 'double', 25.4, 'mm', 'sensor surface diameter');
  item(id).s01(3) = struct_objdata('resonance_frequency', 'double', 110000, 'Hz', 'sensor resonance frequency');
  item(id).s01(4) = struct_objdata('impedance', 'double', 50.0, 'Ohm', 'sensor impedance');
  item(id).s01(5) = struct_objdata('type', 'string', 'ferro-ceramic piezo-electric element', '', 'sensor material type');
  item(id).s01(6) = struct_objdata('strain_characteristic', 'string', 'transversal', '', 'sensor strain characteristic');
  item(id).s01(7) = struct_objdata('connector', 'string', 'BNC', '', 'sensor connector type');
  
  ## device, id = 19
  id = 19;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Sensor-III';
  item(id).a02.v = 'PANAMETRICS, now EVIDENT Europe GmbH (Hamburg, Germany)';
  item(id).a03.v = 'V1548-RB videoscan transducer';
  item(id).a04.v = 'actuator, sensor';
  item(id).a05.v = 'ultrasonic pulse transmission test, shear wave measurement, sensor';
  item(id).a06.v = 'part of ultrasonic test device, loan from MPA Stuttgart (2020-2021)';
  item(id).s01(1) = struct_objdata('surface_shape', 'string', 'circle', '', 'sensor surface shape');
  item(id).s01(2) = struct_objdata('surface_diameter', 'double', 25.4, 'mm', 'sensor surface diameter');
  item(id).s01(3) = struct_objdata('resonance_frequency', 'double', 110000, 'Hz', 'resonance frequency');
  item(id).s01(4) = struct_objdata('impedance', 'double', 50.0, 'Ohm', 'sensor impedance');
  item(id).s01(5) = struct_objdata('type', 'string', 'ferro-ceramic piezo-electric element', '', 'sensor material type');
  item(id).s01(6) = struct_objdata('strain_characteristic', 'string', 'transversal', '', 'sensor strain characteristic');
  item(id).s01(7) = struct_objdata('connector', 'string', 'BNC', '', 'sensor connector type');
  
  ## device, id = 20
  id = 20;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Mold-25';
  item(id).a02.v = 'TTI GmbH - TGU Smartmote (Stuttgart, Germany)';
  item(id).a03.v = 'paste/mortar mold';
  item(id).a04.v = 'mold, formwork';
  item(id).a05.v = 'ultrasonic pulse transmission test, compression/shear wave measurement';
  item(id).a06.v = 'part of ultrasonic test device';
  item(id).s01(1) = struct_objdata('specimen_dim_w_h_t', 'double_arr', [120, 90, 25], 'mm', 'approx. specimen dimensions, width, height, thickness');
  item(id).s01(2) = struct_objdata('frontplate_material', 'string', 'acrylic glass', '', 'front plate material type');
  item(id).s01(3) = struct_objdata('frontplate_shape', 'string', 'cuboid', '', 'front plate shape');
  item(id).s01(4) = struct_objdata('frontplate_dim_w_h_t', 'double_arr', [500, 140, 12], 'mm', 'front plate dimensions, width, height, thickness');
  item(id).s01(5) = struct_objdata('backplate_material', 'string', 'acrylic glass', '', 'back plate material type');
  item(id).s01(6) = struct_objdata('backplate_shape', 'string', 'cuboid', '', 'back plate shape');
  item(id).s01(7) = struct_objdata('backplate_dim_w_h_t', 'double_arr', [500, 140, 12], 'mm', 'back plate dimensions, width, height, thickness');
  item(id).s01(8) = struct_objdata('spacer_number', 'uint', 1, '', 'number of spacers');
  item(id).s01(9) = struct_objdata('spacer_material', 'string', 'rubber foam', '', 'spacer material type');
  item(id).s01(10) = struct_objdata('spacer_shape', 'string', 'U', '', 'spacer shape');
  item(id).s01(11) = struct_objdata('spacer_dimouter_w_h_t', 'double_arr', [170, 140, 25], 'mm', 'approx. outer spacer dimensions, width, height, thickness');
  item(id).s01(12) = struct_objdata('spacer_diminner_w_h_t', 'double_arr', [120, 115, 25], 'mm', 'approx. inner spacer dimensions, width, height, thickness');
  item(id).s01(13) = struct_objdata('topcover_number', 'uint', 1, '', 'number of top covers');
  item(id).s01(14) = struct_objdata('topcover_material', 'string', 'rubber foam', '', 'top cover material type');
  item(id).s01(15) = struct_objdata('topcover_shape', 'string', 'cuboid', '', 'top cover shape');
  item(id).s01(16) = struct_objdata('topcover_dim_w_h_t', 'double_arr', [120, 25, 25], 'mm', 'top cover dimensions, width, height, thickness');
  
  ## device, id = 21
  id = 21;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Mold-50';
  item(id).a02.v = 'TTI GmbH - TGU Smartmote (Stuttgart, Germany)';
  item(id).a03.v = 'paste/mortar mold';
  item(id).a04.v = 'mold, formwork';
  item(id).a05.v = 'ultrasonic pulse transmission test, compression/shear wave measurement';
  item(id).a06.v = 'part of ultrasonic test device';
  item(id).s01(1) = struct_objdata('specimen_dim_w_h_t', 'double_arr', [120, 90, 50], 'mm', 'approx. specimen dimensions, width, height, thickness');
  item(id).s01(2) = struct_objdata('frontplate_material', 'string', 'acrylic glass', '', 'front plate material type');
  item(id).s01(3) = struct_objdata('frontplate_shape', 'string', 'cuboid', '', 'front plate shape');
  item(id).s01(4) = struct_objdata('frontplate_dimensions_w_h_t', 'double_arr', [500, 140, 12], 'mm', 'front plate dimensions, width, height, thickness');
  item(id).s01(5) = struct_objdata('backplate_material', 'string', 'acrylic glass', '', 'back plate material type');
  item(id).s01(6) = struct_objdata('backplate_shape', 'string', 'cuboid', '', 'back plate shape');
  item(id).s01(7) = struct_objdata('backplate_dim_w_h_t', 'double_arr', [500, 140, 12], 'mm', 'back plate dimensions, width, height, thickness');
  item(id).s01(8) = struct_objdata('spacer_number', 'uint', 2, '', 'number of spacers');
  item(id).s01(9) = struct_objdata('spacer_material', 'string', 'rubber foam', '', 'spacer material type');
  item(id).s01(10) = struct_objdata('spacer_shape', 'string', 'U', '', 'spacer shape');
  item(id).s01(11) = struct_objdata('spacer_dimouter_w_h_t', 'double_arr', [170, 140, 25], 'mm', 'approx. outer spacer dimensions, width, height, thickness');
  item(id).s01(12) = struct_objdata('spacer_diminner_w_h_t', 'double_arr', [120, 115, 25], 'mm', 'approx. inner spacer dimensions, width, height, thickness');
  item(id).s01(13) = struct_objdata('topcover_number', 'uint', 2, '', 'number of top covers');
  item(id).s01(14) = struct_objdata('topcover_material', 'string', 'rubber foam', '', 'top cover material type');
  item(id).s01(15) = struct_objdata('topcover_shape', 'string', 'cuboid', '', 'top cover shape');
  item(id).s01(16) = struct_objdata('topcover_dim_w_h_t', 'double_arr', [120, 25, 25], 'mm', 'top cover dimensions, width, height, thickness');
  
  ## device, id = 22
  id = 22;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Mold-70a';
  item(id).a02.v = 'TTI GmbH - TGU Smartmote (Stuttgart, Germany), TU-Graz (Graz, Austria)';
  item(id).a03.v = 'paste/mortar mold';
  item(id).a04.v = 'mold, formwork';
  item(id).a05.v = 'ultrasonic pulse transmission test, compression/shear wave measurement';
  item(id).a06.v = 'part of ultrasonic test device, modified configuration by TU-Graz';
  item(id).s01(1) = struct_objdata('specimen_dim_w_h_t', 'double_arr', [120, 100, 70], 'mm', 'approx. specimen dimensions, width, height, thickness');
  item(id).s01(2) = struct_objdata('frontplate_material', 'string', 'acrylic glass', '', 'front plate material type');
  item(id).s01(3) = struct_objdata('frontplate_shape', 'string', 'cuboid', '', 'front plate shape');
  item(id).s01(4) = struct_objdata('frontplate_dim_w_h_t', 'double_arr', [500, 140, 12], 'mm', 'front plate dimensions, width, height, thickness');
  item(id).s01(5) = struct_objdata('backplate_material', 'string', 'acrylic glass', '', 'back plate material type');
  item(id).s01(6) = struct_objdata('backplate_shape', 'string', 'cuboid', '', 'back plate shape');
  item(id).s01(7) = struct_objdata('backplate_dim_w_h_t', 'double_arr', [500, 140, 12], 'mm', 'back plate dimensions, width, height, thickness');
  item(id).s01(8) = struct_objdata('spacer_number', 'uint', 1, '', 'number of spacers');
  item(id).s01(9) = struct_objdata('spacer_material', 'string', 'XPS board', '', 'spacer material type');
  item(id).s01(10) = struct_objdata('spacer_shape', 'string', 'U', '', 'spacer shape');
  item(id).s01(11) = struct_objdata('spacer_dimouter_w_h_t', 'double_arr', [160, 140, 70], 'mm', 'approx. outer spacer dimensions, width, height, thickness');
  item(id).s01(12) = struct_objdata('spacer_diminner_w_h_t', 'double_arr', [120, 120, 70], 'mm', 'approx. inner spacer dimensions, width, height, thickness');
  item(id).s01(13) = struct_objdata('topcover_number', 'uint', 1, '', 'number of top covers');
  item(id).s01(14) = struct_objdata('topcover_material', 'string', 'polyethylene foil', '', 'top cover material type');
  item(id).s01(15) = struct_objdata('topcover_shape', 'string', 'rectangle', '', 'top cover shape');
  item(id).s01(16) = struct_objdata('topcover_dim_w_h_t', 'double_arr', [120, 70, 0.05], 'mm', 'top cover dimensions, width, height, thickness');
  
  ## device, id = 23
  id = 23;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Mold-70b';
  item(id).a02.v = 'TTI GmbH - TGU Smartmote (Stuttgart, Germany), TU-Graz (Graz, Austria)';
  item(id).a03.v = 'paste/mortar mold';
  item(id).a04.v = 'mold, formwork';
  item(id).a05.v = 'ultrasonic pulse transmission test, compression/shear wave measurement';
  item(id).a06.v = 'part of ultrasonic test device, modified configuration by TU-Graz';
  item(id).s01(1) = struct_objdata('specimen_dim_w_h_t', 'double_arr', [120, 90, 70], 'mm', 'approx. specimen dimensions, width, height, thickness');
  item(id).s01(2) = struct_objdata('frontplate_material', 'string', 'acrylic glass', '', 'front plate material type');
  item(id).s01(3) = struct_objdata('frontplate_shape', 'string', 'cuboid', '', 'front plate shape');
  item(id).s01(4) = struct_objdata('frontplate_dim_w_h_t', 'double_arr', [500, 140, 12], 'mm', 'front plate dimensions, width, height, thickness');
  item(id).s01(5) = struct_objdata('backplate_material', 'string', 'acrylic glass', '', 'back plate material type');
  item(id).s01(6) = struct_objdata('backplate_shape', 'string', 'cuboid', '', 'back plate shape');
  item(id).s01(7) = struct_objdata('backplate_dim_w_h_t', 'double_arr', [500, 140, 12], 'mm', 'back plate dimensions, width, height, thickness');
  item(id).s01(8) = struct_objdata('spacer1_number', 'uint', 2, '', 'type 1, number of spacers');
  item(id).s01(9) = struct_objdata('spacer1_material', 'string', 'rubber foam', '', 'type 1, spacer material type');
  item(id).s01(10) = struct_objdata('spacer1_shape', 'string', 'U', '', 'type 1, spacer shape');
  item(id).s01(11) = struct_objdata('spacer1_dimouter_w_h_t', 'double_arr', [170, 140, 25], 'mm', 'type 1, approx. outer spacer dimensions, width, height, thickness');
  item(id).s01(12) = struct_objdata('spacer1_diminner_w_h_t', 'double_arr', [120, 115, 25], 'mm', 'type 1, approx. inner spacer dimensions, width, height, thickness');
  item(id).s01(13) = struct_objdata('spacer2_number', 'uint', 1, '', 'type 2, number of spacers');
  item(id).s01(14) = struct_objdata('spacer2_material', 'string', 'XPS board', '', 'type 2, spacer material type');
  item(id).s01(15) = struct_objdata('spacer2_shape', 'string', 'U', '', 'type 2, spacer shape');
  item(id).s01(16) = struct_objdata('spacer2_dimouter_w_h_t', 'double_arr', [170, 140, 20], 'mm', 'type 2, approx. outer spacer dimensions, width, height, thickness');
  item(id).s01(17) = struct_objdata('spacer2_diminner_w_h_t', 'double_arr', [120, 115, 20], 'mm', 'type 2, approx. inner spacer dimensions, width, height, thickness');
  item(id).s01(18) = struct_objdata('topcover1_number', 'uint', 2, '', 'type 1, number of top covers');
  item(id).s01(19) = struct_objdata('topcover1_material', 'string', 'rubber foam', '', 'type 1, top cover material type');
  item(id).s01(20) = struct_objdata('topcover1_shape', 'string', 'cuboid', '', 'type 1, top cover shape');
  item(id).s01(21) = struct_objdata('topcover1_dim_w_h_t', 'double_arr', [120, 25, 25], 'mm', 'type 1, top cover dimensions, width, height, thickness');
  item(id).s01(22) = struct_objdata('topcover2_number', 'uint', 1, '', 'type 2, number of top covers');
  item(id).s01(23) = struct_objdata('topcover2_material', 'string', 'XPS board', '', 'type 2, top cover material type');
  item(id).s01(24) = struct_objdata('topcover2_shape', 'string', 'cuboid', '', 'type 2, top cover shape');
  item(id).s01(25) = struct_objdata('topcover2_dim_w_h_t', 'double_arr', [120, 25, 20], 'mm', 'type 2, top cover dimensions, width, height, thickness');
  
  ## device, id = 24
  id = 24;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'BP12000S';
  item(id).a02.v = 'Sartorius Lab Instruments GmbH & Co. KG (Göttingen, Germany)';
  item(id).a03.v = 'BP12000S';
  item(id).a04.v = 'scale, balance';
  item(id).a05.v = 'solid specimen density, immersion weighing';
  item(id).a06.v = 'type: high-capacity loading model';
  item(id).s01(1) = struct_objdata('load_max', 'double', 12000.0, 'g', 'max load, max weight of specimen');
  item(id).s01(2) = struct_objdata('resolution', 'double', 0.1, 'g', 'weight resolution');
  
  ## device, id = 25
  id = 25;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'LC2200';
  item(id).a02.v = 'Sartorius Lab Instruments GmbH & Co. KG (Göttingen, Germany)';
  item(id).a03.v = 'LC2200P';
  item(id).a04.v = 'scale, balance';
  item(id).a05.v = 'solid specimen density, immersion weighing';
  item(id).a06.v = 'type: MC1';
  item(id).s01(1) = struct_objdata('load_max', 'double', 2200.0, 'g', 'max load, max weight of specimen');
  item(id).s01(2) = struct_objdata('resolution', 'double', 0.05, 'g', 'weight resolution');
  
  ## device, id = 26
  id = 26;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'MS1600';
  item(id).a02.v = 'Mettler-Toledo GmbH (Vienna, Austria)';
  item(id).a03.v = 'MS16001L';
  item(id).a04.v = 'scale, balance';
  item(id).a05.v = 'mixture components, fresh paste density';
  item(id).a06.v = 'type: NewClassic MF';
  item(id).s01(1) = struct_objdata('load_max', 'double', 16200.0, 'g', 'max load, max weight of specimen');
  item(id).s01(2) = struct_objdata('resolution', 'double', 0.1, 'g', 'weight resolution');
  
  ## device, id = 27
  id = 27;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Caliper';
  item(id).a02.v = 'Mahr GmbH Helios-Preisser Vertrieb (Gammertingen, Germany)';
  item(id).a03.v = 'DIGI-MET 1320 517';
  item(id).a04.v = 'sliding caliper';
  item(id).a05.v = 'ultrasonic measurement distance, specimen thickness';
  item(id).a06.v = 'type: 150mm/0.01mm';
  item(id).s01(1) = struct_objdata('distance_max', 'double', 150.0, 'mm', 'max distance');
  item(id).s01(2) = struct_objdata('resolution', 'double', 0.01, 'mm', 'distance resolution');
  
  ## device, id = 28
  id = 28;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Mixer';
  item(id).a02.v = 'HOBART GmbH (Offenburg, Germany)';
  item(id).a03.v = 'N50-619';
  item(id).a04.v = 'mixer';
  item(id).a05.v = 'blending of mixture components';
  item(id).a06.v = '';
  item(id).s01(1) = struct_objdata('agitator_speed_levels', 'uint_arr', [136, 281, 580], 'RPM', 'rotational speed levels of agitator');
  item(id).s01(2) = struct_objdata('attachment_speed_levels', 'uint_arr', [60, 124, 255], 'RPM', 'rotational speed levels of attachment');
  item(id).s01(3) = struct_objdata('beater', 'string', 'flat, aluminium (BBEATER-ALU005)', '', 'beater material description');
  
  ## device, id = 29
  id = 29;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Beaker-1000';
  item(id).a02.v = 'n.n.';
  item(id).a03.v = 'graduated beaker, 1000 cm^3';
  item(id).a04.v = 'beaker';
  item(id).a05.v = 'fresh paste density';
  item(id).a06.v = '';
  item(id).s01(1) = struct_objdata('volume', 'double', 1000.0, 'cm^3', 'beaker volume');
  item(id).s01(2) = struct_objdata('mass', 'double', 466.2, 'g', 'beaker mass, net weight');
  item(id).s01(3) = struct_objdata('material', 'string', 'brass', '', 'beaker material');
  item(id).s01(4) = struct_objdata('shape', 'string', 'cylindrical', '', 'beaker shape');
  
  ## device, id = 30
  id = 30;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Washer-M12';
  item(id).a02.v = 'n.n.';
  item(id).a03.v = 'washer M12, DIN 125/DIN EN ISO 7089';
  item(id).a04.v = 'washer';
  item(id).a05.v = 'ultrasonic measurement distance, specimen thickness';
  item(id).a06.v = 'used as spacer for distance measurement, applied to sensor hutches on both sides of specimen';
  item(id).s01(1) = struct_objdata('diameter_inner', 'double', 13.0, 'mm', 'inner diameter, hole diameter');
  item(id).s01(2) = struct_objdata('diameter_outer', 'double', 25.0, 'mm', 'outer diameter, disk diameter');
  item(id).s01(3) = struct_objdata('thickness', 'double', 2.385, 'mm', 'washer thickness');
  item(id).s01(4) = struct_objdata('material', 'string', 'steel', '', 'washer material');
  item(id).s01(5) = struct_objdata('shape', 'string', 'disk with circular hole', '', 'washer shape');
  
  ## device, id = 31
  id = 31;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Thermocouple-K';
  item(id).a02.v = 'RS Components Handelsgesm.b.H. (Gmünd, Austria)';
  item(id).a03.v = 'Thermo Couple Type K';
  item(id).a04.v = 'cable';
  item(id).a05.v = 'connecting temperature DAQ, specimen or air';
  item(id).a06.v = '';
  item(id).s01(1) = struct_objdata('couple_type', 'string', 'K', '', 'couple type');
  item(id).s01(2) = struct_objdata('cable_type', 'string', 'straight-pair', '', 'cable type');
  item(id).s01(3) = struct_objdata('number_of_wires', 'uint', 2, '', 'number of wires');
  item(id).s01(4) = struct_objdata('shielded', 'boolean', false, '', 'is shielded (true/false)');
  item(id).s01(5) = struct_objdata('connector_1', 'string', 'None', '', 'first connector type');
  item(id).s01(6) = struct_objdata('connector_2', 'string', 'None', '', 'second connector type');
  item(id).s01(7) = struct_objdata('length_min_max', 'double_arr', [0.4, 1.2], 'm', 'min/max cable length');
  
  ## device, id = 32
  id = 32;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Testo-454';
  item(id).a02.v = 'Testo GmbH (Vienna, Austria)';
  item(id).a03.v = 'Testo-454';
  item(id).a04.v = 'DAQ';
  item(id).a05.v = 'ultrasonic transmission test, specimen temperature measurement';
  item(id).a06.v = '';
  item(id).s01(1) = struct_objdata('resolution_max', 'uint', 24, 'bit', 'max voltage resolution, vertical resolution');
  item(id).s01(2) = struct_objdata('samplerate_max', 'uint', 10, 'Hz', 'max sampling rate, horizontal resolution');
  item(id).s01(3) = struct_objdata('number_signal_ports', 'uint', 4, '', 'number of available signal ports');
  item(id).s01(4) = struct_objdata('number_com_ports', 'uint', 1, '', 'number of available communication ports');
  item(id).s01(5) = struct_objdata('connector_signal_port1', 'string', 'plug with screw terminal', '', 'signal port 1, connector type');
  item(id).s01(6) = struct_objdata('connector_signal_port2', 'string', 'plug with screw terminal', '', 'signal port 2, connector type');
  item(id).s01(7) = struct_objdata('connector_signal_port3', 'string', 'plug with screw terminal', '', 'signal port 3, connector type');
  item(id).s01(8) = struct_objdata('connector_signal_port4', 'string', 'plug with screw terminal', '', 'signal port 4, connector type');
  item(id).s01(9) = struct_objdata('connector_com_port1', 'string', '', '', 'communication port 1, connector type');
  item(id).s01(10) = struct_objdata('power_supply', 'string', 'battery', '', 'device power supply description');
  
  ## device, id = 33
  id = 33;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Testo-177H1';
  item(id).a02.v = 'Testo GmbH (Vienna, Austria)';
  item(id).a03.v = 'Testo 177H1, temperature/humidity logger';
  item(id).a04.v = 'DAQ';
  item(id).a05.v = 'environment temperature measurement, air temperature';
  item(id).a06.v = '';
  item(id).s01(1) = struct_objdata('temp_range', 'double_arr', [-20.0, 70.0], '°C', 'applicable temperature range');
  item(id).s01(2) = struct_objdata('temp_resolution', 'double', 0.1, '°C', 'temperature resolution');
  item(id).s01(3) = struct_objdata('temp_accuracy', 'double_arr', [-0.5, 0.5], '°C', 'temperature accuracy, measurement tolerance');
  item(id).s01(4) = struct_objdata('power_supply', 'string', 'battery', '', 'device power supply description');
  
  ## device, id = 34
  id = 34;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Trowel';
  item(id).a02.v = 'n.n.';
  item(id).a03.v = 'straight edges';
  item(id).a04.v = 'trowel';
  item(id).a05.v = 'fresh paste density test';
  item(id).a06.v = '';
  item(id).s01(1) = struct_objdata('material', 'string', 'steel', '', 'material type');
  item(id).s01(2) = struct_objdata('edge_type', 'string', 'straight', '', 'edge type');
  
  ## device, id = 35
  id = 35;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Mold-25-nospacer';
  item(id).a02.v = 'TTI GmbH - TGU Smartmote (Stuttgart, Germany)';
  item(id).a03.v = 'paste/mortar mold';
  item(id).a04.v = 'mold, formwork';
  item(id).a05.v = 'ultrasonic pulse transmission test, compression/shear wave measurement';
  item(id).a06.v = 'part of ultrasonic test device, modified configuration by TU-Graz';
  item(id).s01(1) = struct_objdata('specimen_thickness', 'double', 25, 'mm', 'approx. specimen thickness');
  item(id).s01(2) = struct_objdata('frontplate_material', 'string', 'acrylic glass', '', 'front plate material type');
  item(id).s01(3) = struct_objdata('frontplate_shape', 'string', 'cuboid', '', 'front plate shape');
  item(id).s01(4) = struct_objdata('frontplate_dimensions_w_h_t', 'double_arr', [500, 140, 12], 'mm', 'front plate dimensions, width, height, thickness');
  item(id).s01(5) = struct_objdata('backplate_material', 'string', 'acrylic glass', '', 'back plate material type');
  item(id).s01(6) = struct_objdata('backplate_shape', 'string', 'cuboid', '', 'back plate shape');
  item(id).s01(7) = struct_objdata('backplate_dimensions_w_h_t', 'double_arr', [500, 140, 12], 'mm', 'back plate dimensions, width, height, thickness');
  
  ## device, id = 36
  id = 36;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Mold-50-nospacer';
  item(id).a02.v = 'TTI GmbH - TGU Smartmote (Stuttgart, Germany)';
  item(id).a03.v = 'paste/mortar mold';
  item(id).a04.v = 'mold, formwork';
  item(id).a05.v = 'ultrasonic pulse transmission test, compression/shear wave measurement';
  item(id).a06.v = 'part of ultrasonic test device, modified configuration by TU-Graz';
  item(id).s01(1) = struct_objdata('specimen_thickness', 'double', 50, 'mm', 'approx. specimen thickness');
  item(id).s01(2) = struct_objdata('frontplate_material', 'string', 'acrylic glass', '', 'front plate material type');
  item(id).s01(3) = struct_objdata('frontplate_shape', 'string', 'cuboid', '', 'front plate shape');
  item(id).s01(4) = struct_objdata('frontplate_dimensions_w_h_t', 'double_arr', [500, 140, 12], 'mm', 'front plate dimensions, width, height, thickness');
  item(id).s01(5) = struct_objdata('backplate_material', 'string', 'acrylic glass', '', 'back plate material type');
  item(id).s01(6) = struct_objdata('backplate_shape', 'string', 'cuboid', '', 'back plate shape');
  item(id).s01(7) = struct_objdata('backplate_dimensions_w_h_t', 'double_arr', [500, 140, 12], 'mm', 'back plate dimensions, width, height, thickness');
  
  ## device, id = 37
  id = 37;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Mold-70-nospacer';
  item(id).a02.v = 'TTI GmbH - TGU Smartmote (Stuttgart, Germany)';
  item(id).a03.v = 'paste/mortar mold';
  item(id).a04.v = 'mold, formwork';
  item(id).a05.v = 'ultrasonic pulse transmission test, compression/shear wave measurement';
  item(id).a06.v = 'part of ultrasonic test device, modified configuration by TU-Graz';
  item(id).s01(1) = struct_objdata('specimen_thickness', 'double', 70, 'mm', 'approx. specimen thickness');
  item(id).s01(2) = struct_objdata('frontplate_material', 'string', 'acrylic glass', '', 'front plate material type');
  item(id).s01(3) = struct_objdata('frontplate_shape', 'string', 'cuboid', '', 'front plate shape');
  item(id).s01(4) = struct_objdata('frontplate_dimensions_w_h_t', 'double_arr', [500, 140, 12], 'mm', 'front plate dimensions, width, height, thickness');
  item(id).s01(5) = struct_objdata('backplate_material', 'string', 'acrylic glass', '', 'back plate material type');
  item(id).s01(6) = struct_objdata('backplate_shape', 'string', 'cuboid', '', 'back plate shape');
  item(id).s01(7) = struct_objdata('backplate_dimensions_w_h_t', 'double_arr', [500, 140, 12], 'mm', 'back plate dimensions, width, height, thickness');
  
  ## device, id = 38
  id = 38;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Mold-90-nospacer';
  item(id).a02.v = 'TTI GmbH - TGU Smartmote (Stuttgart, Germany)';
  item(id).a03.v = 'paste/mortar mold';
  item(id).a04.v = 'mold, formwork';
  item(id).a05.v = 'ultrasonic pulse transmission test, compression/shear wave measurement';
  item(id).a06.v = 'part of ultrasonic test device, modified configuration by TU-Graz';
  item(id).s01(1) = struct_objdata('specimen_thickness', 'double', 90, 'mm', 'approx. specimen thickness');
  item(id).s01(2) = struct_objdata('frontplate_material', 'string', 'acrylic glass', '', 'front plate material type');
  item(id).s01(3) = struct_objdata('frontplate_shape', 'string', 'cuboid', '', 'front plate shape');
  item(id).s01(4) = struct_objdata('frontplate_dimensions_w_h_t', 'double_arr', [500, 140, 12], 'mm', 'front plate dimensions, width, height, thickness');
  item(id).s01(5) = struct_objdata('backplate_material', 'string', 'acrylic glass', '', 'back plate material type');
  item(id).s01(6) = struct_objdata('backplate_shape', 'string', 'cuboid', '', 'back plate shape');
  item(id).s01(7) = struct_objdata('backplate_dimensions_w_h_t', 'double_arr', [500, 140, 12], 'mm', 'back plate dimensions, width, height, thickness');
  
  ## device, id = 39
  id = 39;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Mold-00-nospacer';
  item(id).a02.v = 'TTI GmbH - TGU Smartmote (Stuttgart, Germany)';
  item(id).a03.v = 'paste/mortar mold';
  item(id).a04.v = 'mold, formwork';
  item(id).a05.v = 'ultrasonic pulse transmission test, compression/shear wave measurement, face-to-face test';
  item(id).a06.v = 'part of ultrasonic test device, modified configuration by TU-Graz';
  item(id).s01(1) = struct_objdata('specimen_thickness', 'double', 0, 'mm', 'approx. specimen thickness');
  item(id).s01(2) = struct_objdata('frontplate_material', 'string', 'acrylic glass', '', 'front plate material type');
  item(id).s01(3) = struct_objdata('frontplate_shape', 'string', 'cuboid', '', 'front plate shape');
  item(id).s01(4) = struct_objdata('frontplate_dimensions_w_h_t', 'double_arr', [500, 140, 12], 'mm', 'front plate dimensions, width, height, thickness');
  item(id).s01(5) = struct_objdata('backplate_material', 'string', 'acrylic glass', '', 'back plate material type');
  item(id).s01(6) = struct_objdata('backplate_shape', 'string', 'cuboid', '', 'back plate shape');
  item(id).s01(7) = struct_objdata('backplate_dimensions_w_h_t', 'double_arr', [500, 140, 12], 'mm', 'back plate dimensions, width, height, thickness');
  
  ## device, id = 40
  id = 40;
  item(id) = item_empty;
  item(id).d01.v = id;
  item(id).a01.v = 'Mold-20-nospacer';
  item(id).a02.v = 'TTI GmbH - TGU Smartmote (Stuttgart, Germany)';
  item(id).a03.v = 'paste/mortar mold';
  item(id).a04.v = 'mold, formwork';
  item(id).a05.v = 'ultrasonic pulse transmission test, compression/shear wave measurement';
  item(id).a06.v = 'part of ultrasonic test device, modified configuration by TU-Graz';
  item(id).s01(1) = struct_objdata('specimen_thickness', 'double', 20, 'mm', 'approx. specimen thickness');
  item(id).s01(2) = struct_objdata('frontplate_material', 'string', 'acrylic glass', '', 'front plate material type');
  item(id).s01(3) = struct_objdata('frontplate_shape', 'string', 'cuboid', '', 'front plate shape');
  item(id).s01(4) = struct_objdata('frontplate_dimensions_w_h_t', 'double_arr', [500, 140, 12], 'mm', 'front plate dimensions, width, height, thickness');
  item(id).s01(5) = struct_objdata('backplate_material', 'string', 'acrylic glass', '', 'back plate material type');
  item(id).s01(6) = struct_objdata('backplate_shape', 'string', 'cuboid', '', 'back plate shape');
  item(id).s01(7) = struct_objdata('backplate_dimensions_w_h_t', 'double_arr', [500, 140, 12], 'mm', 'back plate dimensions, width, height, thickness');
  
  ## save structure
  save('-binary', p_ofp, 'item', 'item_empty', 'devgroup');
  
endfunction
