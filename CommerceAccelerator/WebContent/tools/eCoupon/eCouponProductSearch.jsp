<!-- ==========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
 ===========================================================================-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page language="java"
import="com.ibm.commerce.tools.ecoupon.ECECouponConstant,
	javax.servlet.*,
	com.ibm.commerce.tools.util.*,
	com.ibm.commerce.marketingcenter.search.helpers.*,
	com.ibm.commerce.tools.common.ui.taglibs.*"%>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.search.beans.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.CompositeCatalogEntryAccessBean" %>

<%@include file="eCouponCommon.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
   <%= feCouponHeader %>
   <title><%= eCouponWizardNLS.get("eCouponProductSearchBrowserTitle") %></title>



   <%
       Locale jLocale = commContext.getLocale();

   %>


<script src="/wcs/javascript/tools/common/Util.js">
</script>
<script src="/wcs/javascript/tools/common/dynamiclist.js">
</script>
<script language="JavaScript">
function onLoad() {
  parent.loadFrames();
}

// called when add button is clicked
function performAdd() {
  // put the sku's into an array in the model and set a flag
  var skuArray = new Array();
  var checked = parent.getChecked();
  //alertDialog(" checked = " + checked);

  if(checked.length >0) {
	for (var i=0; i<checked.length; i++) {
		// because this is a SDL, we don't have direct access to the model
		// we need to get the model from the "top" using getModel, and directly
		// add our flags.
		skuArray[i] = new Object();
		skuArray[i].productSku = checked[i];
		//alertDialog(" Product SKU checked = "+ checked[i]);
		skuArray[i].productName = document.all(checked[i]).value;
	}
  }
  if (skuArray.length > 0) {
      // because this is a SDL, we don't have direct access to the model
      // we need to get the model from the "top" using getModel, and directly
      // add our flags.
      var topModel = top.getModel();
      topModel["productSearchSkuArray"] = skuArray;
      top.sendBackData(skuArray,"productSearchSkuArray");
      top.goBack();

      // go back to the when add page
     // var goBackURL = topModel["finderReturnURL"];
     // var goBackURL=top.getData("finderReturnURL");
      //alertDialog("return URL="+goBackURL);
     // if (goBackURL != null) {
         //alertDialog(" goback URl = " + goBackURL);
	 //top.showContent(goBackURL);
        // parent.location.replace(goBackURL);
      //}
      //else {
      	   //alertDialog("No return URL specified-going back search product page");
	  // top.showContent("/webapp/wcs/tools/servlet/DialogView?XMLFile=eCoupon.eCouponProductFindDialog");
  	   //parent.location.replace("/webapp/wcs/tools/servlet/DialogView?XMLFile=eCoupon.eCouponProductFindDialog");
          // if we dont have a URL, take the user back to the initiative list
          //parent.location.replace(""));
      //}
  }
}

// called when cancel button is clicked
function performCancel() {
	var urlparm = new Object();
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=eCoupon.eCouponProductFindDialog";
	urlparm.srSku = "<%=UIUtil.toJavaScript( request.getParameter("srSku") )%>";
	urlparm.srSkuType = "<%=UIUtil.toJavaScript( request.getParameter("srSkuType") )%>";
	urlparm.srName = "<%=UIUtil.toJavaScript( request.getParameter("srName") )%>";
	urlparm.srNameType = "<%=UIUtil.toJavaScript( request.getParameter("srNameType") )%>";
	urlparm.srShort = "<%=UIUtil.toJavaScript( request.getParameter("srShort") )%>";
	urlparm.srShortType = "<%=UIUtil.toJavaScript( request.getParameter("srShortType") )%>";
	top.setContent("<%= eCouponWizardNLS.get("eCouponProductFindPrompt") %>", url, false, urlparm);
}


// -->

</script>
<meta name="GENERATOR" content="IBM WebSphere Studio" />
</head>

<body onload="onLoad();" class="content_list">
<!-- changes by natwar on 19/08 -->
<%
	// get all the stores found in the catalog store path
	String catalogStoreIds = commContext.getStoreId().toString();
	try {
		Integer relatedStores[] = commContext.getStore().getStorePath(com.ibm.commerce.server.ECConstants.EC_STRELTYP_CATALOG);
		for (int i=0; i<relatedStores.length; i++) {
			catalogStoreIds += " " + relatedStores[i].toString();
		}
	}
	catch (Exception e) {
	}

//	System.out.println("Entering Catalog Search");
	AdvancedCatEntrySearchListDataBean productSearchDB = null;
//	System.out.println("The Identifier was " + request.getParameter("srSku"));
//	System.out.println("The srCatIdentifierType was " + request.getParameter("srSkuType"));
	com.ibm.commerce.catalog.beans.CatalogEntryDataBean[] cdb = null;

	try {
		productSearchDB = new AdvancedCatEntrySearchListDataBean();

		productSearchDB.setSku(request.getParameter("srSku")); //had identifier for category
		productSearchDB.setSkuCaseSensitive("no");
		if (request.getParameter("srSkuType").equals(String.valueOf(ECECouponConstant.TYPE_LIKE_IGNORE_CASE))) {
			productSearchDB.setSkuOperator("LIKE");
		}
		else {
			productSearchDB.setSkuOperator("EQUAL");
		}

		productSearchDB.setName(request.getParameter("srName"));
		productSearchDB.setNameCaseSensitive("no");
		if (request.getParameter("srNameType").equals(String.valueOf(ECECouponConstant.TYPE_LIKE_IGNORE_CASE))) {
			productSearchDB.setNameTermOperator("LIKE");
		}
		else {
			productSearchDB.setNameTermOperator("EQUAL");
			productSearchDB.setNameType("EXACT");
		}

		productSearchDB.setShortDesc(request.getParameter("srShort"));
		productSearchDB.setShortDescCaseSensitive("no");
		if (request.getParameter("srShortType").equals(String.valueOf(ECECouponConstant.TYPE_LIKE_IGNORE_CASE))) {
			productSearchDB.setShortDescOperator("LIKE");
		}
		else {
			productSearchDB.setShortDescOperator("EQUAL");
			productSearchDB.setShortDescType("EXACT");
		}

		productSearchDB.setMarkForDelete("0");
		productSearchDB.setPublished("1");

		//********* Not done - setIsProduct or setIsItem

		// set the page size and start index of the result set
		productSearchDB.setBeginIndex(request.getParameter("startindex"));
		productSearchDB.setPageSize(request.getParameter("listsize"));

		productSearchDB.setStoreIds(catalogStoreIds);
		productSearchDB.setStoreIdOperator("IN");

		com.ibm.commerce.beans.DataBeanManager.activate(productSearchDB, request);
		cdb = productSearchDB.getResultList();
	} catch (Exception ex) {
		//ex.printStackTrace();
	}

	int totalMatches = Integer.parseInt(productSearchDB.getResultCount());
	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;
	int rowselect = 1;
	int totalsize = totalMatches;
	int totalpage = totalsize/listSize;
%>
<%=comm.addControlPanel(request.getParameter("ActionXMLFile"),totalpage,totalsize,jLocale)%>
<form name="productSearchForm" id="productSearchForm">
<%= comm.startDlistTable((String)eCouponWizardNLS.get("eCouponProductSearchSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistColumnHeading("",null,false) %>
<%= comm.addDlistColumnHeading((String)eCouponWizardNLS.get("eCouponProductFindSkuSearchString"), null, false) %>
<%= comm.addDlistColumnHeading((String)eCouponWizardNLS.get("eCouponProductFindName"), null, false) %>
<%= comm.addDlistColumnHeading((String)eCouponWizardNLS.get("eCouponProductFindShortDesc"), null, false) %>
<%= comm.endDlistRow() %>
<%
		if (endIndex > totalMatches) {
			endIndex = totalMatches;
		}

		if (cdb != null) {
			for (int i=0; i<cdb.length; i++) {
				com.ibm.commerce.catalog.beans.CatalogEntryDataBean mycDB = cdb[i];
				com.ibm.commerce.beans.DataBeanManager.activate(mycDB, request);
  // Add : 			if((mySPDB.getCatentryType().trim().equalsIgnoreCase(com.ibm.commerce.marketingcenter.search.helpers.SearchProductDataBean.CATENTRY_TYPE_PRODUCT)) || (mySPDB.getCatentryType().trim().equalsIgnoreCase(com.ibm.commerce.marketingcenter.search.helpers.SearchProductDataBean.CATENTRY_TYPE_ITEM))) {
%>
<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(mycDB.getPartNumber(), "none", mycDB.getCatalogEntryID()) %>
<%= comm.addDlistColumn(UIUtil.toHTML(mycDB.getPartNumber()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(mycDB.getDescription().getName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(mycDB.getDescription().getShortDescription()), "none") %>
<%= comm.endDlistRow() %>
<%
				if (rowselect == 1) {
					rowselect = 2;
				}
				else {
					rowselect = 1;
				}
			}
		}
   // Would need to add closing bracket if add ths additional if 10 lines above

%>
<%= comm.endDlistTable() %>
<%		if (totalMatches == 0) { %>
<p></p><p>
<%= (String)eCouponWizardNLS.get("eCouponProductSearchEmpty") %>
<%		}
 %>
</p></form>
<script>
parent.loadFrames();
parent.afterLoads();
parent.setResultssize(<%=totalMatches%>);

</script>

</body>
</html>
