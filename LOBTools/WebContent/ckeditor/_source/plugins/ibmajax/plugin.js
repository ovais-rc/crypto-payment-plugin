/* Copyright IBM Corp. 2011-2014 All Rights Reserved.                    */

/**
 * @fileOverview Defines the {@link CKEDITOR.ibmajax} object, which supports POST requests
 */

(function() {
	CKEDITOR.plugins.add( 'ibmajax', {
		//requires: 'xml'
	});

	/**
	 * Ajax methods for data loading.
	 *
	 * @class
	 * @singleton
	 */
	CKEDITOR.ibmajax = (function() {
	
		/*****createXMLHttpRequest and getResponseText functions are copied from plugins/ajax/plugins.js as these functions are not publicly accessible****/
		var createXMLHttpRequest = function() {
				// In IE, using the native XMLHttpRequest for local files may throw
				// "Access is Denied" errors.
				if ( !CKEDITOR.env.ie || location.protocol != 'file:' )
					try {
					return new XMLHttpRequest();
				} catch ( e ) {}

				try {
					return new ActiveXObject( 'Msxml2.XMLHTTP' );
				} catch ( e ) {}
				try {
					return new ActiveXObject( 'Microsoft.XMLHTTP' );
				} catch ( e ) {}

				return null;
			};

		var getResponseText = function( xhr ) {
				if ( xhr && (typeof xhr !=='undefined') && xhr.readyState == 4 )
					return xhr.responseText;
				return null;
			};
			
		var post = function( url, content, callback, getResponseFn ) {
			var async = !!callback;

			var xhr = createXMLHttpRequest();

			if ( !xhr )
				return null;

			xhr.open( 'POST', url, async );
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

			if ( async ) {
				// TODO: perform leak checks on this closure.
				xhr.onreadystatechange = function() {
					if ( xhr.readyState == 4 ) {
						callback( getResponseFn( xhr ) );
						xhr = null;
					}
				};
			}

			xhr.send( content );

			return async ? '' : getResponseFn( xhr );
		};

		return {
			/**
			 * Loads data from a POST request as plain text.
			 *
			 *		// Load data synchronously.
			 *		var data = CKEDITOR.ibmajax.post( 'somedata.txt' );
			 *		alert( data );
			 *
			 *		// Load data asynchronously.
			 *		var data = CKEDITOR.ibmajax.post( 'somedata.txt', function( data ) {
			 *			alert( data );
			 *		} );
			 *
			 * @param {String} url The URL to POST to.
			 * @param {Function} [callback] A callback function to be called on
			 * data load. If not provided, the data will be loaded
			 * synchronously.
			 * @returns {String} The loaded data. For asynchronous requests, an
			 * empty string. For invalid requests, `null`.
			 */
			
			post: function( url, content, callback ) {
				return post( url, content, callback, getResponseText );
			}
		};
	})();

})();
