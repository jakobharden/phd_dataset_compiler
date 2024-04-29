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
## Extract metadata from project data structure in JSON format
##
## Usage 1: [r_sl] = struct_exp_metajson(p_ds, p_fp), extract metadata and write file
##
## Usage 2: [r_sl] = struct_exp_metajson(p_ds), extract metadata
##
## Usage 3: [r_sl] = struct_exp_metajson(), extract empty metadata structure and write file to "./repository/test.json)"
##
## p_ds ... project data structure, optional, <struct>
## p_fp ... output file path (JSON file), optional, <str>
## r_sl ... return: string list containing the metadata, JSON format, {<str>}
##
## see also: struct_import, fio_struct_save
##
function [r_sl] = struct_exp_metajson(p_ds, p_fp)
  
  ## check arguments
  if (nargin < 1)
    p_ds = [];
  endif
  
  ## extract metadata in JSON format
  r_sl = hlp_extract(p_ds);
  
  ## write metadata file
  if isempty(p_ds)
    hlp_write_metadata(r_sl, './repository/test.json');
  endif
  if (nargin == 2)
    hlp_write_metadata(r_sl, p_fp);
  endif
  
endfunction

################################################################################
## Helper function: extract metadata in JSON format
function hlp_write_metadata(p_sl, p_fp)
  
  fid = fopen(p_fp, 'w');
  for i = 1 : max(size(p_sl))
    fprintf(fid, '%s\n', p_sl{i});
  endfor
  fclose(fid);
  
endfunction

################################################################################
## Helper function: extract metadata in JSON format
function [r_sl] = hlp_extract(p_ds)
  
  ## get dataset author
  as = hlp_author_struct(p_ds, 'dataset');
  aut_gname = as.a02.v;
  aut_fname = as.a03.v;
  aut_affil = as.a07.v;
  aut_ident = as.a18.v;
  aut_identscheme = as.a16.v;
  ## get title
  title_main = sprintf('%s - %s: %s', p_ds.meta_ser.a03.v, p_ds.meta_ser.a02.v, p_ds.meta_set.a02.v);
  title_sub = 'Test series created in the course of the PhD thesis of Jakob Harden.';
  ## get dates
  date_published = datestr(now(), 29);
  date_created = p_ds.meta_set.a10.v;
  date_collected = p_ds.meta_set.a11.v;
  date_copyrighted = p_ds.meta_set.a12.v;
  ## get descriptions
  descr = p_ds.meta_set.a03.v;
  descr_abstr = hlp_descr_abstract(p_ds);
  descr_methods = hlp_flatten_cellarray(p_ds.meta_set.a05.v);
  descr_toc = hlp_flatten_cellarray(p_ds.meta_set.a06.v);
  descr_series = hlp_descr_ser(p_ds);
  ## get version
  version = p_ds.meta_set.a15.v;
  ## get geolocations
  location = hlp_location_struct(p_ds);
  geolocpoint = location.d02.v;
  ## get license information
  licds = hlp_license_struct(p_ds);
  lic_title = licds.a03.v;
  lic_legalcode_url = licds.a04.v;
  lic_scheme = licds.a05.v;
  lic_scheme_url = licds.a06.v;
  lic_descr = licds.a07.v;
  lic_icon = licds.a08.v;
  lic_id = licds.a09.v;
 
  r_sl = {};
  
  ## begin json
  r_sl = hlp_append(r_sl, '{');
  ## access
  r_sl = hlp_append(r_sl, '  "access": {');
  r_sl = hlp_append(r_sl, '    "embargo": {');
  r_sl = hlp_append(r_sl, '      "active": false,');
  r_sl = hlp_append(r_sl, '      "reason": null');
  r_sl = hlp_append(r_sl, '    },');
  r_sl = hlp_append(r_sl, '    "files": "restricted",');
  r_sl = hlp_append(r_sl, '    "record": "restricted",');
  r_sl = hlp_append(r_sl, '    "status": "restricted"');
  r_sl = hlp_append(r_sl, '  },');
  ## draft status
  r_sl = hlp_append(r_sl, '  "is_draft": true,');
  ## published status
  r_sl = hlp_append(r_sl, '  "is_published": false,');
  ## files
  r_sl = hlp_append(r_sl, '  "files": {');
  r_sl = hlp_append(r_sl, '    "enabled": true,');
  r_sl = hlp_append(r_sl, '    "order": []');
  r_sl = hlp_append(r_sl, '  },');
  ## begin metadata
  r_sl = hlp_append(r_sl, '  "metadata": {');
  ## metadata, description
  r_sl = hlp_append(r_sl, sprintf('    "description": "<p>%s</p>",', descr));
  ## metadata, begin additional descriptions
  r_sl = hlp_append(r_sl, '    "additional_descriptions": [');
  ## metadata, add. descr 1, abstract
  r_sl = hlp_append(r_sl, '      {');
  r_sl = hlp_append(r_sl, sprintf('        "description": "%s",', descr_abstr));
  r_sl = hlp_append(r_sl, '        "lang": {"id": "eng","title": {"en": "English"}},');
  r_sl = hlp_append(r_sl, '        "type": {"id": "abstract","title": {"en": "Abstract"}}');
  r_sl = hlp_append(r_sl, '      },');
  ## metadata, add. descr 2
  r_sl = hlp_append(r_sl, '      {');
  r_sl = hlp_append(r_sl, sprintf('        "description": "%s",', descr_toc));
  r_sl = hlp_append(r_sl, '        "lang": {"id": "eng","title": {"en": "English"}},');
  r_sl = hlp_append(r_sl, '        "type": {"id": "table-of-contents","title": {"en": "Table of contents"}}');
  r_sl = hlp_append(r_sl, '      },');
  ## metadata, add. descr 3
  r_sl = hlp_append(r_sl, '      {');
  r_sl = hlp_append(r_sl, sprintf('        "description": "%s",', descr_series));
  r_sl = hlp_append(r_sl, '        "lang": {"id": "eng","title": {"en": "English"}},');
  r_sl = hlp_append(r_sl, '        "type": {"id": "series-information","title": {"en": "Series information"}}');
  r_sl = hlp_append(r_sl, '      },');
  ## metadata, add. descr 4
  r_sl = hlp_append(r_sl, '      {');
  r_sl = hlp_append(r_sl, sprintf('        "description": "%s",', descr_methods));
  r_sl = hlp_append(r_sl, '        "lang": {"id": "eng","title": {"en": "English"}},');
  r_sl = hlp_append(r_sl, '        "type": {"id": "methods","title": {"en": "Methods"}}');
  r_sl = hlp_append(r_sl, '      }');
   ## metadata, end additional descriptions
  r_sl = hlp_append(r_sl, '    ],');
  ## metadata, title
  r_sl = hlp_append(r_sl, sprintf('    "title": "%s",', title_main));
  ## metadata, begin additional titles
  r_sl = hlp_append(r_sl, '    "additional_titles": [');
  ## metadata, add. title
  r_sl = hlp_append(r_sl, '      {');
  r_sl = hlp_append(r_sl, '        "lang": {"id": "eng", "title": {"en": "English"}},');
  r_sl = hlp_append(r_sl, sprintf('        "title": "%s",', title_sub));
  r_sl = hlp_append(r_sl, '        "type": {"id": "subtitle", "title": {"en": "Subtitle"}}');
  r_sl = hlp_append(r_sl, '      }');
  ## metadata, end additional titles
  r_sl = hlp_append(r_sl, '    ],');
  ## metadata, begin creators
  r_sl = hlp_append(r_sl, '    "creators": [');
  r_sl = hlp_append(r_sl, '      {');
  r_sl = hlp_append(r_sl, sprintf('        "affiliations": [{"name": "%s"}],', aut_affil));
  r_sl = hlp_append(r_sl, '        "person_or_org": {');
  r_sl = hlp_append(r_sl, sprintf('          "family_name": "%s",', aut_fname));
  r_sl = hlp_append(r_sl, sprintf('          "given_name": "%s",', aut_gname));
  r_sl = hlp_append(r_sl, sprintf('          "name": "%s, %s",', aut_fname, aut_gname));
  r_sl = hlp_append(r_sl, sprintf('          "identifiers": [{"identifier": "%s", "scheme": "%s"}],', aut_ident, aut_identscheme));
  r_sl = hlp_append(r_sl, sprintf('          "type": "%s"', 'personal'));
  r_sl = hlp_append(r_sl, '        },');
  r_sl = hlp_append(r_sl, '        "role": {"id": "producer", "title": {"en": "Producer"}}');
  r_sl = hlp_append(r_sl, '      }');
  ## metadata, end creators
  r_sl = hlp_append(r_sl, '    ],');
  ## metadata, begin dates
  r_sl = hlp_append(r_sl, '    "dates": [');
  ## metadata, date 1
  r_sl = hlp_append(r_sl, '      {');
  r_sl = hlp_append(r_sl, sprintf('        "date": "%s",', date_created));
  r_sl = hlp_append(r_sl, '        "description": "Date when tests were performed",');
  r_sl = hlp_append(r_sl, '        "type": {"id": "created", "title": {"en": "Created"}}');
  r_sl = hlp_append(r_sl, '      },');
  ## metadata, date 2
  r_sl = hlp_append(r_sl, '      {');
  r_sl = hlp_append(r_sl, sprintf('        "date": "%s",', date_copyrighted));
  r_sl = hlp_append(r_sl, '        "description": "Date when dataset was copyrighted",');
  r_sl = hlp_append(r_sl, '        "type": {"id": "copyrighted","title": {"en": "Copyrighted"}}');
  r_sl = hlp_append(r_sl, '      }');
  ## metadata, end dates
  r_sl = hlp_append(r_sl, '    ],');
  ## metadata, languages
  r_sl = hlp_append(r_sl, '    "languages": [{"id": "eng","title": {"en": "English"}}],');
  ## metadata, publication date
  r_sl = hlp_append(r_sl, sprintf('    "publication_date": "%s",', date_published));
  ## metadata, publisher
  r_sl = hlp_append(r_sl, '    "publisher": "Graz University of Technology",');
  ## metadata, resource type
  r_sl = hlp_append(r_sl, '    "resource_type": {"id": "dataset", "title": {"en": "Dataset"}},');
  ## metadata, rights
  r_sl = hlp_append(r_sl, '    "rights": [');
  r_sl = hlp_append(r_sl, '      {');
  r_sl = hlp_append(r_sl, '        "description": {');
  r_sl = hlp_append(r_sl, sprintf('          "en": "%s"', lic_descr));
  r_sl = hlp_append(r_sl, '         },');
  r_sl = hlp_append(r_sl, sprintf('         "icon": "%s",', lic_icon));
  r_sl = hlp_append(r_sl, sprintf('         "id": "%s",', lic_id));
  r_sl = hlp_append(r_sl, sprintf('         "props": {"scheme": "%s", "url": "%s"},', lic_scheme, lic_legalcode_url));
  r_sl = hlp_append(r_sl, sprintf('         "title": {"en": "%s"}', lic_title));
  r_sl = hlp_append(r_sl, '       }');
  r_sl = hlp_append(r_sl, '     ],');
  ## metadata, geolocation
  r_sl = hlp_append(r_sl, '    "geolocations": [');
  r_sl = hlp_append(r_sl, '      {');
  r_sl = hlp_append(r_sl, '        "geolocationpoint": {');
  r_sl = hlp_append(r_sl, sprintf('          "pointLongitude": "%.8f",', geolocpoint(2)));
  r_sl = hlp_append(r_sl, sprintf('          "pointLatitude": "%.8f"', geolocpoint(1)));
  r_sl = hlp_append(r_sl, '         }');
  r_sl = hlp_append(r_sl, '       }');
  r_sl = hlp_append(r_sl, '     ],');
  ## metadata, version
  r_sl = hlp_append(r_sl, sprintf('    "version": "%s"', version));
  ## end metadata
  r_sl = hlp_append(r_sl, '  }');
  ## end json
  r_sl = hlp_append(r_sl, '}');
  
endfunction

###############################################################################
## Helper function: append item to list
## p_sl ... string list, {<str>}
## p_li ... list item, <str>
## r_sl ... return: updated string list, {<str>}
function [r_sl] = hlp_append(p_sl, p_li)
  
  r_sl = [p_sl; p_li];
  
endfunction

###############################################################################
## Helper function: flatten string array, formatted as html paragraph
## p_ca ... cell array of strings
## p_as ... return: array string, formatted as html paragraph
function [r_as] = hlp_flatten_cellarray(p_ca)
  
  r_as = '<p>';
  for i = 1 : max(size(p_ca))
    if (i == 1)
      r_as = [r_as, p_ca{i}];
    else
      r_as = [r_as, '<br>', p_ca{i}];
    endif
  endfor
  r_as = [r_as, '</p>'];
  
endfunction

###############################################################################
## Helper function: get author structure
## p_ds ... dataset, <struct>
## p_tp ... author type, <str>
##            "series":  series author
##            "dataset": dataset author
## r_as ... return: author structure, <struct>
function [r_as] = hlp_author_struct(p_ds, p_tp)
  
  ## get author id from reference
  switch (p_tp)
    case 'series'
      ref_i = p_ds.meta_ser.r01.i;
    case 'dataset'
      ref_i = p_ds.meta_set.r01.i;
  endswitch
  ## find author in author structure array
  for i = 1 : max(size(p_ds.aut))
    if (p_ds.aut(i).d01.v == ref_i)
      r_as = p_ds.aut(i);
      break;
    endif
  endfor
  
endfunction

###############################################################################
## Helper function: get license structure
## p_ds ... dataset, <struct>
## r_ls ... return: license structure, <struct>
function [r_ls] = hlp_license_struct(p_ds)
  
  ## get license id from reference
  ref_i = p_ds.meta_ser.r02.i;
  ## find license in license structure array
  for i = 1 : max(size(p_ds.lic))
    if (p_ds.lic(i).d01.v == ref_i)
      r_ls = p_ds.lic(i);
      break;
    endif
  endfor
  
endfunction

###############################################################################
## Helper function: get location structure
## p_ds ... dataset, <struct>
## r_ls ... return: location structure, <struct>
function [r_ls] = hlp_location_struct(p_ds)
  
  ## get location id from reference
  ref_i = p_ds.meta_set.r03.i;
  ## find location in location structure array
  for i = 1 : max(size(p_ds.loc))
    if (p_ds.loc(i).d01.v == ref_i)
      r_ls = p_ds.loc(i);
      break;
    endif
  endfor
  
endfunction

###############################################################################
## Helper function: get test series description
## p_ds ... dataset, <struct>
## r_de ... return: string containing the test series description, <str>
function [r_de] = hlp_descr_ser(p_ds)
  
  as = hlp_author_struct(p_ds, 'series');
  lics = hlp_license_struct(p_ds);
  
  r_de = sprintf("<p>Test series information:\
<br>%s = %d\
<br>%s = %s\
<br>%s = %s\
<br>%s = %s\
<br>%s = %s\
<br>%s = %s\
<br>%s = %s\
<br>%s = %s, %s (%s (%s, %s))\
<br>%s = %s (%s)</p>", ...
      p_ds.meta_ser.d01.t, p_ds.meta_ser.d01.v, ...
      p_ds.meta_ser.a01.t, p_ds.meta_ser.a01.v, ...
      p_ds.meta_ser.a02.t, p_ds.meta_ser.a02.v, ...
      p_ds.meta_ser.a03.t, p_ds.meta_ser.a03.v, ...
      p_ds.meta_ser.a05.t, p_ds.meta_ser.a05.v, ...
      p_ds.meta_ser.a06.t, p_ds.meta_ser.a06.v, ...
      p_ds.meta_ser.a07.t, p_ds.meta_ser.a07.v, ...
      'author', as.a03.v, as.a02.v, as.a07.v, as.a12.v, as.a10.v, ...
      'license', lics.a01.v, lics.a03.v);
      
endfunction

###############################################################################
## Helper function: get test series description
## p_ds ... dataset, <struct>
## r_de ... return: string containing the test series description, <str>
function [r_de] = hlp_descr_abstract(p_ds)
  
  r_de = "<p>";
  r_de = [r_de, p_ds.meta_ser.a04.v];
  for i = 1 : max(size(p_ds.meta_set.a04.v))
    r_de = [r_de, "<br>", p_ds.meta_set.a04.v{i}];
  endfor
  r_de = [r_de, "</p>"];
      
endfunction
