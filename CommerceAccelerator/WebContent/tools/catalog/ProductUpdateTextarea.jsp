<%--
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
--%>

<%@ page language="java" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>


<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbProduct = (Hashtable)ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
	String catentryId = request.getParameter("catentryId"); 
	String cellIndex  = request.getParameter("cellIndex"); 
	Integer defaultLanguageId = cmdContext.getStore().getLanguageIdInEntityType();

	CatalogEntryDataBean bnEntry = new CatalogEntryDataBean();
	bnEntry.setCatalogEntryID(catentryId);
	DataBeanManager.activate(bnEntry, cmdContext);

	CatalogEntryDescriptionAccessBean abDefaultDescription = new CatalogEntryDescriptionAccessBean();
	abDefaultDescription = bnEntry.getDescription(defaultLanguageId);

	String strTitle = "";
	String strDefaultValue = "";

	if (cellIndex.equals("name")) 
	{
		strTitle        = (String)rbProduct.get("productUpdateDetail_Name");
		strDefaultValue = abDefaultDescription.getName();
	}
	if (cellIndex.equals("shortDescription")) 
	{
		strTitle        = (String)rbProduct.get("productUpdateDetail_ShortDesc");
		strDefaultValue = abDefaultDescription.getShortDescription();
	}
	if (cellIndex.equals("longDescription")) 
	{
		strTitle        = (String)rbProduct.get("productUpdateDetail_LongDesc");
		strDefaultValue = abDefaultDescription.getLongDescription();
	}
	if (cellIndex.equals("auxDescription1")) 
	{
		strTitle        = (String)rbProduct.get("productUpdateDetail_Aux1Desc");
		strDefaultValue = abDefaultDescription.getAuxDescription1();
	}
	if (cellIndex.equals("auxDescription2")) 
	{
		strTitle        = (String)rbProduct.get("productUpdateDetail_Aux2Desc");
		strDefaultValue = abDefaultDescription.getAuxDescription2();
	}
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<HTML>
<HEAD>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">
<TITLE><%=UIUtil.toHTML((String)rbProduct.get("ProductUpdateContextMenu_SetColumnValue"))%></TITLE>

<SCRIPT>

function okButton()
{
	var frameName = top.getData("ProductLineUpdate_FrameName");
	parent.cmEdit_Textarea(idText.value);
	parent.document.all.textareaIframe.style.display = "none";
	idTitle.value = "";
	displayText.value = "";
	idText.value = "";
}

function cancelButton()
{
   parent.document.all.textareaIframe.style.display = "none";
	idTitle.value = "";
	displayText.value = "";
	idText.value = "";
}

function onLoad()
{
	idText.value = parent.toolbarCurrentElement.value;

	parent.document.all.textareaIframe.style.width  = document.body.scrollWidth;
	parent.document.all.textareaIframe.style.height = document.body.scrollHeight;
}

</SCRIPT>

</HEAD>

<STYLE>
TEXTAREA.updateCellTextArea  { font-family: Verdana,Arial,Helvetica; font-style: italic; font-size: 8pt; color: #6D6D7C; width: 90%; height: 100%; border-width: 0 0 0 0;}
TEXTAREA.updateCellTextArea  { font-family: Verdana,Arial,Helvetica; font-size: 8pt; color: Black; width: 90%; height: 100%; border-width: 0 0 0 0;}
</STYLE>

<BODY class="content" STYLE="margin: 0px" ONLOAD="onLoad();" ONCONTEXTMENU="return false;">
<TABLE WIDTH=100% CELLPADDING=0 CELLSPACING=0 border=0>
	<TR HEIGHT=20 STYLE="font-family: Verdana; font-size: 9pt; color:black; background-color:#D1D1D9" >
		<TD WIDTH=10></TD>
		<TD ID=idTitle STYLE="font-family: Verdana; font-size: 9pt; color:black;" >
			<%= UIUtil.toHTML(strTitle) %>
		</TD>
	</TR>
</TABLE>

<TABLE WIDTH=100% CELLPADDING=0 CELLSPACING=0>
<TR VALIGN=TOP>
	<TD ALIGN=CENTER>
		<TABLE ID=idTable WIDTH=100% BORDER=0 CELLPADDING=0 CELLSPACING=0>
		<TR HEIGHT=10><TD COLSPAN=3></TD></TR>
		<TR STYLE="height:90px;">
			<TD WIDTH=10></TD>
			<TD>
			    <label for="displayText"  class="hidden-label"><%=UIUtil.toHTML((String)rbProduct.get("ProductUpdateTextarea_label_default_store_data"))%></label>
				<TEXTAREA ID="displayText" CLASS=updateCellTextArea ROWS=5 STYLE="width:100%; overflow:auto;" CONTENTEDITABLE=false><%= UIUtil.toHTML(strDefaultValue) %></TEXTAREA>
			</TD>
			<TD WIDTH=10></TD>
		</TR>
		<TR HEIGHT=20><TD COLSPAN=3></TD></TR>
		<TR>
			<TD WIDTH=10></TD>
			<TD>
				<label for="idText" class="hidden-label"><%=UIUtil.toHTML((String)rbProduct.get("ProductUpdateTextarea_label_editable_data"))%></label>
				<TEXTAREA ID="idText" ROWS=5 STYLE="width:100%; overflow:auto;"></TEXTAREA>
			</TD>
			<TD WIDTH=10></TD>
		</TR>
		</TABLE>
	</TD>
</TR>
<TR HEIGHT=20><TD COLSPAN=3></TD></TR>
<TR HEIGHT=36>
	<TD class="button">
		<TABLE WIDTH=100% BORDER=0 CELLPADDING=0 CELLSPACING=2>
		<tr><td class=dottedLine height="1" colspan=10 width=100%></td></tr>
		<TR VALIGN=MIDDLE>
			<TD ALIGN=RIGHT VALIGN=MIDDLE>
				<BUTTON NAME="okButton" ID="dialog" onclick="okButton()" style="height:20px; cursor: default;"><%=UIUtil.toHTML((String)rbProduct.get("OK"))%></BUTTON>
				&nbsp;
				<BUTTON NAME="cancelButton" ID="dialog" onclick="cancelButton()" style="height:20px; cursor: default;"><%=UIUtil.toHTML((String)rbProduct.get("Cancel"))%></BUTTON>
			</TD>
		</TR>
		<tr><td class=dottedLine height="1" colspan=10 width=100%></td></tr>
		</TABLE>
	</TD>
</TR>
</TABLE>
</BODY>
</HTML>

