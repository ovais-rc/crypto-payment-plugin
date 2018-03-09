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
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="java.text.NumberFormat" %>


<%@include file="LiveHelpCommon.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%= fLiveHelpHeader%>
<%@include file="../common/NumberFormat.jsp"%>
<script src="<%=sWebPath%>javascript/tools/common/Util.js"></script>
<title><%= UIUtil.toHTML( UIUtil.change((String)liveHelpNLS.get("RetrieveShoppingcartTitle"),"{0}",(String) request.getAttribute("Title")))%>
</title>
</head>
<body>
<p></p>
<dl>
	<dt><b><%=liveHelpNLS.get("RetrieveShoppingcartTopic")%>: </b></dt>
	<dd>
	<table class="list" id="WC_ShoppingCartLivehelpView_Table_1" >
		<thead>
			<tr class="list_roles">
				<th id="WC_ShoppingCartLivehelpView_TableHeader_1" class="list_header"><%= UIUtil.toHTML(liveHelpNLS.get("RetrieveShoppingcartTable_OrderItem_Quantity").toString())%></th>
				<th id="WC_ShoppingCartLivehelpView_TableHeader_2" class="list_header"><%= UIUtil.toHTML(liveHelpNLS.get("RetrieveShoppingcartTable_OrderItem_SKU").toString())%></th>
				<th id="WC_ShoppingCartLivehelpView_TableHeader_3" class="list_header"><%= UIUtil.toHTML(liveHelpNLS.get("RetrieveShoppingcartTable_Description").toString())%></th>
				<th id="WC_ShoppingCartLivehelpView_TableHeader_4" class="list_header"><%= UIUtil.toHTML(liveHelpNLS.get("RetrieveShoppingcartTable_OrderItem_FulfilmentStatus").toString())%></th>
				<th id="WC_ShoppingCartLivehelpView_TableHeader_5" class="list_header"><%= UIUtil.toHTML(liveHelpNLS.get("RetrieveShoppingcartTable_OrderItem_CustomerComment").toString())%></th>
				<th id="WC_ShoppingCartLivehelpView_TableHeader_6" class="list_header"><%= UIUtil.toHTML(liveHelpNLS.get("RetrieveShoppingcartTable_OrderItem_Currency").toString())%></th>
				<th id="WC_ShoppingCartLivehelpView_TableHeader_7" class="list_header"><%= UIUtil.toHTML(liveHelpNLS.get("RetrieveShoppingcartTable_OrderItem_Price").toString())%></th>
			</tr>
		</thead>
		<%
	Vector vOrderItems= (Vector) request.getAttribute("ShoppingCart");
	NumberFormat nbFormat=NumberFormat.getInstance(aLocale);
	String classId=null;
	java.math.BigDecimal bdQuantity=null;
	java.math.BigDecimal bdPrice=null;
	double subTotal=0;
	String sCurrency=null;
	if (vOrderItems!=null && vOrderItems.size()>0 ) {
%>
		<tbody>
			<%
		for (int idx=0; idx <vOrderItems.size(); idx++ ) {
			if ((idx % 2) == 0) {
				classId="list_row1";
			} else {
				classId="list_row2";
			}
			Hashtable htOrderItem=(Hashtable) vOrderItems.get(idx);
			if (htOrderItem !=null) {
				 bdQuantity=new java.math.BigDecimal((String)htOrderItem.get("quantity"));
				 bdPrice=new java.math.BigDecimal((String)htOrderItem.get("price"));
				 subTotal = subTotal + bdQuantity.longValue() * bdPrice.doubleValue();	
				 sCurrency=(String) htOrderItem.get("baseCurrency");
%>
			<tr class="<%=classId%>">
				<td headers="WC_ShoppingCartLivehelpView_TableHeader_1" class="list_info1" id="WC_ShoppingCartLivehelpView_TableCell_1" ><i><%=UIUtil.toHTML(nbFormat.format(bdQuantity.longValue()))%></i>
				</td>
				<td headers="WC_ShoppingCartLivehelpView_TableHeader_2" class="list_info1" id="WC_ShoppingCartLivehelpView_TableCell_2" ><i><%=UIUtil.toHTML((String)htOrderItem.get("partNumber"))%></i>
				</td>
				<td headers="WC_ShoppingCartLivehelpView_TableHeader_3" class="list_info1" id="WC_ShoppingCartLivehelpView_TableCell_3" ><i><%=UIUtil.toHTML((String)htOrderItem.get("description"))%></i>
				</td>
				<td headers="WC_ShoppingCartLivehelpView_TableHeader_4" class="list_info1" id="WC_ShoppingCartLivehelpView_TableCell_4" ><i><%=UIUtil.toHTML((String)htOrderItem.get("fulfilmentStatus"))%></i>
				</td>
				<td headers="WC_ShoppingCartLivehelpView_TableHeader_5" class="list_info1" id="WC_ShoppingCartLivehelpView_TableCell_5" ><i><%=UIUtil.toHTML((String)htOrderItem.get("customerComment"))%></i>
				</td>
				<td headers="WC_ShoppingCartLivehelpView_TableHeader_6" class="list_info1" id="WC_ShoppingCartLivehelpView_TableCell_6" ><i><%=UIUtil.toHTML((String)htOrderItem.get("baseCurrency"))%></i>
				</td>
				<td headers="WC_ShoppingCartLivehelpView_TableHeader_7" class="list_info1" id="WC_ShoppingCartLivehelpView_TableCell_7" ><i><script>document.write(numberToCurrency(<%=bdPrice.doubleValue()%>,"<%=UIUtil.toJavaScript((String)htOrderItem.get("baseCurrency"))%>","<%=fLanguageId%>"))</script></i>
				</td>
			</tr>
			<%			}
		}
	if (!classId.equals("list_row1")) {
		classId="list_row1";
	} else {
		classId="list_row2";
	}
%>
			<tr class="<%=classId%>">
				<td colspan="6" class="list_info1" align="right" id="WC_ShoppingCartLivehelpView_TableCell_8">
					<i><%= UIUtil.toHTML(liveHelpNLS.get("RetrieveShoppingcartTable_OrderSummary_TotalAmount").toString())%></i>
				</td>
				<td headers="t7" class="list_info1" id="WC_ShoppingCartLivehelpView_TableCell_9">
					<i><script>document.write(numberToCurrency(<%=subTotal%>,"<%=UIUtil.toJavaScript(sCurrency)%>","<%=fLanguageId%>"))</script></i>
				</td>
			</tr>
		</tbody>
		<%
	}

%>
	</table>
	</dd>
</dl>
<p></p>
</body>
</html>
