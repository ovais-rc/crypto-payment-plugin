/* Copyright IBM Corp. 2010-2014  All Rights Reserved.                    */

if (CKEDITOR.lang) {
	// Specify only the languages which IBM supports
	CKEDITOR.lang.languages = 
		{
		'ar':1,
		'bg':1,
		'ca':1, 
		'cs':1, 
		'da':1, 
		'de':1, 
		'el':1, 
		'en':1, 
		'es':1,
		'eu':1,
		'fi':1, 
		'fr':1, 
		'he':1, 
		'hr':1, 
		'hu':1,
		'id':1,
		'it':1, 
		'iw':1, 
		'ja':1, 
		'kk':1, 
		'ko':1, 
		'nb':1, 
		'nl':1, 
		'no':1, 
		'pl':1, 
		'pt':1, 
		'pt-br':1, 
		'ro':1, 
		'ru':1, 
		'sk':1, 
		'sl':1, 
		'sv':1, 
		'th':1, 
		'tr':1, 
		'uk':1, 
		'zh':1, 
		'zh-cn':1, 
		'zh-tw':1
	},
	CKEDITOR.lang.rtl =  { ar:1,he:1,iw:1 }
}

//Add all supported languages to plugins with their own lang files

CKEDITOR.on( 'specialcharPluginReady', function( ev )
{
	var pluginDefinition = ev.data;
	pluginDefinition.availableLangs = CKEDITOR.lang.languages;	
	
});

CKEDITOR.on( 'a11yhelpPluginReady', function( ev )
{
	var pluginDefinition = ev.data;
	pluginDefinition.availableLangs = CKEDITOR.lang.languages;	
	
});