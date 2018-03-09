<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<%@ page import="java.util.*"%>
<%@ page import="java.math.*"%>
<%@ page import="com.ibm.commerce.server.*"%>
<%@ page import="com.ibm.commerce.server.ECConstants"%>
<%@ page import="com.ibm.commerce.command.CommandContext"%>
<%@ page import="com.ibm.commerce.tools.util.*"%>
<%@ page import="java.text.DateFormat"%>
<%@ page import="com.ibm.commerce.tools.util.UIUtil"%>
<%@ page import="com.ibm.commerce.payment.ppc.beans.*"%>
<%@ include file="../common/common.jsp"%>
<%@ include file="ppcUtil.jsp"%>
<%// obtain the resource bundle for display
            CommandContext cmdContextLocale = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
            Locale jLocale = cmdContextLocale.getLocale();
            Integer langId = cmdContextLocale.getLanguageId();
            String storeId = cmdContextLocale.getStoreId().toString();
            String currency = cmdContextLocale.getCurrency();
            Hashtable ppcLabels = (Hashtable) ResourceDirectory.lookup("edp.ppcLabels", jLocale);

            JSPHelper jspHelper = new JSPHelper(request);

            String piId = request.getParameter("piId").trim();
            // get standard list parameters

            String searchOrderId = request.getParameter("orderId").trim();
            String rmaId = request.getParameter("rmaId").trim();

            PPCListPIsForOrderDataBean orderPIList = new PPCListPIsForOrderDataBean();
            PPCListPIsForReturnDataBean rmaPIList = new PPCListPIsForReturnDataBean();
            if (searchOrderId.length()>1) {
                orderPIList.setOrderId(searchOrderId);
                orderPIList.setStoreId(storeId);
                com.ibm.commerce.beans.DataBeanManager.activate(orderPIList, request);
            } else if (rmaId.length()>1) {

                rmaPIList.setRmaID(rmaId);
                rmaPIList.setStoreId(storeId);
                com.ibm.commerce.beans.DataBeanManager.activate(rmaPIList, request);

            } else {
                orderPIList.setPaymentInstructionList(new ArrayList());
                rmaPIList.setPaymentInstructionList(new ArrayList());
            }

            PaymentInstruction pi = null;
            if (searchOrderId.length()>1) {
                for (int i = 0; i < orderPIList.getPaymentInstructionList().size(); i++) {
                    pi = orderPIList.getPIListData(i);
                    if (pi.getId().equals(piId)) {
                        break;
                    }
                }
            } else if (rmaId.length()>1) {

                for (int i = 0; i < rmaPIList.getPaymentInstructionList().size(); i++) {
                    pi = rmaPIList.getPIListData(i);
                    if (pi.getId().equals(piId)) {
                        break;
                    }
                }
            }

            DateFormat df = DateFormat.getDateTimeInstance();
            String timeCreated = df.format(new Date(pi.getTimeCreated()));
            String timeUpdated = df.format(new Date(pi.getTimeUpdated()));
            int state = pi.getState();
            String accountNumber = pi.getAccountNumber();
            String paymentSystemName = pi.getPaymentSystemName();
            String statue = (String) ppcLabels.get(converterStateOfPI(state));
            String amount = getFormattedAmount(pi.getAmount(), currency, langId, storeId);
            String approvedAmount = getFormattedAmount(pi.getApprovedAmount(), currency, langId, storeId);
            String approvingAmount = getFormattedAmount(pi.getApprovingAmount(), currency, langId, storeId);
            String depositedAmount = getFormattedAmount(pi.getDepositedAmount(), currency, langId, storeId);
            String depositingAmount = getFormattedAmount(pi.getDepositingAmount(), currency, langId, storeId);
            String creditedAmount = getFormattedAmount(pi.getCreditedAmount(), currency, langId, storeId);
            String creditingAmount = getFormattedAmount(pi.getCreditingAmount(), currency, langId, storeId);
            String reversingApprovedAmount = getFormattedAmount(pi.getReversingApprovedAmount(), currency, langId,
                    storeId);
            String reversingDepositedAmount = getFormattedAmount(pi.getReversingDepositedAmount(), currency, langId,
                    storeId);
            String reversingCreditedAmount = getFormattedAmount(pi.getReversingCreditedAmount(), currency, langId,
                    storeId);
            String _currency = pi.getCurrency();
            String payCfgId = pi.getPaymentConfigurationId();
%>

<html>
<head>
<title><%=UIUtil.toHTML((String) ppcLabels.get("title"))%></title>
<SCRIPT SRC="/wcs/javascript/tools/common/NumberFormat.js"></SCRIPT>
<script src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript" type="text/javascript">
	function onLoad()
    {
		
		parent.setContentFrameLoaded(true);
		
    }
</script>
<LINK rel="stylesheet" href="<%=UIUtil.getCSSFile(jLocale)%>"
	type="text/css">
</head>

<body onLoad="onLoad()" CLASS="content">
<!--JSP File name :ppcPISummary.jsp -->
<TABLE style="padding-left: 25px;">
	<TBODY>
		<TR>
			<td class="h1" height="40" valign="bottom"
				style="padding-bottom: 20px;" colspan="2"><b><%=UIUtil.toHTML((String) ppcLabels.get("PISummary"))%></b></td>
		</TR>

		<TR>
			<TD width="226"><B><label for="piId"><%=UIUtil.toHTML((String) ppcLabels.get("payInstId"))%>
			:</label></B></TD>
			<TD width="333" id="paymentId"><%=pi.getId()%></TD>
		</TR>
		<tr>
			<TD width="226"><B><label for="state"><%=UIUtil.toHTML((String) ppcLabels.get("state"))%>
			:</label></B></TD>
			<TD width="333" id="state"><%=statue%>
			</TD>
		</TR>
		<TR>
			<TD width="226"><B><label for="accountNumber"><%=UIUtil.toHTML((String) ppcLabels.get("accountNumber"))%>
			:</label></B></TD>
			<TD width="333" id="accountNumber"><%=accountNumber%></TD>
		</tr>
		<TR>
			<TD width="226"><B><label for="paymentSystemName"><%=UIUtil.toHTML((String) ppcLabels.get("paymentSystemName"))%>
			:</label></B></TD>
			<TD width="333" id="paymentSystemName"><%=paymentSystemName%></TD>
		</tr>
		<TR>
			<TD width="226"><B><label for="amount"><%=UIUtil.toHTML((String) ppcLabels.get("amount"))%>
			:</label></B></TD>
			<TD width="333" id="amount"><%=amount%></TD>
		</tr>
		<TR>
			<TD width="226"><B><label for="currency"><%=UIUtil.toHTML((String) ppcLabels.get("currency"))%>
			:</label></B></TD>
			<TD width="333" id="currency"><%=currency%></TD>
		</tr>
		<TR>
			<TD width="226"><B><label for="approvingAmount"><%=UIUtil.toHTML((String) ppcLabels.get("approvingAmount"))%>
			:</label></B></TD>
			<TD width="333" id="approvingAmount"><%=approvingAmount%></TD>
		</tr>
		<tr>
			<TD width="226"><B><label for="approvedAmount"><%=UIUtil.toHTML((String) ppcLabels.get("approvedAmount"))%>
			:</label></B></TD>
			<TD width="333" id="approvedAmount"><%=approvedAmount%></TD>

		</TR>
		<TR>
			<TD width="226"><B><label for="depositingAmount"><%=UIUtil.toHTML((String) ppcLabels.get("depositingAmount"))%>
			:</label></B></TD>
			<TD width="333" id="depositingAmount"><%=depositingAmount%></TD>
		</tr>
		<tr>
			<TD width="226"><B><label for="depositedAmount"><%=UIUtil.toHTML((String) ppcLabels.get("depositedAmount"))%>
			:</label></B></TD>
			<TD width="333" id="depositedAmount"><%=depositedAmount%></TD>
		</TR>
		<TR>
			<TD width="226"><B><label for="creditingAmount"><%=UIUtil.toHTML((String) ppcLabels.get("creditingAmount"))%>
			:</label></B></TD>
			<TD width="333" id="creditingAmount"><%=depositingAmount%></TD>
		</tr>
		<tr>
			<TD width="226"><B><label for="creditedAmount"><%=UIUtil.toHTML((String) ppcLabels.get("creditedAmount"))%>
			:</label></B></TD>
			<TD width="333" id="creditedAmount"><%=creditedAmount%></TD>
		</TR>
		<TR>
			<TD width="226"><B><label for="reversingApprovedAmount"><%=UIUtil.toHTML((String) ppcLabels.get("reversingApprovedAmount"))%>
			:</label></B></TD>
			<TD width="333" id="reversingApprovedAmount"><%=reversingApprovedAmount%></TD>
		</tr>
		<tr>
			<TD width="226"><B><label for="reversingDepositedAmount"><%=UIUtil.toHTML((String) ppcLabels.get("reversingDepositedAmount"))%>
			:</label></B></TD>
			<TD width="333" id="reversingDepositedAmount"><%=reversingDepositedAmount%></TD>
		</TR>
		<TR>
			<TD width="226"><B><label for="reversingCreditedAmount"><%=UIUtil.toHTML((String) ppcLabels.get("reversingCreditedAmount"))%>
			:</label></B></TD>
			<TD width="333" id="reversingCreditedAmount"><%=reversingCreditedAmount%></TD>
		</tr>
		<tr>
			<TD width="226"><B><label for="timeCreated"><%=UIUtil.toHTML((String) ppcLabels.get("timeCreated"))%>
			:</label></B></TD>
			<TD width="333" id="timeCreated"><%=timeCreated%></TD>
		</TR>
		<TR>
			<TD width="226"><B><label for="timeUpdated"><%=UIUtil.toHTML((String) ppcLabels.get("timeUpdated"))%>
			:</label></B></TD>
			<TD width="333" id="timeUpdated"><%=timeUpdated%></TD>
		</tr>
	</tbody>
</table>
</body>

</html>
