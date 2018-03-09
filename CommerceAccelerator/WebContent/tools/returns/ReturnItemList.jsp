<%
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
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<!--
-->

<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>

<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.*" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.common.beans.StoreDataBean" %>
<%@ page import="com.ibm.commerce.tools.optools.order.beans.ProductListBean" %>
<%@ page import="com.ibm.commerce.tools.optools.order.beans.ProductListDataBean" %>
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

	JSPHelper jspHelper = new JSPHelper(request);
      %>
      <link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css"> 
      
      <TITLE><%= UIUtil.toHTML((String)returnsNLS.get("addProductResultsListTitle")) %></TITLE>

      <%
            
      String jStoreID = cmdContext.getStoreId().toString();
      String jLanguageID = cmdContext.getLanguageId().toString();
      String jLocaleID = cmdContext.getLocale().toString();
      String jCurrency = cmdContext.getCurrency();

	// retrieve request parameters
	String orderId			= jspHelper.getParameter("orderId");
	String customerId		= jspHelper.getParameter("customerId");
	String billingAddressId		= jspHelper.getParameter("addressId");
	String searchForProductName 	= jspHelper.getParameter("searchProductName");
	String searchForSKUNumber 	= jspHelper.getParameter("searchSKUNumber");
	String searchForShortDesc 	= jspHelper.getParameter("searchShortDesc");
	String itemsSelected		= jspHelper.getParameter("itemsSelected");
		
	// get standard list parameters
        int rowselect = 1;

	String xmlFile = jspHelper.getParameter("ActionXMLFile");
	String orderByParm = jspHelper.getParameter("orderby");      

	ProductListBean productListBean = new ProductListBean();
	productListBean.setSKULike(searchForSKUNumber);
	productListBean.setNameLike(searchForProductName);
	productListBean.setDescLike(searchForShortDesc);
	productListBean.setOrderBy(orderByParm);
	com.ibm.commerce.beans.DataBeanManager.activate(productListBean, request);

  	ProductListDataBean[] itemList = productListBean.getProductList();
  
  	//retrieve the fulfillment center ID for the store
	StoreDataBean store = new StoreDataBean();
	store.setStoreId(jStoreID);
	com.ibm.commerce.beans.DataBeanManager.activate(store, request);
  	Integer ffmcenterId = new Integer(store.getFulfillmentCenterId());

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
            return <%=itemList.length%>;
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
	   
	   // validate quantity values
   	   for (var i in selectedItemsHashTable) {
   	      var x = selectedItemsHashTable[i];
   	      if (x != null) {
   	         if ( validateQuantity(x.returnQuantity) == false ) {
   	            var formRef = document.AddProductResultsList;
	            formRef["Quantity"+x.itemId].focus();
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
   	      var x = selectedItemsHashTable[i];
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
	   document.createReturnItemsForm.URL.value = "ReturnItemListRedirect";
	   document.createReturnItemsForm.submit();        
	}        

	function SelectedItem(orderItemId, returnQuantity)
	{
	   this.itemId = orderItemId;
	   this.returnQuantity = returnQuantity;
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
	   var formRef = document.AddProductResultsList;
   
	   var quantity = formRef["Quantity"+orderItemId].value;
	   var selItem = new SelectedItem(orderItemId, quantity);
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
	         
	   } else {
	   	if ( defined(selectedItemsHashTable["OrderItemId_" + orderItemId]) ) {
	   		selectedItemsHashTable["OrderItemId_" + orderItemId] = null;
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
	    
      </SCRIPT>
      <SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
    </HEAD>

    <BODY class="content_list" onload="executeOnLoad();">

	<P><%=(String)returnsNLS.get("addProductResultInstructions")%>

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
      <FORM NAME="AddProductResultsList">
        <%= comm.startDlistTable((String)returnsNLS.get("addProductResultsListTableSummary")) %>
        <%= comm.startDlistRowHeading() %>

        <%= comm.addDlistColumnHeading((String)returnsNLS.get("addProductResultHeading1"),null,false,null,false ) %>
        <%= comm.addDlistColumnHeading((String)returnsNLS.get("addProductResultHeading2"),null,false,null,false ) %>
        <%= comm.addDlistColumnHeading((String)returnsNLS.get("addProductResultHeading3"),null,false ,null,false) %>
        <%= comm.addDlistColumnHeading((String)returnsNLS.get("addProductResultHeading4"),null,false ,null,false) %>

        <%= comm.endDlistRow() %>

   
          <%

          for (int i = 0; i < itemList.length; i++)          
          {
		ProductListDataBean item = itemList[i];
		String catentryId = item.getCatentryId();
		
		String name = item.getName();
		String sku = item.getPartNumber();
		String desc = item.getDescription();
		if (name == null)
			name = "";
		if (desc == null) 
			desc = "";
		          
          %>
        <%= comm.startDlistRow(rowselect) %>

        <%= comm.addDlistColumn( name,"none" ) %>
        <%= comm.addDlistColumn( sku,"none" ) %>
        <%= comm.addDlistColumn("<input type=\"text\" maxlength=\"10\" size=\"6\" name=\"Quantity" + catentryId + "\"" + "onChange='clickCheckBoxAction(" + catentryId + ")'" + " >", "none" ) %>
        <%= comm.addDlistColumn( desc,"none" ) %>
        
        <%= comm.endDlistRow() %>
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
	  if (itemList.length == 0)
	  	out.println( "<P>" + UIUtil.toHTML((String)returnsNLS.get("addProductResultNotFound")) );

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


