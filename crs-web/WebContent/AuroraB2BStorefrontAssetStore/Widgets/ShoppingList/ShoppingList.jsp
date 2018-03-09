<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN ShoppingList.jsp -->

<%@ include file= "../../Common/EnvironmentSetup.jspf" %>

<flow:ifEnabled feature="SOAWishlist">
	<%@ include file="ext/ShoppingList_Data.jspf" %>
	<c:if test = "${param.custom_data ne 'true'}">
		<%@ include file="ShoppingList_Data.jspf" %>
	</c:if>
	
	<%@ include file="ext/ShoppingList_UI.jspf" %>
	<c:if test = "${param.custom_view ne 'true'}">
		<%@ include file="ShoppingList_UI.jspf" %>
	</c:if>
	
	<jsp:useBean id="ShoppingList_TimeStamp" class="java.util.Date" scope="request"/>
</flow:ifEnabled>

<!-- END ShoppingList.jsp -->