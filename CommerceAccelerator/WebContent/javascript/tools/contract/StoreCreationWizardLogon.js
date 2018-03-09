/********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* WebSphere Commerce
*
* (c) Copyright IBM Corp. 2000, 2002
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------*/

// This function takes in a text and performs some substitution		
function changeSpecialText(rawDisplayText,textOne, textTwo, textThree, textFour) {
    	var displayText = rawDisplayText.replace(/%1/, textOne);
    
    	if (textTwo != null){
	    	displayText = displayText.replace(/%2/, textTwo);
	}
    	if (textThree != null){
	    	displayText = displayText.replace(/%3/, textThree);
	}
    	if (textFour != null){
	    	displayText = displayText.replace(/%4/, textFour);
	}	    
    	return displayText;
}	

function preserveParameters(origUrl, newUrl) {

	var origURLParser = new URLParser(origUrl);
	var newURLParser = new URLParser(newUrl);
	var origParamNames = origURLParser.getParameterNames();

	for (var i = 0; i < origParamNames.length; i++) {
		if (origParamNames[i] != "krypto" && newURLParser.getParameterValue(origParamNames[i]) == "") {
			newUrl += "&" + origParamNames[i] + "=" + origURLParser.getParameterValue(origParamNames[i]);
		}
	}
	return newUrl;
}
