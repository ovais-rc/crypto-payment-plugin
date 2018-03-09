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
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.order.beans.*" %>
<%@ page import="com.ibm.commerce.order.objects.*" %>
<%@ page import="com.ibm.commerce.price.utils.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.helpers.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.beans.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.fulfillment.objects.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.price.beans.*" %>
<%@ page import="com.ibm.commerce.price.commands.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %> 
<%@include file="../../tools/common/common.jsp" %>
<%@include file="../../tools/common/NumberFormat.jsp" %>

<%--
//---------------------------------------------------------------------
//- Method Declarion
//---------------------------------------------------------------------
--%>
<%!
	public String getFormattedAmount(BigDecimal amount, String currency, Integer langId, String storeId)
	{
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
   	Integer langId		= cmdContextLocale.getLanguageId();
   	Integer storeId 	= cmdContextLocale.getStoreId();
   	String currency		= cmdContextLocale.getCurrency();
   	Hashtable orderLabels 	= (Hashtable)ResourceDirectory.lookup("order.orderLabels", jLocale);
   	Hashtable orderMgmtNLS 	= (Hashtable)ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);

	// retrieve request parameters
	JSPHelper jspHelper 	= new JSPHelper(request);
	String orderId		= jspHelper.getParameter("orderId");
	String customerId	= jspHelper.getParameter("customerId");
	String billingAddressId	= jspHelper.getParameter("addressId");
	String orderByParam	= jspHelper.getParameter("orderby");
	String searchForProductName = jspHelper.getParameter("searchProductName");
	String searchForSKUNumber = jspHelper.getParameter("searchSKUNumber");
	String searchMaxMatches  = jspHelper.getParameter("searchMaxMatches");
		
	// get standard list parameters
	String xmlFile 	= jspHelper.getParameter("ActionXMLFile");
	int startIndex 	= Integer.parseInt(jspHelper.getParameter("startindex"));
	int listSize 	= Integer.parseInt(jspHelper.getParameter("listsize"));
	int endIndex	= startIndex + listSize;
	int rowselect 	= 1;
	
	if (orderByParam == null) {
		orderByParam = "";
	}
	
	String cusCurrency = new String();
	UserRegistrationDataBean userDataBean = new UserRegistrationDataBean();
	try {
		userDataBean.setUserId(customerId);
		com.ibm.commerce.beans.DataBeanManager.activate(userDataBean, request);
		cusCurrency = userDataBean.getPreferredCurrency();
	} catch (Exception ex) {
	}
	
	if (cusCurrency != null && !cusCurrency.equals("")) {
		currency = cusCurrency;
	}
	
	//get product search bean
	ProductListBean pList = new ProductListBean();
	pList.setNameLike(searchForProductName);
	pList.setSKULike(searchForSKUNumber);
	pList.setOrderBy("name");
	pList.setShopperId(customerId);
	pList.setCommandContext(cmdContextLocale);
	pList.setMaxMatches(searchMaxMatches);
	//pList.setCurrency(currency);
	
	try {
	com.ibm.commerce.beans.DataBeanManager.activate(pList, request);
	} catch (Exception ex) {
	}
	
	int totalsize 	= pList.getListSize();
	int totalpage	= totalsize / listSize;
%>

<%--
//---------------------------------------------------------------------
//- Forward Error JSP 
//---------------------------------------------------------------------
--%>

<html>
<head>

<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" /> 

<title><%= orderMgmtNLS.get("addProductResultsListTitle") %></title>

<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Vector.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/order/OrderMgmtUtil.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/ConvertToXML.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>

<script language="JavaScript" type="text/javascript">
<!-- <![CDATA[

//---------------------------------------------------------------------
//  Required javascript function for wizard panel and list
//---------------------------------------------------------------------
function initializeState() {
	parent.parent.setContentFrameLoaded(true);
	defineXMLObject();
}

function getResultsSize() {
	return <%=pList.getListSize() %>;
}

function onLoad() {
  	parent.loadFrames();
}


//---------------------------------------------------------------------
//  user defined javascript functions 
//---------------------------------------------------------------------
/******************************
* prepare the xml object
* pre: 	assume that the wizard xml object is placed in the banner
* post: an xml object for local use in defined
*******************************/
function defineXMLObject() {
	var XMLObject = top.getData("model", 1);

	var order = parent.parent.get("order");
	if ((order == null) || (!defined(order))) 
		order = new Object();
		
	order.billingAddressId 	= XMLObject.order.billingAddressId;
	order.customerId 	= XMLObject.order.customerId;
	if (defined(XMLObject.order.firstOrder) && (XMLObject.order.firstOrder!= null))
		order.orderId 	= XMLObject.order.firstOrder.id;
	
	parent.parent.put("order", order);
debugAlert(parent.parent.modelToXML("XML"));	
}


/******************************
* Add the items to the order
* pre:	checkedItems expected to contain all checked items in the list
* post:	all checked items are stored into the xml object and the OrderItemAddCmd is triggered
*******************************/
function addItem() {
	var checkedItems = parent.parent.get("checkedItems");
	var newItems = new Vector();
	
	if (defined(checkedItems) && (checkedItems != null)) {
		for (var i=0; i<size(checkedItems); i++) {
			var anItem = elementAt(i, checkedItems);
			
			if (anItem.error != "") {
				alertDialog(anItem.error);
				return;
			}  //if
			
			if (anItem.quantity != "") {
				addElement(anItem, newItems);
			}
		}  //for
	}  //if

	if ((newItems == null) || (size(newItems) == 0)) {
		alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("noItemsSelected")) %>");
		return;
	}  //if

	parent.parent.remove("checkedItems");
	parent.parent.put("orderItem", newItems);

	parent.parent.setContentFrameLoaded(false);
	
	document.addProduct.XML.value = parent.parent.modelToXML("XML");
	document.addProduct.URL.value = "OrderProductListRedirect";
	document.addProduct.submit();
	
}  //addItem


//---------------------------------------------------------------------
//  GUI functions
//---------------------------------------------------------------------
/******************************
* 
*******************************/
function debugAlert(msg) {
//	alert("DEBUG: " + msg);
}

/******************************
* retrieve quantity for the item if it exists in checkedItems
*******************************/
function getQuantity(catentryId) {
	var checkedItems = parent.parent.get("checkedItems");
	
	if (defined(checkedItems) && (checkedItems != null)) {
		for (var i=0; i<size(checkedItems); i++) {
			var anItem = elementAt(i, checkedItems);
			if (anItem.catentryId == catentryId)
				return (anItem.quantity.toString());
		}  //for
	}  //if
	
	return('');
}

/******************************
* set the quantity value in the text field
*******************************/
function setQuantityValue(catentryId) {
	var quantity = getQuantity(catentryId);
	var itemForm = document.itemListForm;
	
	itemForm["Quantity_"+catentryId].value = quantity;
}

//---------------------------------------------------------------------
//  helper functions
//---------------------------------------------------------------------

/******************************
* returns true if the input is a valid quantity, false otherwise
*******************************/
function isValidQuantity(quantity) {
	if (quantity == '0')
		return false;

	if (quantity < '0') 
		return false;

	number = parent.parent.strToNumber(quantity, <%=langId%>);
	
	if (number == null) {
		return false;
	}
	
	if (number.toString() == "NaN") {
		return false;
	}
	
	return true;
}


//---------------------------------------------------------------------
//  temporary storage : checkedItems
//---------------------------------------------------------------------
/******************************
* create a new entry in the checkedItems
*******************************/
function createCheckedItem(catentryId) {
	var itemForm = document.itemListForm;
	var checkedItems = parent.parent.get("checkedItems");
	if ((checkedItems == null) || (!defined(checkedItems)))
		checkedItems = new Vector();
	
	// create new field
	var anItem = new Object();
	anItem.catentryId 	= catentryId;	
	anItem.quantity 	= parent.parent.strToNumber(itemForm["Quantity_"+catentryId].value, <%=langId%>);
	anItem.sku		= itemForm["SKU_"+catentryId].value;
	anItem.error		= "";
	
	var ct_size = itemForm["ContractSize_"+catentryId].value;
	
	if (ct_size == 1) {
		anItem.tradingId = itemForm["ContractId_"+catentryId].value;
	} else {
		for (var i=0; i<ct_size; i++) {	
			if (itemForm["ContractId_"+catentryId][i].checked) {
				anItem.tradingId = itemForm["ContractId_"+catentryId][i].value;
			}
		}
	}

	if (!isValidQuantity(anItem.quantity)) {
		anItem.error 	= "<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("invalidQuantityMsg"))%>".replace(/%1/, anItem.sku);
		anItem.quantity = '';
	} //if
	
	addElement(anItem, checkedItems);
	
	parent.parent.put("checkedItems", checkedItems);
}

/******************************
* update the entry in the checkedItems
*******************************/
function updateCheckedItem(catentryId) {
	var itemForm = document.itemListForm;
	var checkedItems = parent.parent.get("checkedItems");
	if ((checkedItems == null) || (!defined(checkedItems)))
		checkedItems = new Vector();
		
	var itemUpdated = false;	
	var newQuantity = itemForm["Quantity_"+catentryId].value;
		
	for (var i=0; i<size(checkedItems); i++) {
		var anItem = elementAt(i, checkedItems);
		if (anItem.catentryId == catentryId) {
			if (newQuantity != '' && !isValidQuantity(newQuantity)) {
				anItem.error 	= "<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("invalidQuantityMsg"))%>".replace(/%1/, anItem.sku);
				anItem.quantity = '';	
				anItem.tradingId = '';
			} else {
				anItem.error 	= "";
				anItem.quantity = newQuantity;					
				
				var ct_size = itemForm["ContractSize_"+catentryId].value;
				if (ct_size == 1) {
					anItem.tradingId = itemForm["ContractId_"+catentryId].value;
				} else {
					for (var j=0; j<ct_size; j++) {
						if (itemForm["ContractId_"+catentryId][j].checked) {
							anItem.tradingId = itemForm["ContractId_"+catentryId][j].value;
						}
					}
				}

			}
		
			itemUpdated = true;
			parent.parent.put("checkedItems", checkedItems);			
		}
	}
		
	if (!itemUpdated) {
		createCheckedItem(catentryId);
	}
}
//[[>-->
</script>
</head>


<body class="content" onload="initializeState();">
<!-- -----------------------------------------------------------------
  -- Add your form and hidden input here
  -- ----------------------------------------------------------------->
<form name="addProduct" method="post" action="CSROrderItemAdd">
	<input type='hidden' name="XML" value="" /> 
      	<input type='hidden' name="URL" value="" />
</form>



<form name="itemListForm">
	<input type="hidden" name="searchProductName" value="<%=UIUtil.toHTML(searchForProductName)%>" />
	<input type="hidden" name="searchSKUNumber" value="<%=UIUtil.toHTML(searchForSKUNumber)%>" />
	<input type="hidden" name="searchMaxMatches" value="UIUtil.toHTML(<%=searchMaxMatches%>)" />
	<script>
		var now = new Date();
		var time = now.getTime().toString();
	</script>
	<input type="hidden" name="CTS" value="time" />
	
	
	<%=orderMgmtNLS.get("addProductDialogB2BInstructions") %>
	<br /><br />
	
	<%= comm.startDlistTable((String)orderMgmtNLS.get("addProductResultsListTitle")) %>
	<%= comm.startDlistRowHeading() %>
		<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("itemName"), null, false) %>
		<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("itemNumber"), null, false) %>
		<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("itemQuantity"), null, false) %>
		<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("itemDescription"), null, false) %>
		<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("itemContractPrice"), null, false) %>
	<%= comm.endDlistRow() %>
	
	<%
	if (endIndex > pList.getListSize()) {
		endIndex = pList.getListSize();
	}
	
	// TABLE CONTENT
	int indexFrom = startIndex;
	int listCount = 0;
	for (int i=indexFrom; i<pList.getListSize(); i++) {
//	    CatEntryPrices[] contractPrice = pList.getProductListData(i).getContractPricesInEntityType();
	    Long[] tradingIds = pList.getProductListData(i).getTradingIds();
	    MonetaryAmount[] tradingUnitPrices = pList.getProductListData(i).getTradingUnitPrices();
	    
	    if (tradingIds != null) { 
	 	listCount++; %>
	 	
		<%= comm.startDlistRow(rowselect) %>
			<%= comm.addDlistColumn(pList.getProductListData(i).getName(), "none") %>
			<%= comm.addDlistColumn(pList.getProductListData(i).getPartNumber(), "none") %>
			<input type='hidden' name="SKU_<%=pList.getProductListData(i).getCatentryId()%>" value="<%=UIUtil.toHTML(pList.getProductListData(i).getPartNumber())%>" />
			<%= comm.addDlistColumn("<label id='quantity" + i + "'/><input type='text' maxlength='10' name='Quantity_" + pList.getProductListData(i).getCatentryId() + "' id='quantity" + i + "' size='3' align='right' onChange='updateCheckedItem("+pList.getProductListData(i).getCatentryId()+");'>", "none") %>
			<script>//setQuantityValue(<%=pList.getProductListData(i).getCatentryId()%>);</script>
			<%= comm.addDlistColumn(pList.getProductListData(i).getDescription(), "none") %>
			
			<% String contractPriceChoice = "";
			   for (int j=0; j<tradingIds.length; j++) {	
				String checkedPrice = "";
				if (j==0)
					checkedPrice = "CHECKED";
				
				contractPriceChoice += "<label id='radio" + i + "'/><INPUT TYPE='RADIO' NAME='ContractId_" + pList.getProductListData(i).getCatentryId() + "' id='radio" + i + "' VALUE='" + tradingIds[j] + "' " + checkedPrice + " onChange='updateCheckedItem("+pList.getProductListData(i).getCatentryId()+");'>" + getFormattedAmount(tradingUnitPrices[j].getValue(), currency, langId, storeId.toString()) + "<BR>";
			   } %>
			<input type='hidden' name="ContractSize_<%=pList.getProductListData(i).getCatentryId()%>" value="<%=tradingIds.length%>" />
			<%= comm.addDlistColumn(contractPriceChoice, "none") %>
			
		<%= comm.endDlistRow() %>
	
		<% 
		if (rowselect == 1) {
			rowselect = 2;
		} else {
			rowselect = 1;
		}
	    }
	} 

	%>	
	<%= comm.endDlistTable() %>
	
<%
//	if (pList.getListSize() == 0) {
	if (listCount == 0) {
%>

<p></p><p>
</p><table cellspacing="0" cellpadding="3" border="0">
<tr>
	<td colspan="7">
		<%=orderMgmtNLS.get("noItemsFoundMsg")%>
	</td>
</tr>
</table>	
<% }
%>
</form>	

<script>
    <!--
        parent.afterLoads();
        parent.setResultssize(getResultsSize());
    //-->
</script>

<script language="JavaScript">
<!--
//For IE
if (document.all) {
	onLoad();
}
//-->
</script>
</body>
</html>
