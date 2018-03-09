<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<HTML>

<%@page import = "java.util.*,
			com.ibm.commerce.command.CommandContext,
			com.ibm.commerce.beans.*,
			com.ibm.commerce.catalog.objects.*,
			com.ibm.commerce.common.objects.*,
			com.ibm.commerce.tools.catalog.beans.*,
			com.ibm.commerce.tools.util.*,
			com.ibm.commerce.tools.catalog.util.*,
            com.ibm.commerce.registry.StoreRegistry"
%>
<%@include file="../common/common.jsp" %>

<%
  CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
  String ownerId = cmdContext.getStore().getOwner().toString();
  Locale jLocale = cmdContext.getLocale();
  String jCurrency = cmdContext.getCurrency();
  Hashtable productResource = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.ProductNLS", jLocale);
  Integer storeId = cmdContext.getStoreId();
%>

<% 
     
  try {
  
  
  
   String productRefNum = request.getParameter(com.ibm.commerce.tools.catalog.util.ECConstants.EC_PRODUCT_NUMBER); 
   String lang_id = request.getParameter(com.ibm.commerce.server.ECConstants.EC_LANGUAGE_ID);
   
   String old_strCategoryId = null;
   String strCategoryId = null;
   String strCategoryName = null;
   String strMasterCatalogId = null;
   String strPath = null;
   String strMasterCatalogOwnerId = null;
   String strOwnerTag = ":owner=";
   
   // get the master catalog   
   // Uses the StoreRegistry for better performance
   StoreAccessBean store = StoreRegistry.singleton().find(storeId);
   if (store == null) {
		store = new StoreAccessBean() ;
		store.setInitKey_storeEntityId(storeId.toString());
   }
   CatalogAccessBean masterCatalog = store.getMasterCatalog();
	  
   strMasterCatalogId = masterCatalog.getCatalogReferenceNumber();
   strMasterCatalogOwnerId = masterCatalog.getOwner().toString();


   if(productRefNum != null){
   
 
   	CatalogGroupCatalogEntryRelationAccessBean cgceAB = new CatalogGroupCatalogEntryRelationAccessBean();
   	
   	Enumeration e = cgceAB.findByCatalogEntryId(new Long(productRefNum));
   	int counter = 0;
   	while ( e.hasMoreElements() ) {
     		cgceAB = ( CatalogGroupCatalogEntryRelationAccessBean ) e.nextElement ();
     		String catalogId = cgceAB.getCatalogId(); 
     		if(catalogId.equals(strMasterCatalogId)){
     			strCategoryId = cgceAB.getCatalogGroupId();
     			counter++;
     		}     		
   	}
   	
   	if(strCategoryId != null){
   		old_strCategoryId = new String(strCategoryId);
	}
   	
   }else {

     strCategoryId = request.getParameter("categoryId");
   }
   
   
   
   
  if (( strCategoryId != null ) && ( strCategoryId.trim().length() > 0 )) {
  
 	// construct path using strCategoryId
	
	try{

       	CatalogGroupAccessBean catAB = new CatalogGroupAccessBean ();
       	catAB.setInitKey_catalogGroupReferenceNumber(strCategoryId);
      

     	CatalogGroupAccessBean firstParent = catAB;
      	CatalogGroupAccessBean [] parents = null;
      
//       	strPath = strCategoryId;
	strPath = strCategoryId + strOwnerTag + catAB.getOwner().toString();
	
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
			     // strPath = strThisCategoryId + "/" + strPath;
			     strPath = strThisCategoryId + strOwnerTag + firstParent.getOwner().toString() + "/" + strPath;
		      }
 		  
	      	} else {

		     // strPath = strMasterCatalogId + "/" + strPath;
		      strPath = strMasterCatalogId + strOwnerTag + strMasterCatalogOwnerId + "/" + strPath;
		      break;
	      	}
    
      	} while  ( parents.length > 0 );
      	
      	
      	} catch (javax.persistence.NoResultException e1) {
      	
      		//strPath = strMasterCatalogId;
      		strPath = strMasterCatalogId + strOwnerTag + strMasterCatalogOwnerId;

   	}
      	
   } else {

       //strPath = strMasterCatalogId;
       strPath = strMasterCatalogId + strOwnerTag + strMasterCatalogOwnerId;
   }
   	

   
   
   strCategoryId = (strCategoryId != null ? UIUtil.toJavaScript(strCategoryId) : "");
   strCategoryName = (strCategoryName != null ? UIUtil.toJavaScript(strCategoryName) : "");
   old_strCategoryId = (old_strCategoryId != null ? UIUtil.toJavaScript(old_strCategoryId) : "");
   strMasterCatalogId = (strMasterCatalogId != null ? UIUtil.toJavaScript(strMasterCatalogId) : "");
   strPath = (strPath != null ? UIUtil.toJavaScript(strPath) : "");


%>

<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>
var ownerId = "<%=ownerId%>";

function CategoryData(){

   this.path = "<%= strPath %>";
   this.fullpath = "<%= strPath %>";
   this.category_id = "<%= strCategoryId%>";
   this.category_name = "<%=strCategoryName%>";
   this.old_categoryId = "<%=old_strCategoryId%>";
   this.masterCatalogId = "<%=strMasterCatalogId%>";
   
   
}


Category.ID = "productcategory";

function Category () {

   this.data = new CategoryData();
   this.id = Category.ID;
   this.tree = null;

}


function load() {

   this.data.old_categoryId = "<%=old_strCategoryId%>";
   this.data.masterCatalogId = "<%=strMasterCatalogId%>";

   y = tree.getHighlightedNode();
   if ( y != null )  {
     this.data.path  = getCategoryPath(tree.getValuePath( y ));
     this.data.fullpath = tree.getValuePath( y );
     this.data.category_id = getCategoryId(y.value);
     this.data.category_name = y.name;
   } 
}


var progressChecks = 0;
var maxChecks      = 60;
var targetPath     = null;
var minDelay = 100;

function getCategoryId ( path ) {
	return getCategoryPath(path);
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


function checkProgress () {
  var y = null;
  var path = null;


  if ( progressChecks <= maxChecks - 1 ) {  
   
     if ( tree.getHighlightedNode != null )  {
        y = tree.getHighlightedNode();
        path  = tree.getValuePath( y );
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


function display() {

  var select_path = null;

  select_path = this.data.fullpath;
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

Category.prototype.load = load;
Category.prototype.display = display;
Category.prototype.getData = getData;


var cg = null;

function savePanelData() {

   if (cg != null)   {
       cg.tree = document.all.tree;
       cg.load();
       parent.put( Category.ID, cg.getData());

   }
     
}
 
function initForm() {

    var dataObject = parent.get( Category.ID );
    
    if (dataObject == null) {
        
        
        cg = new Category ();
        cg.tree = tree;
          
        cg.display();
        
    } else {
       
        cg = new Category();
        cg.data = dataObject;
        cg.tree = tree;
        cg.display();
         
    }
    
    if (parent.get("selectCategory", false))
    {
        parent.remove("selectCategory");
        alertDialog("<%= UIUtil.toJavaScript((String)productResource.get("selectCategory"))%>");
               
    }
    
    parent.setContentFrameLoaded(true);
}    




function validatePanelData(){

   var y1 = null;

   if ( tree.getHighlightedNode != null )  {
     y1 = tree.getHighlightedNode();
     if (y1 == null) {
     
	 alertDialog("<%=UIUtil.toJavaScript((String)productResource.get("notHighlight"))%>");
	 return false;
	 
     }else{
         
     	var pathNode = tree.getValuePath( y1 );  
     	
     	if ( isCatalog ( pathNode ) ) {
     	
           	alertDialog("<%=UIUtil.toJavaScript((String)productResource.get("selectCategory"))%>");
           	return false;
        }
       	
     }    
     

   }
   
   return true;

}


function isCatalog( path ) {

  var sep = "/";
  var pos1 = 0;


  pos1 = path.indexOf( sep );

  result = ( path.length > 0 && pos1 == -1 );
  return result;

}



</SCRIPT>








<META name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE><%=UIUtil.toHTML((String)productResource.get("productFindCriteria_field_parentCategory"))%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
 
<frameset framespacing="0" border="0" frameborder="0" onLoad="initForm();" rows="10%, 90%">
<frame src="/webapp/wcs/tools/servlet/ProductCategoryTopView" TITLE="<%= UIUtil.toHTML( (String)productResource.get("ProductCategory_FrameTitle_1")) %>" name="titleFrame">
<frame src="/webapp/wcs/tools/servlet/DynamicTreeView?XMLFile=catalog.catalogGroupTree" TITLE="<%= UIUtil.toHTML( (String)productResource.get("ProductCategory_FrameTitle_2")) %>" name="tree" >
</frameset>

<%
}
catch (Exception e) 
{
       com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
}

%>


</HTML>
