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
	com.ibm.commerce.user.beans.UserDataBean,
	com.ibm.commerce.tools.contract.beans.AddressListDataBean,
  	com.ibm.commerce.datatype.TypedProperty" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="ContractCommon.jsp" %>

<%
	String contactId = "";

	TypedProperty requestProperties = (TypedProperty)request.getAttribute("RequestProperties");
	if (requestProperties != null) {
		contactId = UIUtil.toHTML((String)requestProperties.getString("ContactId"));
	}

	AddressListDataBean addressList = new AddressListDataBean();
	AddressDataBean address[] = null;
	AddressDataBean addressDb = new AddressDataBean();
	int numberOfAddress = 0;
	String DN = "";

	try {
	  if (!contactId.equals("")) {
	  	Long contactMemberId = new Long(contactId);
	  	addressList.setMemberId(contactMemberId);
  	  	DataBeanManager.activate(addressList, request);
  	  	address = addressList.getAddressList();
  	  	if (address != null) {
	  	  	numberOfAddress = address.length;
  		}
  	  	if (numberOfAddress == 1) {
  	  		addressDb = address[0];
  	  	} else {
  	  		for (int i = 0; i < address.length; i++) {
  	  			if (address[i].getPrimary().equals("1")) {
  	  				addressDb = address[i];
  	  				break;
  	  			}
  	  		}
  	  	}
  	  	UserDataBean UserDB = new UserDataBean();
   		UserDB.setDataBeanKeyMemberId(contactId);
   		DataBeanManager.activate(UserDB, request); 
   		DN = (UserDB.getDistinguishedName().toString()).trim();
  	  }
  	} catch (Exception e) {
  	  out.println(e);
  	}
%>

<html>

<head>
<%= fHeader %>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

<script LANGUAGE="JavaScript">

  var acm = parent.parent.get("AccountRepresentativeModel", null);
  if (acm != null) {
  	acm.contact = "<%=contactId%>"
      	acm.contactDN = "<%=UIUtil.toJavaScript(DN)%>";
  }

  // This function performs augment usability
  function showLoadingMsg(message) {
    if (message == "load") {
      if (parent.parent.setContentFrameLoaded) {
        parent.parent.setContentFrameLoaded(false);
      }
      top.showProgressIndicator(true);
      FinishDiv.style.display = "none";
      BlankMsgDiv.style.display = "none";
      LoadingMsgDiv.style.display = "block";
    }
    else if(message == "blank"){
      top.showProgressIndicator(false);
      LoadingMsgDiv.style.display = "none";
      FinishDiv.style.display = "none";
      BlankMsgDiv.style.display = "block";
    } 
    else if(message == "details"){
      if (parent.parent.setContentFrameLoaded) {
        parent.parent.setContentFrameLoaded(true);
      }
      top.showProgressIndicator(false);
      LoadingMsgDiv.style.display = "none";
      BlankMsgDiv.style.display = "none";
      FinishDiv.style.display = "block";
    }
  }


</script>

<title><%= contractsRB.get("accountRepresentativeContactDetailPrompt") %></title>
</head>

<body class="content" onLoad="showLoadingMsg('details');">

<div id="LoadingMsgDiv" style="display: none">
  &nbsp;<%= contractsRB.get("generalLoadingMessage") %>
</div>

<div id="BlankMsgDiv" style="display: none">
</div>

<div id="FinishDiv" style="display: none">
<% if (!contactId.equals("")) { %>
	<table BORDER=0 id="AccountRepresentativeContactDetailPanel_Table_1">
	  <tr>
		<td VALIGN=TOP ALIGN=LEFT id="AccountRepresentativeContactDetailPanel_TableCell_1"><%= contractsRB.get("accountAddressDetailPrompt") %></td>
	  </tr>
	  <tr>
		<td VALIGN=TOP ALIGN=LEFT id="AccountRepresentativeContactDetailPanel_TableCell_2">
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
<% } %>
</div>

</body>

</html>
