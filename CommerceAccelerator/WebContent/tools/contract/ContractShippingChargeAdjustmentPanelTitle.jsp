<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2005
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<html>

<head>
<%@page import = "java.util.*,
      com.ibm.commerce.contract.util.*,
			com.ibm.commerce.datatype.TypedProperty,
			com.ibm.commerce.tools.contract.beans.*,
			com.ibm.commerce.contract.helper.*,      
			com.ibm.commerce.tools.util.*"
%>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<meta name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<meta http-equiv="Content-Style-Type" content="text/css">

<title><%=UIUtil.toHTML((String)contractsRB.get("genericShippingChargeAdjustmentCatalogFilterTitle"))%></title>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

<script SRC="/wcs/javascript/tools/common/Util.js">
</script>


<script LANGUAGE="JavaScript">

function refreshCatalogFilterTitleDivision() {
//alert('reload');
	location.reload();
}
</script>

</head>

<%
	boolean baseHasTCs = false;
	boolean accountHasTCs = false;
	String baseContract = null;
	String delegationGrid = "false"; 
	TypedProperty requestProperties = (TypedProperty)request.getAttribute("RequestProperties");
	if (requestProperties != null) {
		    baseContract = requestProperties.getString("base_contract_id", null);
		    delegationGrid = requestProperties.getString("delegationGrid", "false");
		    try {
			if (editingAccount == false) {
				// don't display the message if this is the account		    
				baseHasTCs = ContractCmdUtil.doesTradingAgreementHaveTCs(ContractCmdUtil.getCurrentContract(baseContract), 
					ECContractConstants.EC_ELE_SHIPPING_TC_SHIPPING_CHARGE_ADJUSTMENT );
				if (delegationGrid.equals("false")) {
					accountHasTCs = ContractCmdUtil.doesTradingAgreementHaveTCs(accountId,
						ECContractConstants.EC_ELE_SHIPPING_TC_SHIPPING_CHARGE_ADJUSTMENT );				
				}
			}
		    } catch (Exception e) {
		    }
	}
%>		
<body>
<div id="catalogFilterTitleDiv" style="display: block; margin-left: 0">
 <table border="0" width="100%" id="CatalogFilterTitle_Table_1">
	<tr VALIGN=CENTER>
		<td VALIGN=CENTER id="CatalogFilterTitle_TableCell_1">
			<h1><%=UIUtil.toHTML((String)contractsRB.get("genericShippingChargeAdjustmentCatalogFilterTitle"))%></h1>
		</td>
	</tr>
	<tr VALIGN=TOP>
		<td class="list_info1" id="CatalogFilterTitle_TableCell_101" VALIGN=TOP>	
			<% if (baseHasTCs == true && accountHasTCs == true) { %>
				<%=UIUtil.toHTML((String)contractsRB.get("contractShippingChargeAdjustmentSettingsMessage3"))%>
				<%=UIUtil.toHTML((String)contractsRB.get("contractShippingChargeAdjustmentSettingsMessage4"))%>
			<% } else if (baseHasTCs == true) { %>
				<% if (delegationGrid.equals("false")) { %>
					<%=UIUtil.toHTML((String)contractsRB.get("contractShippingChargeAdjustmentSettingsMessage2"))%>
					<%=UIUtil.toHTML((String)contractsRB.get("contractShippingChargeAdjustmentSettingsMessage4"))%>
				<% } else { %>
					<%=UIUtil.toHTML((String)contractsRB.get("contractShippingChargeAdjustmentSettingsMessage5"))%>
					<%=UIUtil.toHTML((String)contractsRB.get("contractShippingChargeAdjustmentSettingsMessage6"))%>				
				<% } %>
			<% } else if (accountHasTCs == true) { %>
				<%=UIUtil.toHTML((String)contractsRB.get("contractShippingChargeAdjustmentSettingsMessage1"))%>
				<%=UIUtil.toHTML((String)contractsRB.get("contractShippingChargeAdjustmentSettingsMessage4"))%>
			<% } %>
		</td>
	</tr>
 </table>

</div>

</body>
</html>
