<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c)  Copyright  IBM Corp.  2000      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>

<%@include file="eCouponCommon.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<jsp:useBean id="ecouponsummary" scope="request" class="com.ibm.commerce.tools.ecoupon.ECouponDetailsDataBean">
</jsp:useBean>
<%
	com.ibm.commerce.beans.DataBeanManager.activate(ecouponsummary, request);
%>

<title><%=eCouponWizardNLS.get("eCouponSummary_title")%></title>
<%=feCouponHeader%>
<script>

function initializeState()
{
	parent.setContentFrameLoaded(true);
}

function savePanelData() {}

function writeCurrency()
{
	document.write(" <%=ecouponsummary.getECouponCurr()%>");
}

function fixedValue()
{
	<% if (ecouponsummary.getPurchaseConditionType() == 1)
	{%>
		document.write("<i>" + parent.numberToCurrency("<%=ecouponsummary.getOrderFixedAmt()%>","<%=ecouponsummary.getECouponCurr()%>","<%=fLanguageId%>") + "</i>");
	<%}
	else if (ecouponsummary.getPurchaseConditionType() == 0)
	{%>
		document.write("<i>" + parent.numberToCurrency("<%=ecouponsummary.getProductFixedAmt()%>","<%=ecouponsummary.getECouponCurr()%>","<%=fLanguageId%>") + "</i>");
	<%}
	else if (ecouponsummary.getPurchaseConditionType() == 2)
	{%>
		document.write("<i>" + parent.numberToCurrency("<%=ecouponsummary.getCategoryFixedAmt()%>","<%=ecouponsummary.getECouponCurr()%>","<%=fLanguageId%>") + "</i>");
	<%}%>
}

function writeTotalNumOffer()
{
	<% if (ecouponsummary.isHasNumOffer())
	{%>
		document.write("<%= (new Integer (ecouponsummary.getECouponNumOffer())).toString()%>");
	<%}
	else
	{%>
		document.write('<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponDetailsAnyNumber").toString())%>');
	<%}%>
}

function writePurchaseCondition()
{
	document.write("<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponOrderPurchase").toString())%>");
	document.write("<br>");
	document.write("<table>");
	document.write("<tr>");
	document.write('<td><%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponDetailsMinAmtLabel").toString())%></td>');
	document.write("<td><i>" + parent.numberToCurrency("<%=ecouponsummary.getMinAmt()%>","<%=ecouponsummary.getECouponCurr()%>","<%=fLanguageId%>"));
	writeCurrency();
	document.write("</td></i>");
	document.write("</tr>");
	<% if (ecouponsummary.isHasMax())
	{%>
		document.write("<tr>");
		document.write('<td><%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponDetailsMaxAmtLabel").toString())%></td>');
		document.write("<td><i>" + parent.numberToCurrency("<%=ecouponsummary.getMaxAmt()%>","<%=ecouponsummary.getECouponCurr()%>","<%=fLanguageId%>"));
		writeCurrency();
		document.write("</td></i>");
		document.write("</tr>");
	<%}%>
	document.write("</table>");
	document.write("<br>");
}

function writeStatus()
{
	<% if (ecouponsummary.getPromoStatus().equals(ECECouponConstant.ECOUPON_PROMOTION_ACTIVE))
	{%>
		document.write('<%= UIUtil.toJavaScript(eCouponWizardNLS.get("Active").toString())%>');
	<%}
	else if (ecouponsummary.getPromoStatus().equals(ECECouponConstant.ECOUPON_PROMOTION_EXPIRED))
	{%>
		document.write('<%= UIUtil.toJavaScript(eCouponWizardNLS.get("Expired").toString())%>');
	<%}
	else if (ecouponsummary.getPromoStatus().equals(ECECouponConstant.ECOUPON_PROMOTION_INACTIVE))
	{%>
		document.write('<%= UIUtil.toJavaScript(eCouponWizardNLS.get("Inactive").toString())%>');
	<%}
	else if (ecouponsummary.getPromoStatus().equals(ECECouponConstant.ECOUPON_PROMOTION_DELETE))
	{%>
		document.write('<%= UIUtil.toJavaScript(eCouponWizardNLS.get("Deleted").toString())%>');
	<%}%>
}

function writeDateTime()
{
	<% if (ecouponsummary.isHasDateTimeRange())
	{%>
		document.write("<br>");
		document.write("<table>");
		document.write("<tr>");
		document.write('<td><%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponDetailsStartDateLabel").toString())%></td>');
		document.write("<td><i><%=ecouponsummary.getStartDateLocale()%></td></i>");
		document.write("</tr>");
		document.write("<tr>");
		document.write('<td><%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponDetailsEndDateLabel").toString())%></td>');
		document.write("<td><i><%=ecouponsummary.getEndDateLocale()%></i></td>");
		document.write("</tr>");
		document.write("</table>");
		document.write("<br>");
	<%}
	else
	{%>
		document.write('<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponAlways").toString())%>');
	<%}%>
}

</script>
</head>
<body class="content" onload="initializeState()">
<form name="eCouponSummaryForm" id="eCouponSummaryForm">
<h1><%=eCouponWizardNLS.get("eCouponSummary_title")%></h1>

<p><%=eCouponWizardNLS.get("eCouponDetailsNameLabel")%>
<i><%=ecouponsummary.getECouponName()%></i></p>

<p><%=eCouponWizardNLS.get("eCouponDetailsDescLabel")%>
<i><%=ecouponsummary.getECouponDesc()%></i></p>

<p><%=eCouponWizardNLS.get("eCouponDetailsShortDescLabel")%>
<i><% if (ecouponsummary.getShortDesc() != null) { %><%= ecouponsummary.getShortDesc() %><% } %></i></p>

<p><%=eCouponWizardNLS.get("eCouponDetailsLongDescLabel")%>
<i><% if (ecouponsummary.getLongDesc() != null) { %><%= ecouponsummary.getLongDesc() %><% } %></i></p>

<p><%=eCouponWizardNLS.get("eCouponDetailsDateRange")%>
<i><script language="JavaScript">
writeDateTime();

</script></i>
</p>

<p><%=eCouponWizardNLS.get("eCouponDetailsThumbnailPathLabel")%>
<i><% if (ecouponsummary.getThumbNailPath() != null) { %><%= ecouponsummary.getThumbNailPath() %><% } %></i></p>

<p><%=eCouponWizardNLS.get("eCouponDetailsFullImagePathLabel")%>
<i><% if (ecouponsummary.getFullImagePath() != null) { %><%= ecouponsummary.getFullImagePath() %><% } %></i></p>

<p><%=eCouponWizardNLS.get("eCouponDetailsPurchaseCond")%>
<i>
<% if (ecouponsummary.getPurchaseConditionType() == 1)
{%>
	<script language="JavaScript">
		writePurchaseCondition();	
	</script>
</i></p>
<%
	if ( ecouponsummary.getOrderType() == ECECouponConstant.BY_PERCENTAGE)
	{%>
		<p><%=eCouponWizardNLS.get("eCouponDetailsDiscValue")%>
		<% Double orderPercentAmt = ECStringConverter.StringToDouble(ecouponsummary.getOrderPercentageAmt()); %>
		<i><%=orderPercentAmt.intValue()%></i>
		<i><%=eCouponWizardNLS.get("percentage_symbol")%></i></p>
	<% }
	else {%>
		<p><%=eCouponWizardNLS.get("eCouponDetailsDiscValue")%>
		<i><script language="JavaScript">
		  fixedValue();
		  writeCurrency();
			</script>
		</i></p>
	<% } %>
<%}
else if (ecouponsummary.getPurchaseConditionType() == 0)
{%>
	<%=eCouponWizardNLS.get("eCouponProductPurchaseCondition_title")%>

	<table class="list" border="0" cellpadding="1" cellspacing="1" id="WC_eCouponSummary_Table_1">
		<tr class="list_roles">
			<th class="list_header" textcolor="white"><%=eCouponWizardNLS.get("eCouponItemHeading")%></th>
			<th class="list_header" textcolor="white"><%=eCouponWizardNLS.get("eCouponSummaryQnty")%></th>
			<th class="list_header" textcolor="white"><%=eCouponWizardNLS.get("eCouponDiscountedHeading")%></th>
		</tr>
	<%	Vector prod = ecouponsummary.getProduct();
		Vector checkedProd = ecouponsummary.getCheckedProducts();
		int rowselect = 1;

		for(int i=0; i<prod.size(); i++)
		{
			Hashtable listElement = (Hashtable) prod.elementAt(i);
			if (rowselect == 1) {
				rowselect = 2;
			}
			else {
				rowselect = 1;
			}
		%>	<tr class="list_row<%=rowselect%>">
				<td id="WC_eCouponSummary_TableCell_1"><%=  (String)listElement.get(ECECouponConstant.PRODUCTSKU) %></td>
				<td id="WC_eCouponSummary_TableCell_2"><%= (String)listElement.get(ECECouponConstant.QUANTITY) %></td>
				<% if (checkedProd.contains((new Integer(i)).toString()))
				{%>
					<td id="WC_eCouponSummary_TableCell_3"><%= eCouponWizardNLS.get("eCouponDiscounted") %></td>
				<%}
				else
				{%>
					<td id="WC_eCouponSummary_TableCell_4"><%= eCouponWizardNLS.get("eCouponNotDiscounted") %></td>
				<% } %>
			</tr>
		<%}%>
	</table>
<%
	if ( ecouponsummary.getProductType() == ECECouponConstant.BY_PERCENTAGE)
	{%>
		<p><%=eCouponWizardNLS.get("eCouponDetailsDiscValue")%>
		<% Double productPercentAmt = ECStringConverter.StringToDouble(ecouponsummary.getProductPercentageAmt()); %>
		<i><%=productPercentAmt.intValue()%></i>
		<i><%=eCouponWizardNLS.get("percentage_symbol")%></i></p>
	<% }
	else {%>
		<p><%=eCouponWizardNLS.get("eCouponDetailsDiscValue")%>
		<i><script language="JavaScript">
		  fixedValue();
		  writeCurrency();
		
</script></i>
	<% }

}
else if (ecouponsummary.getPurchaseConditionType() == 2)
{ %>
	<%=eCouponWizardNLS.get("eCouponCategoryPurchaseCondition_title")%>
	</p><table class="list" border="0" cellpadding="1" cellspacing="1" id="WC_eCouponSummary_Table_2">
		<tr class="list_roles">
			<th class="list_header" textcolor="white"><%=eCouponWizardNLS.get("eCouponCategory")%></th>
			<th class="list_header" textcolor="white"><%=eCouponWizardNLS.get("eCouponMinQntyHeading")%></th>
			<th class="list_header" textcolor="white"><%=eCouponWizardNLS.get("eCouponMaxQntyHeading")%></th>
			<th class="list_header" textcolor="white"><%=eCouponWizardNLS.get("eCouponMinAmtHeading")%></th>
			<th class="list_header" textcolor="white"><%=eCouponWizardNLS.get("eCouponMaxAmtHeading")%></th>
			<th class="list_header" textcolor="white"><%=eCouponWizardNLS.get("eCouponDiscountedHeading")%></th>
		</tr>

	<%	Vector cat = ecouponsummary.getCategory();
		Vector checkedCat = ecouponsummary.getCheckedCategorys();
		int rowselect = 1;

		for(int i=0; i<cat.size(); i++)
		{
			Hashtable listElement = (Hashtable)cat.elementAt(i);
			if (rowselect == 1) {
				rowselect = 2;
			}
			else {
				rowselect = 1;
			}

		%>	<tr class="list_row<%=rowselect%>">
				<td id="WC_eCouponSummary_TableCell_5"><%= (String)listElement.get(ECECouponConstant.CATEGORYSKU)%></td>
				<td id="WC_eCouponSummary_TableCell_6"><% String minQnty = (String)listElement.get(ECECouponConstant.MINCATQUANTITY);
					 if (minQnty!=null)
					 	out.println(minQnty);
				%></td>
				<td id="WC_eCouponSummary_TableCell_7"><% String maxQnty = (String)listElement.get(ECECouponConstant.MAXCATQUANTITY);
					 if (maxQnty!=null)
					 	out.println(maxQnty);
				%></td>
				<td id="WC_eCouponSummary_TableCell_8"><% String minAmt = (String)listElement.get(ECECouponConstant.MINCATAMOUNT);
					 if (minAmt!=null)
//					 	out.println(minAmt);
{ %>
<script>
document.write(parent.numberToCurrency("<%=minAmt%>","<%=ecouponsummary.getECouponCurr()%>","<%=fLanguageId%>"));
document.write(" <%=ecouponsummary.getECouponCurr()%>");

</script>
<% }
				%></td>
				<td id="WC_eCouponSummary_TableCell_9"><% String maxAmt = (String)listElement.get(ECECouponConstant.MAXCATAMOUNT);
					 if (maxAmt!=null)
//					 	out.println(maxAmt);
{ %>
<script>
document.write(parent.numberToCurrency("<%=maxAmt%>","<%=ecouponsummary.getECouponCurr()%>","<%=fLanguageId%>"));
document.write(" <%=ecouponsummary.getECouponCurr()%>");

</script>
<% }
				%></td>
				<% if (checkedCat.contains((new Integer(i)).toString()))
				{%>
					<td id="WC_eCouponSummary_TableCell_10"><%= eCouponWizardNLS.get("eCouponDiscounted") %></td>
				<%}
				else
				{%>
					<td id="WC_eCouponSummary_TableCell_11"><%= eCouponWizardNLS.get("eCouponNotDiscounted") %></td>
				<% } %>
			</tr>
		<%}%>
	</table>
<%
	if ( ecouponsummary.getCategoryType() == ECECouponConstant.BY_PERCENTAGE)
	{%>
		<p><%=eCouponWizardNLS.get("eCouponDetailsDiscValue")%>
		<% Double categoryPercentAmt = ECStringConverter.StringToDouble(ecouponsummary.getCategoryPercentageAmt()); %>
		<i><%=categoryPercentAmt.intValue()%></i>
		<i><%=eCouponWizardNLS.get("percentage_symbol")%></i></p>
	<% }
	else {%>
		<p><%=eCouponWizardNLS.get("eCouponDetailsDiscValue")%>
		<i><script language="JavaScript">
		  fixedValue();
		  writeCurrency();
		
</script></i></p>
	<% }
} %>



<!--
<p><%=eCouponWizardNLS.get("eCouponDetailsCurrLabel")%>
<i><script language="JavaScript">
  writeCurrency();
</script></i>
</p>
-->

<p><%=eCouponWizardNLS.get("eCouponDetailsNumberToOffer")%>
<i><script language="JavaScript">
  writeTotalNumOffer();

</script></i>
</p>

<p><%=eCouponWizardNLS.get("eCouponDetailsNumberOffered")%>
<i><%=ecouponsummary.getNumOffered()%></i></p>

<p><%=eCouponWizardNLS.get("eCouponDetailsStatus")%>
<i><script language="JavaScript">
  writeStatus();

</script></i>
</p>

</form>
</body>
</html>

