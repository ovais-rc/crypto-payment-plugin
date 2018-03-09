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
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.tools.common.ui.UIProperties" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.CatalogDataBean" %>
<%@ page import="com.ibm.commerce.catalog.beans.CategoryDataBean" %>
<%@ page import="com.ibm.commerce.catalog.beans.ProductDataBean" %>
<%@ page import="com.ibm.commerce.catalog.beans.PackageDataBean" %>
<%@ page import="com.ibm.commerce.catalog.beans.BundleDataBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>

<%
  try {
    Locale aLocale = null;
    CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");  
    if( aCommandContext!= null ) 
    {
     	aLocale = aCommandContext.getLocale();
    }
    Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS", aLocale);

    String lang = aCommandContext.getLanguageId().toString();
    if (lang == null) 
    {
    	lang =  "-1";
    }
 
    String rfqId = request.getParameter("rfqId");   
    String categoryId = request.getParameter("categoryId"); 	    
  
    String requestCatalogId = com.ibm.commerce.utf.utils.RFQProductHelper.getCatalogIdFromXmlFragment(new Long(rfqId));

    String strCatName = "";	
    CategoryDataBean dbSubCategories[] = null;
    CatalogEntryAccessBean[] abCatEntries = null;

    CatalogGroupAccessBean abCatGroup = new CatalogGroupAccessBean ();
    abCatGroup.setInitKey_catalogGroupReferenceNumber (categoryId );

    CategoryDataBean dbCategory = new CategoryDataBean(abCatGroup);
    dbCategory.setCommandContext(aCommandContext);
    dbCategory.setCatalogId(requestCatalogId);

    strCatName = dbCategory.getDescription().getName();
    //dbSubCategories = dbCategory.getSubCategories();
    abCatEntries = dbCategory.getCatalogEntries(new Long(requestCatalogId));
    // ProductDataBean[] abProducts = dbCategory.getProducts();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale)%>" type="text/css" />
<title></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/rfq/rfqUtile.js"></script>  
<script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>

<script type="text/javascript">
  var requestCatalogId = '<%= requestCatalogId %>';
  var categoryId = '<%= UIUtil.toJavaScript(categoryId) %>';
  var catentriesLen = '<%= abCatEntries.length %>';

    function initializeState() 
    {
  	parent.setContentFrameLoaded(true);
    }

    function savePanelData() 
    {
	return true;
    }

    function validatePanelData() 
    {
	return true;
    }
</script>
</head>

<body class="content" onload="initializeState();">

<h1><%= rfqNLS.get("rfqcategorysummary") %></h1>

<table>
    <tr>
	<td><%= rfqNLS.get("rfqcategoryname") %>: <%= strCatName %><br /></td>
    </tr>
</table> 
 


<%
    if (abCatEntries != null && abCatEntries.length > 0) 
    {
%>
   	<br /><b><%= rfqNLS.get("products") %></b>
<script type="text/javascript">
    	startDlistTable("<%= UIUtil.toJavaScript(rfqNLS.get("rfqchildcategory")) %>","100%");
    	startDlistRowHeading();
    	addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("product_code")) %>",true,"18%",null);
    	addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("type")) %>",true,"16%",null);
    	addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("name")) %>",true,"18%",null);
    	addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("rfqproductbuyable")) %>",true,"16%",null);
    	addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("product_manufacturer")) %>",true,"16%",null);
    	addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("product_partno")) %>",true,"16%",null);
    	endDlistRowHeading();

    	var rowselect = 1;
<%
	for (int j = 0; j < abCatEntries.length; ++j) 
	{
	    CatalogEntryAccessBean abCatEntry = new CatalogEntryAccessBean();	
	    abCatEntry.setInitKey_catalogEntryReferenceNumber(abCatEntries[j].getCatalogEntryReferenceNumber());					

	    String type = abCatEntry.getType();
	    if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_ITEMBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeitem");
	    if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PRODUCTBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeproduct");	
	    if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PACKAGEBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeprebuiltkit");	
	    if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_BUNDLEBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypebundle");	
	    if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypedynamickit");
		
	    String buyable = abCatEntry.getBuyable();
	    if (buyable.equals("1")) 
	    {
		buyable = (String)rfqNLS.get("yes");
	    } else {
		buyable = (String)rfqNLS.get("no");
	    }	
				 
	    String description = "";
	    CatalogEntryDescriptionAccessBean catalogAB = new CatalogEntryDescriptionAccessBean();
	    catalogAB.setInitKey_catalogEntryReferenceNumber(abCatEntry.getCatalogEntryReferenceNumber());
	    catalogAB.setInitKey_language_id(lang);
	    if (catalogAB.getShortDescription() != null) 
	    {
		description = catalogAB.getShortDescription();
	    }					
%>
	    startDlistRow(rowselect);			
	    addDlistColumn(ToHTML("<%=abCatEntry.getPartNumber()%>"));
	    addDlistColumn(ToHTML("<%= type %>"));
	    addDlistColumn(ToHTML("<%= description %>"));	
	    addDlistColumn(ToHTML("<%= buyable %>"));
	    addDlistColumn(ToHTML("<%= abCatEntry.getManufacturerName() %>"));
	    addDlistColumn(ToHTML("<%= abCatEntry.getManufacturerPartNumber() %>"));
            endDlistRow();    	

            if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; } 
<% 
	}
%>
    	endDlistTable();
</script>
<% 
    }
%>

<br /><br />

</body>
</html>

<% 
    } catch ( Exception e ) {
	out.println("Error - " + e.toString());
    }
%>
