<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
	import="com.ibm.commerce.tools.campaigns.CampaignConstants,
	com.ibm.commerce.tools.campaigns.CatalogSearchDataBean,
	com.ibm.commerce.tools.campaigns.CatalogSearchListDataBean,
	com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@ include file="common.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get("ProductSearchBrowserTitle") %></title>

<%
	Locale jLocale = campaignCommandContext.getLocale();
	String orderByParm = request.getParameter("orderby");

	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;
%>

<%-- Drop the search databean on the page --%>
<jsp:useBean id="mySPLB" scope="request" class="com.ibm.commerce.tools.campaigns.CatalogSearchListDataBean">
<jsp:setProperty name="mySPLB" property="*" />
<%
	mySPLB.setIndexBegin("" + startIndex);
	mySPLB.setIndexEnd("" + endIndex);
	com.ibm.commerce.beans.DataBeanManager.activate(mySPLB, request);
%>
</jsp:useBean>

<%
	int myCount = mySPLB.getResultSetSize();
	int rowselect = 1;
	int totalsize = myCount;
	int totalpage = totalsize/listSize;
%>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
var resultLimit = "<%=UIUtil.toJavaScript( request.getParameter("resultLimit") )%>";
var resultContainer = new Array();
var currentArray = top.getData("currentArray", null);
if (currentArray == null) {
	currentArray = new Array();
}

// called when add button is clicked
function performAdd () {
	// put the sku's into an array in the model and set a flag
	var skuArray = new Array();

	// check if no checkboxes has been selected, or checked boxes exceeds allowed result limit
	if ((resultLimit == "single") && (currentArray.length == 0)) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("pleaseSelectOneSKU")) %>");
		return;
	}
	if ((resultLimit == "single") && (currentArray.length > 1)) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("pleaseSelectAtMostOneSKU")) %>");
		return;
	}
	if ((resultLimit == "multiple") && (currentArray.length == 0)) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("pleaseSelectAtLeastOneSKU")) %>");
		return;
	}

	if (currentArray.length > 0) {
		for (var i=0; i<currentArray.length; i++) {
			// because this is a SDL, we don't have direct access to the model
			// we need to get the model from the "top" using getModel, and directly
			// add our flags.
			skuArray[i] = new Object();
			skuArray[i].productId = trim(currentArray[i].productId);
			skuArray[i].productSku = trim(currentArray[i].productSku);
			skuArray[i].productEncodedSku = trim(currentArray[i].productEncodedSku);
			skuArray[i].productName = trim(currentArray[i].productName);
			skuArray[i].displayText = trim(currentArray[i].productName) + " (" + trim(currentArray[i].productSku) + ")";
		}
	}

	if (skuArray.length > 0) {
		// because this is a SDL, we don't have direct access to the model
		// we need to get the model from the "top" using getModel, and directly
		// add our flags.
		top.sendBackData(skuArray, "productSearchSkuArray");
		top.saveData(null, "currentArray");

		// go back to the finder's caller!
		top.goBack();
	}
}

// called when cancel button is clicked
function performCancel () {
	var urlparm = new Object();
	urlparm.srPartNumber = "<%= UIUtil.toJavaScript(request.getParameter("srPartNumber")) %>";
	urlparm.srName = "<%= UIUtil.toJavaScript(request.getParameter("srName")) %>";
	urlparm.srShortDescription = "<%= UIUtil.toJavaScript(request.getParameter("srShortDescription")) %>";
	urlparm.srPartNumberType = "<%=UIUtil.toJavaScript( request.getParameter("srPartNumberType") )%>";
	urlparm.srNameType = "<%=UIUtil.toJavaScript( request.getParameter("srNameType") )%>";
	urlparm.srShortDescriptionType = "<%=UIUtil.toJavaScript( request.getParameter("srShortDescriptionType") )%>";
	top.setContent("<%= UIUtil.toJavaScript(campaignsRB.get("productFindPanelTitle")) %>", "<%= UIUtil.getWebappPath(request) %>CampaignProductFindDialogView?XMLFile=campaigns.ProductFindDialog", false, urlparm);
}

// called when a checkbox is clicked
function performUpdate (isAll, checkObject) {
	var newIndex;
	var resultFound = false;

	if (isAll) {
		for (var i=0; i<resultContainer.length; i++) {
			for (var j=0; j<currentArray.length; j++) {
				// case 1: if deselect and current entry found, remove current entry
				// case 2: if select and current entry found, do nothing
				if (currentArray[j] != null) {
					if (resultContainer[i].productId == currentArray[j].productId) {
						resultFound = true;
						if (!checkObject.checked) {
							currentArray[j] = null;
							break;
						}
					}
				}
			}
			// case 3: if select and current entry not found, add current entry
			// case 4: if deselect and current entry not found, do nothing
			if (!resultFound) {
				if (checkObject.checked) {
					newIndex = currentArray.length;
					currentArray[newIndex] = new Object();
					currentArray[newIndex] = resultContainer[i];
				}
			}
			else {
				resultFound = false;
			}
		}
	}
	else {
		if (checkObject.checked) {
			for (var i=0; i<resultContainer.length; i++) {
				if (resultContainer[i].productId == checkObject.name) {
					newIndex = currentArray.length;
					currentArray[newIndex] = new Object();
					currentArray[newIndex] = resultContainer[i];
					break;
				}
			}
		}
		else {
			for (var i=0; i<currentArray.length; i++) {
				if (currentArray[i].productId == checkObject.name) {
					currentArray[i] = null;
					break;
				}
			}
		}
	}

	var tempArray = new Array();
	for (var i=0; i<currentArray.length; i++) {
		if (currentArray[i] != null) {
			tempArray[tempArray.length] = currentArray[i];
		}
	}
	currentArray = tempArray;

	top.saveData(currentArray, "currentArray");
}

function getResultsSize () {
	return <%= myCount %>;
}

function onLoad () {
	parent.loadFrames();
}
//-->
</script>
</head>

<body onload="onLoad();" class="content_list">

<script language="JavaScript">
<!-- hide script from old browsers
var resultIndex = 0;
<%	for (int i=0; i<mySPLB.getCatalogList().length; i++) { %>
resultContainer[resultIndex] = new Object();
resultContainer[resultIndex].productId = "<%= mySPLB.getCatalogList()[i].getId() %>";
resultContainer[resultIndex].productSku = "<%= UIUtil.toJavaScript(mySPLB.getCatalogList()[i].getIdentifier()) %>";
resultContainer[resultIndex].productEncodedSku = "<%= UIUtil.toJavaScript(mySPLB.getCatalogList()[i].getEncodedIdentifier()) %>";
resultContainer[resultIndex].productName = "<%= UIUtil.toJavaScript(mySPLB.getCatalogList()[i].getName()) %>";
resultIndex++;
<%	} %>
//-->
</script>

<%= comm.addControlPanel("campaigns.ProductSearchList", totalpage, totalsize, jLocale) %>
<form name="productSearchForm" id="productSearchForm">
<%= comm.startDlistTable((String)campaignsRB.get("ProductSearchSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true, "parent.selectDeselectAll();performUpdate(true, this);") %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("productFindSkuSearchString"), CatalogSearchListDataBean.ORDER_BY_PRODUCT_CODE, CatalogSearchListDataBean.ORDER_BY_PRODUCT_CODE.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("productFindName"), CatalogSearchListDataBean.ORDER_BY_PRODUCT_NAME, CatalogSearchListDataBean.ORDER_BY_PRODUCT_NAME.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("productFindShortDesc"), CatalogSearchListDataBean.ORDER_BY_PRODUCT_SHORTDESC, CatalogSearchListDataBean.ORDER_BY_PRODUCT_SHORTDESC.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("productFindType"), CatalogSearchListDataBean.ORDER_BY_PRODUCT_TYPE, CatalogSearchListDataBean.ORDER_BY_PRODUCT_TYPE.equals(orderByParm)) %>
<%= comm.endDlistRow() %>
<%
	if (endIndex > myCount) {
		endIndex = myCount;
	}

	for (int i=0; i<mySPLB.getCatalogList().length; i++) {
		CatalogSearchDataBean mySPDB = mySPLB.getCatalogList()[i];
%>
<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(mySPDB.getId(), "parent.setChecked();performUpdate(false, this);", mySPDB.getId()) %>
<%= comm.addDlistColumn(UIUtil.toHTML(mySPDB.getIdentifier()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(mySPDB.getName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(mySPDB.getShortDescription()), "none") %>
<%		if (mySPDB.getType().trim().equals(CatalogSearchListDataBean.CATENTRY_TYPE_PRODUCT)) { %>
<%= comm.addDlistColumn((String)campaignsRB.get("productFindProductTypeProduct"), "none") %>
<%		} else if (mySPDB.getType().trim().equals(CatalogSearchListDataBean.CATENTRY_TYPE_ITEM)) { %>
<%= comm.addDlistColumn((String)campaignsRB.get("productFindProductTypeItem"), "none") %>
<%		} else if (mySPDB.getType().trim().equals(CatalogSearchListDataBean.CATENTRY_TYPE_PACKAGE)) { %>
<%= comm.addDlistColumn((String)campaignsRB.get("productFindProductTypePackage"), "none") %>
<%		} else if (mySPDB.getType().trim().equals(CatalogSearchListDataBean.CATENTRY_TYPE_BUNDLE)) { %>
<%= comm.addDlistColumn((String)campaignsRB.get("productFindProductTypeBundle"), "none") %>
<%		} else if (mySPDB.getType().trim().equals(CatalogSearchListDataBean.CATENTRY_TYPE_DYNAMIC_KIT)) { %>
<%= comm.addDlistColumn((String)campaignsRB.get("productFindProductTypeDynamicKit"), "none") %>
<%		} else { %>
<%= comm.addDlistColumn("", "none") %>
<%		} %>
<%= comm.endDlistRow() %>
<%
		if (rowselect == 1) {
			rowselect = 2;
		}
		else {
			rowselect = 1;
		}
	}
%>
<%= comm.endDlistTable() %>

<%	if (myCount == 0) { %>
<p/><p/>
<%= campaignsRB.get("ProductSearchEmpty") %>
<%	} %>

</form>

<script language="JavaScript">
<!-- hide script from old browsers
parent.afterLoads();
parent.setResultssize(getResultsSize());
//-->
</script>

</body>

</html>
