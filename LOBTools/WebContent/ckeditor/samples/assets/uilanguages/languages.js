/*
 Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 For licensing, see LICENSE.md or http://ckeditor.com/license
*/
var CKEDITOR_LANGS=function(){var c={ar:"Arabic",eu:"Basque",bg:"Bulgarian",ca:"Catalan",cs:"Czech",da:"Danish",de:"German",el:"Greek",en:"English",es:"Spanish",fi:"Finnish",fr:"French",he:"Hebrew (HE)",hr:"Croatian",hu:"Hungarian",id:"Indonesian",it:"Italian",iw:"Hebrew (IW)",ja:"Japanese",kk:"Kazakh",ko:"Korean",nb:"Norwegian Bokmal (NB)",no:"Norwegian (NO)",nl:"Dutch",no:"Norwegian",pl:"Polish",pt:"Portuguese (Portugal)","pt-br":"Portuguese (Brazil)",ro:"Romanian",ru:"Russian",sk:"Slovak",sl:"Slovenian",
sv:"Swedish",th:"Thai",tr:"Turkish",uk:"Ukrainian",zh:"Chinese Simplified (ZH)","zh-tw":"Chinese Traditional","zh-cn":"Chinese Simplified (ZH-CN)"},b=[],a;for(a in CKEDITOR.lang.languages)b.push({code:a,name:c[a]||a});b.sort(function(a,b){return a.name<b.name?-1:1});return b}();