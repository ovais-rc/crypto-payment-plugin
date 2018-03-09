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
		result += "<TD CLASS=jtree ALIGN=LEFT NOWRAP ONCLICK=fcnOnClick(this) ONDBLCLICK=fcnOnDblClick(this) LOCK="+strLock+strLinkId+" PARENTCAT="+lParentId+" STOREID="+iStoreId+" ID=\""+lCategoryId+"\"><SPAN><img SRC=/wcs/images/tools/catalog/"+strImage+">"+strLinkImg+"</SPAN><SPAN UNSELECTABLE=on>" + strCategoryName + "</SPAN><SPAN>"+strCount+"</SPAN></TD>\n";
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
		result += "<TD CLASS=jtree ALIGN=LEFT NOWRAP ONCLICK=fcnOnClick(this) ONDBLCLICK=fcnOnDblClick(this) LOCK="+strLock+strLinkId+" PARENTCAT="+lParentId+" STOREID="+iStoreId+" ID=\""+lCategoryId+"\"><SPAN><img SRC=/wcs/images/tools/catalog/"+strImage+">"+strLinkImg+"</SPAN><SPAN UNSELECTABLE=on>" + strCategoryName + "</SPAN><SPAN>"+strCount+"</SPAN></TD>\n";
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
	String startParent   = helper.getParameter("startParent"); 
	String strCatalogId  = helper.getParameter("catalogId"); 
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

	//check if the current target catalog is the master catalog	
	String strMasterCatalogId=cmdContext.getStore().getMasterCatalog().getCatalogReferenceNumber();
	boolean bIsMasterCatalog= strCatalogId.equals(strMasterCatalogId);

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

<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetTree_Title"))%></TITLE>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/NavCatCommonFunctions.js"></SCRIPT>

<SCRIPT>

// Global variables
	var lockStatus = "true";

	var currentCatalogId = '<%=strCatalogId%>'; // The catalog tree being drawn
	var toolbarCurrentElement = null;         // The currently selected element
	var toolbarCurrentColumn  = null;         // The currently selected column
	var toolbarHiliteElement  = null;         // The currently selected element
	var toolbarHiliteColor    = "#EDAC40";    // The currently hilited elements color
	var currentRenameOn       = false;        // If true then we are current renaming
	var currentReparentOn     = false;        // If true then we are current reparenting

	var oPopup   = window.createPopup();
	var currentRenameValue = null;
	var obj = new Object();
	obj.relations = new Array();

	var bIsTargetMasterCatalog = <%=bIsMasterCatalog%>;	  // If the current catalog is the master catalog

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
		if (parent.amidone == false) return;

		treeTable.rows(0).cells(0).firstChild.fireEvent("onclick");
		document.getElementById("0").fireEvent("onclick");

		if ( ("<%=startCategory%>" != "null") && ("<%=startCategory%>" != "0") )
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
		
		if (parent.targetChildrenContent.refresh) parent.targetChildrenContent.refresh("none");
		//if (parent.targetProductsContents.refresh) parent.targetProductsContents.refresh("none");
		//if (parent.sourceProductsContents.refresh) parent.sourceProductsContents.refresh("none");
		//if (parent.catentrySearchResultFrame.refresh) parent.catentrySearchResultFrame.refresh("none");
		//if (parent.categoriesResult.refresh) parent.categoriesResult.refresh("none");
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// onFirstLoad()
	//
	// - hilite the initial element
	//////////////////////////////////////////////////////////////////////////////////////
	function onFirstLoad()
	{
		treeTable.rows(0).cells(0).firstChild.fireEvent("onclick");
		document.getElementById("0").fireEvent("onclick");

		if ( ("<%=startCategory%>" != "null") && ("<%=startCategory%>" != "0") )
		{
			openTreeToCategoryAndParent("<%=startCategory%>", "<%=startParent%>");
			
			if("<%=strIsOpen%>"=="true")
			  if(document.getElementById("<%=startCategory%>"))
				document.getElementById("<%=startCategory%>").parentNode.cells(0).firstChild.fireEvent("onclick");
		}	
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// resetButtons()
	//
	// - function which will reset the tree buttons
	//////////////////////////////////////////////////////////////////////////////////////
	function resetButtons()
	{
		if (parent.targetTreeFrameButtons.setButtons) parent.targetTreeFrameButtons.setButtons();
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
		if (parent.targetTreeFrameButtons.setButtons) parent.targetTreeFrameButtons.setButtons(status);
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
		if (currentRenameOn == true) toolbarRenameFailed();
		if (currentReparentOn == true) toolbarReparentDone(element);
		parent.setTargetElement(element,element.LOCK=='true');
		toolbarUnhilite();
		toolbarHilite(element);
		
		if (parent.sourceTreeFrameButtons.setButtons) parent.sourceTreeFrameButtons.setButtons();
		if (parent.sourceProductsContents.setChecked)parent.sourceProductsContents.setChecked();
		if (parent.catentrySearchResultFrame.setChecked)parent.catentrySearchResultFrame.setChecked();		
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
		
		//if (element != parent.currentTargetTreeElement) 									//d71854
		if ((element != parent.currentTargetTreeElement) || (currentReparentOn==true))
		{
			if(currentRenameOn)
				toolbarRenameDone();
			parent.targetTreeElementChanged();
			if (element.PARENTCAT) toolbarSetHilite(element);
		}	
		//element.focus();
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// fcnOnDblClick()
	//
	// - edit the category if it's allowed
	//////////////////////////////////////////////////////////////////////////////////////
	function fcnOnDblClick(element)
	{
		parent.targetTreeFrameButtons.editButton();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// fcnOnContextMenu()
	//
	// - displays the context menu if a right-click event occured
	//////////////////////////////////////////////////////////////////////////////////////
	function fcnOnContextMenu()
	{
		if (parent.getWorkframeReady() == false) return;
		if (currentReparentOn == true) return;

		var popupBody = "";
		var element = event.srcElement;
		if (!hasCATEGORY(element)) return;

		while (element.tagName != "TD") element = element.parentElement;

		if (currentRenameOn == true)
		{
			if(element!=parent.currentTargetTreeElement)
				toolbarRenameDone();
			else
				return;
		}			

		toolbarSetHilite(element);

		var index = element.parentNode.rowIndex;

		popupBody += "<DIV ID='divPopup' STYLE='width:196; font-size:12pt; background:#EFEFEF; color:black; border-color : WHITE; border-style : solid; border-width : 1px; filter: progid:DXImageTransform.Microsoft.Shadow(color=#777777, Direction=135, Strength=4);'>";

		(showMenu_Edit() == true)     ? popupBody += divEdit_ON.outerHTML     : popupBody += divEdit_OFF.outerHTML;
		(showMenu_Rename() == true)   ? popupBody += divRename_ON.outerHTML   : popupBody += divRename_OFF.outerHTML;
		(showMenu_Products() == true) ? popupBody += divProducts_ON.outerHTML : popupBody += divProducts_OFF.outerHTML;

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
	// showMenu_Edit()
	//
	// - return true if the edit function is to be displayed else return false
	//////////////////////////////////////////////////////////////////////////////////////
	function showMenu_Edit()
	{
		if ( (lockStatus == "true") || (parent.currentTargetTreeElement.LINKID) || (parent.currentTargetTreeElement.id=="0") )
			 return false;
		
		if(parent.bStoreViewOnly)
			return false;
				 
		return true;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarEdit()
	//
	// - this function performs the category edit function
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarEdit()
	{
		oPopup.hide();
		parent.showEditCategory();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// showMenu_Rename()
	//
	// - return true if the rename function is to be displayed else return false
	//////////////////////////////////////////////////////////////////////////////////////
	function showMenu_Rename()
	{
		if ( (lockStatus == "true") || (parent.currentTargetTreeElement.LINKID) || (parent.currentTargetTreeElement.id=="0") )
			return false;
			
		if(parent.bStoreViewOnly)
			return false;
				
		return true;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarRename()
	//
	// - this function creates the input box for the renamed category
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarRename()
	{
		oPopup.hide();
		currentRenameOn = true;
		var element = getSpanElement(parent.currentTargetTreeElement);
		currentRenameValue = getCategoryIdentifier(parent.currentTargetTreeElement);
		element.innerHTML = "<INPUT CLASS=dtable VALUE=\""+currentRenameValue+"\" ONKEYPRESS=toolbarRenameOnKeyPress() ONBLUR=toolbarRenameDone()>";
		element.firstChild.focus();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarRenameOnKeyPress()
	//
	// - this function submits the rename when the enter key is pressed
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarRenameOnKeyPress()
	{
		if (event.keyCode == 27) toolbarRenameFailed();
		if (event.keyCode == 13) toolbarRenameDone();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarRenameDone()
	//
	// - this function submits the rename to the server
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarRenameDone()
	{
		currentRenameOn = false;
		var element = getSpanElement(parent.currentTargetTreeElement);
		value = element.firstChild.value;
		if (isInputStringEmpty(value))
		{
			alertDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTree_ErrorEmptyCode"))%>");
			element.innerHTML = changeJavaScriptToHTML(currentRenameValue);
		} else if (value == currentRenameValue) {
			element.innerHTML = changeJavaScriptToHTML(currentRenameValue);
			return;
		} else {
			element.innerHTML = changeJavaScriptToHTML(value);
			var outputObject = new Object();
			outputObject.catalogId    = parent.currentTargetDetailCatalog;
			outputObject.catgroupId   = parent.currentTargetTreeElement.id;
			outputObject.categoryCode = value;
			parent.workingFrame.submitFunction("NavCatRenameCatgroupControllerCmd", outputObject);
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarRenameFailed()
	//
	// - this function resets the category name upon a failure to change
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarRenameFailed()
	{
		currentRenameOn = false;
		var element = getSpanElement(parent.currentTargetTreeElement);
		element.innerHTML = changeJavaScriptToHTML(currentRenameValue);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// showMenu_Products()
	//
	// - return true if the list products function is to be displayed else return false
	//////////////////////////////////////////////////////////////////////////////////////
	function showMenu_Products()
	{
		if(parent.currentTargetTreeElement.id==0)
			return false;
		return true;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarProducts()
	//
	// - this function lists the products of the selected category
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarProducts()
	{
		oPopup.hide();
		parent.showTargetProducts();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// reparentButton()
	//
	// - this function processes a click of the display reparent button
	//////////////////////////////////////////////////////////////////////////////////////
	function reparentButton()
	{
		alertDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTree_ReparentMsg"))%>");
		currentReparentOn = true;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarReparentDone(element)
	//
	// @param element - the new parent element
	//
	// - this function processes a reparent
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarReparentDone(element)
	{
		currentReparentOn = false;
		//var outputObject = new Object();
		//outputObject.catalogId        = parent.currentTargetDetailCatalog;
		//outputObject.sourceCatgroupId = parent.currentTargetTreeElement.id;
		//outputObject.sourceParentId   = parent.currentTargetTreeElement.PARENTCAT;
		//outputObject.targetCatgroupId = element.id;
		
		var eSource= parent.currentTargetTreeElement;

		//prevent reparenting a link to top level for Cornerstone
//		if((eSource.LINKID) && (element.id=='0'))
//		{
//			alertDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTree_ErrorReparentLinkToTop"))%>");
//			return;		
//		}
		
		//prevent reparenting a locked category to another locked category
		if((eSource.LOCK=='true') && (element.LOCK=='true'))
		{
			alertDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTree_ErrorReparentLockToLock"))%>");
			return;		
		}
		

		obj = new Object();
		obj.catalogId = parent.currentTargetDetailCatalog;
		obj.targetCatgroupId = element.id;
		obj.targetStoreId= element.STOREID;
		
		obj.categories = new Array();

		var newobj = new Object();
		newobj.parentId = eSource.PARENTCAT;   // get the new top level parent
		newobj.parentStoreId = document.getElementById(eSource.PARENTCAT).STOREID;  
		newobj.categoryId = eSource.id;
		newobj.storeId = eSource.STOREID ;
		newobj.linkId = (eSource.LINKID)? eSource.LINKID : "0" ;
		
		obj.categories[obj.categories.length] = newobj;

		// 
		// If there are children then make relationships
		if (eSource.parentNode.HASCHILDREN == "YES")
		{
			var elementRow = eSource.parentNode;
			var targetTable = elementRow.parentNode.parentNode.rows(elementRow.rowIndex+1).cells(1).firstChild;
			addCurrentSubtree(eSource, targetTable);
		}

		parent.workingFrame.submitFunction("NavCatReparentCatgroupControllerCmd", obj);
		obj = new Object();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// function removeButton(parentCategoryId, arrayCategories)
	//
	// - this function determines what has to be removed
	//   if a parentCategoryId and an array of categories passed in, 
	//		-- the parent will not be removed
	//		-- only the categories in the array and their sub-trees will be removed
	//////////////////////////////////////////////////////////////////////////////////////
	function removeButton(parentCategoryId, arrayCategories)
	{
		var element;

		obj = new Object();
		
		if( (parentCategoryId != null) && (arrayCategories != null))						
		{
			element = document.getElementById(parentCategoryId);
			if(element==null)
				return;
			obj.removeFirstNode='false';
		}	
		else
		{
			element = parent.currentTargetTreeElement;
			obj.removeFirstNode='true';
		}	

		obj.catalogId = parent.currentTargetDetailCatalog;
		obj.categories = new Array();

		var newobj = new Object();
		newobj.parentId = element.PARENTCAT;   // get the new top level parent
		newobj.parentStoreId = document.getElementById(element.PARENTCAT).STOREID; 
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
			addCurrentSubtree(element, targetTable, arrayCategories);
		}

		parent.workingFrame.submitFunction("NavCatRemoveCatgroupControllerCmd", obj);
		obj = new Object();
		obj.relations = new Array();
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// function addCurrentSubtree(parentElement, targetTable)
	//
	// - this function retreives the current subtree
	//////////////////////////////////////////////////////////////////////////////////////
	function addCurrentSubtree(parentElement, targetTable, arrayCategories)
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
			
			//If we only build part of the tree
			if(arrayCategories != null)								
			{
				var bElementOnTheTree=false;
				for(var k=0; (k<arrayCategories.length && (bElementOnTheTree==false)); k++)
				{
					if(arrayCategories[k]==element.id)
						bElementOnTheTree=true;
				}
				if(bElementOnTheTree==false)
					continue;
			}
			
			obj.categories[obj.categories.length] = newobj;

			if (targetTable.rows(i).HASCHILDREN == "YES")
			{
				addCurrentSubtree(element,targetTable.rows(i+1).cells(1).firstChild, null);
			}
		 	i++;
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// onKeyUp(event)
	//
	// - keyup even handler
	//////////////////////////////////////////////////////////////////////////////////////
	function onKeyUp(event)
	{
		if(currentRenameOn)
			return;
			
		var keyCode = (event.keyCode)?(event.keyCode):(event.which);
		
		switch(keyCode)
		{
			case 37:		//left
			case 38:		//up
						hiLightUp(parent.currentTargetTreeElement);
						break;
			case 39:		//right
			case 40:		//down
						hiLightDown(parent.currentTargetTreeElement);
						break;
						
			case 13:		//enter
						hiLightExpand(parent.currentTargetTreeElement);
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
		<DIV ID=divEdit_ON
			onmouseover="this.style.background='#EDAC40';" 
			onmouseout="this.style.background='#EFEFEF';" 
			onclick="parent.toolbarEdit();"
			STYLE="font-family:verdana; font-size:70%; height:20px; background:#EFEFEF;  padding:3px; padding-left:10px; padding-right: 10px; cursor:hand ">
			<SPAN><%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetTree_Edit"))%></SPAN> 
		</DIV>
		<DIV ID=divEdit_OFF
			onmouseover="this.style.background='#EDAC40';" 
			onmouseout="this.style.background='#EFEFEF';" 
			STYLE="color: #888888; font-family:verdana; font-size:70%; height:20px; background:#EFEFEF;  padding:3px; padding-left:10px; padding-right: 10px; cursor:hand ">
			<SPAN><%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetTree_Edit"))%></SPAN> 
		</DIV>
		<DIV ID=divRename_ON
			onmouseover="this.style.background='#EDAC40';" 
			onmouseout="this.style.background='#EFEFEF';" 
			onclick="parent.toolbarRename();"
			STYLE="font-family:verdana; font-size:70%; height:20px; background:#EFEFEF;  padding:3px; padding-left:10px; padding-right: 10px; cursor:hand ">
			<SPAN><%=UIUtil.toHTML((String)rbCategory.get("NavCat_Rename"))%></SPAN> 
		</DIV>
		<DIV ID=divRename_OFF
			onmouseover="this.style.background='#EDAC40';" 
			onmouseout="this.style.background='#EFEFEF';" 
			STYLE="color: #888888; font-family:verdana; font-size:70%; height:20px; background:#EFEFEF;  padding:3px; padding-left:10px; padding-right: 10px; cursor:hand ">
			<SPAN><%=UIUtil.toHTML((String)rbCategory.get("NavCat_Rename"))%></SPAN> 
		</DIV>
		<DIV ID=divProducts_ON
			onmouseover="this.style.background='#EDAC40';" 
			onmouseout="this.style.background='#EFEFEF';" 
			onclick="parent.toolbarProducts();"
			STYLE="font-family:verdana; font-size:70%; height:20px; background:#EFEFEF;  padding:3px; padding-left:10px; padding-right: 10px; cursor:hand ">
			<SPAN><%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetTreeButtons_ListProducts"))%></SPAN> 
		</DIV>
		<DIV ID=divProducts_OFF
			onmouseover="this.style.background='#EDAC40';" 
			onmouseout="this.style.background='#EFEFEF';" 
			STYLE="color: #888888; font-family:verdana; font-size:70%; height:20px; background:#EFEFEF;  padding:3px; padding-left:10px; padding-right: 10px; cursor:hand ">
			<SPAN><%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetTreeButtons_ListProducts"))%></SPAN> 
		</DIV>
	</DIV>
</BODY>
</HTML>
