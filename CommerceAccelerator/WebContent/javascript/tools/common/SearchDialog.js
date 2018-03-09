/********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* WebSphere Commerce
*
* (c) Copyright IBM Corp. 2000
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------*/

function searchAction() {
	if (!hasSetBCT && resultURL) {
		if (userParams != "") {
			resultURL = (resultURL.indexOf("?") == -1)?(resultURL + "?"):(resultURL + "&");
			resultURL = resultURL + userParams;
		}
		NAVIGATION.addURLParameter("XMLFile", NAVIGATION.requestProperties.XMLFile);
		NAVIGATION.document.submitForm.target = resultTargetFrame;
		NAVIGATION.document.submitForm.action = resultURL;
	}
	else {
		NAVIGATION.document.submitForm.action = "";
	}
	
	finish();
}

function preSubmitHandler() {	
	if (hasSetBCT) {
		top.saveModel(model);
		top.setContent(bctName, resultURL, isNewTrail, model);		
	}	
}

function refineAction() {
	var urlParser = new URLParser(NAVIGATION.document.URL);
	var url = urlParser.getRequestURI() + "?XMLFile=" + "common.searchDialog";
	NAVIGATION.location.replace(url);
	CONTENTS.location.replace(searchDialogContentURL);
}

function submitFinishHandler(msg) {
}


