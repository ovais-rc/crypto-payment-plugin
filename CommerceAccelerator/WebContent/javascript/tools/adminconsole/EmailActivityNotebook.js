/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation.2002,2003
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//------------------------------------------------------------------------------
//
////////////////////////////////////////////////////////////////////////////////
   function submitErrorHandler (errMessage, errStatus)
   {
     self.CONTENTS.showEmailConfigurationErrorMessage();
     if (top.goBack)
     {
         top.goBack();
     }
   }

   function submitFinishHandler (finishMessage)
   {
        
	if (top.goBack) {
	           top.goBack();
        } 
   }

   function submitCancelHandler()
   {
        if (top.goBack) {
           top.goBack();
        } 
        else {
           alertDialog("Error: top.goBack invalid");
           parent.location.replace(top.getWebPath() + "NewDynamicListView?ActionXMLFile=adminconsole.OrgEntityList&amp;cmd=OrgEntityListView" );
        }
   }

   function preSubmitHandler()
   { 
         self.CONTENTS.showEmailConfigurationSubmitMessage();
   }
   
   function validateAllPanels(){ 
      if (validateOutboundPanel() && validateInboundPanel())
        return true;
      else
        return false;        
   }
  
   function validateOutboundPanel() {  
        var o = get("emailConfiguration");

      	if (!o.outboundName) {
      	    put("emailActivityConfigOutboundNameRequired", true);
	    gotoPanel("emailActivityOutboundPanel");
	    return false;
	}
     
        if (!isValidName(o.outboundName )) { 
	    put("emailActivityConfigNameInvalid", true);
	    gotoPanel("emailActivityOutboundPanel");
	    return false;
	}
		
	if (!isValidUTF8length(o.outboundName, 40)) {
	    put("emailActivityConfigNameTooLong", true);
	    gotoPanel("emailActivityOutboundPanel");
	    return false;
	}
			
	if (!isValidUTF8length(o.outboundDescription, 254)) {
	    put("emailActivityConfigDescriptionTooLong", true);
	    gotoPanel("emailActivityOutboundPanel");
	    return false;
	}	
	
	if(!o.outboundEmlServer){
	    put("emailActivityConfigEmlServerRequired", true);
	    gotoPanel("emailActivityOutboundPanel");
	    return false;
	}
	
	if(!isValidUTF8length(o.outboundEmlServer, 254)){
	    put("emailActivityConfigEmlServerTooLong", true);
	    gotoPanel("emailActivityOutboundPanel");
	    return false;
	}


	if(!o.outboundAccount){
	    put("emailActivityConfigAccountRequired", true);
	    gotoPanel("emailActivityOutboundPanel");
	    return false;
	}
	
	if(!isValidUTF8length(o.outboundAccount, 254)){
	    put("emailActivityConfigAccountTooLong", true);
	    gotoPanel("emailActivityOutboundPanel");
	    return false;
	}
	
	if( o.outboundAuthentication == true){
	   if( !o.outboundPassword){
	        put("emailActivityConfigPasswordRequired", true);
	        gotoPanel("emailActivityOutboundPanel");
	        return false;
	   }
	   if(!isValidUTF8length(o.outboundPassword, 128)){
	       put("emailActivityConfigPasswordTooLong", true);
	       gotoPanel("emailActivityOutboundPanel");
	       return false;
	   }   
	}

	if(!isValidPositiveInteger(o.outboundPort)){
	    put("emailActivityConfigPortInvalid", true);
	    gotoPanel("emailActivityOutboundPanel");
	    return false;
	}
	
	if(!o.outboundHost){
	    put("emailActivityConfigCommerceHostRequired", true);
	    gotoPanel("emailActivityOutboundPanel");
            return false;
	}else if(!isValidUTF8length(o.outboundHost, 254)){
	    put("emailActivityConfigCommerceHostTooLong", true);
	    gotoPanel("emailActivityOutboundPanel");
	    return false;
	}
 
        if(!o.outboundAddress){
            put("emailActivityConfigOutboundEmailAddressRequired", true);
	    gotoPanel("emailActivityOutboundPanel");
       	    return false;
        
        }
        if (!isValidUTF8length(o.outboundAddress, 254)) {
		    put("emailActivityConfigEmailAddressTooLong", true);
	       	    gotoPanel("emailActivityOutboundPanel");
	       	    return false;
	}

	
	var time = o.outboundHour + ':' + o.outboundMinute;
	if( ! validTime(time)){
	    put("emailActivityConfigTimeInvalid", true);
	    gotoPanel("emailActivityOutboundPanel");
	    return false;
	}else{
	    o.outboundTime = Number(o.outboundHour) *60 + Number(o.outboundMinute);
        }
        
        return true; 
   }
    
   function verifyHostname(hostname){  
      if( hostname.length == 0 || hostname.indexOf(".") == -1){
         return true;
       }else{
         if( hostname.indexOf(".") == 0 || hostname.indexOf(".") == (hostname.length-1) ){
       	    return false;
         } else{
            return verifyHostname(hostname.substring(hostname.indexOf(".") +1));
         }
       } 
        
   }
  
   function validateInboundPanel(){
       var o = get("emailConfiguration");

        if (!o.inboundName) {
            put("emailActivityConfigInboundNameRequired", true);
       	    gotoPanel("emailActivityInboundPanel");
       	    return false;
       	}
            
        if (!isValidName(o.inboundName )) { 
       	    put("emailActivityConfigNameInvalid", true);
       	    gotoPanel("emailActivityInboundPanel");
       	    return false;
       	}
       		
       	if (!isValidUTF8length(o.inboundName, 40)) {
       	    put("emailActivityConfigNameTooLong", true);
       	    gotoPanel("emailActivityInboundPanel");
       	    return false;
       	}
       			
       	if (!isValidUTF8length(o.inboundDescription, 254)) {
       	    put("emailActivityConfigDescriptionTooLong", true);
       	    gotoPanel("emailActivityInboundPanel");
       	    return false;
       	}	
       	
       	if(!o.inboundEmlServer){
       	    put("emailActivityConfigEmlServerRequired", true);
       	    gotoPanel("emailActivityInboundPanel");
       	    return false;
       	}
       
        if (!isValidUTF8length(o.inboundEmlServer, 254)) {
		    put("emailActivityConfigEmlServerTooLong", true);
	       	    gotoPanel("emailActivityInboundPanel");
	       	    return false;
	}
       		
       	if(!o.inboundAccount){
       	    put("emailActivityConfigAccountRequired", true);
       	    gotoPanel("emailActivityInboundPanel");
       	    return false;
       	}
       	
       	if (!isValidUTF8length(o.inboundAccount, 254)) {
		    put("emailActivityConfigAccountTooLong", true);
	       	    gotoPanel("emailActivityInboundPanel");
	       	    return false;
	}

       	if( !o.inboundPassword){
       	    put("emailActivityConfigInboundPasswordRequired", true);
       	    gotoPanel("emailActivityInboundPanel");
       	    return false;
       	}
        
        if (!isValidUTF8length(o.inboundPassword, 128)) {
		    put("emailActivityConfigPasswordTooLong", true);
	       	    gotoPanel("emailActivityInboundPanel");
	       	    return false;
	}
       	
        if( !o.inboundAddress){
            put("emailActivityConfigInboundEmailAddressRequired", true);
	    gotoPanel("emailActivityInboundPanel");
       	    return false;
        
        }
        if (!isValidUTF8length(o.inboundAddress, 254)) {
		    put("emailActivityConfigEmailAddressTooLong", true);
	       	    gotoPanel("emailActivityInboundPanel");
	       	    return false;
	}
        
       	if(!isValidPositiveInteger(o.inboundPort.toString())){
       	    put("emailActivityConfigPortInvalid", true);
       	    gotoPanel("emailActivityInboundPanel");
       	    return false;
       	}
       	
       	if(!o.inboundHost){
       	    put("emailActivityConfigCommerceHostRequired", true);
       	    gotoPanel("emailActivityInboundPanel");
            return false;
	}else if(!isValidUTF8length(o.inboundHost, 254)) {
	    put("emailActivityConfigCommerceHostTooLong", true);
	    gotoPanel("emailActivityInboundPanel");
	    return false;
	}
	
        if(o.inboundRetryCount > 0) {
          if (!isFinite(o.inboundRetryInterval) || String(o.inboundRetryInterval).search(/[^0-9]/) != -1) {
	    put("emailActivityInboundRetryIntervalNaN", true);
	    gotoPanel("emailActivityInboundPanel");
	    return false;

          }

          if (o.inboundRetryInterval <= 0) {
	    put("emailActivityInboundRetryIntervalTooSmall", true);
	    gotoPanel("emailActivityInboundPanel");
	    return false;

          }
          if (o.inboundRetryInterval > Number(28*24*60)) {
	    put("emailActivityInboundRetryIntervalTooLong", true);
	    gotoPanel("emailActivityInboundPanel");
	    return false;

          }            
        }
        else {
          if (!isFinite(o.inboundRetryInterval) || String(o.inboundRetryInterval).search(/[^0-9]/) != -1) {
	    put("emailActivityInboundExtractTimeNaN", true);
	    gotoPanel("emailActivityInboundPanel");
	    return false;

          }
          if (o.inboundRetryInterval <= 0) {
	    put("emailActivityInboundExtractTimeTooSmall", true);
	    gotoPanel("emailActivityInboundPanel");
	    return false;

          }
          if (o.inboundRetryInterval > Number(28*24*60)) {
	    put("emailActivityInboundExtractTimeTooLong", true);
	    gotoPanel("emailActivityInboundPanel");
	    return false;

          }                          
        }

        return true; 
   }
