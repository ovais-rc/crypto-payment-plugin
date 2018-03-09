<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.common.beans.StoreDataBean" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.user.beans.UserRegistrationDataBean" %>
<%@include file="../common/common.jsp" %>
<%@include file="../common/NumberFormat.jsp" %>

<%
try{
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale = cmdContext.getLocale();
	Hashtable returnsNLS = (Hashtable)ResourceDirectory.lookup("returns.ReturnsNLS", jLocale);
	JSPHelper jspHelper = new JSPHelper(request);

 	String jLanguageID = cmdContext.getLanguageId().toString();
 	
	StoreDataBean store = new StoreDataBean();
	store.setStoreId(cmdContext.getStoreId().toString());
	com.ibm.commerce.beans.DataBeanManager.activate(store, request);
	boolean isB2B = store.getStoreType() != null && (store.getStoreType().equals("B2B") || store.getStoreType().equals("BRH") || store.getStoreType().equals("BMH"));
	
	String memberId = jspHelper.getParameter("memberId");
	
	// This is the member id for the customer in the csa context.  
	//GK 22100
	String memberIdForCustomerInCSAContext = ( memberId != null ) ? memberId : "" ;
	
	String preCustomerLogonId = "";
	if ( memberId != null && !memberId.equals("") )
	{
		UserRegistrationDataBean userReg = new UserRegistrationDataBean();
		userReg.setUserId(memberId);
		com.ibm.commerce.beans.DataBeanManager.activate(userReg, request);
		preCustomerLogonId = userReg.getLogonId();
	}
%>

<HTML>
<HEAD>

<LINK REL="stylesheet" HREF="<%= UIUtil.getCSSFile(jLocale) %>"
	TYPE="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>
function init() 
{
   if (parent.setContentFrameLoaded) {
      parent.setContentFrameLoaded(true);
   }
}

function isNumber(word) 
{
	var numbers="0123456789";
	for (var i=0; i < word.length; i++)
	{
		if (numbers.indexOf(word.charAt(i)) == -1) 
		return false;
	}
	return true;
}

function findReturn()
{
	var isB2B = <%= isB2B %>;

	if (document.searchReturnForm.searchReturnNumber.value == "" &&
	    document.searchReturnForm.searchOrderNumber.value == "" &&
	    document.searchReturnForm.searchCustomerLogon.value == "" &&
	    <% if (isB2B) {%>document.searchReturnForm.searchContractName.value == "" &&<%}%>
	    document.searchReturnForm.searchReturnStatus.value == "" ) {
		alertDialog("<%= UIUtil.toJavaScript((String)returnsNLS.get("searchNoCriteria")) %>");
		return;
	}

	var returnNumberValue = document.searchReturnForm.searchReturnNumber.value;
	var orderNumberValue = document.searchReturnForm.searchOrderNumber.value;
	var languageID = "<%= jLanguageID %>";
	

	
	//If values are provided, make sure they only contain numeric digits (no alpha, no commas, etc)
	if ( returnNumberValue != "" && !isNumber(returnNumberValue) )
	{
		alertDialog("<%= UIUtil.toJavaScript((String)returnsNLS.get("returnNumberNotValidNumber")) %>");
		return;
	}
	else if ( orderNumberValue != "" && !isNumber(orderNumberValue) )
	{
		alertDialog("<%= UIUtil.toJavaScript((String)returnsNLS.get("orderNumberNotValidNumber")) %>");
		return;
	}

	var returnListURL = "/webapp/wcs/tools/servlet/NewDynamicListView";
	var p = new Object();
	
	if (isB2B) {
		if ("<%=memberIdForCustomerInCSAContext%>" == "")
			p["ActionXMLFile"] = "returns.returnListB2BNoFind";
		else
			p["ActionXMLFile"] = "returns.returnListB2B";
	} else {
		if ("<%=memberIdForCustomerInCSAContext%>" == "")
			p["ActionXMLFile"] = "returns.returnListB2CNoFind";
		else
			p["ActionXMLFile"] = "returns.returnListB2C";
	}
	
	p["cmd"] = "ReturnList";	
	
	p["searchReturnNumber"] = returnNumberValue;
	p["searchOrderNumber"] = orderNumberValue;
	
	if (validateLength(document.searchReturnForm.searchCustomerLogon.value, 31))
		p["searchCustomerLogon"] = document.searchReturnForm.searchCustomerLogon.value;
	else {
		document.searchReturnForm.searchCustomerLogon.focus();
		return;
	}
	
	//GK 22100
	var memberIdForCustomerInCSAContext = "<%=memberIdForCustomerInCSAContext%>";
	p["memberIdForCustomerInCSAContext"] = memberIdForCustomerInCSAContext;
		
	if (isB2B) {
		if (validateLength(document.searchReturnForm.searchContractName.value, 254))
			p["searchContractName"] = document.searchReturnForm.searchContractName.value;
		else {
			document.searchReturnForm.searchContractName.focus();
			return;
		}
	}
	
	p["searchReturnStatus"] = document.searchReturnForm.searchReturnStatus.value;
	
	top.setContent("<%= UIUtil.toHTML((String)returnsNLS.get("returnSearchResultBCT")) %>", returnListURL, true, p);
}
function closeDialog()
{
	top.goBack();
}
function validateLength(text, size)
{
	if (!isValidUTF8length(text, size))
	{
		alertDialog("<%= UIUtil.toJavaScript( (String)returnsNLS.get("TextExceedMaxLengthMsg")) %>");					
		return false;		
	}
	return true;
}
</SCRIPT>

<TITLE><%= UIUtil.toHTML((String)returnsNLS.get("returnSearchTitle")) %></TITLE>

</HEAD>

<BODY onLoad="init();" class="content">

<H1><%= UIUtil.toHTML((String)returnsNLS.get("returnSearchTitle")) %></H1>

<DIV><%= (String)returnsNLS.get("returnSearchLabelInHTML") %></DIV>
<BR>

<FORM name="searchReturnForm">

<TABLE>
	<TR>
		<TD><label for="searchReturnNumber"><%= UIUtil.toHTML((String)returnsNLS.get("searchReturnNumber")) %></label>
		</TD>
	</TR>
	<TR>
		<TD><INPUT size="28" maxlength="19" type="text"
			name="searchReturnNumber" id="searchReturnNumber"></TD>
	</TR>
	<TR>
		<TD></TD>
	</TR>

	<TR>
		<TD><label for="searchOrderNumber"><%= UIUtil.toHTML((String)returnsNLS.get("searchOrderNumber")) %></label>
		</TD>
	</TR>
	<TR>
		<TD><INPUT size="28" maxlength="19" type="text"
			name="searchOrderNumber" id="searchOrderNumber"></TD>
	</TR>
	<TR>
		<TD></TD>
	</TR>

	<TR>
		<TD><label for="searchCustomerLogon"><%= UIUtil.toHTML((String)returnsNLS.get("searchCustomerLogon")) %></label>
		</TD>
	</TR>
	<TR>
		<TD><INPUT size="28" maxlength="31" type="text"
			name="searchCustomerLogon" id="searchCustomerLogon"></TD>
	</TR>
	<TR>
		<TD></TD>
	</TR>

	<% if (isB2B) {
%>
	<TR>
		<TD><label for="searchContractName"><%= UIUtil.toHTML((String)returnsNLS.get("searchContractName")) %></label>
		</TD>
	</TR>
	<TR>
		<TD><INPUT size="28" maxlength="254" type="text"
			name="searchContractName" id="searchContractName"></TD>
	</TR>
	<TR>
		<TD></TD>
	</TR>
	<% }
%>

	<TR>
		<TD><label for="searchReturnStatus"><%= UIUtil.toHTML((String)returnsNLS.get("searchReturnStatus")) %></label>
		</TD>
	</TR>
	<TR>
		<TD><SELECT name="searchReturnStatus" id="searchReturnStatus" size=1>
			<OPTION value="" selected>
			<OPTION value="PRC"><%= UIUtil.toHTML((String)returnsNLS.get("searchStatusInProcess")) %>
			<OPTION value="PND"><%= UIUtil.toHTML((String)returnsNLS.get("searchStatusPending")) %>
			<OPTION value="APP"><%= UIUtil.toHTML((String)returnsNLS.get("searchStatusApproved")) %>
			<OPTION value="EDT"><%= UIUtil.toHTML((String)returnsNLS.get("searchStatusBeingEdited")) %>
			<OPTION value="CLO"><%= UIUtil.toHTML((String)returnsNLS.get("searchStatusClosed")) %>
			<OPTION value="CAN"><%= UIUtil.toHTML((String)returnsNLS.get("searchStatusCancelled")) %>
		</SELECT></TD>
	</TR>
	<TR>
		<TD></TD>
	</TR>
</TABLE>
</FORM>

</BODY>
<SCRIPT>
document.searchReturnForm.searchCustomerLogon.value="<%= UIUtil.toJavaScript(preCustomerLogonId) %>";
</SCRIPT>
</HTML>

<%
}
catch (Exception e)
{
         com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
}
%>
