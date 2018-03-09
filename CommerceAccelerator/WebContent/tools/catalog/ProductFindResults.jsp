<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<!--
catalog editor test JSP
-->

<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.*" %>

<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@include file="../common/common.jsp" %>
<%@include file="../common/List.jsp" %>

  
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
	String fulfillmentCenterId = UIUtil.getFulfillmentCenterId(request);
      %>
      
      <link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
      <TITLE><%= UIUtil.toHTML((String)ProductFindNLS.get("productList_Title")) %></TITLE>

      <%
            
      String jStoreID = cmdContext.getStoreId().toString();
      String jLanguageID = cmdContext.getLanguageId().toString();
      String jLocaleID = cmdContext.getLocale().toString();
      
 	StoreAccessBean sa = cmdContext.getStore();
	String jStoreType = sa.getStoreType();
	String jReportURL = "/webapp/wcs/tools/servlet/ShowContextList?context=B2B_ProductsReports&contextConfigXML=reporting.OperationalReportsContext&ActionXMLFile=bi.prodRptscontextList";
	if (jStoreType != null) {
	  if (jStoreType.equalsIgnoreCase("B2C") || jStoreType.equalsIgnoreCase("RHS") || jStoreType.equalsIgnoreCase("MHS")) {
          jReportURL = "/webapp/wcs/tools/servlet/ShowContextList?context=B2C_ProductsReports&contextConfigXML=reporting.OperationalReportsContext&ActionXMLFile=bi.prodRptscontextList";
        }
	}
	

      String strCategoryId = request.getParameter("parentCategoryID");
      CatalogListBean cList = new CatalogListBean();
      

    String orderByParm = request.getParameter("orderby");
	String strPartNumber=request.getParameter("ProductPartNumber");
	String strProductName=request.getParameter("ProductName");
	String strShortDesc=request.getParameter("ProductShortDescription");
	String strCategoryName=request.getParameter("categoryName");
	
	if( ((strProductName != null)&& (strProductName.trim().length()>0))  
	  ||((strShortDesc !=null) && (strShortDesc.trim().length()>0))
	  ||((strCategoryName !=null) && (strCategoryName.trim().length()>0)))		//they are language dependent
           cList.setLanguageID(jLanguageID);			

      cList.setStoreID(jStoreID);
      cList.setCatalogEntryType("Product");

      cList.setOrderBy(orderByParm);
      
      cList.setPartNumber(strPartNumber);
      cList.setPartNumberCaseSensitive(request.getParameter("partNumberCaseSensitive"));
      cList.setPartNumberLike(request.getParameter("partNumberLike"));
      
      cList.setName(strProductName);
      cList.setNameCaseSensitive(request.getParameter("nameCaseSensitive"));
      cList.setNameLike(request.getParameter("nameLike"));
      
      cList.setShortDescription(strShortDesc);
      cList.setShortDescriptionCaseSensitive(request.getParameter("shortDescriptionCaseSensitive"));
      cList.setShortDescriptionLike(request.getParameter("shortDescriptionLike"));
      
      cList.setParentCategoryID(request.getParameter("parentCategoryID"));

      //cList.setCategoryCode(request.getParameter("categoryCode"));
      //cList.setCategoryCodeLike(request.getParameter("categoryCodeLike"));
      //cList.setCategoryCodeCaseSensitive(request.getParameter("categoryCodeCaseSensitive"));

      cList.setCategoryName(strCategoryName);
      cList.setCategoryNameLike(request.getParameter("categoryNameLike"));
      cList.setCategoryNameCaseSensitive(request.getParameter("categoryNameCaseSensitive"));

	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;

      cList.setIndexBegin(""+startIndex);
      cList.setIndexEnd(""+endIndex);

      com.ibm.commerce.beans.DataBeanManager.activate(cList, request);

	int rowselect = 1;
	int totalsize = cList.getNumberOfCatentries().intValue();
	int totalpage = (totalsize+listSize-1)/listSize;
     
      %>

      <SCRIPT>

        var storeID = "<%= jStoreID %>";
        var languageID = "<%= jLanguageID %>";
        var reportURL = "<%= jReportURL %>";
        var categoryId = "<%=UIUtil.toJavaScript( strCategoryId )%>";

        function onLoad()
        {
          parent.loadFrames();
        }

        function getRefNum()
        {
          return parent.getChecked();
        }

        function getResultsSize(){
            return <%=totalsize%>;
        }

        function getFindTitle() {
            return "<%=UIUtil.toJavaScript((String)ProductFindNLS.get("productUpdateTitle"))%>";
        }

	function getSKUTitle() {
	  
        	var checkedProductRefNum = parent.getChecked();
        
        	<% for (int i = 0; i < cList.getListSize(); i++){ %>
        
			if(checkedProductRefNum == "<%=cList.getCatalogListData(i).getCatalogEntryID()%>"){

				return ("<%=UIUtil.toJavaScript(cList.getCatalogListData(i).getName())%>" + "  -  " + "<%=UIUtil.toJavaScript((String)ProductFindNLS.get("skuTitle"))%>");
			
			}
	
		<%}%>	      		  

        }

	  function getNewTitle() {
            return "<%=UIUtil.toJavaScript((String)ProductFindNLS.get("newProduct"))%>";
        }

        function getPricingTitle() {
            return "<%=UIUtil.toJavaScript((String)PricingResource.get("pricingTitle"))%>";
        }

        function getPricingSummaryTitle() {
            return "<%=UIUtil.toJavaScript((String)PricingResource.get("pricingSummaryTitle"))%>";
        }

        function getLang() {
            return languageID;
        }
        
        function getStore() {
            return storeID;
        }

        function getCategoryId() { 
            return categoryId;
        }

        
        function getAttributeTitle() {
        
        	var checkedProductRefNum = parent.getChecked();
        
        	<% for (int i = 0; i < cList.getListSize(); i++){ %>
        
			if(checkedProductRefNum == "<%=cList.getCatalogListData(i).getCatalogEntryID()%>"){

				return ("<%=UIUtil.toJavaScript(cList.getCatalogListData(i).getName())%>" + "  -  " + "<%=UIUtil.toJavaScript((String)ProductFindNLS.get("attribute"))%>");
			
			}
	
		<%}%>	      	
        
        } 

        function button_Discounts()
        {
	    var aCat=parent.getChecked().toString();        
          top.saveData(aCat,"categoryId");
          top.setContent("<%=ProductFindNLS.get("ProductFindResults_button_discounts")%>", 
          "/webapp/wcs/tools/servlet/DialogView?XMLFile=discount.choseDiscount", true);
         }

	function performItemGeneration() 
	{
	  if (confirmDialog("<%= UIUtil.toJavaScript((String)ProductFindNLS.get("itemGenerateConfirm")) %>")) 
	  {
		var strURL;
		strURL  = "/webapp/wcs/tools/servlet/ItemGenerate?";
		strURL += makeURLfromChecked("checkedProductRefNum",parent.getChecked());
		strURL += "&fulfillmentCenterId="  + <%=fulfillmentCenterId%>;
		strURL += makeURLfromGeneralForm();
		
		parent.location.replace(strURL);
  	   	top.showProgressIndicator(true);
  	   	//top.showContent(strURL,"");
	  }
	}  

	function performProductDelete() 
	{
	  if (confirmDialog("<%= UIUtil.toJavaScript((String)ProductFindNLS.get("productDeleteConfirm")) %>")) 
	  {
		var strURL;
		strURL  = "/webapp/wcs/tools/servlet/ProductDelete?";
		strURL += makeURLfromChecked("checkedProductRefNum",parent.getChecked());
		strURL += makeURLfromGeneralForm();
		
		parent.location.replace(strURL);
  	   	top.showProgressIndicator(true);
  	   	//top.showContent(strURL,"");
	  }
	}

	/**
	* construct the url parameters from parent.generalForm.
	*/  
	function makeURLfromGeneralForm()
	{
		var strURL;	

		strURL = "&orderby="+parent.generalForm.orderby.value;

		strURL += "&ProductPartNumber="+parent.generalForm.ProductPartNumber.value;
		strURL += "&partNumberCaseSensitive="+parent.generalForm.partNumberCaseSensitive.value;
		strURL += "&partNumberLike="+parent.generalForm.partNumberLike.value;
		
		strURL += "&ProductName="+parent.generalForm.ProductName.value;
		strURL += "&nameCaseSensitive="+parent.generalForm.nameCaseSensitive.value;
		strURL += "&nameLike="+parent.generalForm.nameLike.value;
		
		strURL += "&ProductShortDescription="+parent.generalForm.ProductShortDescription.value;
		strURL += "&shortDescriptionCaseSensitive="+parent.generalForm.shortDescriptionCaseSensitive.value;
		strURL += "&shortDescriptionLike="+parent.generalForm.shortDescriptionLike.value;
		
		strURL += "&parentCategoryID="+parent.generalForm.parentCategoryID.value;

        strURL += "&categoryCode="+parent.generalForm.categoryCode.value;
        strURL += "&categoryCodeCaseSensitive="+parent.generalForm.categoryCodeCaseSensitive.value;
        strURL += "&categoryCodeLike="+parent.generalForm.categoryCodeLike.value;

        strURL += "&categoryName="+parent.generalForm.categoryName.value;
        strURL += "&categoryNameCaseSensitive="+parent.generalForm.categoryNameCaseSensitive.value;
        strURL += "&categoryNameLike="+parent.generalForm.categoryNameLike.value;
		
		return strURL;
	}

	/**
	* construct the url parameters for the checked items.
	*/  
	function makeURLfromChecked(URLparam,checkedItems)
	{
		var strURL="";
		if(checkedItems.length > 0)
		{
			var strOneItem = checkedItems[0];
			strURL=URLparam + "=" + strOneItem;
			for (var i = 1; i < checkedItems.length; i++) 
			{
				strOneItem = checkedItems[i];
				strURL += "&" + URLparam + "=" + strOneItem;
			}
		}
		return strURL;
	}  


	function viewReports(){
        if (top.setContent)
        {
          top.setContent('<%=UIUtil.toJavaScript((String)ProductFindNLS.get("productList_button_inventory"))%>',
                                 reportURL,
                                 true);
	  }else{
          parent.location.replace(reportURL);
	  }
	}

        function changeProduct () {
           var productId = null;
           if ( arguments.length > 0 ) {
               productId = arguments[0];
               if (top.setContent) {
                   top.setContent(getFindTitle(), '/webapp/wcs/tools/servlet/NotebookView?XMLFile=catalog.productNotebook&amp;productrfnbr=' + productId + '&amp;langId=' + getLang() + '&amp;storeId=' + getStore(),true)
               } else {
	            parent.location.replace('/webapp/wcs/tools/servlet/NotebookView?XMLFile=catalog.productNotebook&amp;productrfnbr=' + productId + '&amp;langId=' + getLang() + '&amp;storeId=' + getStore());
               }
           }
        }                
      // -->
      </SCRIPT>

      <SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
      <SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
      	
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
      
<%=comm.addControlPanel("catalog.productListActions",totalpage,totalsize,jLocale)%> 
      <FORM NAME="ProductFindResultsFORM">

	
        <%= comm.startDlistTable((String)ProductFindNLS.get("accessProducts")) %>
        <%= comm.startDlistRowHeading() %>
        <%= comm.addDlistCheckHeading() %>
        <%= comm.addDlistColumnHeading((String)ProductFindNLS.get("sku"),"CATENTRY.PARTNUMBER",orderByParm.equals("CATENTRY.PARTNUMBER") ) %>
        <%= comm.addDlistColumnHeading((String)ProductFindNLS.get("productFindResults_Heading2"),"CATENTDESC.NAME",orderByParm.equals("CATENTDESC.NAME") ) %>
        <%= comm.addDlistColumnHeading((String)ProductFindNLS.get("productFindResults_Heading3"),"CATENTDESC.SHORTDESCRIPTION",orderByParm.equals("CATENTDESC.SHORTDESCRIPTION") ) %>
        <%= comm.addDlistColumnHeading((String)ProductFindNLS.get("Category"),"CATGRPDESC.NAME",orderByParm.equals("CATGRPDESC.NAME") ) %>
        <%= comm.addDlistColumnHeading((String)ProductFindNLS.get("skuTitle"),null,orderByParm.equals("ORDER_BY_NUM_OF_SKU") ) %>
        
        <%= comm.endDlistRow() %>

   
          <%
          
	
	  Hashtable allRoles = null;
	  String seller = null;
	  String podMgr = null;
	  String buyer = null;
	  String catMgr = null;
	
	

	  allRoles = Util.getAllRoles();
	  seller = (String)allRoles.get("seller");
	  podMgr = (String)allRoles.get("podMgr");
	  buyer = (String)allRoles.get("buyer");
	  catMgr = (String)allRoles.get("catMgr");

		
  	  Long owner_id = ECStringConverter.StringToLong(sa.getMemberId());
	  Vector currentUserRoles = Util.getRoles(cmdContext.getUser(), owner_id);
		         
          
          for (int i = 0; i < cList.getListSize(); i++)
          {
          %>
	        <%= comm.startDlistRow(rowselect) %>
	        <%= comm.addDlistCheck( cList.getCatalogListData(i).getCatalogEntryID().toString(),"none" ) %>
	        
	  <%
	  
	  if (cmdContext.getUser().isSiteAdministrator() || 
			currentUserRoles.contains(seller) || 
			currentUserRoles.contains(podMgr) || 
			currentUserRoles.contains(buyer) || 
			currentUserRoles.contains(catMgr) )
	  {
			
	  %>	
	  	        
	        <%= comm.addDlistColumn( UIUtil.toHTML(cList.getCatalogListData(i).getPartNumber()),UIUtil.toHTML("javascript:changeProduct(" + cList.getCatalogListData(i).getCatalogEntryID().toString() + ")"), (String)ProductFindNLS.get("sku")) %>

	  <%	  
	  }else{	  
	  %>	        

	        <%= comm.addDlistColumn( UIUtil.toHTML(cList.getCatalogListData(i).getPartNumber()),"none", (String)ProductFindNLS.get("sku")) %>

	  <%
	  }
	  %>	        
	        
	        
	        <%= comm.addDlistColumn( cList.getCatalogListData(i).getName(),"none", (String)ProductFindNLS.get("productFindResults_Heading2")) %>
	        <%= comm.addDlistColumn( cList.getCatalogListData(i).getShortDescription(),"none", (String)ProductFindNLS.get("productFindResults_Heading3")) %>
	        <%= comm.addDlistColumn( cList.getCatalogListData(i).getCategoryName(),"none", (String)ProductFindNLS.get("Category")) %>
	        <%= comm.addDlistColumn( cList.getCatalogListData(i).getNumOfSKUs().toString(),"none", (String)ProductFindNLS.get("skuTitle")) %>
	        
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
    
    
    <%      
          if(totalsize == 0){
          
    %>
          <BR>
          <%=UIUtil.toHTML((String) ProductFindNLS.get("emptyProductList"))%>
        
    <%
    	  }
    	  
    %>
    
    <%@include file="MsgDisplay.jspf" %>
    
    <%	  
          
      } catch (Exception e)	{
      
         com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
      }
    %>
      
      </FORM>

      <SCRIPT>
        <!--
          parent.afterLoads();
          parent.setResultssize(getResultsSize());
        //-->
      </SCRIPT>

    </BODY>

      

  </HTML>


