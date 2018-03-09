<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006, 2016
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
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
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.*" %>
<%@ page import="com.ibm.commerce.ordermanagement.objects.*" %>
<%@ page import="com.ibm.commerce.common.beans.StoreDataBean" %>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.price.beans.FormattedMonetaryAmountDataBean" %>
<%@ page import="com.ibm.commerce.price.utils.MonetaryAmount" %>
<%@ page import="com.ibm.commerce.catalog.beans.CatalogEntryDataBean" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.CatalogEntryDescriptionDataBean" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@include file="../common/common.jsp" %>
<%@include file="../../tools/common/NumberFormat.jsp" %>

<%!
    public String getFormattedAmount(BigDecimal amount, String currency, Integer langId, String storeId)
    {
        try {
	    com.ibm.commerce.common.objects.StoreAccessBean iStoreAB = new com.ibm.commerce.common.objects.StoreAccessBean();
	    iStoreAB.setInitKey_storeEntityId(storeId);	
		
	    FormattedMonetaryAmountDataBean formattedAmount =  new FormattedMonetaryAmountDataBean(new MonetaryAmount(amount, currency), iStoreAB, langId);
	    
	    //determine if the number is negative
	    //currently the getFormattedValue method chops out the negative values
	    boolean isNegative = false;
	    String strAmount = amount.toString();
	    if ( (strAmount != null) && (!strAmount.equals("")) ) {
	    	if (strAmount.startsWith("-"))
	    		isNegative = true;
	    }
	    if (isNegative)
	    	return "-" + formattedAmount.getPrimaryFormattedPrice().getFormattedValue().toString();
	    else
	    	return formattedAmount.getPrimaryFormattedPrice().getFormattedValue().toString();
	    	
	} catch (Exception exc) {
	    return "";
	}
		
    }
    
%>
  
<%
    try {
        CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
        Locale jLocale = cmdContext.getLocale();
      	Hashtable returnsNLS = (Hashtable)ResourceDirectory.lookup("returns.ReturnsNLS", jLocale);
%>  
  
<HEAD>
<link rel="stylesheet" href="<%=UIUtil.getCSSFile(jLocale)%>" type="text/css" />

<SCRIPT src="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
     



<TITLE><%= UIUtil.toHTML((String)returnsNLS.get("returnItemsPageTitle")) %></TITLE>

<%
    String jStoreID = cmdContext.getStoreId().toString();
    String jLanguageID = cmdContext.getLanguageId().toString();
    String jLocaleID = cmdContext.getLocale().toString();

    JSPHelper jspHelper = new JSPHelper(request);
    String returnId = jspHelper.getParameter("returnId");
    if ( returnId == null || returnId.equals(""))
        returnId = "0";
	
    
    StoreDataBean storeDB = new StoreDataBean();
    storeDB.setStoreId(jStoreID);
    com.ibm.commerce.beans.DataBeanManager.activate(storeDB, request);
    String storeentId = storeDB.getStoreEntityId();
    String storeGroupId = storeDB.getStoreGroupId();
    Enumeration returnReasonDBEnum = new ReturnReasonDataBean().findByStoreentIdsForCustomer(new Integer(storeentId),new Integer(storeGroupId));
    Vector returnReasonABVec = new Vector();
    while (returnReasonDBEnum.hasMoreElements()) {
	ReturnReasonAccessBean returnReasonAB = (ReturnReasonAccessBean) returnReasonDBEnum.nextElement();
	returnReasonABVec.addElement(returnReasonAB);
    }
    ReturnReasonAccessBean[] returnReasonListAB = new ReturnReasonAccessBean[returnReasonABVec.size()];
    returnReasonABVec.copyInto(returnReasonListAB);
    
    String orderByParm = jspHelper.getParameter("orderby");      
    if ( orderByParm == null )
	orderByParm = "";
      
    String 	returnCurrency = "";
    String 	returnCurrencyBare = "";
    BigDecimal	runningTotal = new BigDecimal(0.0);
    String 	strRunningTotal = "";
    String	hasOrderItemInReturn = "false";
	
    RMAItemDataBean[] rmaItemLists = null;

    if (!returnId.equals("0")) {
	RMAItemListDataBean rmaItemListDB = new RMAItemListDataBean();
	rmaItemListDB.setRmaId(returnId);
	com.ibm.commerce.beans.DataBeanManager.activate(rmaItemListDB, request);
	rmaItemLists = rmaItemListDB.getRmaItemDataBeans();

        if ((rmaItemLists != null) && (rmaItemLists.length > 0)) {
	    for (int i=0; i<rmaItemLists.length; i++) {
	        runningTotal = runningTotal.add(rmaItemLists[i].getCreditAmountInEntityType());
	        runningTotal = runningTotal.add(rmaItemLists[i].getAdjustmentCreditInEntityType());
	        runningTotal = runningTotal.add(rmaItemLists[i].getAdjustmentInEntityType());
	    
	        // check to see if this is an order item
	        if (!rmaItemLists[i].getOrderItemsId().equals("") && rmaItemLists[i].getOrderItemsId() != null)
	            hasOrderItemInReturn = "true";
	    }
	    returnCurrency = "[" + rmaItemLists[0].getCurrency() + "]";
	    returnCurrencyBare = rmaItemLists[0].getCurrency();
        }
    }

    //if (returnCurrencyBare == null || returnCurrencyBare.equals(""))
	//returnCurrencyBare = storeDB.getCurrency();		
    strRunningTotal = getFormattedAmount(runningTotal, returnCurrencyBare, new Integer(jLanguageID), jStoreID);
%>

<%
request.setAttribute("returnId", returnId);
request.setAttribute("returnsNLS", returnsNLS);
%>
<jsp:include page="/tools/returns/ReturnFinishHandler.jsp" flush="true" />

<SCRIPT>
	var ramSNData = new Array();
	
	function rmaSerialData(rmaId,catEnId,quantity,rmacomid,sn){
		this.rmaId = rmaId;
		this.catEnId = catEnId;	
		this.quantity = quantity;
		this.sn = sn;
		this.rmacomId = rmacomid;
	}
	
    function init() {
        parent.parent.put("prev",parent.parent.getCurrentPanelAttribute("name"));     
        parent.parent.remove("returnItem");


<%--        
	if (parent.parent.get("inUse") == "Y" && parent.parent.get("inUseAlerted") != "true") {
	    parent.parent.put("inUseAlerted","true")
	    if (confirmDialog("<%= UIUtil.toJavaScript( (String)returnsNLS.get("inUseWarning")) %>") == false) {
		top.goBack();
	    }
	}
--%>
	if (parent.parent.setContentFrameLoaded) {
	    parent.parent.setContentFrameLoaded(true);
	}
    }

    var storeID = "<%= jStoreID %>";
    var languageID = "<%= jLanguageID %>";
    var hasOrderItemInReturn = "<%=hasOrderItemInReturn%>";

    function onLoad() {
        parent.loadFrames();
    }

    function getRefNum() {
        return parent.getChecked();
    }

    function getResultsSize() {
        <% if (rmaItemLists != null) { %>
        return <%=rmaItemLists.length%>;
        <% } else { %>
        	return 0;
        <% } %>
    }

    function getLang() {
        return languageID;
    }
        
    function getStore() {
        return storeID;
    }

    function getReturnId() {
	var rc = "<%=returnId%>";
   	if (rc == "null") rc = "";
	return rc;
    }
    
    function getCustomerId() {
        var customerId = parent.parent.get("customerId");
        if (!defined(customerId))
        	return null;
        return customerId;
    }
    
    function validateReturnItems() {
	var items = parent.parent.get("returnItem");
	
	if (defined(items) && items != null) {
	    for (var i=0; i<items.length; i++) {
	        if (!validateQuantity(document.ReturnItemsListForm["returnQuantity"+items[i].returnItemId].value)) {
	            document.ReturnItemsListForm["returnQuantity"+items[i].returnItemId].focus();
	            return false;
	        }
	        if (!validateAmount(document.ReturnItemsListForm["creditAdjustment"+items[i].returnItemId].value)) {
	            document.ReturnItemsListForm["creditAdjustment"+items[i].returnItemId].focus();
	            return false;
	        }
	    }
	}
	
	return true;
    }

    function validateNoteBookPanel()
    {
        return validatePanelData();
    }  
        
    function validatePanelData()
    {
        if (hasOrderItemInReturn != "true") {
            alertDialog("<%= UIUtil.toJavaScript( (String)returnsNLS.get("noOrderItemsInReturn")) %>");
	    return false;
	}
	    
	if (!validateReturnItems())
	    return false;
	
        if ( getResultsSize() > 0 )
        	return true;
	alertDialog("<%= UIUtil.toJavaScript( (String)returnsNLS.get("returnNeedAtLeastOneItemMsg")) %>");
        return false;
    }

    function addItems() {
        if (!validateReturnItems())
            return;
    
        // if inside merchant center
	if (parent.parent.isInsideMC()) {    
	    // save parent.parent "model" to TOP frame before call
	    top.saveModel(parent.parent.model);

	    // set returning panel to be current panel
	    top.setReturningPanel(parent.parent.getCurrentPanelAttribute("name"));

	    if (isAnyChange) {
		// If user has made update to the qty, need to call the update cmd first
		var xmlObject = parent.parent.modelToXML("XML");
		document.callActionForm.action="CSRReturnItemUpdate";
		document.callActionForm.XML.value=xmlObject;
		document.callActionForm.URL.value="/webapp/wcs/tools/servlet/ReturnItemAddRedirect";
		document.callActionForm.submit();			
	    } else {
	    	// launch 2nd wizard  
	    	top.setContent("<%= UIUtil.toJavaScript( (String)returnsNLS.get("addProductBCT")) %>","/webapp/wcs/tools/servlet/DialogView?XMLFile=returns.returnItemSearchDialog&memberId="+getCustomerId(), true);
	    }
        } else {
	    alertDialog("<%= UIUtil.toJavaScript( "TODO") %>");
	}
    }        

    function comments() 
    {
        if (!validateReturnItems())
            return;

        // if inside merchant center
        if (parent.parent.isInsideMC()) {    
            // save parent.parent "model" to TOP frame before call
	    top.saveModel(parent.parent.model);
	    // set returning panel to be current panel
	    top.setReturningPanel(parent.parent.getCurrentPanelAttribute("name"));

	    var checkedReturnItemId = parent.getChecked().toString();
	
	    if (isAnyChange) {
		// If user has made update to the qty, need to call the update cmd first
		var xmlObject = parent.parent.modelToXML("XML");
		document.callActionForm.action="CSRReturnItemUpdate";
		document.callActionForm.XML.value=xmlObject;
		document.callActionForm.URL.value="/webapp/wcs/tools/servlet/ReturnItemAddCommentRedirect";
		document.callActionForm.submit();			
	    } else {
	    	// launch 2nd wizard  
	        top.setContent("<%= UIUtil.toJavaScript( (String)returnsNLS.get("reasonForReturnDialogTitle") ) %>", 
	                       "/webapp/wcs/tools/servlet/DialogView?XMLFile=returns.returnItemCommentsDialog&amp;returnItemId="+checkedReturnItemId, true);
	    }
        } else {
	    alertDialog("<%= UIUtil.toJavaScript( (String)returnsNLS.get("reasonForReturnDialogTitle") ) %>");
        }
    }
	
    function removeItems() {
        if (!validateReturnItems())
            return;

	if (confirmDialog("<%= UIUtil.toJavaScript( (String)returnsNLS.get("addProductDialogRemoveConfirm")) %>")) {
	    parent.parent.remove("deleteReturnItemId");

	    var itemsSelected = false;
	    var items = new Array();
	    var checkedItems = new Array;
	    checkedItems = parent.getChecked();
		
	    if (checkedItems.length > 0) {
    	    for (var i=0; i < checkedItems.length; i++)
	    	parent.removeEntry(checkedItems[i]);
	    
	    	if (isAnyChange) {
		    var preCmdChain = new Object();
		    var preCommand = new Vector();
		    var aCmd = new Object();
		    aCmd.name = "CSRReturnItemUpdate"
		    addElement(aCmd, preCommand);
		    preCmdChain.preCommand = preCommand;
		    parent.parent.remove("preCmdChain");
		    parent.parent.put("preCmdChain",preCmdChain);
	    	}
		parent.parent.put("deleteReturnItemId", checkedItems);
		//---------------------------------
		// call the itemdelete command here
		//---------------------------------
		var xmlObject = parent.parent.modelToXML("XML");
		document.callActionForm.action="CSRReturnItemDelete";
		document.callActionForm.XML.value=xmlObject;
		document.callActionForm.URL.value="ReturnItemsPage?ActionXMLFile=returns.returnItemsPage&cmd=ReturnItemsPage&listsize=15&startindex=0&returnId="+getReturnId();
		document.callActionForm.submit();
	    } else {
		alertDialog("<%= UIUtil.toJavaScript( (String)returnsNLS.get("noItemsSelected")) %>");
	    }
	}
    }

    function recalculate() {
	var items = parent.parent.get("returnItem");

	if (items == null) {
	    alertDialog("<%= UIUtil.toJavaScript( (String)returnsNLS.get("noChange")) %>");
	    return;
	}

        if (!validateReturnItems())
            return;

	if (isAnyChange) {
	    var xmlObject = parent.parent.modelToXML("XML");
	    document.callActionForm.action="CSRReturnItemUpdate";
	    document.callActionForm.XML.value=xmlObject;
	    document.callActionForm.URL.value="ReturnItemsPage?ActionXMLFile=returns.returnItemsPage&cmd=ReturnItemsPage&listsize=15&startindex=0&returnId="+getReturnId();
	    document.callActionForm.submit();			
	} else {
	    alertDialog("<%= UIUtil.toJavaScript( (String)returnsNLS.get("noChange")) %>");
	}
    }

    function checkIsKit(id) {
        eval ("var x = document.ReturnItemsListForm.returnToWarehouse" + id);
        if (x.value == "seeKitDetails")
            return true;
        return false;
    }


    function showKitDetails() 
    {
        if (!validateReturnItems())
            return;

        // if inside merchant center
        if (parent.parent.isInsideMC()) {    
            // save parent.parent "model" to TOP frame before call
	    top.saveModel(parent.parent.model);
	    // set returning panel to be current panel
	    top.setReturningPanel(parent.parent.getCurrentPanelAttribute("name"));

	    var checkedReturnItemId = parent.getChecked().toString();
	    if (!checkIsKit(checkedReturnItemId)) {
	    	alertDialog("<%= UIUtil.toJavaScript( (String)returnsNLS.get("returnItemNotAKit")) %>");
	    	return;
	    }
	
	    if (isAnyChange) {
		// If user has made update to the qty, need to call the update cmd first
		var xmlObject = parent.parent.modelToXML("XML");
		document.callActionForm.action="CSRReturnItemUpdate";
		document.callActionForm.XML.value=xmlObject;
		document.callActionForm.URL.value="/webapp/wcs/tools/servlet/ReturnItemKitDetailsRedirect";
		document.callActionForm.submit();			
	    } else {
	    	// launch 2nd wizard  
	        top.setContent("<%= UIUtil.toJavaScript( (String)returnsNLS.get("returnItemKitDetailsDialogTitle") ) %>", 
	                       "/webapp/wcs/tools/servlet/DialogView?XMLFile=returns.returnItemKitDetailsDialog&amp;returnItemId="+checkedReturnItemId, true);
	    }
        } else {
	    alertDialog("<%= UIUtil.toJavaScript( "TODO" ) %>");
        }
    }

    isAnyChange = false;
    function setAnyChange() {
	isAnyChange = true;
    }	

    function addToUpdate(id,field) {
	var items = parent.parent.get("returnItem");
	
	if (field == "returnQuantity") {
	    validateQuantity(document.ReturnItemsListForm[field+id].value);
	}
	
	if (field == "creditAdjustment") {
	    validateAmount(document.ReturnItemsListForm[field+id].value);
	}
	
	if (items == null) {
	    anItem = new Object();
	    anItem.returnItemId = id;
	    if (field == "returnQuantity" || field == "creditAdjustment") {
	        anItem[field] = parent.parent.strToNumber(document.ReturnItemsListForm[field+id].value, "<%=jLanguageID%>");
	    } else {
	        anItem[field] = document.ReturnItemsListForm[field+id].value;
	    }
	    items = new Array();
	    items[0]=anItem;
	} else {
	    var alreadyExists = false;
	    for (var i=0; i<items.length; i++) {
	        if (items[i].returnItemId == id) {
	            if (field == "returnQuantity" || field == "creditAdjustment") {
	                items[i][field] = parent.parent.strToNumber(document.ReturnItemsListForm[field+id].value, "<%=jLanguageID%>");
	            } else {
	                items[i][field] = document.ReturnItemsListForm[field+id].value;
	            }
	            alreadyExists = true;
	        }
	    }
	    if (!alreadyExists) {
	        anItem = new Object();
	        anItem.returnItemId = id;
	        if (field == "returnQuantity" || field == "creditAdjustment") {
	            anItem[field] = parent.parent.strToNumber(document.ReturnItemsListForm[field+id].value, "<%=jLanguageID%>");
	        } else {
	            anItem[field] = document.ReturnItemsListForm[field+id].value;
	        }
		items[items.length] = anItem;
	    }
	}

	parent.parent.remove("returnItem");
	parent.parent.put("returnItem", items);
    }

    function validateQuantity(element) {
	var number = parent.parent.strToNumber(element, <%=jLanguageID%>);

	if (number.toString() == "NaN") {
	    alertDialog("<%= UIUtil.toJavaScript( (String)returnsNLS.get("ProductsInvalidQuantityMsg")) %>");
	    return false;
	}
	        
	if(number < 0) {
	    alertDialog("<%= UIUtil.toJavaScript( (String)returnsNLS.get("ProductsQuantityMustBeGreaterMsg")) %>");
	    return false;
	}
	
	return true;
    }

    function validateAmount(element) {
        var langId = "<%=jLanguageID%>";
        var currency = "<%=returnCurrencyBare%>";
        var num = parent.parent.numberToCurrency(parent.parent.strToNumber(element, langId), currency, langId);

	if (num == null || num.toString() == "NaN") {
	    alertDialog("<%= UIUtil.toJavaScript( (String)returnsNLS.get("ProductsInvalidAmountMsg")) %>");
	    return false;
	}
	
	return true;
    }
    
    
function editSn(){
    if (!validateReturnItems())
            return;
    
        // if inside merchant center
	if (parent.parent.isInsideMC()) {    
	    // save parent.parent "model" to TOP frame before call
	    top.saveModel(parent.parent.model);

	    // set returning panel to be current panel
	    top.setReturningPanel(parent.parent.getCurrentPanelAttribute("name"));

        var tokens = parent.getSelected().split(",");
		var checked = parent.getChecked();
		var checkedReturnItemId = parent.getChecked().toString();
		var rmaItemId = tokens[0];
		for(var i =0;i<ramSNData.length;i++){
			if(rmaItemId==ramSNData[i].rmaId){
      	       //  var aSN = ramSNData[i].sn;
      	       //  if (aSN=="N"){
      	       //     alertDialog("<%= UIUtil.toJavaScript( (String)returnsNLS.get("NoSNsMsg")) %>");
	           //     return false;
      	       //  }
      	         var catalogEntryId = ramSNData[i].catEnId;
		         var quantity = ramSNData[i].quantity;
		         var rmaComid = ramSNData[i].rmacomId;
      	         var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=returns.rmaSerialNumberEdit&amp;";
                 break;
      		  }
      		
      	}
      	
	    if (isAnyChange) {
		// If user has made update to the qty, need to call the update cmd first
     		var xmlObject = parent.parent.modelToXML("XML");
	    	document.callActionForm.action="CSRReturnItemUpdate";
		    document.callActionForm.XML.value=xmlObject;
		    document.callActionForm.URL.value="/webapp/wcs/tools/servlet/RMASerialNumberRedirect?redirect=true&"
		         + 'rmaItemId=' + rmaItemId + "&catalogEntryId=" + catalogEntryId+"&quantity=" + quantity+"&itemCompId=" + rmaComid;
		    document.callActionForm.submit();			
	    } else {
		

      		url += 'returnId=' + <%=returnId%> + '&rmaItemId=' + rmaItemId + '&itemCompId=' +rmaComid;
        	top.setContent("<%= UIUtil.toHTML((String)returnsNLS.get("editSNsPanel")) %>", url, true);
		}
	}
	
}
</SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
</HEAD>

<BODY onload="init();" class="content_list">
<FORM NAME="callActionForm" action="" method="POST">
    <INPUT type="hidden" name="XML" value="">
    <INPUT type="hidden" name="URL" value="">
</FORM>

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
    int rowselect = 1;
%>

<FORM NAME="ReturnItemsListForm">
    <P>
    <%= comm.startDlistTable(UIUtil.toJavaScript( (String)returnsNLS.get("orderItemListTableSummary"))) %>
        <%= comm.startDlistRowHeading() %>
	    <%= comm.addDlistCheckHeading() %>
            <%= comm.addDlistColumnHeading((String)returnsNLS.get("itemName"),null,false,null,false ) %>
            <%= comm.addDlistColumnHeading((String)returnsNLS.get("sku"),null,false,null,false ) %>
            <%= comm.addDlistColumnHeading((String)returnsNLS.get("rmaSerialNumber"),null,false,null,false ) %>
            <%= comm.addDlistColumnHeading((String)returnsNLS.get("quantityReturned"),null,false,null,false ) %>
            <%= comm.addDlistColumnHeading((String)returnsNLS.get("returnToWareHouse"),null,false,null,false ) %>
            <%= comm.addDlistColumnHeading((String)returnsNLS.get("reasonForReturn"),null,false,null,false ) %>
            <%= comm.addDlistColumnHeading((String)returnsNLS.get("itemCreditAmount"),null,false,null,false ) %>
            <%= comm.addDlistColumnHeading((String)returnsNLS.get("itemCreditAdjustment"),null,false,null,false ) %>
           
        <%= comm.endDlistRow() %>
   
	<%
	if (!returnId.equals("0") && (rmaItemLists != null)) {
	    for (int i = 0; i < rmaItemLists.length; i++) {

		RMAItemComponentListDataBean rmaItemComponentListDB = new RMAItemComponentListDataBean();
		rmaItemComponentListDB.setRmaItemId(rmaItemLists[i].getRmaItemId());
		com.ibm.commerce.beans.DataBeanManager.activate(rmaItemComponentListDB, request);
		RMAItemComponentAccessBean[] rmaItemComponentListAB = rmaItemComponentListDB.getRMAItemComponentList();

		CatalogEntryDataBean catentryDB = new CatalogEntryDataBean();
		catentryDB.setCatalogEntryID(rmaItemLists[i].getCatalogEntryId());
		com.ibm.commerce.beans.DataBeanManager.activate(catentryDB, request);
		CatalogEntryDescriptionDataBean catentryDescDB = new CatalogEntryDescriptionDataBean();
		catentryDescDB.setItemRefNum(catentryDB.getCatalogEntryReferenceNumber());
		catentryDescDB.setInitKey_language_id(jLanguageID);
		com.ibm.commerce.beans.DataBeanManager.activate(catentryDescDB, request);

		ReturnReasonDataBean returnReasonDB = new ReturnReasonDataBean();
		returnReasonDB.setDataBeanKeyRtnReasonId(rmaItemLists[i].getRtnReasonId());
		com.ibm.commerce.beans.DataBeanManager.activate(returnReasonDB, request);

		String name = catentryDescDB.getName();
		if (name == null)
			name = "";
		String sku = catentryDB.getPartNumber();			
	%>

        <%= comm.startDlistRow(rowselect) %>
            <%= comm.addDlistCheck(rmaItemLists[i].getRmaItemId().toString(), "parent.setChecked()" ) %>
            <%= comm.addDlistColumn(name, "none" ) %>
            <%= comm.addDlistColumn(sku, "none" ) %>
            <%
         	StringBuffer serialNumbers = new StringBuffer();    
         	
         	RMASerialNumbersDataBean[] aSNs = rmaItemLists[i].getRmaSerialNumbersDataBeansForRMAItem();
         	    	
         	
			Set sNSet = new HashSet();
			
			if (aSNs != null){
			    for (int k = 0; k < aSNs.length; k++){
			        sNSet.add(aSNs[k].getSerialNumber());
			    }
			}
			
			Iterator anIte = sNSet.iterator();
			while (anIte.hasNext()) {
			    serialNumbers.append((String)anIte.next());
			    serialNumbers.append("<br>");
			}
			
         %>   
        <%= comm.addDlistColumn(serialNumbers.toString(), "none" ) %>   
            <%= comm.addDlistColumn("<input type=\"text\" size=\"6\" name=\"returnQuantity" + rmaItemLists[i].getRmaItemId() + "\"" + " value=\"" + rmaItemLists[i].getQuantity() + "\"" + " onChange=\"setAnyChange();addToUpdate(" +rmaItemLists[i].getRmaItemId()+",\'returnQuantity\');\"" + " >" , "none" ) %>
	    <SCRIPT>
		document.ReturnItemsListForm.returnQuantity<%=rmaItemLists[i].getRmaItemId()%>.value=parent.parent.numberToStr(<%=rmaItemLists[i].getQuantity()%>,"<%=jLanguageID%>");
	    </SCRIPT>
            <% 
            	//determine if item is a kit
            	boolean isKit = false;
            	if (rmaItemComponentListAB.length > 1) { isKit = true; }
            	
            	if (isKit) {
            %>
            		<%= comm.addDlistColumn("<input type=\"hidden\" name=\"returnToWarehouse" + rmaItemLists[i].getRmaItemId() + "\" value=\"seeKitDetails\">" + UIUtil.toJavaScript( (String)returnsNLS.get("seeKitDetails")) , "none" ) %>
            <%	
            	} else {
	        	String yesSelect = "";
			String noSelect = "";
			String noType = "";
			if (rmaItemComponentListAB[0].getShouldReceive().equals("Y")) {
				noType = "N";
		    		yesSelect = "SELECTED ";
			} else if (rmaItemComponentListAB[0].getShouldReceive().equals("N")) {
				noType = "N";
		    		noSelect = "SELECTED ";
			} else if (rmaItemComponentListAB[0].getShouldReceive().equals("S")) {
				noType = "";
		    		noSelect = "SELECTED ";
			}
            %>
            		<%= comm.addDlistColumn("<select name=\"returnToWarehouse" + rmaItemLists[i].getRmaItemId() + "\"" + " id=\"returnToWarehouse" + rmaItemLists[i].getRmaItemId() + "\"" + " onChange=\"setAnyChange();addToUpdate(" +rmaItemLists[i].getRmaItemId()+",\'returnToWarehouse\');\"" + "><option " + yesSelect + "value=\"Y\">" + UIUtil.toJavaScript( (String)returnsNLS.get("returnToWarehouseYes")) + "</option><option " + noSelect + "value=\""+noType+"\">" + UIUtil.toJavaScript( (String)returnsNLS.get("returnToWarehouseNo")) + "</option>" , "none" ) %>
	    <%  
	    	}
	    %>
        
            <%
        	String optionsStr = "";
        	for (int j=0; j < returnReasonListAB.length; j++) {
        	    String isSelect = "";
        	    if (returnReasonListAB[j].getCode().equals(returnReasonDB.getCode()))
        		isSelect = "SELECTED";
        	    optionsStr = optionsStr + "<option " + isSelect + " value=\"" + returnReasonListAB[j].getCode() + "\">" + returnReasonListAB[j].getCode() + "</option>";
        	}
            %>
            
            <%= comm.addDlistColumn("<select name=\"reasonForReturnCode" + rmaItemLists[i].getRmaItemId() + "\"" + " id=\"reasonForReturnCode" + rmaItemLists[i].getRmaItemId() + "\"" + " onChange=\"setAnyChange();addToUpdate(" +rmaItemLists[i].getRmaItemId()+",\'reasonForReturnCode\');\"" + ">" + optionsStr, "none" ) %>

	    <%
	    	BigDecimal creditAmountBeforeCharges = rmaItemLists[i].getCreditAmountInEntityType().add(rmaItemLists[i].getAdjustmentCreditInEntityType());
	    	BigDecimal creditAmount = creditAmountBeforeCharges;
	        String strCreditAmount = getFormattedAmount(creditAmount, returnCurrencyBare, new Integer(jLanguageID), jStoreID);
            %>
            <%= comm.addDlistColumn(strCreditAmount, "none" ) %>
            <%= comm.addDlistColumn("<input type=\"text\" size=\"6\" name=\"creditAdjustment" + rmaItemLists[i].getRmaItemId() + "\"" + " value=\"" + rmaItemLists[i].getAdjustmentInEntityType() + "\"" + " onChange=\"setAnyChange();addToUpdate(" +rmaItemLists[i].getRmaItemId()+",\'creditAdjustment\');\"" + " >" , "none" ) %>
	    <SCRIPT>
		document.ReturnItemsListForm.creditAdjustment<%=rmaItemLists[i].getRmaItemId()%>.value=parent.parent.numberToCurrency(<%=rmaItemLists[i].getAdjustmentInEntityType()%>,"<%=rmaItemLists[i].getCurrency()%>","<%=jLanguageID%>");
	    </SCRIPT>

        <%= comm.endDlistRow() %>
		<SCRIPT>
		    <% if ( serialNumbers.length() == 0 ) { 
		       		if (isKit) { %>
		      			ramSNData[<%=i%>] = new rmaSerialData(<%=rmaItemLists[i].getRmaItemId()%>,<%=rmaItemLists[i].getCatalogEntryId()%>,<%=rmaItemLists[i].getQuantity()%>,"","N");
		  			<% } else { %>
		  				ramSNData[<%=i%>] = new rmaSerialData(<%=rmaItemLists[i].getRmaItemId()%>,<%=rmaItemLists[i].getCatalogEntryId()%>,<%=rmaItemLists[i].getQuantity()%>,<%=rmaItemComponentListAB[0].getRmaItemCmpId()%>,"N");
		  			<% }
		     } else { 
		     		if (isKit) { %>
			   			ramSNData[<%=i%>] = new rmaSerialData(<%=rmaItemLists[i].getRmaItemId()%>,<%=rmaItemLists[i].getCatalogEntryId()%>,<%=rmaItemLists[i].getQuantity()%>,"","Y");
            		<% } else { %>
		  				ramSNData[<%=i%>] = new rmaSerialData(<%=rmaItemLists[i].getRmaItemId()%>,<%=rmaItemLists[i].getCatalogEntryId()%>,<%=rmaItemLists[i].getQuantity()%>,<%=rmaItemComponentListAB[0].getRmaItemCmpId()%>,"N");
		  			<% }
            	} %> 
		</SCRIPT>
	<%
	        if (rowselect==1) {
		    rowselect = 2;
	        } else {
		    rowselect = 1;
	        }
	    } 
        }
	%>
    <%= comm.endDlistTable() %>
    <br> 
    <div align="right"> <%=UIUtil.toHTML( (String)returnsNLS.get("refundAmount"))%> : <%=returnCurrency%> <%=strRunningTotal%> 
    &nbsp;&nbsp;
    <button type="button" id="contentButton" name="updateBtn" onClick="recalculate()" ><%=UIUtil.toHTML(returnsNLS.get("update").toString())%></button> 
    </div>
    
    <%
	if ((rmaItemLists == null) || (rmaItemLists.length < 1)) {
	%>

	<P><P>
	<TABLE CELLSPACING=0 CELLPADDING=3 BORDER=0 >
	<TR>
	    <TD COLSPAN=7 >
		<%=UIUtil.toHTML( (String)returnsNLS.get("noReturnItemsToList"))%> 

	    </TD>
	</TR> 
	</TABLE>	

	<% 	
	}
	
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
