## Initialize dataset compiler, version 1.1
##
## Usage: init()
##
## The initialization is performing the following tasks:
##  - set graphics toolkit
##  - add subdirectories to the execution path
##  - initialize/create databse files
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

## Select graphics toolkit
##graphics_toolkit("gnuplot");
##graphics_toolkit("fltk");
graphics_toolkit("qt");

## Load additional packages
##pkg load signal;
##pkg load statistics;
##pkg load ltfat;

## Add subdirectory paths
subdirs = {...
  "fileio", ...
  "patches", ...
  "struct_hdf", ...
  "struct_hdf/atomic", ...
  "struct_hdf/db", ...
  "struct_hdf/export", ...
  "struct_hdf/import", ...
  "struct_hdf/update", ...
  "struct_hdf/plot"};
for i = 1 : size(subdirs, 2)
  addpath(subdirs{i});
endfor

## Clear global variables
clearvars -global 'dsc_*';

## Initialize global variables
global dsc_dbpath_static = './struct_hdf/db/db_static.oct';
if (exist(dsc_dbpath_static, 'file') != 3)
  struct_make_static(dsc_dbpath_static);
endif
global dsc_db_static = load(dsc_dbpath_static);

global dsc_dbpath_mat = './struct_hdf/db/db_mat.oct';
if (exist(dsc_dbpath_mat, 'file') != 3)
  struct_make_matdb(dsc_dbpath_mat);
endif
global dsc_db_mat = load(dsc_dbpath_mat);

global dsc_dbpath_aut = './struct_hdf/db/db_aut.oct';
if (exist(dsc_dbpath_aut, 'file') != 3)
  struct_make_autdb(dsc_dbpath_aut);
endif
global dsc_db_aut = load(dsc_dbpath_aut);

global dsc_dbpath_dev = './struct_hdf/db/db_dev.oct';
if (exist(dsc_dbpath_dev, 'file') != 3)
  struct_make_devdb(dsc_dbpath_dev);
endif
global dsc_db_dev = load(dsc_dbpath_dev);

global dsc_dbpath_rec = './struct_hdf/db/db_rec.oct';
if (exist(dsc_dbpath_rec, 'file') != 3)
  struct_make_recdb(dsc_dbpath_rec);
endif
global dsc_db_rec = load(dsc_dbpath_rec);

global dsc_dbpath_lic = './struct_hdf/db/db_lic.oct';
if (exist(dsc_dbpath_lic, 'file') != 3)
  struct_make_licdb(dsc_dbpath_lic);
endif
global dsc_db_lic = load(dsc_dbpath_lic);

global dsc_dbpath_loc = './struct_hdf/db/db_loc.oct';
if (exist(dsc_dbpath_loc, 'file') != 3)
  struct_make_locdb(dsc_dbpath_loc);
endif
global dsc_db_loc = load(dsc_dbpath_loc);

global dsc_dbpath_metaser = './struct_hdf/db/db_metaser.oct';
if (exist(dsc_dbpath_metaser, 'file') != 3)
  struct_make_metaserdb(dsc_dbpath_metaser);
endif
global dsc_db_metaser = load(dsc_dbpath_metaser);

global dsc_dbpath_metaset = './struct_hdf/db/db_metaset.oct';
if (exist(dsc_dbpath_metaset, 'file') != 3)
  struct_make_metasetdb(dsc_dbpath_metaset);
endif
global dsc_db_metaset = load(dsc_dbpath_metaset);

## Cleaning up
clearvars "i"
clearvars "subdirs"
