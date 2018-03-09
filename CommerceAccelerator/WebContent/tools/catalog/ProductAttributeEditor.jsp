<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//* 
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>

<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.common.beans.LanguageDescriptionDataBean"%>
<%@ page import="com.ibm.commerce.catalog.beans.ProductDataBean" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.ras.*" %>

<%@include file="../common/common.jsp" %>
<%
   	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbProduct = (Hashtable)ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
	JSPHelper jsphelper = new JSPHelper(request);
   	String catentryID  	= jsphelper.getParameter("catentryID"); 
   	String catentryType	= jsphelper.getParameter("catentryType");
   	String attributeType 	= jsphelper.getParameter("attributeType");
   	String strReadonly 	= jsphelper.getParameter("readonlyAccess");
   	String finishMessage	= jsphelper.getParameter("SubmitFinishMessage");

	try {
		ProductDataBean bnProduct = new ProductDataBean();
		bnProduct.setProductID(catentryID);
		DataBeanManager.activate(bnProduct, cmdContext);
		bnProduct.setAdminMode(true);
	} catch (Exception ex) {
	  	ECTrace.trace(ECTraceIdentifiers.COMPONENT_CATALOGTOOL, this.getClass().getName(), "main",
					"Exception retrieving catentry " + catentryID);			  
	}

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>

<HEAD>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>
// The language array takes the language index within the table and returns the language representation
// within the database
// e.g.  For US English as the default store language:
//			language index = 0
//			language = -1
var languages = new Array();
var currentLanguage 		= <%=cmdContext.getStore().getLanguageIdInEntityType()%>
var currentLanguageIndex 	= 0;

var attributeChanged = false;
var DOIOWN = true;
var readonlyAccess = <%=strReadonly%>;

////////////////////////////////////////////////////////////////////////////////////////////////
// setDOIOWN(tf)
//
// - set the DOIOWN variable
////////////////////////////////////////////////////////////////////////////////////////////////
function setDOIOWN(tf)
{
	DOIOWN = tf;
}

////////////////////////////////////////////////////////////////////////////////////////////////
// getDOIOWN()
//
// - return the DOIOWN variable
////////////////////////////////////////////////////////////////////////////////////////////////
function getDOIOWN()
{
	return DOIOWN;
}

////////////////////////////////////////////////////////////////////////////////////////////////
// setItems()
//
// - displays all the items associated with the product
////////////////////////////////////////////////////////////////////////////////////////////////
function setItems()
{
	//parent.setContentFrameLoaded(true);
//	document.all.frameItems.src = "/webapp/wcs/tools/servlet/ProductUpdateAttribute3"+document.location.search;
	document.all.frameItems.src = "/webapp/wcs/tools/servlet/ProductUpdateAttribute3?catentryID=<%=catentryID%>&catentryType=<%=catentryType%>&attributeType=<%=attributeType%>&finishMessage=<%=UIUtil.toJavaScript((String)finishMessage)%>";
}

////////////////////////////////////////////////////////////////////////////////////////////////
// setAttributes()
//
// - displays all the attributes associated with the product
////////////////////////////////////////////////////////////////////////////////////////////////
function setAttributes() {
//	document.all.frameProduct.src = "/webapp/wcs/tools/servlet/ProductUpdateAttribute2"+document.location.search;
	document.all.frameProduct.src = "/webapp/wcs/tools/servlet/ProductUpdateAttribute2?catentryID=<%=catentryID%>&catentryType=<%=catentryType%>&attributeType=<%=attributeType%>";
}

////////////////////////////////////////////////////////////////////////////////////////////////
// setCurrentLanguage(key)
//
// - set the current language with the table index
////////////////////////////////////////////////////////////////////////////////////////////////
function setCurrentLanguage(key) {
	currentLanguageIndex = key;
	currentLanguage		 = languages[currentLanguageIndex];

	frameProduct.displayLanguage();
	frameItems.displayLanguage();
}

////////////////////////////////////////////////////////////////////////////////////////////////
// getCurrentLanguage
//
// - get the current language
////////////////////////////////////////////////////////////////////////////////////////////////
function getCurrentLanguage() {
	return currentLanguage;
}

////////////////////////////////////////////////////////////////////////////////////////////////
// getLanguage(key)
//
// - get the language based on the key
////////////////////////////////////////////////////////////////////////////////////////////////
function getLanguage(key) {
	return languages[key];
}

////////////////////////////////////////////////////////////////////////////////////////////////
// saveAction()
//
// - save action
////////////////////////////////////////////////////////////////////////////////////////////////
function saveAction() {
	if (frameItems.duplicatesExist()) {
		alertDialog('<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_duplicateSKUExistErrorMsg"))%>');
	} else {
		frameItems.submitUpdate();
//		top.saveModel(parent.parent.model);		
//		top.setReturningPanel(parent.getCurrentPanelAttribute("name"));
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////
// saveButton()
//
// - save button action
////////////////////////////////////////////////////////////////////////////////////////////////
function saveButton() {
	if (attributeChanged && DOIOWN == true) {
		saveAction();
	} else {
		alertDialog("<%=UIUtil.toJavaScript((String)rbProduct.get("descriptiveAttributeNoChangesToSave"))%>");
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////
// okButton()
//
// - ok button action
////////////////////////////////////////////////////////////////////////////////////////////////
function okButton() {
	if (attributeChanged) {
		saveAction();
	}
	top.goBack();
}

///////////////////////////////////////////////////////////////////////////////////////////////
// cancelButton()
//
// - cancel button action
////////////////////////////////////////////////////////////////////////////////////////////////
function cancelButton() {
	if (frameItems.hasMissingValuesForDefaultLanguage() == true) 
	{
		alertDialog('<%=UIUtil.toJavaScript((String)rbProduct.get("msgDescriptiveAttribute_AttributeNoValueSelected"))%>');
		return;
	}
	if (!attributeChanged || top.confirmDialog('<%=UIUtil.toJavaScript((String)rbProduct.get("productUpdateDetailCancelConfirmation"))%>')) {
		top.goBack();
	}
}


function onLoad()
{
	if (readonlyAccess == true)
	{
		var btnSaveButton = parent.NAVIGATION.document.getElementsByName("attribute_button_saveButton");
		btnSaveButton.item(0).disabled = true;
	}
}

</SCRIPT>

</HEAD>


<FRAMESET BORDER=0 FRAMEBORDER=NO ID=frameset1 NAME=frameset1 ROWS="*,0,0" ONLOAD=onLoad()>
   <FRAME ID=frameTop  TITLE="<%= UIUtil.toHTML( (String)rbProduct.get("productUpdateDetail_AttributeEditor")) %>" NAME="<%= UIUtil.toHTML( (String)rbProduct.get("productUpdateDetail_AttributeEditor")) %>" 
   	  SRC="/webapp/wcs/tools/servlet/ProductUpdateAttribute1?catentryID=<%=catentryID%>&catentryType=<%=catentryType%>&attributeType=<%=attributeType%>">
   <FRAMESET BORDER=0 FRAMEBORDER=NO ID=frameset2 NAME=frameset2 COLS="*,140">
      <FRAME ID=frameProduct TITLE="<%= UIUtil.toHTML( (String)rbProduct.get("ProductAttributeEditor_FrameTitle_1")) %>" NAME="<%= UIUtil.toHTML( (String)rbProduct.get("ProductAttributeEditor_FrameTitle_1")) %>" SRC="/wcs/tools/common/blank.html">
      <FRAME ID=frameProductButton TITLE="<%= UIUtil.toHTML( (String)rbProduct.get("ProductAttributeEditor_FrameTitle_2")) %>" NAME="<%= UIUtil.toHTML( (String)rbProduct.get("ProductAttributeEditor_FrameTitle_2")) %>" SRC="/webapp/wcs/tools/servlet/ProductUpdateAttribute2Buttons">
   </FRAMESET>
   <FRAMESET BORDER=0 FRAMEBORDER=NO ID=frameset3 NAME=frameset3 COLS="*,140">
      <FRAME ID=frameItems TITLE="<%= UIUtil.toHTML( (String)rbProduct.get("ProductAttributeEditor_FrameTitle_3")) %>" NAME="<%= UIUtil.toHTML( (String)rbProduct.get("ProductAttributeEditor_FrameTitle_3")) %>" SRC="/wcs/tools/common/blank.html">
      <FRAME ID=frameItemsButton TITLE="<%= UIUtil.toHTML( (String)rbProduct.get("ProductAttributeEditor_FrameTitle_4")) %>" NAME="<%= UIUtil.toHTML( (String)rbProduct.get("ProductAttributeEditor_FrameTitle_4")) %>" SRC="/webapp/wcs/tools/servlet/ProductUpdateAttribute3Buttons">
   </FRAMESET>
</FRAMESET>

<SCRIPT>
	if (readonlyAccess == true)
	{
		frameset2.cols = "*,0";
		frameset3.cols = "*,0";
	}
</SCRIPT>

</HTML>

