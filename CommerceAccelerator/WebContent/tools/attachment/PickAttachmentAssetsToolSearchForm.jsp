<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2005
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
<% 
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//------------------------------------------------------------------------------
// 040515           MF        Creation Date
////////////////////////////////////////////////////////////////////////////////
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.context.base.BaseContext" %>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@ page import="com.ibm.commerce.context.globalization.GlobalizationContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>

<%@ include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale 		= ((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale();
	String languageId = ((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLanguageId().toString();
	Hashtable rbAttachment = (Hashtable) ResourceDirectory.lookup("attachment.AttachmentNLS",jLocale);

	StoreAccessBean abStore = cmdContext.getStore();
	Integer [] iLanguages  = abStore.getSupportedLanguageIds();

	boolean SINGLELANGSTORE = false;
	if (iLanguages.length == 1)  {
		SINGLELANGSTORE = true;
	}
%>

<%--
//---------------------------------------------------------------------
//- Forward Error JSP 
//---------------------------------------------------------------------
--%>

<html>
<head>

<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />

<title><%=rbAttachment.get("PickAttachmentAssetsToolSearchForm_Title")%></title>

<script src="/wcs/javascript/tools/common/Util.js"></script>

<script language="JavaScript">

<%--
//---------------------------------------------------------------------
//- Display functions
//---------------------------------------------------------------------
--%>
var searchCriteria = new searchObject(); 

/////////////////////////////////////////////////////////////////////////////////////
// searchObject()
//
// - the value object attached to each node
/////////////////////////////////////////////////////////////////////////////////////
function searchObject()
{
	this.filenameSearchString    = "";
	this.descriptionSearchString = "";
	this.typeSelect              = "";
	this.languageId              = "";
}


/////////////////////////
// initialization
/////////////////////////
function onLoad() {

	//
	// Ensure that if we hit the bct find we flush the saved data
	top.put("ProductUpdateDetailDataExists", "false");


	//parent.setContentFrameLoaded(true);
	//parent.setSearchResultListFrame(searchCriteria);
}

////////////////////////
// clean up the form
////////////////////////
function cleanForm() {
	document.searchForm.reset();
}


<%--
//---------------------------------------------------------------------
//- Action functions
//---------------------------------------------------------------------
--%>
///////////////////////
// validate all the inputs before sending form to result page
///////////////////////
function validateEntries() {
	//return true;
	return true;
}

///////////////////////
// return back to the previous page with the form value if GO_BACK option is specified
///////////////////////
function goBackWithParameters(urlPara)
{
	top.mccbanner.counter --;
	top.mccbanner.counter --;
	top.mccbanner.showbct();
	
	top.setContent("",url,true, urlPara);     

}

function goBackWithParametersWithoutChangingTitle(urlPara)
{
	top.mccbanner.counter --;
	top.mccbanner.showbct();
	
	top.showContent(top.mccbanner.trail[top.mccbanner.counter].location, 
					urlPara);
}

/////////////////////////////////////
// findButton()
/////////////////////////////////////

function findButton()
{
	searchCriteria.filenameSearchString = document.all.targetName.value;
	// since we don't have a UI for Attachment target yet, we don't need the line below
	//searchCriteria.descriptionSearchString = document.all.targetDescription.value;
	searchCriteria.typeSelect = document.all.TypeSelect.value;
	searchCriteria.languageId = "<%= languageId %>";
	
	parent.setSearchResultListFrame(searchCriteria);
	
}

//////////////////////////////////////////////////////////////////////////////////////
// handleEnterPressed() 
//
// - perform a default action if the enter key is pressed
//////////////////////////////////////////////////////////////////////////////////////
function handleEnterPressed() 
{
	if(event.keyCode != 13) return;
	parent.searchForm.findButton();
}

/**
*	inspect
*/
function inspect(obj) 
{
	if (obj == null) return;
	for (var i in obj) alert(i + " = " + obj[i]);
}

//////////////////////////
// cancel search 
//////////////////////////
function cancelAction() {
	top.goBack();
}

</script>
</head>


<body class="content" onkeypress="handleEnterPressed();" onload="onLoad();" oncontextmenu="return false;">

<style type='text/css'>
input.input {
	width: 200px;
}

select.input {
	width: "auto";
}

.stylingFrame {
	margin-top: 0px;
	margin-bottom: 0px;
}

.topForm {
	margin-bottom: 0px;
	margin-top: 1px
}
</style>

<h1><%=rbAttachment.get("PickAttachmentAssetsToolSearchForm_Title")%></h1>
<script>
document.writeln("<%=UIUtil.toJavaScript((String)rbAttachment.get("PickAttachmentAssetsToolSearchForm_Instruction"))%>");
</script>
<br />
<form name="searchForm" action="" class="topForm" method="post"><br />

<table border="0">
	<tbody>
		<tr>
			<td ><label for="targetName"><%=rbAttachment.get("PickAttachmentAssetsToolSearchForm_TargetName")%></label></td>
		</tr>
		<tr>
			<td><input type="text" id="targetName" name="targetName" class="input" size="100" maxlength="64" /></td>
			<td>&nbsp;</td>
		</tr>
<% if (false) { 
   // this if is to hide the targetDescription field since we don't have a UI to 
   // enter this value yet.
%>
		<tr>
			<td ><label for="targetDescription"><%=rbAttachment.get("PickAttachmentAssetsToolSearchForm_Description")%></label></td>
		</tr>		
		<tr>
			<td><input type="text" id="targetDescription" name="targetDescription" class="input" maxlength="64" /></td>
			<td>&nbsp;</td>
		</tr>
<% } %>
	</tbody>
</table>

<table border="0">
	<tbody>
		<tr>
			<td ><label for="TypeSelect"><%=rbAttachment.get("PickAttachmentAssetsToolSearchForm_Type")%></label></td>
		</tr>
		<tr>
			<td ><select id="TypeSelect" name="TypeSelect" class="input">
			    <option value="All"><%=rbAttachment.get("PickAttachmentAssetsToolSearchForm_All")%></option>
				<option value="Universal"><%=rbAttachment.get("PickAttachmentAssetsToolSearchForm_Universal")%></option>
<%		if  (!SINGLELANGSTORE) { %>
				<option value="LanguageSpecific"><%=rbAttachment.get("PickAttachmentAssetsToolSearchForm_LanguageSpecic")%></option>
<%      } %>
				<option value="Unspecified"><%=rbAttachment.get("PickAttachmentAssetsToolSearchForm_Unspecified")%></option>
			</select></td>
		</tr>
		<tr>
			<td></td>
		</tr>
	</tbody>
</table>

</form>

<form name="typeFrame" style="display: none" class="stylingFrame"></form>

<form class="stylingFrame"></form>

</body>
</html>
