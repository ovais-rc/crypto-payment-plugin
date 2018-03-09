/*
Copyright (c) 2003-2015, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.md or http://ckeditor.com/licensePortions Copyright IBM Corp., 2009-2015.
*/
CKEDITOR.plugins.setLang( 'embedbase', 'en', {
	pathName: 'media object',
	title: 'Insert Media',
	url: 'URL:',
	button: 'Insert Media Embed',
	unsupportedUrlGiven: 'The given URL is not supported.',
	unsupportedUrl: 'The URL {url} is not supported by Media Embed.',
	fetchingFailedGiven: 'Failed to fetch content for the given URL.',
	fetchingFailed: 'Failed to fetch content for {url}.',
	fetchingOne: 'Fetching oEmbed response...',
	fetchingMany: 'Fetching oEmbed responses, {current} of {max} done...',
		
	ibm :
	{
		alignment : "Alignment:",
		size : "Size:",
		specify : "Specify:",
		maxWidth : "Width:",
		maxHeight : "Height:",
		emptyURL: "Please enter a URL into the text field.",
		buttons:{
			original : "Original",
			small : "Small (200px)",
			medium : "Medium (400px)",
			fitPageWidth : "Fit page width"
		}
	}
} );
