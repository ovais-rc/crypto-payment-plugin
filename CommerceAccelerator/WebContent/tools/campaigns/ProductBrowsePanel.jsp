<!-- ========================================================================
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
=========================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<%@ page language="java"
	import="com.ibm.commerce.tools.campaigns.CampaignConstants" %>

<%@ include file="common.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get("ProductBrowsePanelTitle") %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
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
var locationType = "";
var catalogId = "";
var categoryId = "";

var bp = top.getData("browseParameters", 1);

if (bp != null) {
	selectionType = bp.selectionType;
	locationType = bp.locationType;
	catalogId = bp.catalogId;
	categoryId = bp.categoryId;
}

document.writeln('<frameset rows="10%,*" border="0" frameborder="no" framespacing="0">');
document.writeln('	<frame src="<%= CampaignConstants.URL_CAMPAIGN_PRODUCT_BROWSE_TREE_CONTENT %>" title="<%= UIUtil.toJavaScript(campaignsRB.get("ProductBrowseContentPanelTitle")) %>" name="treeContent">');
document.writeln('	<frame src="DynamicTreeView?XMLFile=campaigns.ProductBrowseTree&selectionType=' + selectionType + '&locationType=' + locationType + '&catalogId=' + catalogId + '&categoryId=' + categoryId + '" title="<%= UIUtil.toJavaScript(campaignsRB.get("ProductBrowseTreePanelTitle")) %>" name="tree">');
document.writeln('</frameset>');
//-->
</script>

</html>