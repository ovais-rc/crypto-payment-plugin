<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006, 2016
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
   -------------------------------------------------------------------
    ProductCategoryDetail.jsp
===========================================================================-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@page import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.ejb.helpers.SessionBeanHelper" %>
<%@ page import="com.ibm.commerce.base.objects.ServerJDBCHelperBean" %>
<%@ page import="com.ibm.commerce.common.helpers.StoreUtil" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.registry.StoreRegistry" %>

<%@include file="../common/common.jsp" %>

<%!
private String handleCategory(String strCategoryName, Long lCategoryId, String TMB, CommandContext cmdContext, Hashtable hCategories, Vector v, Hashtable rbProduct, Hashtable rbUI)
{
	String result = "";
	strCategoryName = UIUtil.toHTML(strCategoryName);

	if (v == null || v.size() == 0)
	{  
		result += "<TR TMB="+TMB+" HASCHILDREN=NO isOpen=false>\n";
		result += "   <TD CLASS=jtree WIDTH=10><img alt='' src=/wcs/images/tools/dtree/line"+TMB+".gif border=0></TD>\n";
		result += "   <TD CLASS=jtree ONCLICK=fcnOnClick(this) ONDBLCLICK=fcnOnDblClick(this) ID=c"+lCategoryId+" CATEGORY="+lCategoryId+">" + strCategoryName + "</TD>\n";
		result += "</TR>\n";
	} else {
		result += "<TR TMB="+TMB+" HASCHILDREN=YES isOpen=true>\n";
		result += "   <TD CLASS=jtree WIDTH=10><img alt='"+UIUtil.toJavaScript((String)rbUI.get("collapse"))+"' src=/wcs/images/tools/dtree/minus"+TMB+".gif ONCLICK=\"openClose(this, '"+TMB+"')\" border=0></TD>\n";
		result += "   <TD CLASS=jtree ONCLICK=fcnOnClick(this) ONDBLCLICK=fcnOnDblClick(this) ID=c"+lCategoryId+" CATEGORY="+lCategoryId+">" + strCategoryName + "</TD>\n";
		result += "</TR>\n";
		result += "<TR STYLE=\"display:block\">\n";
		if (TMB.equals("bottom") == false) { result += "   <TD CLASS=jtree WIDTH=10 background=/wcs/images/tools/dtree/linestraight.gif></TD>\n"; }
		else                               { result += "   <TD CLASS=jtree WIDTH=10>&nbsp;</TD>\n"; }
		result += "<TD CLASS=jtree>\n";
		result += "<TABLE BORDER=0 CELLPADDING=0 CELLSPACING=0>\n";
		for (int i=0; i<v.size(); i++)
		{
			Hashtable hChild = (Hashtable) v.elementAt(i);
			Vector vChild = (Vector) hCategories.get(new Long(hChild.get("catgroup_id").toString()));
			Long lChildId = new Long(hChild.get("catgroup_id").toString());
			String strDescription = "";
		
			try {
				CatalogGroupDescriptionAccessBean abDescription = new CatalogGroupDescriptionAccessBean();
				abDescription.setInitKey_catalogGroupReferenceNumber(lChildId.toString());
				abDescription.setInitKey_language_id(cmdContext.getLanguageId().toString());
		
				strDescription = abDescription.getName();
		
			} catch (Exception e) {
				try {
					CatalogGroupDescriptionAccessBean abDescription = new CatalogGroupDescriptionAccessBean();
					abDescription.setInitKey_catalogGroupReferenceNumber(lChildId.toString());
					abDescription.setInitKey_language_id(cmdContext.getStore().getLanguageId());
			
					strDescription = abDescription.getName();
				} catch (Exception ex) {
					strDescription = UIUtil.toJavaScript((String)rbProduct.get("shippingCategoryNameNotAvailable"));
				}
			}

			if (i == (v.size()-1)) { result += handleCategory(strDescription, new Long(hChild.get("catgroup_id").toString()), "bottom", cmdContext, hCategories, vChild, rbProduct, rbUI); }
			else                   { result += handleCategory(strDescription, new Long(hChild.get("catgroup_id").toString()), "middle", cmdContext, hCategories, vChild, rbProduct, rbUI); }
		}
		result += "</TABLE>\n";
		result += "</TD>\n";
		result += "</TR>\n";
	}

   return result;
}
%>


<%!
private void addToHashtable(Hashtable h, java.lang.Object oKey, java.lang.Object oValue)
{
	if (h.containsKey(oKey) == false)
	{
		Vector vNew = new Vector();
		h.put(oKey, vNew);
	}
	
	Vector v = (Vector) h.get(oKey);
	v.addElement(oValue);
}
%>



<%
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Get the command context
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbUI = (Hashtable)ResourceDirectory.lookup("common.uiNLS", cmdContext.getLocale());
	Hashtable rbProduct = (Hashtable)ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
	Hashtable rbCategory = (Hashtable)ResourceDirectory.lookup("catalog.CategoryNLS", cmdContext.getLocale());
	String startCategory = request.getParameter("startCategory"); 

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Retreive the store access bean and master catalog id
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	Integer intStoreId = cmdContext.getStoreId();
	StoreAccessBean abStore = StoreRegistry.singleton().find(intStoreId);
     if (abStore == null) {
			abStore = new StoreAccessBean();
			abStore.setInitKey_storeEntityId(intStoreId.toString());
     }

	CatalogAccessBean abMaster = abStore.getMasterCatalog();
	String strMasterCatalogId = abMaster.getCatalogReferenceNumber();

	Hashtable hCategories = new Hashtable();

	try
	{
		// SELECT LIST OF TOP LEVEL CATEGORIES FOR THE SELECTED CATALOG
		ServerJDBCHelperBean abHelper = SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);
		String strSQL  = "SELECT CATGROUP.CATGROUP_ID, STORECGRP.STOREENT_ID, CATGROUP.IDENTIFIER";
				 strSQL += " FROM CATGROUP, CATTOGRP, STORECGRP";
				 strSQL += " WHERE CATGROUP.CATGROUP_ID=CATTOGRP.CATGROUP_ID AND CATGROUP.CATGROUP_ID=STORECGRP.CATGROUP_ID ";
				 strSQL += " AND CATTOGRP.CATALOG_ID=" +  strMasterCatalogId;
				 strSQL += " AND STORECGRP.STOREENT_ID " + CatalogSqlHelper.getStorePathInClauseSQL(cmdContext.getStoreId());

		Vector vResult = abHelper.executeQuery(strSQL);
		for (int i=0; i<vResult.size(); i++)
		{
			Vector vRow = (Vector) vResult.elementAt(i);
			Long lParent = new Long(0);
			Hashtable hChild = new Hashtable();
			hChild.put("catgroup_id", vRow.elementAt(0));
			hChild.put("storeent_id", vRow.elementAt(1));
			hChild.put("identifier",  vRow.elementAt(2));
			addToHashtable(hCategories, lParent, hChild);
		}
	} catch (Exception ex) {
	}


	try
	{
		ServerJDBCHelperBean helper = SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);
		String  strSQL = "SELECT CATGRPREL.CATGROUP_ID_PARENT, CATGRPREL.CATGROUP_ID_CHILD, STORECGRP.STOREENT_ID, CATGROUP.IDENTIFIER";
				 strSQL += " FROM CATGRPREL, STORECGRP, CATGROUP";
				 strSQL += " WHERE CATGROUP.CATGROUP_ID=STORECGRP.CATGROUP_ID AND CATGROUP.CATGROUP_ID=CATGRPREL.CATGROUP_ID_CHILD";
				 strSQL += " AND CATGRPREL.CATALOG_ID=" +  strMasterCatalogId;
				 strSQL += " AND STORECGRP.STOREENT_ID " + CatalogSqlHelper.getStorePathInClauseSQL(cmdContext.getStoreId());

		Vector vResult = helper.executeQuery(strSQL);
		for (int i=0; i<vResult.size(); i++)
		{
			Vector vRow = (Vector) vResult.elementAt(i);
			Long lParent = new Long(vRow.elementAt(0).toString());
			Hashtable hChild = new Hashtable();
			hChild.put("parent_catgroup_id", vRow.elementAt(0));
			hChild.put("catgroup_id", vRow.elementAt(1));
			hChild.put("storeent_id", vRow.elementAt(2));
			hChild.put("identifier", vRow.elementAt(3));
			addToHashtable(hCategories, lParent, hChild);
		}
	} catch (Exception ex) {
	}


%>

<HTML>
<HEAD>

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

<TITLE><%=UIUtil.toHTML((String)rbProduct.get("CatalogGroupTree_FrameTitle_1"))%></TITLE>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

<SCRIPT>

	var expandString   = "<%=UIUtil.toJavaScript((String)rbUI.get("expand"))%>";
	var collapseString = "<%=UIUtil.toJavaScript((String)rbUI.get("collapse"))%>";


	//////////////////////////////////////////////////////////////////////////////////////
	// openClose(element, TMB)
	//
	// - this function opens and/or closes the selected portion of the tree
	//////////////////////////////////////////////////////////////////////////////////////
	function openClose(element, TMB)
	{
		var trElement = element.parentNode.parentNode;
		var index = trElement.rowIndex;
		var table = trElement.parentNode;

		if (trElement.isOpen == "true")
		{
			trElement.isOpen = "false";
			table.rows(index+1).style.display = "none";
			element.src = "/wcs/images/tools/dtree/plus"+TMB+".gif"
			element.alt = expandString;
		} else {
			trElement.isOpen = "true";
			table.rows(index+1).style.display = "block";
			element.src = "/wcs/images/tools/dtree/minus"+TMB+".gif"
			element.alt = collapseString;
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// fcnOnClick(element)
	//
	// - the onclick even hilites and selects a category
	//////////////////////////////////////////////////////////////////////////////////////
	function fcnOnClick(element)
	{
		if (element.CATEGORY == "-1") return;
		parent.toolbarCurrentElementID   = element.CATEGORY;
		parent.toolbarCurrentElementName = element.firstChild.nodeValue;

		var elementArray = document.all.item("c"+element.CATEGORY);
		toolbarSetHilite(elementArray);
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// fcnOnDblClick(element)
	//
	// - the onclick selects a category and returns
	//////////////////////////////////////////////////////////////////////////////////////
	function fcnOnDblClick(element)
	{
		if (element.CATEGORY == "-1") return;
		fcnOnClick(element);
		parent.okButton();
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// fcnFind(name)
	//
	// - hilite the found category if it exists
	//////////////////////////////////////////////////////////////////////////////////////
	function fcnFind(categoryID)
	{
		var element = document.all.item("c"+categoryID);
		toolbarSetHilite(element);
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad(element)
	//
	// - hilite the initial element
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad(element)
	{
		fcnFind(element);
	}


// Global variables
	var toolbarCurrentElement = null;    // The currently selected element
	var toolbarCurrentDOIOWN  = null;    // Do I own the current element
	var toolbarCurrentColumn  = null;    // The currently selected column
	var toolbarHiliteElement  = new Array();    // The currently selected element

	var toolbarHiliteColor    = "#18416B";    // The currently hilited elements color


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarSetHilite(element)
	//
	// - reset the old element and hilite the new element
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarSetHilite(element)
	{
		if (!element) return;

		toolbarUnhilite();

		if (element.CATEGORY)
		{
			parent.toolbarCurrentElementID     = element.CATEGORY;
			parent.toolbarCurrentElementName   = element.firstChild.nodeValue;
			toolbarHilite(element);
		} else {
			for (var i=0; i<element.length; i++)
			{
				var singleElement = element[i];
				parent.toolbarCurrentElementID     = singleElement.CATEGORY;
				parent.toolbarCurrentElementName   = singleElement.firstChild.nodeValue;
				toolbarHilite(singleElement);
			}
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarUnhilite()
	//
	// - unhilite the old hilite element
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarUnhilite()
	{
		for (var i=0; i<toolbarHiliteElement.length; i++)
		{
			var element = toolbarHiliteElement[i];
			if (element.style) element.style.backgroundColor = toolbarHiliteColor;
			else element.parentNode.style.backgroundColor = toolbarHiliteColor;
		}
		toolbarHiliteElement = new Array();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarHilite(element)
	//
	// - hilite the currently selected element
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarHilite(element)
	{
		var len = toolbarHiliteElement.length;
		toolbarHiliteElement[len] = element;
		if (element.style) 
		{
			toolbarHiliteColor = element.style.backgroundColor;
			element.style.backgroundColor = "#ACD5F8";
		} else {
			toolbarHiliteColor = element.parentNode.style.backgroundColor;
			element.parentNode.style.backgroundColor = "#ACD5F8";
		}
	}



</SCRIPT>

</HEAD>
<BODY ONLOAD=onLoad("<%=UIUtil.toHTML(startCategory)%>")>

<% 
	CatalogDataBean bnCatalog = new CatalogDataBean();
	bnCatalog.setCatalogId(strMasterCatalogId);
	DataBeanManager.activate(bnCatalog, cmdContext);
	bnCatalog.setAdminMode(true);


	CatalogDescriptionAccessBean bnCatalogDesc = new CatalogDescriptionAccessBean();
	bnCatalogDesc = bnCatalog.getDescription();
	String name = bnCatalogDesc.getName();
	Vector v = (Vector) hCategories.get(new Long(0));
%>
	<TABLE BORDER=0 CELLPADDING=0 CELLSPACING=0 WIDTH=105%>
		<TR HEIGHT=20 WIDTH=100% STYLE="font-family: Verdana; font-size: 9pt; color:black; background-color:#D1D1D9" >
			<TD WIDTH=10></TD>
			<TD STYLE="font-family: Verdana; font-size: 9pt; color:black;" >
				<%=UIUtil.toHTML((String)rbCategory.get("categoryUpdateTitle"))%>&nbsp;
			</TD>
		</TR>
		<TR><TD>&nbsp;</TD></TR>
	</TABLE>
	<TABLE BORDER=0 CELLPADDING=0 CELLSPACING=0>
		<%= handleCategory(name, new Long(0), "top", cmdContext, hCategories, v, rbProduct, rbUI) %>
	</TABLE>

</BODY>
</HTML>
