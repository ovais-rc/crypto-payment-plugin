<!--========================================================================== 
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
===========================================================================-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %> 
<%@ page import="com.ibm.commerce.emarketing.beans.*" %>
<%@ page import="com.ibm.commerce.emarketing.commands.EmailActivityConstants" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.exception.ECApplicationException" %>
<%@ page import="com.ibm.commerce.exception.ECSystemException" %>
<%@ page import="com.ibm.commerce.tools.campaigns.CampaignListDataBean" %>
<%@ page import="com.ibm.commerce.tools.campaigns.CampaignDataBean" %>
<%@ page import="com.ibm.commerce.tools.segmentation.SegmentConstants" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.lang.*" %>
<%@ page import="com.ibm.commerce.emarketing.emailtemplate.commands.EmailTemplateConstants"%>

<%@include file="../common/common.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style type='text/css'>
.selectWidth {
	width: 375px;
}
</style>
<%@ include file="EmailActivityCommon.jsp" %>


<title><%= emailActivityRB.get("emailActivityDialogTitle") %></title>
<%
    String emailActivityId = request.getParameter("emailActivityId");
    String campaignId = request.getParameter("campaignId");
    
    String fromPanel = request.getParameter("fromPanel");
    String campaignName = request.getParameter("campaignName");

    boolean emailActivityChange = (emailActivityId.length() > 0);		

    EmailActivityDataBean eadb = null;
    if (emailActivityChange == true) {
   		eadb = new EmailActivityDataBean();
 		eadb.setId(new Integer(emailActivityId));
 		DataBeanManager.activate(eadb, request);
    }
    
    
    
    EmailMessageListDataBean emailMessageListdb = new EmailMessageListDataBean();
    DataBeanManager.activate(emailMessageListdb, request);
    
    EmailMessageDataBean emailMessages[]= null;
    int numberOfEmailMessages = 0;
    emailMessages = emailMessageListdb.getEmailMessageList();
    if (emailMessages != null) {
    	numberOfEmailMessages = emailMessages.length;
    }
    
    CustomerProfileDataBean cpdb = new CustomerProfileDataBean();
    DataBeanManager.activate(cpdb, request);
    
    EmailConfigurationTimeDataBean emailConfigurationTimedb = new EmailConfigurationTimeDataBean();   
    DataBeanManager.activate(emailConfigurationTimedb, request);
    
    
    CampaignListDataBean campaignListdb = new CampaignListDataBean();
   //campaignListdb.setLocalSearch (true);
    DataBeanManager.activate(campaignListdb, request);
    CampaignDataBean campaignDBArray[] = campaignListdb.getCampaignList();
 
    int numOfCampaigns= 0;
    if(campaignDBArray != null){
    	numOfCampaigns=campaignDBArray.length;
    }
 
 %>
<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script src="/wcs/javascript/tools/common/DateUtil.js"></script>

<script language="JavaScript">

<!---- hide script from old browsers
function showEmailActivitySuccessMessage()
{
    <% if (emailActivityChange == false) {                               
    %>
       alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityCreateSuccessConfirmation")) %>");
    <% } else { %>
       alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityModifySuccessConfirmation")) %>"); 
    <% } %>
}

function showCreateEmailActivityErrorMessage()
{
   alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityErrorCreate")) %>");
}

function showChangeEmailActivityErrorMessage()
{
    alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityErrorChange")) %>");
}

function showDuplicateEmailActivityErrorMessage()
{
    alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityDuplicateName")) %>");
}

function loadPanelData()
{
    if (parent.setContentFrameLoaded){
      parent.setContentFrameLoaded(true);
    }
    
	 var templateListState = top.get("templateList");
    <% String minuteStr=null;
       String hourStr=null;
       String replyToPerStore=null;
       String defaultReplyTo=null;
       //At least a member group and a email message template has to be created before creating an email activity
       //Have to configurate the email activity account first in order to create an email activity  
       
       if(emailConfigurationTimedb.getIsConfigured()) { 
              int time= 0;
	      int hour = 0;
	      int minute = 0;
	      int numberOfMinutesPerHour = 60;
	      if(emailConfigurationTimedb.getOutboundTime() !=null){
	        	time =  emailConfigurationTimedb.getOutboundTime().intValue();
	      		hour = time/numberOfMinutesPerHour;
	      	       	minute = time - hour*numberOfMinutesPerHour;
	      }
	      if(hour < 10) {
	                hourStr="0"+String.valueOf(hour);
	      }else{
	                hourStr=String.valueOf(hour);
	      }
	       	       
	      if(minute < 10) {
	                minuteStr = "0"+String.valueOf(minute);
	      }else{
	       	 minuteStr=String.valueOf(minute);
              }
              replyToPerStore = emailConfigurationTimedb.getOutboundReplyTo();
      } else { %>
               
               alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityConfigurationRequired")) %>");
              parent.top.goBack();
    
       <%}  
       
       if(cpdb.getMemberGroupLength() == 0 && !emailActivityChange) { %>      
         alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityCreateCustomerProfile")) %>");
         parent.top.goBack();
     <%} else if (cpdb.getMemberGroupLength() == 0 && emailActivityChange){ %>
         alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("CustomerProfileNoneInChange")) %>");  
         parent.top.goBack();
      <%} else {
        //has the customer profile and message template in database & configured accounts 
        // java.util.Vector memberGroupNames = cpdb.getAllMemberGroupNames();
        // java.util.Vector memberGroupIds = cpdb.getAllMemberGroupIds();
        
         java.util.Vector memberGroups = cpdb.getAllMemberGroups();
         int memberGroupLength = cpdb.getMemberGroupLength(); 
      %>
      <% if ( !fromPanel.equals("campaign")) { %> 
                  document.emailActivityForm.CampaignList.options[0] = 
                                                  new Option("<%= emailActivityRB.get("emailActivityDialogNoCampaigns") %>","", false, false);       
                 	<%for (int i = 0; i<numOfCampaigns; i++){ 
                 			if(campaignDBArray[i].getId().toString().equals(campaignId)){
                 			%>
               				   document.emailActivityForm.CampaignList.options[<%= i +1 %>] = 
                                                  new Option("<%= UIUtil.toJavaScript(campaignDBArray[i].getCampaignName() )%>",
                		                                                  "<%= campaignDBArray[i].getId().toString() %>", true, true);       
                 			
           
                			<%}else{
                			%>
                				  document.emailActivityForm.CampaignList.options[<%= i +1 %>] = 
                                                  new Option("<%= UIUtil.toJavaScript(campaignDBArray[i].getCampaignName() )%>",
                		                                                  "<%= campaignDBArray[i].getId().toString() %>", false, false);       
                
                 
                 <%		    	  }
                 	} 
       }//end of  if (fromPanel.equals("campaign")) 
      %>
      
    <% for (int i = 0; i < memberGroupLength; i++) { 
    %>                   
         document.emailActivityForm.CustomerProfileList.options[<%=i%>] =   
               	new Option("<%= UIUtil.toJavaScript(((CustomerProfileDataBeanEntry)memberGroups.elementAt(i)).getName()) %>",
    		   "<%= UIUtil.toJavaScript(((CustomerProfileDataBeanEntry)memberGroups.elementAt(i)).getID()) %>", false, false);    
		      
    
  <%       }%>
      
    <% for (int i = 0; i < numberOfEmailMessages; i++){
       	  %>
       	     document.emailActivityForm.MessageContentList.options[<%= i %>] = 
                                             new Option("<%= UIUtil.toJavaScript(emailMessages[i].getName() )%>",
           		                                                  "<%= emailMessages[i].getId().toString() %>", false, false);       
    <% } %>
          
     
    <% if (emailActivityChange) {    
             //modify an existing email activity
          %>
                document.emailActivityForm.Name.value = "<%= UIUtil.toJavaScript(eadb.getName()) %>";
                document.emailActivityForm.Description.value = "<%= UIUtil.toJavaScript(eadb.getDescription()) %>";
                
                //select the customer segments
                <%if(eadb.getCustomerProfileExist()){
                %>
                	<% for (int i = 0; i < memberGroupLength; i++){
                		if( ((eadb.getMemberGroupId()).toString()).equals( ((CustomerProfileDataBeanEntry)memberGroups.elementAt(i)).getID()) ){
                	%>
                			document.emailActivityForm.CustomerProfileList.options[<%=i%>].defaultSelected = true;
                			document.emailActivityForm.CustomerProfileList.options[<%=i%>].selected = true;
                	<%	}
                	   }
                	%>
               
                	document.emailActivityForm.SegmentSummary.disabled= false;
		        document.emailActivityForm.SegmentSummary.className = "enabled";
		            
			
                <%}else 
                { //the customer profile associated with this email activity is deleted
                %>
                       alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("CustomerProfileDeletedChange")) %>");  
          	<%}%>
          	 
          	 //select the email template
                <% for (int i = 0; i < numberOfEmailMessages; i++){
		       	  %>       	  
			if(document.emailActivityForm.MessageContentList.options[<%=i%>].value == <%= eadb.getMessageContentId() %>){
				document.emailActivityForm.MessageContentList.options[<%=i%>].selected = true;
				document.emailActivityForm.MessageContentList.options[<%=i%>].defaultSelected = true;
			}
      
                <% } %>
               
                //select the associated campaign
                var campaignCount;
                <% if( !fromPanel.equals("campaign")) {
                        if (eadb.getCampaignId() != null){
                 %>
      		        	<% for (int i = 0; i < numOfCampaigns; i++){
                                        if( (eadb.getCampaignId()).equals(campaignDBArray[i].getId())){
                                 %>  
                                 		  //the index is i+1 because there is an option no campaign at the beginning 
                          			  document.emailActivityForm.CampaignList.options[<%=i+1 %>].selected = true;
                                      		  document.emailActivityForm.CampaignList.options[<%=i+1 %>].defaultSelected = true;
                                      <% }   
               			 }  
                
                	}
                  }//end of if( fromPanel.equals(campaign))
      		%>	                     
		document.emailActivityForm.customReplyTo.value = "<%=UIUtil.toJavaScript(eadb.getReplyTo()) %>";
	
                <% Timestamp deliveryDate =  eadb.getDeliveryDate(); %>
                document.emailActivityForm.YEAR.value =  "<%= TimestampHelper.getYearFromTimestamp(deliveryDate) %>";
                document.emailActivityForm.MONTH.value = "<%= TimestampHelper.getMonthFromTimestamp(deliveryDate) %>";
                document.emailActivityForm.DAY.value = "<%= TimestampHelper.getDayFromTimestamp(deliveryDate) %>";
                
    <% } else {
         //create a new email activity
              Timestamp currentServerTime =  TimestampHelper.getCurrentTime();
	  %>
	  
	  document.emailActivityForm.YEAR.value = "<%=TimestampHelper.getYearFromTimestamp(currentServerTime) %>";
      	  document.emailActivityForm.MONTH.value = "<%=TimestampHelper.getMonthFromTimestamp(currentServerTime) %>";
      	  document.emailActivityForm.DAY.value = "<%=TimestampHelper.getDayFromTimestamp(currentServerTime) %>"; 
      	  
		  // from here -- 3
		  if (templateListState != "readOnly")
		  {
				<% for (int i = 0; i < numberOfEmailMessages; i++){
				  %>
				 document.emailActivityForm.MessageContentList.options[<%= i %>] = 
												new Option("<%= UIUtil.toJavaScript(emailMessages[i].getName() )%>",
																	  "<%= emailMessages[i].getId().toString() %>", false, false);       
			  <% } %>
		  }//templateListstate = "readOnly"
		  else
		  {
			  var templateName = top.get("newTemplateName");
			  var templateMessageId = top.get("newTemplateMessageId");
			  document.emailActivityForm.MessageContentList.options[0] = 
				new Option(templateName,
			   templateMessageId, true, true);
			  top.put("templateList","!readOnly");
			  document.emailActivityForm.MessageContentList.disabled = true;
			  document.emailActivityForm.newEmailTemplate.disabled = true;
		  }
          //till here -- 3
          document.emailActivityForm.customReplyTo.value = "<%=replyToPerStore%>";
     <% }    
     %>
     
     loadSavedData();
	 if(top.get("preSelectTemplateName") == "true")
	 {
		 //select the template created,by clicking on newTemplate button..
		 top.remove("preSelectTemplateName");
		 preSelectTemplateName();
	 }
     document.emailActivityForm.Name.focus();
   <%} %>
	<% if(numberOfEmailMessages == 0) { %>
		//Disable the preview button..
        document.emailActivityForm.previewTemplate.disabled = true;
	<% } else { %>
		  document.emailActivityForm.previewTemplate.disabled = false;
	<% } %>
}

function preSelectTemplateName()
{
   var templateMessageId = top.get("newTemplateMessageId");

    for(var i = 0; i < document.emailActivityForm.MessageContentList.length; i++)
	{
		if(document.emailActivityForm.MessageContentList[i].value
		==  templateMessageId)
		{
			document.emailActivityForm.MessageContentList[i].selected = true;
		}
	}
}
function showButton(){
	document.emailActivityForm.SegmentSummary.disabled = false;
	document.emailActivityForm.SegmentSummary.className = "enabled";
		            
}

function previewEmailTemplate()
{
	var index = document.emailActivityForm.MessageContentList.selectedIndex;
	var messageId = document.emailActivityForm.MessageContentList[index].value;

	//save the data...will be displayed again when user comes to this page..
	top.put("fromPreview", "true");
    saveParameters();

	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=emailactivity.EmailTemplatePreviewDialog"+"&messageId="+messageId+"&previewRequestFrom=EmailActivityDialog";

	top.setContent("<%= UIUtil.toJavaScript((String)emailActivityRB.get("EmailTemplatePreview")) %>", url,true);
}

function createEmailTemplate(){
	top.put("task","A");

	//after creating the template, come back to activity creation page..
	top.saveData("newEmailActivity", "nextView");
	top.put("comingFrom","emailActivityPage");

	parent.addURLParameter("addUpdateFlag","A");
	parent.addURLParameter("nextView","newEmailActivity");

	//save the data...will be displayed again when user comes to this page..
	top.put("fromTemplateCreation", "true");
    saveParameters();

	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=emailactivity.EmailTemplateDialogFromActivity";
	top.setContent("<%= UIUtil.toJavaScript((String)emailActivityRB.get("newEmailTemplate")) %>", url, true);		            
}


//////from here
function loadSavedParameters(){
 	with (document.emailActivityForm) {
     	if (top.get) {
     	        document.emailActivityForm.Name.value = top.get("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_NAME %>", null);
				document.emailActivityForm.Description.value= top.get("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_DESCRIPTION %>", null);
				var messageContentListIndex = top.get("MessageContentListIndex", null);
				if(messageContentListIndex != -1)
				{
					document.emailActivityForm.MessageContentList.options[messageContentListIndex].selected = true;
				}
				var customerProfileIndex =  top.get("CustomerProfileListIndex", null);
				if(customerProfileIndex != -1){
				document.emailActivityForm.CustomerProfileList.options[customerProfileIndex].selected = true;
				document.emailActivityForm.SegmentSummary.disabled = false;
				document.emailActivityForm.SegmentSummary.className = "enabled";
		            
				}
				<% if (! fromPanel.equals("campaign")) { %> 
				document.emailActivityForm.CampaignList.options[top.get("CampaignListIndex", null)].selected = true;
				<% } %>
				document.emailActivityForm.YEAR.value = top.get("<%=EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_YEAR %>", null);
				document.emailActivityForm.MONTH.value = top.get("<%=EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_MONTH %>", null);
				document.emailActivityForm.DAY.value = top.get("<%=EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_DAY %>", null);
				document.emailActivityForm.customReplyTo.value = top.get("<%=EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CUSTOMREPLYTO %>", null);
    	 }	
     }

    top.put("fromTemplateCreation", "false");
}

function saveParameters()
{    
    <% if(emailActivityChange == true){
    %> 
        top.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_EMAILPROMOTIONID %>", "<%=UIUtil.toJavaScript( emailActivityId )%>");    
    <% } %>
    top.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_NAME %>", document.emailActivityForm.Name.value);
    top.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_DESCRIPTION %>", document.emailActivityForm.Description.value);  
    
    top.put("MessageContentListIndex",  document.emailActivityForm.MessageContentList.selectedIndex);
	if(document.emailActivityForm.MessageContentList.selectedIndex != -1) {
    top.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_EMAILMESSAGEID %>", document.emailActivityForm.MessageContentList.options[document.emailActivityForm.MessageContentList.selectedIndex].value);
   	}
   	top.put("CustomerProfileListIndex",  document.emailActivityForm.CustomerProfileList.selectedIndex);
   	if (document.emailActivityForm.CustomerProfileList.selectedIndex != -1){
    	top.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_MEMBERGROUPID %>",document.emailActivityForm.CustomerProfileList.options[document.emailActivityForm.CustomerProfileList.selectedIndex].value );
   	}
   	
   	<% if (!fromPanel.equals("campaign")) { %> 
   	top.put("CampaignListIndex",  document.emailActivityForm.CampaignList.selectedIndex);
   	top.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CAMPAIGNID%>",document.emailActivityForm.CampaignList.options[document.emailActivityForm.CampaignList.selectedIndex].value );
        <% } else { %>
        top.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CAMPAIGNID%>", "");
        <%} %>
    top.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_YEAR %>", emailActivityForm.YEAR.value);
    top.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_MONTH%>",emailActivityForm.MONTH.value);
    top.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_DAY%>", emailActivityForm.DAY.value);   
    top.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_HOUR%>", "12");   
    top.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_MINUTE%>", "12");   
    top.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_REPLYTOCHECKBOX%>", "true");   
    top.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CUSTOMREPLYTO%>", trim(emailActivityForm.customReplyTo.value));   
}
//till here
function segmentSummary () {
	var segmentId = document.emailActivityForm.CustomerProfileList.options[document.emailActivityForm.CustomerProfileList.selectedIndex].value;
		
	if(segmentId != ""){
		
		var url = "<%= SegmentConstants.URL_SEGMENT_DETAILS_DIALOG_VIEW %>" + segmentId;
		parent.put("fromSegmentSummary", "true");
        	passParameters();
        	top.saveModel(parent.model);
        
		top.setContent("<%= UIUtil.toJavaScript((String)emailActivityRB.get("segmentSummaryDialogTitle")) %>", url, true);
		}
		
}

function loadSavedData(){
 	with (document.emailActivityForm) {     
     	if (parent.get) {
     	    var fromSummary = parent.get("fromSegmentSummary", null);
     	    if(fromSummary == "true"){
     	        document.emailActivityForm.Name.value = parent.get("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_NAME %>", null);
				document.emailActivityForm.Description.value= parent.get("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_DESCRIPTION %>", null);
				document.emailActivityForm.MessageContentList.options[parent.get("MessageContentListIndex", null)].selected = true;
				
				var customerProfileIndex =  parent.get("CustomerProfileListIndex", null);
				if(customerProfileIndex != -1){
				document.emailActivityForm.CustomerProfileList.options[customerProfileIndex].selected = true;
				document.emailActivityForm.SegmentSummary.disabled = false;
				document.emailActivityForm.SegmentSummary.className = "enabled";
		            
				}
				<% if (! fromPanel.equals("campaign")) { %> 
				document.emailActivityForm.CampaignList.options[parent.get("CampaignListIndex", null)].selected = true;
				<% } %>
				document.emailActivityForm.YEAR.value = parent.get("<%=EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_YEAR %>", null);
				document.emailActivityForm.MONTH.value = parent.get("<%=EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_MONTH %>", null);
				document.emailActivityForm.DAY.value = parent.get("<%=EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_DAY %>", null);
				document.emailActivityForm.customReplyTo.value = parent.get("<%=EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CUSTOMREPLYTO %>", null);
	
			}
			
			
    	 }	
     }

    parent.put("fromCampaignSummary", "false");

    var fromTemplate = top.get("fromTemplateCreation", null);
    if(fromTemplate == "true" || top.get("fromPreview",null) == "true")
	{
		loadSavedParameters();
		top.put("fromTemplateCreation", "false");
		top.put("fromPreview","false");
	}
}

function shouldGoBack()
{ 
   if(! confirmDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityCancelConfirmation")) %>")){
         return false;
   }
   return true;
}

function validatePanelData()
{
	with (document.emailActivityForm) {
                if (!Name.value) {
			alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityNameRequired")) %>");
			Name.focus();
			return false;
		}
		if (!isValidUTF8length(Name.value, 254)) {
			alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityNameTooLong")) %>");
			Name.select();
			Name.focus();
			return false;
		}
		if (!isValidUTF8length(Description.value, 254)) {
			alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityDescriptionTooLong")) %>");
			Description.select();
			Description.focus();
			return false;
		}	
		if( document.emailActivityForm.CustomerProfileList.selectedIndex == -1){
			alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityCustomerProfileNotSelected")) %>");
			CustomerProfileList.focus();
			return false;
		
		}

		if( document.emailActivityForm.MessageContentList.selectedIndex == -1){
			alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityTemplateNotSelected")) %>");
			newEmailTemplate.focus();
			return false;
		}
	
		 	if (!customReplyTo.value) {        
		 		alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityReplyToRequired")) %>");
		 		customReplyTo.focus();
		 		return false;
			}
			
			var customReplyToAfterTrim = trim(customReplyTo.value);
			if (!isValidUTF8length(customReplyToAfterTrim, 256)) {
				alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityReplyToTooLong")) %>");
				customReplyTo.focus();
				return false;
			}
			
			var objRegex1 =/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})$/i;	//matchs aaa12@bbb23
			var objRegex2 = /^<\s*([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})\s*>$/i;	//matchs < aaa12@bbb23 >
			var objRegex3 = /^".*"\s*<\s*([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})\s*>$/i; //matchs "abcd_23 ase"  <aaa12@bbb23>
		
			if( !objRegex1.test(customReplyToAfterTrim) && !objRegex2.test(customReplyToAfterTrim) && !objRegex3.test(customReplyToAfterTrim)){
			        alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityReplyToBadFormat")) %>");
			     	customReplyTo.focus();
				return false;
			}
		
		    var vd = validDate(document.emailActivityForm.YEAR.value, document.emailActivityForm.MONTH.value, document.emailActivityForm.DAY.value);		
	        if(!vd){
                        alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityInvalidDate")) %>");
		        return false;
	        }  
	       
	        //To validate the send date is later than current server time
	        <% Timestamp currentTime =  TimestampHelper.getCurrentTime(); %>
	        var endTime = "<%=hourStr%>" + ":" + <%=minuteStr %>;
	        var vStartTime = validateStartEndDateTime("<%=TimestampHelper.getYearFromTimestamp(currentTime) %>","<%=TimestampHelper.getMonthFromTimestamp(currentTime) %>","<%=TimestampHelper.getDayFromTimestamp(currentTime) %>",YEAR.value, MONTH.value, DAY.value,"<%=TimestampHelper.getTimeFromTimestamp(currentTime)%>", endTime);	        					  
                if(vStartTime != true){
                        alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityErrorDeliveryTime")) %>");
						 return false;
    	        }
	}
        return true;
}

function passParameters()
{    
    <% if(emailActivityChange == true){
    %> 
        parent.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_EMAILPROMOTIONID %>", "<%=UIUtil.toJavaScript( emailActivityId )%>");    
    <% } %>
    parent.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_NAME %>", document.emailActivityForm.Name.value);
    parent.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_DESCRIPTION %>", document.emailActivityForm.Description.value);  
    
    parent.put("MessageContentListIndex",  document.emailActivityForm.MessageContentList.selectedIndex);
    parent.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_EMAILMESSAGEID %>", document.emailActivityForm.MessageContentList.options[document.emailActivityForm.MessageContentList.selectedIndex].value);
   	
   	parent.put("CustomerProfileListIndex",  document.emailActivityForm.CustomerProfileList.selectedIndex);
   	if (document.emailActivityForm.CustomerProfileList.selectedIndex != -1){
    	parent.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_MEMBERGROUPID %>",document.emailActivityForm.CustomerProfileList.options[document.emailActivityForm.CustomerProfileList.selectedIndex].value );
   	}
   	
   	<% if (!fromPanel.equals("campaign")) { %> 
   	parent.put("CampaignListIndex",  document.emailActivityForm.CampaignList.selectedIndex);
   	parent.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CAMPAIGNID%>",document.emailActivityForm.CampaignList.options[document.emailActivityForm.CampaignList.selectedIndex].value );
        <% } else { %>
        parent.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CAMPAIGNID%>", "");
        <%} %>
    parent.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_YEAR %>", emailActivityForm.YEAR.value);
    parent.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_MONTH%>",emailActivityForm.MONTH.value);
    parent.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_DAY%>", emailActivityForm.DAY.value);   
    parent.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_HOUR%>", "<%=hourStr %>");   
    parent.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_MINUTE%>", "<%=minuteStr %>");   
    parent.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_REPLYTOCHECKBOX%>", "true");   
    parent.put("<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_CUSTOMREPLYTO%>", trim(emailActivityForm.customReplyTo.value));   
}


function savePanelData()
{
	var afterCreationGoTo = top.get("afterCreationGoTo");
	if(afterCreationGoTo != null && afterCreationGoTo != "")
	{
		parent.addURLParameter("afterCreationGoTo",afterCreationGoTo);
	}
	else
	{
		parent.addURLParameter("afterCreationGoTo","emailActivityListPage");
	}
}

function setupDate() 
{
    window.yearField = document.emailActivityForm.YEAR;
    window.monthField = document.emailActivityForm.MONTH;
    window.dayField = document.emailActivityForm.DAY;
} 

//-->
</script>

<meta name="GENERATOR" content="IBM WebSphere Studio" />
</head>

<body onload="loadPanelData()" class="content">
<script for="document" event="onclick()">
document.all.CalFrame.style.display="none";
</script>

<script>
document.writeln('<iframe name="calendar" title="' + top.calendarTitle + '" style="display:none;position:absolute;width:198;height:230;z-index=100" ID="CalFrame" marginheight=0 marginwidth=0 noresize frameborder=0 scrolling=no src="/webapp/wcs/tools/servlet/Calendar"></iframe>');
</script>

<h1><% if (emailActivityChange == false) { %> <%= emailActivityRB.get("emailActivityDialogNewTitle") %> <% } else { %> <%= emailActivityRB.get("emailActivityDialogChangeTitle") %> <% } %></h1>

<form name="emailActivityForm">

<p><label for="nameID"><%= emailActivityRB.get("emailActivityDialogNameInput") %></label><br />
<input name="Name" id="nameID" type="text" size="50" maxlength="254" /> <br />
<br />

<label for="descriptionID"><%= emailActivityRB.get("emailActivityDialogDescriptionLabel") %></label> <br />
<textarea name="Description" id="descriptionID" rows="4" cols="50" wrap="physical" onkeydown="limitTextArea(this.form.Description, 254);" onkeyup="limitTextArea(this.form.Description, 254);"></textarea> <br />
<br />

<label for="campaignID">
<%= emailActivityRB.get("emailActivityDialogCampaign") %></label><br />
<% if (fromPanel.equals("campaign")) { %> 
<i><%=UIUtil.toHTML( campaignName )%></i>
<%} else {%>   
<select name="CampaignList" id="campaignID" single="SINGLE">
</select>
<%} %>

<br /><br />
<label for="customerSegmentID"><%= emailActivityRB.get("emailActivityDialogCustomerProfileList") %> </label><br />
<table name="segmentTable" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<select name="CustomerProfileList" id="customerSegmentID" class='selectWidth' size='5' single ="SINGLE"onchange="showButton()">
			</select>
		</td>
		<td valign="top" >
			<button type="button" name="SegmentSummary" value="segmentSummary" class="disabled"  onclick="segmentSummary()" disabled="true"><%= emailActivityRB.get("emailActivityDialogSegmentSummary") %></button>						
		</td> 
	</tr>	
</table>
<br />

<label for="messageListID"><%= emailActivityRB.get("emailActivityDialogMessageContentList") %></label><br />
<table name="templateTable" border="0" cellpadding="0" cellspacing="0">
<tr>
<td>
<select name="MessageContentList" id="messageListID" single="SINGLE">
</select> <br />
</td>
       	<td valign="top" >
			<button name="previewTemplate" value="previewTemplate" onclick="javascript:previewEmailTemplate()" class="general"><%= emailActivityRB.get("EmailTemplatePreview") %></button>		
		</td>

       	<td valign="top" >
			<button name="newEmailTemplate" value="newEmailTemplate" onclick="javascript:createEmailTemplate()" class="general"><%= emailActivityRB.get("newEmailTemplate") %></button>			
		</td> 
	</tr>	
</table>
<br />
<br />

<% if(emailActivityChange) { %>
<%= emailActivityRB.get("emailActivityDialogCurrentTime") %>
<%=TimestampHelper.getDateTimeFromTimestamp(eadb.getDeliveryDate(), jLocale) %>
<br /><br />
<% } %>

 <% if(emailActivityChange) { %>
       <%= emailActivityRB.get("emailActivityDialogChangeTo") %>
 <% } else { %>
       <%= emailActivityRB.get("emailActivityDialogDeliveryOn") %>
 <% } %>
<br />

<table name="dateTable" border="0" cellpadding="0" cellspacing="0" >
     <tr>
        <td><label for="yearID"><%= emailActivityRB.get("emailActivityDialogYear") %></label></td>
        <td><label for="monthID"><%= emailActivityRB.get("emailActivityDialogMonth") %></label></td>
        <td><label for="dayID"><%= emailActivityRB.get("emailActivityDialogDay") %></label></td>
        <td></td>
        <td></td>
        <td></td>
     </tr>
     <tr>
        <td><input type="text" id="yearID" value="" name="YEAR" size="4" maxlength="4" /></td>
        <td><input type="text" id="monthID" value="" name="MONTH" size="2" maxlength="2" /></td>
        <td><input type="text" id="dayID" value="" name="DAY" size="2" maxlength="2" /></td>
        <td><a href="javascript:setupDate();showCalendar(document.emailActivityForm.calImg1)"><img src="/wcs/images/tools/calendar/calendar.gif" border="0" alt='<%=UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityCalendarText"))%>' id="calImg1" /></a></td>
        <td><%= emailActivityRB.get("emailActivityDialogHour") %></td>
        <td><%=hourStr%>:<%=minuteStr %></td>
    </tr>
    </table>
<br />

<label for="replyToID"><%= emailActivityRB.get("emailActivityDialogDefineReplyTo") %></label><br />
<input name="customReplyTo" id="replyToID" type="text" size="50" maxlength="256" />
<br />
        </form>
</body>
</html>
