<!--===========================================================================
/*
 *-------------------------------------------------------------------
 * IBM Confidential
 * OCO Source Materials
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2002, 2003
 *     All rights reserved.
 *
 * The source code for this program is not published or otherwise
 * divested of its trade secrets, irrespective of what has been
 * deposited with the US Copyright Office.
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

===========================================================================-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="com.ibm.commerce.emarketing.commands.*" %>
<%@include file="../common/common.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="EmailActivityCommon.jsp" %>
<style type='text/css'>
.selectWidth {
	width: 200px;
}
</style>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />

<title><%= emailActivityNLS.get("emailActivityInboundTitle") %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script src="/wcs/javascript/tools/common/DateUtil.js"></script>

<script language="JavaScript">

<!---- hide script from old browsers
function loadPanelData()
 {
   with (document.emailConfigurationInboundForm) {     
      	if (parent.setContentFrameLoaded) {
    		parent.setContentFrameLoaded(true);
    	}
    	
    	if (parent.get) {
    		var o = parent.get("emailConfiguration", null);
    		if (o != null) { 		  
                   Name.value = o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_NAME %>;
   	           Description.value = o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_DESCRIPTION %>;
   	           EmailServer.value = o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_EMLSERVER %>;
   		   	   Account.value =  o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_ACCOUNT %>;
   		   if(o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_PORT %>){
   		       Port.value =  o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_PORT %>;
   		   }else{
   		       Port.value = 110;
   		   }
   		   Password.value =  o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_PASSWORD %>;
   		   EmailAddress.value = o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_ADDRESS %>;
   		   CommerceHost.value = o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_HOST %>;
   		   
               if(o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_RETRY_COUNT %>) {

                 RetryCount.value = o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_RETRY_COUNT %>;
                 RetryRadio[0].checked = true;
                 RetryDiv.style.display='block';
                 ExtractDiv.style.display='none';
               }
               else{

                 RetryRadio[1].checked = true;
                 ExtractDiv.style.display='block';
                 RetryDiv.style.display='none';
               }
               IntervalMinutes.value = o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_RETRY_INTERVAL %>%60;
               IntervalHours.value = (o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_RETRY_INTERVAL %>-IntervalMinutes.value)/60;
   		   
   	        }
    	} 
 
    	Name.focus(); 
    		
    }
    validateDataErrorMessage();
    
 }
 
 function showEmailConfigurationErrorMessage(){
     alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityConfigErrorUpdate")) %>");
 }
 
 function showEmailConfigurationSubmitMessage(){
     if (parent.get) {
          var o = parent.get("emailConfiguration", null);
          if (o != null) { 
              if( o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_ISCONFIGURED%> && (o.originalOutboundHour != o.outboundHour || o.originalOutboundMinute != o.outboundMinute)){
                   alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityNotChangingExistingEA")) %>"); 
              }
          }
     }
 }
  
 function validateDataErrorMessage(){
    with(document.emailConfigurationInboundForm){
           if (parent.get("emailActivityConfigInboundNameRequired", false))
           { 
               parent.remove("emailActivityConfigInboundNameRequired");
               Name.focus();
               alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityConfigInboundNameRequired")) %>");
           }
           
           if (parent.get("emailActivityConfigNameInvalid", false))
           {    
                      parent.remove("emailActivityConfigNameInvalid");
                      Name.focus();
                      alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityConfigNameInvalid")) %>");
           }
           
           if (parent.get("emailActivityConfigNameTooLong", false))
           {    
                      parent.remove("emailActivityConfigNameTooLong");
                      Name.focus();
                      alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityConfigNameTooLong")) %>");
           }
           
           if (parent.get("emailActivityConfigDescriptionTooLong", false))
           {    
                      parent.remove("emailActivityConfigDescriptionTooLong");
                      Description.focus();
                      alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityConfigDescriptionTooLong")) %>");
           }
           
           if (parent.get("emailActivityConfigEmlServerRequired", false))
           {    
    		parent.remove("emailActivityConfigEmlServerRequired");
    		EmailServer.focus();
    		alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityConfigEmlServerRequired")) %>");
           }

           if (parent.get("emailActivityConfigEmlServerTooLong", false))
           {    
                      parent.remove("emailActivityConfigEmlServerTooLong");
                      EmailServer.focus();
                      alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityConfigEmlServerTooLong")) %>");
           }
           
           
           if (parent.get("emailActivityConfigInboundEmailAddressRequired", false))
	   {    
	        parent.remove("emailActivityConfigInboundEmailAddressRequired");
	        EmailAddress.focus();
	        alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityConfigEmailAddressRequired")) %>");
           }
           
           if (parent.get("emailActivityConfigEmailAddressTooLong", false))
	   {    
	             parent.remove("emailActivityConfigEmailAddressTooLong");
	             EmailAddress.focus();
	             alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityConfigEmailAddressTooLong")) %>");
           }
           
           if (parent.get("emailActivityConfigAccountRequired", false))
           {    
           		parent.remove("emailActivityConfigAccountRequired");
           		Account.focus();
           		alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityConfigAccountRequired")) %>");
           }
           
           if (parent.get("emailActivityConfigAccountTooLong", false))
	   {    
	          parent.remove("emailActivityConfigAccountTooLong");
	          Account.focus();
	          alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityConfigAccountTooLong")) %>");
           }
           
           if (parent.get("emailActivityConfigInboundPasswordRequired", false))
           {    
           		parent.remove("emailActivityConfigInboundPasswordRequired");
           		Password.focus();
           		alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityConfigInboundPasswordRequired")) %>");
           }
           
           if (parent.get("emailActivityConfigPasswordTooLong", false))
	   {    
	            parent.remove("emailActivityConfigPasswordTooLong");
	            Password.focus();
	            alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityConfigPasswordTooLong")) %>");
           }
           
           if (parent.get("emailActivityConfigPortInvalid", false))
           {    
                    parent.remove("emailActivityConfigPortInvalid");
                    Port.focus();
                    alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityConfigPortInvalid")) %>");
           }
           
           if (parent.get("emailActivityConfigCommerceHostRequired", false))
           {    
                  	parent.remove("emailActivityConfigCommerceHostRequired");
                  	CommerceHost.focus();
                  	alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityConfigCommerceHostRequired")) %>");
           }
           
           if (parent.get("emailActivityCommerceHostInvalid", false))
	   {    
	                 parent.remove("emailActivityCommerceHostInvalid");
	                 CommerceHost.focus();
	                 alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityCommerceHostInvalid")) %>");
           }
           
           if (parent.get("emailActivityConfigCommerceHostTooLong", false))
	   {    
	                 parent.remove("emailActivityConfigCommerceHostTooLong");
	                 CommerceHost.focus();
	                 alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityConfigCommerceHostTooLong")) %>");
           }
           
           if (parent.get("emailActivityInboundRetryIntervalNaN", false))
           {    
                      parent.remove("emailActivityInboundRetryIntervalNaN");
                      IntervalHours.value = "";
                      IntervalMinutes.value = "";
                      IntervalHours.select();
                      IntervalHours.focus();
                      alertDialog("Only whole numbers are valid input for retry interval fields.");
           }

           if (parent.get("emailActivityInboundRetryIntervalTooSmall", false))
           {    
                      parent.remove("emailActivityInboundRetryIntervalTooSmall");
                      IntervalHours.select();
                      IntervalHours.focus();
                      alertDialog("Retry interval must be one minute or greater.");
           }

           if (parent.get("emailActivityInboundRetryIntervalTooLong", false))
           {    
                      parent.remove("emailActivityInboundRetryIntervalTooLong");
                      IntervalHours.select();
                      IntervalHours.focus();
                      alertDialog("Retry interval must be less than one month.");
           }

           if (parent.get("emailActivityInboundExtractTimeNaN", false))
           {    
                      parent.remove("emailActivityInboundExtractTimeNaN");
                      IntervalHours.value = "";
                      IntervalMinutes.value = "";
                      IntervalHours.select();
                      IntervalHours.focus();
                      alertDialog("Only whole numbers are valid input for extract time fields.");
           }

           if (parent.get("emailActivityInboundExtractTimeTooSmall", false))
           {    
                      parent.remove("emailActivityInboundExtractTimeTooSmall");
                      IntervalHours.select();
                      IntervalHours.focus();
                      alertDialog("Length of time after delivery must be one minute or greater.");
           }

           if (parent.get("emailActivityInboundExtractTimeTooLong", false))
           {    
                      parent.remove("emailActivityInboundExtractTimeTooLong");
                      IntervalHours.select();
                      IntervalHours.focus();
                      alertDialog("Length of time after delivery must be less than one month.");
           }


   }
 
 }
 


function savePanelData(){
      with (document.emailConfigurationInboundForm) {
          if (parent.get) {
	  	var o = parent.get("emailConfiguration", null);
	  }
	  if (o != null) {	  	
            o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_NAME %> = Name.value;
            o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_DESCRIPTION %> =  Description.value;
            o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_HOST %> = CommerceHost.value;
	    o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_ACCOUNT %> = Account.value;
            o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_PASSWORD %> = Password.value;
            o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_ADDRESS %> = EmailAddress.value;
	    o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_PORT %> = Port.value;
	    o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_EMLSERVER %> = EmailServer.value;
          if (RetryRadio[0].checked) {
            o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_RETRY_COUNT %> = RetryCount.value;
          }
          else {
            o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_RETRY_COUNT %> = Number(0);
          }

          o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_INBOUND_RETRY_INTERVAL %> = Number(IntervalHours.value * 60) + Number(IntervalMinutes.value);
	    
       	  }
     }
     
}

//-->
</script>

<meta name="GENERATOR" content="IBM WebSphere Studio" />
</head>

<body onload="loadPanelData()" class="content">

<h1><%= emailActivityNLS.get("emailActivityInboundConfig") %></h1>

<form name="emailConfigurationInboundForm">

<p><label for="nameID"><%= emailActivityNLS.get("emailActivityName") %></label> <br />
<input name="Name" id="nameID" type="text" size="30" maxlength="40" /> <br />
<br />

<label for="descriptionID"><%= emailActivityNLS.get("emailActivityDescription") %></label> <br />
<input name="Description" id="descriptionID" type="text" size="50" maxlength="254" /> </label> <br />
<br />

<label for="emailServerID"><%= emailActivityNLS.get("emailActivityHost") %></label> <br />
<input name="EmailServer" id="emailServerID" type="text" size="30" maxlength="254" /> <br />
<br />

<label for="emailAddressID"><%= emailActivityNLS.get("emailActivityEmailAddress") %> </label> <br />
<input name="EmailAddress" id="emailAddressID" type="text" size="30" maxlength="254" /> <br />
<br />

<label for="accountID"><%= emailActivityNLS.get("emailActivityAccount") %></label> <br />
<input name="Account" id="accountID" type="text" size="30" maxlength="254" /> <br />
<br />

<label for="passwordID"><%= emailActivityNLS.get("emailActivityPassword") %></label>  <br />
<input name="Password" id="passwordID" type="password" size="30" maxlength="128" /> <br />
<br />

<label for="portID"><%= emailActivityNLS.get("emailActivityPort") %></label> <br />
<input name="Port" id="portID" type="text" size="6" maxlength="6" /> <br />
<br />

<label for="commerceHostID"><%= emailActivityNLS.get("emailActivityCommerceHost") %></label> <br />
<input name="CommerceHost" id="commerceHostID" type="text" size="30" maxlength="254" /> <br />
<br />
<input name="RetryRadio" type="radio" value="doRetry" id="retryBouncesID" onclick="RetryDiv.style.display='block';ExtractDiv.style.display='none'; RetryCount.style.visibility='visible';" /><label for="retryBouncesID"><%= emailActivityNLS.get("emailActivityRetryBounces") %></label><br />
<input name="RetryRadio" type="radio" value="extractOnly" id="extractOnlyID" onclick="ExtractDiv.style.display='block';RetryDiv.style.display='none'; RetryCount.style.visibility='hidden';" /><label for="extractOnlyID"><%= emailActivityNLS.get("emailActivityExtractOnly") %></label><br />
<br />
</p><div id="RetryDiv" style="display: none; margin-left: 20">
<label for="retryCountID"><%= emailActivityNLS.get("emailActivityNumberOfRetries") %> </label> 
<select name="RetryCount" id="retryCountID">
<option value="1">1</option>
<option value="2">2</option>
<option value="3" selected="selected">3</option>
<option value="4">4</option>
<option value="5">5</option>
<option value="6">6</option>
<option value="7">7</option>
<option value="8">8</option>
<option value="9">9</option>
<option value="10">10</option>
<option value="11">11</option>
<option value="12">12</option>
</select>
<br />
<br />
<%= emailActivityNLS.get("emailActivityRetryInterval") %>

</div>

<div id="ExtractDiv" style="display: none; margin-left: 20">
<%= emailActivityNLS.get("emailActivityBounceExtract") %>
</div>
<div style="margin-left: 20">
<input name="IntervalHours" id="hoursID" value="" size="3"></input><label for="hoursID"> <%= emailActivityNLS.get("emailActivityHours") %> </label> <input name="IntervalMinutes" id="minutesID" value="" size="2"></input><label for="minutesID"> <%= emailActivityNLS.get("emailActivityMinutes") %></label> <br /><br />
</div>

</form>
</body>
</html>
