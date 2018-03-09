<?xml version="1.0" encoding="UTF-8"?>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%-- ------------------------------------------------------------------------------------------------------------- --%>
<%-- Include common environment. --%>
<%@ include file="FeedEnvironment.jspf"%>

<%-- ------------------------------------------------------------------------------------------------------------- --%>
<%-- Set clickOpenBrowser if you want to open a new browser when shoppers click on links.
     You can leave the value blank to use the same browser: value=""
     Alternatively, you can set it to: value="target=\"_blank\"" to open a new browser.
     This is used in <a href> html tags. --%>
<c:set var="clickOpenBrowser"          value="" />

<%-- ------------------------------------------------------------------------------------------------------------- --%>
<%-- The maximum number of entries to display is not defined for gift lists, since the shoppers may not expect such limit. --%>

<%-- ------------------------------------------------------------------------------------------------------------- --%>	
<%-- Get the data for the Gift List. --%>
<c:set var="giftListDatas"             value="${dataObject.giftList[0]}"/>

<%-- ------------------------------------------------------------------------------------------------------------- --%>	
<%-- The following file sets the common data for the Atom feed and processes each data type from the Gift List. --%>
<%@ include file="SerializeGiftListDataAtom.jspf"%>
