<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.common.ui.*" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@include file="common.jsp" %>
<jsp:useBean id="tree" scope="request" class="com.ibm.commerce.tools.common.ui.DynamicTreeBean"></jsp:useBean>
<%
    tree.setRequest(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<title>DynamicTreeFetchData</title>
<script type="text/javascript">

<%= tree.getJS() %>

<%
	if (request.getParameter("gotoNodeByName") != null) {
		out.println("var findNode = new Object();");
		out.println("findNode.type = \"name\"");
		out.println("findNode.value = \"" + UIUtil.toJavaScript((String)request.getParameter("gotoNodeByName")) + "\";");
	}
	else if (request.getParameter("gotoNodeByValue") != null) {
		out.println("var findNode = new Object();");
		out.println("findNode.type = \"value\"");
		out.println("findNode.value = \"" + UIUtil.toJavaScript((String)request.getParameter("gotoNodeByValue")) + "\";");
	}
	else {
		out.println("var findNode = null;");
	}
%>

function init() {
	if (findNode != null) {
		parent.setFindNode(parent.DTreeHandler.focusNode, node, findNode, false);
		parent.DTreeHandler.focusNode.renderChildNodes();
		parent.gotoAndHighlightNode(findNode.value, findNode.type);
	}
	else {
		parent.setNode(parent.DTreeHandler.focusNode, node, menus, icons);

		if (parent.tree != null && !parent.tree.rendered) {
			parent.DTreeHandler.insertHTMLBeforeEnd(parent.document.body, parent.tree.toString());
			if (!parent.DTreeConfig.showRoot)
				parent.document.getElementById(parent.tree.id + "-item").style.display = "none";
			parent.doLevelExpand(parent.tree);
			top.showProgressIndicator(false);
		}
		else if (parent.DTreeHandler.focusNode != null) {
			parent.DTreeHandler.focusNode.renderChildNodes();
			parent.document.getElementById(parent.DTreeHandler.focusNode.id + "-anchor").innerHTML = parent.DTreeHandler.focusNode.name;
			parent.DTreeHandler.focusNode.expand();
			top.showProgressIndicator(false);
		}
	}
	parent.DTreeHandler.isLoading = false;
	
	if (parent.onDataFetched) {
		parent.onDataFetched();
	}
}

</script>
</head>
<body onload="init();">
</body>
</html>

