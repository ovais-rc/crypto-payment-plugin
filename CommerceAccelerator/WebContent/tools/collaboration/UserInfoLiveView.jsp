<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2003
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//------------------------------------------------------------------------------
//
////////////////////////////////////////////////////////////////////////////////
--%>

<%@ page language="java" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>

<%@include file="LiveHelpCommon.jsp" %>
<%
  Hashtable htProfile= (Hashtable) request.getAttribute("ShopperProfile");
  Hashtable htLastOrder= null;
  Vector vOrderHistory= null; 
  boolean bHasProfile=false;
  if (htProfile!=null) {
  	String sTemp=(String) htProfile.get("HasProfile");
  	if (sTemp !=null && sTemp.equals("TRUE")) {
		bHasProfile=true;
		htLastOrder=(Hashtable) htProfile.get("LastOrder");
		vOrderHistory=(Vector) htProfile.get("OrderHistory");
		}
  	} 
  else {
  	htProfile=new Hashtable();
  	}
  
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%= fLiveHelpHeader%>
<%@include file="../common/NumberFormat.jsp"%>
<script src="<%=sWebPath%>javascript/tools/common/Util.js"></script>
<title><%= UIUtil.toHTML( UIUtil.change((String)liveHelpNLS.get("RetrieveShopperProfileTitle"),"{0}",(String) request.getAttribute("Title")))%>
</title>
</head>
<body>
<h1><% if (bHasProfile) { %> <%= UIUtil.toHTML( UIUtil.change((String)liveHelpNLS.get("RetrieveShopperProfileTitle"),"{0}",(String) request.getAttribute("Title")))%>
<% } else { %> <%=liveHelpNLS.get("RetrieveShopperProfileTopic")%> <% } %>
</h1>
<dl>
	<dt><b><%=liveHelpNLS.get("RetrieveShopperProfile_Identification")%></b>
	</dt>
	<dd><%=liveHelpNLS.get("RetrieveShopperProfile_Identification_ShopperId")%>
	<i><%=UIUtil.toHTML((String) htProfile.get("Identify"))%></i></dd>
	<dd><%=liveHelpNLS.get("RetrieveShopperProfile_Identification_Description")%>
	<% if (bHasProfile) { %> <i><%= UIUtil.toHTML((String) htProfile.get("Description"))%></i>
	<% } else { %> <i><%=liveHelpNLS.get("RetrieveShopperProfile_Identification_Unregistered")%></i>
	<% } %>
	<p></p>
	<%
if (bHasProfile) {
%></dd>
	<dt><b><%=liveHelpNLS.get("RetrieveShopperProfile_Preference")%></b></dt>
	<dd><%=liveHelpNLS.get("RetrieveShopperProfile_Preference_Language")%>
	<i><%=UIUtil.toHTML((String) htProfile.get("Language"))%></i></dd>
	<dd><%=liveHelpNLS.get("RetrieveShopperProfile_Preference_Currency")%>
	<i><%=UIUtil.toHTML((String) htProfile.get("Currency"))%></i></dd>
	<dd><%=liveHelpNLS.get("RetrieveShopperProfile_Preference_DeliverMethod")%>
	<i><%=UIUtil.toHTML((String) htProfile.get("DeliveryMethod"))%></i>
	<p></p>
	<% if (htLastOrder != null ) { %>
	<p></p>
	</dd>
	<dt><b><%=liveHelpNLS.get("RetrieveShopperProfile_LastOrder")%></b></dt>
	<dd><%=liveHelpNLS.get("RetrieveShopperProfile_LastOrder_Date")%> <i><%=UIUtil.toHTML((String) htLastOrder.get("LastOrdered"))%></i>
	</dd>
	<dd><%=liveHelpNLS.get("RetrieveShopperProfile_LastOrder_Amount")%> <i><script>document.write(numberToCurrency(<%=((java.math.BigDecimal) htLastOrder.get("LastOrderValue")).doubleValue()%>,"<%=UIUtil.toJavaScript((String)htLastOrder.get("LastOrderCurrency"))%>","<%=fLanguageId%>"))</script></i>
	</dd>
	<dd><%=liveHelpNLS.get("RetrieveShopperProfile_LastOrder_Status")%> <i><%=UIUtil.toHTML((String) htLastOrder.get("LastOrderStatus"))%></i>
	<p></p>
	<p></p>
	</dd>
	<dt><b><%=liveHelpNLS.get("RetrieveShopperProfile_UserOrderHistory")%></b>
	</dt>
	<dd>
	<table class="list" id="WC_UserInfoLiveView_Table_1">
		<thead>
			<tr class="list_roles">
				<th id="WC_UserInfoLiveView_TableHeader_1" class="list_header"><%= UIUtil.toHTML(liveHelpNLS.get("RetrieveShopperProfileTable_UserOrderHistory_Date").toString())%></th>
				<th id="WC_UserInfoLiveView_TableHeader_2" class="list_header"><%= UIUtil.toHTML(liveHelpNLS.get("RetrieveShopperProfileTable_UserOrderHistory_OrderNumber").toString())%></th>
				<th id="WC_UserInfoLiveView_TableHeader_3" class="list_header"><%= UIUtil.toHTML(liveHelpNLS.get("RetrieveShopperProfileTable_UserOrderHistory_Status").toString())%></th>
				<th id="WC_UserInfoLiveView_TableHeader_4" class="list_header"><%= UIUtil.toHTML(liveHelpNLS.get("RetrieveShopperProfileTable_UserOrderHistory_Currency").toString())%></th>
				<th id="WC_UserInfoLiveView_TableHeader_5" class="list_header"><%= UIUtil.toHTML(liveHelpNLS.get("RetrieveShopperProfileTable_UserOrderHistory_TotalAmount").toString())%></th>
			</tr>
		</thead>
		<tbody>
			<%
		String classId=null;
		for (int idx=0; idx <vOrderHistory.size(); idx++ ) {
			if ((idx % 2) == 0) {
				classId="list_row1";
			} else {
				classId="list_row2";
			}
			Hashtable htOrder=(Hashtable) vOrderHistory.get(idx);
			if (htOrder !=null) {
	%>
			<tr class="<%=classId%>">
				<td headers="WC_UserInfoLiveView_TableHeader_1" class="list_info1" id="WC_UserInfoLiveView_TableCell_1"><i><%=UIUtil.toHTML((String) htOrder.get("OrderTimePlaced"))%></i>
				</td>
				<td headers="WC_UserInfoLiveView_TableHeader_2" class="list_info1" id="WC_UserInfoLiveView_TableCell_2"><i><%=UIUtil.toHTML((String) htOrder.get("OrderId"))%></i>
				</td>
				<td headers="WC_UserInfoLiveView_TableHeader_3" class="list_info1" id="WC_UserInfoLiveView_TableCell_3"><i><%=UIUtil.toHTML((String) htOrder.get("OrderStatus"))%></i>
				</td>
				<td headers="WC_UserInfoLiveView_TableHeader_4" class="list_info1" id="WC_UserInfoLiveView_TableCell_4"><i><%=UIUtil.toHTML((String) htOrder.get("OrderCurrency"))%></i>
				</td>
				<td headers="WC_UserInfoLiveView_TableHeader_5" class="list_info1" id="WC_UserInfoLiveView_TableCell_5"><i><script>document.write(numberToCurrency(<%=((java.math.BigDecimal) htOrder.get("OrderTotalAmount")).doubleValue()%>,"<%=UIUtil.toJavaScript((String)htOrder.get("OrderCurrency"))%>","<%=fLanguageId%>"))</script></i>
				</td>
			</tr>
			<% 
				}
			}
	%>
		</tbody>
	</table>
	<% } %> <% } %></dd>
</dl>

</body>
</html>
