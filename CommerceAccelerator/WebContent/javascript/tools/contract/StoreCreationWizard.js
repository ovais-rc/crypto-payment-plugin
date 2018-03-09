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
   	if(errStatus == "DuplicatedContractName"){
   		put("DuplicatedContractName", true);
   		gotoPanel("storeGeneralPanel");	  		
   	}else if(errStatus == "StoreIdentifierAlreadyExists"){
   		put("StoreIdentifierAlreadyExists", true);
   		gotoPanel("storeGeneralPanel");	  		
   	}else if(errStatus == "StoreOwnerOwnsDifferentType"){
   		put("StoreOwnerOwnsDifferentType", true);
   		gotoPanel("storeGeneralPanel");	  		
   	}else if(errStatus == "FulfillmentCenterNameAlreadyExists"){
   		put("FulfillmentCenterNameAlreadyExists", true);
   		if(errMessage != null){
   			put("DuplicateFulfillmentCenterName", errMessage);
   		}
   		gotoPanel("fulfillmentPanel");	  		
   	}else if(errStatus == "EmailIsMultibyte"){
   		put("EmailIsMultibyte", true);
   		gotoPanel("storeGeneralPanel");	  		
   	}else{
   		put("InternalConfigError", true);
   		gotoPanel("summaryPanel");	  		
   	}
}

// checks if the Tools framework has been loaded or not... The field "pdata" is an object defined in ToolsUI.jsp
// "doExitAlert" is a flag that is being used to display an exit alert message.
if(top.pdata){
	top.doExitAlert = true;
}

// submitCancelHandler() is called when cancel is selected.
function submitCancelHandler() {
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


// submitFinishHandler() is called if the submit command does not return a submitErrorStatus code (ie. successful case)
function submitFinishHandler(finishMessage){
	
	var forwardingURL = null;
	var contractId = NAVIGATION.requestProperties['contractId']; 	
  
   	forwardingURL = "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.StoreCreationConfirmationDialog&contractId=" + contractId;
   	
	if(top.get("launchSeparateWindow") != null && top.get("launchSeparateWindow") == "false"){	
		forwardingURL = forwardingURL + "&launchSeparateWindow=false"; 		
	}
	if(top.get("fromAccelerator") != null && top.get("fromAccelerator") == "true"){	
		forwardingURL = forwardingURL + "&fromAccelerator=true"; 		
	}	
	if(top.get("storeViewName") != null){	
		forwardingURL = forwardingURL + "&storeViewName=" + top.get("storeViewName"); 		
	}		
   	document.location = forwardingURL;
}

   
// preSubmitHandler() is Called after validateAllPanels() but before finish controller command
function preSubmitHandler(){	
	if(top.get("storeId") != null){
//alert("in preSubmit " + top.get("storeId"));
		addURLParameter("storeId", top.get("storeId")); 
	}	
//alert("in preSubmit");
	if(top.get("paymentOverride") != null){
//alert("have paymentOverride " + top.get("paymentOverride"));
		addURLParameter("paymentOverride", top.get("paymentOverride")); 
	}
	if(get("SWCStoreTypeData").aopStore == '1'){
//alert("have paymentOverride for aop store" );
		addURLParameter("paymentOverride", "true"); 
	}	
}




function isValidInputText(myString) {
    var invalidChars = ""; // invalid chars
    invalidChars += "\t"; // escape sequences
    
    // if the string is empty it is not a valid name
    if (isEmpty(myString)) return false;
 
    // look for presence of invalid characters.  if one is
    // found return false.  otherwise return true
    for (var i=0; i<myString.length; i++) {
      if (invalidChars.indexOf(myString.substring(i, i+1)) >= 0) {
        return false;
      }
    }            
    return true;
}



function isValidEmail(strEmail){
	if (strEmail.length < 5) {
             return false;
       	}else{
           	if (strEmail.indexOf(" ") > 0){
                      	return false;
               	}else{
                  	if (strEmail.indexOf("@") < 1) {
                            	return false;
                     	}else{
                           	if (strEmail.lastIndexOf(".") < (strEmail.indexOf("@") + 2)){
                                     	return false;
                                }else{
                                        if (strEmail.lastIndexOf(".") >= strEmail.length-2){
                                        	return false;
                                        }
                              	}
                       	}
              	}
       	}
      	return true;
}


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


function KeyListener(e){
	// 13 is the "Enter" key
	if(e.keyCode == 13){
		CONTENTS.addButtonAction();
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



if(top.mccbanner && top.get("closingRedirectURL")) {
	top.mccbanner.openLink = function () {
		top.mccbanner.document.location = "javascript: void(0);";
	}
}