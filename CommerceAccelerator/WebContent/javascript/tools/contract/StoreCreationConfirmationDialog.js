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

// submitErrorHandler() is called if the submit command returns a submitErrorStatus code.   
function submitErrorHandler(errMessage, errStatus){
}

// submitCancelHandler() is called when cancel is selected.
function submitCancelHandler(){  	
}

// submitFinishHandler() is called if the submit command does not return a submitErrorStatus code (ie. successful case)
function submitFinishHandler(finishMessage){
}

// preSubmitHandler() is Called after validateAllPanels() but before finish controller command
function preSubmitHandler(){
	top.doExitAlert = false;
	if(top.get("launchSeparateWindow") != null && top.get("launchSeparateWindow") == "false"){
		if (top.get("fromAccelerator") != null && top.get("fromAccelerator") == "true") {
			top.goBack();
		} else {
	 		var redirectURL = top.get("closingRedirectURL"); 
   			top.remove("closingRedirectURL");
   			top.remove("launchSeparateWindow"); 
   			top.location.href = redirectURL;
   		}
	}else{	
     			top.close();
     	}	
}



if(top.pdata && top.get("closingRedirectURL")){

        top.beforeExit = function () {

		if(top.mccmain && top.doExitAlert){
			if(top.get("closingWindowMessage")){
   				alertDialog(top.get("closingWindowMessage")); 
   			}
   		}  	
   		var redirectURL = top.get("closingRedirectURL"); 
   		top.remove("closingRedirectURL"); 
   	
   		var fromAccelerator = false;
		if (top.get("fromAccelerator") != null && top.get("fromAccelerator") == "true")
			fromAccelerator = true;
			
   		if(top.opener && !top.opener.closed && fromAccelerator == false){
   			top.opener.document.location = redirectURL;
   			top.closeChildWindows();
   		  	
   		}
	}

}