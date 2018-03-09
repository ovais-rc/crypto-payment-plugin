<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>
<%@ page import="com.ibm.commerce.ras.*" %>
<%@ page import="com.ibm.commerce.common.beans.StoreDataBean" %>
<%@ page import="com.ibm.commerce.order.beans.*" %>
<%@ page import="com.ibm.commerce.order.objects.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.beans.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.helpers.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.price.beans.*" %>
<%@ page import="com.ibm.commerce.price.utils.*" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@include file="../../tools/common/common.jsp" %>
<%@include file="../../tools/common/NumberFormat.jsp" %>


<%--
//---------------------------------------------------------------------
//- Method Declarion
//---------------------------------------------------------------------
--%>
<%!
public String getPaymentStatusString(Hashtable res, String payStatus) {
	String result = "";
	if (payStatus == null || payStatus.length() == 0) {
		result = (String)res.get("payment_unknown");
	} else {
		result = (String)res.get(payStatus);
	}
	return result;
}

public String getEDPPaymentStatus(Hashtable tmpOrderLabels, HttpServletRequest request, String orderId) {
	String paymentState = null;
	com.ibm.commerce.edp.beans.EDPPaymentStatusDataBean eDPPaymentStatusDataBean	=	new com.ibm.commerce.edp.beans.EDPPaymentStatusDataBean();
	eDPPaymentStatusDataBean.setOrderId(new Long(orderId));
	eDPPaymentStatusDataBean.setNeedGlobalized(false);
	try {
		com.ibm.commerce.beans.DataBeanManager.activate(eDPPaymentStatusDataBean, request);
		paymentState = eDPPaymentStatusDataBean.getPaymentStatus();
	} catch (Exception ex) {
		//Exception
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "OrderSummaryDetailsB2C.jsp", "getPaymentStatus", "Exception in OrderSummaryDetails.jsp");
		ex.printStackTrace();
	}

	if (paymentState == null) {
       paymentState = (String)tmpOrderLabels.get("orderSummaryDetPaymentStateNotApplicable");
	} else {
	   if (paymentState.equals("Failure")){
           paymentState = "Failed";
       }
	   paymentState = (String)tmpOrderLabels.get(paymentState);
	}
	return paymentState;
}

public String getFormattedAmount(BigDecimal amount, String currency, Integer langId, String storeId) {
	try {
		com.ibm.commerce.common.beans.StoreDataBean iStoreDB = new com.ibm.commerce.common.beans.StoreDataBean();
		iStoreDB.setStoreId(storeId);

		FormattedMonetaryAmountDataBean formattedAmount =  new FormattedMonetaryAmountDataBean(
				new MonetaryAmount(amount, currency),
				iStoreDB, langId);

		return formattedAmount.getPrimaryFormattedPrice().getFormattedValue().toString();
	} catch (Exception exc) {
		return "";
	}
}

public String getOrderType(Hashtable res, com.ibm.commerce.tools.optools.order.beans.OrderListDataBean anOrder) {
	String result = "";
	String orderType = null;
	try {
		orderType = anOrder.getOrderType();
	} catch (Exception e) {
	}
	if (orderType == null || orderType.length() == 0) {
		result = (String) res.get("noOrderType");
	} else {
		result = (String) res.get(orderType);
	}
	return result;
}
%>

<%--
//---------------------------------------------------------------------
//- Logic Section
//---------------------------------------------------------------------
--%>
<%

   	// obtain the resource bundle for display
	CommandContext cmdContextLocale = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   	Locale jLocale 		= cmdContextLocale.getLocale();
   	Integer langId		= cmdContextLocale.getLanguageId();
   	Integer storeId 	= cmdContextLocale.getStoreId();
   	String currency		= cmdContextLocale.getCurrency();
   	Hashtable orderLabels 	= (Hashtable)ResourceDirectory.lookup("order.orderLabels", jLocale);
    StoreDataBean storeBean = new StoreDataBean();
    storeBean.setStoreId(storeId.toString());
    com.ibm.commerce.beans.DataBeanManager.activate(storeBean, request);

	JSPHelper jspHelper 	= new JSPHelper(request);
	String isAdvancedSearch = jspHelper.getParameter("isAdvancedSearch");
    String orderByParam = jspHelper.getParameter("orderby");
    String orderStatus = jspHelper.getParameter("orderStatus");
    String orderType = jspHelper.getParameter("orderType");
    String blocked= jspHelper.getParameter("blocked");
    String blockReason= jspHelper.getParameter("blockReason");
	String customerId	= jspHelper.getParameter("customerId");
	String accountId	= jspHelper.getParameter("accountId");
	String searchOrderId 	= jspHelper.getParameter("orderId");
	String searchUserLogon 	= jspHelper.getParameter("userLogon");
	String userLogonSearchType = jspHelper.getParameter("userLogonSearchType");
	String orderDateSD	= jspHelper.getParameter("orderDateSD");
	String orderDateED	= jspHelper.getParameter("orderDateED");
	String lastUpdateSD	= jspHelper.getParameter("lastUpdateSD");
	String lastUpdateED	= jspHelper.getParameter("lastUpdateED");
	String firstName	= jspHelper.getParameter("firstName");
	String firstNameSearchType = jspHelper.getParameter("firstNameSearchType");
	String lastName		= jspHelper.getParameter("lastName");
	String lastNameSearchType = jspHelper.getParameter("lastNameSearchType");
	String address1		= jspHelper.getParameter("address1");
	String address1SearchType = jspHelper.getParameter("address1SearchType");
    String city = jspHelper.getParameter("city");
    String citySearchType = jspHelper.getParameter("citySearchType");
	String zipcode		= jspHelper.getParameter("zipcode");
	String zipcodeSearchType = jspHelper.getParameter("zipcodeSearchType");
	String email1		= jspHelper.getParameter("email1");
	String email1SearchType = jspHelper.getParameter("email1SearchType");
	String phone1	= jspHelper.getParameter("phone1");
	String fetchSize	= jspHelper.getParameter("fetchSize");

//LI646 begin
String ffmId = jspHelper.getParameter("fulfillmentCenterId");
String orderItemStatus = jspHelper.getParameter("orderItemStatus");

String paymentDataSizeString = jspHelper.getParameter("paymentDataSize");
Integer paymentDataSize = new Integer(0);
if (paymentDataSizeString != null){
   paymentDataSize =   paymentDataSize = Integer.valueOf(paymentDataSizeString);
}
HashMap paymentDataHashMap = new HashMap(paymentDataSize.intValue());
for (int i = 1; i <= paymentDataSize.intValue(); i++) {
	String key = jspHelper.getParameter("paymentData_name_"+i);
	String value = jspHelper.getParameter("paymentData_value_"+i);
	paymentDataHashMap.put(key,value);
}
//LI646 end


	if (accountId == null || accountId.length() == 0) {
		accountId = "";}
//get ShipAddress1 and shipZipcode
    String shipFirstName = jspHelper.getParameter("shipFirstName");
    String shipFirstNameSearchType = jspHelper.getParameter("shipFirstNameSearchType");
    String shipLastName = jspHelper.getParameter("shipLastName");
    String shipLastNameSearchType = jspHelper.getParameter("shipLastNameSearchType");
    String shipAddress1 = jspHelper.getParameter("shipAddress1");
    String shipAddress1SearchType = jspHelper.getParameter("shipAddress1SearchType");
    String shipCity = jspHelper.getParameter("shipCity");
    String shipCitySearchType = jspHelper.getParameter("shipCitySearchType");
    String shipZipcode = jspHelper.getParameter("shipZipcode");
    String shipZipcodeSearchType = jspHelper.getParameter("shipZipcodeSearchType");
    String orgId = jspHelper.getParameter("orgId");
    String orgName = jspHelper.getParameter("orgName");
    String orgNameSearchType = jspHelper.getParameter("orgNameSearchType");
    String ordersField1 = jspHelper.getParameter("ordersField1");
    String SKU = jspHelper.getParameter("SKU");
    String ordersNotFulfilled = jspHelper.getParameter("ordersNotFulfilled");

    String orgField1 = jspHelper.getParameter("orgField1");
    String orgField1SearchType = jspHelper.getParameter("orgField1SearchType");

//get Bill information
    String billFirstName = jspHelper.getParameter("billFirstName");
    String billFirstNameSearchType = jspHelper.getParameter("billFirstNameSearchType");
    String billLastName = jspHelper.getParameter("billLastName");
    String billLastNameSearchType = jspHelper.getParameter("billLastNameSearchType");
    String billAddress1 = jspHelper.getParameter("billAddress1");
    String billAddress1SearchType = jspHelper.getParameter("billAddress1SearchType");
    String billCity = jspHelper.getParameter("billCity");
    String billCitySearchType = jspHelper.getParameter("billCitySearchType");
    String billZipcode = jspHelper.getParameter("billZipcode");
    String billZipcodeSearchType = jspHelper.getParameter("billZipcodeSearchType");

	// get customer id for find result
	if (customerId == null || customerId.length() == 0) {
		customerId = "";
		if (searchOrderId != null && searchOrderId.length() != 0) {
			try {
				//judge whether OrderId is invalid  
				OrderAccessBean abOrder = new OrderAccessBean();
				abOrder.setInitKey_orderId(searchOrderId);
			
				OrderDataBean oneOrder = new OrderDataBean();
				oneOrder.setOrderId(searchOrderId);
				com.ibm.commerce.beans.DataBeanManager.activate(oneOrder, request);
				customerId = oneOrder.getMemberId();
			} catch (Exception ex1) {
				ECTrace.trace(ECTraceIdentifiers.COMPONENT_ORDER, "OrderListB2B.jsp", "none", "Exception when populating orderDB");
			}
		}

	}

	// get standard list parameters
	String xmlFile 	= jspHelper.getParameter("ActionXMLFile");
	int startIndex 	= Integer.parseInt(jspHelper.getParameter("startindex"));
	int listSize 	= Integer.parseInt(jspHelper.getParameter("listsize"));
	int endIndex	= startIndex + listSize;
	int rowselect 	= 1;

	OrderListBean oList	= new OrderListBean();
	oList.setOrderBy(orderByParam);
    oList.setBlocked(blocked);
    oList.setBlockReason(blockReason);

    if (orderType == null){
        orderType = "";
    }
    if (orderStatus == null){
        orderStatus = "";
    }

    if (orderStatus.equals("")){
   	orderStatus = "all";
    }
    if (orderType.equals("")){
  	orderType = "ORD";
    }

    oList.setOrderType(orderType);
    oList.setStatus(orderStatus);

	//LI646 begin
	if(ffmId != null && ffmId.trim().length() > 0){
		oList.setFulfillmentCenterId(Long.valueOf(ffmId));
	}
	oList.setOrderItemStatus(orderItemStatus);
	oList.setPaymentData(paymentDataHashMap);
	//LI646 end
	oList.setStartIndex((new Integer(startIndex)).toString());
	oList.setMaxLength((new Integer(listSize)).toString());
	oList.setUsage("new");

	oList.setOrderId(searchOrderId);
	if("true".equals(isAdvancedSearch)){
		oList.setFetchSize(fetchSize);
	}
	if ((searchUserLogon == null || searchUserLogon.length() == 0) &&
	    (searchOrderId == null || searchOrderId.length() == 0) &&
	    (orderType == null || orderType.equals("ORD") || orderType.equals("")) &&
	    (orderStatus == null || orderStatus.equals("all")|| orderStatus.equals("")) &&
	    (accountId == null || accountId.length() == 0) &&
	    (orderDateSD == null || orderDateSD.length() == 0) &&
	    (orderDateED == null || orderDateED.length() == 0) &&
	    (lastUpdateSD == null || lastUpdateSD.length() == 0) &&
	    (lastUpdateED == null || lastUpdateED.length() == 0) &&
	    (firstName == null || firstName.length() == 0) &&
	    (lastName == null || lastName.length() == 0) &&
	    (shipFirstName == null || shipFirstName.length() == 0) &&
	    (shipLastName == null || shipLastName.length() == 0) &&
	    (address1 == null || address1.length() == 0) &&
	    (city == null || city.length() == 0) &&
	    (zipcode == null || zipcode.length() == 0) &&
        (email1 == null || email1.length() == 0) &&
	    (phone1 == null || phone1.length() == 0) &&
	    (shipFirstName == null || shipFirstName.length() == 0) &&
	    (shipLastName == null || shipLastName.length() == 0) &&
	    (shipAddress1 == null || shipAddress1.length() == 0) &&
	    (orgField1 == null || orgField1.length() == 0) &&
	    (shipCity == null || shipCity.length() == 0) &&
	    (shipZipcode == null || shipZipcode.length() == 0) &&
	    (billFirstName == null || billFirstName.length() == 0) &&
	    (billLastName == null || billLastName.length() == 0) &&
	    (billAddress1 == null || billAddress1.length() == 0) &&
	    (billCity == null || billCity.length() == 0) &&
	    (billZipcode == null || billZipcode.length() == 0) &&
	    (ordersField1 == null || ordersField1.length() == 0) &&
	    (orgField1 == null || orgField1.length() == 0) &&
	    (orgId == null || orgId.length() == 0) &&
	    (ordersNotFulfilled == null || ordersNotFulfilled.length() == 0) &&
	    (SKU == null || SKU.length() == 0) &&
	    (orgName == null || orgName.length() == 0)) {
		oList.setUserId(customerId);
	} else {
		oList.setUserLogon(searchUserLogon);
		oList.setUserLogonSearchType(userLogonSearchType);

		oList.setAccountId(accountId);
		if (orderDateSD != null) {
			oList.setOrderDateSD(orderDateSD);
		}
		if (orderDateED != null) {
			oList.setOrderDateED(orderDateED);
		}
		if (lastUpdateSD != null) {
			oList.setLastUpdateSD(lastUpdateSD);
		}
		if (lastUpdateED != null) {
			oList.setLastUpdateED(lastUpdateED);
		}
		oList.setFirstName(firstName);
		oList.setFirstNameSearchType(firstNameSearchType);
		oList.setLastName(lastName);
		oList.setLastNameSearchType(lastNameSearchType);
		oList.setAddress1(address1);
		oList.setAddress1SearchType(address1SearchType);
	    oList.setCity(city);
	    oList.setCitySearchType(citySearchType);
		oList.setZipcode(zipcode);
		oList.setZipcodeSearchType(zipcodeSearchType);
		oList.setEmail1(email1);
		oList.setEmail1SearchType(email1SearchType);
		oList.setPhone1(phone1);

	   //set Shipping Address1 and shipZipCode and Organization
	    oList.setShipFirstName(shipFirstName);
	    oList.setShipFirstNameSearchType(shipFirstNameSearchType);
	    oList.setShipLastName(shipLastName);
	    oList.setShipLastNameSearchType(shipLastNameSearchType);
	    oList.setShipAddress1(shipAddress1);
	    oList.setShipAddress1SearchType(shipAddress1SearchType);
	    oList.setShipCity(shipCity);
	    oList.setShipCitySearchType(shipCitySearchType);
	    oList.setShipZipcode(shipZipcode);
	    oList.setShipZipcodeSearchType(shipZipcodeSearchType);
	    oList.setBillFirstName(billFirstName);
	    oList.setBillFirstNameSearchType(billFirstNameSearchType);
	    oList.setBillLastName(billLastName);
	    oList.setBillLastNameSearchType(billLastNameSearchType);
	    oList.setBillAddress1(billAddress1);
	    oList.setBillAddress1SearchType(billAddress1SearchType);
	    oList.setOrgId(orgId);
	    oList.setBillCity(billCity);
	    oList.setBillCitySearchType(billCitySearchType);
	    oList.setBillZipcode(billZipcode);
	    oList.setBillZipcodeSearchType(billZipcodeSearchType);
	    oList.setOrgName(orgName);
	    oList.setOrgNameSearchType(orgNameSearchType);
	    oList.setOrdersField1(ordersField1);
	    oList.setOrdersNotFulFilled(ordersNotFulfilled);
	    oList.setSKU(SKU);
	    oList.setOrgField1(orgField1);
	    oList.setOrgField1SearchType(orgField1SearchType);
		oList.setFetchSize(fetchSize);
	}

	com.ibm.commerce.beans.DataBeanManager.activate(oList, request);

	int totalsize	= oList.getResultSetSize();
	int totalpage	= totalsize / listSize;

	int actualSize = listSize;
	if (totalsize < listSize) {
		actualSize = totalsize;
	}

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%=UIUtil.getCSSFile(jLocale)%>" type="text/css" />
<title><%= orderLabels.get("title") %></title>

<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js">
</script>
<script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js">
</script>
<script language="JavaScript" type="text/javascript">
<!-- <![CDATA[
//---------------------------------------------------------------------
//  Required javascript function for dynamic list
//---------------------------------------------------------------------
function onLoad() {
	parent.loadFrames();
}


function getRefNum() {
	return parent.getChecked();
}

function getResultsSize() {
	return <%=oList.getResultSetSize() %>;
}

function getUserId() {
debugAlert("<%=customerId%>");
	return "<%=customerId%>";
}

function getCustomerId() {
	// returns passed in customer id
	return "<%=customerId%>";
}

//---------------------------------------------------------------------
//  user defined javascript functions
//---------------------------------------------------------------------
var list = new Array(<%= oList.getListSize() %>);
<% for (int i=0; i<oList.getListSize(); i++) { %>
    list[<%=i%>] = {orderId:"<%=oList.getOrderListData(i).getOrderId()%>", state:"<%=oList.getOrderListData(i).getOrderStatus()%>",orderType:"<%=oList.getOrderListData(i).getOrderType()%>", isEditable:"<%=oList.getOrderListData(i).getOrderBean().isEditable()%>", isLocked:"<%=oList.getOrderListData(i).getOrderBean().isLocked()%>"};
<% } %>

var takeOverLock = "N";

function checkOrderLockedByOtherCSR() {
	var checkeds = new Array;
	checkeds = parent.getChecked();

	  for (var i=0; i<checkeds.length; i++) {
	    for (var j=0; j<list.length; j++) {
			if (list[j].orderId == checkeds[i]) {
				if(list[j].isLocked == "true") {
					if (!confirmDialog("<%=UIUtil.toJavaScript((String) orderLabels.get("editStateWarning"))%>")) {
						return false;
					} else {
						takeOverLock = "Y";
					}
				}
			}
		  }
		}
	return true;
}

function checkOrderState() {
	var checkeds = new Array;
	checkeds = parent.getChecked();

	for (var i=0; i<checkeds.length; i++) {
		for (var j=0; j<list.length; j++) {
			if (list[j].orderId == checkeds[i]) {
			    if(list[j].isEditable == "false") {
					alertDialog("<%=UIUtil.toJavaScript((String)orderLabels.get("invalidSelection"))%>");
					return false;
			    }
				if (list[j].state == "S" || list[j].state == "X" || list[j].state == "R" || list[j].state == "D") {
					alertDialog("<%=UIUtil.toJavaScript((String)orderLabels.get("invalidSelection"))%>");
					return false;
				}
				if (list[j].state == "T") {
					alertDialog("<%=UIUtil.toJavaScript((String)orderLabels.get("invalidSelectionLocked"))%>");
					return false;
				}
				if (list[j].state == "E") {
					if (!confirmDialog("<%=UIUtil.toJavaScript((String)orderLabels.get("editStateWarning"))%>"))
						return false;
				}
				if (list[j].state == "J") {
					if (!confirmDialog("<%=UIUtil.toJavaScript((String)orderLabels.get("invalidSelection"))%>"))
						return false;
				}
			    if (list[j].orderType == "TEP") {
				  alertDialog("<%=UIUtil.toJavaScript((String) orderLabels.get("invalidSelectionLocked"))%>");
				  return false;
			    }
			    if (list[j].orderType == "PRL" || list[j].orderType == "SRL") {
			      alertDialog("<%=UIUtil.toJavaScript((String) orderLabels.get("invalidSelectionRL"))%>");
				  return false;
			    }
			    if (list[j].orderType == "QUP") {
			      alertDialog("<%=UIUtil.toJavaScript((String) orderLabels.get("invalidSelectionQUP"))%>");
				  return false;
			    }
			    if (list[j].orderType == "QUT") {
			      alertDialog("<%=UIUtil.toJavaScript((String) orderLabels.get("invalidSelectionQUT"))%>");
				  return false;
				}
			    if (list[j].orderType == "BIN") {
			      alertDialog("<%=UIUtil.toJavaScript((String) orderLabels.get("invalidSelection"))%>");
				  return false;
				}
			}
		  }
		}
	return true;
}

function checkForOrderStateA() {
	var checkeds = new Array;
	checkeds = parent.getChecked();

	for (var i=0; i<checkeds.length; i++) {
		for (var j=0; j<list.length; j++) {
			if (list[j].orderId == checkeds[i]) {
				if (list[j].state != "A") {
					alertDialog("<%=UIUtil.toJavaScript((String)orderLabels.get("invalidSelectionForPaymentProceed"))%>");
					return false;
				}
			}
		}
	}

	return true;


}

function checkForCompleteOrder() {
	var checkeds = new Array;
	checkeds = parent.getChecked();

	for (var i=0; i<checkeds.length; i++) {
		for (var j=0; j<list.length; j++) {
			if (list[j].orderId == checkeds[i]) {
				if (list[j].state != "C") {
					alertDialog("<%=UIUtil.toJavaScript((String)orderLabels.get("invalidSelection"))%>");
					return false;
				}
			}
		}
	}

	return true;


}

function checkForShippedOrder() {
	var checkeds = new Array;
	checkeds = parent.getChecked();

	for (var i=0; i<checkeds.length; i++) {
		for (var j=0; j<list.length; j++) {
			if (list[j].orderId == checkeds[i]) {
				if (list[j].state != "S") {
					alertDialog("<%=UIUtil.toJavaScript((String)orderLabels.get("invalidSelectionForReturn"))%>");
					return false;
				}
			}
		}
	}

	return true;
}

function checkBlock() {
	var checkeds = new Array;
	checkeds = parent.getChecked();
	for (var i=0; i<checkeds.length; i++) {
		for (var j=0; j<list.length; j++) {
			if (list[j].orderId == checkeds[i]) {
				if (list[j].state == "X" ||list[j].state == "D"  || list[j].orderType != "ORD") {
					alertDialog("<%=UIUtil.toJavaScript((String) orderLabels.get("invalidSelectionForBlock"))%>");
					return false;
				}
			}
		}
	}
	return true;
}

function checkForReturnableOrder() {
	var checkeds = new Array;
	checkeds = parent.getChecked();

	//For standard order store, only "S","D","P" orders are allowed to return. P? hjz
	  for (var i=0; i<checkeds.length; i++) {
		for (var j=0; j<list.length; j++) {
			if (list[j].orderId == checkeds[i]) {
				if (list[j].state != "S" && list[j].state != "D" && list[j].state != "P") {
					alertDialog("<%=UIUtil.toJavaScript((String)orderLabels.get("invalidSelectionForReturn"))%>");
					return false;
				}
			}
		}
	  }

	return true;
}

function checkForCanceledAndLockedOrder() {
	var checkeds = new Array;
	checkeds = parent.getChecked();

	for (var i=0; i<checkeds.length; i++) {
		for (var j=0; j<list.length; j++) {
			if (list[j].orderId == checkeds[i]) {
				if (list[j].state == "X") {
					alertDialog("<%=UIUtil.toJavaScript((String)orderLabels.get("invalidSelectionLocked"))%>");
					return false;
				}
				if (list[j].state == "T") {
					alertDialog("<%=UIUtil.toJavaScript((String)orderLabels.get("invalidSelectionLocked"))%>");
					return false;
				}
				if (list[j].state == "J") {
					alertDialog("<%=UIUtil.toJavaScript((String)orderLabels.get("invalidSelectionLocked"))%>");
					return false;
				}
			}
		}
	  }

	return true;
}

function checkForLockedOrder() {
	var checkeds = new Array;
	checkeds = parent.getChecked();

	for (var i=0; i<checkeds.length; i++) {
		for (var j=0; j<list.length; j++) {
			if (list[j].orderId == checkeds[i]) {
				if (list[j].state == "T") {
					alertDialog("<%=UIUtil.toJavaScript((String)orderLabels.get("invalidSelectionLocked"))%>");
					return false;
				}
			}
		}
	  }

	return true;
}

function quickviewAction (orderId) {
	top.setContent(getQuickviewBCT(),'/webapp/wcs/tools/servlet/DialogView?XMLFile=order.orderDetailsDialogB2B&amp;orderId='+orderId,true)
}

function quickviewActionPaymentStatus (orderId) {
	top.setContent(getEDPPaymentBCT(),'/webapp/wcs/tools/servlet/DialogView?XMLFile=edp.edpDetailsDialogB2C&amp;orderId='+orderId,true)
}
function quickviewActionOrdBlock (orderId) {
// need to check order status type , NEW,PRC  & type ORD can block manag
	for (var j=0; j<list.length; j++) {
		if (list[j].orderId == orderId) {
			if (list[j].status == "X" ||list[j].status == "D" || list[j].orderType != "ORD") {
				alertDialog("<%=UIUtil.toJavaScript((String) orderLabels.get("invalidSelectionForBlock"))%>");
				return false;
			}
		}
	}
	top.setContent(getOrderBlockBCT(),'/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=order.orderBlockView&amp;cmd=OrderBlockView&amp;orderId='+orderId,true)

}
//---------------------------------------------------------------------
//  GUI functions
//---------------------------------------------------------------------
function getNewBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("newBCT"))%>";
}

function getEDPPaymentBCT() {
	return "<%=UIUtil.toJavaScript((String) orderLabels.get("edppaymentBCT"))%>";
}

function getOrderBlockBCT() {
   return "<%=UIUtil.toJavaScript((String) orderLabels.get("orderBlockBCT"))%>";
}

function getQuickviewBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("quickviewBCT"))%>";
}

function getEditOrderItemInfoBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("editOrder1BCT"))%>";
}

function getEditOrderInfoBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("editOrder2BCT"))%>";
}

function getChangeBillAddrBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("changeBillingAddress"))%>";
}

function getChangePaymentBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("changePayment"))%>";
}

function getCommentBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("commentBCT"))%>";
}

function getCancelBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("cancelBCT"))%>";
}

function getAllOrderBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("allOrderTitle"))%>";
}

function getNewOrderBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("newlOrderTitle"))%>";
}

function getCanceledOrderBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("canceledOrderTitle"))%>";
}

function getShippedOrderBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("shippedOrderTitle"))%>";
}

function getEditOrderBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("editBCT"))%>";
}

function getCompletedOrderBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("completedOrderTitle"))%>";
}

function getReleasedOrderBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("releasedOrderTitle"))%>";
}

function getSubmittedOrderBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("submittedOrderTitle"))%>";
}

function getPApprovalOrderBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("pApprovalOrderTitle"))%>";
}

function getBackOrderedOrderBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("backorderedOrderTitle"))%>";
}

function getNoInventoryOrderBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("noInventoryOrderTitle"))%>";
}

function getCreateReturnBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("createReturnBCT"))%>";
}

function getFindBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("findBCT"))%>";
}


function getCaptureBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("captureBCT"))%>";
}

function getPaymentProceedBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("paymentProceedBCT"))%>";
}

function getInvoiceBCT() {
	return "<%=UIUtil.toJavaScript((String)orderLabels.get("invoiceBCT"))%>";
}

function getManagePaymentBCT() {
	return "<%=UIUtil.toJavaScript((String) orderLabels.get("managerPaymentBCT"))%>";
}

function debugAlert(msg) {
//	alert("DEBUG: " + msg);
}
//[[>-->

</script>
</head>

<body class="content">

<script type="text/javascript">
<!-- <![CDATA[
//for IE
if (document.all) {
	onLoad();
}
//[[>-->

</script>

<%= comm.addControlPanel(xmlFile, totalpage, totalsize, jLocale) %>

<form name='OrderListForm' id='OrderListForm' action="">
	<%= comm.startDlistTable((String)orderLabels.get("CSOrderListTableSummary")) %>
	<%= comm.startDlistRowHeading() %>
	<%= comm.addDlistCheckHeading() %>
	<%= comm.addDlistColumnHeading((String)orderLabels.get("orderNumber"), "orderId", orderByParam.equals("orderId"),"100",false) %>
	<%= comm.addDlistColumnHeading((String)orderLabels.get("customerName"), "logonId", orderByParam.equals("logonId")) %>
	<%= comm.addDlistColumnHeading((String)orderLabels.get("accountName"), null, false,null,false) %>
        <%= comm.addDlistColumnHeading((String) orderLabels.get("blockStatus"), null, false,null,false)%>
	<%= comm.addDlistColumnHeading((String)orderLabels.get("paymentStatus"), null, false,null,false) %>
        <%= comm.addDlistColumnHeading((String) orderLabels.get("orderStatus"), null, false,null,false)%>
	<%= comm.addDlistColumnHeading((String)orderLabels.get("orderDate"), "ordate", orderByParam.equals("ordate"),"100",false )%>
	<%= comm.addDlistColumnHeading((String)orderLabels.get("orderUpdatedDate"), "updateDate", orderByParam.equals("updateDate"),"100",false) %>
	<%= comm.addDlistColumnHeading((String)orderLabels.get("total"), "ortotal", orderByParam.equals("ortotal"),"100",false )%>

<%=comm.endDlistRow()%> <%
	if (endIndex > oList.getListSize()) {
		endIndex = oList.getListSize();
	}%>

<%
	// TABLE CONTENT
    StringBuffer aPaymentstrBuffer = null;
	StringBuffer aStrBuffer = null;
	for (int i=0; i < endIndex; i++) {
	%>
		<%= comm.startDlistRow(rowselect) %>
			<%= comm.addDlistCheck(oList.getOrderListData(i).getOrderId().toString(), "none") %>
			<%
			aStrBuffer = new StringBuffer();
			aStrBuffer.append("javascript:quickviewAction('");
			aStrBuffer.append(oList.getOrderListData(i).getOrderId());
			aStrBuffer.append("')");
            String dynamicPaymentStatus = "";

	        dynamicPaymentStatus = getEDPPaymentStatus(orderLabels, request,oList.getOrderListData(i).getOrderId().toString());
	         %>
			<%= comm.addDlistColumn(oList.getOrderListData(i).getOrderId().toString(), aStrBuffer.toString()) %>
			<%= comm.addDlistColumn(oList.getOrderListData(i).getMemberName(), "none") %>
			<%= comm.addDlistColumn(oList.getOrderListData(i).getAccountName(), "none") %>
            <%
                String isBlocked = null;
                String nlvBlocked = null;
                isBlocked = oList.getOrderListData(i).getOrderBean().getIsBlocked();
                if ( isBlocked != null && isBlocked.equals("1")){
                   nlvBlocked = (String) orderLabels.get("blocked");
                }else{
                   nlvBlocked = (String) orderLabels.get("orderNotBlocked");
                }
            %>
            <%=comm.addDlistColumn(nlvBlocked, "none")%>
            <%= comm.addDlistColumn(dynamicPaymentStatus, "none") %>
            <%=comm.addDlistColumn((String) orderLabels.get(oList.getOrderListData(i).getOrderStatus().trim()), "none")%>
			<%= comm.addDlistColumn((String)TimestampHelper.getDateFromTimestamp(oList.getOrderListData(i).getOrderPlacedAt(), jLocale), "none") %>
			<%= comm.addDlistColumn((String)TimestampHelper.getDateFromTimestamp(oList.getOrderListData(i).getOrderUpdatedAt(), jLocale), "none") %>
			<%
			aStrBuffer = new StringBuffer();
            // get currency from Order so it gets converted properly
            currency = oList.getOrderListData(i).getOrderCurrency();
            aStrBuffer.append(getFormattedAmount(oList.getOrderListData(i).getOrderTotal(), currency, langId, storeId.toString()));
			aStrBuffer.append("(");
			aStrBuffer.append(oList.getOrderListData(i).getOrderCurrency());
			aStrBuffer.append(")");
			%>
			<%= comm.addDlistColumn(aStrBuffer.toString(), "none") %>
		<%= comm.endDlistRow() %>

		<%
		if (rowselect == 1) {
			rowselect = 2;
		} else {
			rowselect = 1;
		}
	}

	%>
	<%= comm.endDlistTable() %>

<%
	if (oList.getListSize() == 0) {
%>

<p></p><p>
</p><table cellspacing="0" cellpadding="3" border="0" id="WC_ OrderListB2B_Table_1">
<tr>
	<td colspan="7" id="WC_ OrderListB2B_TableCell_1">
		<%=orderLabels.get("noOrdersToList")%>
	</td>
</tr>
</table>
<% }
%>
</form>

<script type="text/javascript">
<!-- <![CDATA[
   parent.afterLoads();
   parent.setResultssize(getResultsSize());
//[[>-->

</script>
</body>
</html>


