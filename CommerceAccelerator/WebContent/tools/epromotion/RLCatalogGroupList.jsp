
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!--
catalog editor test JSP
-->
<%@ page language="java" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.tools.common.ui.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@ page import="com.ibm.commerce.search.beans.CategorySearchListDataBean"%>
<%@ page import="com.ibm.commerce.search.beans.SearchConstants"%>
<%@ page import="com.ibm.commerce.search.rulequery.RuleQuery"%>
<%@ page import="com.ibm.commerce.catalog.beans.CategoryDataBean" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@include file="epromotionCommon.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%= UIUtil.toHTML((String)RLPromotionNLS.get("RLCatalogGroup_title")) %></title>
<%= fPromoHeader%>
<%
	 CategorySearchListDataBean catGroupList;
	 CategoryDataBean categories[] = null;
	 CommandContext cmdContext = null;
	 String orderByParm = "";
	 int totalsize = 0;
	 int resultCount =0;
	 int startIndex = 0;
	 int listSize = 10;
     try {
	     cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	     orderByParm = request.getParameter("orderby");
	     if (request.getParameter("startindex") == null) {
	         startIndex = 0;
	     } else {
	         startIndex = Integer.parseInt(request.getParameter("startindex"));
	     }
	     if (request.getParameter("listsize") == null) {
	         listSize = 10;
	     } else {
	         listSize = Integer.parseInt(request.getParameter("listsize")); 
	     }
	     String nameType="";
    	 String shortDescriptionType ="";
    	 String categoryName = request.getParameter("categoryName");
		 boolean nameLike= request.getParameter("nameLike").trim().equalsIgnoreCase("true");
		 String categoryShortDescription = request.getParameter("categoryShortDescription");
		 boolean shortDescriptionLike = request.getParameter("shortDescriptionLike").trim().equalsIgnoreCase("true");
		 if(nameLike)
		 {
		 	nameType="LIKE";
		 }
		 else
		 {
		 	nameType="EQUAL";
		 }

		 if(shortDescriptionLike)
		 {
		 	shortDescriptionType="LIKE";
		 }
		 else
		 {
		 	shortDescriptionType="EQUAL";
		 }

		 if(categoryShortDescription == null)
		 {
		 	categoryShortDescription ="";
		 }

		 if(categoryName == null)
		 {
		 	categoryName="";
		 }

    	 // search for categories based on the user input
		 catGroupList = new CategorySearchListDataBean();
		 catGroupList.setCommandContext(cmdContext);
		 //set the search on categories that are not marked for delete
		 catGroupList.setMarkForDelete("1");
		 catGroupList.setMarkForDeleteOperator( SearchConstants.OPERATOR_NOT_EQUAL);
		 
		 //set the store ID parameter to support store path
		 Integer anStoreId = cmdContext.getStoreId();
		 if ( anStoreId != null){
		 	Vector vStoreIDs = new RuleQuery().findStorePaths(anStoreId.intValue());
		 	catGroupList.setStoreId(((vStoreIDs.toString()).substring(1,(vStoreIDs.toString()).length())).replace(']',' ').trim() );
		 	catGroupList.setStoreIdOperator( SearchConstants.OPERATOR_IN );
		 }
		// catGroupList.setStoreId(cmdContext.getStoreId().toString());
		// catGroupList.setStoreIdOperator("IN");
		
		 // set the search criteria that only return the published categories:
		 catGroupList.setPublished("1");
		 catGroupList.setPublishedOperator(	SearchConstants.OPERATOR_EQUAL );
		 
		 catGroupList.setLangId(cmdContext.getLanguageId().toString());		
		 catGroupList.setUserId(cmdContext.getUserId().intValue());
		 catGroupList.setName(categoryName);		
		 catGroupList.setNameCaseSensitive("no");
		 catGroupList.setNameTermOperator(nameType);
		 catGroupList.setShortDesc(categoryShortDescription);
		 catGroupList.setShortDescCaseSensitive("no");
		 catGroupList.setShortDescOperator(shortDescriptionType);
		 
		 catGroupList.setBeginIndex(String.valueOf(startIndex));
		 catGroupList.setPageSize(String.valueOf(listSize));

 		 DataBeanManager.activate(catGroupList, request);		
	     categories = catGroupList.getResultList();
	     resultCount = categories.length;
	     try{	  
	     	totalsize = Integer.parseInt(catGroupList.getResultCount().trim());
	     } catch (Exception ex){
	     	totalsize = 0;
	     }

	} catch (Exception e)	{
      	com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
     }
 %>

<script>	
  	var resultContainer = new Array();
	var resultIndex = 0;
	var noIdentifierMessage = '<%=RLPromotionNLS.get("noCategoryIdentifier")%>';
		
	top.mccmain.mcccontent.isInsideWizard = function() {
 	 return true;
	}		
       
    function onLoad () {
		parent.loadFrames();
		parent.parent.setContentFrameLoaded(true);
	}  
		
	// Function is called when the checkbox is checked/unchecked
	function setChecked(checkObject){
		for (var i=0; i<resultContainer.length; i++) {
	    	if(checkObject.value == resultContainer[i].categoryId)
			{
				var catIdent = resultContainer[i].categoryIdentifier;
				if(catIdent == null || catIdent == '') // Check if the category selected has identifier
				{
					alertDialog(noIdentifierMessage);
				}
				else
				{
					parent.setChecked();
				}					
				break;
			}
		}		
	}

</script>

<script src="/wcs/javascript/tools/common/Util.js">
</script>
<script src="/wcs/javascript/tools/common/dynamiclist.js">
</script>

</head>

<body onload="onLoad();" class="content_list">

  <script>
  	// Populate the category details into JScript array (resultContainer) 
    <%	for (int i=0; i<categories.length; i++) { %>
		resultContainer[resultIndex] = new Object();
		
		resultContainer[resultIndex].categoryId = "<%= categories[i].getCategoryId() %>";
		resultContainer[resultIndex].categoryIdentifier = "<%= categories[i].getIdentifier() %>";
		resultContainer[resultIndex].categoryName = "<%= categories[i].getDescription(cmdContext.getLanguageId()).getName() %>";
		resultIndex++;
	<% } %>
	
	    //Performs add action
    	function addAction()
		{
			var duplicateCgryList = new Array();
			var checked = parent.getChecked().toString();
			var params = checked.split(',');

			var catIdentifier = new Array();
			var catId = new Array();
			var catName = new Array();
			var counter = 0;
		
			for (var a=0; a<params.length; a++)
			{
				var eachRow = params[a].split(';');
				catId[counter] = eachRow[0];
				catIdentifier[counter] = eachRow[1];	
				catName[counter] = eachRow[2];					
				counter = counter+1;
			}
			
			var cgceMapList = top.getData("RLCatGrpCatEntMapList", 1);
			if (cgceMapList == null || cgceMapList == undefined) {
				cgceMapList = new Array();
			}
			
			for (var i = 0;i < counter; i++) {
				var newCatGpName = catIdentifier[i];
				var newCatGpId = catId[i];
				var duplicate = false;
				for (var j = 0;j < cgceMapList.length; j++) {
					var sep1Index = cgceMapList[j].indexOf("|");
					var sep2Index = cgceMapList[j].substring(sep1Index+1, cgceMapList[j].length).indexOf("|") + sep1Index + 1;
					var catGpName = trim(cgceMapList[j].substring(0, sep1Index));
					var catGpId = trim(cgceMapList[j].substring(sep1Index+1, cgceMapList[j].length));
					if (catGpName == newCatGpName) {
						cgceMapList[j] = catGpName + "|" + newCatGpId;
						duplicate = true;
						break;
					}
				}
				if (duplicate == false) {
					cgceMapList[cgceMapList.length] = newCatGpName + "|" + newCatGpId;
				}
			}
			top.saveData(cgceMapList,"RLCatGrpCatEntMapList");		
			
			var rlpagename=top.get("<%= RLConstants.RLPROMOTION_PROD_SEARCH_PAGE %>", null);
			var calCodeId = null;
				
			var rlPromo = top.get("RLPromotion");	// Get RLPromotion object from top
			var catlist = new Array();
			var catListToAdd = null;
			var catListIndex = 0;	
			if (rlPromo != null)  
			{			
				catListToAdd = rlPromo.<%= RLConstants.RLPROMOTION_CATGROUP_CODE %>;//Get category list from RLPromotion object
				if (catListToAdd != null)
				{
					catListIndex = catListToAdd.length;					
				}
				
				// If Category list length is greater than 0, append the ctegories selected in this page to that list								    
				if ( catListIndex > 0) 
				{
					var counter = 0;
					for (var a=0; a<catIdentifier.length; a++)
					{  
						var isDuplicateCgry = false;
						for (var b=0; b<catListIndex; b++)
						{ 
							if (catListToAdd[b] != null)
							{
								// check if duplicate category
								if (trim(catIdentifier[a]) == trim(catListToAdd[b]))											
								{ 
									duplicateCgryList[counter] = catIdentifier[a];
									counter++;
									isDuplicateCgry = true;
									break;
								}
							}
						}
						// If not duplicate category, append it to the list
						if (!isDuplicateCgry)
						{
							catListToAdd[catListIndex] = catIdentifier[a];
							catListIndex++;
						}
					}	
					rlPromo.<%= RLConstants.RLPROMOTION_CATGROUP_CODE %> = catListToAdd;						
				}
				else
				{
					rlPromo.<%= RLConstants.RLPROMOTION_CATGROUP_CODE %> = catIdentifier;
				}				
					
				var idListToAdd = rlPromo.<%= RLConstants.RLPROMOTION_CATGROUP_ID %>;
				var idListIndex = null;
				if (idListToAdd != null)
				{
					idListIndex = idListToAdd.length;
					if ( idListIndex > 0)
					{					
						for (var a=0; a<catId.length; a++)
						{
							var idDuplicate = false;
							for (var b=0; b<idListIndex; b++)
							{						
								if (trim(catId[a]) == trim(idListToAdd[b]))											
								{
									idDuplicate = true;
									break;
								}
							}
							if (!idDuplicate)						
							{
								idListToAdd[idListIndex] = catId[a];
								idListIndex++;
							}
						}	
						rlPromo.<%= RLConstants.RLPROMOTION_CATGROUP_ID %> = idListToAdd;													
					}
				}
				else
				{
					rlPromo.<%= RLConstants.RLPROMOTION_CATGROUP_ID %> = catId;
				}	
					
				var tempCatList = rlPromo.<%= RLConstants.RLPROMOTION_CATGROUP_CODE %>;
				top.sendBackData(rlPromo,"RLPromotion");
				top.sendBackData(tempCatList, "RLCategoryList");				
				calCodeId = rlPromo.<%= RLConstants.EC_CALCODE_ID %>;					
				
			}  // end of if rlPromo !=null
			else 
			{				
				catListToAdd = top.get("RLCategoryList");
				if (catListToAdd != null)
				{
					catListIndex = catListToAdd.length;					
				}
							
				if ( catListIndex > 0)
				{
					var counter = 0;
					for (var a=0; a<catIdentifier.length; a++)
					{  
						var isDuplicateCgry = false;
						for (var b=0; b<catListIndex; b++)
						{ 
							if (catListToAdd[b] != null)
							{
								if (trim(catIdentifier[a]) == trim(catListToAdd[b]))											
								{ 
									duplicateCgryList[counter] = catIdentifier[a];
									counter++;
									isDuplicateCgry = true;
									break;
								}
							}
						}
						if (!isDuplicateCgry)
						{
							catListToAdd[catListIndex] = catIdentifier[a];
							catListIndex++;
						}
					}						
					top.sendBackData(catListToAdd, "RLCategoryList");
				}
				else
				{					
					top.sendBackData(catIdentifier, "RLCategoryList");
				}		
					
				top.sendBackData(catId, "RLCategoryIdList");	
				calCodeId = null;							
			}
				 				
				
			if( (calCodeId == null) || (calCodeId == '') )
			{
				top.goBack();				
			}
			else
			{
				top.goBack();				
			}
		}
    
     
</script>

<%
	try
	{
      int rowselect = 1;
      int totalpage = totalsize/listSize;
      int endIndex = startIndex + listSize;
      if (endIndex > resultCount) {
		endIndex = resultCount;
	  }     

%>

		<%=comm.addControlPanel("RLPromotion.RLCatalogGroupList",totalpage,totalsize,fLocale)%>
	<form name="RLCatGroupForm" id="RLCatGroupForm">
		<%= comm.startDlistTable((String)RLPromotionNLS.get("CategorySearchSummary")) %>
		<%= comm.startDlistRowHeading() %>
		<%= comm.addDlistCheckHeading() %>
<%
		String strCategoryCodeHeading =(String)RLPromotionNLS.get("categoryCode"); 
	   	if(strCategoryCodeHeading==null)
	   	{
	   	  strCategoryCodeHeading="Category Code";	//sorry, it's not in French yet.
	   	}
%>
        <%= comm.addDlistColumnHeading(strCategoryCodeHeading, "none",false )%>
        <%= comm.addDlistColumnHeading((String)RLPromotionNLS.get("categoryList_Heading1"),"none", false) %>
        <%= comm.addDlistColumnHeading((String)RLPromotionNLS.get("categoryList_Heading2"),"none", false) %>
        <%= comm.addDlistColumnHeading((String)RLPromotionNLS.get("categoryList_Heading3"),"none", false) %>
        <%= comm.endDlistRow() %>

<%
          for (int i = 0; i < categories.length; i++)
          {
			CategoryDataBean category = categories[i];
			category.setCatalogId(cmdContext.getStore().getMasterCatalog().getCatalogReferenceNumber());
			category.setCommandContext(cmdContext);
			String catalogId = category.getCatalogId();
			// Get Parent categories of this category
			CategoryDataBean[] parent =	category.getParentCategories();
			StringBuffer parentCategory = new StringBuffer();

			if(parent.length >0)
			{
				for(int j=0; j<parent.length; j++){
					String parentCgry = parent[0].getDescription(cmdContext.getLanguageId()).getName();
					if(parentCgry != null)
					{
						if(parentCategory.length() > 0)
						{
							parentCategory.append(",");
						}
						parentCategory.append(parentCgry);
					}						
			     }
			}
			else // If no parent category then it is top level category
			{
				parentCategory.append((String)RLPromotionNLS.get("topCategory"));

			}			

%>
		 <%= comm.startDlistRow(rowselect) %>
	     <%= comm.addDlistCheck(category.getCategoryId()+";"+ encodeValue(category.getIdentifier()) +";"+ encodeValue(category.getDescription(cmdContext.getLanguageId()).getName()),"setChecked(this);",category.getCategoryId() ) %>
         <%= comm.addDlistColumn(UIUtil.toHTML(category.getIdentifier()), "none") %>
         <%= comm.addDlistColumn(UIUtil.toHTML(category.getDescription(cmdContext.getLanguageId()).getName()), "none" ) %>
 	     <%= comm.addDlistColumn(UIUtil.toHTML(category.getDescription(cmdContext.getLanguageId()).getShortDescription()),"none" ) %>	     	        
		 <%= comm.addDlistColumn(UIUtil.toHTML(parentCategory.toString()),"none") %>	     	        
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
	if(totalsize == 0)
	{ 
%>        
		<p></p><p>
		<%= RLPromotionNLS.get("ProductSearchEmpty") %>
<%
	}
%>

   </p></form>

      <script>
        <!--
          parent.afterLoads();
          parent.setResultssize(<%=totalsize%>);
          
        //-->
      
</script>

   <%
      } catch (Exception e)	{
      		com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
      }
    %>

</body>
</html>
