<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%-- 
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
--%>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.text.*" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.order.beans.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.fulfillment.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.price.utils.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.helpers.*" %> 
<%@ page import="com.ibm.commerce.tools.optools.common.helpers.*" %> 
<%@ page import="com.ibm.commerce.tools.optools.order.beans.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.commands.ECOptoolsConstants" %>
<%@ page import="com.ibm.commerce.fulfillment.beans.ShippingModeDataBean" %>
<%@ page import="com.ibm.commerce.user.beans.AddressDataBean" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@include file="../../tools/common/common.jsp" %>
<%@include file="../../tools/common/NumberFormat.jsp" %>

<%-- 
//---------------------------------------------------------------------
//- Method Declarion
//---------------------------------------------------------------------
--%>
<%! 	
	// Method to get catalog entry name for an order item
	public String getOrderItemName(String catalogEntryId, HttpServletRequest request) {
		String name;
     
		try {
			CatalogEntryDataBean aCatalogEntry	= new CatalogEntryDataBean(); 
			aCatalogEntry.setCatalogEntryID(catalogEntryId);
		
			com.ibm.commerce.beans.DataBeanManager.activate(aCatalogEntry, request);

	   
			// The databean did not expose the name method	
			name = aCatalogEntry.getDescription().getName();
			if (name == null) {
				return "";
			}   
	   } catch (Exception exec) {
	      // Exceptions:
	      // - catalogEntryId.length() == 0
	      // - aCatalogEntry.getDescription() == null
	   	return "";
	   }	
		return name;
	}
	
	// retrieve the shipmode description
	public String getShipMode(String shipModeId, Integer storeId, String langId,HttpServletRequest request) {
		
		
		try {
		
   			if (shipModeId != null && !shipModeId.equals("")) {
   				ShippingModeDataBean shipMode = new ShippingModeDataBean();
   				shipMode.setInitKey_shippingModeId(shipModeId);
   				DataBeanManager.activate(shipMode, request);
   			
   				return shipMode.getDescription(new Integer(langId), new Integer(shipMode.getShippingModeId())).getDescription();
   			} else {
   				return "";
   			}
   			
   		} catch (Exception ex) {
   			return "";
   		}
   		
   		
	}
	
	//retrieve shipping address nickname
	public String getShippingAddress(String addressId,HttpServletRequest request) {
		try {
			if (addressId != null && !addressId.equals("")) {
				AddressDataBean address = new AddressDataBean();
				address.setAddressId(addressId);
				DataBeanManager.activate(address, request);
			
				return address.getNickName();
			} else {
				return "";
			}
			
		} catch (Exception ex) {
			return "";
		}
		
	}
	
	public String getContractName(String contractId, HttpServletRequest request) {
		try {
			if (contractId != null && !contractId.equals("")) {
				com.ibm.commerce.contract.beans.ContractDataBean contractDataBean = new com.ibm.commerce.contract.beans.ContractDataBean();
				contractDataBean.setDataBeanKeyReferenceNumber(contractId); 
				DataBeanManager.activate(contractDataBean, request);
				return contractDataBean.getName();
			} else {
				return "";
			}

		} catch (Exception ex) {
			return "";
		}
		
	}
	
	
%>

<%-- 
//---------------------------------------------------------------------
//- Logic Section
//---------------------------------------------------------------------
--%>
<% 
	// obtain the resource bundle for display
	CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale 		= cmdContextLocale.getLocale();
	String langId		= cmdContextLocale.getLanguageId().toString();
	Integer storeId 	= cmdContextLocale.getStoreId();
	Hashtable orderLabels 	= (Hashtable)ResourceDirectory.lookup("order.orderLabels", jLocale);
   	Hashtable orderMgmtNLS 	= (Hashtable)ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);
   	Hashtable orderAddProducts 	= (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderAddProducts", jLocale);

	// retrieve request parameters
	JSPHelper jspHelper 	= new JSPHelper(request);
	String firstOrderId 	= jspHelper.getParameter("firstOrderId");
	String secondOrderId	= jspHelper.getParameter("secondOrderId");

	// get standard list parameters
	String xmlFile 		= request.getParameter("ActionXMLFile");
	int startIndex 		= Integer.parseInt(jspHelper.getParameter("startindex"));
	int listSize 		= Integer.parseInt(jspHelper.getParameter("listsize"));
	String orderByParam	= request.getParameter("orderby");
	int endIndex		= startIndex + listSize;
	int rowselect 		= 1;
	
	if (orderByParam == null) {
		orderByParam = "";
	}
	
	/* ---
	Hashtable xmlRoot;
	try {
		//UIUtil.processParameters(request);
		
		// get XML Object
		
		Vector xmlObj;
		xmlObj = (java.util.Vector) requestProperties.get(ECToolsConstants.EC_XMLOBJECT);
		if (xmlObj != null) {
			xmlRoot = (Hashtable) xmlObj.firstElement(); // there should only be 1 element in the Vector
		} else {
			// need to throw an invalid parameters exception 
			throw new Exception();
		}
	}
	* ---- */
	
	String[] orders = null;
	if (firstOrderId != null && !firstOrderId.equals("")) {
		if (secondOrderId != null && !secondOrderId.equals("")) {
			orders = new String[2];
			orders[1] = secondOrderId;
		} else {
			orders = new String[1];		
		}
		orders[0] = firstOrderId;
	}
	
	OrderItemListDataBean itemList = new OrderItemListDataBean();
	itemList.setLangId(langId);
	itemList.setLogonId("");
	itemList.setOrderBy(orderByParam);
	itemList.setOrders(orders);
	
	try {
		com.ibm.commerce.beans.DataBeanManager.activate(itemList, request);
	} catch (Exception ex) {
		System.out.println(ex.getMessage());
	}

	int totalsize = 0;
	int totalpage = 0;
	if ((itemList != null) && (itemList.getResultSetSize() != 0)) {
		totalsize = itemList.getResultSetSize();
		totalpage = totalsize / listSize;
	}

%>

<%--
//---------------------------------------------------------------------
//- Forward Error JSP 
//---------------------------------------------------------------------
--%>

<html>
<head>
   
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />

<title><%= UIUtil.toHTML((String)orderMgmtNLS.get("shippingPage")) %></title>

<script src="/wcs/javascript/tools/common/Util.js"></script>
<script src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>
<script src="/wcs/javascript/tools/common/Vector.js"></script>
<script src="/wcs/javascript/tools/order/OrderMgmtUtil.js"></script>
<script src="/wcs/javascript/tools/common/dynamiclist.js"></script>

<script language="JavaScript" type="text/javascript">
<!-- <![CDATA[
//---------------------------------------------------------------------
//  Required javascript function for wizard panel and list
//---------------------------------------------------------------------
function savePanelData() {
  parent.parent.put("callPrepareRequired", "true");
  var authToken = parent.parent.get("authToken");
  if (defined(authToken)) {
	parent.parent.addURLParameter("authToken", authToken);
  }
}// END savePanelData()


function validatePanelData() { 
	
	if (get1stOrderId() == "" || "<%=itemList%>" == "null") {
		alertDialog("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("itemsMustBeSelectedMsg")) %>");
		return false
	}
	
	return true;
}

function validateNoteBookPanel() {
	return validatePanelData();

}

function onLoad() {
	
	parent.loadFrames();
	loadPanelData();
}

function getResultsSize() {
        return <%=totalsize%>;
}

function get1stOrderId() {
   var rc = "<%=firstOrderId%>";
   if (rc == "null") rc = "";
	return rc;
}
function get2ndOrderId() {
   var rc = "<%=secondOrderId%>";
   if (rc == "null") rc = "";
	return rc;
}

//---------------------------------------------------------------------
//  user defined javascript functions 
//---------------------------------------------------------------------
//
// Change Shipto address action - update order items shipto address                
//
function changeShipAddress() {

	var items = new Vector();
	var checkedItems = new Array;
	checkedItems = parent.getChecked();
	var contractId;
	var anOrderItemId;
	var orderItemSKU;
	
	parent.parent.remove("orderItem", items);
	
	for (var i=0; i<checkedItems.length; i++) {
		anItem = new Object();
		anItem.orderItemId = checkedItems[i];
		parent.removeEntry(checkedItems[i]);
		anItem.quantity	= document.itemListForm["Quantity_"+anItem.orderItemId].value;
		anItem.orderId = document.itemListForm["OrderId_"+anItem.orderItemId].value;
		contractId = document.itemListForm["ContractId_"+anItem.orderItemId].value;
		anItem.tradingId = contractId;
		addElement(anItem, items);
		anOrderItemId = anItem.orderItemId;
		orderItemSKU = document.itemListForm["SKU_"+anItem.orderItemId].value;
		
	}
	
	
		
	// if inside merchant center
	if (parent.parent.isInsideMC()) {    
		parent.parent.put("orderItem", items);
		

		// set returning panel to be current panel
		top.setReturningPanel(parent.parent.getCurrentPanelAttribute("name"));

		top.saveModel(parent.parent.model);	
		
		top.setContent(orderItemSKU+" - "+"<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("shippingAddressListTrail")) %>", 
	               "/webapp/wcs/tools/servlet/DialogView?XMLFile=order.orderShippingAddressListDialog&orderItemId="+anOrderItemId, true);
		
	} else {
		alertDialog("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("addProductWizardChaining")) %>");
	}		


}   

//
// RChange Shipping mode action - update order items shipmode                 
//   
function changeShipMode() {
	
	var items = new Vector();
	var checkedItems = new Array;
	checkedItems = parent.getChecked();
	var anOrderItemId;
	var orderItemSKU;
	
	parent.parent.remove("orderItem", items);
		
	for (var i=0; i<checkedItems.length; i++) {
		anItem = new Object();
		anItem.orderItemId = checkedItems[i];
		parent.removeEntry(checkedItems[i]);
		anItem.quantity	= document.itemListForm["Quantity_"+anItem.orderItemId].value;
		anItem.orderId = document.itemListForm["OrderId_"+anItem.orderItemId].value;
		addElement(anItem, items);
		anOrderItemId = anItem.orderItemId;
		orderItemSKU = document.itemListForm["SKU_"+anItem.orderItemId].value;
		
	}
	
	if (size(items) != 0) 
		parent.parent.put("orderItem", items);
	
	
	if (parent.parent.isInsideMC()) {
		top.saveModel(parent.parent.model);
		
		//set returning panel to be current panel
		top.setReturningPanel(parent.parent.getCurrentPanelAttribute("name"));
		
		top.setContent(orderItemSKU+" - "+"<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("selectShipModeTitle")) %>",
			       "/webapp/wcs/tools/servlet/DialogView?XMLFile=order.orderSelectShipModeDialog&orderItemId="+anOrderItemId, 
			       true);
	}
	
}


function debugAlert(msg) {
//	alert("DEBUG: " + msg);
}

var order = parent.parent.get("order");

function loadPanelData() {
	
	// remove preCommand in XML when this page loaded
	var preCommand = parent.parent.get("preCommand");
	if (defined(preCommand) && preCommand != "") {
		parent.parent.remove("preCommand");
	}
	parent.parent.remove("preCmdChain");
	
	parent.parent.remove("orderItem");
	parent.parent.remove("address");
	if (parent.parent.setContentFrameLoaded) {
		parent.parent.setContentFrameLoaded(true);
	}
	
   
}
orderItemsEditable = new Object();
function checkButtons() {
       var checked = parent.getChecked();       
       //disable not editable item.
       
       for (var i=0; i<checked.length; i++) {
       		if ( !defined(orderItemsEditable[checked[i]]) ) {   		
                     parent.buttons.buttonForm.chgShipAddrButton.disabled = true;
                     parent.buttons.buttonForm.chgShipAddrButton.className='disabled';
                     parent.buttons.buttonForm.chgShipModeButton.disabled = true;
                     parent.buttons.buttonForm.chgShipModeButton.className='disabled';            
            }
       }       
 
}
//[[>-->
</script>

</head>
<!--BODY bgcolor= "#A6A6A6" LINK = "#00436A" VLINK = "#00436A"  ALINK = "#00436A" -->
<body class="content">
<!--Support For Customers,Shopping Under Multiple Accounts. -->
<form name="itemListForm">
 <%request.setAttribute("resourceBundle", orderAddProducts);%> 
<jsp:include page="ActiveOrganization.jsp"
	flush="true" /> 
	<br />
	<%= comm.startDlistTable((String)orderLabels.get("CSOrderListTableSummary")) %>
	<%= comm.startDlistRowHeading() %>
		<%= comm.addDlistCheckHeading() %>
		<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("itemName"), "productName", orderByParam.equals("productName")) %>
		<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("itemNumber"), null, false) %>
		<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("shippingAddressPageContractName"), null, false) %>
		<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("itemShipAddress"), "shipAddress", orderByParam.equals("shipAddress")) %>
		<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("itemShipMethod"), "shipMode", orderByParam.equals("shipMode")) %>
	<%= comm.endDlistRow() %>
	
	<%
	if (totalsize != 0) {
		//if (endIndex > itemList.length) {
			endIndex = itemList.getResultSetSize();
		//}
	} else {
		endIndex = 0;
	}

	
	//TABLE CONTENT
	int indexFrom = startIndex;
	for (int i=indexFrom; i<endIndex; i++) {
	%>
		<%= comm.startDlistRow(rowselect) %>
			<%= comm.addDlistCheck(itemList.getOrderItemListData(i).getOrderItemId(), "parent.setChecked();checkButtons();") %>
		 <script>             
                 <%                     
                  boolean isEditable = itemList.getOrderItemListData(i).getOrderItemBean().isEditable();
                  if(isEditable){                         
                  %>
                      orderItemsEditable["<%= itemList.getOrderItemListData(i).getOrderItemId() %>"] = true;
                  <%
                    }
                  %>
              </script>
			<%= comm.addDlistColumn(getOrderItemName(itemList.getOrderItemListData(i).getCatalogEntryId(), request), "none") %>
			<%= comm.addDlistColumn(itemList.getOrderItemListData(i).getSKU(), "none") %>
			<%= comm.addDlistColumn(getContractName(itemList.getOrderItemListData(i).getContractId(), request), "none") %>
			<%= comm.addDlistColumn(getShippingAddress(itemList.getOrderItemListData(i).getAddressId(), request), "none") %>
			<%= comm.addDlistColumn(getShipMode(itemList.getOrderItemListData(i).getShippingModeId(), storeId, langId, request), "none") %>
			<input type="hidden" name="Quantity_<%=itemList.getOrderItemListData(i).getOrderItemId()%>" value="<%=itemList.getOrderItemListData(i).getQuantity()%>" />
			<input type="hidden" name="ContractId_<%=itemList.getOrderItemListData(i).getOrderItemId()%>" value="<%=itemList.getOrderItemListData(i).getContractId()%>" />
			<input type="hidden" name="OrderId_<%=itemList.getOrderItemListData(i).getOrderItemId()%>" value="<%=itemList.getOrderItemListData(i).getOrderId()%>" />
			<input type="hidden" name="SKU_<%=itemList.getOrderItemListData(i).getOrderItemId()%>" value="<%=itemList.getOrderItemListData(i).getSKU()%>" />
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
	if (itemList == null) {
%>

<p></p><p>
</p><table cellspacing="0" cellpadding="3" border="0">
<tr>
	<td colspan="7">
		<%=UIUtil.toHTML( (String) orderLabels.get("noOrdersToList"))%>
	</td>
</tr>
</table>	
<% }
%>	
</form>

<form name="callActionForm" action="" method="post">
<input type="hidden" name="XML" value="" />
<input type="hidden" name="URL" value="" />
</form>

<script type="text/javascript">
<!-- <![CDATA[
        parent.afterLoads();
        parent.setResultssize(getResultsSize());
//[[>-->
</script>

<script language="JavaScript" type="text/javascript">
<!-- <![CDATA[
//For IE
if (document.all) {
	onLoad();
}
//[[>-->
</script>

</body>
</html>

