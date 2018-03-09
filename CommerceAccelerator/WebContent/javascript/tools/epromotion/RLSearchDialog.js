//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------
function searchAction() {
	if (resultURL) {
		NAVIGATION.addURLParameter("XMLFile", NAVIGATION.requestProperties.XMLFile);
		NAVIGATION.document.submitForm.target = resultTargetFrame;
		NAVIGATION.document.submitForm.action = resultURL;
	}
	else {
		NAVIGATION.document.submitForm.action = "";
	}
	finish();
}

function cancelAction() {
	self.CONTENTS.cancelAction();
}


function refineAction() {
	var urlParser = new URLParser(NAVIGATION.document.URL);
	var url = urlParser.getRequestURI() + "?XMLFile=" + "RLPromotion.searchDialog";
	NAVIGATION.location.replace(url);
	CONTENTS.location.replace(searchDialogContentURL);
}


function submitFinishHandler(msg) {
}

