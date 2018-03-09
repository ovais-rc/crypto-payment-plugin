<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006, 2017
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>

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
<%@ page import="com.ibm.commerce.tools.optools.order.beans.*" %>
<%@ page import="com.ibm.commerce.price.beans.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.fulfillment.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.price.utils.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.helpers.*" %> 
<%@ page import="com.ibm.commerce.tools.optools.common.helpers.*" %> 
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %> 
<%@ page import="com.ibm.commerce.order.objects.*" %>
<%@page import="java.math.BigDecimal" %>
<%@page import="com.ibm.commerce.tools.catalog.util.RangePricing"%>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="java.util.*"%>
<%@page import="com.ibm.commerce.catalog.objects.CatalogEntryAccessBean"%>
<%@page import="com.ibm.commerce.user.beans.AdminOrganizationListDataBean"%>
<%@page import ="com.ibm.commerce.user.objects.OrganizationAccessBean"%>
<%@include file="../../tools/common/common.jsp" %>
<%@include file="../../tools/common/NumberFormat.jsp" %>

<%-- 
//---------------------------------------------------------------------
//- Method Declaration
//---------------------------------------------------------------------
--%>
<%! 
       // Method to get catalog entry name for an order item
       public String getOrderItemName(String catalogEntryId, HttpServletRequest request) {
              String name;
     
              try {
                     CatalogEntryDataBean aCatalogEntry       = new CatalogEntryDataBean(); 
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
       
//Support For Customers,Shopping Under Multiple Accounts. 
//This is the new function added to display the organization selection list box.

private String generateOrganizationsLB(
	String selOrgId,
	String customerId,
	HttpServletRequest request) {

	Iterator iter = null;
	TreeMap sortedMap = new TreeMap();
	String orgId = "";
	String orgName = "";
	if (selOrgId == null) {
		selOrgId = "";
	}
	try {
		AdminOrganizationListDataBean orgListDataBean =
			new AdminOrganizationListDataBean();
		OrganizationAccessBean[] entitledOrganizations = null;
		
		orgListDataBean.setCustomerMemberId(new Long(customerId));
		orgListDataBean.setAccountCheck(true);
		orgListDataBean.setExplicitEntitlement(false);
		DataBeanManager.activate(orgListDataBean, request);
		entitledOrganizations = orgListDataBean.getEntitledOrganizations();
		for (int i = 0; i < entitledOrganizations.length; i++) {
			orgId = entitledOrganizations[i].getOrganizationId();
			orgName = entitledOrganizations[i].getDisplayName();
			sortedMap.put(orgId, orgName);
		}
		iter = sortedMap.keySet().iterator();
	} catch (Exception e) {
		e.printStackTrace();
	}

	String resulttitle = "";

	if (iter == null) {
		
		return "";
	}

	String result =
		resulttitle + "<SELECT NAME=selectOrg ID=orgId width=100 > \n";

	while (iter.hasNext()) {
		orgId = (String) iter.next();
		orgName = (String) sortedMap.get(orgId);
		result = result + "   <OPTION value=" + orgId;
		

		if (orgId.equalsIgnoreCase(selOrgId)) {
			result = result + " selected";
		}
		result = result + ">" + orgName + "</OPTION> \n";
	}

	result += " </SELECT> ";
	
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
       CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
       Locale jLocale               = cmdContextLocale.getLocale();
       String langId              = cmdContextLocale.getLanguageId().toString();
       Integer storeLanguageId = cmdContextLocale.getLanguageId();
//Long activeOrgId = cmdContextLocale.getActiveOrganizationId();
       Integer storeId        = cmdContextLocale.getStoreId();
       Hashtable orderLabels        = (Hashtable)ResourceDirectory.lookup("order.orderLabels", jLocale);
       Hashtable orderMgmtNLS        = (Hashtable)ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);
Hashtable orderAddProducts =
	(Hashtable) com.ibm.commerce.tools.util.ResourceDirectory.lookup(
		"order.orderAddProducts",
		jLocale);
       // retrieve request parameters
       JSPHelper jspHelper = new JSPHelper(request);
       String firstOrderId        = jspHelper.getParameter("firstOrderId");
       String secondOrderId       = jspHelper.getParameter("secondOrderId");
       String customerId        = jspHelper.getParameter("customerId");
       //Support For Customers,Shopping Under Multiple Accounts. 
       String selOrgId = "";
       com.ibm.commerce.user.beans.UserRegistrationDataBean userBean = new com.ibm.commerce.user.beans.UserRegistrationDataBean();
       userBean.setDataBeanKeyMemberId(customerId);
       DataBeanManager.activate(userBean,request);
       selOrgId = userBean.getParentMemberId();

       // get standard list parameters
       int startIndex               = Integer.parseInt(jspHelper.getParameter("startindex"));
       int listSize               = Integer.parseInt(jspHelper.getParameter("listsize"));
       String orderByParam        = request.getParameter("orderby");
       int endIndex              = startIndex + listSize;
       int rowselect               = 1;


       if (null == orderByParam)
       {
              orderByParam = "";
       }
       


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
              if (afirstOrderItems.length != 0) {
                     firstOrderExist = true;
              }
	selOrgId = orderBean.getOrganizationId();
       }

       if ((secondOrderId != null) && !(secondOrderId.equals(""))) {
              orderBean2.setOrderId(secondOrderId);
              com.ibm.commerce.beans.DataBeanManager.activate(orderBean2, request);
              asecondOrderItems = orderBean2.getOrderItemDataBeans();
              if (asecondOrderItems.length != 0) {
                     secondOrderExist = true;
              }
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
       
       com.ibm.commerce.beans.DataBeanManager.activate(itemList, request);
       
       String               orderCurrency = "";
       BigDecimal       runningTotal = new BigDecimal(0.0);
       String              strRunningTotal = "";
       
       if (itemList != null) {
              for (int i=0; i<itemList.getResultSetSize(); i++) {
                     runningTotal = runningTotal.add(itemList.getOrderItemListData(i).getTotalProductInEntityType());
                     runningTotal = runningTotal.subtract(itemList.getOrderItemListData(i).getDiscount());
                     if (orderCurrency.equals("")) {
                            orderCurrency = itemList.getOrderItemListData(i).getCurrency();                     
                     }
              }
       }
       
       strRunningTotal = getFormattedAmount(runningTotal, orderCurrency, new Integer(langId), storeId.toString());
       
       int totalsize = 0;
       int totalpage = 0;
       
       if (itemList != null && itemList.getResultSetSize() != 0) {
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

<title><%= orderMgmtNLS.get("productsPage") %></title>

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
var changesOccured = 'false';
function savePanelData() {
       parent.parent.put("notifyMerchant", "1");
       parent.parent.put("notifyShopper", "1");
       parent.parent.put("notifyOrderSubmitted", "1");
       parent.parent.put("callPrepareRequired", "true");       
       //Support For Customers,Shopping Under Multiple Accounts. 
	   var selOrgId = document.itemListForm.orgId.options[document.itemListForm.orgId.selectedIndex].value;
       var selOrgIdName = document.itemListForm.orgId.options[document.itemListForm.orgId.selectedIndex].text;
       parent.parent.put("selectedOrg",selOrgId);
       top.put("selectedOrgName", selOrgIdName);
       top.put("selectedOrg",selOrgId);
       saveOrderItemsChanges();
       
       var authToken = parent.parent.get("authToken");
       if (defined(authToken)) {
		parent.parent.addURLParameter("authToken", authToken);
       }
       
}// END savePanelData()


function validatePanelData() { 
       
       if (get1stOrderId() == "" || "<%=totalsize%>" == "0") {
              alertDialog("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("itemsMustBeSelectedMsg")) %>");
              return false
       }
       
	
       if (!isDiscountCurrencyValid) {
	      return false;
       }
       
       
       if (isAnyChange) {
              parent.parent.put("preCommand", "/webapp/wcs/tools/servlet/CSROrderItemUpdate");
              addCmdToPreCmdChain("CSROrderItemUpdate");
       }       

       return true;
}

function validateNoteBookPanel() {
       return validatePanelData();

}


function onLoad() {
       parent.loadFrames();       
       loadPanelData();
       //getOrgName();
}

function getResultsSize() {
        return <%=totalsize%>;
}

//---------------------------------------------------------------------
//  user defined javascript functions 
//---------------------------------------------------------------------
function debugAlert(msg) {
//       alert("DEBUG: " + msg);
}

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

orderItemsWithPA = new Object();
orderItemsEditable = new Object();

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
function getCustomerId() {
       var rc = "<%=customerId%>";
   if (rc == "null") rc = "";
       return rc;
}

// Clean up the chains of pre commands in the XML
function removePreCmdChain() {
       parent.parent.remove("preCmdChain");
}

// Add the name of the command (url name) to the pre command chains
function addCmdToPreCmdChain(cmdName) {
       var preCmdChain = parent.parent.get("preCmdChain");       
       
       if (!defined(preCmdChain)) {
              var preCmdChain = new Object();
              parent.parent.put("preCmdChain", preCmdChain);
       }       
       
       var preCmd = new Object();
       updateEntry(preCmdChain, "preCommand", preCmd);
       
       updateEntry(preCmd, "name", cmdName);
       
}



function loadPanelData() {
       
       // remove preCommand in XML when this page loaded
       var preCommand = parent.parent.get("preCommand");
       if (defined(preCommand) && preCommand != "") {
              parent.parent.remove("preCommand");
       }

       // Clean up the chains of pre commands in the XML when this page is loaded
       removePreCmdChain();

       parent.parent.remove("orderItem");
       parent.parent.remove("deletedOrderItem");
       if (get1stOrderId() != "") {
              var firstOrder = order["firstOrder"];
              if (!defined(firstOrder)) {
                     var firstOrder = new Object();
                     updateEntry(firstOrder, "id", get1stOrderId());
                     updateEntry(order, "firstOrder", firstOrder);
              } else {
                     updateEntry(firstOrder, "id", get1stOrderId());
              }
       }
       if (getCustomerId() != "") {
              updateEntry(order, "customerId", getCustomerId());
       }
       
       if (parent.parent.setContentFrameLoaded) {
              parent.parent.setContentFrameLoaded(true);
       }
       
       document.itemListForm.updateBtn.disabled = true;
}

//
// Add Product action                   
//
function addItems() {        
       var customerId = getCustomerId();
       if (customerId == null || customerId == "") {
              customerId = order["customerId"];
       }

       // if inside merchant center
       if (parent.parent.isInsideMC()) {    

              // save parent.parent "model" to TOP frame before calling 2nd wizard
              top.saveModel(parent.parent.model);

              // set returning panel to be current panel
              top.setReturningPanel(parent.parent.getCurrentPanelAttribute("name"));

              savePanelData();
              
              if (isAnyChange) {
                     // If user has made update to the qty, need to call the update cmd first
                     parent.parent.setContentFrameLoaded(false);
                     var xmlObject = parent.parent.modelToXML("XML");
                     debugAlert(xmlObject);
                     document.callActionForm.action="CSROrderItemUpdate";
                     document.callActionForm.XML.value=xmlObject;
                     document.callActionForm.URL.value="/webapp/wcs/tools/servlet/OrderItemAddRedirectB2B";
                     document.callActionForm.submit();                     

              
              
              } else {
                     
                     // launch add products 
                     top.setContent("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("addProductsTrail")) %>", 
                     "/webapp/wcs/tools/servlet/DialogView?XMLFile=order.orderProductSearchDialogB2B&customerId="+ customerId, true);
              }
              
       } else {
              alertDialog("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("addProductWizardChaining")) %>");
       }
}

// Added by fengtao **********************************
//
// Quick Add Products action                   
//
function quickAddItems() {        
       var customerId = getCustomerId();
       if (customerId == null || customerId == "") {
              customerId = order["customerId"];
       }
       var selOrgId = document.itemListForm.orgId.options[document.itemListForm.orgId.selectedIndex].value;

       // if inside merchant center
       if (parent.parent.isInsideMC()) {    

              // save parent.parent "model" to TOP frame before calling 2nd wizard
              top.saveModel(parent.parent.model);

              // set returning panel to be current panel
              top.setReturningPanel(parent.parent.getCurrentPanelAttribute("name"));

              savePanelData();
              
              if (isAnyChange) {
                     // If user has made update to the qty, need to call the update cmd first
                     parent.parent.setContentFrameLoaded(false);
                     var xmlObject = parent.parent.modelToXML("XML");
                     debugAlert(xmlObject);
                     document.callActionForm.action="CSROrderItemUpdate";
                     document.callActionForm.XML.value=xmlObject;
                     document.callActionForm.URL.value="/webapp/wcs/tools/servlet/OrderItemAddRedirectB2B";
                     document.callActionForm.submit();                     

              
              
              } else {
                     
                     // launch quick add products 
                     top.setContent("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("quickAdd")) %>", 
                     "/webapp/wcs/tools/servlet/DialogView?XMLFile=order.orderQuickAddDialogB2B&customerId="+ customerId+"&activeOrganizationId="+ selOrgId, true);
              }
              
       } else {
              alertDialog("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("addProductWizardChaining")) %>");
       }
}


//
// New Add Product action                   
//
function newAddItems() {        
       var customerId = getCustomerId();
       if (customerId == null || customerId == "") {
              customerId = order["customerId"];
       }
       
       var selOrgId = document.itemListForm.orgId.options[document.itemListForm.orgId.selectedIndex].value;   

       // if inside merchant center
       if (parent.parent.isInsideMC()) {    

              // save parent.parent "model" to TOP frame before calling 2nd wizard
              top.saveModel(parent.parent.model);

              // set returning panel to be current panel
              top.setReturningPanel(parent.parent.getCurrentPanelAttribute("name"));

              savePanelData();
              
              if (isAnyChange) {
                     // If user has made update to the qty, need to call the update cmd first
                     parent.parent.setContentFrameLoaded(false);
                     var xmlObject = parent.parent.modelToXML("XML");
                     debugAlert(xmlObject);
                     document.callActionForm.action="CSROrderItemUpdate";
                     document.callActionForm.XML.value=xmlObject;
                     document.callActionForm.URL.value="/webapp/wcs/tools/servlet/OrderItemAddRedirectB2B";
                     document.callActionForm.submit();                     

              
              
              } else {
                        
                     // launch add products 
                     top.setContent("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("newAddProducts")) %>", 
                     "/webapp/wcs/tools/servlet/DialogView?XMLFile=order.orderAddProductSearchDialogB2B&customerId="+ customerId + "&activeOrganizationId="+ selOrgId, true);
              }
              
       } else {
              alertDialog("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("addProductWizardChaining")) %>");
       }
}


//****************************************************

//
// Remove Product action                   
//
function removeItems() {
       checkedItems = parent.getChecked();
       if (checkedItems.length > 0 && isButtonDisabled(parent.buttons.buttonForm.removeProductsButton) == false) {
       
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
                            debugAlert(xmlObject);
                            document.callActionForm.action="CSROrderItemDelete";
                            document.callActionForm.XML.value=xmlObject;
                            document.callActionForm.URL.value="/webapp/wcs/tools/servlet/OrderItemsPageB2B?ActionXMLFile=order.orderItemsPageB2B&cmd=OrderItemsPageB2B&listsize=15&startindex=0&firstOrderId="+get1stOrderId()+"&secondOrderId="+get2ndOrderId()+"&customerId="+"<%=customerId%>";
                            document.callActionForm.submit();
                     }
                     
              } else {
                     alertDialog("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("noItemsSelected")) %>");
              }
           }
       }
}


function getViewPABCT() {
       return '<%=UIUtil.toJavaScript((String)orderLabels.get("pAttributesTitle"))%>';
}

function viewPAttributes() {
       var orderItemId = parent.getChecked();
       
       if (orderItemId.length > 0 && isButtonDisabled(parent.buttons.buttonForm.viewPAttributesButton) == false) {
              top.setContent(getViewPABCT(),'/webapp/wcs/tools/servlet/DialogView?XMLFile=order.orderItemPAttributes&amp;orderItemId='+orderItemId,true);
       }
}


//
function saveOrderItemsChanges()
{
       // get the payment&billing information of the firstOrder
       var order = parent.parent.get("order");
       var prevFirstOrder = order["firstOrder"];
       if ( defined(prevFirstOrder) ) {
          var payment = prevFirstOrder["payment"];
          var billingAddressId = prevFirstOrder["billingAddressId"];
       }
       
       // stub code to set orderId to an existing order
       var firstOrder = prevFirstOrder;
       if (defined(prevFirstOrder)){
          firstOrder = prevFirstOrder;
       }else{
       		firstOrder = new Object();
       	}
       updateEntry(firstOrder, "id", get1stOrderId());
       
       if ( defined(prevFirstOrder) && defined(payment) )
          updateEntry(firstOrder, "payment", payment);
       if ( defined(prevFirstOrder) && defined(billingAddressId) )
          updateEntry(firstOrder, "billingAddressId", billingAddressId);
          
       updateEntry(order, "firstOrder", firstOrder);
       
       var items = new Vector();
       var checkedItems = new Array;
       checkedItems = parent.getChecked();
       
       parent.parent.remove("orderItem", items);
       
       for (var i=0; i<itemListForm.length; i++) {
              var currentElement = itemListForm.elements[i];
              if ((currentElement.type == "checkbox") && (currentElement.name != "select_deselect")) {
                         var orgQuantity = document.itemListForm["OrgQuantity_"+currentElement.name].value;
                         var quantity       = document.itemListForm["Quantity_"+currentElement.name].value;
                         var sku              = document.itemListForm["SKU_"+currentElement.name].value;
                         var tradingId   = document.itemListForm["TradingId_"+currentElement.name].value;
                         var orderId       = document.itemListForm["OrderId_"+currentElement.name].value;
                         var orgDiscount = document.itemListForm["OrgDiscount_"+currentElement.name].value;
                         var discount = document.itemListForm["Discount_"+currentElement.name].value;

                         var numOrgQty = parent.parent.strToNumber(orgQuantity, <%=langId%>);
                         var numNewQty = parent.parent.strToNumber(quantity, <%=langId%>);
                         if ((numOrgQty != numNewQty) || (orgDiscount != currencyToNumber(discount,"<%=orderCurrency.toString()%>", <%=langId%>))) {
                            anItem = new Object();
                            anItem.orderItemId       = currentElement.name;
                            anItem.quantity              = quantity;
                            anItem.tradingId        = tradingId;
                            anItem.orderId              = orderId;
                            
                            if (numOrgQty != numNewQty) {
                                   if (!validateQuantity(anItem.quantity, sku)) {
                                          document.itemListForm["Quantity_"+currentElement.name].focus();
                                          return null;
                                   }
                            
                                   anItem.quantity = numNewQty;
                            
                            }
                            
                            //if (orgDiscount != discount) {
                            if (orgDiscount != currencyToNumber(discount,"<%=orderCurrency.toString()%>", <%=langId%>)) {
                            
	                           if (!validateDiscount(discount, sku)) {
	                              document.itemListForm["Discount_"+currentElement.name].focus();
	                              return null;
	                           }                           
                                  
                                   //anItem.discount            = discount;
                            	   anItem.discount              = currencyToNumber(discount,"<%=orderCurrency.toString()%>", <%=langId%>);
                            }
                                   
                            addElement(anItem, items);
                     }
              }
              
              if (items != null && items.size() > 0) {
                     parent.parent.put("orderItem", items);
              }
       }
       
	     
       //if flow achieve here, discount currency is valid.
       isDiscountCurrencyValid = true;
	       
       
       for (var i=0; i<checkedItems.length; i++) {
              parent.removeEntry(checkedItems[i]);
       }
       
       return items;
}


//
// Recalculate action - update order items quantity and shipmode               
//   
function recalculate() {
       debugAlert(parent.getChecked().toString());
       // stub code to set orderId to an existing order
       var items = new Vector();
                     
       items = saveOrderItemsChanges();

       if (isAnyChange) {
           if (items != null && items.size() > 0) {
              parent.parent.setContentFrameLoaded(false);
              var xmlObject = parent.parent.modelToXML("XML");
              debugAlert(xmlObject);
              document.callActionForm.action="CSROrderItemUpdate";
              document.callActionForm.XML.value=xmlObject;
              document.callActionForm.URL.value="/webapp/wcs/tools/servlet/OrderItemsPageB2B?ActionXMLFile=order.orderItemsPageB2B&cmd=OrderItemsPageB2B&listsize=15&startindex=0&firstOrderId="+get1stOrderId()+"&secondOrderId="+get2ndOrderId()+"&customerId="+"<%=customerId%>";
              document.callActionForm.submit();       
           }
       } else {
              alertDialog("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("noChange")) %>");
       }
}


//
//  Boolean flag for quantity update
//
isAnyChange = false;
function setAnyChange() {
       isAnyChange = true;
}

//setAnyChange2 entered via any change to any DISCOUNT ITEM price field

function setAnyChange2(index)
{
     
       isAnyChange = true;       
    
       for (var i=0; i<itemListForm.length; i++) {
              var currentElement = itemListForm.elements[i];
              if ((currentElement.type == "checkbox") && (currentElement.name != "select_deselect")) {
                 
                         var discount = document.itemListForm["Discount_"+currentElement.name].value;
                         
                         var sku      = document.itemListForm["SKU_"+currentElement.name].value;
                         
                if (discount != "") { 
                    
                       var validCurrencyInput = isValidCurrency(discount, "<%=orderCurrency.toString()%>", <%=langId%>);                      
                       if (!validCurrencyInput) {
                         
  	                alertDialog("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("invalidDiscountCurrencyMsg")) %>".replace(/%1/, sku));
  	                isDiscountCurrencyValid = false;
  	                document.itemListForm["Discount_"+currentElement.name].focus();
                         
                       } else {
                            //num2cur = numberToCurrency(discount, "<%=orderCurrency.toString()%>", <%=langId%>); 
                            num2cur = numberToCurrency(currencyToNumber(discount,"<%=orderCurrency.toString()%>", <%=langId%>), "<%=orderCurrency.toString()%>", <%=langId%>);           
                            document.itemListForm["Discount_"+currentElement.name].value = num2cur;
                       }          
               } 
           } //end of top if
   } //end of for
} //end of function
// End of setAnyChange2 - provides discount price edits       

function enableUpdate() {
       document.itemListForm.updateBtn.disabled = false;
}

//
//  Validate the Quantity field in the list
//
function validateQuantity(element, sku) {
       var number = parent.parent.strToNumber(element, <%=langId%>);
       if (number.toString() == "NaN") {
              alertDialog("<%=UIUtil.toJavaScript((String)orderMgmtNLS.get("invalidQuantityMsg"))%>".replace(/%1/, sku));
              return false;
       }
               
       if(number < 0) {
              alertDialog("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("quantityMustBeGreaterMsg")) %>".replace(/%1/, sku));
              return false;
       }
       
       return true;
}


//
//  Boolean flag for Discount currency format error
//
var isDiscountCurrencyValid = true;

//
//  Validate the Discount field in the list 
//
function validateDiscount(element, sku) {
      var currencySelect = "<%=orderCurrency.toString()%>"; 
      var slangId = <%=langId%>; 	
      var validCurrencyInput = isValidCurrency(element, currencySelect, slangId);
      
      if (!validCurrencyInput) {
         alertDialog("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("invalidDiscountCurrencyMsg")) %>".replace(/%1/, sku));
         isDiscountCurrencyValid = false;
         return false;
      } 
      
      return true;     
}


function selectAllButtons() {
       parent.selectDeselectAll();
       checkButtons();
}

function checkButtons() {
       var checked = parent.getChecked();
       //disable not editable item.
       
       for (var i=0; i<checked.length; i++) {
       		if ( !defined(orderItemsEditable[checked[i]]) ) {
              if (isButtonDisabled(parent.buttons.buttonForm.removeProductsButton) == false) {
                     disableButton(parent.buttons.buttonForm.removeProductsButton);                    
              }           
       	  }
       }
       
       if (checked.length == 0) {
              if (isButtonDisabled(parent.buttons.buttonForm.removeProductsButton) == false) {
                     disableButton(parent.buttons.buttonForm.removeProductsButton);
              }
              if (isButtonDisabled(parent.buttons.buttonForm.viewPAttributesButton) == false) {
                     disableButton(parent.buttons.buttonForm.viewPAttributesButton);
              }
       } else if (checked.length == 1) {
              if ( !defined(orderItemsWithPA[checked[0]]) ) {       
                     if (isButtonDisabled(parent.buttons.buttonForm.viewPAttributesButton) == false) {
                            disableButton(parent.buttons.buttonForm.viewPAttributesButton);
                     }
              }
       } else {
              if (isButtonDisabled(parent.buttons.buttonForm.viewPAttributesButton) == false) {
                     disableButton(parent.buttons.buttonForm.viewPAttributesButton);
              }
       }
}
                        

function disableButton(b) {
       if (defined(b)) {
              b.disabled= true;
              b.className='disabled';
              b.id='disabled';
       }
}

function isButtonDisabled(b) {
       if (b.className =='disabled' &&       b.id == 'disabled')
              return true;
       return false;
}
//Support For Customers,Shopping Under Multiple Accounts. 
function setSelectedOrgName(){
	var getSelOrgId = parent.parent.get("selectedOrg");
	if(getSelOrgId !=undefined){
		document.itemListForm.orgId.value=getSelOrgId;
	}
	var listSize="<%=totalsize%>"
	if(listSize>0){
		document.itemListForm.orgId.disabled=true;
	}else {
		document.itemListForm.orgId.disabled=false;
	}	
}
//[[>-->
function func_1(thisObj, thisEvent) {
//use 'thisObj' to refer directly to this component instead of keyword 'this'
//use 'thisEvent' to refer to the event generated instead of keyword 'event'

}

function func_2(thisObj, thisEvent) {
//use 'thisObj' to refer directly to this component instead of keyword 'this'
//use 'thisEvent' to refer to the event generated instead of keyword 'event'
setOrgName
}</script>

</head>
<body class="content">
<form name="itemListForm" onclick="return func_1(this, event);"><%StringBuffer curStr = new StringBuffer();
       if (!orderCurrency.equals("")) {
              curStr.append("[");
              curStr.append(orderCurrency);
              curStr.append("]");
}%> <input type='hidden' name='orgnameVal' value="" />
       
<table border="0" cellpadding="0" cellspacing="0" width="400">
	<tr>
		<!--List Box for Organization selection -->
	<td><label for="orgId"><%=UIUtil.toHTML((String) orderAddProducts.get("activeOrganization"))%></label>
		<%=generateOrganizationsLB(selOrgId,customerId,request)%>
	</td>

	</tr>
</table>
<br />
<div align="right"><%=orderMgmtNLS.get("subTotal")%> <%=curStr.toString()%> : <%=strRunningTotal%>
&nbsp;&nbsp;
<button type="button" id="contentButton" name="updateBtn" onclick="recalculate();"><%=UIUtil.toHTML(orderMgmtNLS.get("updateQty").toString())%></button>
</div>
<br>
<script>setSelectedOrgName();</script> <%=comm.startDlistTable((String) orderLabels.get("CSOrderListTableSummary"))%>
<%=comm.startDlistRowHeading()%> 
              <%= comm.addDlistCheckHeading(true, "selectAllButtons()") %>
<%=comm.addDlistColumnHeading((String) orderMgmtNLS.get("itemName"), "productName", orderByParam.equals("productName"))%>
<%=comm.addDlistColumnHeading((String) orderMgmtNLS.get("itemNumber"), null, false)%> 
<%=comm.addDlistColumnHeading((String) orderMgmtNLS.get("itemQuantity"),null,false)%>
<%=comm.addDlistColumnHeading((String) orderMgmtNLS.get("itemContractName"), null, false)%> 
<%=comm.addDlistColumnHeading((String) orderMgmtNLS.get("orderItemLevelDiscount"), null, false)%>
<%=comm.addDlistColumnHeading((String) orderMgmtNLS.get("itemPrice"), null, false)%>
<%=comm.addDlistColumnHeading((String) orderMgmtNLS.get("itemShippingDate"), "shipDate",orderByParam.equals("shipDate"))%>
<%=comm.endDlistRow()%>
 <%if (totalsize != 0) {
	//if (endIndex > itemList.length) {
	endIndex = itemList.getResultSetSize();
	
	//}
} else {
	endIndex = 0;
}
//TABLE CONTENT
int indexFrom = startIndex;
StringBuffer aStrBuffer = null;
StringBuffer aStrBuffer1 = null;
for (int i = indexFrom; i < endIndex; i++) {%> 
<%=comm.startDlistRow(rowselect)%>
                     <%= comm.addDlistCheck(itemList.getOrderItemListData(i).getOrderItemId(), "parent.setChecked();checkButtons();") %>
<script>
                     <%
                     if (itemList.getOrderItemListData(i).getOrderItemBean().hasPAttributes()) {
                     %>
                            orderItemsWithPA["<%=itemList.getOrderItemListData(i).getOrderItemId()%>"] = true;
                     <%
                     }
                     boolean isEditable = itemList.getOrderItemListData(i).getOrderItemBean().isEditable();
                  boolean isFree = itemList.getOrderItemListData(i).getOrderItemBean().isFree();
                     if(isEditable){                         
                     %>
                     		 orderItemsEditable["<%= itemList.getOrderItemListData(i).getOrderItemId() %>"] = true;
                     <%
                     }
                     %>
             </script>
                     
       <%=comm.addDlistColumn(getOrderItemName(	itemList.getOrderItemListData(i).getCatalogEntryId(),request),"none")%> 
       <%=comm.addDlistColumn(itemList.getOrderItemListData(i).getSKU(), "none")%>

<input type="hidden" name="SKU_<%=UIUtil.toHTML(itemList.getOrderItemListData(i).getOrderItemId())%>" 	value="<%=UIUtil.toHTML(itemList.getOrderItemListData(i).getSKU())%>" />
<%
aStrBuffer = new StringBuffer();
aStrBuffer.append("<label for='quantity");
aStrBuffer.append(i);
aStrBuffer.append("'/>");
			if(isEditable && !isFree){	
                     	    aStrBuffer.append("<input type='text' maxlength='10' name='Quantity_");
                     		aStrBuffer.append(itemList.getOrderItemListData(i).getOrderItemId());
                            aStrBuffer.append("' size='3' align='right' onChange='setAnyChange();' onKeyUp='enableUpdate();' value='");
                            aStrBuffer.append(getFormattedQuantity(itemList.getOrderItemListData(i).getQuantityInEntityType().doubleValue(), jLocale));
                       }else{
                            aStrBuffer.append("<input type='text'disabled='disabled' maxlength='10' name='Quantity_");
                     		aStrBuffer.append(itemList.getOrderItemListData(i).getOrderItemId());
                            aStrBuffer.append("' size='3' align='right' value='");
                            aStrBuffer.append(getFormattedQuantity(itemList.getOrderItemListData(i).getQuantityInEntityType().doubleValue(), jLocale));
                     }
                     aStrBuffer.append("' id='quantity");
                     aStrBuffer.append(i);
                     aStrBuffer.append("' >");
                     %>
                     <%= comm.addDlistColumn(aStrBuffer.toString(), "none") %>

<input type="hidden"
	name="OrgQuantity_<%=itemList.getOrderItemListData(i).getOrderItemId()%>"
	value="<%=itemList.getOrderItemListData(i).getQuantity()%>" /> <input
	type="hidden"
	name="OrderId_<%=itemList.getOrderItemListData(i).getOrderItemId()%>"
	value="<%=itemList.getOrderItemListData(i).getOrderId()%>" /> <input
	type="hidden"
	name="OrgDiscount_<%=itemList.getOrderItemListData(i).getOrderItemId()%>"
	value="<%=itemList.getOrderItemListData(i).getDiscount()%>" /> <%=comm.addDlistColumn(
	getContractName(itemList.getOrderItemListData(i).getContractId(), request),
	"none")%> <input type="hidden"
	name="TradingId_<%=itemList.getOrderItemListData(i).getOrderItemId()%>"
	value="<%=itemList.getOrderItemListData(i).getContractId()%>" /> 
	
	<%
                                   
	aStrBuffer1 = new StringBuffer();
	aStrBuffer1.append("<label for='discount");
	aStrBuffer1.append(i);
	aStrBuffer1.append("'/>");
			if(isEditable && !isFree){		
                     	aStrBuffer1.append("<input type='text' maxlength='10' name='Discount_");
                     	aStrBuffer1.append(itemList.getOrderItemListData(i).getOrderItemId());
                    	aStrBuffer1.append("' size='8' align='right' onChange='setAnyChange2(");
                     	aStrBuffer1.append(itemList.getOrderItemListData(i).getOrderItemId());
                    	aStrBuffer1.append(");'onKeyUp='enableUpdate();' value='");
                     	aStrBuffer1.append(getFormattedAmount(itemList.getOrderItemListData(i).getDiscount(),orderCurrency, new Integer(langId), storeId.toString()));              
                     }else{
                     	aStrBuffer1.append("<input type='text' disabled='disabled'  maxlength='10' name='Discount_");
                     	aStrBuffer1.append(itemList.getOrderItemListData(i).getOrderItemId());
                    	aStrBuffer1.append("' size='8' align='right' value='");  	
                    	aStrBuffer1.append(getFormattedAmount(itemList.getOrderItemListData(i).getDiscount(),orderCurrency, new Integer(langId), storeId.toString()));              
                         //aStrBuffer1.append(getFormattedAmount(itemList.getOrderItemListData(i).getDiscount(),orderCurrency, new Integer(langId), storeId.toString()));              
                     }
                     aStrBuffer1.append("' id='discount");
                     aStrBuffer1.append(i);
                     aStrBuffer1.append("' >");
                     %>
 <%=comm.addDlistColumn(aStrBuffer1.toString(), "none")%>

<%=comm.addDlistColumn(	getFormattedAmount(itemList.getOrderItemListData(i).getPriceInEntityType(),orderCurrency,	new Integer(langId),storeId.toString()),"none")%> 
<%if (itemList.getOrderItemListData(i).getEstimatedAvailableTimeInEntityType()!= null) {
	String estimatedShipDate = TimestampHelper.getDateFromTimestamp(itemList.getOrderItemListData(i).getEstimatedAvailableTimeInEntityType(),jLocale);%> 
<%=comm.addDlistColumn(estimatedShipDate, "none")%> 
<%} else {%>
<%=comm.addDlistColumn("", "none")%> <%}%> 
<%=comm.endDlistRow()%>

 <%if (rowselect == 1) {
	rowselect = 2;
} else {
	rowselect = 1;
}
}%> <%=comm.endDlistTable()%> 
<%if (itemList == null) {
%>

<p></p>
<p></p>
<table cellspacing="0" cellpadding="3" border="0">
	<tr>
		<td colspan="7"><%=orderMgmtNLS.get("noItemToList")%></td>
	</tr>
</table>
<%}
%></form>

<form name="callActionForm" action="" method="post"><input type="hidden"
	name="XML" value="" /> <input type="hidden" name="URL" value="" /></form>

<script type="text/javascript">
parent.afterLoads();
parent.setResultssize(getResultsSize());

//For IE
if (document.all) {
	onLoad();
}

// Override the refresh button method to expand the width of buttons for multiple language purpose
parent.AdjustRefreshButton = function (butName, classStyle) {
	if (butName && classStyle) {
		butName.className = classStyle;
		if (classStyle.toLowerCase() == "disabled") {
			butName.disabled = true;
		}
		else {
			butName.disabled = false;
		}
	}
	butName.style.width = "150px";
}
</script>

</body>
</html>

