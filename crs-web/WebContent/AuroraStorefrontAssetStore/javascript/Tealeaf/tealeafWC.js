//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2012, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------


TealeafWCJS ={
	
	processDOMEvent:function(event){
		if (typeof TLT !== 'undefined') {
			TLT.processDOMEvent(event);
		}
	},

	rebind:function(id){
		if (typeof TLT !== 'undefined' && TLT.rebind) {
			var scope = $("#" + id)[0];
			if (scope) {
				TLT.rebind(scope);
			}
		}
	},
	
	logClientValidationCustomEvent:function( customMsgObj){
		if (typeof TLT !== 'undefined') {
			if(TLT.isInitialized()){
				TLT.logCustomEvent("WCClientValidation", customMsgObj);
			}
			else{
				setTimeout(function () { logClientValidationCustomEvent( customMsgObj)}, 100);
			}
		}
	},
	
	createExplicitChangeEvent:function(id){
		if (typeof TLT !== 'undefined') {
			$("#" + id).trigger("change");
		}
	}
}