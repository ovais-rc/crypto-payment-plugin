<!-- 
========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
========================================================================
-->
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.math.*" %>
<%@ page import="com.ibm.commerce.beans.*"  %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.contract.beans.*" %>
<%@ page import="com.ibm.commerce.contract.commands.*" %>
<%@ page import="com.ibm.commerce.contract.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.command.*"  %>
<%@ page import="com.ibm.commerce.common.objects.*"  %>
<%@ page import="com.ibm.commerce.price.utils.*"  %>
<%@ page import="com.ibm.commerce.price.*"  %>
<%@ page import="com.ibm.commerce.rfq.beans.*" %>
<%@ page import="com.ibm.commerce.rfq.objects.*" %>
<%@ page import="com.ibm.commerce.rfq.objimpl.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.utf.beans.*" %>
<%@ page import="com.ibm.commerce.utf.helper.*" %>
<%@ page import="com.ibm.commerce.utf.objects.*" %>
<%@ page import="com.ibm.commerce.utf.objimpl.*" %>
<%@ page import="com.ibm.commerce.utf.utils.*" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="../common/NumberFormat.jsp" %>

<%
    Locale aLocale = null;
    CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");  
    String ErrorMessage = request.getParameter(com.ibm.commerce.tools.common.ui.UIProperties.SUBMIT_ERROR_MESSAGE);
    if (ErrorMessage == null) {
		ErrorMessage = "";
    }
    if( aCommandContext!= null ) {
    	aLocale = aCommandContext.getLocale();
    }    
    Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS", aLocale);
    String strPercentage = (String)rfqNLS.get("percentagemark");

    String lang = aCommandContext.getLanguageId().toString();
    Integer langId = aCommandContext.getLanguageId();
    String StoreId = aCommandContext.getStoreId().toString();
    StoreAccessBean storeAB = com.ibm.commerce.registry.StoreRegistry.singleton().find(new Integer(StoreId));
    if (lang == null) {
  		lang =  "-1";
    }
    int rowselect=1;
    String rfqid =  request.getParameter("rfqid");
    String prodCategoryId =  request.getParameter("rfqCategoryId");
    String rfqCategoryName = "";
    if (prodCategoryId != null && prodCategoryId.length() > 0) {
        RFQCategryDataBean rfqCategry = new RFQCategryDataBean();
        rfqCategry.setRfqCategryId(prodCategoryId);
        rfqCategoryName = UIUtil.toHTML(rfqCategry.getName());
    }
    if (rfqCategoryName == null || rfqCategoryName =="") {
        rfqCategoryName = UIUtil.toHTML((String)rfqNLS.get("RFQExtra_NotCategorized"));
    }
%>


<jsp:useBean id="rfq" class="com.ibm.commerce.utf.beans.RFQDataBean" >
<jsp:setProperty property="*" name="rfq" />
<jsp:setProperty property="rfqId" name="rfq" value="<%= rfqid %>" />
</jsp:useBean>
<%
    com.ibm.commerce.beans.DataBeanManager.activate(rfq, request);
    String name = UIUtil.toHTML(rfq.getName());
    String endresult = rfq.getEndResult();
    if (endresult.equals(com.ibm.commerce.utf.utils.UTFConstants.EC_UTF_ENDRESULT_ORDER.toString())) {
		endresult = (String)rfqNLS.get("order");
    } else {
		endresult = (String)rfqNLS.get("contract");
    } 
%> 


<jsp:useBean id="prodList" class="com.ibm.commerce.utf.beans.RFQProdListBean" >
<jsp:setProperty property="*" name="prodList" />
</jsp:useBean>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale)%>" type="text/css" />
<title><%= rfqNLS.get("RFQSummTitle") %></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script type="text/javascript">
function printAction() {
	window.print();
}
function initializeState() {
  	parent.setContentFrameLoaded(true);
}
function savePanelData() {
	return true;
}
function validatePanelData() {
	return true;
}
function goToCategory(rfqid, rfqCategoryId) {
	top.setContent(getCategoryAttBCT(), "DialogView?XMLFile=rfq.requestSummaryCategory&amp;rfqid="+rfqid+"&amp;rfqCategoryId="+rfqCategoryId, true);
}
function getCategoryAttBCT() {
  	return "<%= UIUtil.toJavaScript(rfqNLS.get("category")) %>";
}
function goToProduct(rfqid, rfqProdId, showCR) {
	top.setContent(getProductAttBCT(), "DialogView?XMLFile=rfq.requestSummaryProduct&amp;rfqShowCR="+showCR+"&amp;rfqid="+rfqid+"&amp;rfqProdId="+rfqProdId, true);
}
function getProductAttBCT() {
  	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_ProductAtt")) %>";
}
function goToConfigurationReport(rfqid, rfqProdId){
	top.setContent(getConfigurationReportBCT(), "DialogView?XMLFile=rfq.rfqRequestSummaryDynamicKitConfigReport&amp;rfqid="+rfqid+"&amp;rfqProdId="+rfqProdId, true);
}
function getConfigurationReportBCT() {
  	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_ConfigReport")) %>";
}
</script>
</head>

<body class="content" onload="initializeState();">
<br /><h1><%= rfqNLS.get("prodcategoryinfo") %>: <i><%= rfqCategoryName %></i></h1>
<form name="SummaryForm" action="">
<table>
    <tr>
	<td> <%= rfqNLS.get("rfqname") %>: <i><%= name %></i><br /></td>
    </tr>
    
</table>
<br />

<!-- Start Percentage Pricing on Products table -->
<%
    prodList.setRFQId(rfqid);
 
    Integer[] negotiationTypes = new Integer[1];
    //get all percentage pricing on Items, Products and Pre-built kits(Packages)
    negotiationTypes[0] = new Integer (2);                              
    prodList.setNegotiationTypes(negotiationTypes);                   
    com.ibm.commerce.beans.DataBeanManager.activate(prodList, request);        
    com.ibm.commerce.utf.beans.RFQProdDataBean [] pList = prodList.getRFQProds();
     
boolean header = false;	

if (pList != null && pList.length > 0 ) { 	
		
    for (int i = 0; pList != null && i < pList.length; i++) {
		RFQProdDataBean aPList = pList[i];
		String catid = aPList.getCatentryId();
		String quantity = aPList.getQuantity();
		String price = aPList.getPrice();
		BigDecimal price_ejb = aPList.getPriceInEntityType();
		String currency = aPList.getCurrency();
		String unitid = aPList.getQtyUnitId();
		String prodName = UIUtil.toHTML(aPList.getRfqProductName());
		String rfqProdId = aPList.getRfqprodId();
		String prodChangeable = aPList.getChangeable();		
		String ppAdjust = aPList.getPriceAdjustment();
		if (ppAdjust != null && ppAdjust.length() > 0) 
		{
            	    Double ptemp = Double.valueOf(ppAdjust);
            	    java.text.NumberFormat numberFormatter;
            	    if (ptemp != null && ptemp.doubleValue() <= 0) 
            	    {
          	    	numberFormatter = java.text.NumberFormat.getNumberInstance(aLocale);
          	    	ppAdjust = numberFormatter.format(ptemp);
		    }
		}
		String categoryIdent = aPList.getRfqCategryId(); 	
	
		
		String unit = "";
		FormattedMonetaryAmount fmt = null;
		CurrencyManager cm = CurrencyManager.getInstance();
		String currencyCode = cm.getDefaultCurrency(storeAB, langId);   

		if ( !price.equals("") && price != null ) {
	    	price_ejb = new BigDecimal(price);
	    	if (price_ejb.doubleValue() >= 0 ) {
				fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(price_ejb, currencyCode), storeAB, langId);
				price = fmt.getFormattedValue();  // price without prefix and postfix
	    	}
		}
      	if (quantity != null && quantity.length() > 0) {
            Double dtemp = Double.valueOf(quantity);
            //Integer itemp = new Integer(dtemp.intValue());
            java.text.NumberFormat numberFormatter;
            //if (itemp.intValue() >= 0) 
            if (dtemp != null && dtemp.doubleValue() >= 0) {
          		numberFormatter = java.text.NumberFormat.getNumberInstance(aLocale);
          		//quantity = numberFormatter.format(itemp);
          		quantity = numberFormatter.format(dtemp);
            }
      	}
        String catname = prodName;
        String catdescription = "";        
		String showCR = "false";           
        String prodNum = ""; 
        String type = "";
        if( (catid != null) && !catid.equals("null") && !catid.equals("")) {
            CatalogEntryDescriptionAccessBean catalogAB = new CatalogEntryDescriptionAccessBean();
            catalogAB.setInitKey_catalogEntryReferenceNumber(catid);
            catalogAB.setInitKey_language_id(lang);
             
            catname = UIUtil.toHTML(catalogAB.getName());
            catdescription = UIUtil.toHTML(catalogAB.getShortDescription());            
            CatalogEntryAccessBean dbCatentry = new CatalogEntryAccessBean();            	
            dbCatentry.setInitKey_catalogEntryReferenceNumber(catid);
            type = dbCatentry.getType().trim();
            
			if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_ITEMBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeitem");
			if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PRODUCTBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeproduct");	
			if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PACKAGEBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeprebuiltkit");	
			if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypedynamickit");				
	 
            
            prodNum = dbCatentry.getPartNumber();
		            
        }
		if (unitid != null && !unitid.equals("")) {
            QuantityUnitDescriptionAccessBean unitA = new QuantityUnitDescriptionAccessBean();
            unitA.setInitKey_language_id(lang);
            unitA.setInitKey_quantityUnitId(unitid);
            unit = unitA.getDescription();
		}
		String prodCanBeSubstituted = "";
        if (prodChangeable.equals(RFQConstants.EC_RFQ_PRODUCT_CHANGEABLE_YES.toString())) {
            prodCanBeSubstituted = (String)rfqNLS.get("yes");
        } else {
            prodCanBeSubstituted = (String)rfqNLS.get("no");
        }
        
if (categoryIdent.equals(prodCategoryId) && !header) {   
		
%>	
<b><%= rfqNLS.get("rfqproductpercentagepriceinfo") %></b>
    <%= comm.startDlistTable((String)rfqNLS.get("rfqproductpercentagepriceinfo")) %>
    <%= comm.startDlistRowHeading() %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqprodname"),"none",false,"20%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("product_partno"),"none",false,"22%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("description"),"none",false,"22%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqproducttype"),"none",false,"12%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqpriceadjustment"),"none",false,"12%" ) %>
<%  if (endresult.equals((String)rfqNLS.get("order"))) { %>    
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("quantity"),"none",false,"12%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqunits"),"none",false,"12%" ) %>    
<% } %>    
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("productcanbesubstituted"),"none",false,"15%" ) %>
    <%= comm.endDlistRowHeading() %>
	
<%
	header = true;
}

if (categoryIdent.equals(prodCategoryId) && header) { 
%>
    <%= comm.startDlistRow(rowselect) %>
    <%= comm.addDlistColumn(catname,"javascript:goToProduct("+rfqid+","+rfqProdId+","+showCR+")") %>  
    <%= comm.addDlistColumn(prodNum,"none") %>
    <%= comm.addDlistColumn(catdescription,"none") %>    
    <%= comm.addDlistColumn(type,"none") %>
    <%= comm.addDlistColumn(ppAdjust + " " + strPercentage,"none") %>    
<%  if (endresult.equals((String)rfqNLS.get("order"))) { %>     
    <%= comm.addDlistColumn(quantity,"none") %>
    <%= comm.addDlistColumn(unit,"none") %>  
<% } %>    
    <%= comm.addDlistColumn(prodCanBeSubstituted,"none") %>
    <%= comm.endDlistRow() %>
<%
    	if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }
    }//end for
    }
%>
    <%= comm.endDlistTable() %>
    
<%
}
%>
<!-- end Percentage Pricing on Products -->	

<!-- Start Fixed Pricing on Products table -->
<%
    prodList.setRFQId(rfqid);
    
    negotiationTypes = new Integer[1];
    //get fixed pricing on Items, Products and Pre-built kits(Packages)
    negotiationTypes[0] = new Integer (1);                              
    prodList.setNegotiationTypes(negotiationTypes);    
                  
    com.ibm.commerce.beans.DataBeanManager.activate(prodList, request);
    com.ibm.commerce.utf.beans.RFQProdDataBean [] pListFP = prodList.getRFQProds();
	header = false;	
if (pListFP != null && pListFP.length > 0 ) { 	


     for (int i = 0; pListFP != null && i < pListFP.length; i++) {
		RFQProdDataBean aPList = pListFP[i];
		String catid = aPList.getCatentryId();
		String quantity = aPList.getQuantity();
		String price = aPList.getPrice();
		BigDecimal price_ejb = aPList.getPriceInEntityType();
		String currency = aPList.getCurrency();
		String unitid = aPList.getQtyUnitId();
		String prodName = UIUtil.toHTML(aPList.getRfqProductName());
		String rfqProdId = aPList.getRfqprodId();
		String prodChangeable = aPList.getChangeable();
		String unit = "";
		FormattedMonetaryAmount fmt = null;
		CurrencyManager cm = CurrencyManager.getInstance();
		String currencyCode = cm.getDefaultCurrency(storeAB, langId); 
		String categoryIdent = aPList.getRfqCategryId();  

		if ( !price.equals("") && price != null ) {
	    	price_ejb = new BigDecimal(price);
	    	if (price_ejb.doubleValue() >= 0 ) {
				fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(price_ejb, currencyCode), storeAB, langId);
				price = fmt.getFormattedValue();  // price without prefix and postfix
	    	}
		}
      	if (quantity != null && quantity.length() > 0) {
            Double dtemp = Double.valueOf(quantity);
            //Integer itemp = new Integer(dtemp.intValue());
            java.text.NumberFormat numberFormatter;
            //if (itemp.intValue() >= 0) 
            if (dtemp != null && dtemp.doubleValue() >= 0) {
          		numberFormatter = java.text.NumberFormat.getNumberInstance(aLocale);
          		//quantity = numberFormatter.format(itemp);
          		quantity = numberFormatter.format(dtemp);
            }
      	}
        String catname = prodName;
        String catdescription = "";        
		String showCR = "false";           
        String prodNum = ""; 
        String type = ""; 
        if( (catid != null) && !catid.equals("null") && !catid.equals("")) {
            CatalogEntryDescriptionAccessBean catalogAB = new CatalogEntryDescriptionAccessBean();
            catalogAB.setInitKey_catalogEntryReferenceNumber(catid);
            catalogAB.setInitKey_language_id(lang);
            catname = UIUtil.toHTML(catalogAB.getName());
            catdescription = UIUtil.toHTML(catalogAB.getShortDescription());            
            CatalogEntryAccessBean dbCatentry = new CatalogEntryAccessBean();            	
            dbCatentry.setInitKey_catalogEntryReferenceNumber(catid);
            
            type = dbCatentry.getType().trim();
            
			if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_ITEMBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeitem");
			if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PRODUCTBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeproduct");	
			if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PACKAGEBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeprebuiltkit");	
			if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypedynamickit");				
	 
            
            prodNum = dbCatentry.getPartNumber();
	            
        }
		if (unitid != null && !unitid.equals("")) {
            QuantityUnitDescriptionAccessBean unitA = new QuantityUnitDescriptionAccessBean();
            unitA.setInitKey_language_id(lang);
            unitA.setInitKey_quantityUnitId(unitid);
            unit = unitA.getDescription();
		}
		String prodCanBeSubstituted = "";
        if (prodChangeable.equals(RFQConstants.EC_RFQ_PRODUCT_CHANGEABLE_YES.toString())) {
            prodCanBeSubstituted = (String)rfqNLS.get("yes");
        } else {
            prodCanBeSubstituted = (String)rfqNLS.get("no");
        }
        
if (categoryIdent.equals(prodCategoryId) && !header) {   

%>
<br />
<b><%= rfqNLS.get("rfqproductfixedpriceinfo") %></b>
    <%= comm.startDlistTable((String)rfqNLS.get("rfqproductfixedpriceinfo")) %>
    <%= comm.startDlistRowHeading() %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqprodname"),"none",false,"16%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("product_partno"),"none",false,"11%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("description"),"none",false,"18%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqproducttype"),"none",false,"12%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("price"),"none",false,"8%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("currency"),"none",false,"7%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("quantity"),"none",false,"8%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqunits"),"none",false,"8%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("productcanbesubstituted"),"none",false,"26%" ) %>
    <%= comm.endDlistRowHeading() %>
	
<%	
 	header = true;
}

if (categoryIdent.equals(prodCategoryId) && header) {    
%>
    <%= comm.startDlistRow(rowselect) %>
    <%= comm.addDlistColumn(catname,"javascript:goToProduct("+rfqid+","+rfqProdId+","+showCR+")") %>  
    <%= comm.addDlistColumn(prodNum,"none") %>
    <%= comm.addDlistColumn(catdescription,"none") %>    
    <%= comm.addDlistColumn(type,"none") %>
    <%= comm.addDlistColumn(price,"none") %>
    <%= comm.addDlistColumn(currency,"none") %>
    <%= comm.addDlistColumn(quantity,"none") %>
    <%= comm.addDlistColumn(unit,"none") %>
    <%= comm.addDlistColumn(prodCanBeSubstituted,"none") %>
    <%= comm.endDlistRow() %>
<%
    	if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }
    }//end for
    }
    
%>
    <%= comm.endDlistTable() %>
    
<%

}
%>
<!-- end Fixed Pricing on Products -->					

<!-- Start Percentage Pricing on Dynamic kits -->
<%
    prodList.setRFQId(rfqid);

    negotiationTypes = new Integer[1];
    //get percentage pricing on dynamic kits
    negotiationTypes[0] = new Integer (4);                              
    prodList.setNegotiationTypes(negotiationTypes);    
                  
    com.ibm.commerce.beans.DataBeanManager.activate(prodList, request);
    com.ibm.commerce.utf.beans.RFQProdDataBean [] pListPPDK = prodList.getRFQProds();
	header = false;
if (pListPPDK != null && pListPPDK.length > 0 ) { 	
	
    
    for (int i = 0; pListPPDK != null && i < pListPPDK.length; i++) {
		RFQProdDataBean aPList = pListPPDK[i];
		String catid = aPList.getCatentryId();
		String quantity = aPList.getQuantity();
		String price = aPList.getPrice();
		BigDecimal price_ejb = aPList.getPriceInEntityType();
		String currency = aPList.getCurrency();
		String unitid = aPList.getQtyUnitId();
		String prodName = UIUtil.toHTML(aPList.getRfqProductName());
		String rfqProdId = aPList.getRfqprodId();
		String prodChangeable = aPList.getChangeable();		
		String ppAdjust = aPList.getPriceAdjustment();
		if (ppAdjust != null && ppAdjust.length() > 0) 
		{
            	    Double ptemp = Double.valueOf(ppAdjust);
            	    java.text.NumberFormat numberFormatter;
            	    if (ptemp != null && ptemp.doubleValue() <= 0) 
            	    {
          	    	numberFormatter = java.text.NumberFormat.getNumberInstance(aLocale);
          	    	ppAdjust = numberFormatter.format(ptemp);
		    }
		}
		String categoryIdent = aPList.getRfqCategryId(); 
		
		String unit = "";
		FormattedMonetaryAmount fmt = null;
		CurrencyManager cm = CurrencyManager.getInstance();
		String currencyCode = cm.getDefaultCurrency(storeAB, langId);   

		if ( !price.equals("") && price != null ) {
	    	price_ejb = new BigDecimal(price);
	    	if (price_ejb.doubleValue() >= 0 ) {
				fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(price_ejb, currencyCode), storeAB, langId);
				price = fmt.getFormattedValue();  // price without prefix and postfix
	    	}
		}
      	if (quantity != null && quantity.length() > 0) {
            Double dtemp = Double.valueOf(quantity);
            //Integer itemp = new Integer(dtemp.intValue());
            java.text.NumberFormat numberFormatter;
            //if (itemp.intValue() >= 0) 
            if (dtemp != null && dtemp.doubleValue() >= 0) {
          		numberFormatter = java.text.NumberFormat.getNumberInstance(aLocale);
          		//quantity = numberFormatter.format(itemp);
          		quantity = numberFormatter.format(dtemp);
            }
      	}
        String catname = prodName;
        String catdescription = "";        
		String showCR = "false";           
        String prodNum = ""; 
        String type = "";
        if( (catid != null) && !catid.equals("null") && !catid.equals("")) {
            CatalogEntryDescriptionAccessBean catalogAB = new CatalogEntryDescriptionAccessBean();
            catalogAB.setInitKey_catalogEntryReferenceNumber(catid);
            catalogAB.setInitKey_language_id(lang);
             
            catname = UIUtil.toHTML(catalogAB.getName());
            catdescription = UIUtil.toHTML(catalogAB.getShortDescription());            
            CatalogEntryAccessBean dbCatentry = new CatalogEntryAccessBean();            	
            dbCatentry.setInitKey_catalogEntryReferenceNumber(catid);
            type = dbCatentry.getType().trim();
            
			if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_ITEMBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeitem");
			if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PRODUCTBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeproduct");	
			if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PACKAGEBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeprebuiltkit");	
			if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypedynamickit");				
	 
            
            prodNum = dbCatentry.getPartNumber();
		            
        }
		if (unitid != null && !unitid.equals("")) {
            QuantityUnitDescriptionAccessBean unitA = new QuantityUnitDescriptionAccessBean();
            unitA.setInitKey_language_id(lang);
            unitA.setInitKey_quantityUnitId(unitid);
            unit = unitA.getDescription();
		}
		String prodCanBeSubstituted = "";
        if (prodChangeable.equals(RFQConstants.EC_RFQ_PRODUCT_CHANGEABLE_YES.toString())) {
            prodCanBeSubstituted = (String)rfqNLS.get("yes");
        } else {
            prodCanBeSubstituted = (String)rfqNLS.get("no");
        }
if (categoryIdent.equals(prodCategoryId) && !header) {   

%>
<br />
<b><%= rfqNLS.get("rfqdynamickitpercentagepriceinfo") %></b>
    <%= comm.startDlistTable((String)rfqNLS.get("rfqdynamickitpercentagepriceinfo")) %>
    <%= comm.startDlistRowHeading() %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqdynamickitname"),"none",false,"20%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("product_partno"),"none",false,"22%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("description"),"none",false,"22%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqpriceadjustment"),"none",false,"12%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("productcanbesubstituted"),"none",false,"15%" ) %>
    <%= comm.endDlistRowHeading() %>
	
<%	
 	header = true;
}

if (categoryIdent.equals(prodCategoryId) && header) {  
%>
    <%= comm.startDlistRow(rowselect) %>
    <%= comm.addDlistColumn(catname,"javascript:goToConfigurationReport("+rfqid+","+rfqProdId+")") %>  
    <%= comm.addDlistColumn(prodNum,"none") %>
    <%= comm.addDlistColumn(catdescription,"none") %>    
    <%= comm.addDlistColumn(ppAdjust+ " " + strPercentage,"none") %>    
    <%= comm.addDlistColumn(prodCanBeSubstituted,"none") %>
    <%= comm.endDlistRow() %>
<%
    	if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }
    }//end for
    }
%>
    <%= comm.endDlistTable() %>
    
<%
}
%>


<!-- end Percentage Pricing on Dynamic Kits -->	

<!-- Start Fixed Pricing on Dynamic Kits -->
<%
    prodList.setRFQId(rfqid);
    
    negotiationTypes = new Integer[1];
    //get fixed pricing on dynamic kits
    negotiationTypes[0] = new Integer (3);                              
    prodList.setNegotiationTypes(negotiationTypes);    
                  
    com.ibm.commerce.beans.DataBeanManager.activate(prodList, request);
    com.ibm.commerce.utf.beans.RFQProdDataBean [] pListFPDK = prodList.getRFQProds();
	header = false;
if (pListFPDK != null && pListFPDK.length > 0 ) { 
		
    
    for (int i = 0; pListFPDK != null && i < pListFPDK.length; i++) {
		RFQProdDataBean aPList = pListFPDK[i];
		String catid = aPList.getCatentryId();
		String quantity = aPList.getQuantity();
		String price = aPList.getPrice();
		BigDecimal price_ejb = aPList.getPriceInEntityType();
		String currency = aPList.getCurrency();
		String unitid = aPList.getQtyUnitId();
		String prodName = UIUtil.toHTML(aPList.getRfqProductName());
		String rfqProdId = aPList.getRfqprodId();
		String prodChangeable = aPList.getChangeable();
		String unit = "";
		FormattedMonetaryAmount fmt = null;
		CurrencyManager cm = CurrencyManager.getInstance();
		String currencyCode = cm.getDefaultCurrency(storeAB, langId);   
		String categoryIdent = aPList.getRfqCategryId(); 
		
		if ( !price.equals("") && price != null ) {
	    	price_ejb = new BigDecimal(price);
	    	if (price_ejb.doubleValue() >= 0 ) {
				fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(price_ejb, currencyCode), storeAB, langId);
				price = fmt.getFormattedValue();  // price without prefix and postfix
	    	}
		}
      	if (quantity != null && quantity.length() > 0) {
            Double dtemp = Double.valueOf(quantity);
            //Integer itemp = new Integer(dtemp.intValue());
            java.text.NumberFormat numberFormatter;
            //if (itemp.intValue() >= 0) 
            if (dtemp != null && dtemp.doubleValue() >= 0) {
          		numberFormatter = java.text.NumberFormat.getNumberInstance(aLocale);
          		//quantity = numberFormatter.format(itemp);
          		quantity = numberFormatter.format(dtemp);
            }
      	}
        String catname = prodName;
        String catdescription = "";        
		String showCR = "false";           
        String prodNum = ""; 
        String type = ""; 
        if( (catid != null) && !catid.equals("null") && !catid.equals("")) {
            CatalogEntryDescriptionAccessBean catalogAB = new CatalogEntryDescriptionAccessBean();
            catalogAB.setInitKey_catalogEntryReferenceNumber(catid);
            catalogAB.setInitKey_language_id(lang);
            catname = UIUtil.toHTML(catalogAB.getName());
            catdescription = UIUtil.toHTML(catalogAB.getShortDescription());            
            CatalogEntryAccessBean dbCatentry = new CatalogEntryAccessBean();            	
            dbCatentry.setInitKey_catalogEntryReferenceNumber(catid);
            
            type = dbCatentry.getType().trim();
            
			if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_ITEMBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeitem");
			if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PRODUCTBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeproduct");	
			if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PACKAGEBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeprebuiltkit");	
			if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypedynamickit");				
	 
            
            prodNum = dbCatentry.getPartNumber();
	            
        }
		if (unitid != null && !unitid.equals("")) {
            QuantityUnitDescriptionAccessBean unitA = new QuantityUnitDescriptionAccessBean();
            unitA.setInitKey_language_id(lang);
            unitA.setInitKey_quantityUnitId(unitid);
            unit = unitA.getDescription();
		}
		String prodCanBeSubstituted = "";
        if (prodChangeable.equals(RFQConstants.EC_RFQ_PRODUCT_CHANGEABLE_YES.toString())) {
            prodCanBeSubstituted = (String)rfqNLS.get("yes");
        } else {
            prodCanBeSubstituted = (String)rfqNLS.get("no");
        }
if (categoryIdent.equals(prodCategoryId) && !header) { 

%>
<br />
<b><%= rfqNLS.get("rfqdynamickitfixedpriceinfo") %></b>
    <%= comm.startDlistTable((String)rfqNLS.get("rfqdynamickitfixedpriceinfo")) %>
    <%= comm.startDlistRowHeading() %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqdynamickitname"),"none",false,"20%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("product_partno"),"none",false,"22%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("description"),"none",false,"22%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("price"),"none",false,"12%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("currency"),"none",false,"7%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("quantity"),"none",false,"12%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqunits"),"none",false,"12%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("productcanbesubstituted"),"none",false,"15%" ) %>
    <%= comm.endDlistRowHeading() %>
	
<%	 
 	header = true;
}

if (categoryIdent.equals(prodCategoryId) && header) { 
%>
    <%= comm.startDlistRow(rowselect) %>
    <%= comm.addDlistColumn(catname,"javascript:goToConfigurationReport("+rfqid+","+rfqProdId+")") %>    
    <%= comm.addDlistColumn(prodNum,"none") %>
    <%= comm.addDlistColumn(catdescription,"none") %>    
    <%= comm.addDlistColumn(price,"none") %>
    <%= comm.addDlistColumn(currency,"none") %>
    <%= comm.addDlistColumn(quantity,"none") %>
    <%= comm.addDlistColumn(unit,"none") %>
    <%= comm.addDlistColumn(prodCanBeSubstituted,"none") %>
    <%= comm.endDlistRow() %>
<%
    	if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }
    }//end for
    }
%>
    <%= comm.endDlistTable() %>
    
<%
}
%>

    
<!-- end Fixed Pricing on Dynamic Kits -->	      
    
    
    
</form>


</body>
</html>
