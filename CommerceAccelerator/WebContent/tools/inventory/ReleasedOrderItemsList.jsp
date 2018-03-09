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
// 020723	    KNG		Initial Create
//
// 020813	    KNG		Make changes from code review and
//				UCD design exploration sessions
////////////////////////////////////////////////////////////////////////////////
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>

<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.helpers.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.beans.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@include file="ReleaseOrdersHelper.jsp" %>
<%@include file="../../tools/common/common.jsp" %>

<%--
//---------------------------------------------------------------------
//- Logic Section
//---------------------------------------------------------------------
--%>
<%
   	// obtain the resource bundle for display
	CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale 		= cmdContextLocale.getLocale();
	Integer languageId	= cmdContextLocale.getLanguageId();
	String storeId		= cmdContextLocale.getStoreId().toString();

	StoreAccessBean sa = cmdContextLocale.getStore();
	String storeTP = sa.getStoreType();
	String storeType = "";
	if ( storeTP == null ) {
		storeType = "";
	} else {
		storeType = storeTP.trim();
	}

	Vector specialFFMCDisplayNames = getSpecialFFMCsInformation(storeId.toString(), languageId.toString(), 1);
	String ffmStoreId = null;
	if (specialFFMCDisplayNames != null && specialFFMCDisplayNames.size()>0 ) {
		ffmStoreId = (String)specialFFMCDisplayNames.elementAt(0);
	}
	
	String host = request.getServerName();
	String StoresWebPath = ConfigProperties.singleton().getValue("WebServer/StoresWebPath");
   	
	Hashtable releaseOrderItemsNLS 	= (Hashtable)ResourceDirectory.lookup("inventory.releaseOrderItemsNLS", jLocale);

	// retrieve request parameters
	JSPHelper jspHelper	 = new JSPHelper(request);
	String orderId		 = jspHelper.getParameter("orderId");
	String orderDateSD	 = jspHelper.getParameter("orderDateSD");
	String orderDateED	 = jspHelper.getParameter("orderDateED");
	String shopcartDateSD    = jspHelper.getParameter("shopcartDateSD");
	String shopcartDateED	 = jspHelper.getParameter("shopcartDateED");
	String maxMatches	 = jspHelper.getParameter("fetchSize");
	
	//get product search bean
	ReleasedOrderItemsListBean releasedOIListBean = new ReleasedOrderItemsListBean();
	releasedOIListBean.setStoreId(storeId);
	releasedOIListBean.setOrderId(orderId);
	releasedOIListBean.setOrderPlacedSD(orderDateSD);
	releasedOIListBean.setOrderPlacedED(orderDateED);
	releasedOIListBean.setReleasedSD(shopcartDateSD);
	releasedOIListBean.setReleasedED(shopcartDateED);
	releasedOIListBean.setMaxMatches(maxMatches);
	releasedOIListBean.setCommandContext(cmdContextLocale);
	com.ibm.commerce.beans.DataBeanManager.activate(releasedOIListBean, request);
	
%>

<HTML>
<HEAD>

<LINK REL=stylesheet HREF="<%= UIUtil.getCSSFile(jLocale) %>" TYPE="text/css"> 

<TITLE><%= UIUtil.toHTML((String)releaseOrderItemsNLS.get("ReleasedOrderItemsListTitle")) %></TITLE>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">
function getHelp() {
	return "FF.fulfill.FindShopCartsResults.Help";
}

function getResultsSize() {
	return <%=releasedOIListBean.getListSize() %>;
}

function getQuickviewBCT() {
	return "<%=UIUtil.toJavaScript((String)releaseOrderItemsNLS.get("quickviewBCT"))%>";
}

function quickviewAction (orderId) {
<%
	if (storeType.equalsIgnoreCase("B2C") || storeType.equalsIgnoreCase("RHS") || storeType.equalsIgnoreCase("MHS")) {
%>
	top.setContent(getQuickviewBCT(),'/webapp/wcs/tools/servlet/DialogView?XMLFile=order.orderDetailsDialogB2C&amp;orderId='+orderId,true);
<%
	} else {
%>
	top.setContent(getQuickviewBCT(),'/webapp/wcs/tools/servlet/DialogView?XMLFile=order.orderDetailsDialogB2B&amp;orderId='+orderId,true);
<%
	}
%>
}

function getShopcartViewBCT() {
	return "<%=UIUtil.toJavaScript((String)releaseOrderItemsNLS.get("ReleasedOrderItemsListShopcartViewBCT"))%>";
}

function shopcartViewAction (shopcartId) {
	url = 'https://<%=host%>/<%=StoresWebPath.substring(1,StoresWebPath.length())%>/ShopCartDetailDisplayView?storeId=<%=ffmStoreId%>&amp;orderId='+shopcartId+'&amp;langId=<%=languageId%>&amp;orderRn='+shopcartId;

	top.location = url;

}

function init() {
      	parent.setContentFrameLoaded(true);
}

</SCRIPT>
</HEAD>


<BODY CLASS="content" ONLOAD="init();">
<FORM NAME="itemListForm">
<H1><%= UIUtil.toHTML((String)releaseOrderItemsNLS.get("ReleasedOrderItemsListTitle")) %></H1>
<%= (String)releaseOrderItemsNLS.get("ReleasedOrderItemsListDescription") %>

	<BR><BR>

	<TABLE CLASS="list" BORDER=0 CELLPADDING=1 CELLSPACING=1 WIDTH=100%>
	<TR CLASS="list_roles">
	<TD bgcolor="#1B436F" width=10%>
   		<TABLE CLASS="list_roles">
		<TR>
		<TD CLASS="list_header">
		<%= UIUtil.toHTML((String)releaseOrderItemsNLS.get("ReleasedOrderItemsListShopcartNumber")) %>
		</TD>
		</TR>
		</TABLE>
	</TD>
	<TD bgcolor="#1B436F" width=10%>
   		<TABLE CLASS="list_roles">
		<TR>
		<TD CLASS="list_header">
		<%= UIUtil.toHTML((String)releaseOrderItemsNLS.get("ReleasedOrderItemsListOrderNumber")) %>
		</TD>
		</TR>
		</TABLE>
	</TD>
	<TD bgcolor="#1B436F" width=30%>
   		<TABLE CLASS="list_roles">
		<TR>
		<TD CLASS="list_header">
		<%= UIUtil.toHTML((String)releaseOrderItemsNLS.get("ReleasedOrderItemsListProduct")) %>
		</TD>
		</TR>
		</TABLE>
	</TD>
	<TD bgcolor="#1B436F" width=15%>
   		<TABLE CLASS="list_roles">
		<TR>
		<TD CLASS="list_header">
		<%= UIUtil.toHTML((String)releaseOrderItemsNLS.get("ReleasedOrderItemsListSKU")) %>
		</TD>
		</TR>
		</TABLE>
	</TD>
	<TD bgcolor="#1B436F" width=8%>
   		<TABLE CLASS="list_roles">
		<TR>
		<TD CLASS="list_header">
		<%= UIUtil.toHTML((String)releaseOrderItemsNLS.get("ReleasedOrderItemsListQuantity")) %>
		</TD>
		</TR>
		</TABLE>
	</TD>
	<TD bgcolor="#1B436F" width=15%>
   		<TABLE CLASS="list_roles">
		<TR>
		<TD CLASS="list_header">
		<%= UIUtil.toHTML((String)releaseOrderItemsNLS.get("ReleasedOrderItemsListReleasedToDate")) %>
		</TD>
		</TR>
		</TABLE>
	</TD>
	<TD bgcolor="#1B436F" width=12%>
   		<TABLE CLASS="list_roles">
		<TR>
		<TD CLASS="list_header">
		<%= UIUtil.toHTML((String)releaseOrderItemsNLS.get("ReleasedOrderItemsListStatus")) %>
		</TD>
		</TR>
		</TABLE>
	</TD>
	</TR>	

	<%
	int rowselect = 2;
	String bgcolor = "#EBF0EE";
	String currentShopCartId = null;
	int i=0;
	while (i<releasedOIListBean.getListSize())
	{
		if ( (currentShopCartId == null) || (!currentShopCartId.equals(releasedOIListBean.getReleasedOrderItemsListData(i).getExtordnum())) ) {
			if (rowselect == 1) {
				rowselect = 2;
				bgcolor = "#EBF0EE";
			} else {
				rowselect = 1;
				bgcolor = "#FFFFFF";
			}
			currentShopCartId = releasedOIListBean.getReleasedOrderItemsListData(i).getExtordnum();
			%>
			<TR>
			<TD bgcolor="<%= bgcolor %>" width=10%>
   				<TABLE CLASS="list_role_off">
				<TR>
				<TD CLASS="list_row">
				<A HREF="javascript:shopcartViewAction('<%= releasedOIListBean.getReleasedOrderItemsListData(i).getExtordnum() %>')"><%= releasedOIListBean.getReleasedOrderItemsListData(i).getExtordnum() %></A>
				</TD>
				</TR>
				</TABLE>
			</TD>
			<TD bgcolor="<%= bgcolor %>" width=10%>
   				<TABLE CLASS="list_role_off">
				<TR>
				<TD CLASS="list_row">
				</TD>
				</TR>
				</TABLE>
			</TD>
			<TD bgcolor="<%= bgcolor %>" width=30%>
   				<TABLE CLASS="list_role_off">
				<TR>
				<TD CLASS="list_row">
				</TD>
				</TR>
				</TABLE>
			</TD>
			<TD bgcolor="<%= bgcolor %>" width=15%>
   				<TABLE CLASS="list_role_off">
				<TR>
				<TD CLASS="list_row">
				</TD>
				</TR>
				</TABLE>
			</TD>
			<TD bgcolor="<%= bgcolor %>" width=8%>
   				<TABLE CLASS="list_role_off">
				<TR>
				<TD CLASS="list_row">
				</TD>
				</TR>
				</TABLE>
			</TD>
			<TD bgcolor="<%= bgcolor %>" width=15%>
   				<TABLE CLASS="list_role_off">
				<TR>
				<TD CLASS="list_row">
				</TD>
				</TR>
				</TABLE>
			</TD>
			<TD bgcolor="<%= bgcolor %>" width=12%>
   				<TABLE CLASS="list_role_off">
				<TR>
				<TD CLASS="list_row">
				</TD>
				</TR>
				</TABLE>
			</TD>
		<%
		} else {
		%>
			<TR>
			<TD bgcolor="<%= bgcolor %>" width=10%>
   				<TABLE CLASS="list_role_off">
				<TR>
				<TD CLASS="list_row">
				</TD>
				</TR>
				</TABLE>
			</TD>
			<TD bgcolor="<%= bgcolor %>" width=10%>
   				<TABLE CLASS="list_role_off">
				<TR>
				<TD CLASS="list_row">
				<A HREF="javascript:quickviewAction('<%= releasedOIListBean.getReleasedOrderItemsListData(i).getOrderItemAB().getOrderId() %>')"><%= releasedOIListBean.getReleasedOrderItemsListData(i).getOrderItemAB().getOrderId() %></A>
				</TD>
				</TR>
				</TABLE>
			</TD>
			<TD bgcolor="<%= bgcolor %>" width=30%>
   				<TABLE CLASS="list_role_off">
				<TR>
				<TD CLASS="list_row">
				<%= releasedOIListBean.getReleasedOrderItemsListData(i).getProductName() %>
				</TD>
				</TR>
				<% 
				if (releasedOIListBean.getReleasedOrderItemsListData(i).isPackage()) {
					int numberItemsInPackage = releasedOIListBean.getReleasedOrderItemsListData(i).getNumItemsInPackage();
					for (int j=0; j<numberItemsInPackage; j++) {
						%>
						<TR>
						<TD CLASS="list_row">
						&nbsp;&nbsp;<%= getFormattedQuantity(releasedOIListBean.getReleasedOrderItemsListData(i).getPackageContentQuantities(j), jLocale) %> <%= releasedOIListBean.getReleasedOrderItemsListData(i).getPackageContentNames(j) %>
						</TD>
						</TR>
						<%
					}
				} else if (releasedOIListBean.getReleasedOrderItemsListData(i).isConfiguredItem()) {
					int numberItemsInConfiguredItem = releasedOIListBean.getReleasedOrderItemsListData(i).getNumItemsInConfiguredItem();
					for (int j=0; j<numberItemsInConfiguredItem; j++) {
						%>
						<TR>
						<TD CLASS="list_row">
						&nbsp;&nbsp;<%= getFormattedQuantity(releasedOIListBean.getReleasedOrderItemsListData(i).getConfiguredItemContentQuantities(j), jLocale) %> <%= releasedOIListBean.getReleasedOrderItemsListData(i).getConfiguredItemContentNames(j) %>
						</TD>
						</TR>
						<%
					}			
				}
				%>
				</TABLE>
			</TD>
			<TD bgcolor="<%= bgcolor %>" width=15%>
   				<TABLE CLASS="list_role_off">
				<TR>
				<TD CLASS="list_row">
				<%= releasedOIListBean.getReleasedOrderItemsListData(i).getOrderItemAB().getPartNumber() %>
				</TD>
				</TR>
				<% 
				if (releasedOIListBean.getReleasedOrderItemsListData(i).isPackage()) {
					int numberItemsInPackage = releasedOIListBean.getReleasedOrderItemsListData(i).getNumItemsInPackage();
					for (int j=0; j<numberItemsInPackage; j++) {
						%>
						<TR>
						<TD CLASS="list_row">
						&nbsp;&nbsp;<%= releasedOIListBean.getReleasedOrderItemsListData(i).getPackageContentSKUs(j) %>
						</TD>
						</TR>
						<%
					}
				} else if (releasedOIListBean.getReleasedOrderItemsListData(i).isConfiguredItem()) {
					int numberItemsInConfiguredItem = releasedOIListBean.getReleasedOrderItemsListData(i).getNumItemsInConfiguredItem();
					for (int j=0; j<numberItemsInConfiguredItem; j++) {
						%>
						<TR>
						<TD CLASS="list_row">
						&nbsp;&nbsp;<%= releasedOIListBean.getReleasedOrderItemsListData(i).getConfiguredItemContentSKUs(j) %>
						</TD>
						</TR>
						<%
					}			
				}
				%>
				</TABLE>
			</TD>
			<TD bgcolor="<%= bgcolor %>" width=8%>
   				<TABLE CLASS="list_role_off">
				<TR>
				<TD CLASS="list_row">
				<%= getFormattedQuantity(releasedOIListBean.getReleasedOrderItemsListData(i).getOrderItemAB().getQuantity(), jLocale) %>
				</TD>
				</TR>
				</TABLE>
			</TD>
			<TD bgcolor="<%= bgcolor %>" width=15%>
  	 			<TABLE CLASS="list_role_off">
				<TR>
				<TD CLASS="list_row">
				<%= releasedOIListBean.getReleasedOrderItemsListData(i).getDisplayReleasedDate() %>
				</TD>
				</TR>
				</TABLE>
			</TD>
			<TD bgcolor="<%= bgcolor %>" width=12%>
   				<TABLE CLASS="list_role_off">
				<TR>
				<TD CLASS="list_row">
				<%= UIUtil.toHTML((String)releaseOrderItemsNLS.get((String)releasedOIListBean.getReleasedOrderItemsListData(i).getFulfillmentStatus())) %>
				</TD>
				</TR>
				</TABLE>
			</TD>
			<%
			i++;
		}
	} 
	%>
		
<%
	if (releasedOIListBean.getListSize() == 0) {
%>

<P><P>
<TABLE CELLSPACING=0 CELLPADDING=3 BORDER=0>
<TR>
	<TD COLSPAN=7>
		<%= UIUtil.toHTML((String)releaseOrderItemsNLS.get("ReleasedOrderItemsListNoItemsFound")) %>
	</TD>
</TR>
</TABLE>
<% 	} %>
</FORM>
</BODY>
</HTML>
