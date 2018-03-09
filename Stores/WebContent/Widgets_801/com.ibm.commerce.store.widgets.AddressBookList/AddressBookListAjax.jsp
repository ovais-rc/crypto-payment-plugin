<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2017 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN AddressBookListAjax.jsp -->

<%@ include file="/Widgets_801/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_801/Common/nocache.jspf" %>

<%@ include file="ext/AddressBookList_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
    <%@ include file="AddressBookList_Data.jspf" %>
</c:if>

<c:choose>
    <c:when test = "${param.type eq 'add'}">
        <%@ include file="AddressBookList_Create_UI.jspf" %>
    </c:when>
    <c:otherwise>
        <%@ include file="ext/AddressBookList_UI.jspf" %>
        <c:if test = "${param.custom_view ne 'true'}">
            <%@ include file="AddressBookList_UI.jspf" %>
        </c:if>
    </c:otherwise>
</c:choose>

<!-- END AddressBookListAjax.jsp -->