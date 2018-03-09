<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2005, 2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">


<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.tools.optools.returns.beans.*" %>
<%@ page import="com.ibm.commerce.common.beans.StoreDataBean" %>
<%@ page import="com.ibm.commerce.edp.refunds.*" %>
<%@ page import="com.ibm.commerce.edp.beans.*" %>
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
//	boolean isAOP = (store.getComplexOrders().shortValue() > 0);
%>

<HTML>
<HEAD>

<LINK REL="stylesheet" HREF="<%= UIUtil.getCSSFile(jLocale) %>" TYPE="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>
function init() 
{
   if (parent.setContentFrameLoaded) {
      parent.setContentFrameLoaded(true);
   }
}
function printDialog()
{
	window.focus();
	window.print();
}
function closeDialog()
{
	top.goBack();
}
function verifyTax(value)
{
	if (value == "NaN")
		value = "<%= UIUtil.toHTML((String)returnsNLS.get("returnTaxUnknown2")) %>";
	return value;
}
function verifyTotalCredit(value)
{
	if (value == "NaN")
		value = "<%= UIUtil.toHTML((String)returnsNLS.get("returnTotalCreditUnknown2")) %>";
	return value;
}
function conditionalWrite(condition, output1, output2)
{
	if (condition == "")
		document.writeln(output2);
	else
		document.writeln(output1);
}
</SCRIPT>

<TITLE><%= UIUtil.toHTML((String)returnsNLS.get("returnSummaryTitle")) %></TITLE>

</HEAD>

<BODY onload="init();" class="content" style="margin-right: 10pt">
<%
	String rmaId = jspHelper.getParameter("returnId");
	CSRReturnSummaryDataBean summary = new CSRReturnSummaryDataBean();
	summary.setRmaId(rmaId);
	summary.setCommandContext(cmdContext);
 	com.ibm.commerce.beans.DataBeanManager.activate(summary, request);
	
%>

<H1><%= UIUtil.toHTML((String)returnsNLS.get("returnSummaryTitle")) %></H1>

<!-- general info -->
<%
	String orderStatusText = summary.getOrderStatus();
	if (orderStatusText.equals(new String("PRC")))
		orderStatusText = (String)returnsNLS.get("orderStatusInProcess");
	else if (orderStatusText.equals(new String("PND")))
		orderStatusText = (String)returnsNLS.get("orderStatusPending");
	else if (orderStatusText.equals(new String("APP")))
		orderStatusText = (String)returnsNLS.get("orderStatusApproved");
	else if (orderStatusText.equals(new String("EDT")))
		orderStatusText = (String)returnsNLS.get("orderStatusBeingEdited");
	else if (orderStatusText.equals(new String("CLO")))
		orderStatusText = (String)returnsNLS.get("orderStatusClosed");
	else if (orderStatusText.equals(new String("CAN")))
		orderStatusText = (String)returnsNLS.get("orderStatusCancelled");
%>
<DIV>
	<%= UIUtil.toHTML((String)returnsNLS.get("returnConfirmationNumberLabel")) %>
	<I><%= UIUtil.toHTML(summary.getRmaId()) %></I><BR>
	<%= UIUtil.toHTML((String)returnsNLS.get("lastUpdatedLabel")) %>
	<I><%= UIUtil.toHTML(summary.getLastUpdateDate()) %></I><BR>
	<%= UIUtil.toHTML((String)returnsNLS.get("orderStatusLabel")) %>
	<I><%= UIUtil.toHTML(orderStatusText) %></I><BR>
<% if (isB2B) {
		String contractNameText = summary.getContractDesc();
		if (contractNameText == null ||contractNameText.equals(""))
			contractNameText = (String)returnsNLS.get("contractNameNotAvailable");
%>
	<%= UIUtil.toHTML((String)returnsNLS.get("contractNameLabel")) %>
	<I><%= UIUtil.toHTML(contractNameText) %></I><BR>
<%	}
%>
<%
	String memberLogonIdText = summary.getMemberLogonId();
	if ( memberLogonIdText.equals("") )
		memberLogonIdText = (String)returnsNLS.get("orignatorLogonIDIsGuest");
%>
	<%= UIUtil.toHTML((String)returnsNLS.get("orignatorLogonIDLabel")) %>
	<I><%= UIUtil.toHTML(memberLogonIdText) %></I><BR>
<% if (isB2B) {
		String organizationNameText = summary.getOrganizationName();
		if (organizationNameText.equals(""))
			organizationNameText = (String)returnsNLS.get("organizationNameNotAvailable");
%>
	<%= UIUtil.toHTML((String)returnsNLS.get("organizationNameLabel")) %>
	<I><%= organizationNameText %></I>
<%	}
%>
</DIV><BR><BR>

<!-- RMA item info -->
<TABLE class="list" BORDER=0 CELLPADDING=1 CELLSPACING=1 WIDTH="100%" summary="<%= UIUtil.toHTML((String)returnsNLS.get("returnTable1Summary2")) %>" >
<TR class="list_roles">
	<TH><TABLE CLASS="list_role_off"><TR><TD class="list_header"><%= (String)returnsNLS.get("itemName3") %></TD></TR></TABLE></TH>
	<TH><TABLE CLASS="list_role_off"><TR><TD class="list_header"><%= (String)returnsNLS.get("sku3") %></TD></TR></TABLE></TH>
	<TH><TABLE CLASS="list_role_off"><TR><TD class="list_header"><%= (String)returnsNLS.get("quantityReturned3") %></TD></TR></TABLE></TH>
	<TH><TABLE CLASS="list_role_off"><TR><TD class="list_header"><%= (String)returnsNLS.get("returnToWareHouse3") %></TD></TR></TABLE></TH>
	<TH><TABLE CLASS="list_role_off"><TR><TD class="list_header"><%= (String)returnsNLS.get("reasonForReturn3") %></TD></TR></TABLE></TH>
	<TH><TABLE CLASS="list_role_off"><TR><TD class="list_header"><%= (String)returnsNLS.get("comments3") %></TD></TR></TABLE></TH>
	<TH><TABLE CLASS="list_role_off"><TR><TD class="list_header"><%= (String)returnsNLS.get("creditAmount3") %></TD></TR></TABLE></TH>
	<TH><TABLE CLASS="list_role_off"><TR><TD class="list_header"><%= (String)returnsNLS.get("creditAdjustment3") %></TD></TR></TABLE></TH>
	<TH><TABLE CLASS="list_role_off"><TR><TD class="list_header"><%= (String)returnsNLS.get("refundAmount3") %></TD></TR></TABLE></TH>
</TR>

<%
	for (int i=0; i < summary.getNumTotal(); i++)
	{
		String shouldReceiveText = summary.getShouldReceive();
		if ( shouldReceiveText.equals(new String("Y")) )
			shouldReceiveText = (String)returnsNLS.get("returnShouldReceiveYes2");
		else if ( shouldReceiveText.equals(new String("N")) )
			shouldReceiveText = (String)returnsNLS.get("returnShouldReceiveNo2");
		else if ( shouldReceiveText.equals(new String("S")) )
			shouldReceiveText = (String)returnsNLS.get("returnShouldReceiveNo2");
%>
<TR class="list_row<%=(i%2)+1%>">
	<TD CLASS="list_info1"><%= UIUtil.toHTML(summary.getName())%></TD>
	<TD CLASS="list_info1"><%= UIUtil.toHTML(summary.getPartNumber())%></TD>
	<TD CLASS="list_info1" align=left><SCRIPT>document.writeln(numberToStr(<%= summary.getQuantity()%>,"<%= jLanguageID %>", null))</SCRIPT></TD>
	<TD CLASS="list_info1"><%= UIUtil.toHTML(shouldReceiveText)%></TD>
<%	if ( !summary.getRefundAmount().equals("") )
	{
%>
	<TD CLASS="list_info1"><%= UIUtil.toHTML(summary.getReason())%></TD>
	<TD CLASS="list_info1"><%= UIUtil.toHTML(summary.getItemComment())%></TD>
	<TD CLASS="list_info1" align=right><SCRIPT>document.writeln(numberToCurrency(<%= summary.getPreAdjAmount()%>,"<%= summary.getCurrency() %>","<%= jLanguageID %>"))</SCRIPT></TD>
	<TD CLASS="list_info1" align=right><SCRIPT>document.writeln(numberToCurrency(<%= summary.getAdjAmount()%>,"<%= summary.getCurrency() %>","<%= jLanguageID %>"))</SCRIPT></TD>
	<TD CLASS="list_info1" align=right><SCRIPT>document.writeln(numberToCurrency(<%= summary.getRefundAmount()%>,"<%= summary.getCurrency() %>","<%= jLanguageID %>"))</SCRIPT></TD>
<%
	}
	else
		out.println("<TD CLASS=\"list_info1\" colspan=\"5\"></TD>");
%>
</TR>

<%
	summary.next();
	}
%>
</TABLE>

<TABLE class="list2" summary="<%= UIUtil.toHTML((String)returnsNLS.get("returnTable2Summary2")) %>" >
<TR>
	<TD align=right style="width: 90%"><%= UIUtil.toHTML((String)returnsNLS.get("returnOtherChargesLabel2"))%></TD>
	<TD align=right><SCRIPT>document.writeln(verifyTax(numberToCurrency("<%= summary.getTotalCharges() %>","<%= summary.getCurrency() %>","<%= jLanguageID %>")))</SCRIPT></TD>
</TR>
<TR>
	<TD align=right style="width: 90%"><%= UIUtil.toHTML((String)returnsNLS.get("returnTaxLabel2"))%></TD>
	<TD align=right><SCRIPT>document.writeln(verifyTax(numberToCurrency("<%= summary.getTotalTaxAmount() %>","<%= summary.getCurrency() %>","<%= jLanguageID %>")))</SCRIPT></TD>
</TR>
<TR>
	<TD align=right style="width: 90%"><B><%= UIUtil.toHTML(((String)returnsNLS.get("returnRefundTotalLabel2"))+" ["+summary.getCurrency()+"]" ) %></B></TD>
	<TD align=right><B><SCRIPT>document.writeln(verifyTotalCredit(numberToCurrency("<%= summary.getTotalCredit() %>","<%= summary.getCurrency() %>","<%= jLanguageID %>")))</SCRIPT></B></TD>
</TR>
</TABLE>


<!-- fulfillment center info -->
<DIV><B><%= UIUtil.toHTML((String)returnsNLS.get("warehouseInformationTitle")) %></B><BR><BR>	
<%
	if ( summary.isAnyShouldReceive() )
	{

		Hashtable addrFormats = (Hashtable)ResourceDirectory.lookup("returns.addressFormats");
		Hashtable localeAddrFormat = (Hashtable)XMLUtil.get(addrFormats, "addressFormats."+ jLocale.toString());
		if (localeAddrFormat == null) 
		localeAddrFormat = (Hashtable)XMLUtil.get(addrFormats, "addressFormats.default");

		String addressDisplay = "";
		for (int i = 2; i < localeAddrFormat.size(); i++) 
		{
			String addressLine = (String)XMLUtil.get(localeAddrFormat,"line"+ i +".elements");
			String[] addressFields = Util.tokenize(addressLine, ",");
			String newLine = "";
			for (int j = 0; j < addressFields.length; j++) 
			{
				if ( addressFields[j].equals("firstName") )
					newLine += summary.getFfmcFirstName();
				else if ( addressFields[j].equals("lastName") )
					newLine += summary.getFfmcLastName();
				else if ( addressFields[j].equals("address1") )
					newLine += summary.getFfmcAddress1();
				else if ( addressFields[j].equals("address2") )
					newLine += summary.getFfmcAddress2();
				else if ( addressFields[j].equals("address3") )
					newLine += summary.getFfmcAddress3();
				else if ( addressFields[j].equals("city") )
					newLine += summary.getFfmcCity();
				else if ( addressFields[j].equals("region") )
					newLine += summary.getStateProvDisplayName();
				else if ( addressFields[j].equals("country") )
					newLine += summary.getCountryDisplayName();
				else if ( addressFields[j].equals("postalCode") )
					newLine += summary.getFfmcZipCode();
//do not display phone number
//				else if ( addressFields[j].equals("phoneNumber") )
//					newLine += summary.getFfmcPhoneNumber();
				else if ( addressFields[j].equals("space") && !newLine.equals("") )
					newLine += " ";
				else if ( addressFields[j].equals("comma") && !newLine.equals("") )
					newLine += ",";
			}
			if ( !newLine.equals("") )
				newLine += "<BR>";
			addressDisplay += newLine;
		}
//do not display email
//		if ( !summary.getFfmcEmail().equals("") )
//			addressDisplay += summary.getFfmcEmail() + "<BR>";
%>

<SCRIPT>conditionalWrite("<%= UIUtil.toJavaScript(summary.getFulfillmentCenterName()+addressDisplay) %>",
"	<%= addressDisplay %>								",
"	<%= UIUtil.toHTML((String)returnsNLS.get("summaryWarehouseUnknown")) %>		");</SCRIPT>

<%
	}
	else
		out.println(UIUtil.toHTML((String)returnsNLS.get("summaryNoProductsNeedToBeReturned")));
%>
</DIV><BR><BR>


<!-- credit info -->
<DIV><B><%= UIUtil.toHTML((String)returnsNLS.get("paymentInformationTitle")) %></B><BR><BR>
<%

	String totalCreditString = summary.getTotalCredit();

	if ( totalCreditString!="" && (new BigDecimal(totalCreditString).compareTo(new BigDecimal(0)) != 0) )
	{

		String paymentStatus = summary.getPaymentStatus();

		if (paymentStatus.equals("")) {
			paymentStatus = UIUtil.toHTML((String)returnsNLS.get("creditInitiatedNo"));
		} else {
			paymentStatus = UIUtil.toHTML( (String)returnsNLS.get("creditInitiatedYes") + " " + paymentStatus );
		}

%>
	<%= UIUtil.toHTML((String)returnsNLS.get("paymentStatusLabel")+" ") %>
		<I><%= paymentStatus %></I><BR>
<%


    	EDPRefundInstructionsDataBean bean = new EDPRefundInstructionsDataBean();
	    bean.setRmaId(new Long(rmaId));
	    com.ibm.commerce.beans.DataBeanManager.activate(bean, request);
		java.util.ArrayList ris = bean.getRefundInstructions();
		String rmkey = "paymentMethodLabel";
		String rm = "";
		if (ris.size() > 0) {
		    int ind = 0;
		    for(ind = 0;ind< ris.size();ind++){
			  RefundInstructionData ri = (RefundInstructionData) ris.get(ind);
			  rm = ri.getRefundMethod();
			  if(ri.getCanceled().equals(Boolean.FALSE)){
			      break;
			  }
			}
			if(ind ==ris.size()){
			  rm = "";
			}
		}
		

%>
<SCRIPT>conditionalWrite("<%= UIUtil.toJavaScript(rm) %>",
"	<%= UIUtil.toHTML((String)returnsNLS.get(rmkey)+" ") %>		"+
"		<I><%= UIUtil.toHTML(rm)%></I><BR>				","");</SCRIPT>
<%
	
	}
	else
		out.println(UIUtil.toHTML((String)returnsNLS.get("summaryCreditInfoNotRequired")));
%>
</DIV><BR><BR>


<!-- RMA comment -->
<SCRIPT>conditionalWrite("<%= UIUtil.toJavaScript(summary.getComment()) %>",
"	<DIV><B><%= UIUtil.toHTML((String)returnsNLS.get("commentsTitle")) %></B><BR><BR>	" +
"	<%= UIUtil.toJavaScript(summary.getComment()) %></DIV><BR><BR>				","");</SCRIPT>
	

</BODY>
</HTML>

<%
}
catch (Exception e)
{
	com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
}
%>
