/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/licensePortions Copyright IBM Corp., 2009-2015.
 */
var CKEDITOR_LANGS = (function()
{
	var langs =
	{
		ar		: 'Arabic',
		bg		: 'Bulgarian',
		ca		: 'Catalan',
		cs		: 'Czech',
		da		: 'Danish',
		de		: 'German',
		el		: 'Greek',
		en		: 'English',
		es		: 'Spanish',
		eu		: 'Basque',
		fi		: 'Finnish',
		fr		: 'French',
		he		: 'Hebrew (HE)',
		hr		: 'Croatian',
		hu		: 'Hungarian',
		id		: 'Indonesian',
		it		: 'Italian',
		iw		: 'Hebrew (IW)',
		ja		: 'Japanese',
		kk		: 'Kazakh',
		ko		: 'Korean',
		nb		: 'Norwegian Bokmal (NB)',
		no		: 'Norwegian (NO)',		
		nl		: 'Dutch',
		no		: 'Norwegian',
		pl		: 'Polish',
		pt		: 'Portuguese (Portugal)',
		'pt-br'	: 'Portuguese (Brazil)',
		ro		: 'Romanian',
		ru		: 'Russian',
		sk		: 'Slovak',
		sl		: 'Slovenian',
		sv		: 'Swedish',
		th		: 'Thai',
		tr		: 'Turkish',
		uk		: 'Ukrainian',
		zh		: 'Chinese Simplified (ZH)',
		'zh-tw'	: 'Chinese Traditional',
		'zh-cn'	: 'Chinese Simplified (ZH-CN)'
	};

	var langsArray = [];

	for ( var code in langs )
	{
		langsArray.push( { code : code, name : langs[ code ] } );
	}

	langsArray.sort( function( a, b )
		{
			return ( a.name < b.name ) ? -1 : 1;
		});

	return langsArray;
})();