<!-- 
========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
========================================================================
-->  
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogGroupCatalogEntryRelationAccessBean" %>
<%@ page import="com.ibm.commerce.catalog.beans.ProductDataBean" %>
<%@ page import="com.ibm.commerce.catalog.beans.CategoryDataBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogAccessBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogEntryDescriptionAccessBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogEntryAccessBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogGroupDescriptionAccessBean" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.common.beans.LanguageDescriptionDataBean"%>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@ page import="com.ibm.commerce.rfq.utils.RFQConstants"%>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="../common/List.jsp" %>
<%@ include file="../catalog/CatalogSearchUtil.jsp" %>
<%
    CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
    Locale localeUsed = cmdContext.getLocale();
    // obtain the resource bundle for display
    Hashtable rfq2NLS = (Hashtable)ResourceDirectory.lookup("inventory.VendorPurchaseNLS", localeUsed   );
    Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS", localeUsed   );
    // Set up the search bean results.
    CatalogEntryDataBean bnEntries[] = null;
    CatalogEntryDataBean bnEntry;
    int totalsize = 0; 
    if (catEntrySearchDB != null) {
	bnEntries = catEntrySearchDB.getResultList();
    }
    if (bnEntries != null) {
        totalsize = bnEntries.length;
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%= fHeader%>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(localeUsed) %>" type="text/css" />
<title></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>

<script type="text/javascript">
<!---- hide script from old browsers
function substituteProduct() {
	var urlParams = new Object();
	var catentryId = getCheckedValue("catentryId");
	var partNumber = getCheckedValue("partNumber") ;
	var prodName = getCheckedValue("name") ;
	var prodType =  getCheckedValue("type") ;
	var prodDesc =  getCheckedValue("description") ;
	urlParams.catentryId = catentryId;
	urlParams.partNumber = partNumber;
	urlParams.prodName = prodName;
	urlParams.prodType = prodType;
	urlParams.prodDesc = prodDesc;
	top.mccbanner.counter --;
	top.mccbanner.counter --;
	top.mccbanner.showbct();
	top.showContent(top.mccbanner.trail[top.mccbanner.counter].location, urlParams);
}

function findAction() {
	top.goBack();
}
function cancelAction() {
	top.goBack(2);
}
function getNewBCT1() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfqresponse")) %>";
}
function onLoad() {
	parent.loadFrames()
	if (parent.parent.setContentFrameLoaded) {
		parent.parent.setContentFrameLoaded(true);
	}
	//getSearchCriteria();
}
function getCheckedValue(value) {
	var checkValues = parent.getChecked();
	var valueArray = checkValues[0].split(",");
	var catentryId  = valueArray[0];
	var partNumber = valueArray[1];
	var name = valueArray[2];
	var type =  valueArray[3];
	var description = valueArray[4];
	if (value == "catentryId") {
    	    return catentryId;   
    	} else if ( value == "partNumber" ) {
    	    return partNumber ;    
    	} else if ( value == "name" ) {
  	    return name ;    
    	} else if (value == "type") {
   	    return type ;      
    	} else if (value == "description") {
   	    return description ;      
    	}
}
function getResultsize() {
   	return <%=totalsize%>; 
}
// -->
</script>

</head>

<body onload="onLoad()" class="content">
<%
    if ( totalsize != 0 ) {
%>
<br />
<%= rfqNLS.get("instruction_SubstituteProduct") %>
<%
    }
    int startIndex = Integer.parseInt(request.getParameter("startindex"));
    int listSize = Integer.parseInt(request.getParameter("listsize"));
    int endIndex = startIndex + listSize;
    if (endIndex > totalsize) {
      	endIndex = totalsize;
    }
    int totalpage = totalsize/listSize;
    int rowselect = 1;
%>

<%=comm.addControlPanel("rfq.rfqResponseCatentrySearchResult", totalpage, totalsize, localeUsed )%>

<form name="itemSearchResults" action="">
<%=addHiddenVars()%>
				
<%= comm.startDlistTable((String)rfq2NLS.get("itemSearchResultTableSum")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("product_partno"), null, false )%>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqproducttype"), null, false )%>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("product_name"), null, false  )%>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("product_desc"), null, false )%>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("catalogSearch_manufacturer_partnumber"), null, false )%>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("product_manufacturer"), null, false )%>

<%= comm.endDlistRow() %>

<!-- Need to have a for loop to look for all the catentries -->
<%
    if (bnEntries != null) {
        for (int i=startIndex; i<endIndex; i++) {
            bnEntry = bnEntries[i];
            bnEntry.setCommandContext(cmdContext);
            CatalogEntryDescriptionAccessBean abDescription = bnEntry.getDescription();

	    String catentryType = bnEntry.getType().trim();
	    String productType = "";
	    if (catentryType.equals(RFQConstants.EC_OFFERING_ITEMBEAN)) 
	    {
	    	productType = (String)rfqNLS.get("rfqproductrequesttypeitem");
	    }
	    if (catentryType.equals(RFQConstants.EC_OFFERING_PRODUCTBEAN)) 
	    {
		productType = (String)rfqNLS.get("rfqproductrequesttypeproduct");
	    }	
	    if (catentryType.equals(RFQConstants.EC_OFFERING_PACKAGEBEAN)) 
	    {
		productType = (String)rfqNLS.get("rfqproductrequesttypeprebuiltkit");
	    }
	    if (catentryType.equals(RFQConstants.EC_OFFERING_BUNDLEBEAN)) 
	    {
		productType = (String)rfqNLS.get("rfqproductrequesttypebundle");
	    }				
	    if (catentryType.equals(RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) 
	    {
		productType = (String)rfqNLS.get("rfqproductrequesttypedynamickit");
	    }
%>
<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(bnEntry.getCatalogEntryID() + "," + bnEntry.getPartNumber() + "," + abDescription.getName() + "," + productType + "," + abDescription.getShortDescription(),  "none" ) %>
<%= comm.addDlistColumn( bnEntry.getPartNumber(), "none" ) %> 
<%= comm.addDlistColumn( productType, "none" ) %> 
<%= comm.addDlistColumn( abDescription.getName(), "none" ) %> 
<%= comm.addDlistColumn( abDescription.getShortDescription(), "none" ) %> 
<%= comm.addDlistColumn( bnEntry.getManufacturerPartNumber(), "none" ) %> 
<%= comm.addDlistColumn( bnEntry.getManufacturerName(), "none" ) %> 
<%= comm.endDlistRow() %>
<%
    	    if(rowselect==1) { rowselect = 2; } else { rowselect = 1; }
        }
    }
%>
<%= comm.endDlistTable() %>
<%
    if ( totalsize == 0 ) {
%>
<br />
<%=rfq2NLS.get("searchCriteriaNotMet")%>
<%
    }
%>
<br />
</form>

<script type="text/javascript">
<!---- hide script from old browsers
  parent.afterLoads();
  parent.setResultssize(getResultsize());
  // -->
</script>

</body>
</html>
