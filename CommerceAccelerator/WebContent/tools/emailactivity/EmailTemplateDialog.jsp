

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

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %> 
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.emarketing.emailtemplate.objects.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
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

<%

	CommandContext context = (CommandContext)pageContext.getRequest().getAttribute(ECConstants.EC_COMMANDCONTEXT);
	
	// Checking whether Coremetrics is enabled for this store. If Coremetrics is not enabled for the store, cm-email feature also 
	// wont be enabled
	boolean cmEmailFeature = EmailTemplateUtil.isCoremetricsEnabled(context.getStoreId());
	Hashtable cmEmailActivityRB = null;
	if (cmEmailFeature) {
		try {
			cmEmailActivityRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("emailactivity.CMEmailActivity", 		emailActivityCommandContext.getLocale());
		} catch (Exception e ) {
			// Cant load the resource bundle for cm-email feature
			// Disable the cm-email feature
			cmEmailFeature = false;
		}
		
		if (emailActivityRB == null) {
			System.out.println("Email Activity resouces bundle is null");
		}
	}
%>


<title><%= emailActivityRB.get("emailTemplateDialogTitle") %></title>



<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script src="/wcs/javascript/tools/common/DateUtil.js"></script>
<script language="JavaScript">

<!---- hide script from old browsers
function loadPanelData()
{
	var comingFrom = top.getData("comingFrom");
	var task = top.get("task");

	//if we are updating/copying or if we are coming from search/preview
	//page, then populate all fields...
	if(task == "U" || task == "D" || comingFrom == "searchPage" || comingFrom == "preview"){
		loadData();
		loadLinkFields();
	}
	showTheDivs();
	if(comingFrom == "searchPage"){
		getSearchResult();
	}

	//assume that we are creating new template and not email activitiy..
	top.saveData("emailTemplateList","nextView");
	top.saveData("noWhere","comingFrom");

	document.emailTemplateForm.Name.focus();

	if (parent.setContentFrameLoaded){
		parent.setContentFrameLoaded(true);
    }
}

function toggleLinkTextbox(obj) {
	if (obj.value == "on") {
		obj.value = "off";
		obj.checked = true;
	} else {
		obj.checked = false;
		obj.value = "on";
	}
	clearLinkNameField();
	showTheDivs();
}


function previewTemplate()
{
	saveFormData();
	saveLinkFields();
	top.saveData("preview","comingFrom");
	var emailTemplateObject = new Object();

	//The actual content....email Body...
	emailTemplateObject.emailBody = document.emailTemplateForm.EmailContent.value;

	//Do we need to record email opened event ?
	if(document.emailTemplateForm.Record.checked){
		emailTemplateObject.recordOpen = "1";
	}
	else {
		emailTemplateObject.recordOpen = "0";
	}

	//check the content format type..is it HTML or Plain text ?
	for(var i=0; i<document.emailTemplateForm.EmailFormat.length; i++)
	{
		if(document.emailTemplateForm.EmailFormat[i].checked == true)
		{
			emailTemplateObject.contentFormat = document.emailTemplateForm.EmailFormat[i].value;
			break;
		}
	}

	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=emailactivity.EmailTemplatePreviewDialog&templateType=0";
	top.setContent("<%= UIUtil.toJavaScript((String)emailActivityRB.get("EmailTemplatePreview")) %>", url, true,emailTemplateObject);
}

function showTheDivs()
{
	var comingFrom = top.getData("comingFrom");
	var attributeType = top.getData("attributeType");
	var subAttributeType = top.getData("subAttributeType");
	var linkType = top.getData("linkType");
	if(comingFrom == "searchPage" || comingFrom == "preview")
	{
		//set the attribute type...first name, last name, link....for HTML
		for(var i = 0; i < document.emailTemplateForm.attributesList.length; i++)
		{
			if(document.emailTemplateForm.attributesList[i].value
			==  attributeType)
			{
				document.emailTemplateForm.attributesList[i].selected = true;
			}
		}
		//for plain text...
		for(var i = 0; i < document.emailTemplateForm.attributesListPT.length; i++)
		{
			if(document.emailTemplateForm.attributesListPT[i].value
			==  attributeType)
			{
				document.emailTemplateForm.attributesListPT[i].selected = true;
			}
		}

		if(attributeType = "<%=EmailTemplateConstants.LINK %>")
		{
			//Check whether its predefinedclickaction or specify URL as click action..
			for(var i = 0; i < document.emailTemplateForm.clickActionList.length; i++)
			{
				if(document.emailTemplateForm.clickActionList[i].value
				==  subAttributeType)
				{
					document.emailTemplateForm.clickActionList[i].selected = true
				}
			}

			for(var i = 0; i < document.emailTemplateForm.predefinedClickActionsList.length; i++)
			{
				if(document.emailTemplateForm.predefinedClickActionsList[i].value
				==  linkType)
				{
					document.emailTemplateForm.predefinedClickActionsList[i].selected = true;
				}
			}			
		}
	}
		
	//show the divs...
	for(var i=0; i<document.emailTemplateForm.EmailFormat.length; i++)
	{
		if(document.emailTemplateForm.EmailFormat[i].checked == true)
		{
			var format = 	document.emailTemplateForm.EmailFormat[i].value;
			if(format == "<%=EmailTemplateConstants.HTML_FORMAT %>")
				showHTMLDiv();
			else if(format == "<%=EmailTemplateConstants.PLAIN_TEXT_FORMAT %>")
				showPlainTextDiv();
		}
	}
}


function loadRecordClicksStatus(emailTemplateBean)
{
	if(emailTemplateBean.recordClicksForProduct == "1")
		document.emailTemplateForm.recordClicksForProduct.checked = true;
	else
		document.emailTemplateForm.recordClicksForProduct.checked = false;

	if(emailTemplateBean.recordClicksForCategory == "1")
		document.emailTemplateForm.recordClicksForCategory.checked = true;
	else
		document.emailTemplateForm.recordClicksForCategory.checked = false;

	if(emailTemplateBean.recordClicksForSC == "1")
		document.emailTemplateForm.recordClicksForSC.checked = true;
	else
		document.emailTemplateForm.recordClicksForSC.checked = false;

	if(emailTemplateBean.recordClicksForIL == "1")
		document.emailTemplateForm.recordClicksForIL.checked = true;
	else
		document.emailTemplateForm.recordClicksForIL.checked = false;

	if(emailTemplateBean.recordClicksForURLPT == "1")
		document.emailTemplateForm.recordClicksForURLPT.checked = true;
	else
		document.emailTemplateForm.recordClicksForURLPT.checked = false;

	if(emailTemplateBean.recordClicksForURL == "1")
		document.emailTemplateForm.recordClicksForURL.checked = true;
	else
		document.emailTemplateForm.recordClicksForURL.checked = false;
}

function loadData()
{
	var comingFrom = top.getData("comingFrom");
	var task = top.get("task");
	var emailTemplateBean = null;
	if(comingFrom == "searchPage" || comingFrom == "preview")
	{
		emailTemplateBean = top.getData("emailTemplateBean");
		document.emailTemplateForm.Name.value = emailTemplateBean.name;
	}
	else
	{
		emailTemplateBean = parent.get("<%= EmailTemplateConstants.EMAIL_TEMPLATE_BEAN %>");
	}
	//if it is update...
	if(task == "U")
	{
		//it is update..so name field is read only...
		document.emailTemplateForm.Name.value = emailTemplateBean.name;
		document.emailTemplateForm.Name.readOnly = true;
		document.emailTemplateForm.Name.style.background = "#CCCCCC";
	}
	
	var linkType = top.getData("linkType");

	document.emailTemplateForm.Description.value = emailTemplateBean.description;

	document.emailTemplateForm.EmailSubject.value = 
	emailTemplateBean.emailSubject;

	 document.emailTemplateForm.EmailContent.value = emailTemplateBean.emailBody;

	 if(emailTemplateBean.recordOpen == "1")
		document.emailTemplateForm.Record.checked = true;
	 else
		 document.emailTemplateForm.Record.checked = false;

	document.emailTemplateForm.display.value = emailTemplateBean.display;
	
	 <% if (cmEmailFeature) { %>
	 if(emailTemplateBean.linktoCM == "1") {
		document.emailTemplateForm.linktoCM.checked = true;
		document.emailTemplateForm.linkNameForCM.value = emailTemplateBean.linkName;
	 } else
		 document.emailTemplateForm.linktoCM.checked = false;
	 <% } %>

	var task = top.get("task");

	for(var i=0; i<document.emailTemplateForm.EmailFormat.length; i++)
	{
		if(document.emailTemplateForm.EmailFormat[i].value == emailTemplateBean.contentFormat)
		{
			document.emailTemplateForm.EmailFormat[i].checked = true;
		}
	}

	loadRecordClicksStatus(emailTemplateBean);
}

function showFirstLastNameDiv()
{
	document.all["linkSelect"].style.display = "none";
	document.all["contentSelect"].style.display = "none";
	document.all["eMarketingSpotSelect"].style.display = "none";

	var selectedValue = document.emailTemplateForm.attributesList[document.emailTemplateForm.attributesList.selectedIndex].value;

	if (selectedValue == "<%=EmailTemplateConstants.FIRST_NAME %>")
		top.saveData("<%=EmailTemplateConstants.FIRST_NAME %>", "attributeTypeForInsert");
	else if (selectedValue == "<%=EmailTemplateConstants.LAST_NAME %>")
		top.saveData("<%=EmailTemplateConstants.LAST_NAME %>", "attributeTypeForInsert");
}

function showLinkDiv()
{
	document.all["linkSelect"].style.display = "block";
	document.all["contentSelect"].style.display = "none";
	document.all["eMarketingSpotSelect"].style.display = "none";
	top.saveData("<%=EmailTemplateConstants.LINK %>", "attributeTypeForInsert");
	//show child links...
	showHideLinkDivs();
}

function showContentDiv()
{	
	document.all["contentSelect"].style.display = "block";
	document.all["linkSelect"].style.display = "none";
	document.all["eMarketingSpotSelect"].style.display = "none";
	top.saveData("<%=EmailTemplateConstants.CONTENT %>", "attributeTypeForInsert");
}

function showEMarketingDiv()
{
	document.all["eMarketingSpotSelect"].style.display = "block";
	document.all["linkSelect"].style.display = "none";
	document.all["contentSelect"].style.display = "none";
	top.saveData("<%=EmailTemplateConstants.EMSPOT %>", "attributeTypeForInsert");
}

function showFirstLastNameDivPT()
{
	document.all["linkSelectPT"].style.display = "none";

	//for inserting the tag...
	var selectedValue = document.emailTemplateForm.attributesListPT[document.emailTemplateForm.attributesListPT.selectedIndex].value;

	if (selectedValue == "<%=EmailTemplateConstants.FIRST_NAME%>")
		top.saveData("<%=EmailTemplateConstants.FIRST_NAME %>", "attributeTypeForInsert");
	else if (selectedValue == "<%=EmailTemplateConstants.LAST_NAME %>")
		top.saveData("<%=EmailTemplateConstants.LAST_NAME %>", "attributeTypeForInsert");
}

function showLinkDivPT()
{
	document.all["linkSelectPT"].style.display = "block";
	top.saveData("<%=EmailTemplateConstants.LINK %>", "attributeTypeForInsert");
}

function showPredefinedClickDiv()
{
	document.all["predefinedLinkSelect"].style.display = "block";
	document.all["urlLinkSelect"].style.display = "none";
	top.saveData("predefinedLink", "linkTypeForInsert");
	//show the child links..like product, category...unsubscribe..
	showHidePredefinedClickDivs();
}

function showURLClickDiv()
{
	document.all["urlLinkSelect"].style.display = "block";
	document.all["predefinedLinkSelect"].style.display = "none";
	top.saveData("urlLink", "linkTypeForInsert");
}

function showDisplayProductDiv()
{
	document.all["displayProductSelect"].style.display = "block";
	document.all["displayCategorySelect"].style.display = "none";
	document.all["shoppingCartSelect"].style.display = "none";
	document.all["interestListSelect"].style.display = "none";
	document.all["unsubscribeSelect"].style.display = "none";
	top.saveData("product", "predefinedLinkTypeForInsert");
}

function showDisplayCategoryDiv()
{
	document.all["displayCategorySelect"].style.display = "block";
	document.all["displayProductSelect"].style.display = "none";
	document.all["shoppingCartSelect"].style.display = "none";
	document.all["interestListSelect"].style.display = "none";
	document.all["unsubscribeSelect"].style.display = "none";
	top.saveData("category", "predefinedLinkTypeForInsert");
}

function showShoppingCartDiv()
{
	document.all["shoppingCartSelect"].style.display = "block";
	document.all["displayProductSelect"].style.display = "none";
	document.all["displayCategorySelect"].style.display = "none";
	document.all["interestListSelect"].style.display = "none";
	document.all["unsubscribeSelect"].style.display = "none";
	top.saveData("shoppingCart", "predefinedLinkTypeForInsert");
}

function showInterestListDiv()
{
	document.all["interestListSelect"].style.display = "block";
	document.all["displayProductSelect"].style.display = "none";
	document.all["displayCategorySelect"].style.display = "none";
	document.all["shoppingCartSelect"].style.display = "none";
	document.all["unsubscribeSelect"].style.display = "none";
	top.saveData("interestList", "predefinedLinkTypeForInsert");
}

function showUnsubscribeDiv()
{
	document.all["unsubscribeSelect"].style.display = "block";
	document.all["displayProductSelect"].style.display = "none";
	document.all["displayCategorySelect"].style.display = "none";
	document.all["shoppingCartSelect"].style.display = "none";
	document.all["interestListSelect"].style.display = "none";
	top.saveData("unsubscribe", "predefinedLinkTypeForInsert");
}

function hideAllMainDivs()
{
	document.all["linkSelect"].style.display = "none";
	document.all["contentSelect"].style.display = "none";
	document.all["eMarketingSpotSelect"].style.display = "none";
}

function hideAllPredefinedLinkDivs()
{
	document.all["displayProductSelect"].style.display = "none";
	document.all["displayCategorySelect"].style.display = "none";
	document.all["shoppingCartSelect"].style.display = "none";
	document.all["interestListSelect"].style.display = "none";
	document.all["unsubscribeSelect"].style.display = "none";
}

function showHideHtmlDivs()
{
	var selectedValue = document.emailTemplateForm.attributesList[document.emailTemplateForm.attributesList.selectedIndex].value;
	if (selectedValue == "<%=EmailTemplateConstants.FIRST_NAME %>") {
		showFirstLastNameDiv();
		<% if (cmEmailFeature) { %>
		hideLinkNameField();
		<% } %>
		document.emailTemplateForm.display.value = "first name";
	} else if (selectedValue == "<%=EmailTemplateConstants.LAST_NAME %>") {
		showFirstLastNameDiv();
		<% if (cmEmailFeature) { %>
		hideLinkNameField();
		<% } %>
		document.emailTemplateForm.display.value = "last name";
	} else if (selectedValue == "<%=EmailTemplateConstants.LINK%>") {
		showLinkDiv();
	}
	else if (selectedValue == "<%=EmailTemplateConstants.CONTENT%>") {
		showContentDiv();
		 <% if (cmEmailFeature) { %>
			hideLinkNameField();
		<% } %>
		document.emailTemplateForm.display.value = "content spot";
	}
	else if (selectedValue == "<%=EmailTemplateConstants.EMSPOT%>") {
		showEMarketingDiv();
		 <% if (cmEmailFeature) { %>
			hideLinkNameField();
		<% } %>
		document.emailTemplateForm.display.value = "em spot";
	}
}


<% if (cmEmailFeature) { %>
function hideLinkNameField() {
	obj = document.getElementById("linkNameDisplayForCM");
	obj.style.display = "none";
}

function showLinkNameField() {
	obj = document.getElementById("linkNameDisplayForCM");
	obj.style.display = "block";
}
<% } %>

function showHidePTDivs()
{
	var hide = "true";
	var selectedValue = document.emailTemplateForm.attributesListPT[document.emailTemplateForm.attributesListPT.selectedIndex].value;

	if (selectedValue == "<%=EmailTemplateConstants.FIRST_NAME %>") {
		showFirstLastNameDivPT();
		<% if (cmEmailFeature) { %>
		clearLinkNameField();
		<% } %>
		document.emailTemplateForm.display.value = "first name";
	}
	else if (selectedValue == "<%=EmailTemplateConstants.LAST_NAME %>") {
		showFirstLastNameDivPT();
		<% if (cmEmailFeature) { %>
		clearLinkNameField();
		<% } %>
		document.emailTemplateForm.display.value = "last name";
	}
	else if (selectedValue == "<%=EmailTemplateConstants.LINK%>") {
		showLinkDivPT();
		<% if (cmEmailFeature) { %>
			clearLinkNameField();	
			if (document.emailTemplateForm.linktoCM.checked) {
				hide = "false";
			}
		<% } %>
		document.emailTemplateForm.display.value = "Pt Link";
	}
	<% if (cmEmailFeature) { %>
	if (hide == "true") {
		hideLinkNameField();
	} else {
		showLinkNameField();
	}
	<% } %>
}

function showHideLinkDivs()
{
	var selectedValue = document.emailTemplateForm.clickActionList[document.emailTemplateForm.clickActionList.selectedIndex].value;
	if (selectedValue == "predefined click") {
		showPredefinedClickDiv();
		var displayFld = document.emailTemplateForm.display.value;
		if (displayFld != "Display product" && displayFld != "Display category" &&
				displayFld != "Add to shopping cart" && displayFld != "Add to interest list") {
		}
	}
	else if (selectedValue == "URL click") {
		showURLClickDiv();
		<% if (cmEmailFeature) { %>
		clearLinkNameField();
		<% } %>
		document.emailTemplateForm.display.value = "URL click";
	}
}

function loadValues(field, val)
{
	var str = typeof val;
	if(str != '' && str != "undefined")
	{
		field.value = val;
	}
}

function loadLinkFields()
{
	//Predefined fields...
	loadValues(document.emailTemplateForm.productName,top.getData("productName"));
	loadValues(document.emailTemplateForm.selectCategory,top.getData("selectCategory"));
	loadValues(document.emailTemplateForm.selectItem,top.getData("selectItem"));
loadValues(document.emailTemplateForm.selectInterestItem,top.getData("selectInterestItem"));
	loadValues(document.emailTemplateForm.unsubscribeUrl,top.getData("unsubscribeUrl"));
	loadValues(document.emailTemplateForm.unsubscribeText,top.getData("unsubscribeText"));

	//Select URL as click action..
	loadValues(document.emailTemplateForm.url, top.getData("url"));
	loadValues(document.emailTemplateForm.textURL,top.getData("textURL"));
	//Emarketing
	loadValues(document.emailTemplateForm.eMarketingSpot,top.getData("eMarketingSpot"));
	//URL in case of Plain text
	loadValues(document.emailTemplateForm.urlPT,top.getData("urlPT"));
	

	for(var i = 0; i < document.emailTemplateForm.emSpotDisplayList.length; i++)
	{
		if(document.emailTemplateForm.emSpotDisplayList[i].value == top.getData("emSpotDisplayListValue"))
		{
			document.emailTemplateForm.emSpotDisplayList[i].selected = true;
			break;
		}
	}
	//Content
	loadValues(document.emailTemplateForm.content,top.getData("content"));
	for(var i = 0; i<document.emailTemplateForm.contentDisplayList.length; i++)
	{
		if(document.emailTemplateForm.contentDisplayList[i].value == top.getData("emSpotDisplayListValue"))
		{
			document.emailTemplateForm.contentDisplayList[i].selected = true;
		}
	}

}

function saveLinkFields()
{
	//Predefined fields...
	top.saveData(document.emailTemplateForm.productName.value,"productName");
	top.saveData(document.emailTemplateForm.selectCategory.value,"selectCategory");
	top.saveData(document.emailTemplateForm.selectItem.value,"selectItem");
	top.saveData(document.emailTemplateForm.selectInterestItem.value,"selectInterestItem");
	top.saveData(document.emailTemplateForm.unsubscribeUrl.value,"unsubscribeUrl");
	top.saveData(document.emailTemplateForm.unsubscribeText.value,"unsubscribeText");
	//Select URL as click action..
	top.saveData(document.emailTemplateForm.url.value,"url");
	top.saveData(document.emailTemplateForm.textURL.value,"textURL");
	//Emarketing
	top.saveData(document.emailTemplateForm.eMarketingSpot.value,"eMarketingSpot");
	//URL in case of plain text..
	top.saveData(document.emailTemplateForm.urlPT.value,"urlPT");
	
	for(var i=0; i<document.emailTemplateForm.emSpotDisplayList.length; i++)
	{
		if(document.emailTemplateForm.emSpotDisplayList[i].selected == true)
		{
			top.saveData(document.emailTemplateForm.emSpotDisplayList[i].value,"emSpotDisplayListValue");
			break;
		}
	}

	//content
	top.saveData(document.emailTemplateForm.content.value,"content");
	for(var i=0; i<document.emailTemplateForm.contentDisplayList.length; i++)
	{
		if(document.emailTemplateForm.contentDisplayList[i].selected == true)
		{
			top.saveData(document.emailTemplateForm.contentDisplayList[i].value,"contentDisplayListValue");
			break;
		}
	}
}

<% if (cmEmailFeature) { %>

function clearLinkNameField() {
	linkNameFldObj = document.getElementById("linkNameForCM");
	linkNameFldObj.value = "";
} 
<% } %>

function showHidePredefinedClickDivs()
{
	displayFld = document.emailTemplateForm.display.value;
	var selectedValue = document.emailTemplateForm.predefinedClickActionsList[document.emailTemplateForm.predefinedClickActionsList.selectedIndex].value;
	if (selectedValue == "Display product") {
		showDisplayProductDiv();
		<% if (cmEmailFeature) { %>
			if (document.emailTemplateForm.linktoCM.checked)
				showLinkNameField();
			else 
				hideLinkNameField();

			if (displayFld != selectedValue)
				clearLinkNameField();
			document.emailTemplateForm.display.value = "Display product";
		<% } %>
	}
	else if (selectedValue == "Display category") {
		showDisplayCategoryDiv();
		<% if (cmEmailFeature) { %>
			if (document.emailTemplateForm.linktoCM.checked)
				showLinkNameField();
			else 
				hideLinkNameField();

			if (displayFld != selectedValue)
				clearLinkNameField();
			document.emailTemplateForm.display.value = "Display category";
		<% } %>
	}
	else if (selectedValue == "Add to shopping cart") {
		showShoppingCartDiv();
		<% if (cmEmailFeature) { %>
			if (document.emailTemplateForm.linktoCM.checked)
				showLinkNameField();
			else 
				hideLinkNameField();

			if (displayFld != selectedValue)
				clearLinkNameField();
			document.emailTemplateForm.display.value = "Add to shopping cart";
		<% } %>
	}
	else if (selectedValue == "Add to interest list") {
		showInterestListDiv();
		<% if (cmEmailFeature) { %>
			if (document.emailTemplateForm.linktoCM.checked)
				showLinkNameField();
			else 
				hideLinkNameField();

			if (displayFld != selectedValue)
				clearLinkNameField();
			document.emailTemplateForm.display.value = "Add to interest list";
		<% } %>
	}
	else if (selectedValue == "Unsubscribe") {
		showUnsubscribeDiv();
		document.emailTemplateForm.display.value = "Unsubscribe";
		 <% if (cmEmailFeature) { %>
			hideLinkNameField();
		<% } %>
	}
}

function showHTMLDiv()
{
	document.all["htmlSelect"].style.display = "block";
	document.all["plainTextSelect"].style.display = "none";
	top.saveData("html", "contentFormat");
	showHideHtmlDivs();
}

function showPlainTextDiv()
{
	document.all["plainTextSelect"].style.display = "block";
	document.all["htmlSelect"].style.display = "none";
	top.saveData("plainText", "contentFormat");
	hideAllMainDivs();
	showHidePTDivs();
}


function constructTag()
{
	var tag;
	//first check the content format
	var contentFormat = top.getData("contentFormat");

	var cmAction = 0;
	var linkName = "";	
	var cmEnabled = "false";

	<% if (cmEmailFeature) { %>
		cmEnabled = "true";
		if (document.emailTemplateForm.linktoCM.checked) {
			cmAction = 1;
		}
	<% } %>

	if(contentFormat == "html")
	{
		//it is HTML type..check the attribute type..
		var attribute = top.getData("attributeTypeForInsert");
		if(attribute == "<%=EmailTemplateConstants.FIRST_NAME %>")
		{
			tag = "<e-mail:FirstName />";
			doInsert(tag,'','false');
		}
		else if(attribute == "<%=EmailTemplateConstants.LAST_NAME %>")
		{
			tag = "<e-mail:LastName />";
			doInsert(tag,'','false');
		}
		else if(attribute == "<%=EmailTemplateConstants.EMSPOT %>")
		{
			// tag = "<e-mail:ESpot name="" display="" />";
			var espotName = document.emailTemplateForm.eMarketingSpot.value;
			var display = "";
			if(document.emailTemplateForm.emSpotDisplayList.selectedIndex != -1)
			{
				display = 	document.emailTemplateForm.emSpotDisplayList[document.emailTemplateForm.emSpotDisplayList.selectedIndex].value;
			}
			tag = "<e-mail:EMSpot name=\"";
			tag = tag + espotName + "\" ";
			tag = tag + "display=\"" + display + "\" ";
			if (cmEnabled == "true") {
				tag = tag + "cmaction=\"";
				tag = tag + cmAction +  "\" ";
			}
			tag = tag +	"/>";

			doInsert(tag,'','false');
		}
		else if(attribute == "<%=EmailTemplateConstants.CONTENT %>")
		{
			var contentName = document.emailTemplateForm.content.value;
			var display = "";
			if(document.emailTemplateForm.contentDisplayList.selectedIndex != -1)
			{
				display = 	document.emailTemplateForm.contentDisplayList[document.emailTemplateForm.contentDisplayList.selectedIndex].value;
			}
			tag = "<e-mail:Content name=\"";
			tag = tag + contentName  + "\" ";
			tag = tag + "display=\"" + display + "\" ";
			if (cmEnabled == "true") {
				tag = tag + "cmaction=\"";
				tag = tag + cmAction +  "\" ";
			}
			tag = tag +	"/>";

			doInsert(tag,'','false');
		}
		else if(attribute == "<%=EmailTemplateConstants.LINK %>")
		{
			var linkType = top.getData("linkTypeForInsert");
			var emailAction = 0;

			if(linkType == "predefinedLink")
			{
				var predefinedLink = top.getData("predefinedLinkTypeForInsert");
				var name;
				var type = "";
				var sku = "";
				if (cmAction == 1) {
					tag = "<e-mail:CMLink ";
				} else {
					tag = "<e-mail:Link ";
				}
				
				if(predefinedLink == "product")
				{
					<% if (cmEmailFeature) { %>	
					if (cmAction == 1) {
						linkName = document.emailTemplateForm.linkNameForCM.value;
						if (linkName.length == 0) {
							alertDialog("You must specify a Link name");
							document.emailTemplateForm.linkNameForCM.focus();
							return false;					
						}							
					}
					<% } %>
					if(document.emailTemplateForm.recordClicksForProduct.checked){
						emailAction = 1;
					}
					name = document.emailTemplateForm.productName.value;
					name = escape(name);
					if(top.getData("productResult") != null)
					{
						sku = (top.getData("productResult")).catentryId;
					}
					tag = tag + "sku=\"";
					tag = tag + sku + "\" ";
					if (cmEnabled == "true" && cmAction == 1) {
						tag = tag + "linkname=\"";
						tag = tag + linkName + "\" ";
					}
					type = "product";
				}
				else if(predefinedLink == "category")
				{
					<% if (cmEmailFeature) { %>	
					if (cmAction == 1) {
						linkName = document.emailTemplateForm.linkNameForCM.value;
						if (linkName.length == 0) {
							alertDialog("You must specify a Link name");
							document.emailTemplateForm.linkNameForCM.focus();
							return false;					
						}							
					}
					<% } %>
					if(document.emailTemplateForm.recordClicksForCategory.checked){
						emailAction = 1;
					}
					name = document.emailTemplateForm.selectCategory.value;
					name = escape(name);
					type = "category";
					
					var categoryId = "";
					var isTopCategory = "";
					if(top.getData("categoryResult") != null){
						categoryId = (top.getData("categoryResult")).categoryId;
						isTopCategory = (top.getData("categoryResult")).isTopCategory;
					}
					tag = tag + "categoryId=\"";
					tag = tag + categoryId + "\" ";
					if (cmEnabled == "true" && cmAction == 1) {
						tag = tag + "linkname=\"";
						tag = tag + linkName + "\" ";
					}
					if(isTopCategory == "Y"){
						tag = tag + "top=\"";
						tag = tag + isTopCategory + "\" ";
					}													
				}
				else if(predefinedLink == "shoppingCart")
				{
					<% if (cmEmailFeature) { %>	
					if (cmAction == 1) {
						linkName = document.emailTemplateForm.linkNameForCM.value;
						if (linkName.length == 0) {
							alertDialog("You must specify a Link name");
							document.emailTemplateForm.linkNameForCM.focus();
							return false;					
						}							
					}
					<% } %>
					if(document.emailTemplateForm.recordClicksForSC.checked){
						emailAction = 1;
					}
					name = document.emailTemplateForm.selectItem.value;
					name = escape(name);
					if(top.getData("itemResult") != null){
						sku = (top.getData("itemResult")).catentryId;
					}
					tag = tag + "sku=\"";
					tag = tag + sku + "\" ";
					if (cmEnabled == "true" && cmAction == 1) {
						tag = tag + "linkname=\"";
						tag = tag + linkName + "\" ";
					}
					type = "shoppingCart";

				}
				else if(predefinedLink == "interestList")
				{
					<% if (cmEmailFeature) { %>	
					if (cmAction == 1) {
						linkName = document.emailTemplateForm.linkNameForCM.value;
						if (linkName.length == 0) {
							alertDialog("You must specify a Link name");
							document.emailTemplateForm.linkNameForCM.focus();
							return false;					
						}								
					}
					<% } %>
					if(document.emailTemplateForm.recordClicksForIL.checked){
						emailAction = 1;
					}
					name = document.emailTemplateForm.selectInterestItem.value;
					name = escape(name);
					if(top.getData("itemResult") != null)
					{
						sku = (top.getData("itemResult")).catentryId;
					}
					
					tag = tag + "sku=\"";
					tag = tag + sku + "\" ";
					if (cmEnabled == "true" && cmAction == 1) {
						tag = tag + "linkname=\"";
						tag = tag + linkName + "\" ";
					}
					type = "interestList";
				}
				else if(predefinedLink == "unsubscribe")
				{
					var text = document.emailTemplateForm.unsubscribeText.value;
					var url = document.emailTemplateForm.unsubscribeUrl.value;
					var type = "unsubscribe";
					emailAction = "2";
					// <e-mail:Link text="" url="" / >
					tag = "<e-mail:Link text=\"";
					tag = tag + text + "\" ";
					tag = tag + "url=\""+url+"\" ";
					tag = tag + "emailaction=\"";
					tag = tag + emailAction + "\" ";
					tag = tag + "type=\""+type+"\" />";
				}
				if(predefinedLink != "unsubscribe")
				{
					//<e-mail:Link name="" emailaction="" type="" / >
					tag = tag + "name=\"";
					tag = tag + name + "\" ";
					tag = tag + "emailaction=\"";
					tag = tag + emailAction + "\" ";
					tag = tag + "type=\""+type + "\" ";
					tag = tag + "/>";
				}
			}
			else if(linkType == "urlLink")
			{
				var url = document.emailTemplateForm.url.value;
				var text = document.emailTemplateForm.textURL.value;
				<% if (cmEmailFeature) { %>	
				if (cmAction == 1) {
					linkName = document.emailTemplateForm.linkNameForCM.value;
					if (linkName.length == 0) {
						alertDialog("You must specify a Link name");
						document.emailTemplateForm.linkNameForCM.focus();
						return false;					
					}														
				}
				<% } %>
				if(document.emailTemplateForm.recordClicksForURL.checked){
					emailAction = 1;
				}
				// <e-mail:Link text="" emailaction="" url="" type="" />
				var type = "URLClickAction";
				if (cmAction == 1) {
					tag = "<e-mail:CMLink text=\"";
				} else {
					tag = "<e-mail:Link text=\"";
				}
				
				tag = tag + text;
				tag = tag + "\" emailaction=\"";
				tag = tag + emailAction;

				if (cmEnabled == "true" && cmAction == 1) {
					tag = tag + "\" linkname=\"";
					tag = tag + linkName;
				}

				tag = tag + "\" url=\""+url+"\"";
				tag = tag + " type=\""+type+"\" "; 
				
				tag = tag + "/>";
			}
			doInsert(tag,'','false');
		}
	}
	else if(contentFormat == "plainText")
	{
		var attribute = top.getData("attributeTypeForInsert");
		if(attribute == "<%=EmailTemplateConstants.FIRST_NAME %>")
		{
			tag = "<e-mail:FirstName />";
			doInsert(tag,'','false');
		}
		else if(attribute == "<%=EmailTemplateConstants.LAST_NAME %>")
		{
			tag = "<e-mail:LastName />";
			doInsert(tag,'','false');
		}
		else if(attribute == "<%=EmailTemplateConstants.LINK %>")
		{
			var url = document.emailTemplateForm.urlPT.value;
			var emailAction = 0;
			<% if (cmEmailFeature) { %>	
			if (cmAction == 1) {
				linkName = document.emailTemplateForm.linkNameForCM.value;
				if (linkName.length == 0) {
					alertDialog("You must specify a Link name");
					document.emailTemplateForm.linkNameForCM.focus();
					return false;					
				}					
			}
			<% } %>
			if(document.emailTemplateForm.recordClicksForURLPT.checked)
			{
				emailAction = 1;
			}
			// <e-mail:Link URL="" emailAction="" type = ""/>
			var type = "URLPlainText";
			if (cmAction == 1) {
				tag = "<e-mail:CMLink url=\"";
			} else {
				tag = "<e-mail:Link url=\"";
			}
			tag = tag + url + "\" emailAction=\"";
			tag = tag + emailAction + "\" ";

			if (cmEnabled == "true" && cmAction == 1) {
				tag = tag + "linkname=\"";
				tag = tag + linkName + "\" ";
			}			
			tag = tag + " type=\""+type+"\" "; 
			tag = tag + "/>";
			doInsert(tag,'','false');
		}
	}
}

function doInsert(ibTag, ibClsTag, isSingle)
{
	var isClose = false;
	var obj_ta = document.emailTemplateForm.emailContent;

	var myAgent   = navigator.userAgent.toLowerCase();
	var myVersion = parseInt(navigator.appVersion);
	//var is_ie   = ((myAgent.indexOf("msie") != -1)  && (myAgent.indexOf("opera") == -1));
	var is_win   =  ((myAgent.indexOf("win")!=-1) || (myAgent.indexOf("16bit")!=-1));

	//ISIE is a var from Util.js
	if ( (myVersion >= 4) && isIE && is_win) // Ensure it works for IE4up / Win only
	{
		if(obj_ta.isTextEdit){ // this doesn't work for NS, but it works for IE 4+ and compatible browsers
			obj_ta.focus();
//			obj_ta.scrollTop = obj_ta.scrollHeight
			var sel = document.selection;
			var rng = sel.createRange();
			rng.colapse;
			if((sel.type == "Text" || sel.type == "None") && rng != null){
				if(ibClsTag != "" && rng.text.length > 0)
					ibTag += rng.text + ibClsTag;

				else if(isSingle)
					isClose = true;

				rng.text = ibTag;
			}
		}
		else
		{
			if(isSingle)
				isClose = true;
	
			obj_ta.value += ibTag;
		}
	}
	else
	{
		if(isSingle)
			isClose = true;

		obj_ta.value += ibTag;
	}

	obj_ta.focus();
	
	// clear multiple blanks
//	obj_ta.value = obj_ta.value.replace(/  /, " ");

	return isClose;
}


function shouldGoBack()
{ 
   if(! confirmDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailTemplateCancelConfirmation")) %>")){
         return false;
   }
   return true;
}

function validatePanelData()
{
	with (document.emailTemplateForm) {
                if (!Name.value) {
			alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailTemplateNameRequired")) %>");
			Name.focus();
			return false;
		}
	           if (!EmailSubject.value) {
			alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailTemplateSubjectRequired")) %>");
			EmailSubject.focus();
			return false;
		}

	       if (!EmailContent.value) {
			alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailTemplateContentRequired")) %>");
			EmailContent.focus();
			return false;
		}
	}
	return true;
}
function savePanelData()
{
	saveFormData();
	saveLinkFields();
	var task = top.get("task");
	var nextView = top.getData("nextView");
	parent.addURLParameter("addUpdateFlag",task);
	parent.addURLParameter("nextView",nextView);
	if(task == "U")
	{
		var emailTemplateBean = parent.get("emailTemplateBean");
		parent.put("messageId",emailTemplateBean.messageId);
	}
	top.saveModel(parent.model);
}

function showWarning()
{
	alertDialog("<%= emailActivityRB.get("changingToPlainText")%>");
}


function saveRecordClicksStatus()
{
	var emailTemplateBean = top.getData("emailTemplateBean");

	if(document.emailTemplateForm.recordClicksForProduct.checked == true){
		emailTemplateBean.recordClicksForProduct = "1";
	}
	else {
		emailTemplateBean.recordClicksForProduct = "0";
	}

	if(document.emailTemplateForm.recordClicksForCategory.checked == true){
		emailTemplateBean.recordClicksForCategory = "1";
	}
	else {
		emailTemplateBean.recordClicksForCategory = "0";
	}

	if(document.emailTemplateForm.recordClicksForSC.checked == true){
		emailTemplateBean.recordClicksForSC = "1";
	}
	else {
		emailTemplateBean.recordClicksForSC = "0";
	}

	if(document.emailTemplateForm.recordClicksForIL.checked == true){
		emailTemplateBean.recordClicksForIL = "1";
	}
	else {
		emailTemplateBean.recordClicksForIL = "0";
	}

	if(document.emailTemplateForm.recordClicksForURLPT.checked == true){
		emailTemplateBean.recordClicksForURLPT = "1";
	}
	else {
		emailTemplateBean.recordClicksForURLPT = "0";
	}

	if(document.emailTemplateForm.recordClicksForURL.checked == true){
		emailTemplateBean.recordClicksForURL = "1";
	}
	else {
		emailTemplateBean.recordClicksForURL = "0";
	}
}

function saveFormData()
{
	var emailTemplateBean = parent.get("emailTemplateBean");

	emailTemplateBean.name = 
	document.emailTemplateForm.Name.value;

	emailTemplateBean.description = document.emailTemplateForm.Description.value;

	emailTemplateBean.emailSubject = document.emailTemplateForm.EmailSubject.value;

	emailTemplateBean.emailBody = document.emailTemplateForm.EmailContent.value;
	emailTemplateBean.display = document.emailTemplateForm.display.value;

	if(document.emailTemplateForm.Record.checked == true)
		emailTemplateBean.recordOpen = "1";
	else
		emailTemplateBean.recordOpen = "0";

	<% if (cmEmailFeature) { %>
	if(document.emailTemplateForm.linktoCM.checked == true) {
		emailTemplateBean.linktoCM = "1";
		emailTemplateBean.linkName = document.emailTemplateForm.linkNameForCM.value;
	} else {
		emailTemplateBean.linktoCM = "0";
		emailTemplateBean.linkName = "";
	}
	<% } %>

	for(var i=0; i<document.emailTemplateForm.EmailFormat.length; i++)
	{
		if(document.emailTemplateForm.EmailFormat[i].checked == true)
		{
			emailTemplateBean.contentFormat = document.emailTemplateForm.EmailFormat[i].value;
			break;
		}
	}

	var attributeType = null;
	if(emailTemplateBean.contentFormat == 0)
	{
		//HTML
	 attributeType = document.emailTemplateForm.attributesList[document.emailTemplateForm.attributesList.selectedIndex].value;
	top.saveData(attributeType, "attributeType");
	}
	else
	{
	 attributeType = document.emailTemplateForm.attributesList[document.emailTemplateForm.attributesListPT.selectedIndex].value;
	top.saveData(attributeType, "attributeType");

	}

	//save either plaintext attribut or html attribute..
	if(attributeType == "<%=EmailTemplateConstants.LINK %>")
	{
		var subAttributeType = document.emailTemplateForm.clickActionList[document.emailTemplateForm.clickActionList.selectedIndex].value;
		top.saveData(subAttributeType,"subAttributeType");

		var linkType = 
		document.emailTemplateForm.predefinedClickActionsList[document.emailTemplateForm.predefinedClickActionsList.selectedIndex].value;
		top.saveData(linkType,"linkType");

	}

	parent.put("emailTemplateBean", emailTemplateBean);
	top.saveData(emailTemplateBean,"emailTemplateBean");
	saveRecordClicksStatus();
}

//-->
</script>

<meta name="GENERATOR" content="IBM WebSphere Studio" />
</head>

<body onload="loadPanelData()" class="content">

<h1><%= emailActivityRB.get("emailTemplateDialogNewTitle") %></h1>

<form name="emailTemplateForm">

<input type="hidden" name="display" />

<p><label for="nameID"><%= emailActivityRB.get("emailTemplateDialogNameInput") %></label><br />
<input name="Name" id="nameID" type="text" size="50" maxlength="254" /> <br />
<br />

<label for="descriptionID"><%= emailActivityRB.get("emailTemplateDialogDescriptionLabel") %></label> <br />
<textarea name="Description" id="descriptionID" rows="4" cols="50" wrap="physical" onkeydown="limitTextArea(this.form.Description, 254);" onkeyup="limitTextArea(this.form.Description, 254);"></textarea> <br />
<br />
<label for="record">
<input name="Record" type="checkbox" id="record" /> </label>
<label for="isrecord"><%=emailActivityRB.get("recordEmails")%></label><br />
<% if (cmEmailFeature)  { %> 
<input name="linktoCM" type="checkbox" id="lntoCM"  onclick="toggleLinkTextbox(this)"/> 
<label for="lntoCM"><%=cmEmailActivityRB.get("recordEmailsWithCM")%></label><br /> 
<% } %>
<br />
<label for="emailSubjectID"><%= emailActivityRB.get("emailSubject") %></label><br />
<input name="EmailSubject" id="emailSubjectID" type="text" size="50" maxlength="256" />
<br />

<br /><br />

<label for="contentFormat"><%= emailActivityRB.get("contentFormat") %></label><br />
<label for="EmailFormat">
<input type="radio" id="EmailFormat" name="EmailFormat" value="<%=EmailTemplateConstants.HTML_FORMAT %>" checked onclick="javascript:showHTMLDiv()" id="htmlFormat" /></label>
<%=emailActivityRB.get("htmlFormat")%>

<input type="radio" id="EmailFormat" name="EmailFormat" value="<%=EmailTemplateConstants.PLAIN_TEXT_FORMAT %>" onclick="javascript:showWarning();showPlainTextDiv()" id="plainText" />
<%=emailActivityRB.get("plainText")%>
<br /><br />

<Div id="htmlSelect" style="display:none;">
<label for="emailContentLabel"><%= emailActivityRB.get("emailContentLabel") %></label><br /><br/>
<label for="attributes"><%= emailActivityRB.get("attributes") %><br/></label>
<select name="attributesList" id="attributes"
onchange = javascript:showHideHtmlDivs()>
<option value="<%=EmailTemplateConstants.FIRST_NAME %>"><%= emailActivityRB.get("firstName") %></option>
<option value="<%=EmailTemplateConstants.LAST_NAME %>"><%= emailActivityRB.get("lastName") %></option>
<option value="<%=EmailTemplateConstants.LINK %>"><%= emailActivityRB.get("link") %></option>
<option value="<%=EmailTemplateConstants.CONTENT %>"><%= emailActivityRB.get("contentSpot") %></option>
<option value="<%=EmailTemplateConstants.EMSPOT %>"><%= emailActivityRB.get("emarketingSpot") %></option>
</select> 
<br />

<%@ include file = "EmailTemplateLinkDiv.jspf"%>
<%@ include file = "EmailTemplateContentMarketingDiv.jspf" %>

<!-- end of html select.. -->
</Div>

<Div id="plainTextSelect" style="display:none;">
<label for="emailContentLabelPT"><%= emailActivityRB.get("emailContentLabel") %></label><br /><br/>
<label for="attributesPT"><%= emailActivityRB.get("attributesPT") %><br/></label>
<select name="attributesListPT" id="attributesPT"onchange = javascript:showHidePTDivs()>
<option value="<%=EmailTemplateConstants.FIRST_NAME %>"><%= emailActivityRB.get("firstName") %></option>
<option value="<%=EmailTemplateConstants.LAST_NAME %>"><%= emailActivityRB.get("lastName") %></option>
<option value="<%=EmailTemplateConstants.LINK %>"><%= emailActivityRB.get("link") %></option>
</select>
<br />
<!-- div for link option in plain text -->
<Div id="linkSelectPT" style="display:none;margin-left: 22">
<label for="urlPT"><%= emailActivityRB.get("urlPT")%><br/></label>
<input name="urlPT" id="urlPT" type="text" size="50" maxlength="254" /> 
<br/><br/>

<input name="recordClicksForURLPT" type="checkbox" id="recordClicks" /> <label for="recordClicks"><%=emailActivityRB.get("recordClicks")%></label><br /> 

<!-- end of div for link option in plain text -->

</div>
<!-- end of div for plain text... -->
</Div>

<br/>
<% if (cmEmailFeature) { %>
<Div id="linkNameDisplayForCM">
<label for="lnName"><%=cmEmailActivityRB.get("cmLinkName")%><br/></label>
<input name="linkNameForCM" id="lnName" type="text" size="50" maxlength="254" />&nbsp;
</Div>
<br/>
<% } %>
<table>
<tr>
<td align = left valign = bottom> 
<button value='<%=emailActivityRB.get("insert")%>' name="insert" onclick="javascript:constructTag()" class="general" style="text-align: left; padding-left: 5px;">&nbsp;<%=emailActivityRB.get("insert")%></button>
</td>
<td align = right valign = bottom>
<button value='<%=emailActivityRB.get("previewTemplate")%>' name="previewTemplateButton" onclick="javascript:previewTemplate()" class="general" style="text-align: center; padding-left: 5px;">&nbsp;<%=emailActivityRB.get("previewTemplate")%></button>
</td>
</tr>
<tr>

<td colspan="2">
<label for="emailContent">
<textarea name="EmailContent" id="emailContent" rows="6" cols="100" wrap="physical"  onkeydown="limitTextArea(this.form.emailContent, 10000);" onkeyup="limitTextArea(this.form.emailContent, 10000);"></textarea></label> 
</td>
</table>
</form>
</body>
</html>
