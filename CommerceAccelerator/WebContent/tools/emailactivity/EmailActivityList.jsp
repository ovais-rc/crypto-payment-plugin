<!-- ========================================================================
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
 * deposited with the US Copyright Office
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
=========================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.server.ConfigProperties" %>
<%@ page import="com.ibm.commerce.server.ServerConfiguration" %>
<%@ page import="com.ibm.commerce.emarketing.beans.EmailActivityListEntry" %>
<%@ page import="com.ibm.commerce.emarketing.beans.EmailActivityListDataBean" %>
<%@ page import="com.ibm.commerce.emarketing.commands.*" %>
<%@ page import="com.ibm.commerce.tools.campaigns.CampaignConstants" %>
<%@ page import="com.ibm.commerce.tools.campaigns.CampaignDataBean" %>
<%@ page import="com.ibm.commerce.tools.campaigns.CampaignListDataBean" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.tools.xml.XMLUtil" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="com.ibm.commerce.emarketing.emailtemplate.commands.EmailTemplateConstants"%>

<%@ include file="EmailActivityCommon.jsp" %>
<%
	String orderByParm = request.getParameter("orderby");
	String viewType = request.getParameter("viewType");

	String campaignId = request.getParameter("campaignId");

	EmailActivityListDataBean emailActivityList = new EmailActivityListDataBean();
	emailActivityList.setCampaignIdStr(campaignId);
	DataBeanManager.activate(emailActivityList, request);

	EmailActivityListEntry emailActivities[] = null;
	int numberOfEmailActivities = 0;

	emailActivities = emailActivityList.getEmailActivityList();
	if (emailActivities != null) {
		numberOfEmailActivities = emailActivities.length;
	}

	String status = null;

	CampaignListDataBean campaignList = new CampaignListDataBean();
	//campaignList.setLocalSearch(true);
	DataBeanManager.activate(campaignList, request);

	CampaignDataBean campaigns[] = campaignList.getCampaignList();
	int numberOfCampaigns = 0;

	if (campaigns != null) {
		numberOfCampaigns = campaigns.length;
	}

	DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.SHORT, jLocale);

%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%	Hashtable campaignsRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("campaigns.campaignsRB", emailActivityCommandContext.getLocale()); %>
<title><%= emailActivityRB.get("emailActivityListTitle") %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript">

<!---- hide script from old browsers
function newEmailActivity() {

    var campaignId = getSelectValue(document.emailActivityForm.initiativeCampaign);
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=emailactivity.EmailActivityDialogAdd&campaignId="+ campaignId;
	if (top.setContent) {
	    top.setContent("<%= UIUtil.toJavaScript((String)emailActivityRB.get("createEmailActivity")) %>", url, true);
	}
	else {
        parent.location.replace(url);
	}
}

function manageEmailTemplates()
{
	var url = "<%= UIUtil.getWebappPath(request) %>NewDynamicListView?ActionXMLFile=emailactivity.EmailTemplateList&amp;cmd=EmailTemplateListView&amp;orderby=name";
	top.put("emailTemplateListBCT","<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailTemplates")) %>");
	if (top.setContent) {
	    top.setContent("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailTemplates")) %>", url, true);
	}
	else {
        parent.location.replace(url);
	}
}

function changeEmailActivity () {

	var emailActivityId = -1;
	if (arguments.length > 0) {
		emailActivityId = arguments[0];
	}
	else {
		var checked = parent.getChecked();
		if (checked.length > 0) {
			emailActivityId = checked[0];
		}
	}
	if (emailActivityId != -1) {
	    var status = getStatusFromList(emailActivityId);
	    
	    var isCreatedInThisStore = isCreatedInTheCurrentStoreFlag(status);
	    var emailStatus = status.substring(0, status.indexOf("|"));
    
	    if (isCreatedInThisStore == "N"){
	        alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityChangeNotAllowedStore")) %>");
	        
	    }else{
	    
       	    	if(emailStatus == 1){
            	     alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityChangeNotAllowed")) %>");
            	}else{
	
			if (top.setContent) {
				top.setContent("<%= UIUtil.toJavaScript((String)emailActivityRB.get("changeEmailActivity")) %>", "/webapp/wcs/tools/servlet/DialogView?XMLFile=emailactivity.EmailActivityDialogChange&emailActivityId=" + emailActivityId, true);
			}
			else {
				parent.location.replace("/webapp/wcs/tools/servlet/DialogView?XMLFile=emailactivity.EmailActivityDialogChange&emailActivityId=" + emailActivityId);
			}
	    	}
	    }//end of if (isCreatedInThisStore == "N")
	}
}

function changeEmailActivityFromName(emailActivityId, emailActivityStatus){

     if(emailActivityStatus != 0){
	     alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityChangeNotAllowed")) %>");
	}else{
	       if (top.setContent) {
				top.setContent("<%= UIUtil.toJavaScript((String)emailActivityRB.get("changeEmailActivity")) %>", "/webapp/wcs/tools/servlet/DialogView?XMLFile=emailactivity.EmailActivityDialogChange&emailActivityId=" + emailActivityId, true);
	       }
		   else {
				parent.location.replace("/webapp/wcs/tools/servlet/DialogView?XMLFile=emailactivity.EmailActivityDialogChange&emailActivityId=" + emailActivityId);
			}
	}
}

function getEmailActivitySummary(){
	var emailActivityId = -1;
	if (arguments.length > 0) {
		emailActivityId = arguments[0];
	}
	else {
		var checked = parent.getChecked();
		if (checked.length > 0) {
			emailActivityId = checked[0];
		}
	}
	if (emailActivityId != -1) {

	    var status = getStatusFromList(emailActivityId);
	    var isCreatedInThisStore = isCreatedInTheCurrentStoreFlag(status);
	    
	    if (isCreatedInThisStore == "N"){
	    	        alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivitySummaryNotAllowedStore")) %>");
	    	        
	    }else{

		if (top.setContent) {
			top.setContent("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivitySummary")) %>", "/webapp/wcs/tools/servlet/DialogView?XMLFile=emailactivity.EmailActivitySummaryDialog&emailActivityId=" + emailActivityId, true);
		}
		else {
			parent.location.replace("/webapp/wcs/tools/servlet/DialogView?XMLFile=emailactivity.EmailActivitySummaryDialog&emailActivityId=" + emailActivityId);
		}
	    }

	}
}

function deleteEmailActivity () {
	var checked = parent.getChecked();
	var campaignId = getSelectValue(document.emailActivityForm.initiativeCampaign);
	var viewType = getSelectValue(document.emailActivityForm.initiativeType);
	if (checked.length > 0) {
		var isDeletable = true;
		
		for (var j=0; j<checked.length; j++){
			var eaId = checked[j];
			var status = getStatusFromList(eaId);

			var isCreatedInThisStore = isCreatedInTheCurrentStoreFlag(status);
			if (isCreatedInThisStore == "N"){
				isDeletable = false;
			}
		}
		
		if(!isDeletable){
			  alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityDeleteNotAllowedStore")) %>");
	    	       
		}else{
			if (confirmDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivityListDeleteConfirmation")) %>")) {
				var emailActivityId = checked[0];
				var url = "/webapp/wcs/tools/servlet/EmailActivityDelete?" + "<%= EmailActivityConstants.PARAMETER_EMAIL_ACTIVITY_IDS %>" + "=" + emailActivityId;
				for (var i=1; i<checked.length; i++) {
					emailActivityId = checked[i];
					url += "," + emailActivityId;
				}
				url += "&viewType=" + viewType + "&campaignId=" + campaignId;
				parent.location.replace(url);
			}
		}
	}
}

function getResultsSize () {
	return <%= numberOfEmailActivities %>;
}

function getSelectValue (select) {
	return select.options[select.selectedIndex].value;
}

function loadSelectValue (select, value) {
	for (var i=0; i < select.length; i++) {
		if (select.options[i].value == value) {
			select.options[i].selected = true;
			return;
		}
	}
}

function changeListView () {
	var viewType = getSelectValue(document.emailActivityForm.initiativeType);
	var campaignId = getSelectValue(document.emailActivityForm.initiativeCampaign);

	if (viewType == "<%= CampaignConstants.INITIATIVE_LIST_WEB_VIEW %>") {
		var url = "/webapp/wcs/tools/servlet/CampaignInitiativesView?ActionXMLFile=campaigns.InitiativeList&cmd=CampaignInitiativeListView&orderby=name&viewType=" + viewType + "&campaignId=" + campaignId;
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeListTitle")) %>", url, false);
	}
	else if (viewType == "<%= CampaignConstants.INITIATIVE_LIST_EMAIL_VIEW %>") {
		var url = "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=emailactivity.EmailActivityList&cmd=EmailActivityListView&orderby=name&viewType=" + viewType + "&campaignId=" + campaignId;
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeListTitle")) %>", url, false);
	}
}

function onLoad() {
	loadSelectValue(document.emailActivityForm.initiativeType, "<%=UIUtil.toJavaScript( viewType )%>");
	loadSelectValue(document.emailActivityForm.initiativeCampaign, "<%=UIUtil.toJavaScript( campaignId )%>");

	parent.loadFrames();
}

function isCreatedInTheCurrentStoreFlag(status){
	return status.substring(status.indexOf("|") + 1, status.length);
}

function getStatusFromList(emailActivityId){
	var status; 
	for(var i=0; i<document.emailActivityForm.elements.length; i++){
	          var e=  document.emailActivityForm.elements[i];
	          if(e.type =='checkbox'){
	                 if(e.name == emailActivityId){
	                      status = e.value;
	                 }
	          }

	}
	return status;
}
//-->
</script>
<meta name="GENERATOR" content="IBM WebSphere Studio" />
</head>

<body onload="onLoad()" class="content_list">

<%
	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;
	int rowselect = 1;
	int totalsize = numberOfEmailActivities;
	int totalpage = totalsize/listSize;
%>
<%= comm.addControlPanel("emailactivity.EmailActivityList", totalpage, totalsize, jLocale) %>
<form name="emailActivityForm">
<table border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<label for="initiativeTypeID"><%= campaignsRB.get("initiativeListTypeView") %></label><br/>
			<select name="initiativeType" id="initiativeTypeID" onchange="changeListView()">
				<option value="<%= CampaignConstants.INITIATIVE_LIST_WEB_VIEW %>"><%= campaignsRB.get(CampaignConstants.INITIATIVE_LIST_WEB_VIEW) %></option>
				<option value="<%= CampaignConstants.INITIATIVE_LIST_EMAIL_VIEW %>"><%= campaignsRB.get(CampaignConstants.INITIATIVE_LIST_EMAIL_VIEW) %></option>
			</select>
		</td>
		<td width="20">&nbsp;</td>
		<td>
			<label for="initiativeCampaignID"><%= campaignsRB.get("initiativeListCampaignView") %></label><br/>
			<select name="initiativeCampaign" id="initiativeCampaignID" onchange="changeListView()">
				<option value=""><%= campaignsRB.get(CampaignConstants.MSG_ALL_CAMPAIGN) %></option>
<%	for (int i=0; i<numberOfCampaigns; i++) { %>
				<option value="<%= campaigns[i].getId() %>"><%= UIUtil.toHTML(campaigns[i].getCampaignName()) %></option>
<%	} %>
			</select>
		</td>
	</tr>
</table>
<br />

<%= comm.startDlistTable((String)emailActivityRB.get("emailAcitivtyListSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>

<%= comm.addDlistColumnHeading((String)emailActivityRB.get("emailActivityListName"), EmailActivityConstants.ORDER_BY_NAME, orderByParm.equals(EmailActivityConstants.ORDER_BY_NAME)) %>
<%= comm.addDlistColumnHeading((String)emailActivityRB.get("emailActivityListDescription"), EmailActivityConstants.ORDER_BY_DESCRIPTION, orderByParm.equals(EmailActivityConstants.ORDER_BY_DESCRIPTION)) %>
<%= comm.addDlistColumnHeading((String)emailActivityRB.get("emailActivityListCustomerSegment"), EmailActivityConstants.ORDER_BY_CUSTOMERSEGMENTNAME, orderByParm.equals(EmailActivityConstants.ORDER_BY_CUSTOMERSEGMENTNAME)) %>
<%= comm.addDlistColumnHeading((String)emailActivityRB.get("emailActivityListSendDate"), EmailActivityConstants.ORDER_BY_SENDDATE, orderByParm.equals(EmailActivityConstants.ORDER_BY_SENDDATE)) %>
<%= comm.addDlistColumnHeading((String)emailActivityRB.get("emailActivityListCampaign"), EmailActivityConstants.ORDER_BY_CAMPAIGNNAME, orderByParm.equals(EmailActivityConstants.ORDER_BY_CAMPAIGNNAME)) %>
<%= comm.addDlistColumnHeading((String)emailActivityRB.get("emailActivityListStatus"), EmailActivityConstants.ORDER_BY_STATUS, orderByParm.equals(EmailActivityConstants.ORDER_BY_STATUS)) %>

<%= comm.endDlistRowHeading() %>

<%
	if (endIndex > numberOfEmailActivities) {
		endIndex = numberOfEmailActivities;
	}

	EmailActivityListEntry emailActivityListEntry;
	int indexFrom = startIndex;
	for (int i=indexFrom; i<endIndex; i++) {
		emailActivityListEntry = emailActivities[i];
%>
<%= comm.startDlistRow(rowselect) %>
   
   <% if(emailActivityListEntry.getStoreId().equals(emailActivityCommandContext.getStoreId().toString())) { 
   	//the e-mail belongs to the store which the user is logged in. 
   %>
   	<%= comm.addDlistCheck(emailActivityListEntry.getId().toString(), "none", UIUtil.toHTML( emailActivityListEntry.getStatus().toString()) + "|Y") %>
   	<%= comm.addDlistColumn(UIUtil.toHTML(emailActivityListEntry.getName()), "javascript:changeEmailActivityFromName(" + emailActivityListEntry.getId() + "," + emailActivityListEntry.getStatus() + ")") %>
   
   <%} else { 
   %>   	
   	<%= comm.addDlistCheck(emailActivityListEntry.getId().toString(), "none", UIUtil.toHTML( emailActivityListEntry.getStatus().toString()) + "|N") %>
   	<%= comm.addDlistColumn(UIUtil.toHTML(emailActivityListEntry.getName()), "none") %>
   
   <%}%>   
   <%= comm.addDlistColumn(UIUtil.toHTML(emailActivityListEntry.getDescription() ), "none") %>
   <%= comm.addDlistColumn(UIUtil.toHTML(emailActivityListEntry.getCustomerSegmentName() ), "none") %>
   <%= comm.addDlistColumn(dateFormat.format(new Date(emailActivityListEntry.getSendDate().getTime())), "none") %>
   <%= comm.addDlistColumn(UIUtil.toHTML(emailActivityListEntry.getCampaignName() ), "none") %>
   <%  status= emailActivityListEntry.getStatusString(); %>
   <%= comm.addDlistColumn((String)emailActivityRB.get(status), "none") %>

 <%= comm.endDlistRow() %>
   <%
		if (rowselect == 1) {
			rowselect = 2;
		}
		else {
			rowselect = 1;
		}
	}
%>
<%= comm.endDlistTable() %>
<%	if (numberOfEmailActivities== 0) { %>
<p>
</p><p><%= emailActivityRB.get("emailActivityListEmpty") %>
<%	} %>
</p></form>

<script>
<!--
parent.afterLoads();
parent.setResultssize(getResultsSize());
parent.setButtonPos("0px", "54px");
//-->
</script>

</body>

</html>
