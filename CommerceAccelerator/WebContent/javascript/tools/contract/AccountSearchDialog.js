
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

function userValidatePanelData() {
		return true;
}

function userSavePanelData() {
	//Saves current model into HOME trail's contractSearchParm
	if (model) {
		var mod = model;		
		top.mccbanner.trail[1].accountSearchParm = mod;
	}
	//alert ( dumpObject(model));
	//alert (dumpObject (top.mccbanner.trail[1].contractSearchParm));
}

function userLoadPanelData () {
	//Repopulate fields with previous search.	
	var previousModel = top.mccbanner.trail[1].accountSearchParm;
	if (previousModel) {
		//Check to see the search are coming from the right search page by comparing page type.
		if (top.mccbanner.trail[1].accountSearchParm.pageType == CONTENTS.document.searchForm.pageType.value) {
			model = previousModel;
		}
	}
	//alert (dumpObject (model));
}

function submitCancelHandler()
{	
	top.goBack();	

	//Return to previous page with Title and URL in XML file when Cancel button is pressed.
	//except for Reseller Search for Reporting where it will go back to 'HOME'
//	if ((top.mccbanner.trail[1].prevSearchLocation == "") ||  (top.mccbanner.trail[1].prevSearchLocation == null) ||  (top.mccbanner.trail[1].prevSearchLocation == undefined))
//		top.goBack();	
//	else
//		top.setContent (top.mccbanner.trail[1].prevSearchTitle, top.mccbanner.trail[1].prevSearchLocation, false);
		
}
