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
<title>DynamicTreeData</title>
<script type="text/javascript">

<%= tree.getJS() %>

function init() {
	if (parent.setNode) {
		if (menus) {
		} else {
			menus=null;
		}
		if (icons) {
		} else {
			icons=null;
		}
<% if (request.getParameter("gotoNodeByName")!=null) { %>
		goto = new Object();
		goto.type="name";
		goto.value='<%=UIUtil.toJavaScript((String)request.getParameter("gotoNodeByName"))%>';
<%} else if (request.getParameter("gotoNodeByValue")!=null) { %>
		goto = new Object();
		goto.type="value";
		goto.value='<%=UIUtil.toJavaScript((String)request.getParameter("gotoNodeByValue"))%>';
<%} else {%>
		goto=null;
<%}%>
		if (parent.beforeSetNode)
			parent.beforeSetNode(node, menus, icons, goto);
		parent.setNode(node, menus, icons, goto);
	}
}

</script>
</head>
<body onload="init();">
</body>
</html>

