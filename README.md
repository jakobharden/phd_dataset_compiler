# Dataset compiler, version 1.1

This script collection allows to compile raw data from ultrasonic pulse transmission tests (FreshCon device) to datasets using the open GNU Octave binary file format.

Table of contents:
- License
- Prerequisites
- Directories and files
- Installation instructions
- Usage instructions
- Help
- Related data sources
- Revision and release history


## License

All files published under the DOI 10.3217/6qg3m-af058 are licensed under the MIT license.

Copyright 2023 Jakob Harden (jakob.harden@tugraz.at, Graz University of Technology, Graz, Austria)
License: MIT
This file is part of the PhD thesis of Jakob Harden.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
documentation files (the “Software”), to deal in the Software without restriction, including without 
limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of 
the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


## Prerequisites

To be able to use the scripts, GNU Octave 6.2.0 (or a higher version) need to to be installed.
GNU Octave is available via the package management system on many Linux distributions. Windows users 
have to download the Windows version of GNU Octave and to install the software manually.

GNU Octave download: https://octave.org/download


## Directories and files

All scripts files (*.m) are plain text files written in the scientific programming language of GNU Octave 6.2.0.

Directory and file structure:
- [fileio] ... directory, collection of file input/output function files.
- [struct_hdf] ... directory, collection of function files used to compile the datasets from raw data (*.oct files).
- [struct_hdf/atomic] ... directory, function files related atomic structure elements (lowest level of the hierarchical data structure).
- [struct_hdf/db] ... directory, function files used to create the databases that hold the information about devices, materials, etc.
- [struct_hdf/export] ... directory, function files used to export data structure elements.
- [struct_hdf/import] ... directory, function files used to compile binary datasets from raw data.
- [struct_hdf/update] ... directory, function files used to update an already existing binary dataset (*.oct file).
- [struct_hdf/*.m] ... function files used to create the substructures of a binary dataset (*.oct file).
- init.m ... function file used to initialize the program.
- README.md ... this file


## Installation instructions

1) copy the main program directory to a location of your choice --> **workdir**.
2) open GNU Octave.
3) change the working directory to **workdir**.


## Usage instructions

1) uncompress ZIP archive containing the raw data --> **rawdir**
2) run GNU Octave
3) initialize program: octave: >>> init;
4) compile dataset: octave: >>> struct_import(T, S);
5) load compiled dataset into memory: octave: >>> ds = load(FP, "dataset").dataset;

Where **T** is the raw data source type, **S** the raw data source directory and **FP** the full qualified file path to the compiled data set. Possible options for **T** are documented in the function file **./struct_hdf/import/struct_import.m**. The resulting output file (*.oct) is always written to the parent directory of the source directory.

Example:
```
octave: >> init;
octave: >> struct_import("paste", "/path/to/source/mydataset");
octave: >> ds = load("/path/to/source/mydataset.oct", "dataset").dataset;
```
In the example shown above, the raw data of an ultrasonic pulse transmission test on a cement paste is compiled to a binary dataset in "/path/to/source/mydataset.oct".


## Help

All function files in this script collection contain a proper documentation and usage instructions. To access that help on the GNU Octave command line, type:
```
octave: >> init;
octave: >> help function_file_name;
```


## Related data sources

Datasets compiled with this scripts are made available at the repository of Graz University of Technology under an open license (Creative Commons, CC BY 4.0). The repository records enlisted below contain the raw data, the compiled datasets and a technical description of the record content.

Data sources:
- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 1, Cement Paste at Early Stages". Graz University of Technology. doi: 10.3217/bhs4g-m3z76
- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 3, Reference Tests on Air". Graz University of Technology. doi: 10.3217/ph0jm-8ax76
- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 4, Cement Paste at Early Stages". Graz University of Technology. doi: 10.3217/f62md-kep36
- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 5, Reference Tests on Air". Graz University of Technology. doi: 10.3217/bjkrj-pg829
- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 6, Reference Tests on Water". Graz University of Technology. doi: 10.3217/hn7we-q7z09
- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 7, Reference Tests on Aluminium Cylinder". Graz University of Technology. doi: 10.3217/azh6e-rvy75


## Revision and release history

### 2023-07-14, version 1

- published/released version 1 at the repository of Graz University of Technology; url: (https://repository.tugraz.at/)[https://repository.tugraz.at/]; doi: 10.3217/6t7km-5dg82


### 2023-08-06, version 1.1

- Moved the copyright notice to the bottom of the function file documentation in all file headers. The license stays the same (MIT). This was done to stay aligned to GNU Octave function file documentation definitions (copyright notice goes after the function synopsis). Additionally, the help command (octave: >> help "function_file_name") is now parsing and displaying the function file documentation correctly.
- No chages were made to the program logic.
- Added a revision and release history to the README.md file.
- Minor updates in the text of the README.md file.
- published/released version 1.1 at the repository of Graz University of Technology; url: (https://repository.tugraz.at/)[https://repository.tugraz.at/]; doi: 10.3217/6qg3m-af058

