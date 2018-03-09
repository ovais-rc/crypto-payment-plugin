<!--==========================================================================
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
===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page language="java"
	import="com.ibm.commerce.tools.util.UIUtil,
	com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.user.beans.AddressDataBean,
  com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.datatype.TypedProperty" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="ContractCommon.jsp" %>

<%
	String addressId = "";

	try
	{
	  TypedProperty requestProperties = (TypedProperty)request.getAttribute("RequestProperties");
	  if (requestProperties != null)
	  {
      addressId = (String)requestProperties.getString("AddressId");
	  }
	}
	catch (Exception e)
	{
	}

	AddressDataBean addressDb = new AddressDataBean();
	if (addressId != "")
	{
    	try
    	{
    	  addressDb.setAddressId(addressId);
    	  addressDb.setCommandContext(contractCommandContext);
		    addressDb.populate();
    	}
    	catch (Exception e)
    	{
    	}
	}
%>

<html>

<head>
<%= fHeader %>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">
<script LANGUAGE="JavaScript">

function showLoadingMsg(flag)
{
  if (flag == true)
  {
    if (parent.parent.setContentFrameLoaded)
    {
      parent.parent.setContentFrameLoaded(false);
    }
  	top.showProgressIndicator(true);
  	AddressDetailDiv.style.display = "none";
  	LoadingMsgDiv.style.display = "block";
  }
  else
  {
    if (parent.parent.setContentFrameLoaded)
    {
      parent.parent.setContentFrameLoaded(true);
    }
    top.showProgressIndicator(false);
  	LoadingMsgDiv.style.display = "none";
  	AddressDetailDiv.style.display = "block";
  }
}


</script>
</head>

<body class="content" onLoad="showLoadingMsg(false);">

<div id="LoadingMsgDiv" style="display: none">
  <%= contractsRB.get("generalLoadingMessage") %>
</div>

<div id="AddressDetailDiv" style="display: none; margin-left: 25">
<%
if (addressId != "")
{
%>
<table BORDER=0 id="AccountFinancialAddressDetailPanel_Table_1">
<tr>
<td VALIGN=TOP ALIGN=LEFT id="AccountFinancialAddressDetailPanel_TableCell_1">
<%= contractsRB.get("accountAddressDetailPrompt") %>
</td>
</tr>
<tr>
<td VALIGN=TOP ALIGN=LEFT id="AccountFinancialAddressDetailPanel_TableCell_2">
<%	// exclude the primary data in address table for the registered user
	// for the primary data, Address1 is equal to "-"
	if (!(addressDb.getAddress1()).equals("-")) {

		String strAddress1 = addressDb.getAddress1();
		String strAddress2 = addressDb.getAddress2();
		String strAddress3 = addressDb.getAddress3();
		String strCity = addressDb.getCity();
		String strState = addressDb.getStateProvDisplayName();
		String strCountry = addressDb.getCountryDisplayName();
		String strZipCode = addressDb.getZipCode();

		if (strAddress2 == null) strAddress2 = "";
		if (strAddress3 == null) strAddress3 = "";
		if (strState == null) strState = ""; %>

		<% if (fLocale.toString().equals("ja_JP")||fLocale.toString().equals("ko_KR")||fLocale.toString().equals("zh_CN")||fLocale.toString().equals("zh_TW")) { %>

			<%=strCountry%>&nbsp;<%=strZipCode%><br>
			<%=strState%>&nbsp;<%=strCity%><br>
			<%=strAddress1%>&nbsp;<%=strAddress2%>&nbsp;<%=strAddress3%><br>

		<% } else if (fLocale.toString().equals("fr_FR")||fLocale.toString().equals("de_DE")){ %>

			<%=strAddress1%>&nbsp;<%=strAddress2%>&nbsp;<%=strAddress3%><br>
			<%=strZipCode%>&nbsp;<%=strCity%><br>
			<% if (fLocale.toString().equals("de_DE")) { %>
				<%=strState%><br>
			<% } %>
			<%=strCountry%>&nbsp;<br>
		<% } else { %>

			<%=strAddress1%>&nbsp;<%=strAddress2%>&nbsp;<%=strAddress3%><br>
			<%=strCity%>&nbsp;<%=strState%>&nbsp;<%=strZipCode%> <br>
			<%=strCountry%>&nbsp;<br>
		<% } %>

<% 	} %>

</td>
</tr>
</table>
<%
}
%>
</div>
</body>

</html>
