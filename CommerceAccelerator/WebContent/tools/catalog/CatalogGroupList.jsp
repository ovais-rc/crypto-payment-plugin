

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<HTML>
<!--
catalog editor test JSP
-->
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.AccessControlHelperDataBean" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.CatalogGroupListDataBean" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.CatalogGroupDataBean" %>
<%@ page import="com.ibm.commerce.tools.catalog.commands.CategoryUpdate" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.attachment.common.ECAttachmentConstants" %>
<%@include file="../common/common.jsp" %>


    <HEAD>
      <%= fHeader %>
      <%
      try {
      CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
      Locale jLocale = cmdContext.getLocale();
      Hashtable ProductFindNLS = (Hashtable) ResourceDirectory.lookup("catalog.ProductNLS", jLocale);
      Hashtable PricingResource = (Hashtable)ResourceDirectory.lookup("catalog.PricingNLS", jLocale);
      Hashtable AttributeNLS = (Hashtable) ResourceDirectory.lookup("catalog.AttributeNLS", jLocale);
      Hashtable ItemNLS = (Hashtable) ResourceDirectory.lookup("catalog.ItemNLS", jLocale);
      Hashtable CategoryNLS = (Hashtable) ResourceDirectory.lookup("catalog.CategoryNLS", jLocale);

      String orderByParm = request.getParameter("orderby");

	CatalogGroupListDataBean catGroupList;
	CatalogGroupDataBean catGroups[] = null;
	catGroupList = new CatalogGroupListDataBean();
	catGroupList.setAcceleratorFlag(true);
	DataBeanManager.activate(catGroupList, request);
	
	catGroups = catGroupList.getCatalogGroupList();
	
	int totalsize = catGroupList.getNumberOfCategories().intValue();
	
	String myInterfaceName = CategoryUpdate.NAME;
	AccessControlHelperDataBean myACHelperBean= new AccessControlHelperDataBean();
	myACHelperBean.setInterfaceName(myInterfaceName);
	DataBeanManager.activate(myACHelperBean,cmdContext);
	
	// to do, need to change to get value from access control helper after access control is done
	boolean attachmentAccessGained = true;
	
      %>
      
      <link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
      
      <TITLE><%= UIUtil.toHTML((String)CategoryNLS.get("catalogGroup_title")) %></TITLE>
	<script src="/wcs/javascript/tools/attachment/Constants.js"></script>
      <SCRIPT>
      
      var readonlyAccess = <%=myACHelperBean.isReadOnly()%>;
      var attachmentAccessGained = <%=attachmentAccessGained%>;
      
      var catalogGroup = new Array();
      <% 
         for (int i = 0; i < catGroups.length; i++)
         {
		    CatalogGroupDataBean catGroup = catGroups[i];
      %>
            catalogGroup['<%=catGroup.getCatGroupId() %>'] = new Object();
            catalogGroup['<%=catGroup.getCatGroupId() %>'].doIOwn = <%=catGroup.doIOwn() %>;
      <%
         }
      %>
      
      	function onLoad()
        {
          parent.loadFrames();
        }
        
	function getCategoryDelConfirmMsg()
	{
	    return "<%= UIUtil.toJavaScript((String)CategoryNLS.get("categoryDeleteConfirm")) %>"
	}
	
	function getDoNotOwnCategoriesMsg()
	{
	    return "<%= UIUtil.toJavaScript((String)CategoryNLS.get("categoryTree_delete_disabled")) %>"
	}
	
	function getNewCategoryTitle() {
            return "<%=UIUtil.toJavaScript((String)CategoryNLS.get("categoryCreateTitle"))%>";
      }

	function getChangeCategoryTitle() {
            return "<%=UIUtil.toJavaScript((String)CategoryNLS.get("categoryUpdateTitle"))%>";
      }

	function getListProductsTitle() {
            return "<%=UIUtil.toJavaScript((String)CategoryNLS.get("productListTitle"))%>";
      }

      function changeCategory () {
 	var categoryId = null;
	if (arguments.length > 0) {
	   categoryId = arguments[0];
           if (top.setContent) {
                top.setContent( getChangeCategoryTitle(), "/webapp/wcs/tools/servlet/NotebookView?XMLFile=catalog.categoryNotebook&amp;categoryId=" + categoryId + "&amp;path=&amp;bCreate=false", true);
           } else {
	        parent.location.replace("/webapp/wcs/tools/servlet/NotebookView?XMLFile=catalog.categoryNotebook&amp;categoryId=" + categoryId + "&amp;path=&amp;bCreate=false");
           }
	}
      }

      function createCategoryAction() 
      {
        if (readonlyAccess == false)
        {
          top.setContent(getNewCategoryTitle(), '/webapp/wcs/tools/servlet/WizardView?XMLFile=catalog.categoryWizard&amp;categoryId=&amp;path=&amp;bCreate=true', true)
        }
        else 
        {
		  alertDialog("<%=UIUtil.toJavaScript((String)CategoryNLS.get("categoryTree_create_disabled"))%>");
		}
      }
      
      function updateCategoryAction(catGrpID) 
      {
        if (catalogGroup[catGrpID].doIOwn)
        {
          top.setContent(getChangeCategoryTitle(), "/webapp/wcs/tools/servlet/NotebookView?XMLFile=catalog.categoryNotebook&amp;categoryId=" + catGrpID + "&amp;path=&amp;bCreate=false", true)
        }
        else 
        {
		  alertDialog("<%=UIUtil.toJavaScript((String)CategoryNLS.get("categoryTree_update_disabled"))%>");
		}
      }
      
      function listProductAction(catGrpID) {
		top.setContent(getListProductsTitle(), "/webapp/wcs/tools/servlet/ProductUpdateDialog?catgroupID=" + catGrpID, true);
      }
 
	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarListAttachment(element)
	//
	// - check if it is a valid integer
	//////////////////////////////////////////////////////////////////////////////////////
	function showAttachmentsAction(catGrpID) {

		var url = top.getWebPath() + "AttachmentListDialogView";
		var urlPara = new Object();
		
		urlPara.objectType = "<%=ECAttachmentConstants.EC_ATCH_OBJECT_TYPE_CATALOG_GROUP%>";
		urlPara.objectId = catGrpID;
		urlPara.readOnly = !attachmentAccessGained;
		
		top.setContent("<%=UIUtil.toJavaScript((String) CategoryNLS.get("CatgroupTree_button_showAttachments"))%>", url, true, urlPara);   
	}
	
	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarAddAttachment(element)
	//
	// - check if it is a valid integer
	//////////////////////////////////////////////////////////////////////////////////////
	function addAttachmentsAction(catGrpID) {
		addAttachmentAction(catGrpID)
	}
	
	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarAddAttachment(element)
	//
	// - check if it is a valid integer
	//////////////////////////////////////////////////////////////////////////////////////
	function addAttachmentAction(catGrpID) {

		if (!attachmentAccessGained) {
			alertDialog("<%=UIUtil.toJavaScript((String)CategoryNLS.get("categoryTree_addAttachment_disabled"))%>");
			return;
		}
		
		var url 		= top.getWebPath() + "PickAttachmentAssetsTool";
		var urlPara  		= new Object();

		urlPara.objectId    = catGrpID;
		urlPara.objectType = "<%=ECAttachmentConstants.EC_ATCH_OBJECT_TYPE_CATALOG_GROUP%>";
		urlPara.saveChanges = true;
		urlPara.returnPage = CONSTANT_TOOL_LIST;
		
		top.setContent("<%=UIUtil.toJavaScript((String) CategoryNLS.get("CatgroupTree_button_addAttachment"))%>", url, true, urlPara);

	}


        // -->
      </SCRIPT>

      <SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
      <SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

      <FORM NAME="_formUsedByCategoryDelete">
        <INPUT TYPE="hidden" NAME="categoryKeyword" VALUE="<%= UIUtil.toHTML(request.getParameter("categoryKeyword")) %>" >
        <INPUT TYPE="hidden" NAME="keywordLike" VALUE="<%=UIUtil.toHTML( request.getParameter("keywordLike") )%>" >
        <INPUT TYPE="hidden" NAME="categoryName" VALUE="<%= UIUtil.toHTML(request.getParameter("categoryName")) %>" >
        <INPUT TYPE="hidden" NAME="nameLike" VALUE="<%=UIUtil.toHTML( request.getParameter("nameLike") )%>" >
        <INPUT TYPE="hidden" NAME="categoryShortDescription" VALUE="<%= UIUtil.toHTML(request.getParameter("categoryShortDescription")) %>" >
        <INPUT TYPE="hidden" NAME="shortDescriptionLike" VALUE="<%=UIUtil.toHTML( request.getParameter("shortDescriptionLike") )%>" >
        <INPUT TYPE="hidden" NAME="categoryLongDescription" VALUE="<%= UIUtil.toHTML(request.getParameter("categoryLongDescription")) %>" >
        <INPUT TYPE="hidden" NAME="longDescriptionLike" VALUE="<%=UIUtil.toHTML( request.getParameter("longDescriptionLike") )%>" >
      </FORM>
      
    </HEAD>

   <BODY class="content_list">
 
      <SCRIPT>
        <!--
        // For IE
        if (document.all) {
          onLoad();
        }
        //-->
      </SCRIPT>

<%
          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));
          int endIndex = startIndex + listSize;
          int rowselect = 1;
          int totalpage = (totalsize+listSize-1)/listSize;
%>

<%=comm.addControlPanel("catalog.catalogGroupList",totalpage,totalsize,jLocale)%>


      <FORM NAME="CatGroupForm">
        <%= comm.startDlistTable((String)CategoryNLS.get("accessProducts")) %>
        <%= comm.startDlistRowHeading() %>
        <%= comm.addDlistCheckHeading() %>
        <% 
        	String strCategoryCodeHeading =(String)CategoryNLS.get("categoryCode"); 
           	if(strCategoryCodeHeading==null)
           	  strCategoryCodeHeading="Category Code";	//sorry, it's not in French yet.
        %>
        <%= comm.addDlistColumnHeading(strCategoryCodeHeading,"CATGROUP.IDENTIFIER",orderByParm.equals("CATGROUP.IDENTIFIER") ) %>
        <%= comm.addDlistColumnHeading((String)CategoryNLS.get("categoryList_Heading1"),"CATGRPDESC.NAME",orderByParm.equals("CATGRPDESC.NAME") ) %>
        <%= comm.addDlistColumnHeading((String)CategoryNLS.get("categoryList_Heading2"),"CATGRPDESC.SHORTDESCRIPTION",orderByParm.equals("CATGRPDESC.SHORTDESCRIPTION") ) %>
        <%= comm.endDlistRow() %>

          <%
          for (int i = 0; i < catGroups.length; i++)
          {
		CatalogGroupDataBean catGroup = catGroups[i];
	   %>

	        <%= comm.startDlistRow(rowselect) %>
	        <%= comm.addDlistCheck( catGroup.getCatGroupId().toString(),"none" ) %>
	        <%
	        	if (myACHelperBean.isReadOnly() || !catGroup.doIOwn() )
	        	{
	        %>
	        	<%= comm.addDlistColumn(UIUtil.toHTML(catGroup.getIdentifier()), "none") %>
	        <%  }
	            else
	            {
	        %>    
	        	 <%= comm.addDlistColumn(UIUtil.toHTML(catGroup.getIdentifier()), UIUtil.toHTML("javascript:changeCategory('" + catGroup.getCatGroupId().toString() + "')")) %>
	        <%
	        	 }
	        %>	 	
            <%= comm.addDlistColumn( catGroup.getName(), "none" ) %>
	        <%= comm.addDlistColumn( UIUtil.toHTML(catGroup.getShortDescription()),"none" ) %>
	        <%= comm.endDlistRow() %>
	 
	   <%
	            if(rowselect==1){
	               rowselect = 2;
	            }else{
	               rowselect = 1;
	            }
          } 
          %>
        <%= comm.endDlistTable() %>
        

        
      </FORM>

      <SCRIPT>
        <!--
          parent.afterLoads();
          parent.setResultssize(<%=totalsize%>);
          
        //-->
      </SCRIPT>
      
   <%@include file="MsgDisplay.jspf" %>   
      
   <%
      } catch (Exception e)	{
      
         com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
      }
    %>
         
      
    </BODY>
         
  </HTML>
