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
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.inventory.commands.*" %>
<%@ page import="com.ibm.commerce.order.utils.*" %>
<%@ page import="com.ibm.commerce.fulfillment.beans.*" %>
<%@ page import="com.ibm.commerce.ras.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.helpers.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.beans.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
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
Integer storeId 	= cmdContextLocale.getStoreId();

StoreAccessBean sa = cmdContextLocale.getStore();
String storeTP = sa.getStoreType();
String storeType = "";
if ( storeTP == null ) {
	storeType = "";
} else {
	storeType = storeTP.trim();
}
	
Vector specialFFMCDisplayNames = getSpecialFFMCsInformation(storeId.toString(), languageId.toString(), 0);
String firstDisplayName = null;
if (specialFFMCDisplayNames != null && specialFFMCDisplayNames.size()>0 ) {
	firstDisplayName = (String)specialFFMCDisplayNames.elementAt(0);
}

Hashtable releaseOrderItemsNLS 	= (Hashtable)ResourceDirectory.lookup("inventory.releaseOrderItemsNLS", jLocale);

com.ibm.commerce.server.JSPHelper URLParameters = new com.ibm.commerce.server.JSPHelper(request);

// get standard list parameters
int startIndex 		= Integer.parseInt(URLParameters.getParameter("startindex"));
int listSize 		= Integer.parseInt(URLParameters.getParameter("listsize"));
int endIndex		= startIndex + listSize;

//get OrderItemsToReleaseListBean to perform the search
OrderItemsToReleaseListBean oiList = new OrderItemsToReleaseListBean();
oiList.setStoreId(storeId.toString());
oiList.setStartIndex(new Integer(startIndex));
oiList.setMaxListSize(new Integer(listSize));
com.ibm.commerce.beans.DataBeanManager.activate(oiList, request);
	
int totalsize = 0;
if (oiList != null && oiList.getResultSetSize() != 0) {
	totalsize = oiList.getResultSetSize();
}
%>


<HTML>
<HEAD>

<LINK REL=stylesheet HREF="<%= UIUtil.getCSSFile(jLocale) %>" TYPE="text/css"> 

<TITLE><%= UIUtil.toHTML((String)releaseOrderItemsNLS.get("ReleaseOrderItemsTitle")) %></TITLE>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT src="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT src="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">
//---------------------------------------------------------------------
//  Required javascript function for wizard panel and list
//---------------------------------------------------------------------
function onLoad() {
	parent.loadFrames();
}

function initializeState() {
	parent.parent.setContentFrameLoaded(true);
}

function getResultsSize() {
	return <%= oiList.getResultSetSize() %>;
}

function getQuickviewBCT() {
	return "<%=UIUtil.toJavaScript((String)releaseOrderItemsNLS.get("quickviewBCT"))%>";
}

function getShopcartOptionsBCT() {
	return "<%=UIUtil.toJavaScript((String)releaseOrderItemsNLS.get("shopcartOptionsBCT"))%>";
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

function saveCurrentSelection(selectName) {
	var anArray = selectName.split("_");
	var orderItemId = anArray[1];
	
	var ffmcValue = document.releaseOrderItemListForm["ffmc_" + orderItemId].options[document.releaseOrderItemListForm["ffmc_" + orderItemId].selectedIndex].value;
	parent.parent.put(orderItemId, ffmcValue);
}

function release() {
	// verify there is something selected
	var checkeds = new Array;
	checkeds = parent.getChecked();
	
	if (checkeds.length == 0) {
		alertDialog("<%=UIUtil.toJavaScript((String)releaseOrderItemsNLS.get("ReleaseOrderItemsNothingSelected"))%>");
		return;
	}
	
	// create the URL parameters for command or Shopcart page
	var orderItemIds = ""; // for Shopcart page
	var ffmcIds = ""; // for Shopcart page
	var FFMStores = ""; // for Shopcart page
	var FFMStoresHash = new Object();
	
	var ids;
	var orderIds = new Vector();
	var URLParam = new Object(); // for calling command
	URLParam["<%= AssignToSpecifiedFulfillmentCenterCmd.STR_ALLOCATE %>"] = "1";
	URLParam["<%= AssignToSpecifiedFulfillmentCenterCmd.STR_RELEASE %>"] = "1";
	
	var ffmcValue;
	var ffmcId;
	for (var i=0; i<checkeds.length; i++) {
		ids = checkeds[i].split("_");
		// save orderItemId
		URLParam["<%= OrderConstants.EC_ORDERITEM_ID %>" + "_" + (i+1)] = ids[0];
		if (i == 0) {
			orderItemIds = ids[0];
		} else {
			orderItemIds = orderItemIds + "," + ids[0];
		}
		if (!orderIds.contains(ids[1])) {
			addElement(ids[1], orderIds);
		}
		
		//save ffmcenterId
		ffmcValue = parent.parent.get(ids[0]);
		ffmcId = ffmcValue.split("_");
		URLParam["ffmcenterId" + "_" + (i+1)] = ffmcId[0];
		if (i == 0) {
			ffmcIds = ffmcId[0];
		} else {
			ffmcIds = ffmcIds + "," + ffmcId[0];
		}
		
		if (ffmcId[1] == "true") {
			if (!defined(FFMStoresHash[ffmcId[2]])) {
				FFMStoresHash[ffmcId[2]] = ffmcId[2];
				if (FFMStores == "") {
					FFMStores = ffmcId[2];
				} else {
					FFMStores = FFMStores + "," + ffmcId[2];
				}
			}
		}
	}

	// determine the next action item: call command or go to shopcart options dialog
	parent.parent.setContentFrameLoaded(false);
	if (FFMStores != "") {
		ordersString = "";
		for(k=0; k<size(orderIds); k++) {
			if (k==0) {
				ordersString = elementAt(k, orderIds);
			} else {
				ordersString = ordersString + "," + elementAt(k, orderIds);
			}
		}
		top.setContent(getShopcartOptionsBCT(),'/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.releaseToShoppingCart&orderItemIds='+orderItemIds+'&ffmcIds='+ffmcIds+'&FFMStores='+FFMStores+'&orderIds='+ordersString, true);
	} else {
		var returnURL = "ReleaseOrderItemsRedirect";

		URLParam.URL = returnURL;
		URLParam["<%= ECConstants.EC_ERROR_VIEWNAME %>"] = "ReleaseOrderItemsErrorView";

		var url = "/webapp/wcs/tools/servlet/AssignToSpecifiedFulfillmentCenter?";
		for(k=0; k<size(orderIds); k++) {
			if (k==0) {
				url = url + "<%= OrderConstants.EC_ORDER_ID %>=" + elementAt(k, orderIds);
			} else {
				url = url + "&<%= OrderConstants.EC_ORDER_ID %>=" + elementAt(k, orderIds);
			}
		}
		
		top.mccmain.submitForm(url,URLParam);
      		top.refreshBCT();
	}
}

function cancel() {
	var answer = parent.parent.confirmDialog('<%=UIUtil.toJavaScript((String)releaseOrderItemsNLS.get("cancelConfirmation"))%>');
	return answer ;
}

</SCRIPT>
</HEAD>


<BODY CLASS="content" ONLOAD="initializeState();">

<SCRIPT LANGUAGE="JavaScript">
<!--
//For IE
if (document.all) {
	onLoad();
}
-->
</SCRIPT>

<FORM NAME="releaseOrderItemListForm" >
<% if (firstDisplayName != null) {
	%>
	<SCRIPT LANGUAGE="JavaScript">
	var text = "<%= UIUtil.toJavaScript((String)releaseOrderItemsNLS.get("ReleaseOrderItemsDescriptionSpecial")) %>";
	var ffmname = "<%= firstDisplayName %>";
	text = text.replace(/%1/, ffmname);
	text = text.replace(/%1/, ffmname);
	document.writeln("<P>" + text + "<BR><BR>");
	</SCRIPT>
	<%
} else {
	%>
	<P><%= releaseOrderItemsNLS.get("ReleaseOrderItemsDescription") %><BR><BR>
<%
}
%>

<%= comm.startDlistTable("releaseOrderItemsTable") %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)releaseOrderItemsNLS.get("ReleaseOrderItemsOrderNumber"), null, false) %>
<%= comm.addDlistColumnHeading((String)releaseOrderItemsNLS.get("ReleaseOrderItemsProductName"), null, false) %>
<%= comm.addDlistColumnHeading((String)releaseOrderItemsNLS.get("ReleaseOrderItemsPartNumber"), null, false) %>
<%= comm.addDlistColumnHeading((String)releaseOrderItemsNLS.get("ReleaseOrderItemsQuantity"), null, false) %>
<%= comm.addDlistColumnHeading((String)releaseOrderItemsNLS.get("ReleaseOrderItemsFulfilledThrough"), null, false) %>
<%= comm.endDlistRow() %>

<%
// determine the endindex for this page
if (endIndex > oiList.getListSize()) {
	endIndex = oiList.getListSize();
}

// TABLE CONTENT
int rowselect = 2;
String currentOrderId = null;
int itemsInCurrentOrder = 0;
int i=0;
while (i<endIndex) {
	if ( (currentOrderId == null) || (!currentOrderId.equals(oiList.getOrderItemsToReleaseListData(i).getOrderItemAB().getOrderId())) ) {
		if (rowselect == 1) {
			rowselect = 2;
		} else {
			rowselect = 1;
		}
		currentOrderId = oiList.getOrderItemsToReleaseListData(i).getOrderItemAB().getOrderId();
		itemsInCurrentOrder = 0;
		%>
		<%= comm.startDlistRow(rowselect) %>
		<%= comm.addDlistColumn("","none") %>
		<%
		StringBuffer scriptBuffer = new StringBuffer();
		scriptBuffer.append("javascript:quickviewAction('");
		scriptBuffer.append(oiList.getOrderItemsToReleaseListData(i).getOrderItemAB().getOrderId());
		scriptBuffer.append("')");
		%>
		<%= comm.addDlistColumn(oiList.getOrderItemsToReleaseListData(i).getOrderItemAB().getOrderId(), scriptBuffer.toString()) %>
		<%= comm.addDlistColumn("","none") %>
		<%= comm.addDlistColumn("","none") %>
		<%= comm.addDlistColumn("","none") %>
		<%= comm.addDlistColumn("","none") %>
		<%= comm.endDlistRow() %>
	<%	
	} else {	
		%>
		<%= comm.startDlistRow(rowselect) %>
		<%
		StringBuffer orderItemId_orderId = new StringBuffer();
		orderItemId_orderId.append(oiList.getOrderItemsToReleaseListData(i).getOrderItemAB().getOrderItemId());
		orderItemId_orderId.append("_");
		orderItemId_orderId.append(oiList.getOrderItemsToReleaseListData(i).getOrderItemAB().getOrderId());
		%>
		<%= comm.addDlistCheck(orderItemId_orderId.toString(), "none") %>
		
		<%= comm.addDlistColumn("", "none") %>
	
		<%
		StringBuffer productName = new StringBuffer();
		StringBuffer productSKU = new StringBuffer();
		StringBuffer productQuantity = new StringBuffer();
		productName.append(oiList.getOrderItemsToReleaseListData(i).getProductName());
		productSKU.append(oiList.getOrderItemsToReleaseListData(i).getOrderItemAB().getPartNumber());
		productQuantity.append(getFormattedQuantity(oiList.getOrderItemsToReleaseListData(i).getOrderItemAB().getQuantity(), jLocale));
	
		// is this a package or a configured item
		if (oiList.getOrderItemsToReleaseListData(i).isPackage()) {
			int numberItemsInPackage = oiList.getOrderItemsToReleaseListData(i).getNumItemsInPackage();
			for (int j=0; j<numberItemsInPackage; j++) {
				productName.append("<BR>");
				productName.append("&nbsp;&nbsp;&nbsp;");
				productName.append(getFormattedQuantity(oiList.getOrderItemsToReleaseListData(i).getPackageContentQuantities(j), jLocale));
				productName.append("&nbsp;");
				productName.append(oiList.getOrderItemsToReleaseListData(i).getPackageContentNames(j));
				productSKU.append("<BR>");
				productSKU.append("&nbsp;&nbsp;&nbsp;");
				productSKU.append(oiList.getOrderItemsToReleaseListData(i).getPackageContentSKUs(j));
			
			}
		} else if (oiList.getOrderItemsToReleaseListData(i).isConfiguredItem()) {
			productName.append("<BR>");
			productName.append("&nbsp;&nbsp;&nbsp;");
			productSKU.append("<BR>");
			productSKU.append("&nbsp;&nbsp;&nbsp;");
			productQuantity.append("<BR>");
			productQuantity.append("&nbsp;&nbsp;&nbsp;");
			int numberItemsInConfiguredItem = oiList.getOrderItemsToReleaseListData(i).getNumItemsInConfiguredItem();
			for (int j=0; j<numberItemsInConfiguredItem; j++) {
				productName.append("<BR>");
				productName.append("&nbsp;&nbsp;&nbsp;");
				productName.append(getFormattedQuantity(oiList.getOrderItemsToReleaseListData(i).getConfiguredItemContentQuantities(j), jLocale));
				productName.append("&nbsp;");
				productName.append(oiList.getOrderItemsToReleaseListData(i).getConfiguredItemContentNames(j));
				productSKU.append("<BR>");
				productSKU.append("&nbsp;&nbsp;&nbsp;");
				productSKU.append(oiList.getOrderItemsToReleaseListData(i).getConfiguredItemContentSKUs(j));
			}		
		}
		%>
	
		<%= comm.addDlistColumn(productName.toString(), "none") %>
		<%= comm.addDlistColumn(productSKU.toString(), "none") %>
		<%= comm.addDlistColumn(productQuantity.toString(), "none" ) %>

		<%
		// create the drop down list:
		// 1. the name of the drop down widget is the "orderItemId"
		// 2. the value of the option is either "ffmcId_false" or "ffmcId_true_FFMStore"
		//    (true means the fulfillment center selected has a non-NULL FFMStore attribute)
		String orderItemFfmcId = oiList.getOrderItemsToReleaseListData(i).getOrderItemAB().getFulfillmentCenterId();
		StringBuffer orderItemFfmcIdValue = new StringBuffer(); // the value of the order item ffmc to be pre-selected
		StringBuffer defaultFfmcIdValue = new StringBuffer(); // the value of the default ffmc if the order item ffmc was empty
		StringBuffer ffmcIdValue = new StringBuffer(); // the value of a ffmc
	
		StringBuffer ffmcSelect = new StringBuffer();
		ffmcSelect.append("<select name=\"ffmc_");
		ffmcSelect.append(oiList.getOrderItemsToReleaseListData(i).getOrderItemAB().getOrderItemId());
		ffmcSelect.append("\" id=\"ffmc_");
		ffmcSelect.append(oiList.getOrderItemsToReleaseListData(i).getOrderItemAB().getOrderItemId());
		ffmcSelect.append("\" onChange=\"saveCurrentSelection(this.name)\">");
	
		Vector ffmcList = oiList.getOrderItemsToReleaseListData(i).getFulfillmentCenters();
		for (int k=0; k<ffmcList.size(); k++) {
			ffmcIdValue = new StringBuffer();
			Integer ffmc = (Integer)ffmcList.elementAt(k);
			String ffmcName = "";
			String FFMStore = null;
			boolean hasFFMStore = false;

			ffmcName = oiList.getFulfillmentCenterDisplayName(ffmc.toString());
			FFMStore = oiList.getFulfillmentCenterFFMStore(ffmc.toString());
			if ( (FFMStore != null) && (!FFMStore.equals("")) ) {
				//System.out.println("FFMStore = " + FFMStore);
				hasFFMStore = true;
			}
		
			// construct the default value
			if (k==0) {
				defaultFfmcIdValue.append(ffmc.toString());
				defaultFfmcIdValue.append("_");
				defaultFfmcIdValue.append(hasFFMStore);
				if (hasFFMStore) {
					defaultFfmcIdValue.append("_");
					defaultFfmcIdValue.append(FFMStore);
				}
			}

			// try to pre-select the fulfillment center of the order item
			// and construct the value for the ffmc
			String selected = "";
			if (orderItemFfmcId.equals(ffmc.toString())) {
				selected = "selected";

				orderItemFfmcIdValue.append(orderItemFfmcId);
				orderItemFfmcIdValue.append("_");
				orderItemFfmcIdValue.append(hasFFMStore);
				if (hasFFMStore) {
					orderItemFfmcIdValue.append("_");
					orderItemFfmcIdValue.append(FFMStore);
				}
			}
		
			// construct the value for a ffmc
			ffmcIdValue.append(ffmc.toString());
			ffmcIdValue.append("_");
			ffmcIdValue.append(hasFFMStore);
			if (hasFFMStore) {
				ffmcIdValue.append("_");
				ffmcIdValue.append(FFMStore);
			}

			ffmcSelect.append("<option  value=\"");
			ffmcSelect.append(ffmcIdValue.toString());
			ffmcSelect.append("\" ");
			ffmcSelect.append(selected);
			ffmcSelect.append(" >");
			ffmcSelect.append(ffmcName);
			ffmcSelect.append("</option>");
		}
		%>
		<%= comm.addDlistColumn(ffmcSelect.toString(), "none") %>
		<%= comm.endDlistRow() %>
	
		<SCRIPT LANGUAGE="JavaScript">
		// save the orderItemId with its ffmcId in model
		if ("<%= orderItemFfmcIdValue.toString() %>" == "") {
			parent.parent.put("<%= oiList.getOrderItemsToReleaseListData(i).getOrderItemAB().getOrderItemId() %>", "<%= defaultFfmcIdValue.toString() %>");
		} else {
			parent.parent.put("<%= oiList.getOrderItemsToReleaseListData(i).getOrderItemAB().getOrderItemId() %>", "<%= orderItemFfmcIdValue.toString() %>");
		}
		</SCRIPT>

		<%
		i++;
		itemsInCurrentOrder++;
	}
}
// add the "more products" row if neccessary (i.e. the rest of the products in the last order will
// be shown on the next page)
if ( totalsize > (startIndex + endIndex) ) {

	int totalReleasable = oiList.getTotalReleasableOrderItems(currentOrderId);
	if ( totalReleasable > (itemsInCurrentOrder-1) ) {
	%>
		<%= comm.startDlistRow(rowselect) %>
		<%= comm.addDlistColumn("","none") %>
		<%= comm.addDlistColumn("","none") %>
		<%= comm.addDlistColumn((String)releaseOrderItemsNLS.get("ReleaseOrderItemsMoreProducts"),"none") %>
		<%= comm.addDlistColumn("","none") %>
		<%= comm.addDlistColumn("","none") %>
		<%= comm.addDlistColumn("","none") %>
	<%
	}
}
%>
<%= comm.endDlistTable() %>

<%
if (oiList.getListSize() == 0) {
%>

	<P><P>
	<TABLE CELLSPACING=0 CELLPADDING=3 BORDER=0>
	<TR>
		<TD COLSPAN=7>
		<%= UIUtil.toHTML((String)releaseOrderItemsNLS.get("ReleaseOrderItemsNothingToRelease")) %>
		</TD>
	</TR>
	</TABLE>
<% } %>
</FORM>


<SCRIPT LANGUAGE="JavaScript">
<!--
parent.set_t_item_page(<%= totalsize %>, <%= listSize %>);
parent.afterLoads();
parent.setResultssize(getResultsSize());        
//-->
</SCRIPT>


</BODY>
</HTML>
