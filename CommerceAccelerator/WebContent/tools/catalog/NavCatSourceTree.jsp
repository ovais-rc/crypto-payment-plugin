<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2017 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@page import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@ page import="com.ibm.commerce.contract.objects.TradingAgreementAccessBean" %>
<%@ page import="com.ibm.commerce.contract.objects.ContractAccessBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.ejb.helpers.SessionBeanHelper" %>
<%@ page import="com.ibm.commerce.base.objects.ServerJDBCHelperBean" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.ras.ECTrace" %>
<%@ page import="com.ibm.commerce.ras.ECTraceIdentifiers" %>
<%@ page import="com.ibm.commerce.tools.common.ToolsConfiguration" %>

<%@include file="../common/common.jsp" %>
<%@include file="../catalog/DefaultContractBehavior.jspf" %>
<%@include file="../catalog/TradingAgreements.jspf" %>

<%!
String STR_ALT_LINK = "";
String STR_ALT_FOLDER_LOCKED_CLOSED = "";
String STR_ALT_FOLDER_LOCKED_OPEN = "";
String STR_ALT_FOLDER_CLOSED = "";
String STR_ALT_FOLDER_OPEN = "";

private String handleCategory(Hashtable hCurrent, Long lParentId, String TMB, CommandContext cmdContext, Hashtable hCategories, Vector v, Hashtable hCounts, Hashtable hAncestor)
{
	String  strCategoryName = UIUtil.toHTML((String)hCurrent.get("identifier"));
	Long    lCategoryId     = new Long(hCurrent.get("catgroup_id").toString());
	Integer iStoreId        = new Integer(hCurrent.get("storeent_id").toString());
	String strLinkId = "", strLinkImg = "";
	String strImage = "folderclosed.gif alt=\""+STR_ALT_FOLDER_CLOSED +"\"";
	String strLock = "false";

	String strCount = " (0)";
	if(hCounts==null)
		strCount ="";
	else	
		if (hCounts.containsKey(lCategoryId)) { strCount = " ("+(String) hCounts.get(lCategoryId)+")"; }

	if (hCurrent.containsKey("link_id")) 
	{ 
		strLinkId = " LINKID="+hCurrent.get("link_id").toString();
		strLinkImg = "<img SRC=/wcs/images/tools/catalog/link.gif alt=\"" + STR_ALT_LINK +"\" >";
	}

	if (iStoreId.intValue() != cmdContext.getStoreId().intValue()) 
	{
		strImage = "folderlockedclosed.gif alt=\""+STR_ALT_FOLDER_LOCKED_CLOSED +"\"";
		strLock  = "true";
	}

	String result = "";
	if (v == null || v.size() == 0)
	{  
		result += "<TR TMB="+TMB+" HASCHILDREN=NO isOpen=false>\n";
		if(TMB.equals("top"))
			result += "<TD CLASS=jtree STYLE='width:0; padding:0'><img alt='' SRC=/wcs/images/tools/catalog/line"+TMB+".gif STYLE='width:0; padding:0'></TD>\n";
		else
			result += "<TD CLASS=jtree WIDTH=16><img alt='' SRC=/wcs/images/tools/catalog/line"+TMB+".gif></TD>\n";
		result += "<TD CLASS=jtree ALIGN=LEFT NOWRAP ONCLICK=fcnOnClick(this) LOCK="+strLock+strLinkId+" PARENTCAT="+lParentId+" STOREID="+iStoreId+" ID=\""+lCategoryId+"\"><SPAN><img SRC=/wcs/images/tools/catalog/"+strImage+">"+strLinkImg+"</SPAN><SPAN UNSELECTABLE=on>" + strCategoryName + "</SPAN><SPAN>"+strCount+"</SPAN></TD>\n";
		result += "</TR>\n";
		result += "<TR STYLE=\"display:none\">\n";
		result += "<TD CLASS=jtree WIDTH=0>&nbsp;</TD>\n";
		result += "<TD CLASS=jtree ALIGN=LEFT>&nbsp;</TD>\n";
		result += "</TR>\n";
	} else {
		result += "<TR TMB="+TMB+" HASCHILDREN=YES isOpen=false ALIGN=LEFT>\n";
		if(TMB.equals("top"))
			result += "<TD CLASS=jtree STYLE='width:0; padding:0'><img alt='' SRC=/wcs/images/tools/catalog/plus"+TMB+".gif ONCLICK=\"openClose(this, '"+TMB+"')\" STYLE='width:0; padding:0'></TD>\n";
		else		
			result += "<TD CLASS=jtree WIDTH=16><img alt='' SRC=/wcs/images/tools/catalog/plus"+TMB+".gif ONCLICK=\"openClose(this, '"+TMB+"')\"></TD>\n";
		result += "<TD CLASS=jtree ALIGN=LEFT NOWRAP ONCLICK=fcnOnClick(this) LOCK="+strLock+strLinkId+" PARENTCAT="+lParentId+" STOREID="+iStoreId+" ID=\""+lCategoryId+"\"><SPAN><img SRC=/wcs/images/tools/catalog/"+strImage+">"+strLinkImg+"</SPAN><SPAN UNSELECTABLE=on>" + strCategoryName + "</SPAN><SPAN>"+strCount+"</SPAN></TD>\n";
		result += "</TR>\n";
		result += "<TR ALIGN=LEFT STYLE=\"display:none\">\n";
		if (TMB.equals("bottom") == false) result += "<TD CLASS=jtree background=/wcs/images/tools/dtree/linestraight.gif></TD>\n";
		else                               result += "<TD CLASS=jtree>&nbsp;</TD>\n";
		result += "<TD CLASS=jtree ALIGN=LEFT>\n";
		result += "<TABLE border=0 CELLPADDING=0 CELLSPACING=0>\n";
		for (int i=0; i<v.size(); i++)
		{
			Hashtable hChild = (Hashtable) v.elementAt(i);
			Long lChildId = new Long(hChild.get("catgroup_id").toString());
			
			if(creatingLoop(lChildId, hAncestor))
				continue;
			
			Hashtable	hChildAncestor = null;
			if(hAncestor==null)
				hChildAncestor = new Hashtable();
			else
				hChildAncestor = (Hashtable)hAncestor.clone();
			hChildAncestor.put(lChildId, lChildId);
			
			Vector vChild = (Vector) hCategories.get(lChildId);

			if (i == (v.size()-1)) result += handleCategory(hChild, lCategoryId, "bottom", cmdContext, hCategories, vChild, hCounts, hChildAncestor);
			else                   result += handleCategory(hChild, lCategoryId, "middle", cmdContext, hCategories, vChild, hCounts, hChildAncestor);
		}
		result += "</TABLE>\n";
		result += "</TD>\n";
		result += "</TR>\n";
	}
   return result;
}

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

private boolean creatingLoop(Long catgoryId, Hashtable hAncestor)
{
	if(hAncestor==null)
		return false;
	if(hAncestor.containsKey(catgoryId))	
		return true;
	return false;	
}

private String generateEntitlementSQL(CommandContext cmdContext)
{
	String strSQL="";

	try{
		Long lMemberId=cmdContext.getUser().getMemberIdInEntityType();
		
		// Out-of-box, Accelerator behaves like the store front. So if products are excluded
		// in the default store contract, then we won't be able to browse or search them in Accelerator.
		// By default, the method isRemoveDefaultContract() returns false. 
		// By changing this method to return true, then we remove any default contract that
		// we pass to ProductSetEntitlementHelper.
		// isRemoveDefaultContract() is defined in the file DefaultContractBehavior.jspf

		
		boolean removeDefaultContract = isRemoveDefaultContract();
		TradingAgreementAccessBean[] abTradingAgreements= getCurrentTradingAgreements(removeDefaultContract,cmdContext.getCurrentTradingAgreements());

		if(abTradingAgreements != null)
		{
			com.ibm.commerce.productset.commands.util.ProductSetEntitlementHelper pss = new com.ibm.commerce.productset.commands.util.ProductSetEntitlementHelper(abTradingAgreements, lMemberId);
			if(pss.isFilterEnabled())
			{
				Vector[] productSetInList=pss.getInclusionProductSetsOfContracts();
				Vector[] productSetOutList=pss.getExclusionProductSetsOfContracts();
				
				strSQL = com.ibm.commerce.catalog.helpers.ProductSetHelper.makeUpProductSetEntitlementSQLString("CATENTRY", "CATENTRY_ID", productSetInList, productSetOutList);
			}
			
		}
	}catch(Exception ex){
	}

	return strSQL;		
}

%>


<%
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Get the command context
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable)ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	com.ibm.commerce.server.JSPHelper helper = new com.ibm.commerce.server.JSPHelper(request);
	String startCategory = helper.getParameter("startCategory"); 
	String strCatalogId = helper.getParameter("catalogId"); 
	String startParent   = helper.getParameter("startParent"); 
	String strIsOpen	 = helper.getParameter("isOpen"); 

	// Validate input parms
	try
	{
		Long.parseLong(strCatalogId);
	}
	catch(Exception e)
	{
		throw e;
	}

	//the displayNumberOfProducts parameter passed through url decide if the numbers on the trees need to display or not
	String strDisplayNumberOfProducts = helper.getParameter("displayNumberOfProducts");
	if (strDisplayNumberOfProducts == null || strDisplayNumberOfProducts.equals("false") == false)
	{
		strDisplayNumberOfProducts = "true";	//enabled by default
	}
	else
		strDisplayNumberOfProducts="false";

	String strExtFunctionSKU = helper.getParameter("ExtFunctionSKU");
	if (strExtFunctionSKU!= null && strExtFunctionSKU.equals("true"))
		strExtFunctionSKU= "true";	
	else
		strExtFunctionSKU="false"; //disabled by default

	STR_ALT_LINK = UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTree_Alt_Link"));
	STR_ALT_FOLDER_LOCKED_CLOSED = UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTree_Alt_FolderLockedClosed"));
	STR_ALT_FOLDER_LOCKED_OPEN = UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTree_Alt_FolderLockedOpen"));
	STR_ALT_FOLDER_CLOSED = UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTree_Alt_FolderClosed"));
	STR_ALT_FOLDER_OPEN = UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTree_Alt_FolderOpen"));
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Global hashtable to retain the categories
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	Hashtable hCategories = new Hashtable();

	try
	{
		// SELECT LIST OF TOP LEVEL CATEGORIES FOR THE SELECTED CATALOG
		ServerJDBCHelperBean abHelper = SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);
		String strSQL  = "SELECT DISTINCT CATTOGRP.CATGROUP_ID, STORECGRP.STOREENT_ID, CATGROUP.IDENTIFIER, CATTOGRP.SEQUENCE, CATTOGRP.CATALOG_ID_LINK";
				 strSQL += " FROM CATGROUP, CATTOGRP, STORECGRP";
				 strSQL += " WHERE CATGROUP.CATGROUP_ID=CATTOGRP.CATGROUP_ID AND CATGROUP.CATGROUP_ID=STORECGRP.CATGROUP_ID ";
				 strSQL += " AND CATGROUP.MARKFORDELETE=0";
				 strSQL += " AND CATTOGRP.CATALOG_ID=" +  strCatalogId;
				 strSQL += " AND STORECGRP.STOREENT_ID " + CatalogSqlHelper.getStorePathInClauseSQL(cmdContext.getStoreId());
				 strSQL += " ORDER BY CATTOGRP.SEQUENCE, CATTOGRP.CATGROUP_ID";				 

		Vector vResult = abHelper.executeQuery(strSQL);
		for (int i=0; i<vResult.size(); i++)
		{
			Vector vRow = (Vector) vResult.elementAt(i);
			Long lParent = new Long(0);
			Hashtable hChild = new Hashtable();
			hChild.put("catgroup_id", new Long(vRow.elementAt(0).toString()));
			hChild.put("storeent_id", new Long(vRow.elementAt(1).toString()));
			hChild.put("identifier",  vRow.elementAt(2));
			Object objLink = vRow.elementAt(4);
			if (objLink != null) 
				hChild.put("link_id", new Long(vRow.elementAt(4).toString()));
			
			addToHashtable(hCategories, lParent, hChild);
		}
	} catch (Exception ex) {}


	try
	{
		ServerJDBCHelperBean abHelper2 = SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);
		String  strSQL = "SELECT DISTINCT CATGRPREL.CATGROUP_ID_PARENT, CATGRPREL.CATGROUP_ID_CHILD, STORECGRP.STOREENT_ID, CATGROUP.IDENTIFIER, CATGRPREL.CATALOG_ID_LINK, CATGRPREL.SEQUENCE";
				 strSQL += " FROM CATGRPREL, STORECGRP, CATGROUP";
				 strSQL += " WHERE CATGROUP.CATGROUP_ID=STORECGRP.CATGROUP_ID AND CATGROUP.CATGROUP_ID=CATGRPREL.CATGROUP_ID_CHILD";
				 strSQL += " AND CATGROUP.MARKFORDELETE=0";
				 strSQL += " AND CATGRPREL.CATALOG_ID=" +  strCatalogId;
				 strSQL += " AND STORECGRP.STOREENT_ID " + CatalogSqlHelper.getStorePathInClauseSQL(cmdContext.getStoreId());
				 strSQL += " ORDER BY CATGRPREL.SEQUENCE, CATGRPREL.CATGROUP_ID_CHILD"; 				 

		Vector vResult = abHelper2.executeQuery(strSQL);
		for (int i=0; i<vResult.size(); i++)
		{
			Vector vRow = (Vector) vResult.elementAt(i);
			Long lParent = new Long(vRow.elementAt(0).toString());
			Hashtable hChild = new Hashtable();
			hChild.put("parent_catgroup_id", new Long(vRow.elementAt(0).toString()));
			hChild.put("catgroup_id",        new Long(vRow.elementAt(1).toString()));
			hChild.put("storeent_id",        new Long(vRow.elementAt(2).toString()));
			hChild.put("identifier",         vRow.elementAt(3));
			Object objLink = vRow.elementAt(4);
			if (objLink != null) { hChild.put("link_id", new Long(vRow.elementAt(4).toString())); }
			addToHashtable(hCategories, lParent, hChild);
		}
	} catch (Exception ex) {}


	Hashtable hCounts = null;

	if(strDisplayNumberOfProducts.equals("true"))
	{	
		hCounts=new Hashtable();
		try
		{
		
			String strEntitlementSQL=generateEntitlementSQL(cmdContext);
		
			ServerJDBCHelperBean abHelper = SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);
			String strSQL  = "SELECT COUNT(*), CATGPENREL.CATGROUP_ID";
					 strSQL += " FROM CATGPENREL, STORECENT, CATENTRY";
					 strSQL += " WHERE CATGPENREL.CATENTRY_ID=STORECENT.CATENTRY_ID AND CATGPENREL.CATENTRY_ID=CATENTRY.CATENTRY_ID AND STORECENT.CATENTRY_ID=CATENTRY.CATENTRY_ID";
					 strSQL += " AND CATGPENREL.CATALOG_ID=" +  strCatalogId;
					 strSQL += " AND CATENTRY.MARKFORDELETE=0";
					 if(strExtFunctionSKU.equals("false"))
					 	strSQL += " AND CATENTRY.CATENTTYPE_ID <> 'ItemBean'";
					 strSQL += " AND STORECENT.STOREENT_ID " + CatalogSqlHelper.getStorePathInClauseSQL(cmdContext.getStoreId());
					 strSQL += strEntitlementSQL;
					 strSQL += " GROUP BY CATGPENREL.CATGROUP_ID";
	
			Vector vCounts = abHelper.executeQuery(strSQL);
			for (int i=0; i<vCounts.size(); i++)
			{
				Vector vCount = (Vector) vCounts.elementAt(i);
				String strCount  = vCount.elementAt(0).toString();
				Long lCatgroupId = new Long(vCount.elementAt(1).toString());
				hCounts.put(lCatgroupId, strCount);
			}
		} catch (Exception ex) {}
	}

%>

<HTML>
<HEAD>

<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceTree_Title"))%></TITLE>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/NavCatCommonFunctions.js"></SCRIPT>

<SCRIPT>

// Global variables
	var lockStatus = "true";

	var currentCatalogId = '<%=strCatalogId%>';  // The catalog tree being drawn
	var toolbarCurrentElement = null;    // The currently selected element
	var toolbarCurrentColumn  = null;    // The currently selected column
	var toolbarHiliteElement  = null;    // The currently selected element
	var toolbarHiliteColor    = "#EDAC40";    // The currently hilited elements color


	var oPopup   = window.createPopup();
	var currentRenameValue = null;
	var obj = new Object();
	obj.relations = new Array();

//Alt text will be used in NavCatCommonFunctions.js

	STR_ALT_LINK = "<%=STR_ALT_LINK%>";
	STR_ALT_FOLDER_LOCKED_CLOSED = "<%=STR_ALT_FOLDER_LOCKED_CLOSED%>";
	STR_ALT_FOLDER_LOCKED_OPEN = "<%=STR_ALT_FOLDER_LOCKED_OPEN%>";
	STR_ALT_FOLDER_CLOSED = "<%=STR_ALT_FOLDER_CLOSED%>";
	STR_ALT_FOLDER_OPEN = "<%=STR_ALT_FOLDER_OPEN%>";

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - hilite the initial element
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad()
	{
		treeTable.rows(0).cells(0).firstChild.fireEvent("onclick");
		document.getElementById("0").fireEvent("onclick");
		
		if (("<%=startCategory%>" != "null") && ("<%=startCategory%>" != "0"))
		{
			var bOpenParent=false;
		
			if("<%=startParent%>" != "null")			
			{
				if(document.getElementById("<%=startCategory%>"))
					openTreeToCategoryAndParent("<%=startCategory%>", "<%=startParent%>");
				else //the startCategory has been deleted
				{
					var parentparentId=document.getElementById("<%=startParent%>").PARENTCAT;
					openTreeToCategoryAndParent("<%=startParent%>",parentparentId);
					bOpenParent=true;
				}	
			}
			else
			{
				var element = document.getElementById("<%=startCategory%>");
				if(element != null)
				{
					element.fireEvent("onclick");
					openTreeByElement(element);
				}	
			}		

			if("<%=strIsOpen%>"=="true")
			{
			  if(document.getElementById("<%=startCategory%>"))
				document.getElementById("<%=startCategory%>").parentNode.cells(0).firstChild.fireEvent("onclick");
			
			}
				
			if(bOpenParent)	
			{
			  if(document.getElementById("<%=startParent%>"))
			  {
			  	if(document.getElementById("<%=startParent%>").id != '0')
			  	document.getElementById("<%=startParent%>").parentNode.cells(0).firstChild.fireEvent("onclick");
			  }	
			} 	
		}
		
		parent.m_bSourceTreeInvalidated=false;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// treeLoaded()
	//
	// - dummy function to indicate that the source tree has loaded
	//////////////////////////////////////////////////////////////////////////////////////
	function treeLoaded()
	{
		return true;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// resetButtons()
	//
	// - function which will reset the tree buttons
	//////////////////////////////////////////////////////////////////////////////////////
	function resetButtons()
	{
		if (parent.sourceTreeFrameButtons.setButtons) parent.sourceTreeFrameButtons.setButtons();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setByLockStatus(status)
	//
	// @param status - true or false indicating the lock status of the current target
	//
	// - this function sets the buttons appropriately to enabled or disabled
	//////////////////////////////////////////////////////////////////////////////////////
	function setByLockStatus(status)
	{
		lockStatus = status;
		if (parent.sourceTreeFrameButtons.setButtons) parent.sourceTreeFrameButtons.setButtons(status);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarSetHilite(element)
	//
	// @param element - the element to hilite
	//
	// - reset the old element and hilite the new element
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarSetHilite(element)
	{
		if (!element) return;
		if (element.tagName != "TD") element = element.parentNode;
		parent.setSourceElement(element,element.LOCK=='true');
		toolbarUnhilite();
		toolbarHilite(element);
		if (parent.sourceTreeFrameButtons.setButtons) parent.sourceTreeFrameButtons.setButtons();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// fcnOnClick()
	//
	// - highlight the selected element as the current element
	//////////////////////////////////////////////////////////////////////////////////////
	function fcnOnClick(element)
	{
		if (!element) element = event.srcElement;
		while (element.tagName != "TD") element = element.parentNode;
		if (element.PARENTCAT) toolbarSetHilite(element);
		//element.focus();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// function linkButton()
	//
	// - this function determines what has to be linked
	//////////////////////////////////////////////////////////////////////////////////////
	function linkButton()
	{
		var element = parent.currentSourceTreeElement;

		obj = new Object();
		obj.catalogId = parent.currentTargetDetailCatalog;
		obj.sourceCatalogId = parent.currentSourceDetailCatalog;
		obj.categories = new Array();

		var newobj = new Object();
		newobj.parentId = parent.currentTargetTreeElement.id;   // get the new top level parent
		newobj.parentStoreId = parent.currentTargetTreeElement.STOREID;  
		newobj.categoryId = element.id;
		newobj.storeId = element.STOREID ;
		newobj.linkId = (element.LINKID)? element.LINKID : "0" ;
		
		obj.categories[obj.categories.length] = newobj;

		// 
		// If there are children then make relationships
		if (element.parentNode.HASCHILDREN == "YES")
		{
			var elementRow = element.parentNode;
			var targetTable = elementRow.parentNode.parentNode.rows(elementRow.rowIndex+1).cells(1).firstChild;
			addCurrentSubtree(element, targetTable);
		}

		parent.workingFrame.submitFunction("NavCatLinkCatgroupControllerCmd", obj);
		obj = new Object();
		obj.relations = new Array();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// function addCurrentSubtree(parentElement, targetTable)
	//
	// - this function retreives the current subtree
	//////////////////////////////////////////////////////////////////////////////////////
	function addCurrentSubtree(parentElement, targetTable)
	{
		for (var i=0; i<targetTable.rows.length; i++)
		{
			var element = targetTable.rows(i).cells(1);
			var newobj = new Object();
			newobj.parentId = element.PARENTCAT;
			newobj.parentStoreId = parentElement.STOREID;
			newobj.categoryId = element.id;
			newobj.storeId = element.STOREID ;
			newobj.linkId = (element.LINKID)? element.LINKID : "0" ;
			
			obj.categories[obj.categories.length] = newobj;

			if (targetTable.rows(i).HASCHILDREN == "YES")
			{
				addCurrentSubtree(element,targetTable.rows(i+1).cells(1).firstChild);
			}
		 	i++;
		}
	}



	//////////////////////////////////////////////////////////////////////////////////////
	// function copyButton()
	//
	// - this function determines what has to be copied
	//////////////////////////////////////////////////////////////////////////////////////
	function copyButton(bCopyWithProducts)
	{
		var element = parent.currentSourceTreeElement;

		obj = new Object();
		obj.catalogId = parent.currentTargetDetailCatalog;
		obj.sourceCatalogId = parent.currentSourceDetailCatalog;
		obj.copyWithProducts = bCopyWithProducts;
		obj.categories = new Array();

		var newobj = new Object();
		newobj.parentId = parent.currentTargetTreeElement.id;   // get the new top level parent
		newobj.parentStoreId = parent.currentTargetTreeElement.STOREID;  
		newobj.categoryId = element.id;
		newobj.storeId = element.STOREID ;
		newobj.linkId = (element.LINKID)? element.LINKID : "0" ;
		
		obj.categories[obj.categories.length] = newobj;

		// 
		// If there are children then make relationships
		if (element.parentNode.HASCHILDREN == "YES")
		{
			var elementRow = element.parentNode;
			var targetTable = elementRow.parentNode.parentNode.rows(elementRow.rowIndex+1).cells(1).firstChild;
			addCurrentSubtree(element, targetTable);
		}

		parent.workingFrame.submitFunction("NavCatCopyCategoryControllerCmd", obj);
		obj = new Object();
		obj.relations = new Array();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// fcnOnContextMenu()
	//
	// - displays the context menu if a right-click event occured
	//////////////////////////////////////////////////////////////////////////////////////
	function fcnOnContextMenu()
	{
		if (parent.getWorkframeReady() == false) return;

		var popupBody = "";
		var element = event.srcElement;
		if (!hasCATEGORY(element)) return;

		toolbarSetHilite(element);

		while (element.tagName != "TD") element = element.parentElement;
		var index = element.parentNode.rowIndex;

		popupBody += "<DIV ID='divPopup' STYLE='width:196; font-size:12pt; background:#EFEFEF; color:black; border-color : WHITE; border-style : solid; border-width : 1px; filter: progid:DXImageTransform.Microsoft.Shadow(color=#777777, Direction=135, Strength=4);'>";

		(showMenu_Copy() == true) ? popupBody += divCopy_ON.outerHTML : popupBody += divCopy_OFF.outerHTML;
		(showMenu_Link() == true) ? popupBody += divLink_ON.outerHTML : popupBody += divLink_OFF.outerHTML;

		popupBody += "</DIV>";

		var yHeight = getObjPageY(event.srcElement) + 20 - document.body.scrollTop;

		oPopup.document.body.innerHTML = popupBody; 
		oPopup.show(event.clientX+2, yHeight, 200, 10, document.body);
		
		var nWidth=oPopup.document.getElementById('divPopup').scrollWidth;
		var nHeight=oPopup.document.getElementById('divPopup').scrollHeight;
		oPopup.show(event.clientX+2, yHeight, 
					oPopup.document.getElementById('divPopup').scrollWidth + 4,
					oPopup.document.getElementById('divPopup').scrollHeight + 4,
					document.body);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// showMenu_Link()
	//
	// - return true if the link function is to be displayed else return false
	//////////////////////////////////////////////////////////////////////////////////////
	function showMenu_Link()
	{
		if(parent.bStoreViewOnly)
			return false;
		return parent.sourceTreeFrameButtons.isLinkAllowed();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarLink()
	//
	// - this function performs a right click link command
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarLink()
	{
		oPopup.hide();
		parent.sourceTreeFrameButtons.linkButton();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// showMenu_Copy()
	//
	// - return true if the copy function is to be displayed else return false
	//////////////////////////////////////////////////////////////////////////////////////
	function showMenu_Copy()
	{
		if(parent.bStoreViewOnly)
			return false;

		if((parent.currentSourceTreeElement != null)&&(parent.currentSourceTreeElement.id != '0'))
		  if(parent.currentSourceTreeElement.LINKID == null || parent.sourceTreeFrameButtons.isLinkAllowed())
			return true;
			
		return false;	
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarCopy()
	//
	// - this function performs a right click copy command
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarCopy()
	{
		oPopup.hide();
		parent.sourceTreeFrameButtons.copyButton();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// onKeyUp(event)
	//
	// - keyup even handler
	//////////////////////////////////////////////////////////////////////////////////////
	function onKeyUp(event)
	{
		var keyCode = (event.keyCode)?(event.keyCode):(event.which);
		
		switch(keyCode)
		{
			case 37:		//left
			case 38:		//up
						hiLightUp(parent.currentSourceTreeElement);
						break;
			case 39:		//right
			case 40:		//down
						hiLightDown(parent.currentSourceTreeElement);
						break;
						
			case 13:		//enter
						hiLightExpand(parent.currentSourceTreeElement);
						break;			
		}
	}

</SCRIPT>

</HEAD>
<BODY CLASS=content ONLOAD=onLoad() ONCONTEXTMENU="return false;" onkeyup="onKeyUp(event);" >

<% 
	CatalogDataBean bnCatalog = new CatalogDataBean();
	bnCatalog.setCatalogId(strCatalogId);
	DataBeanManager.activate(bnCatalog, cmdContext);
	String name = bnCatalog.getIdentifier();
	Integer nCatalogStoreId=com.ibm.commerce.tools.catalog.util.AddCategoryToCategoryHelper.getCatalogStoreId(new Long(strCatalogId));
	Vector v = (Vector) hCategories.get(new Long(0));

	Hashtable h = new Hashtable();
	h.put("identifier", name);
	h.put("catgroup_id", "0");
	h.put("storeent_id", nCatalogStoreId.toString());
%>

<script>
	document.writeln("<b>" + parent.replaceField("<%=UIUtil.toJavaScript((String)rbCategory.get("categoryTreeFor"))%>", changeJavaScriptToHTML("<%=UIUtil.toJavaScript(name)%>")) + "</b><BR><BR>");
</script>	

	<TABLE border=0 ID=treeTable CELLPADDING=0 CELLSPACING=0 ONCONTEXTMENU="fcnOnContextMenu(); return false;">
		<%= handleCategory(h, new Long(0), "top", cmdContext, hCategories, v, hCounts, null) %>
	</TABLE>

	<DIV ID="divWorkSheet" STYLE="display:none;">
		<DIV ID=divCopy_ON
			onmouseover="this.style.background='#EDAC40';" 
			onmouseout="this.style.background='#EFEFEF';" 
			onclick="parent.toolbarCopy();"
			STYLE="font-family:verdana; font-size:70%; height:20px; background:#EFEFEF;  padding:3px; padding-left:10px; padding-right: 10px; cursor:hand ">
			<SPAN><%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceTreeButtons_Copy"))%></SPAN> 
		</DIV>
		<DIV ID=divCopy_OFF
			onmouseover="this.style.background='#EDAC40';" 
			onmouseout="this.style.background='#EFEFEF';" 
			STYLE="color: #888888; font-family:verdana; font-size:70%; height:20px; background:#EFEFEF;  padding:3px; padding-left:10px; padding-right: 10px; cursor:hand ">
			<SPAN><%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceTreeButtons_Copy"))%></SPAN> 
		</DIV>
		<DIV ID=divLink_ON
			onmouseover="this.style.background='#EDAC40';" 
			onmouseout="this.style.background='#EFEFEF';" 
			onclick="parent.toolbarLink();"
			STYLE="font-family:verdana; font-size:70%; height:20px; background:#EFEFEF;  padding:3px; padding-left:10px; padding-right: 10px; cursor:hand ">
			<SPAN><%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceTreeButtons_Link"))%></SPAN> 
		</DIV>
		<DIV ID=divLink_OFF
			onmouseover="this.style.background='#EDAC40';" 
			onmouseout="this.style.background='#EFEFEF';" 
			STYLE="color: #888888; font-family:verdana; font-size:70%; height:20px; background:#EFEFEF;  padding:3px; padding-left:10px; padding-right: 10px; cursor:hand ">
			<SPAN><%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceTreeButtons_Link"))%></SPAN> 
		</DIV>
	</DIV>

</BODY>
</HTML>
