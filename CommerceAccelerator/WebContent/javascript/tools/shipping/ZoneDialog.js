//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*




function submitErrorHandler (submitErrorMessage, submitErrorStatus) {
	if (submitErrorStatus == "zoneExists") {
		put("zoneExists", true);
		gotoPanel("zonePanel");
	}
	else if (submitErrorStatus == "zoneChanged") {
		put("zoneChanged", true);
		gotoPanel("zonePanel");
	}
	else {
		alertDialog(submitErrorMessage);
	}
}

function submitFinishHandler (submitFinishMessage) {
	if (submitFinishMessage != null && submitFinishMessage != "")
		alertDialog(submitFinishMessage);
	submitCancelHandler();
}

function submitCancelHandler () {
	if (top.goBack) {
		top.goBack();
	}
	else {
		window.location.replace("ZonesView?ActionXMLFile=shipping.ZonesList&cmd=ZonesListView&orderby=name&selected=SELECTED&listsize=20&startindex=0&refnum=0");
	}

}
