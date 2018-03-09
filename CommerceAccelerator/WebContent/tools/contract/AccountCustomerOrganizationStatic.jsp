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

<%@page language="java"
	import="com.ibm.commerce.tools.util.UIUtil,
		com.ibm.commerce.command.CommandFactory,
		com.ibm.commerce.beans.DataBeanManager,
		com.ibm.commerce.user.beans.OrganizationDataBean,
		com.ibm.commerce.datatype.TypedProperty,
		com.ibm.commerce.tools.contract.beans.AccountDataBean" %>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<html>

<head>
 <%= fHeader %>
 <style type='text/css'>
 .selectWidth {width: 200px;}
 
</style>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

 <title><%= contractsRB.get("accountCustomerOrganizationDisplay") %></title>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/ConvertToXML.js">
</script>

 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Account.js">
</script>

 <script LANGUAGE="JavaScript">
 
  // This function detect if the panel has been load before
  function loadPanelData() {
    
    <%  AccountDataBean account = new AccountDataBean(new Long(accountId), new Integer(fLanguageId));
      	DataBeanManager.activate(account, request);  %>
    if (parent.parent.get) {
  	var hereBefore = parent.parent.get("AccountCustomerModelLoaded", null);
	if (hereBefore != null) {
		// have been to this page before - load from the model
          	var o = parent.parent.get("AccountCustomerModel", null);
	  	if (o != null) {
		  parent.contactSelectionBody.location.replace("AccountCustomerContactSelectionPanelView?OrgId=" + o.org + "&ContactId=" + o.contact);

		  // handle error messages back from the validate page
    		  if (parent.parent.get("accountCustomerOrgRequired", false)) {
      			parent.parent.remove("accountCustomerOrgRequired");
      			alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("accountCustomerOrgRequired"))%>");
     		  }
    		  else if (parent.parent.get("accountCustomerContactRequired", false)) {
      			parent.parent.remove("accountCustomerContactRequired");
      			alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("accountCustomerContactRequired"))%>");
     		  }
         	}
        } else {
    		// load AccountCommonDataModel
    		parent.loadCommonDataModel();
    		        
		// this is the first time on this page - create the customer model
    		var acm = new AccountCustomerModel();
    		parent.parent.put("AccountCustomerModel", acm);
    		parent.parent.put("AccountCustomerModelLoaded", true);
    		
		// this is the first time on this page - create the representative model
		var arm = new AccountRepresentativeModel();
    		parent.parent.put("AccountRepresentativeModel", arm);
    		arm.org = "<%=fStoreMemberId%>";
    		<%
    		try {
    			OrganizationDataBean OrgEntityDB = new OrganizationDataBean();
			OrgEntityDB.setDataBeanKeyMemberId(fStoreMemberId.toString());
			DataBeanManager.activate(OrgEntityDB, request);
			String DN = (OrgEntityDB.getDistinguishedName().toString()).trim();
		%>
			arm.orgDN = "<%=UIUtil.toJavaScript(DN)%>";
		<% 
		} catch (Exception e) {
		} %>

		parent.checkForUpdate(acm, arm);
		parent.contactSelectionBody.location.replace("AccountCustomerContactSelectionPanelView?OrgId=" + acm.initialOrg + "&ContactId=" + acm.initialContact);

	}      	
    }
    
    // handle error messages back from the validate page
    if (parent.parent.get("accountExists", false)) {
      parent.parent.remove("accountExists");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("accountExists"))%>");
    }
    else if (parent.parent.get("accountMarkForDelete", false)) {
      parent.parent.remove("accountMarkForDelete");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("accountMarkedForDeleteError"))%>");
    }
    else if (parent.parent.get("accountHasBeenChanged", false)) {
      parent.parent.remove("accountHasBeenChanged");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("accountChanged"))%>");
    }
    else if (parent.parent.get("accountGenericError", false)) {
      parent.parent.remove("accountGenericError");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("accountNotSaved"))%>");
    }
    
  }
  
 
</script>

</head>

<body ONLOAD="loadPanelData();" class="content">

<h1><%= contractsRB.get("accountCustomerPanelTitle") %></h1>

<form NAME="orgForm" id="orgForm">

<table border="0" id="AccountCustomerOrganizationStatic_Table_1">
 <tr>
  <td valign='top' id="AccountCustomerOrganizationStatic_TableCell_1">
  	&nbsp;<br>
  	<%= contractsRB.get("accountCustomerOrganizationDisplay") %>&nbsp;<i><%=account.getCustomerName()%></i>
  </td>
 </tr>
</table>

</form>
</body>
</html>
