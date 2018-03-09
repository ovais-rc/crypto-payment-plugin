<!-- 
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2005
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//----------------------------------------------------------------------
//
////////////////////////////////////////////////////////////////////////////////
=========================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
	import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.emarketing.utils.EmailTemplateUtil,
com.ibm.commerce.emarketing.emailtemplate.databeans.EmailTemplateListDataBean,
	com.ibm.commerce.tools.common.ui.taglibs.*,
	com.ibm.commerce.emarketing.utils.EmailTemplateRow,
	com.ibm.commerce.emarketing.emailtemplate.commands.EmailTemplateConstants"
	%>

<%@ include file="../campaigns/common.jsp" %>
<%@ include file="EmailActivityCommon.jsp" %>

<%
	String orderByParm = request.getParameter(EmailTemplateConstants.PARAMETER_ORDER_BY);
	if(orderByParm == null || orderByParm.length() == 0) {
		orderByParm = "name";
	}

	EmailTemplateListDataBean emailTemplateList = new EmailTemplateListDataBean();
	DataBeanManager.activate(emailTemplateList,request);
    EmailTemplateRow[] emailTemplateListRows = 	emailTemplateList.getEmailTemplateListRows();
	int numberOfTemplates = 0;

	if(emailTemplateListRows != null)
	{
		numberOfTemplates = emailTemplateListRows.length;
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= emailActivityRB.get("emailTemplatesTitle") %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">

<!-- hide script from old browsers

function mySubmitFinishHandler()
{
	var submitErrorStatus = "<%=UIUtil.toJavaScript( request.getParameter("SubmitErrorStatus") )%>";
	if(submitErrorStatus == "true")
	{
		//error occured in controller command..check if its related to invalid deletions.
		var invalidDeletions = "<%=UIUtil.toJavaScript( request.getParameter("invalidDeletions") )%>";
		if(invalidDeletions == "true") {
			//Get invalid deletion list and display it to user..
			var title = "<%= emailActivityRB.get("deleteActiveTemplatesError") %>";
		    var list = "<%=UIUtil.toJavaScript( request.getParameter("invalidDeletionsList") )%>";
			alertDialog(title+ ": "+ list);
		}
	}
}


function newEmailTemplate() {
	top.put("task","A");
	top.put("finishButton","true");
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=emailactivity.EmailTemplateDialog";
	top.setContent("<%= UIUtil.toJavaScript((String)emailActivityRB.get("newEmailTemplate")) %>", url, true);
}

function changeEmailTemplate() {
	top.put("task","U");
	var messageId = parent.getChecked();
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=emailactivity.EmailTemplateDialog"+"&messageId="+messageId;
	top.setContent("<%= UIUtil.toJavaScript((String)emailActivityRB.get("changeEmailTemplate")) %>", url, true);
}

function changeEmailTemplateFromName(emailTemplateId){

	top.put("task","U");
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=emailactivity.EmailTemplateDialog"+"&messageId="+emailTemplateId;

   if (top.setContent){
		top.setContent("<%= UIUtil.toJavaScript((String)emailActivityRB.get("changeEmailTemplate")) %>", url, true);
   }
   else{
		parent.location.replace("/webapp/wcs/tools/servlet/DialogView?XMLFile=emailactivity.EmailTemplateDialog"+"&messageId="+emailTemplateId);
   }
}

function duplicateEmailActivity(){
	top.put("task","D");
	var messageId = parent.getChecked();
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=emailactivity.EmailTemplateDialog"+"&messageId="+messageId;
	top.setContent("<%= UIUtil.toJavaScript((String)emailActivityRB.get("copyEmailTemplate")) %>", url, true);
}

function previewEmailTemplate()
{
	var messageId = parent.getChecked();
	var templateType;
	var formName = "manageEmailTemplateListForm";
	//form filled type..
	templateType = "0";
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=emailactivity.EmailTemplatePreviewDialog"+"&messageId="+messageId+"&templateType="+templateType;
	top.setContent("<%= UIUtil.toJavaScript((String)emailActivityRB.get("EmailTemplatePreview")) %>", url,true);
}

function deleteEmailTemplate()
{
	var selectedMessageIds = parent.getSelected();
	var relatedTemplateNames = getTemplatesNamesByStoreType("RS");
	var currentStoreTemplateIDs = getTemplatesIDByStoreType("CS");
	if(relatedTemplateNames != '')
	{
		//Display message saying that Related store templates cannot be deleted
		parent.alertDialog('<%= UIUtil.toJavaScript(emailActivityRB.get("relatedStoreTemplateDeletion"))%>'+ "-- "+ relatedTemplateNames);
	}

    var	orderByParm = "<%=UIUtil.toJavaScript( orderByParm)%>";
	if (currentStoreTemplateIDs != '')
	{
		//continue deleting the current store templates...
		var url = "<%= UIUtil.getWebappPath(request) %>EmailTemplateDeleteCtrlCmd?messageIds=" + currentStoreTemplateIDs+"&amp;orderby="+orderByParm;
		if (confirmDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("deleteEmailTemplateConfirmation")) %>"))
		{
			parent.location.replace(url);
		}
	}
}



function getTemplatesNamesByStoreType(storeType)
{
	var selectedTemplates = parent.getChecked();
	//This is the form name defined in XML File - EmailTemplateList.xml
	var formName = "manageEmailTemplateListForm";
	var templateNames = '';
	for(var i = 0; i < selectedTemplates.length; i++)
	{
		var storeTypeField = "TS_"+selectedTemplates[i];
		var val = eval(formName + "." + storeTypeField + ".value");
		if(storeType == val) 
		{
			var templateNameField = "TN_"+selectedTemplates[i];
			var templateName=eval(formName + "." + templateNameField +".value");

			if(templateNames != '')	{
				templateNames = templateNames + ", " + templateName;
			}
			else {
				templateNames = templateName;
			}
		}
	}
	 return templateNames;
}

function getTemplatesIDByStoreType(storeType)
{
	var selectedTemplates = parent.getChecked();
	//This is the form name defined in XML File - EmailTemplateList.xml
	var formName = "manageEmailTemplateListForm";
	var templateIDs = '';
	for(var i = 0; i < selectedTemplates.length; i++)
	{
		var storeTypeField = "TS_"+selectedTemplates[i];
		var val = eval(formName + "." + storeTypeField + ".value");
		if(storeType == val) 
		{
			var templateID = selectedTemplates[i];

			if(templateIDs != '')	{
				templateIDs = templateIDs + "," + templateID;
			}
			else {
				templateIDs = templateID;
			}
		}
	}
	 return templateIDs;
}



function enableDisableButtons()
{
	parent.setChecked();
	var checkedTemplates = parent.getChecked();
	var i = checkedTemplates.length;
	//if user selects more than one template, change/copy button
	//will be disabled by default...Need to take care of situation
	//where user selects only one template...
	if(i == 1)
	{
		var checkBoxName = checkedTemplates[0];
		var formName = "manageEmailTemplateListForm";
		//get the value of corresponding hidden variable..
		var templateStoreType = eval(formName + "." +"TS_"+checkBoxName+".value");
		if(templateStoreType == "CS")
		{
			//template belongs to Current Store
			parent.AdjustRefreshButton(parent.buttons.buttonForm.changeButton,'enabled');
			parent.AdjustRefreshButton(parent.buttons.buttonForm.copyButton,'enabled');
		}
		else if(templateStoreType == "RS")
		{
			//Template belongs to related store
			parent.AdjustRefreshButton(parent.buttons.buttonForm.changeButton,'disabled');
			parent.AdjustRefreshButton(parent.buttons.buttonForm.copyButton,'enabled');
			parent.AdjustRefreshButton(parent.buttons.buttonForm.deleteButton,'disabled');
		}
	}
}

function getResultsSize () {
	return <%= numberOfTemplates %>;
}

function getSelectValue (select) {
	return select.options[select.selectedIndex].value;
}

function loadSelectValue (select, value) {
	for (var i=0; i<select.length; i++) {
		if (select.options[i].value == value) {
			select.options[i].selected = true;
			return;
		}
	}
}

function onLoad () {
	mySubmitFinishHandler();
	parent.loadFrames();
}
//-->
</script>
</head>

<body onload="onLoad()" class="content_list">
<%
	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;
	int rowselect = 1;
	int totalsize = numberOfTemplates;
	int totalpage = totalsize/listSize;
%>
 <%= comm.addControlPanel("emailactivity.EmailTemplateList", totalpage, totalsize, jLocale) %> 

<form name="manageEmailTemplateListForm" id="manageEmailTemplateListForm">

<br/>

<%= comm.startDlistTable((String)emailActivityRB.get("eMailTemplateList")) %>
<%= comm.startDlistRowHeading() %>

<%= comm.addDlistCheckHeading() %>

<%= comm.addDlistColumnHeading((String)emailActivityRB.get("templateListNameColumn"), EmailTemplateConstants.ORDER_BY_NAME, orderByParm.equals(EmailTemplateConstants.ORDER_BY_NAME)) %>

<%= comm.addDlistColumnHeading((String)emailActivityRB.get("templateListDescriptionColumn"),EmailTemplateConstants.ORDER_BY_DESCRIPTION, orderByParm.equals(EmailTemplateConstants.ORDER_BY_DESCRIPTION)) %>


<%= comm.addDlistColumnHeading((String)emailActivityRB.get("templateListContentFormatColumn"),EmailTemplateConstants.ORDER_BY_CONTENT_FORMAT, orderByParm.equals(EmailTemplateConstants.ORDER_BY_CONTENT_FORMAT)) %>

<%= comm.endDlistRow() %>
<%
	if (endIndex > numberOfTemplates) {
		endIndex = numberOfTemplates;
	}

	EmailTemplateRow emailTemplate;
	int indexFrom = startIndex;
	for (int i=indexFrom; i<endIndex; i++) {
		emailTemplate = emailTemplateListRows[i];
   String templateName = "TN_"+emailTemplate.getCheckBoxName().toString();
   String templateStore = "TS_"+emailTemplate.getCheckBoxName().toString();

%>
<%= comm.startDlistRow(rowselect) %>

<% 	//check box name cannot start with number..so keep one hidden variable for
	// each row, whose name will be "TN_"+checkBoxName();
	if(!emailTemplate.isCreatedInThisStore()) {
		//it is created in related store..
%>
	<INPUT TYPE = hidden name = '<%=templateStore%>' value='RS'> 
<%	} else { %>
	<INPUT TYPE = hidden name = '<%=templateStore%>' value='CS'> 
<%	} %>

	<INPUT TYPE = hidden name = '<%=templateName%>' value= '<%= emailTemplate.getName()%>'> 

<%= comm.addDlistCheck(emailTemplate.getCheckBoxName().toString(), "enableDisableButtons()") %>

<%
	if(emailTemplate.isCreatedInThisStore()) {
	//if its created in this store, then u can change..
%>

<%= comm.addDlistColumn(UIUtil.toHTML(emailTemplate.getName()),"javascript:changeEmailTemplateFromName(" + emailTemplate.getCheckBoxName().toString()+ ")") %>

<% } else { %>

<%= comm.addDlistColumn(UIUtil.toHTML(emailTemplate.getName()),"none") %>

<% } %>

<%= comm.addDlistColumn(UIUtil.toHTML(emailTemplate.getDescription()), "none") %>

<% if(emailTemplate.getContentFormat().equals("1"))
	{ %>
<%= comm.addDlistColumn(UIUtil.toHTML(emailActivityRB.get("plainText").toString()), "none") %>
<%
	}else{
%>
<%= comm.addDlistColumn(UIUtil.toHTML(emailActivityRB.get("html").toString()), "none") %>
<%
	}
%>

<%= comm.endDlistRow() %>

<%
		if (rowselect == 1) {
			rowselect = 2;
		}
		else {
			rowselect = 1;
		}
}//for loop
%>
<%= comm.endDlistTable() %>
<%	if (numberOfTemplates == 0) { %>
<p/><p/>
<%= emailActivityRB.get(EmailTemplateConstants.MSG_TEMPLATE_LIST_EMPTY) %>
<%	} %>
</form>

<script>
<!-- hide script from old browsers
parent.afterLoads();
parent.setResultssize(getResultsSize());
parent.setButtonPos("0px", "54px");
</script>

</body>

</html>
