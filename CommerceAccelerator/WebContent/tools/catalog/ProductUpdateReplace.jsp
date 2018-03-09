<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002, 2003
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

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbProduct = (Hashtable)ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<HTML>
<HEAD>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">
<TITLE><%=UIUtil.toHTML((String)rbProduct.get("ProductUpdateReplace"))%></TITLE>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

<SCRIPT> 
	
	var currentElement = null;
	var currentRow = 0, currentCell = 0;

	function okButton() 
	{
		if (inputFind.value == "") 
		{ 
			alertDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("ProductUpdateReplace_NoFindString")) %>"); 
			return; 
		}

		if (currentRow >= 0)
		{
			for (var i=1; i<parent.dTable.rows.length; i++)
			{
				if (i == currentRow) continue;
				parent.dTable.rows(i).cells(currentCell).style.backgroundColor = "";
			}
		}

		parent.document.all.replaceIframe.style.display = "none";
		var results = parent.okButtonReplace(inputFind.value, inputReplace.value, replaceWhat[0].checked, replaceWhat[2].checked);
		if (replaceWhat[0].checked == false) alertDialog(replaceField("<%= UIUtil.toJavaScript((String)rbProduct.get("ProductUpdateReplace_ReplaceSuccessful")) %>", "?", results));
	}

	function cancelButton()
	{
		if (currentRow >= 0)
		{
			for (var i=1; i<parent.dTable.rows.length; i++)
			{
				if (i == currentRow) continue;
				if (currentCell != 0) parent.dTable.rows(i).cells(currentCell).style.backgroundColor = "";
			}
		}
		parent.document.all.replaceIframe.style.display = "none";
	}

	function replaceField(source, pattern, replacement) 
	{
		index1 = source.indexOf(pattern);
		index2 = index1 + pattern.length;
		return source.substring(0, index1) + replacement + source.substring(index2);
	}

	function setElementType(element)
	{
		currentCell = -1;
		currentRow = -1;

		if (!element || !element.tagName || element.tagName != "TEXTAREA")
		{
			replaceAll.checked = true;
			replaceSelected.disabled = true;
			replaceColumn.disabled = true;
		} else {
			replaceSelected.disabled = false;
			replaceSelected.checked = true;
			replaceColumn.disabled = false;
		}

		currentElement = element;
	}

	function fcnOnClick(element)
	{
		if (!currentElement) return;
		currentCell = currentElement.parentNode.cellIndex;
		currentRow = currentElement.parentNode.parentNode.rowIndex;
		if (element.id == "replaceColumn")
		{
			for (var i=1; i<parent.dTable.rows.length; i++)
			{
				if (i == currentRow) continue;
				parent.dTable.rows(i).cells(currentCell).style.backgroundColor = "#ACD5F8";
			}
		} else {
			for (var i=1; i<parent.dTable.rows.length; i++)
			{
				if (i == currentRow) continue;
				parent.dTable.rows(i).cells(currentCell).style.backgroundColor = "";
			}
		}
	}

	function setElementFocus(element)
	{

		if (currentRow >= 0)
		{
			for (var i=1; i<parent.dTable.rows.length; i++)
			{
				if (i == element.parentNode.parentNode.rowIndex) continue;
				parent.dTable.rows(i).cells(currentCell).style.backgroundColor = "";
			}
		}

		if (!element || !element.tagName || element.tagName != "TEXTAREA")
		{
			replaceAll.checked = true;
			replaceSelected.disabled = true;
			replaceColumn.disabled = true;
		} else {
			replaceSelected.disabled = false;
			replaceColumn.disabled = false;
		}

		currentElement = element;

		if (replaceColumn.checked)
		{
			currentCell = element.parentNode.cellIndex;
			currentRow = element.parentNode.parentNode.rowIndex;

			for (var i=1; i<parent.dTable.rows.length; i++)
			{
				if (i == currentRow) continue;
				parent.dTable.rows(i).cells(currentCell).style.backgroundColor = "#ACD5F8";
			}
		}

	}


</SCRIPT>
</HEAD>

<BODY class="content" STYLE="margin: 0" ONCONTEXTMENU="return false;">

<TABLE BORDER=0 CELLPADDING=0 CELLSPACING=0 WIDTH=100%>
	<TR HEIGHT=20 STYLE="font-family: Verdana; font-size: 9pt; color:white; background-color:#D1D1D9" >
		<TD WIDTH=10>&nbsp</TD>
		<TD STYLE="font-family: Verdana; font-size: 9pt; color:black;" >
			<%=UIUtil.toHTML((String)rbProduct.get("ProductUpdateReplace"))%>&nbsp;
		</TD>
		<TD>&nbsp</TD>
	</TR>
	<TR HEIGHT=20><TD COLSPAN=3></TD></TR>
	<TR VALIGN=TOP>
		<TD WIDTH=10></TD>
		<TD NOWRAP>
			<label for="inputFindId"><%= UIUtil.toHTML((String)rbProduct.get("ProductUpdateReplace_Find")) %>&nbsp;</label>
		</TD>
		<TD>
			<INPUT NAME="inputFind" id="inputFindId" STYLE="width: 200;">
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=10></TD>
		<TD NOWRAP>
			<label for="inputReplaceId"><%= UIUtil.toHTML((String)rbProduct.get("ProductUpdateReplace_Replace")) %>&nbsp;</label>
		</TD>
		<TD>
			<INPUT NAME="inputReplace" id="inputReplaceId" STYLE="width: 200;">
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD></TD>
		<TD></TD>
		<TD>
			<INPUT TYPE=CHECKBOX ID="caseCheckbox" CHECKED><label for="caseCheckbox"><%= UIUtil.toHTML((String)rbProduct.get("ProductUpdateReplace_Case")) %>&nbsp;</label>
		</TD>
	</TR>
	<TR HEIGHT=10><TD COLSPAN=3></TD></TR>
	<TR VALIGN=TOP>
		<TD WIDTH=10></TD>
		<TD COLSPAN=3 NOWRAP>
			<INPUT TYPE=RADIO ID="replaceSelected" ONCLICK=fcnOnClick(this) NAME=replaceWhat CHECKED><label for="replaceSelected"><%= UIUtil.toHTML((String)rbProduct.get("ProductUpdateReplace_Selected")) %></label>
			<INPUT TYPE=RADIO ID="replaceAll"      ONCLICK=fcnOnClick(this) NAME=replaceWhat><label for="replaceAll"><%= UIUtil.toHTML((String)rbProduct.get("ProductUpdateReplace_All")) %></label>
			<INPUT TYPE=RADIO ID="replaceColumn"   ONCLICK=fcnOnClick(this) NAME=replaceWhat><label for="replaceColumn"><%= UIUtil.toHTML((String)rbProduct.get("ProductUpdateReplace_Column")) %></label>
		</TD>
	</TR>
	<TR HEIGHT=20><TD COLSPAN=3></TD></TR>
	<TR HEIGHT=40>
		<TD class="button" COLSPAN=3>
			<TABLE WIDTH=100% BORDER=0 CELLPADDING=0 CELLSPACING=2 >
			<tr><td class=dottedLine height="1" colspan=10 width=100%></td></tr>
			<TR VALIGN=MIDDLE>
				<TD ALIGN=RIGHT VALIGN=MIDDLE>
					<BUTTON NAME="okButton" ID="dialog" onclick="okButton()" style="height:20px; cursor: default;"><%= UIUtil.toHTML((String)rbProduct.get("OK")) %></BUTTON>
					&nbsp;
					<BUTTON NAME="cancelButton" ID="dialog" onclick="cancelButton()" style="height:20px; cursor: default;"><%= UIUtil.toHTML((String)rbProduct.get("Cancel")) %></BUTTON>
				</TD>
			</TR>
			<tr><td class=dottedLine height="1" colspan=10 width=100%></td></tr>
			</TABLE>
		</TD>
	</TR>
</TABLE>

</BODY>
</HTML>
