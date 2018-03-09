<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2003-2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<HTML>
<HEAD>

<%@ page import = "java.util.*" %>
<%@ page import = "com.ibm.commerce.command.CommandContext" %>
<%@ page import = "com.ibm.commerce.tools.util.*" %>

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	com.ibm.commerce.server.JSPHelper helper = new com.ibm.commerce.server.JSPHelper(request);
	String strMessage    = helper.getParameter("SubmitFinishMessage");
	String strResult     = helper.getParameter("resultString");
	String strCategoryId = helper.getParameter("categoryId");
	String strIdentifier = helper.getParameter("identifier");
%>

<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatWorkFrame_Title"))%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css"> 

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/ConvertToXML.js"></SCRIPT>


<SCRIPT>

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called upon load of the page
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad()
	{
		top.showProgressIndicator(false);
		parent.setWorkframeReady(true);

		if (defined(parent.currentTargetTreeElement))
		{
			var targetCatalogId  = parent.currentTargetDetailCatalog;
			var targetParentId   = parent.currentTargetTreeElement.PARENTCAT;
			var targetCategoryId = parent.currentTargetTreeElement.id;
		}

		if (defined(parent.currentSourceTreeElement))
		{
			var sourceCatalogId  = parent.currentSourceDetailCatalog;
			var sourceParentId   = parent.currentSourceTreeElement.PARENTCAT;
			var sourceCategoryId = parent.currentSourceTreeElement.id;
		}

<%
		if (strMessage != null) 
		{ 

			if (!strMessage.equals("msgNavCatRenameCatgroupControllerCmdFinished"))	// &&
			    //!strMessage.equals("msgNavCatSequenceCategoryControllerCmdFinished"))
			{
%>
				alertDialog("<%=UIUtil.toJavaScript(rbCategory.get(strMessage))%>");
<%
			}


			if ( strMessage.equals("msgNavCatSequenceCategoryControllerCmdFinished") || 
				 strMessage.equals("msgNavCatAddProductRelationsControllerCmdFinished") ||
				 strMessage.equals("msgNavCatAddProductRelationControllerCmdFinished") || 
				 strMessage.equals("msgNavCatRemoveProductRelationsControllerCmdFinished")) { 
				 if (strResult == null || strResult.equals("null")) { strResult="none"; }
%>
				parent.refreshTargetProducts("<%=strResult%>");
				//parent.refreshTargetTree();
<%
			} else if (strMessage.equals("msgNavCatCopyCategoryControllerCmdFinished")) { 
%>
				//parent.targetTreeFrame.addTreeCategoriesByCatalogAndResultstring(targetCatalogId, "<%=strResult%>");
				//if (parent.sourceTreeFrame.treeLoaded) parent.sourceTreeFrame.addTreeCategoriesByCatalogAndResultstring(targetCatalogId, "<%=strResult%>");
				parent.refreshTargetTree(null,true);
				//if (parent.targetChildrenContent.refresh) parent.targetChildrenContent.refresh("none");
<%
			} else if (strMessage.equals("msgNavCatDeleteCatgroupControllerCmdFinished")) { 
%>
				//parent.targetTreeFrame.removeTreeCategory(targetCategoryId);
				//if (parent.sourceTreeFrame.treeLoaded) parent.sourceTreeFrame.removeTreeCategory(targetCategoryId);
				parent.refreshTargetTree(null);
<%
			} else if (strMessage.equals("msgNavCatRemoveCatgroupControllerCmdFinished")) { 
%>
				//parent.targetTreeFrame.removeTreeCategoriesByCatalogAndParent(targetCatalogId, "<%=strCategoryId%>", "<%=strResult%>");
				//if (parent.sourceTreeFrame.treeLoaded) parent.sourceTreeFrame.removeTreeCategoriesByCatalogAndParent(targetCatalogId, "<%=strCategoryId%>", "<%=strResult%>");
				parent.refreshTargetTree();
				//if (parent.targetChildrenContent.refresh) parent.targetChildrenContent.refresh("none");
<%
			} else if (strMessage.equals("msgNavCatSequenceCategoriesControllerCmdFinished")) { 
%>
				parent.refreshTargetTree(null, true);
				//if (parent.targetChildrenContent.refresh) parent.targetChildrenContent.refresh("<%=strResult%>");
<%
			} else if (strMessage.equals("msgNavCatRenameCatgroupControllerCmdFinished")) { 
%>
				parent.targetTreeElementChanged();
				parent.targetTreeFrame.renameTreeCategory("<%=strCategoryId%>", "<%=UIUtil.toJavaScript(strIdentifier)%>");
				if (parent.sourceTreeFrame.treeLoaded) parent.sourceTreeFrame.renameTreeCategory("<%=strCategoryId%>", "<%=UIUtil.toJavaScript(strIdentifier)%>");
<%
			} else if (strMessage.equals("msgNavCatReparentCatgroupControllerCmdFinished")) { 
%>
				//parent.refreshTargetTree("<%=strResult%>");
				parent.refreshTargetTree(null, true);
<%
			} else if (strMessage.equals("msgNavCatCategoryUpdateControllerCmdFinished")) { 
%>
				parent.hideEditCategory();
				parent.targetTreeFrame.renameTreeCategory("<%=strCategoryId%>", "<%=UIUtil.toJavaScript(strIdentifier)%>");
				if (parent.sourceTreeFrame.treeLoaded) parent.sourceTreeFrame.renameTreeCategory("<%=strCategoryId%>", "<%=UIUtil.toJavaScript(strIdentifier)%>");
<%
			} else if (strMessage.equals("msgNavCatCategoryCreateControllerCmdFinished")) { 
%>
				parent.createCategory.afterSuccess();
				parent.refreshTargetTree(null, true);
<%
			} else if (strMessage.equals("msgNavCatLinkCatgroupControllerCmdFinished")) { 
%>
				//parent.targetTreeFrame.addLinkTreeCategoriesByCatalog(targetCatalogId, "<%=strResult%>");
				//if (parent.sourceTreeFrame.treeLoaded) parent.sourceTreeFrame.addLinkTreeCategoriesByCatalog(targetCatalogId, "<%=strResult%>");
				parent.refreshTargetTree(null, true);
				//if (parent.targetChildrenContent.refresh) parent.targetChildrenContent.refresh("none");
<%
			} else if (strMessage.equals("msgNavCatRenameCatgroupControllerCmdFailed") || strMessage.equals("msgNavCatRenameCatgroupControllerCmdDuplicate") ) {
%>
				parent.targetTreeFrame.toolbarRenameFailed();
<%
			}
		} 
%>
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// submitFunction(action, obj)
	//
	// @param action - the action which will be submitted to the server
	// @param obj - the object which contains the data to submit to the action
	//
	// - this function submits the requested action to the server
	//////////////////////////////////////////////////////////////////////////////////////
	function submitFunction(action, obj)
	{
		top.showProgressIndicator(true);
		form1.action = action;
		form1.XML.value = convertToXML(obj, "XML");
		form1.submit();
		parent.setWorkframeReady(false);
	}

</SCRIPT>

</HEAD>

<BODY CLASS="button" ONLOAD=onLoad() ONCONTEXTMENU="return false;">

	<FORM name="form1" ACTION="dummy" ONSUBMIT="return false;" METHOD="POST">
		<INPUT TYPE=HIDDEN NAME=XML VALUE="">
	</FORM>

</BODY>
</HTML>
