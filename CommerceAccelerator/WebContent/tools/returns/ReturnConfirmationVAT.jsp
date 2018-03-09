<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.tools.optools.returns.beans.*" %>
<%@ page import="com.ibm.commerce.common.beans.StoreDataBean" %>
<%@ page import="com.ibm.commerce.edp.beans.*" %>
<%@ page import="com.ibm.commerce.edp.api.*" %>
<%@ page import="com.ibm.commerce.ordermanagement.objects.*" %>
<%@ page import="com.ibm.commerce.contract.objects.BusinessPolicyAccessBean" %>
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

	String rmaId = jspHelper.getParameter("returnId");
	String returnPolicyId = jspHelper.getParameter("returnPolicyId");
%>

<HTML lang="en">
<HEAD>

<LINK REL="stylesheet" HREF="<%= UIUtil.getCSSFile(jLocale) %>" TYPE="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

<%
request.setAttribute("returnId", rmaId);
request.setAttribute("returnsNLS", returnsNLS);
%>
<jsp:include page="/tools/returns/ReturnFinishHandler.jsp" flush="true" />

<SCRIPT>
function init() 
{
   parent.put("prev",parent.getCurrentPanelAttribute("name"));
   if (parent.setContentFrameLoaded) {
      parent.setContentFrameLoaded(true);
   }
}
function verifyTax(value)
{
	if (value == "NaN")
		value = "<%= UIUtil.toHTML((String)returnsNLS.get("returnTaxUnknown")) %>";
	return value;
}
function verifyTotalCredit(value)
{
	if (value == "NaN")
		value = "<%= UIUtil.toHTML((String)returnsNLS.get("returnTotalCreditUnknown")) %>";
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

<TITLE><%= UIUtil.toHTML((String)returnsNLS.get("returnConfirmTitle")) %></TITLE>

</HEAD>

<BODY onload="init();" class="content">

<FORM NAME="callActionForm" ACTION="" method="post">
	<INPUT TYPE='hidden' NAME="URL" VALUE="">
	<INPUT TYPE='hidden' NAME="XML" VALUE="">
</FORM>

<%
	CSRReturnSummaryDataBean summary = new CSRReturnSummaryDataBean();
	summary.setRmaId(rmaId);
	summary.setReturnPolicyId(returnPolicyId);
	summary.setCommandContext(cmdContext);
	
 	com.ibm.commerce.beans.DataBeanManager.activate(summary, request);

%>

<H1><%= UIUtil.toHTML((String)returnsNLS.get("returnConfirmTitle")) %></H1>

<DIV>
	<%= UIUtil.toHTML((String)returnsNLS.get("returnNumberLabel")) %> 
	<em><%= UIUtil.toHTML(summary.getRmaId()) %></em><BR>

<% if (isB2B) {
		String contractNameText = summary.getContractName();
		if (contractNameText.equals(""))
			contractNameText = (String)returnsNLS.get("returnContractNameNotAvailable");
%>
	<%= UIUtil.toHTML((String)returnsNLS.get("contractNameLabel")) %>
	<em><%= UIUtil.toHTML(contractNameText) %></em><BR>

<%	}
%>

<%
	String memberLogonIdText = summary.getMemberLogonId();
	if ( memberLogonIdText.equals("") )
		memberLogonIdText = (String)returnsNLS.get("returnOrignatorLogonIDIsGuest");
%>
	<%= UIUtil.toHTML((String)returnsNLS.get("returnOrignatorLogonIDLabel")) %>
	<em><%= UIUtil.toHTML(memberLogonIdText) %></em><BR>

<% if (isB2B) {
		String organizationNameText = summary.getOrganizationName();
		if (organizationNameText.equals(""))
			organizationNameText = (String)returnsNLS.get("returnOrganizationNameNotAvailable");
%>
	<%= UIUtil.toHTML((String)returnsNLS.get("returnOrganizationNameLabel")) %>
	<em><%= organizationNameText %></em>
<%	}
%>

</DIV><BR><BR>

<TABLE class="list" BORDER=0 CELLPADDING=1 CELLSPACING=1 WIDTH="100%" summary="<%= UIUtil.toHTML((String)returnsNLS.get("returnTable1Summary")) %>" >
<TR class="list_roles">
	<TH><TABLE CLASS="list_role_off"><TR><TD class="list_header"><%= (String)returnsNLS.get("itemName2") %></TD></TR></TABLE></TH>
	<TH><TABLE CLASS="list_role_off"><TR><TD class="list_header"><%= (String)returnsNLS.get("sku2") %></TD></TR></TABLE></TH>
	<TH><TABLE CLASS="list_role_off"><TR><TD class="list_header"><%= (String)returnsNLS.get("quantityReturned2") %></TD></TR></TABLE></TH>
	<TH><TABLE CLASS="list_role_off"><TR><TD class="list_header"><%= (String)returnsNLS.get("returnToWareHouse2") %></TD></TR></TABLE></TH>
	<TH><TABLE CLASS="list_role_off"><TR><TD class="list_header"><%= (String)returnsNLS.get("reasonForReturn2") %></TD></TR></TABLE></TH>
	<TH><TABLE CLASS="list_role_off"><TR><TD class="list_header"><%= (String)returnsNLS.get("creditAmount2") %></TD></TR></TABLE></TH>
	<TH><TABLE CLASS="list_role_off"><TR><TD class="list_header"><%= (String)returnsNLS.get("creditAdjustment2") %></TD></TR></TABLE></TH>
	
</TR>
<%
	for (int i=0; i < summary.getNumTotal(); i++)
	{
		String shouldReceiveText = summary.getShouldReceive();
		if ( shouldReceiveText.equals(new String("Y")) )
			shouldReceiveText = (String)returnsNLS.get("returnShouldReceiveYes");
		else if ( shouldReceiveText.equals(new String("N")) )
			shouldReceiveText = (String)returnsNLS.get("returnShouldReceiveNo");
		else if ( shouldReceiveText.equals(new String("S")) )
			shouldReceiveText = (String)returnsNLS.get("returnShouldReceiveNo");
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
	<TD CLASS="list_info1" align=right><SCRIPT>document.writeln(numberToCurrency(<%= summary.getPreAdjAmount()%>,"<%= summary.getCurrency() %>","<%= jLanguageID %>"))</SCRIPT></TD>
	<TD CLASS="list_info1" align=right><SCRIPT>document.writeln(numberToCurrency(<%= summary.getAdjAmount()%>,"<%= summary.getCurrency() %>","<%= jLanguageID %>"))</SCRIPT></TD>
	
<%
	}
	else
		out.println("<TD CLASS=\"list_info1\" colspan=\"4\"></TD>");
%>
</TR>

<%
	summary.next();
	}
%>
</TABLE>

<TABLE class="list2" summary="<%= UIUtil.toHTML((String)returnsNLS.get("returnTable2Summary")) %>" >
<TR>
	<TD align=right style="width: 90%"><%= UIUtil.toHTML((String)returnsNLS.get("returnOtherChargesLabel"))%></TD>
	<TD align=right><SCRIPT>document.writeln(verifyTax(numberToCurrency("<%= summary.getTotalCharges() %>","<%= summary.getCurrency() %>","<%= jLanguageID %>")))</SCRIPT></TD>
</TR>
<TR>
	<TD align=right style="width: 88%"><%= UIUtil.toHTML((String)returnsNLS.get("returnTaxLabel"))%></TD>
	<TD align=right><SCRIPT>document.writeln(verifyTax(numberToCurrency("<%= summary.getTotalTaxAmount() %>","<%= summary.getCurrency() %>","<%= jLanguageID %>")))</SCRIPT></TD>
	
</TR>
<TR>
	<TD align=right style="width: 88%"><strong><%= UIUtil.toHTML(((String)returnsNLS.get("returnRefundTotalLabel"))+" ["+summary.getCurrency()+"]" )%></strong></TD>
	<TD align=right><strong><SCRIPT>document.writeln(verifyTotalCredit(numberToCurrency("<%= summary.getTotalCredit() %>","<%= summary.getCurrency() %>","<%= jLanguageID %>")))</SCRIPT></strong></TD>
</TR>
</TABLE><BR>


<!-- fulfillment center info -->
<DIV>
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
					newLine += summary.getFfmcState();
				else if ( addressFields[j].equals("country") )
					newLine += summary.getFfmcCountry();
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
"	<%= UIUtil.toHTML((String)returnsNLS.get("returnLocationTitle")) %><BR><BR>	",
"	<%= UIUtil.toHTML((String)returnsNLS.get("confirmWarehouseUnknown")) %>	");</SCRIPT>
	<%= addressDisplay %>

<%
	}
	else
		out.println(UIUtil.toHTML((String)returnsNLS.get("confirmNoProductsNeedToBeReturned")));
%>
</DIV><BR><BR>

<!-- credit info -->
<DIV>

<%
	String totalCreditString = summary.getTotalCredit();
	if ( totalCreditString!="" && (new BigDecimal(totalCreditString).compareTo(new BigDecimal(0)) != 0) )
	{
	
%>
<%= UIUtil.toHTML((String)returnsNLS.get("returnCreditAccountTitle")) %><BR><BR>
<%
		String pmkey = "paymentMethodLabel";
    	

%>
<SCRIPT>
var curPaymentPolicyName = parent.get("paymentPolicyName");
conditionalWrite(curPaymentPolicyName,
"	<%= UIUtil.toHTML((String)returnsNLS.get(pmkey)+" ") %>		"+
"		<I>"+curPaymentPolicyName+"</I><BR>				","");</SCRIPT>
<%

	}
	else
	{
		out.println(UIUtil.toHTML((String)returnsNLS.get("confirmCreditInfoNotRequired")));
	}
%>

</DIV><BR><BR>

</BODY>
</HTML>

<%
}
catch (Exception e)
{
	com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
}
%>
