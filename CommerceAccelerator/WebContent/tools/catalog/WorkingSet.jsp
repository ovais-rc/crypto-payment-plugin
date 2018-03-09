<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2002, 2016
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.CatalogEntryDataBean" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@ page import="com.ibm.commerce.registry.StoreRegistry" %>

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Integer intStoreId = cmdContext.getStoreId();
	StoreAccessBean abStore = StoreRegistry.singleton().find(intStoreId);
    if (abStore == null) {
		abStore = new StoreAccessBean();
		abStore.setInitKey_storeEntityId(intStoreId.toString());
    }
    String strMasterCatalogId = abStore.getMasterCatalog().getCatalogReferenceNumber();

%>

<HTML>
<HEAD>

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/CatalogCommonFunctions.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">

<% 
	String catentryID = request.getParameter("catentryID"); 
	String SKU        = request.getParameter("SKU"); 

	if (catentryID.equals("new"))
	{
		CatalogEntryAccessBean abCatEntry = new CatalogEntryAccessBean();
		abCatEntry = abCatEntry.findByMemberIdAndSKUNumber(abStore.getMemberIdInEntityType(), SKU);
		catentryID = abCatEntry.getCatalogEntryReferenceNumber();
	}

	CatalogEntryDataBean bnEntry = new CatalogEntryDataBean();
	bnEntry.setCatalogEntryID(catentryID);
	DataBeanManager.activate(bnEntry, cmdContext);

	CatalogEntryDescriptionAccessBean abDescription = new CatalogEntryDescriptionAccessBean();
	abDescription = bnEntry.getDescription();


	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Retrieve the category information
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	String categoryName = "", categoryID = "";
	CatalogGroupCatalogEntryRelationAccessBean abCategory = new CatalogGroupCatalogEntryRelationAccessBean();
	Enumeration e = abCategory.findByCatalogEntryId(new Long(bnEntry.getCatalogEntryID()));
	while ( e.hasMoreElements() ) 
	{
		abCategory = (CatalogGroupCatalogEntryRelationAccessBean) e.nextElement ();
		if (abCategory.getCatalogId().equals(strMasterCatalogId))
		{
			CatalogGroupDescriptionAccessBean abCategoryDescription = new CatalogGroupDescriptionAccessBean();
			abCategoryDescription.setInitKey_catalogGroupReferenceNumber(abCategory.getCatalogGroupId());
			abCategoryDescription.setInitKey_language_id(cmdContext.getLanguageId().toString());
			categoryName = abCategoryDescription.getName();
			categoryID   = abCategory.getCatalogGroupId();
			break;
		}
	}

%>

	function onLoad()
	{
		///////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Retrieve the product information
		///////////////////////////////////////////////////////////////////////////////////////////////////////////
		var newProduct = new Object();


		newProduct.ID           = "<%= UIUtil.toHTML(bnEntry.getCatalogEntryID()) %>";
		newProduct.type         = "<%= UIUtil.toHTML(bnEntry.getType()) %>"; 
		newProduct.partNumber   = "<%= UIUtil.toHTML(bnEntry.getPartNumber()) %>";
		newProduct.mfPartNumber = "<%= UIUtil.toHTML(bnEntry.getManufacturerPartNumber()) %>";
		newProduct.mfName       = "<%= UIUtil.toHTML(bnEntry.getManufacturerName()) %>";
		newProduct.URL          = "<%= UIUtil.toHTML(bnEntry.getUrl()) %>";
		newProduct.field1       = "<%= UIUtil.toHTML(bnEntry.getField1()) %>";
		newProduct.field2       = "<%= UIUtil.toHTML(bnEntry.getField2()) %>";
		newProduct.field3       = "<%= UIUtil.toHTML(bnEntry.getField3()) %>";
		newProduct.field4       = "<%= UIUtil.toHTML(bnEntry.getField4()) %>";
		newProduct.field5       = "<%= UIUtil.toHTML(bnEntry.getField5()) %>";
		newProduct.onSpecial    = "<%= UIUtil.toHTML(bnEntry.getOnSpecial()) %>";
		newProduct.onAuction    = "<%= UIUtil.toHTML(bnEntry.getOnAuction()) %>";
		newProduct.buyable      = "<%= UIUtil.toHTML(bnEntry.getBuyable()) %>";
		newProduct.category     = "<%= UIUtil.toHTML(categoryName) %>";
		newProduct.categoryID   = "<%= categoryID %>";

		newProduct.lang = new Array();
		newProduct.lang[<%=cmdContext.getLanguageId()%>]           = new Object();
		newProduct.lang[<%=cmdContext.getLanguageId()%>].name      = "<%= UIUtil.toHTML(abDescription.getName()) %>";
		newProduct.lang[<%=cmdContext.getLanguageId()%>].shortDesc = "<%= UIUtil.toHTML(abDescription.getShortDescription()) %>";
		newProduct.lang[<%=cmdContext.getLanguageId()%>].longDesc  = "<%= UIUtil.toHTML(abDescription.getLongDescription()) %>";
		newProduct.lang[<%=cmdContext.getLanguageId()%>].aux1Desc  = "<%= UIUtil.toHTML(abDescription.getAuxDescription1()) %>";
		newProduct.lang[<%=cmdContext.getLanguageId()%>].aux2Desc  = "<%= UIUtil.toHTML(abDescription.getAuxDescription2()) %>";
		newProduct.lang[<%=cmdContext.getLanguageId()%>].thumbNail = "<%= UIUtil.toHTML(abDescription.getThumbNail()) %>";
		newProduct.lang[<%=cmdContext.getLanguageId()%>].fullImage = "<%= UIUtil.toHTML(abDescription.getFullImage()) %>";

		parent.firstIFRAMENAME.contentFrame.toolbarChangeFinished(newProduct);
	}

</SCRIPT>

</HEAD>

<BODY ONLOAD=onLoad()>
</BODY>
</HTML>


