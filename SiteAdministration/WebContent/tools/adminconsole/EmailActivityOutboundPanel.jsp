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
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.emarketing.beans.EmailConfigurationDataBean" %>
<%@ page import="com.ibm.commerce.emarketing.commands.*" %>
<%@ page import="java.sql.Timestamp" %>

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

<title><%= emailActivityNLS.get("emailActivityOutboundTitle") %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script src="/wcs/javascript/tools/common/DateUtil.js"></script>

<script language="JavaScript">
<!-- hide script from old browsers


function showDivisions () {
	with (document.emailConfigurationOutboundForm) {
		if (Authentication.checked == true) {
			document.all.customUrlDiv.style.display = "block";
		}
		else {
			document.all.customUrlDiv.style.display = "none";
		}
	}
}

function loadPanelData()
 { 
    with (document.emailConfigurationOutboundForm) {     
   	if (parent.setContentFrameLoaded) {
 		parent.setContentFrameLoaded(true);
 	}
 	
 	if (parent.get) {
 		var o = parent.get("emailConfiguration", null);
 		if (o != null) { 		  
 		   Name.value = o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_OUTBOUND_NAME %>;
	           Description.value = o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_OUTBOUND_DESCRIPTION %>;
	           EmailServer.value = o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_OUTBOUND_EMLSERVER %>;
		   Account.value =  o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_OUTBOUND_ACCOUNT %>;
		   Address.value =  o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_OUTBOUND_ADDRESS %>;
		   if(o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_OUTBOUND_PORT %>){
		      Port.value = o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_OUTBOUND_PORT %>;
		   }else{
		      Port.value = 25;
		   }
		   if( o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_OUTBOUND_AUTHENTICATION %> == true) { 
		        Authentication.checked = true;
		        showDivisions ();
		        Password.value =  o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_OUTBOUND_PASSWORD %>;
		   }
		   CommerceHost.value = o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_OUTBOUND_HOST %>;
		   if( (o.outboundHour) || (o.outboundMinute) ){
		        Hour.value = o.outboundHour;
		      	Minute.value = o.outboundMinute;
		   } else if(o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_OUTBOUND_TIME %> >=0 && o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_ISCONFIGURED%>){
		      	var time = o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_OUTBOUND_TIME %>;
		      	var minute = time%60;
		      	var hour = (time - minute)/60;
		      	Minute.value = minute;
		      	Hour.value = hour;
		      	o.originalOutboundHour = hour;
		      	o.originalOutboundMinute = minute;
   		   }
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

   with(document.emailConfigurationOutboundForm){
       if (parent.get("emailActivityConfigOutboundNameRequired", false))
       { 
           parent.remove("emailActivityConfigOutboundNameRequired");
           Name.focus();
           alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityConfigOutboundNameRequired")) %>");
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
       
       if (parent.get("emailActivityConfigEmlServerTooLong", false))
       {    
                parent.remove("emailActivityConfigEmlServerTooLong");
                EmailServer.focus();
                alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityConfigEmlServerTooLong")) %>");
       }
       
       if (parent.get("emailActivityConfigEmlServerRequired", false))
       {    
		parent.remove("emailActivityConfigEmlServerRequired");
		EmailServer.focus();
		alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityConfigEmlServerRequired")) %>");
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
       
       if (parent.get("emailActivityConfigPasswordRequired", false))
       {    
       		parent.remove("emailActivityConfigPasswordRequired");
       		Password.focus();
       		alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityConfigPasswordRequired")) %>");
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
       
       if (parent.get("emailActivityConfigTimeInvalid", false))
       {       
                  parent.remove("emailActivityConfigTimeInvalid");
                  Hour.focus();
                  alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityConfigTimeInvalid")) %>");
       }

       if (parent.get("emailActivityConfigOutboundEmailAddressRequired", false))
	 {    
	      parent.remove("emailActivityConfigOutboundEmailAddressRequired");
	      Address.focus();
	      alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityConfigEmailAddressRequired")) %>");
       }
           
       if (parent.get("emailActivityConfigEmailAddressTooLong", false))
	 {    
	            parent.remove("emailActivityConfigEmailAddressTooLong");
	             Address.focus();
	             alertDialog("<%= UIUtil.toJavaScript((String)emailActivityNLS.get("emailActivityConfigEmailAddressTooLong")) %>");
       }


   }
}

function savePanelData(){
      with (document.emailConfigurationOutboundForm) {
          if (parent.get) {
	  	var o = parent.get("emailConfiguration", null);
	  }
	  if (o != null) {	  
            o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_OUTBOUND_NAME %> = Name.value;
            o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_OUTBOUND_DESCRIPTION %> =  Description.value;
            o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_OUTBOUND_HOST %> = CommerceHost.value;
	    o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_OUTBOUND_ACCOUNT %> = Account.value;
	    o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_OUTBOUND_ADDRESS %> = Address.value;
	    o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_OUTBOUND_AUTHENTICATION %> = Authentication.checked;
	    if(Authentication.checked == true){
                   o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_OUTBOUND_PASSWORD %> = Password.value;
	    } else
	    {      o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_OUTBOUND_PASSWORD %> = null;
	    }
	    o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_OUTBOUND_PORT %> = Port.value;
	    o.<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CFG_OUTBOUND_EMLSERVER %> = EmailServer.value;
	    
	    o.outboundHour= Hour.value;
	    o.outboundMinute = Minute.value;
	    
	    
       	  }
     }
}
//-->
</script>

<meta name="GENERATOR" content="IBM WebSphere Studio" />
</head>
<body onload="loadPanelData()" class="content">

<h1><%= emailActivityNLS.get("emailActivityOutboundConfig") %></h1>

<form name="emailConfigurationOutboundForm">

<p><label for="nameID"><%= emailActivityNLS.get("emailActivityName") %></label><br />
<input name="Name" type="text" id="nameID" size="30" maxlength="40" /> <br />
<br />

<label for="descriptionID"><%= emailActivityNLS.get("emailActivityDescription") %></label><br />
<input name="Description" id="descriptionID" type="text" size="50" maxlength="254" /> <br />
<br />

<label for="emailServerID"><%= emailActivityNLS.get("emailActivityHost") %></label><br />
<input name="EmailServer" id="emailServerID" type="text" size="30" maxlength="254" /> <br />
<br />

<label for="addressID"><%= emailActivityNLS.get("emailActivityEmailAddress") %></label><br />
<input name="Address" id="addressID" type="text" size="30" maxlength="254" /> <br />
<br />

<label for="accountID"><%= emailActivityNLS.get("emailActivityAccount") %></label><br />
<input name="Account" id="accountID" type="text" size="30" maxlength="254" /> <br />
<br />

<label for="authenticationID"><%= emailActivityNLS.get("emailActivityAuthentication") %> </label><input name="Authentication" id="authenticationID" type="checkbox" value="false" onclick="showDivisions()" /><br />

</p><div id="customUrlDiv" style="display: none; margin-left: 20"><label for="passwordID"><%= emailActivityNLS.get("emailActivityPassword") %> </label><br />
<input name="Password" id="passwordID" type="password" size="30" maxlength="128" /></div>
<br />

<label for="portID"><%= emailActivityNLS.get("emailActivityPort") %></label><br />
<input name="Port" id="portID" type="text" size="6" maxlength="6" /> <br />
<br />

<label for="commerceHostID"><%= emailActivityNLS.get("emailActivityCommerceHost") %></label><br />
<input name="CommerceHost" id="commerceHostID" type="text" size="30" maxlength="254" /> <br />
<br />
<table name="timeTable">
    <tr>
        <td></td>
        <td><label for="hourID"><%= emailActivityNLS.get("emailActivityHour") %></label></td>
        <td><label for="minuteID"><%= emailActivityNLS.get("emailActivityMinute") %></label></td>
    </tr>
    <tr>
        <td><%= emailActivityNLS.get("emailActivityStartTimeOutbound") %></td>
        <td><input type="text" id="hourID" value="" name="Hour" size="2" maxlength="2" /></td>
        <td><input type="text" id="minuteID" value="" name="Minute" size="2" maxlength="2" /></td>
    </tr>
</table>
<br />
<br />

</form>
</body>
</html>
