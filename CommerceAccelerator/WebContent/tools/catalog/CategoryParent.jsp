<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2000, 2016
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<HTML>

<%@page import = "java.util.*,
			com.ibm.commerce.command.CommandContext,
			com.ibm.commerce.beans.*,
			com.ibm.commerce.catalog.objects.*,
			com.ibm.commerce.tools.catalog.beans.*,
			com.ibm.commerce.tools.util.*,
			com.ibm.commerce.common.objects.StoreAccessBean,
			com.ibm.commerce.tools.catalog.util.*,
            com.ibm.commerce.registry.StoreRegistry"
%>
<%@include file="../common/common.jsp" %>

<%
  CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
  String ownerId = cmdContext.getStore().getOwner().toString();
  Hashtable rbCategory = (Hashtable)ResourceDirectory.lookup("catalog.CategoryNLS", cmdContext.getLocale());
  Locale jLocale = cmdContext.getLocale();
  String jCurrency = cmdContext.getCurrency();
  Hashtable itemResource = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.CategoryNLS", jLocale);
  Integer intStoreId = cmdContext.getStoreId();
  String storeId = cmdContext.getStoreId().toString();
  String lang_id = cmdContext.getLanguageId().toString();

  try {

   String strCategoryId = request.getParameter ("categoryId");
   String strPath = request.getParameter ("path");
   
   strPath = ( strPath != null ? strPath  : "");
   strCategoryId = ( strCategoryId != null ? strCategoryId  : "");

   String strCreate = request.getParameter("bCreate");
   Boolean blnCreate = null;
   if (( strCreate != null ) && ( strCreate.equals("true") ) ) {
       blnCreate = new Boolean ( true );
   } else {
       blnCreate = new Boolean ( false );
   }
   boolean bCreate = blnCreate.booleanValue(); 

   // Uses the StoreRegistry for better performance
   StoreAccessBean store = StoreRegistry.singleton().find(intStoreId);
   if (store == null) {
		store = new StoreAccessBean() ;
		store.setInitKey_storeEntityId(storeId);
   }
   CatalogAccessBean masterCatalog = store.getMasterCatalog();
   String strMasterCatalogId = masterCatalog.getCatalogReferenceNumber();
   String strMasterCatalogOwner = masterCatalog.getOwner().toString();
	
   if ( ( strPath == null ) || ( strPath.length () == 0 ) ) {

     if ( bCreate )  {
       strPath = strMasterCatalogId+":owner="+strMasterCatalogOwner;
     } else {

 	// construct path using strCategoryId

         CatalogGroupAccessBean catAB = new CatalogGroupAccessBean ();
         catAB.setInitKey_catalogGroupReferenceNumber(strCategoryId);
      

         CatalogGroupAccessBean firstParent = catAB;
         CatalogGroupAccessBean [] parents = null;
      
         strPath = strCategoryId;
         do {
           
	      parents = firstParent.getParentCatalogGroups( new Long( strMasterCatalogId ));
	      if ( parents == null ) {
		      break;
	      }
	      if ( parents.length > 0 ) {
		      				      
		      firstParent = parents[0];
		      if ( firstParent == null ) {
			      break;
		      }
		      String strThisCategoryId = firstParent.getCatalogGroupReferenceNumber();
		      if ( strThisCategoryId != null ) {
		          String strOwnerIdOfThisCategory = firstParent.getOwner().toString();
			  strPath = strThisCategoryId + ":owner=" +strOwnerIdOfThisCategory+ "/" + strPath;
		      }
 		  
	      } else {
		      strPath = strMasterCatalogId + ":owner=" +strMasterCatalogOwner+ "/" + strPath;
		      break;
	      }
    
         } while  ( parents.length > 0 );
      } // if ( bCreate )...
   } // if ( ( strPath == null 

%>

<META name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE><%=UIUtil.toHTML((String)itemResource.get("categoryParentTitle"))%></TITLE>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %> 
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css"> 

<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT> 
<SCRIPT>

var ownerId = "<%=ownerId%>";

function CategoryParentData(){

   this.path = "<%=UIUtil.toJavaScript( strPath )%>";

<% if ( bCreate ) { %>
   this.parent_path = this.path;
   this.category_id = "";
<% } else { %>
   this.category_id = "<%=UIUtil.toJavaScript( strCategoryId )%>";
   this.parent_path = getParentPath ( this.path );
<% } %>

   if ( isCatalog( this.parent_path ) ) {
     this.parent_category_id = "";
   } else {
     this.parent_category_id = getCategoryId( this.parent_path );
   }
   this.parent_category_name = ""; // for compatibility with command - not used
   this.old_parent_category_id = this.parent_category_id;
   this.catalog_id = getCatalogId ( this.path );


}

CategoryParent.messages = new Object();
CategoryParent.ID = "categoryparent";

function CategoryParent () {

   this.data = new CategoryParentData();
   this.id = CategoryParent.ID;
   this.tree = null;
   this.msgs = CategoryParent.messages;
}


function moveFocus(formFieldName) {
    var focus_target = "this.formref." + formFieldName + "." + "focus()";
    eval(focus_target);
}

function getCategoryPath(path) {
	var tag1 = ":owner=";
	var tag2 = "/";
	var pos1 = 0;
	var categoryPath = "";
	
	if (path != null) {
		var pathArray = path.split(tag2);

		for (var i=0; i<pathArray.length; i++) {
			pos1 = pathArray[i].lastIndexOf(tag1);
			if (i > 0) {
				categoryPath += tag2 + pathArray[i].substring(0, pos1);
			} else {
				categoryPath += pathArray[i].substring(0, pos1);
			}
		}
		return categoryPath;
	}
	return path;
}

function isTopCategory ( path ) {

   var sep = "/";
   var pos1 = -1, pos2 = -1;
   var categoryPath = getCategoryPath(path);

   pos1 = categoryPath.indexOf ( sep, 0 );

   if ( pos1 != -1 ) {
     pos2 = categoryPath.indexOf ( sep, pos1 + 1 );
   }

   result = ( pos1 > 0 && pos2 == -1 );
   return result;
}


function getCategoryId ( path ) {

 var sep = "/";
 var pos1 = 0;
 var init_pos = 0;
 var categoryId = null;
 var categoryPath = getCategoryPath(path);

 pos1 = categoryPath.lastIndexOf ( sep );
 if ( pos1 != -1 ) {
    categoryId = categoryPath.substring( pos1 + 1, categoryPath.length );
 }
 return categoryId;

}



function getCatalogId( path ) {

   var sep = "/";
   var pos1 = 0;
   var catalogId = null;
   var categoryPath = getCategoryPath(path)
 
   pos1 = categoryPath.indexOf ( sep, 0 );
   if ( pos1 != -1 ) {
     catalogId = categoryPath.substring( 0, pos1 );
   } else {
     catalogId = categoryPath.substring( 0, categoryPath.length );
   }
   
   return catalogId;
}

function getParentPath( path ) {

 var sep = "/";
 var pos1 = 0;
 var init_pos = 0;
 var parent_path = null;

 pos1 = path.lastIndexOf(sep);
 if ( pos1 != -1 ) {
   parent_path = path.substring(0, pos1);
 }
 return parent_path;

}


function isCatalog( path ) {

  var sep = "/";
  var pos1 = 0;
  var categoryPath = getCategoryPath(path);

  pos1 = categoryPath.indexOf( sep );

  result = ( categoryPath.length > 0 && pos1 == -1 );
  return result;

}

function load() {
   var node = null;
   if ( tree.getHighlightedNode != null )  {
     node = tree.getHighlightedNode();
     if (node != null) {
	this.data.parent_path  = tree.getValuePath( node );
     	if ( isCatalog ( this.data.parent_path ) ) {
    		// this is top category
    		this.data.parent_category_id = "";
     	} else {
     		this.data.parent_category_id = getCategoryId( this.data.parent_path );
     	}
     }
   } 
}

function isChangeable(param) {
	var tag = ":owner=";
	var pos1 = 0;
	var init_pos = 0;
	var paramOwner = null;
	var isChangeable = false;
	
	pos1 = param.lastIndexOf(tag);
	
	if (pos1 != -1) {
		var paramOwner = param.substring( pos1 + 7, param.length);
		if (ownerId == paramOwner) {
			return true;
		} else {
			return false;
		}
	} else {
		return false;
	}
}


function validatePanelData() {
 	var node = tree.getHighlightedNode();
 	if (node != null) {
 		parent_path = tree.getValuePath( node );
 		category_id = "<%=UIUtil.toJavaScript( strCategoryId )%>";
 		
	       if ( ! isCatalog ( parent_path ) ) {
		    hlCategoryId = getCategoryId( parent_path );
		    <% if ( ! bCreate ) { %>
		    if ( hlCategoryId ==  category_id ) {
			alertDialog(   CategoryParent.messages["samechosen"]  );
			return false;  
		    }
		    <% } %>
	       }
 	}
 	
   	return true;
}

var progressChecks = 0;
var maxChecks      = 60;
var targetPath     = null;
var minDelay = 100;

function checkProgress () {
  var y = null;
  var path = null;

 
  if ( progressChecks <= maxChecks - 1 ) {  
     	y = tree.getHighlightedNode();
  	
  	if (y != null) {
  		path = tree.getValuePath(y);
  	}

  	if (path != targetPath) {

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


function display() {

  var select_path = null;

  select_path = this.data.parent_path;
  if ( select_path != null ) {


   targetPath = select_path;
   top.showProgressIndicator ( true );   
   tree.gotoAndHighlightByValue(select_path);
   checkTimer = setTimeout("checkProgress()", minDelay);
  }
} 


function getData() {

    return this.data;
}

CategoryParent.prototype.load = load;
CategoryParent.prototype.display = display;
CategoryParent.prototype.getData = getData;
CategoryParent.prototype.focus = moveFocus;
CategoryParent.prototype.doAlert = doAlert;

var cg = null;

function savePanelData() {
   if (cg != null)   {
       cg.tree = document.all.tree;
       cg.load();
       parent.put( CategoryParent.ID, cg.getData());
       parent.putPanelMsgs( CategoryParent.ID, cg.msgs);
   }
}
 
function initForm() {

    var dataObject = parent.get( CategoryParent.ID );
    initPanelObject();
    
    if (dataObject == null) {
        

        
        cg = new CategoryParent ();
        cg.tree = tree;
	cg.msgs = CategoryParent.messages;
        cg.display();
        
    } else {

        
        var code = parent.getErrorParams();
        
        cg = new CategoryParent();
        cg.msgs = parent.getPanelMsgs(CategoryParent.ID);
        cg.data = dataObject;
        cg.tree = tree;
        cg.doAlert(code);
        cg.display();
         
    }
    parent.setContentFrameLoaded(true);
}    

function doAlert(code) 
{

    if (code != null) 
    {
           if ( code == "samechosen" ) {

               alertDialog(      "<%=UIUtil.toJavaScript((String)itemResource.get("categorySameChosen"))%>" );
          }
          
    }
}


function initPanelObject() {

   CategoryParent.messages["samechosen"] = "<%=UIUtil.toJavaScript((String)itemResource.get("categorySameChosen"))%>";

} 

</SCRIPT>

<frameset framespacing="0" border="0" frameborder="0" onLoad="initForm();" rows="15%, 85%">
<frame src="/webapp/wcs/tools/servlet/CategoryParentTopView" name="titleFrame" TITLE="<%= UIUtil.toHTML( (String)rbCategory.get("CategoryParent_FrameTitle_1")) %>">
<frame src="/webapp/wcs/tools/servlet/DynamicTreeView?XMLFile=catalog.catalogGroupTree" name="tree" TITLE="<%= UIUtil.toHTML( (String)rbCategory.get("CategoryParent_FrameTitle_2")) %>">
</frameset>
 
<%
}
catch (Exception e) 
{
       com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
}

%>

</HTML>
