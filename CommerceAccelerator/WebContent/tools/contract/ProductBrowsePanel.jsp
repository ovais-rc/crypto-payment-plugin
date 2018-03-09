<!--==========================================================================
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
===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page language="java" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="ContractCommon.jsp" %>

<html>

<head>
<%= fHeader %>
<title><%= contractsRB.get("contractProductBrowsePanelTitle") %></title>

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script language="JavaScript">
<!---- hide script from old browsers
function visibleList (s) {
	if (defined(this.treeContent) == false || this.treeContent.document.readyState != "complete") {
		return;
	}

	if (defined(this.treeContent.visibleList)) {
		this.treeContent.visibleList(s);
		return;
	}

	if (defined(this.treeContent.document.forms[0])) {
		for (var i = 0; i < this.treeContent.document.forms[0].elements.length; i++) {
			if (this.treeContent.document.forms[0].elements[i].type.substring(0,6) == "select") {
				this.treeContent.document.forms[0].elements[i].style.visibility = s;
			}
		}
	}
}
//-->

</script>
</head>

<script language="JavaScript">
<!---- hide script from old browsers
var selectionType = "";
var catalogId = "";
var categoryId = "";

// try to get the contract common data model 2 models back...
var ccdm = top.getData("ccdm", 2);
if (! ccdm) {
	ccdm = top.getData("ccdm", 1);
} 

//alert (ccdm.referenceNumber);

var bst = top.getData("browseSelectionType", 1);
var plc = top.getData("priceListCategory", 1);

if (bst != null) {
	selectionType = bst;
}
if (ccdm != null) {
	catalogId = ccdm.catalogId;
}
if (plc != null) {
	categoryId = plc;
}

document.writeln('<frameset rows="10%,*" border="0" frameborder="no" framespacing="0">');
document.writeln('	<frame  name="treeContent" src="/webapp/wcs/tools/servlet/PriceListProductBrowseTreeContentView" title="<%= contractsRB.get("contractProductBrowseContentPanelTitle") %>">');
if (ccdm.referenceNumber != "") {
	document.writeln('	<frame  name="tree" src="/webapp/wcs/tools/servlet/DynamicTreeView?XMLFile=contract.PriceListProductBrowseTree&selectionType=' + selectionType + '&catalogId=' + catalogId + '&categoryId=' + categoryId + '&contractId=' + ccdm.referenceNumber +'" title="<%= contractsRB.get("contractProductBrowseTreePanelTitle") %>">');
} else {
	document.writeln('	<frame  name="tree" src="/webapp/wcs/tools/servlet/DynamicTreeView?XMLFile=contract.PriceListProductBrowseTree&selectionType=' + selectionType + '&catalogId=' + catalogId + '&categoryId=' + categoryId + '" title="<%= contractsRB.get("contractProductBrowseTreePanelTitle") %>">');
}
document.writeln('</frameset>');

//-->

</script>

</html>
