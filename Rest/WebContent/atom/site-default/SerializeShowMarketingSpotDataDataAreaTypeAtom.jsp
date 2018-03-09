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
<%--  Open the Marketing Spot Atom Bundle (eSpotAtomFeedText.properties file), which contains the text for some Atom feed tags.
      Edit that file if you want to set up a specific title for your feed in your e-Marketing Spot.
      --%>
<c:set var="eSpotAtomFeedBundleName" value="com.ibm.commerce.stores.atom.eSpotAtomFeedText"/>
<fmt:setBundle basename="${eSpotAtomFeedBundleName}" var="eSpotAtomFeedResourceBundle" />

<%-- ------------------------------------------------------------------------------------------------------------- --%>	
<%-- Get the data for the e-Marketing Spot. --%>
<c:set var="marketingSpotDatas"        value="${dataObject.marketingSpotData[0]}"/>

<%-- ------------------------------------------------------------------------------------------------------------- --%>	
<%-- The following file sets the common data for the Atom feed and processes each data type from the e-Marketing Spot. --%>
<%@ include file="SerializeMarketingSpotDataAtom.jspf"%>
