<!--
//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------
-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java"
	import="com.ibm.commerce.tools.epromotion.RLConstants" %>
<%@include file="epromotionCommon.jsp" %>

<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="GENERATOR" content="IBM WebSphere Studio">
<title><%= UIUtil.toHTML((String)RLPromotionNLS.get("CategoryBrowsePanelTitle")) %></title>
<%= fPromoHeader%>

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
var locationType = "";
var catalogId = "";
var categoryId = "";
var isNodeRequiredId = "false";

var bp = top.getData("browseParameters", 1);

if (bp != null) {
	selectionType = bp.selectionType;
	locationType = bp.locationType;
	catalogId = bp.catalogId;
	categoryId = bp.categoryId;
}

document.writeln('<frameset rows="15%,*" border="0" frameborder="no" framespacing="0">');

document.writeln('	<frame src="/webapp/wcs/tools/servlet/RLCategoryBrowseTreeContentView" title="<%= UIUtil.toJavaScript(RLPromotionNLS.get("CategoryBrowseContentPanelTitle")) %>" name="treeContent">');

document.writeln('	<frame src="DynamicTreeView?XMLFile=RLPromotion.RLCategoryBrowseTree&selectionType=' + selectionType + '&locationType=' + locationType + '&catalogId=' + catalogId + '&isNodeRequiredId='+ isNodeRequiredId + '&categoryId=' + categoryId + '" title="<%= UIUtil.toJavaScript(RLPromotionNLS.get("CategoryBrowseTreePanelTitle")) %>" name="tree">');
document.writeln('</frameset>');
//-->

</script>

</html>
