<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2017
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
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.order.beans.*" %>
<%@ page import="com.ibm.commerce.fulfillment.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.price.utils.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.helpers.*" %> 
<%@ page import="com.ibm.commerce.tools.optools.common.helpers.*" %> 
<%@ page import="com.ibm.commerce.tools.optools.order.beans.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
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
	
	public String getFormattedQuantity(double quantity, Locale locale) {
		java.text.NumberFormat numberFormat = java.text.NumberFormat.getNumberInstance(locale);
		return numberFormat.format(quantity);
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
   	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   	Locale jLocale 		= cmdContext.getLocale();
   	String langId		= cmdContext.getLanguageId().toString();
   	Integer storeId 	= cmdContext.getStoreId();
   	Hashtable orderLabels 	= (Hashtable)ResourceDirectory.lookup("order.orderLabels", jLocale);
   	Hashtable orderMgmtNLS 	= (Hashtable)ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);
   	Hashtable orderAddProducts 	= (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderAddProducts", jLocale);

	// retrieve request parameters
	com.ibm.commerce.server.JSPHelper jspHelper = new JSPHelper(request);
	String firstOrderId 	= jspHelper.getParameter("firstOrderId");
	String secondOrderId	= jspHelper.getParameter("secondOrderId");

	// get standard list parameters
	//String xmlFile 		= request.getParameter("ActionXMLFile");
	String xmlFile = jspHelper.getParameter("ActionXMLFile");
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
	


	//
	// Check if orders actually have order items. Used to update the "hasItems" flag for the orders
	//
	OrderDataBean orderBean = new OrderDataBean ();
	OrderDataBean orderBean2 = new OrderDataBean ();
	OrderItemDataBean[] afirstOrderItems = null;
	OrderItemDataBean[] asecondOrderItems = null;
	boolean firstOrderExist = false;
	boolean secondOrderExist = false;

	if ((firstOrderId != null) && !(firstOrderId.equals(""))) {
		orderBean.setOrderId(firstOrderId);
		com.ibm.commerce.beans.DataBeanManager.activate(orderBean, request);
		afirstOrderItems = orderBean.getOrderItemDataBeans();
		if (afirstOrderItems.length != 0)
			firstOrderExist = true;
	}

	if ((secondOrderId != null) && !(secondOrderId.equals(""))) {
		orderBean2.setOrderId(secondOrderId);
		com.ibm.commerce.beans.DataBeanManager.activate(orderBean2, request);
		asecondOrderItems = orderBean2.getOrderItemDataBeans();
		if (asecondOrderItems.length != 0)
			secondOrderExist = true;
	}


	
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

<title><%= UIUtil.toHTML((String)orderMgmtNLS.get("allocateItemsPage")) %></title>

<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Vector.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/order/OrderMgmtUtil.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>

<script language="JavaScript" type="text/javascript">
<!-- <![CDATA[
//---------------------------------------------------------------------
//  Required javascript function for wizard panel and list
//---------------------------------------------------------------------

var order = parent.parent.get("order");

//
// set hasItems flag for orders
//
firstOrderObj = order["firstOrder"];
secondOrderObj = order["secondOrder"];
if (defined(firstOrderObj)) {
   updateEntry(firstOrderObj, "hasItems", "<%= firstOrderExist %>");
}
if (defined(secondOrderObj)) {
   updateEntry(secondOrderObj, "hasItems", "<%= secondOrderExist %>");
}


function savePanelData() {
    parent.parent.put("callPrepareRequired", "true");       

    var authToken = parent.parent.get("authToken");
    if (defined(authToken)) {
	parent.parent.addURLParameter("authToken", authToken);
    }       
        
}// END savePanelData()


function validatePanelData() { 
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

//---------------------------------------------------------------------
//  user defined javascript functions 
//---------------------------------------------------------------------

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

function loadPanelData() {
	
	// remove preCommand in XML when this page loaded
	var preCommand = parent.parent.get("preCommand");
	if (defined(preCommand) && preCommand != "") {
		parent.parent.put("preCommand");
	}
	parent.parent.remove("preCmdChain");
	
	removeEntry(order, "item");
	
	if (get2ndOrderId() != "") {
		var secondOrder = order["secondOrder"];
		if (!defined(secondOrder)) {
			secondOrder = new Object();
			updateEntry(secondOrder, "id", get2ndOrderId());
			updateEntry(order, "secondOrder", secondOrder);
		} else {
			updateEntry(secondOrder, "id", get2ndOrderId());
		}
	}

	if (parent.parent.setContentFrameLoaded) {
		parent.parent.setContentFrameLoaded(true);
	}
   
	//if there are no items then re-direct the user to the products page
	if ("<%=totalsize%>" == "0") {
		alertDialog("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("itemsMustBeSelectedMsg")) %>");
		parent.parent.gotoPanel("productsPageNavTabTitle");
	}
   
}
//function checkButtons() {
	//debugAlert("checkButtons");
//	refreshButtons();
//}
function shipIn1stOrder() {
	parent.parent.remove("orderItem");
	var items = new Vector();
	var checkedItems = new Array;
	checkedItems = parent.getChecked();
	for (var i=0; i < checkedItems.length; i++) {
		anItem = new Object();
		anItem.orderItemId = checkedItems[i];
		for (var j = 0; j < document.itemListForm.elements.length; j++) {
			if (document.itemListForm.elements[j].name  == "orderId_for_"+checkedItems[i]) {
				anItem.orderId = document.itemListForm.elements[j].value;
				break;
			}
		}
		parent.removeEntry(checkedItems[i]);
		addElement(anItem, items);
	}
	if (checkedItems.length > 0) {
		parent.parent.put("orderItem", items);
		var xmlObject = parent.parent.modelToXML("XML");
		document.splitActionForm.action="CSROrderItemSplit";
		document.splitActionForm.XML.value=xmlObject;
		if (get2ndOrderId() == "")
			document.splitActionForm.URL.value="OrderItemsAllocationPageB2B?ActionXMLFile=order.orderItemsAllocationPage&listsize=15&startindex=0&firstOrderId="+get1stOrderId();
		else
			document.splitActionForm.URL.value="OrderItemsAllocationPageB2B?ActionXMLFile=order.orderItemsAllocationPage&listsize=15&startindex=0&firstOrderId="+get1stOrderId()+"&secondOrderId="+get2ndOrderId();

		parent.parent.setContentFrameLoaded(false);
		document.splitActionForm.toOrderId.value = get1stOrderId();
		document.splitActionForm.fromOrderId.value = get2ndOrderId();
		document.splitActionForm.submit();
	} else {
		alertDialog("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("noItemsSelected")) %>");
	}
}
function shipIn2ndOrder() {

	parent.parent.remove("orderItem");
	var items = new Vector();
	var checkedItems = new Array;
	checkedItems = parent.getChecked();
	for (var i=0; i < checkedItems.length; i++) {
		anItem = new Object();
		anItem.orderItemId = checkedItems[i];
		for (var j = 0; j < document.itemListForm.elements.length; j++) {
			if (document.itemListForm.elements[j].name  == "orderId_for_"+checkedItems[i]) {
				anItem.orderId = document.itemListForm.elements[j].value;
				break;
			}
		}
		parent.removeEntry(checkedItems[i]);
		addElement(anItem, items);
	}
	if (checkedItems.length > 0) {
		parent.parent.put("orderItem", items);
		var xmlObject = parent.parent.modelToXML("XML");
		document.splitActionForm.action="CSROrderItemSplit";
		document.splitActionForm.XML.value=xmlObject;
		if (get2ndOrderId() == "")
			document.splitActionForm.URL.value="OrderItemsAllocationPageB2B?ActionXMLFile=order.orderItemsAllocationPage&listsize=15&startindex=0&firstOrderId="+get1stOrderId();
		else
			document.splitActionForm.URL.value="OrderItemsAllocationPageB2B?ActionXMLFile=order.orderItemsAllocationPage&listsize=15&startindex=0&firstOrderId="+get1stOrderId()+"&secondOrderId="+get2ndOrderId();
		
		parent.parent.setContentFrameLoaded(false);
		document.splitActionForm.toOrderId.value = get2ndOrderId();
		document.splitActionForm.fromOrderId.value = get1stOrderId();
		document.splitActionForm.submit();
	} else {
		alertDialog("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("noItemsSelected")) %>");
	}
}
//
// Remove Product action                   
//
function removeItems() {
	if (confirmDialog("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("addProductDialogRemoveConfirm")) %>")) {
		parent.parent.remove("deletedOrderItem");

		var itemsSelected = false;
		var items = new Vector();
		var checkedItems = new Array;
		checkedItems = parent.getChecked();
		
		for (var i=0; i<checkedItems.length; i++) {
			anItem = new Object();
			anItem.orderItemId = checkedItems[i];
			parent.removeEntry(checkedItems[i]);
			addElement(anItem, items);
		}
		
		if (checkedItems.length > 0) {				
			parent.parent.put("deletedOrderItem", items);
			
			// Before leaving this page needs to save the data changed in the panel
			savePanelData();
			
			// Validate the current panel before allowing the user to proceed
			if (validatePanelData()) {
			
				//---------------------------------
				// call the itemdelete command here
				//---------------------------------
				parent.parent.setContentFrameLoaded(false);				
				var xmlObject = parent.parent.modelToXML("XML");
				debugAlert("DEBUG: xml=" + xmlObject);
				document.callActionForm.action="CSROrderItemDelete";
				document.callActionForm.XML.value=xmlObject;
				document.callActionForm.URL.value="OrderItemsAllocationPageB2B?ActionXMLFile=order.orderItemsAllocationPage&listsize=15&startindex=0&firstOrderId="+get1stOrderId()+"&secondOrderId="+get2ndOrderId();	
				document.callActionForm.submit();
			}
		} else {
			alertDialog("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("noItemsSelected")) %>");
		}
		
	}
}
orderItemsEditable = new Object();

function checkButtons() {
       var checked = parent.getChecked();
       //alert(checked);
       //disable not editable item.
       
       for (var i=0; i<checked.length; i++) {
       		if ( !defined(orderItemsEditable[checked[i]]) ) {         		
            disableButton(parent.buttons.buttonForm.removeProductsButton); 
       	  }
       } 
}

function disableButton(buttonName) {
       if (defined(buttonName)) {
              buttonName.disabled= true;
              buttonName.className='disabled';              
       }
}

function selectAllButtons() {
       parent.selectDeselectAll();
       checkButtons();
}

//---------------------------------------------------------------------
//  GUI functions
//---------------------------------------------------------------------

/******************************
* print up the debug messages
*******************************/
function debugAlert(msg) {
//	alert("DEBUG: " + msg);
}
//[[>-->
</script>

</head>
<body class="content">
<!--Support For Customers,Shopping Under Multiple Accounts. -->
<%= comm.addControlPanel(xmlFile, totalpage, totalsize, jLocale) %>

<form name="itemListForm">
<%request.setAttribute("resourceBundle", orderAddProducts);%> 
<jsp:include page="ActiveOrganization.jsp"
	flush="true" /> 
	<br />
	<%= comm.startDlistTable((String)orderLabels.get("CSOrderListTableSummary")) %>
	<%= comm.startDlistRowHeading() %>
		<%= comm.addDlistCheckHeading(true, "selectAllButtons()") %>
		<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("itemName"), "productName", orderByParam.equals("productName")) %>
		<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("itemNumber"), null, false) %>
		<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("itemQuantity"), null, false) %>
		<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("contractName"), null, false) %>
		<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("itemShippingDate"), "shipDate", orderByParam.equals("shipDate")) %>
		
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
			<%= comm.addDlistColumn(getFormattedQuantity(itemList.getOrderItemListData(i).getQuantityInEntityType().doubleValue(), jLocale), "none") %>
			<%= comm.addDlistColumn(getContractName(itemList.getOrderItemListData(i).getContractId(), request), "none") %>
			<% if (itemList.getOrderItemListData(i).getEstimatedAvailableTimeInEntityType() != null) { 
			 	String estimatedShipDate = TimestampHelper.getDateFromTimestamp(itemList.getOrderItemListData(i).getEstimatedAvailableTimeInEntityType(), jLocale);                                
			%>		           
			        <%= comm.addDlistColumn(estimatedShipDate , "none") %>
				
			<% }  else { %>
				<%= comm.addDlistColumn("", "none") %>
			
			<% } %>

			<input type="hidden" name="orderId_for_<%=itemList.getOrderItemListData(i).getOrderItemId()%>" value="<%=itemList.getOrderItemListData(i).getOrderId()%>" />
			
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

<form name="splitActionForm" action="" method="post">
<input type="hidden" name="XML" value="" />
<input type="hidden" name="URL" value="" />
<input type="hidden" name="toOrderId" value="" />
<input type="hidden" name="fromOrderId" value="" />
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

