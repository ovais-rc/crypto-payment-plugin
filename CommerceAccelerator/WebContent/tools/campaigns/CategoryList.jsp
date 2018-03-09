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
	import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.tools.campaigns.CatalogSearchDataBean,
	com.ibm.commerce.tools.campaigns.CatalogSearchListDataBean,
	com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@ include file="common.jsp" %>

<%
	Locale jLocale = campaignCommandContext.getLocale();
	String orderByParm = request.getParameter("orderby");

	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;

	CatalogSearchListDataBean catalogSearchListDataBean = new CatalogSearchListDataBean();
	catalogSearchListDataBean.setStoreId(campaignCommandContext.getStoreId().toString());
	catalogSearchListDataBean.setLanguageId(campaignCommandContext.getLanguageId().toString());
	catalogSearchListDataBean.setSearchType(CatalogSearchListDataBean.SEARCH_TYPE_CATGROUP);
	catalogSearchListDataBean.setIndexBegin("" + startIndex);
	catalogSearchListDataBean.setIndexEnd("" + endIndex);
	catalogSearchListDataBean.setOrderby(orderByParm);
	DataBeanManager.activate(catalogSearchListDataBean, request);
	CatalogSearchDataBean[] myCategories = catalogSearchListDataBean.getCatalogList();

	int myCount = catalogSearchListDataBean.getResultSetSize();
	int rowselect = 1;
	int totalsize = myCount;
	int totalpage = totalsize/listSize;
	if (endIndex > myCount) {
		endIndex = myCount;
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get("CategoryListDialogTitle") %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
var currentArray = top.getData("currentArray", null);
if (currentArray == null) {
	currentArray = new Array();
}

var resultContainer = new Array();
var resultIndex = 0;

var searchType = top.getData("searchType", 1);

function performAdd () {
	// put the category's into an array in the model and set a flag
	var categoryArray = new Array();

	// check if the number of selected categories exceeds allowed result limit
	if (currentArray.length == 0) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("pleaseSelectOneCategory")) %>");
		return;
	}
	if ((searchType == "categorySingle") && (currentArray.length > 1)) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("pleaseSelectAtMostOneCategory")) %>");
		return;
	}

	categoryArray = currentArray;
	top.sendBackData(categoryArray, "categoryResult");
	top.saveData(null, "currentArray");

	// go back to the finder's caller!
	top.goBack();
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
					if (resultContainer[i].categoryId == currentArray[j].categoryId) {
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
				if (resultContainer[i].categoryId == checkObject.name) {
					newIndex = currentArray.length;
					currentArray[newIndex] = new Object();
					currentArray[newIndex] = resultContainer[i];
					break;
				}
			}
		}
		else {
			for (var i=0; i<currentArray.length; i++) {
				if (currentArray[i].categoryId == checkObject.name) {
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

function performCancel () {
	// let's go back
	top.goBack();
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
<%	for (int i=0; i<myCategories.length; i++) { %>
resultContainer[resultIndex] = new Object();
resultContainer[resultIndex].categoryId = "<%= myCategories[i].getId() %>";
resultContainer[resultIndex].categoryIdentifier = "<%= UIUtil.toJavaScript(myCategories[i].getIdentifier()) %>";
resultContainer[resultIndex].categoryEncodedIdentifier = "<%= UIUtil.toJavaScript(myCategories[i].getEncodedIdentifier()) %>";
resultContainer[resultIndex].categoryMemberId = "<%= myCategories[i].getMemberId() %>";
resultContainer[resultIndex].categoryName = "<%= UIUtil.toJavaScript(myCategories[i].getName()) %>";
resultContainer[resultIndex].isTopCategory = "N";
<%
		if (myCategories[i].getParentName() != null) {
			if (myCategories[i].getParentName().equals("")) {
%>
resultContainer[resultIndex].isTopCategory = "Y";
<%
			}
		}
%>
resultIndex++;
<%	} %>
//-->
</script>

<%= comm.addControlPanel("campaigns.CategoryList", totalpage, totalsize, jLocale) %>
<form name="categoryListForm" id="categoryListForm">
<%= comm.startDlistTable((String)campaignsRB.get("CategoryListDialogSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true, "parent.selectDeselectAll();performUpdate(true, this);") %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("CategoryListDialogCategoryName"), CatalogSearchListDataBean.ORDER_BY_CATEGORY_NAME, CatalogSearchListDataBean.ORDER_BY_CATEGORY_NAME.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("CategoryListDialogCategoryShort"), CatalogSearchListDataBean.ORDER_BY_CATEGORY_SHORTDESC, CatalogSearchListDataBean.ORDER_BY_CATEGORY_SHORTDESC.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("CategoryListDialogParentCategory"), null, false) %>
<%= comm.endDlistRow() %>
<%
	String parentName;
	for (int i=0; i<myCategories.length; i++) {
%>
<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(myCategories[i].getId(), "parent.setChecked();performUpdate(false, this);", UIUtil.toHTML(UIUtil.toJavaScript(myCategories[i].getName()))) %>
<%= comm.addDlistColumn(UIUtil.toHTML(myCategories[i].getName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(myCategories[i].getShortDescription()), "none") %>
<%
		parentName = myCategories[i].getParentName();
		if (parentName != null) {
			if (parentName.equals("")) {
				parentName = (String)campaignsRB.get("CategoryListDialogTopLevelCategory");
			}
		}
%>
<%= comm.addDlistColumn(UIUtil.toHTML(parentName), "none") %>
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
<%= campaignsRB.get("CategoryListDialogEmpty") %>
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
