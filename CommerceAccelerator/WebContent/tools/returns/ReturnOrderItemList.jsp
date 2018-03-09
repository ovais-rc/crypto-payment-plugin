

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<HTML lang="en">
<!--
-->

<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>

<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.optools.returns.beans.OrderItemSearchCriteriaBean" %>
<%@ page import="com.ibm.commerce.catalog.beans.CatalogEntryDataBean" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.CatalogEntryDescriptionDataBean" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.order.beans.OrderItemDataBean" %>
<%@ page import="com.ibm.commerce.tools.optools.order.beans.OrderItemListDataBean" %>
<%@ page import="com.ibm.commerce.tools.optools.order.beans.CSROrderItemDataBean" %>
<%@ page import="com.ibm.commerce.common.beans.StoreDataBean" %>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@ page import="com.ibm.commerce.price.beans.FormattedMonetaryAmountDataBean" %>
<%@ page import="com.ibm.commerce.price.beans.FormattedQuantityAmountDataBean" %>
<%@ page import="com.ibm.commerce.price.utils.MonetaryAmount" %>
<%@ page import="com.ibm.commerce.price.utils.QuantityAmount" %>
<%@ page import="com.ibm.commerce.contract.beans.ContractDataBean" %>
<%@include file="../common/common.jsp" %>
<%@include file="../common/NumberFormat.jsp" %>
  
    <HEAD>
      <SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

      <%
      try {
        CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
        Locale jLocale = cmdContext.getLocale();
      	Hashtable returnsNLS = (Hashtable)ResourceDirectory.lookup("returns.ReturnsNLS", jLocale);
      	Hashtable orderMgmtNLS 	= (Hashtable)ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);
   	Hashtable orderLabels 	= (Hashtable)ResourceDirectory.lookup("order.orderLabels", jLocale);	


      %>
      
      <link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css"> 
      
      <TITLE><%= UIUtil.toHTML((String)returnsNLS.get("orderItemSearchResultsListTitle")) %></TITLE>

      <%
            
      String jStoreID = cmdContext.getStoreId().toString();
      String jLanguageID = cmdContext.getLanguageId().toString();
      String jLocaleID = cmdContext.getLocale().toString();

      JSPHelper jspHelper = new JSPHelper(request);
      String orderIdsStr = jspHelper.getParameter("searchOrderNumber");
   
   Vector orderIdsVec = new Vector();
   String[] orderIds;
   if ( orderIdsStr == null || orderIdsStr.equals("") ) {
   	orderIds = null;
   } else {
   	StringTokenizer st = new StringTokenizer(orderIdsStr, ",");
   	while (st.hasMoreTokens()) {
   		orderIdsVec.addElement(st.nextToken());
   	}
   	orderIds = new String[orderIdsVec.size()];
   	orderIdsVec.copyInto(orderIds);
   }

	OrderItemListDataBean orderItemListDB = new OrderItemListDataBean();
	orderItemListDB.setLangId(jLanguageID);
	orderItemListDB.setLogonId(jspHelper.getParameter("searchCustomerLogonId"));
	orderItemListDB.setOrderBy("");
	orderItemListDB.setOrders(orderIds);
	orderItemListDB.setAccountId(jspHelper.getParameter("searchAccountId"));
	com.ibm.commerce.beans.DataBeanManager.activate(orderItemListDB, request);
	CSROrderItemDataBean[] orderItemListArray = null;
	if (orderItemListDB.getResultSetSize() != 0)
		orderItemListArray = orderItemListDB.getOrderItemList();

	StoreDataBean store = new StoreDataBean();
	store.setStoreId(jStoreID);
	com.ibm.commerce.beans.DataBeanManager.activate(store, request);
	boolean isB2B = store.getStoreType() != null && (store.getStoreType().equals("B2B") || store.getStoreType().equals("BRH") || store.getStoreType().equals("BMH"));
      %>

      <SCRIPT>

        var storeID = "<%= jStoreID %>";
        var languageID = "<%= jLanguageID %>";

        function onLoad()
        {
          parent.loadFrames();
        }

        function getRefNum()
        {
          return parent.getChecked();
        }

        function getResultsSize(){
            return <%=orderItemListDB.getResultSetSize()%>;
            //return <%//=orderItemDynamicList.getTotalSize().intValue()%>;
        }


        
        function getLang() {
            return languageID;
        }
        
        function getStore() {
            return storeID;
        }
        
	function createReturnItems()
	{
   	   var selectedItemsHashTable = parent.parent.get("selectedItems");

	   // validate quantity values and order item status
   	   for (var i in selectedItemsHashTable) {
   	      var x = getSelectedItemData(selectedItemsHashTable[i].orderItemId);
   	      if (x != null) {
   	         //verify that the order item status is returnable
   	         if ( x.orderItemStatus != "S" && x.orderItemStatus != "D" ) {
   	         	alertDialog("<%=UIUtil.toJavaScript((String)orderLabels.get("invalidSelectionForReturn"))%>");
   	         	return;
   	         }
   	         
   	         //validate quantity
   	         if ( validateQuantity(x.returnQuantity) == false ) {
   	            var formRef = document.OrderItemSearchResultsList;
	            formRef["Quantity"+x.orderItemId].focus();
   	            return;
   	         } else {
   	            //save the number
   	            selectedItemsHashTable[i].returnQuantity = strToNumber(selectedItemsHashTable[i].returnQuantity, languageID);
   	         }
   	      }
   	   }

	   // remove the null objects from the selectedItemsHashtable	      	   
           var returnItems = new Array();

	   var j = 0;
   	   for (var i in selectedItemsHashTable) {
   	      var x = getSelectedItemData(selectedItemsHashTable[i].orderItemId);
   	      if ( x != null ) {
   	         returnItems[j] = x;
   	         j++;
   	      }
   	   }
   	   
   	   if (j <= 0) { 
		alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("noItemsSelected")) %>");
           	return;
   	   }

           parent.parent.remove("selectedItems");
	   parent.parent.put("addReturnItem", returnItems);
	  
	   document.createReturnItemsForm.XML.value = parent.parent.modelToXML("XML");
	   document.createReturnItemsForm.URL.value = "ReturnItemListRedirect?quantity*=&reason*=&orderItemId*=";
	   document.createReturnItemsForm.submit();        
	}        

	function SelectedItem(orderItemId, returnQuantity, customerId, status)
	{
	   this.orderItemId = orderItemId;
	   this.returnQuantity = returnQuantity;
	   this.customerId = customerId;
	   this.orderItemStatus = status;
	}

	function validateQuantity(element) 
	{
		var number = strToNumber(element, languageID);

	   	if (number.toString() == "NaN") 
	   	{
			alertDialog("<%= UIUtil.toJavaScript( (String)returnsNLS.get("ProductsInvalidQuantityMsg")) %>");
			return false;
		}
	        
		if(number <= 0) 
		{
			alertDialog("<%= UIUtil.toJavaScript( (String)returnsNLS.get("ProductsQuantityMustBeGreaterMsg")) %>");
			return false;
		}
		return true;
	}

	function getSelectedItemData(orderItemId)
	{
	   var formRef = document.OrderItemSearchResultsList;
   
	   var quantity = formRef["Quantity"+orderItemId].value;
	   var customerId = formRef["CustomerId"+orderItemId].value;
	   var status = top.getData("orderItemStatus"+orderItemId, 0);
	   var selItem = new SelectedItem(orderItemId, quantity, customerId, status);
	   return selItem;
	}

	function clickCheckBoxAction(orderItemId)
	{
	   selectedItemsHashTable = parent.parent.get("selectedItems");
	   if (selectedItemsHashTable == null)
	   	selectedItemsHashTable = new Object();

	   var selectedItem = getSelectedItemData(orderItemId);
	   
	   if ( selectedItem.returnQuantity != null && selectedItem.returnQuantity != "" ) {
	        validateQuantity(selectedItem.returnQuantity);

	   	// add item to hash table
	   	selectedItemsHashTable["OrderItemId_" + orderItemId] = selectedItem;
	         
	   	// if customer id is not set in model set it.
	   	var customerIdInModel = parent.parent.get("customerId");
	   	if (customerIdInModel == null || customerIdInModel == "")
	   		parent.parent.put("customerId", selectedItem.customerId);
	   } else {
	   	if ( defined(selectedItemsHashTable["OrderItemId_" + orderItemId]) ) {
	   		selectedItemsHashTable["OrderItemId_" + orderItemId] = null;
	   		selectedItemsHashTable = selectedItemsHashTable;
	   	}
	   }
	   parent.parent.put("selectedItems", selectedItemsHashTable);
	}
	
	
	function executeOnLoad()
	{
           var returnWizardModel = top.getModel(1);
		
	   // retrieve all relavent data
	   var returnId = returnWizardModel.returnId;
	   var customerId = returnWizardModel.customerId;
	   
	   // store data in page data in model
	   parent.parent.put("returnId",returnId);
	   parent.parent.put("customerId", customerId);
	}
	
	
	function writeNumber ( number )
	{
		document.writeln( strToNumber(number,"<%= jLanguageID %>") );
	}

      </SCRIPT>
      <SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
    </HEAD>

    <BODY class="content_list" onload="executeOnLoad();">

	<P><%=(String)returnsNLS.get("orderItemSearchResultInstructions")%>

	<FORM NAME="createReturnItemsForm" METHOD="post" ACTION="CSRReturnItemAdd">
	   <INPUT TYPE='hidden' NAME="XML" VALUE=""> 
      	   <INPUT TYPE='hidden' NAME="URL" VALUE="">
	</FORM>
      <SCRIPT>
        <!--
        // For IE
        if (document.all) {
          onLoad();
        }
        //-->
      </SCRIPT>
<%
          int startIndex = Integer.parseInt(jspHelper.getParameter("startindex"));
          int listSize = Integer.parseInt(jspHelper.getParameter("listsize"));
          int endIndex = startIndex + listSize;
          int rowselect = 1;
	  int totalsize = orderItemListDB.getResultSetSize();
          int totalpage = totalsize/listSize;
%>
      <FORM NAME="OrderItemSearchResultsList">
        <%= comm.startDlistTable((String)returnsNLS.get("orderItemListTableSummary")) %>
        <%= comm.startDlistRowHeading() %>

        <%= comm.addDlistColumnHeading((String)returnsNLS.get("orderItemSearchResultHeading1"),null,false,null,false)%>
        <% if (isB2B) { %>
        	<%= comm.addDlistColumnHeading((String)returnsNLS.get("orderItemSearchResultHeadingContractName"),null,false,null,false)%>
        <% } %>
        <%= comm.addDlistColumnHeading((String)returnsNLS.get("orderItemSearchResultHeading2"),null,false,null,false)%>
        <%= comm.addDlistColumnHeading((String)returnsNLS.get("orderItemSearchResultHeading3"),null,false,null,false)%>
        <%= comm.addDlistColumnHeading((String)returnsNLS.get("orderItemSearchResultHeading4"),null,false,null,false)%>
        <%= comm.addDlistColumnHeading((String)returnsNLS.get("orderItemSearchResultHeading5"),null,false,null,false)%>
        <%= comm.addDlistColumnHeading((String)returnsNLS.get("orderItemSearchResultHeading6"),null,false,null,false)%>
        <%= comm.addDlistColumnHeading((String)returnsNLS.get("orderItemSearchResultHeading7"),null,false,null,false)%>

        <%= comm.endDlistRow() %>

   
          <%
          
          for (int i = 0; i < orderItemListDB.getResultSetSize(); i++)
          {
             OrderItemDataBean orderItem = new OrderItemDataBean(); 
             orderItem.setOrderItemId((String)orderItemListArray[i].getOrderItemId());
      	     com.ibm.commerce.beans.DataBeanManager.activate(orderItem, request);

	     String contractName = "";
	     String contractId = orderItem.getContractId();
	     if (contractId != null && !contractId.equals("")) {
	     	ContractDataBean contractDB = new ContractDataBean();
	     	contractDB.setInitKey_referenceNumber(contractId);
      	        com.ibm.commerce.beans.DataBeanManager.activate(contractDB, request);
	     	contractName = contractDB.getName();
	     }
	     
		CatalogEntryDataBean catEntry = new CatalogEntryDataBean();
		catEntry.setCatalogEntryID(orderItem.getCatalogEntryId());
		com.ibm.commerce.beans.DataBeanManager.activate(catEntry, request);
		CatalogEntryDescriptionDataBean catEntDesc = new CatalogEntryDescriptionDataBean();
		catEntDesc.setItemRefNum(catEntry.getCatalogEntryReferenceNumber());
		catEntDesc.setInitKey_language_id(jLanguageID);
		com.ibm.commerce.beans.DataBeanManager.activate(catEntDesc, request);

             String jName = catEntDesc.getName();
             if (jName == null)
             	jName = "";
             String jShortDescription = catEntDesc.getShortDescription();
             if (jShortDescription == null)
             	jShortDescription = "";
             
	     String currency = orderItem.getCurrency();
	     if (currency == null || currency.equals(""))
	     	currency = store.getCurrency();		

	     String amount = orderItem.getPrice();
	     if (amount == null )
	     	amount = "";
	     else
	     {
		FormattedMonetaryAmountDataBean formattedAmount =  new FormattedMonetaryAmountDataBean(	new MonetaryAmount( orderItem.getPriceInEntityType(), currency ), (StoreAccessBean) store, cmdContext.getLanguageId() );
		amount = formattedAmount.getPrimaryFormattedPrice().getFormattedValue().toString();
	     }
             
             String oItemId = orderItem.getOrderItemId();
          %>

	<%
	// disable or enable non-returnable order items
	if ( orderItem.getStatus().equals("S") || orderItem.getStatus().equals("D") ) {
	%>
        	<%= comm.startDlistRow(rowselect) %>
        	<%= comm.addDlistColumn( orderItem.getOrderId()+" <input type=\"hidden\" name=\"CustomerId" + oItemId + "\"" + "  value=" + "\"" + orderItem.getMemberId() + "\"" + ">","none" ) %>
		<SCRIPT>top.saveData("<%=orderItem.getStatus()%>","orderItemStatus<%=orderItem.getOrderItemId()%>");</SCRIPT>
		<% if (isB2B) { %>
        		<%= comm.addDlistColumn( contractName,"none" ) %>
        	<% } %>
        	<%= comm.addDlistColumn( jName,"none" ) %>
        	<%= comm.addDlistColumn( orderItem.getPartNumber(),"none" ) %>
		<%= comm.addDlistColumn("<input type=\"text\" maxlength=\"10\" size=\"6\" name=\"Quantity" + oItemId + "\"" + "onChange=clickCheckBoxAction(" + oItemId + ")" + " >", "none" ) %>
		<%
			FormattedQuantityAmountDataBean formattedQuantity = new FormattedQuantityAmountDataBean( new QuantityAmount( orderItem.getQuantityInEntityType().doubleValue(), currency ), (StoreAccessBean) store, cmdContext.getLanguageId() );
		%>
        	<%= comm.addDlistColumn( "<div style=\"text-align: left; font-size : 8pt\">"+formattedQuantity.getFormattedQuantity().toString()+"</div>","none" ) %>
        	<%= comm.addDlistColumn( jShortDescription,"none" ) %>
        	<%= comm.addDlistColumn( "<div style=\"text-align: right; font-size : 8pt\">"+amount+" ("+currency+")</div>","none" ) %>
        
        	<%= comm.endDlistRow() %>
        <%
        } else {
        %>
        	<%= comm.startDlistRow(rowselect) %>
        	<%= comm.addDlistColumn( "<div style=\"text-align: left; font-size : 8pt; color: Gray\">"+orderItem.getOrderId()+" <input type=\"hidden\" name=\"CustomerId" + oItemId + "\"" + "  value=" + "\"" + orderItem.getMemberId() + "\"" + ">","none" ) %>
		<SCRIPT>top.saveData("<%=orderItem.getStatus()%>","orderItemStatus<%=orderItem.getOrderItemId()%>");</SCRIPT>
		<% if (isB2B) { %>
        		<%= comm.addDlistColumn( "<div style=\"text-align: left; font-size : 8pt; color: Gray\">"+contractName,"none" ) %>
        	<% } %>
        	<%= comm.addDlistColumn( "<div style=\"text-align: left; font-size : 8pt; color: Gray\">"+jName,"none" ) %>
        	<%= comm.addDlistColumn( "<div style=\"text-align: left; font-size : 8pt; color: Gray\">"+orderItem.getPartNumber(),"none" ) %>
		<%= comm.addDlistColumn("<input type=\"hidden\" maxlength=\"10\" size=\"6\" name=\"Quantity" + oItemId + "\"" + " disabled=\"true\" " + "onChange=clickCheckBoxAction(" + oItemId + ")" + " >", "none" ) %>
		<%
			FormattedQuantityAmountDataBean formattedQuantity = new FormattedQuantityAmountDataBean( new QuantityAmount( orderItem.getQuantityInEntityType().doubleValue(), currency ), (StoreAccessBean) store, cmdContext.getLanguageId() );
		%>
        	<%= comm.addDlistColumn( "<div style=\"text-align: left; font-size : 8pt; color: Gray\">"+formattedQuantity.getFormattedQuantity().toString()+"</div>","none" ) %>
        	<%= comm.addDlistColumn( "<div style=\"text-align: left; font-size : 8pt; color: Gray\">"+jShortDescription,"none" ) %>
        	<%= comm.addDlistColumn( "<div style=\"text-align: right; font-size : 8pt; color: Gray\">"+amount+" ("+currency+")</div>","none" ) %>
        
        	<%= comm.endDlistRow() %>
        
        <%
        }
        %>
        
        
        
	<%
            if(rowselect==1){
               rowselect = 2;
            }else{
               rowselect = 1;
            }
          } 
          
	%>
        <%= comm.endDlistTable() %>
	<%
          if (orderItemListDB.getResultSetSize() == 0)
		out.println( "<P>" + UIUtil.toHTML((String)returnsNLS.get("orderItemSearchResultNotFound")) );
		
	} catch (Exception e)	{
		com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
	}
	%>
      </FORM>

      <SCRIPT>
        <!--
          parent.afterLoads();
          parent.setResultssize(getResultsSize());
        //-->
      </SCRIPT>

    </BODY>

  </HTML>


