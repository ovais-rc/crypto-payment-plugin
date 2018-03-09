<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2000, 2005
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->

<html>

<head>

<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@ include file="../common/common.jsp" %>


    <%

      try {
	      CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	      Locale jLocale = cmdContext.getLocale();
          JSPHelper jspHelper = new com.ibm.commerce.server.JSPHelper(request);
	      Hashtable ProductFindNLS = (Hashtable) ResourceDirectory.lookup("catalog.ProductNLS", jLocale);
      	      Hashtable PricingResource = (Hashtable)ResourceDirectory.lookup("catalog.PricingNLS", jLocale);
              Hashtable AttributeNLS = (Hashtable) ResourceDirectory.lookup("catalog.AttributeNLS", jLocale);
              Hashtable ItemNLS = (Hashtable) ResourceDirectory.lookup("catalog.ItemNLS", jLocale);
              Hashtable CategoryNLS = (Hashtable) ResourceDirectory.lookup("catalog.CategoryNLS", jLocale);

          	//check if the SKU function is enabled	
	      String strExtFunctionSKU = jspHelper.getParameter("sku");

	      if (strExtFunctionSKU!= null && strExtFunctionSKU.trim().equalsIgnoreCase("true")) {
		     strExtFunctionSKU= "true";	
          }
	      else {
		     strExtFunctionSKU="false"; //disabled by default
          }
 
   %>
      		
      <SCRIPT>
	var newButton = "<%= UIUtil.toJavaScript((String)CategoryNLS.get("CatgroupTree_button_Create"))%>";
	var changeButton = "<%= UIUtil.toJavaScript((String)CategoryNLS.get("CatgroupTree_button_Update")) %>";
	var deleteButton = "<%= UIUtil.toJavaScript((String)CategoryNLS.get("CatgroupTree_button_Delete")) %>";
	var listButton = "<%= UIUtil.toJavaScript((String)CategoryNLS.get("CatgroupTree_button_Products")) %>";
	var newProductButton = "<%= UIUtil.toJavaScript((String)CategoryNLS.get("CatgroupTree_button_newProduct")) %>";
	var newBundleKitButton = "<%= UIUtil.toJavaScript((String)CategoryNLS.get("CatgroupTree_button_newBundleKit")) %>";
	var productReportsButton = "<%= UIUtil.toJavaScript((String)CategoryNLS.get("CatgroupTree_button_productReports")) %>";
	var showAttachmentsButton="<%= UIUtil.toJavaScript((String)CategoryNLS.get("CatgroupTree_button_showAttachments")) %>";;
	var addAttachmentButton="<%= UIUtil.toJavaScript((String)CategoryNLS.get("CatgroupTree_button_addAttachment")) %>";;
	
	var newCategory = "<%= UIUtil.toJavaScript((String)CategoryNLS.get("categoryCreateTitle")) %>";
	var changeCategory = "<%= UIUtil.toJavaScript((String)CategoryNLS.get("categoryUpdateTitle")) %>";
	var listCatalogEntries = "<%= UIUtil.toJavaScript((String)CategoryNLS.get("catalogEntriesListTitle")) %>";
	
	var newProductBCT = "<%=UIUtil.toJavaScript((String)ProductFindNLS.get("productUpdateDetailBCT_CreateProduct"))%>"
	var newBundleKitBCT = "<%=UIUtil.toJavaScript((String)ProductFindNLS.get("productUpdateDetailBCT_CreateKit"))%>";

        var pathId = "category_tree_path";
	
	function getHelp()
	{
		return "MC.catalogTool.categoryTree.Help";
	}

	function CategoryDelComfirm()
	{
	    return confirmDialog("<%= UIUtil.toJavaScript((String)CategoryNLS.get("categorySingleDeleteConfirm")) %>"); 
	}

	function NewCategoryNotSelect()
	{
	    return alertDialog("<%= UIUtil.toJavaScript((String)CategoryNLS.get("notHighlight_new")) %>"); 
	}

	function ChangeCategoryNotSelect()
	{
	    return alertDialog("<%= UIUtil.toJavaScript((String)CategoryNLS.get("notHighlight_change")) %>"); 
	}
	
	function AddAttachmentNotSelect()
	{
	    return alertDialog("<%= UIUtil.toJavaScript((String)CategoryNLS.get("notHighlight_addAttachment")) %>"); 
	}
	
	function ShowAttachmentNotSelect()
	{
	    return alertDialog("<%= UIUtil.toJavaScript((String)CategoryNLS.get("notHighlight_showAttachment")) %>"); 
	}
	
	function DeleteCategoryNotSelect()
	{
	    return alertDialog("<%= UIUtil.toJavaScript((String)CategoryNLS.get("notHighlight_delete")) %>"); 
	}

	function ListProductsCategoryNotSelect()
	{
	    return alertDialog("<%= UIUtil.toJavaScript((String)CategoryNLS.get("notHighlight_list")) %>"); 
	}

	////////////////////////////////////////////////////////////////////////////////////////////
	// getExtFunctionSKU()
	//
	// - returns if the Product management tool should list the SKUs under a category.
    //   By default, the SKUs are excluded.  The flag ExtFunctionSKU needs to be set to true
    //   in CommerceAccelerator.xml of your business model.
	////////////////////////////////////////////////////////////////////////////////////////////
	function getExtFunctionSKU() {
	   return <%=strExtFunctionSKU%>;
    }

	function getCatalogId (value) {
		var tag = ":owner=";
		var pos1 = 0;
		var init_pos = 0;
		var catId = null;

		pos1 = value.lastIndexOf(tag);

		if (pos1 != -1) {
			catId = value.substring(0, pos1);
		} else {
			catId = value;
		}
		
		return catId;
	}

        function getCategoryId ( path ) {

             var sep = "/";
             var pos1 = 0;
             var init_pos = 0;
             var categoryId = null;

             pos1 = path.lastIndexOf ( sep );
             if ( pos1 != -1 ) {
               categoryId = path.substring( pos1 + 1, path.length );
             }
             return categoryId;
       }


        function getParentPath( path ) {

            var sep = "/";
            var pos1 = 0;
            var init_pos = 0;
            var parent_path = null;

            pos1 = path.lastIndexOf ( sep );
            if ( pos1 != -1 ) {
              parent_path = path.substring( 0, pos1  );
            }
            return parent_path;

        }
        function getValidPath ( path, deletedCategories )  {

           var sep = "/";
           var pos1 = 0;
           var thisCategoryId = null;
           var validPath = null;
           var found = false;
           var i = null;

           if(  deletedCategories == null ){
              return path;
           }

           // exclude catalogId from search:
           pos1 = path.indexOf( sep );
           if ( pos1 == -1 ) {
             // path contains catalogId only
             return path;
           }
           for ( i = 0; i <= deletedCategories.length - 1; i++ ) {           
 	          pos1 = path.indexOf( deletedCategories[i], pos1 + 1);
	           if ( pos1 != -1 ) {
			pos2 = path.indexOf( sep, pos1 );
        	        if ( pos2 != -1 ) {
				thisCategoryId = path.substring( pos1, pos2 );		
	                } else {
	                	thisCategoryId = path.substr( pos1 );
	                }
		  	if ( deletedCategories [i] == getCatalogId(thisCategoryId) ) {
	                  	validPath = path.substring( 0, pos1 - 1 );
	                  	return validPath;
			}
        	 }
           }

           return path;
        }


        function saveHighlightedPath () {
           var x = null;
           var path = null;
           var node = null;
           var parent = false;

           if (arguments.length > 0) {
	     parent = arguments[0];
           }

           if ( tree.getHighlightedNode != null )  {
		node = tree.getHighlightedNode();
		
		if (node != null) {
			path = tree.getValuePath(node);
			if (path != null) {
				if (parent != null && parent == true) {
					path = getParentPath(path);
				}
				top.put(pathId, path);
			}
		}
	   } 
        }


var progressChecks = 0;
var maxChecks      = 60;
var targetPath     = null;
var minDelay = 100;

function checkProgress () {


  var x = null;
  var y = null;
  var path = null;


  if ( progressChecks <= maxChecks - 1 ) {  
   
     if ( tree.getHighlightedNode != null )  {
	y = tree.getHighlightedNode();
	if (y != null) {
		path = tree.getValuePath(y);
	}
     }

     if ( path != targetPath ) {
        top.showProgressIndicator ( true );        
        checkTimer = setTimeout("checkProgress()", minDelay);
        progressChecks += 1;

     } else  {
         top.showProgressIndicator ( false );
     }
  }  else {

     top.showProgressIndicator ( false );
  }
}


function display(path) {

  var select_path = null;

  select_path = path
  if ( select_path != null ) {

   targetPath = select_path;
   top.showProgressIndicator ( true );   
   tree.gotoAndHighlightByValue(select_path);
   checkTimer = setTimeout("checkProgress()", minDelay);
  }
} 

       function initForm () {
           
           var path = top.get ( pathId, null );
           var deletedCategories = top.get( "deletedCategory", null );
           var categoryId = null;

           if ( path != null ) {
              path = getValidPath( path, deletedCategories );
              if ( path != null ) {
		top.put( "deletedCategory", null );
                top.put( pathId, path );
                display( path );
              }
           }

        }
       


        function closeForm () {
            saveHighlightedPath ();          
        }
        
      </SCRIPT>
      

      <SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

	<FORM NAME="_formDeleteSubmit" ACTION="Delete" METHOD="POST"> 
	  <INPUT TYPE="hidden" NAME="checkedCategoryRefNum" VALUE="">
	  <INPUT TYPE="hidden" NAME="redirecturl" VALUE="">	
	  
	</FORM>
	
    <%@include file="MsgDisplay.jspf" %>
      
	

</head>
	<frameset framespacing="0" border="0" frameborder="0" rows="50,*">
		<frame src="/webapp/wcs/tools/servlet/CatalogGroupTitle" title="<%=UIUtil.toHTML((String)CategoryNLS.get("CategoryParent_FrameTitle_0"))%>" name="header">
		<frameset framespacing="0" border="0" frameborder="0" cols="*,170" onLoad="initForm();" onUnload="closeForm()">
			<frame src="/webapp/wcs/tools/servlet/DynamicTreeView?XMLFile=catalog.catalogGroupTree" TITLE="<%= UIUtil.toHTML( (String)ProductFindNLS.get("CatalogGroupTree_FrameTitle_1")) %>" name="tree">
			<frame src="/webapp/wcs/tools/servlet/CategoryTreeButtonView" TITLE="<%= UIUtil.toHTML( (String)ProductFindNLS.get("CatalogGroupTree_FrameTitle_2")) %>" name="content">
		</frameset>
	</frameset>

   <%
      } catch (Exception ex){
         com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, ex);
      }
   %>   	
         
</html>
