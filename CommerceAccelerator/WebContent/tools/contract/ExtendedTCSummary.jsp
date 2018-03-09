<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page language="java"
	import="com.ibm.commerce.contract.helper.TCConfigUtil"%>
<%@page import="java.util.*"%>
<%@page import="com.ibm.commerce.command.CommandContext"%>
<%@page import="com.ibm.commerce.server.ECConstants"%>
<%@page import="com.ibm.commerce.tools.util.UIUtil"%>

<%
			CommandContext contractCommandContext1 = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
			if (contractCommandContext1 == null) {
				out.println("CommandContext is null");
				return;
			}
			Locale fLocale1 = contractCommandContext1.getLocale();
			java.util.Hashtable contractsRB1 = (java.util.Hashtable) com.ibm.commerce.tools.util.ResourceDirectory.lookup("contract.contractRB", fLocale1);
			if (contractsRB1 == null) {
				out.println("Contracts resources bundle is null");
			}
			String tradingId = null;
			tradingId = (String) request.getAttribute("summaryTradingId");

%>
<!--LI 2261 Begin to display contract extended tc propertie-->
<h4><%=contractsRB1.get("tcSummaryTitle")%></h4>
<%
			String extSummary = null;
			extSummary = TCConfigUtil.getExtendedTCSummary(tradingId,fLocale1);
			if (extSummary == null || extSummary.trim().length() == 0) {
				%><%=contractsRB1.get("noExtendedTC")%><%
			
			} else {

				%><script type="text/javascript">document.writeln(decodeNewLinesForHtml('<%= UIUtil.toJavaScript(extSummary) %>'))</script>
				<br />
				<%
			}

%>
<!--LI 2261 End to display contract extended tc properties-->
