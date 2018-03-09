<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<HTML>
<HEAD>

<%@ page import = "java.util.*" %>
<%@ page import = "com.ibm.commerce.command.CommandContext" %>
<%@ page import = "com.ibm.commerce.tools.util.*" %>

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	com.ibm.commerce.server.JSPHelper helper = new com.ibm.commerce.server.JSPHelper(request);
	String strMessage    = helper.getParameter("SubmitFinishMessage");
%>
<TITLE><%=UIUtil.toHTML((String)rbCategory.get("ProductCatBottom_Title"))%></TITLE>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css"> 

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/ConvertToXML.js"></SCRIPT>

<SCRIPT>


	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called upon load of the frame it will also display any
	//   message that is returned from the server
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad()
	{
<%
		if (strMessage != null) 
		{ 
%>
			alertDialog("<%=UIUtil.toJavaScript(rbCategory.get(strMessage))%>");
<%
			if (strMessage.equals("msgProductCatUpdateCatgpenrelCmdFinished"))
			{
%>
				parent.closeProductCat();
<%
			}
		}
%>
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// saveButtonClick()
	//
	// - this function is called when the save button is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function saveButtonClick()
	{
		parent.categoryList.saveButtonClick();
	} 


	//////////////////////////////////////////////////////////////////////////////////////
	// cancelButtonClick()
	//
	// - this function is called when the cancel button is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function cancelButtonClick()
	{
		if (confirmDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("ProductCatBottom_CancelMsg"))%>"))
		{
			parent.closeProductCat();
		}
	} 


	//////////////////////////////////////////////////////////////////////////////////////
	// submitChanges(outputXML)
	//
	// @param outputXML - the object to be transformed into XML which represents the
	//                    changes to the product to catalog/category relationships
	//
	// - this function submits the changes to the server in XML form
	//////////////////////////////////////////////////////////////////////////////////////
	function submitChanges(outputXML)
	{
		form1.action = "ProductCatUpdateCatgpenrelCmd";
		form1.XML.value = convertToXML(outputXML, "XML");
		form1.submit();
	}


</SCRIPT>

</HEAD>

<BODY CLASS="button" ONLOAD=onLoad()>

	<FORM name="form1" ACTION="dummy" ONSUBMIT="return false;" METHOD="POST">
		<INPUT TYPE=HIDDEN NAME=XML VALUE="">
	</FORM>

	<TABLE WIDTH=100% HEIGHT=35 BORDER=0 CELLPADDING=0 CELLSPACING=0 >
		<TR VALIGN=MIDDLE WIDTH=100%>
			<TD ALIGN=RIGHT VALIGN=MIDDLE WIDTH=100%>
				<INPUT TYPE="button" NAME="saveButton"   VALUE="<%=UIUtil.toHTML((String)rbCategory.get("ProductCat_Save"))%>"   ID="dialog" onclick="saveButtonClick()">
				<INPUT TYPE="button" NAME="cancelButton" VALUE="<%=UIUtil.toHTML((String)rbCategory.get("ProductCat_Cancel"))%>" ID="dialog" onclick="cancelButtonClick()">
			</TD>
		</TR>
	</TABLE>
 
</BODY>
</HTML>
