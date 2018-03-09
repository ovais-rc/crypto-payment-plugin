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
   <title><%= eCouponWizardNLS.get("eCouponCategorySearchBrowserTitle") %></title>



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
function performAdd () {
	// put the sku's into an array in the model and set a flag
	var skuArray = new Array();
	var checked = parent.getChecked();
	var isDuplicate = false;

	if (checked.length > 0) {
		for (var i=0; i<checked.length; i++) {
			// check if the selected category is already existed or not
			var categorySet = top.getData("category", 2);
			for (var j=0; j<categorySet.length; j++) {
				if (categorySet[j].categorySKU == checked[i]) {
					alertDialog("<%= UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponCategorySKUInvalid")) %>");
					isDuplicate = true;
					break;
				}
			}

			// because this is a SDL, we don't have direct access to the model
			// we need to get the model from the "top" using getModel, and directly
			// add our flags.
			if (!isDuplicate) {
				skuArray[i] = new Object();
				skuArray[i].categorySku = checked[i];
				skuArray[i].categoryName = document.all(checked[i]).value;
			}
			else {
				isDuplicate = false;
			}
		}
	}

	if (skuArray.length > 0) {
		// because this is a SDL, we don't have direct access to the model
		// we need to get the model from the "top" using getModel, and directly
		// add our flags.
		var topModel = top.getModel();
		topModel["categorySearchSkuArray"] = skuArray;
		top.sendBackData(skuArray, "categorySearchSkuArray");
		top.goBack();
	}
}

// called when cancel button is clicked
function performCancel() {
	var urlparm = new Object();
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=eCoupon.eCouponCategoryFindDialog";
	urlparm.srSku = "<%=UIUtil.toJavaScript( request.getParameter("srSku") )%>";
	urlparm.srSkuType = "<%=UIUtil.toJavaScript( request.getParameter("srSkuType") )%>";
	urlparm.srName = "<%=UIUtil.toJavaScript( request.getParameter("srName") )%>";
	urlparm.srNameType = "<%=UIUtil.toJavaScript( request.getParameter("srNameType") )%>";
	urlparm.srShort = "<%=UIUtil.toJavaScript( request.getParameter("srShort") )%>";
	urlparm.srShortType = "<%=UIUtil.toJavaScript( request.getParameter("srShortType") )%>";
	top.setContent("<%= eCouponWizardNLS.get("eCouponCategoryFindPrompt") %>", url, false, urlparm);
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
			catalogStoreIds += "," + relatedStores[i].toString();
		}
	}
	catch (Exception e) {
	}

//	System.out.println("Entering Catalog Search");
	CategorySearchListDataBean categorySearchDB = null;
//	System.out.println("The Identifier was " + request.getParameter("srSku"));
//	System.out.println("The srCatIdentifierType was " + request.getParameter("srSkuType"));
	com.ibm.commerce.catalog.beans.CategoryDataBean[] cdb = null;

	try {
		categorySearchDB = new CategorySearchListDataBean();

		categorySearchDB.setIdentifier(request.getParameter("srSku"));
		categorySearchDB.setIdentifierCaseSensitive("no");
		if (request.getParameter("srSkuType").equals(String.valueOf(ECECouponConstant.TYPE_LIKE_IGNORE_CASE))) {
			categorySearchDB.setIdentifierOperator("LIKE");
		}
		else {
			categorySearchDB.setIdentifierOperator("EQUAL");
			categorySearchDB.setIdentifierType("EXACT");
		}

		categorySearchDB.setName(request.getParameter("srName"));
		categorySearchDB.setNameCaseSensitive("no");
		if (request.getParameter("srNameType").equals(String.valueOf(ECECouponConstant.TYPE_LIKE_IGNORE_CASE))) {
			categorySearchDB.setNameTermOperator("LIKE");
		}
		else {
			categorySearchDB.setNameTermOperator("EQUAL");
			categorySearchDB.setNameType("EXACT");
		}

		categorySearchDB.setShortDesc(request.getParameter("srShort"));
		categorySearchDB.setShortDescCaseSensitive("no");
		if (request.getParameter("srShortType").equals(String.valueOf(ECECouponConstant.TYPE_LIKE_IGNORE_CASE))) {
			categorySearchDB.setShortDescOperator("LIKE");
		}
		else {
			categorySearchDB.setShortDescOperator("EQUAL");
			categorySearchDB.setShortDescType("EXACT");
		}

		categorySearchDB.setMarkForDelete("0");
		categorySearchDB.setPublished("1");

		// set the page size and start index of the result set
		categorySearchDB.setBeginIndex(request.getParameter("startindex"));
		categorySearchDB.setPageSize(request.getParameter("listsize"));

		categorySearchDB.setStoreId(catalogStoreIds);
		categorySearchDB.setStoreIdOperator("IN");

		com.ibm.commerce.beans.DataBeanManager.activate(categorySearchDB, request);
		cdb = categorySearchDB.getResultList();
	} catch (Exception ex) {
		//ex.printStackTrace();
	}

	int totalMatches = Integer.parseInt(categorySearchDB.getResultCount());
	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;
	int rowselect = 1;
	int totalsize = totalMatches;
	int totalpage = totalsize/listSize;
%>
<%=comm.addControlPanel(request.getParameter("ActionXMLFile"),totalpage,totalsize,jLocale)%>
<form name="categorySearchForm" id="categorySearchForm">
<%= comm.startDlistTable((String)eCouponWizardNLS.get("eCouponCategorySearchSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistColumnHeading("",null,false) %>
<%= comm.addDlistColumnHeading((String)eCouponWizardNLS.get("eCouponCategoryFindSkuSearchString"), null, false) %>
<%= comm.addDlistColumnHeading((String)eCouponWizardNLS.get("eCouponCategoryFindName"), null, false) %>
<%= comm.addDlistColumnHeading((String)eCouponWizardNLS.get("eCouponCategoryFindShortDesc"), null, false) %>
<%= comm.endDlistRow() %>
<%
		if (endIndex > totalMatches) {
			endIndex = totalMatches;
		}
		if (cdb != null) {
			for (int i=0; i<cdb.length; i++) {
				com.ibm.commerce.catalog.beans.CategoryDataBean mycDB = cdb[i];
				com.ibm.commerce.beans.DataBeanManager.activate(mycDB, request);
%>
<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(mycDB.getIdentifier(), "none", mycDB.getCategoryId()) %>
<%= comm.addDlistColumn(UIUtil.toHTML(mycDB.getIdentifier()), "none") %>
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
%>
<%= comm.endDlistTable() %>
<%		if (totalMatches == 0) { %>
<p></p><p>
<%= (String)eCouponWizardNLS.get("eCouponCategorySearchEmpty") %>
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

