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
## Add header lines to text file
##
## Usage: fio_header_add(p_fp, p_hi)
##
## p_fp ... file path, <str>
## p_hi ... header information, cell array of strings {<str>}
##
## see also: 
##
function fio_header_add(p_fp, p_hi)
  
  ## check arguments
  if (nargin < 1)
    help fio_header_add;
    error('Less arguments given!');
  endif
  if (nargin < 2)
    h1 = sprintf('Copyright %d Jakob Harden, Graz University of Technology (Graz, Austria)', datevec(now())(1));
    h2 = 'This file is part of the PhD thesis of Jakob Harden';
    p_hi = {h1; h2};
  endif
  
  ## get file stat info
##  fst = stat(p_fp);
##  p_si = {sprintf('dev: %d', fst.dev), ...
##    sprintf('ino: %d', fst.ino), ...
##    sprintf('mode: %d', fst.mode), ...
##    sprintf('modestr: %s', fst.modestr), ...
##    sprintf('nlink: %d', fst.nlink), ...
##    sprintf('uid: %d', fst.uid), ...
##    sprintf('gid: %d', fst.gid), ...
##    sprintf('rdev: %d', fst.rdev), ...
##    sprintf('size: %d', fst.size), ...
##    sprintf('atime: %d', fst.atime), ...
##    sprintf("atimestr: %s", strtrim(ctime(fst.atime))), ...
##    sprintf('mtime: %d', fst.mtime), ...
##    sprintf("mtimestr: %s", strtrim(ctime(fst.mtime))), ...
##    sprintf('ctime: %d', fst.ctime), ...
##    sprintf("ctimestr: %s", strtrim(ctime(fst.ctime))), ...
##    sprintf('blksize: %d', fst.blksize), ...
##    sprintf('blocks: %d', fst.blocks)};
    
  ## temporary header file
  fp_hdr = cstrcat(p_fp, ".hdr");
##  hlp_write_tmpheader(fp_hdr, p_hi, p_si);
  hlp_write_tmpheader(fp_hdr, p_hi);
  
  ## concatenate header and input file to temporary output file
  fp_out = cstrcat(p_fp, ".out");
  [err, msg] = system(sprintf("cat \"%s\" \"%s\" >> \"%s\"", fp_hdr, p_fp, fp_out));
  if (err > 0)
    error("Cannot concatenate header and input file!\n  header file = %s\n  input file = %s\n  output file = %s", ...
      fp_hdr, p_fp, fp_out);
  endif
  
  ## move temporary output file to input file
  [err, msg] = system(sprintf("mv -f \"%s\" \"%s\"", fp_out, p_fp));
  if (err > 0)
    error("Cannot move temporary output file to input file!\n  output file = %s\n  input file = %s", fp_out, p_fp);
  endif
  
  ## remove temporary header file
  [err, msg] = system(sprintf("rm \"%s\"", fp_hdr));
  if (err > 0)
    error("Cannot remove temporary header file!\n  header file = %s", fp_hdr);
  endif
  
endfunction

###############################################################################
## Helper function: write header to text file
## p_fp  ... header file path, string
## p_hi  ... header information, cell array of strings
## p_si  ... file stat information, cell array of strings
function hlp_write_tmpheader(p_fp, p_hi, p_si)
  
  ## open file for writing
  fid = fopen(p_fp, "w");
  
  ## check for errors
  if (fid < 0)
    error("Cannot open temporary header file for writing!\n  path = %s", p_fp);
  endif
  
  ## write license information
  if (nargin > 1)
    fprintf(fid, "%s\n", p_hi{:});
  endif
  
  ## write filestat information
  if (nargin > 2)
    fprintf(fid, "%s\n", p_si{:});
  endif
  
  ## close file
  fclose(fid);
  
endfunction
