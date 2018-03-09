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

	TypedProperty requestProperties = (TypedProperty)request.getAttribute("RequestProperties");
	if (requestProperties != null) {
    addressId = (String)requestProperties.getString("AddressId");
	}

	AddressDataBean addressDb = new AddressDataBean();
	try
	{
	  addressDb.setAddressId(addressId);
	  addressDb.setCommandContext(contractCommandContext);
		addressDb.populate();
	  //DataBeanManager.activate(addressDb, request);
	}
	catch (Exception e)
	{
	}
%>

<html>

<head>
<%= fHeader %>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">
<title><%= contractsRB.get("contractPaymentFormAddressDetailPanelTitle") %></title>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/NumberFormat.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/DateUtil.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/ConvertToXML.js">
</script>

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Contract.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Payment.js">
</script>

<script LANGUAGE="JavaScript">
<!---- hide script from old browsers

function showBlankLoadingDetail(flag)
{
  if (flag=="Blank")
  {
    if (parent.parent.setContentFrameLoaded)
    {
      parent.parent.setContentFrameLoaded(true);
    }
  	top.showProgressIndicator(false);
  	Detail.style.display = "none";
  	Loading.style.display = "none";
  	Blank.style.display = "block";
  }
  else if (flag=="Loading")
  {
    if (parent.parent.setContentFrameLoaded)
    {
      parent.parent.setContentFrameLoaded(false);
    }
  	top.showProgressIndicator(true);
  	Detail.style.display = "none";
  	Blank.style.display = "none";
  	Loading.style.display = "block";
  }
  else if (flag=="Detail")
  {
      if (parent.parent.setContentFrameLoaded)
    {
      parent.parent.setContentFrameLoaded(true);
    }
  	top.showProgressIndicator(false);
  	Loading.style.display = "none";
  	Blank.style.display = "none";
  	Detail.style.display = "block";
  }
}
//-->

</script>

</head>

<body class="content" OnLoad="showBlankLoadingDetail('Detail');">
<div id="Blank" style="display: none">
</div>

<div id="Loading" style="display: none">
<%= contractsRB.get("generalLoadingMessage") %>
</div>

<div id="Detail" style="display: block">
<table BORDER=0 id="ContractPaymentDialogAddressDetailPanel_Table_1">
<tr>
<td VALIGN=TOP ALIGN=LEFT id="ContractPaymentDialogAddressDetailPanel_TableCell_1">
<%= contractsRB.get("contractPaymentAddressDetailPrompt") %>
</td>
</tr>
<tr>
<td VALIGN=TOP ALIGN=LEFT id="ContractPaymentDialogAddressDetailPanel_TableCell_2">

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
</div>
</body>

</html>
