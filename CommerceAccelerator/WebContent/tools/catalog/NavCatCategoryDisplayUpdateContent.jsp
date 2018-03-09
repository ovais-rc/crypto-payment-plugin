<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2003, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<%@ page language="java" %>

<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.base.objects.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>

<%@include file="../common/common.jsp" %>

<%
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Get the command context
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable) ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	com.ibm.commerce.server.JSPHelper helper = new com.ibm.commerce.server.JSPHelper(request);
	String strTemplateId = helper.getParameter("templateId");

	Integer [] iLanguages = cmdContext.getStore().getSupportedLanguageIds();
	CatalogGroupPageRelationAccessBean abRelation = new CatalogGroupPageRelationAccessBean();
	abRelation.setInitKey_displayReferenceNumber(strTemplateId);

	String strPageName    = abRelation.getPageName();
	String strDescription = abRelation.getDescription();
	String strField1      = abRelation.getField1();
	String strField2      = abRelation.getField2();
	String strDevice      = abRelation.getDevicetype_id();
	Integer iLanguage     = abRelation.getLanguageIdInEntityType();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>

<STYLE type='text/css'>
	.selectWidth {width: 200px;}
</STYLE>

<HEAD>

	<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoryDisplayUpdateContent_Title"))%></TITLE>
	<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

	<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

<SCRIPT>


	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called when the frame is loaded
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad () 
	{
		PageName.focus();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// validateParameters()
	//
	// - this function validates the parameters for the save
	//////////////////////////////////////////////////////////////////////////////////////
	function validateParameters()
	{
		if (isInputStringEmpty(PageName.value))
		{
			alertDialog("<%=UIUtil.toJavaScript(rbCategory.get("NavCatCategoryDisplayCreateContent_NoPageName"))%>");
			return false;
		}

		if (isValidUTF8length(PageName.value, 254) == false) 
		{ 
			alertDialog("<%= UIUtil.toJavaScript((String)rbCategory.get("fieldSizeExceeded"))%>"); 
			PageName.focus();
			return false;
		}

		if (isValidUTF8length(Description.value, 254) == false) 
		{ 
			alertDialog("<%= UIUtil.toJavaScript((String)rbCategory.get("fieldSizeExceeded"))%>"); 
			Description.focus();
			return false;
		}

		if (isValidUTF8length(Field1.value, 254) == false) 
		{ 
			alertDialog("<%= UIUtil.toJavaScript((String)rbCategory.get("fieldSizeExceeded"))%>"); 
			Field1.focus();
			return false;
		}

		if (isValidUTF8length(Field2.value, 254) == false) 
		{ 
			alertDialog("<%= UIUtil.toJavaScript((String)rbCategory.get("fieldSizeExceeded"))%>"); 
			Field2.focus();
			return false;
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// okButton()
	//
	// - this function saves the changes
	//////////////////////////////////////////////////////////////////////////////////////
	function okButton()
	{
		if (validateParameters() == false) return;
		
		var obj = new Object();
		obj.templateId = "<%=strTemplateId%>";
		obj.pagename = PageName.value;
		obj.device = deviceSelect.value;
		obj.description = Description.value;

		if (languageSelect.value != "null") obj.language = languageSelect.value;
		if (!isInputStringEmpty(Field1.value)) obj.field1 = Field1.value;
		if (!isInputStringEmpty(Field2.value)) obj.field2 = Field2.value;

		parent.categoryDisplayBottom.submitFunction("NavCatCategoryDisplayUpdateControllerCmd", obj);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// handleEnterPressed() 
	//
	// - perform a default action if the enter key is pressed
	//////////////////////////////////////////////////////////////////////////////////////
	function handleEnterPressed() 
	{
		if(event.keyCode != 13) return;
		okButton();
	}



</SCRIPT>
</HEAD>

<BODY CLASS=content ONLOAD=onLoad() ONKEYPRESS=handleEnterPressed() ONCONTEXTMENU="return false;">

	<H1><%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoryDisplayUpdateContent_H1"))%></H1>

	<LABEL for="PageName"><%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoryDisplayCreateContent_PageName"))%></LABEL>&nbsp;<%=UIUtil.toHTML((String)rbCategory.get("CatalogFieldLabelRequired"))%>
	<BR>
	<INPUT SIZE=32 MAXLENGTH=254 ID="PageName" NAME=PageName VALUE="<%=UIUtil.toHTML(strPageName)%>">
	<BR>
	<BR>
	<TABLE CELLPADDING=0 CELLSPACING=0>
		<TR>
			<TD ALIGN=LEFT VALIGN=CENTER >
				<LABEL for="languageSelect"><%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoryDisplayCreateContent_SelectedLanguage"))%></LABEL>
			</TD>
			<TD WIDTH=100>&nbsp;</TD>
			<TD ALIGN=LEFT VALIGN=CENTER >
				<LABEL for="deviceSelect"><%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoryDisplayCreateContent_SelectedDevice"))%></LABEL>
			</TD>
		</TR>
		<TR>
			<TD ALIGN=LEFT VALIGN=CENTER >
				<SELECT ID="languageSelect" NAME=languageSelect>
<%
				if (iLanguage == null)
				{
%>
					<OPTION VALUE="null" SELECTED><%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoryDisplayCreateContent_AllLanguages"))%>
<%
				} else {
%>
					<OPTION VALUE="null"><%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoryDisplayCreateContent_AllLanguages"))%>
<%
				}

				for (int i=0; i<iLanguages.length; i++)
				{
					LanguageDescriptionAccessBean abLanguage = new LanguageDescriptionAccessBean();
					abLanguage.setInitKey_languageId(cmdContext.getLanguageId().toString());
					abLanguage.setInitKey_descriptionLanguageId(iLanguages[i].toString());
					String strLanguage = abLanguage.getDescription();
					if (iLanguage != null && iLanguages[i].intValue() == iLanguage.intValue())
					{
%>
						<OPTION VALUE="<%=iLanguages[i]%>" SELECTED><%=UIUtil.toHTML(strLanguage)%>
<%
					} else {
%>
						<OPTION VALUE="<%=iLanguages[i]%>"><%=UIUtil.toHTML(strLanguage)%>
<%
					}
		}
%>
				</SELECT>
			</TD>
			<TD WIDTH=100>&nbsp;</TD>
			<TD ALIGN=LEFT VALIGN=CENTER >
				<SELECT ID="deviceSelect" NAME=deviceSelect>
<%
				DeviceFormatAccessBean abDevices = new DeviceFormatAccessBean();
				Enumeration e = abDevices.findAll();
				while (e.hasMoreElements())
				{
					DeviceFormatAccessBean abDevice = (DeviceFormatAccessBean) e.nextElement();
					String strDev = abDevice.getDeviceTypeId();
					if (abDevice.getDeviceFormatId().equals(strDevice))
					{
%>
						<OPTION VALUE="<%=abDevice.getDeviceFormatId()%>" SELECTED><%=UIUtil.toHTML(strDev)%>
<%
					} 
					else
					{
%>
						<OPTION VALUE="<%=abDevice.getDeviceFormatId()%>"><%=UIUtil.toHTML(strDev)%>
<%
					}
				}
%>
				</SELECT>
			</TD>
		</TR>
	</TABLE>
	<BR>
	<BR>
	<LABEL for="Description"><%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoryDisplayCreateContent_Description"))%></LABEL>
	<BR>
	<TEXTAREA COLS=64 ROWS=4 ID="Description" NAME=Description><%=UIUtil.toHTML(strDescription)%></TEXTAREA>
	<BR>
	<BR>
	<LABEL for="Field1"><%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoryDisplayCreateContent_Field1"))%></LABEL>
	<BR>
	<INPUT SIZE=64 MAXLENGTH=254 ID="Field1" NAME=Field1 VALUE="<%=UIUtil.toHTML(strField1)%>">
	<BR>
	<BR>
	<LABEL for="Field2"><%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoryDisplayCreateContent_Field2"))%></LABEL>
	<BR>
	<INPUT SIZE=64 MAXLENGTH=254 ID="Field2" NAME=Field2 VALUE="<%=UIUtil.toHTML(strField2)%>">

</BODY>
</HTML>
