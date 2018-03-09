/****************************************************************************
 *
 * Licensed Materials - Property of IBM
 *
 * WebSphere Commerce
 *
 * (c) Copyright IBM Corp. 2002
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 * 
 ***************************************************************************/

function submitErrorHandler(errorMessage)
{
	alertDialog(errMessage);
}

function submitFinishHandler(finishMessage)
{
	top.setHome();
}

function submitCancelHandler()
{
	top.setHome();
}

function viewStoreButton()
{
	if (self.isContentFrameLoaded() == false) 
	{
		return;
	}
	
	loc = "http://";
	loc += self.location.hostname;
	loc += self.get("StoresWebPath");
	loc += "/";
	loc += "StoreView?storeId=";
	loc += encodeURI(self.get("StoreId"));
	
	window.open(loc,'');	
}

function okButton()
{
	self.submitCancelHandler();
}