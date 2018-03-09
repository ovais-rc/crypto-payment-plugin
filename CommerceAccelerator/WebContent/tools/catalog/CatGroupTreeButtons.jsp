<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2000, 2005
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->

<html>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.AccessControlHelperDataBean" %>
<%@ page import="com.ibm.commerce.tools.catalog.commands.CategoryUpdate" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.attachment.common.ECAttachmentConstants" %>
<%@ include file="../common/common.jsp" %>

<head>
      <%
        CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
        String ownerId = cmdContext.getStore().getOwner().toString();
        Locale jLocale = cmdContext.getLocale();
	    Hashtable rbCategory = (Hashtable)ResourceDirectory.lookup("catalog.CategoryNLS", cmdContext.getLocale());
	    Hashtable rbProduct = (Hashtable)ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
	    
	    String myInterfaceName = CategoryUpdate.NAME;
	    AccessControlHelperDataBean myACHelperBean= new AccessControlHelperDataBean();
	    myACHelperBean.setInterfaceName(myInterfaceName);
	    DataBeanManager.activate(myACHelperBean,cmdContext);
	    
	    boolean isB2C=false;
	    if (cmdContext.getStore().getStoreType() != null && (cmdContext.getStore().getStoreType().equalsIgnoreCase("B2C") || cmdContext.getStore().getStoreType().equalsIgnoreCase("RHS") || cmdContext.getStore().getStoreType().equalsIgnoreCase("MHS")))
	    {
	       isB2C = true;	
	    }

	    // to do, need to change to get value from access control helper after access control is done
	    boolean attachmentAccessGained = true;
      %>
      
      <link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
	<TITLE><%=UIUtil.toHTML((String)rbCategory.get("categoryFindCriteria_Title"))%></TITLE>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/button.js"></SCRIPT>
<script src="/wcs/javascript/tools/attachment/Constants.js"></script>
<SCRIPT>

var ownerId = "<%=ownerId%>";
var attachmentAccessGained = <%=attachmentAccessGained%>;

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

/////////////////////////////////
// isCatalogGroupHighlighted()
// This method return true if the hightlighted node is a catalog group
/////////////////////////////////
function isCatalogGroupHighlighted()
{
	var y = parent.tree.getHighlightedNode();
	var namePath = parent.tree.getNamePath(y);
	if (namePath.indexOf("/") == -1)
	{
		return false;
	} else {
		return true;
	}
}

function createSubCategory() {
	var y = parent.tree.getHighlightedNode();
	if (y == null) {
		top.setContent(parent.newCategory, "/webapp/wcs/tools/servlet/WizardView?XMLFile=catalog.categoryWizard&categoryId=&path=&bCreate=true", true);
	} else {
		top.setContent(parent.newCategory, "/webapp/wcs/tools/servlet/WizardView?XMLFile=catalog.categoryWizard&categoryId=&path=" + parent.tree.getValuePath(y) + "&bCreate=true", true);
	}
}

function updateCategory() {
	var y = parent.tree.getHighlightedNode();

	if (y == null) {
		parent.ChangeCategoryNotSelect();
	} else {	
		var catGroupSelected = isCatalogGroupHighlighted();
		if (isChangeable(y.value) & catGroupSelected ) {
			top.setContent(parent.changeCategory, "/webapp/wcs/tools/servlet/NotebookView?XMLFile=catalog.categoryNotebook&categoryId=" + parent.getCatalogId(y.value) + "&path=" + parent.tree.getValuePath(y) + "&bCreate=false", true);
		} else {
			if (catGroupSelected)
			{
				alertDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("categoryTree_update_disabled"))%>");
			} else {
				alertDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("categoryTree_updateCatalog_disallowed"))%>");
				
			}
			
		}
	}
}

function listProducts() {
	var y = parent.tree.getHighlightedNode();
	var catGroupSelected = isCatalogGroupHighlighted();

        /* Defect 93293: Fixing button logic for displaying friendly error message when no category selected.
	if (y == null | (! catGroupSelected) ) {
		if (catGroupSelected) {
			parent.ListProductsCategoryNotSelect();
		} else {
			alertDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("categoryTree_listProductForCatalog_disallowed"))%>");		
		}
	}
	*/
	
	if (y == null) {
		parent.ListProductsCategoryNotSelect();
	} else if (!catGroupSelected) {
		alertDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("categoryTree_listProductForCatalog_disallowed"))%>");
	}	
	else {
		var title = y.name + " - " + parent.listCatalogEntries;
		//
		// Ensure that if we hit the bct find we flush the saved data
		top.put("ProductUpdateDetailDataExists", "false");

        var url = top.getWebappPath() + "ProductUpdateDialog";

        var urlPara = new Object();
        urlPara.catgroupID=parent.getCatalogId(y.value) ;
        urlPara.ExtFunctionSKU=parent.getExtFunctionSKU() ;

		top.setContent(title, url, true,urlPara);
	}
}

function addDeletedCategory ( categoryId ) {

        var deletedCategories = null;
        var newIndex = null;
   
        deletedCategories = top.get( "deletedCategory", null );
        if ( deletedCategories == null ) {
             deletedCategories = new Array();
             newIndex = 0;
		} else {
             newIndex = deletedCategories.length;
        }
        deletedCategories[ newIndex ] = categoryId;
        top.put( "deletedCategory", deletedCategories );
}

function performCategoryDeleteFromTreePage()
{
	var y = parent.tree.getHighlightedNode();
	var catGroupSelected = isCatalogGroupHighlighted();
	
	if (y == null | (! catGroupSelected) ) {
	    if (y == null) {
			parent.DeleteCategoryNotSelect();
		} else {
			alertDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("categoryTree_deleteCatalog_disallowed"))%>");	
		}
	} else {
		if (isChangeable(y.value)) {
		    if (parent.CategoryDelComfirm()) {
			    top.showProgressIndicator(true);

			    addDeletedCategory(parent.getCatalogId(y.value));
	
			    parent._formDeleteSubmit.checkedCategoryRefNum.value = parent.getCatalogId(y.value);
				if (parent.getExtFunctionSKU()) {
			    	parent._formDeleteSubmit.redirecturl.value ="/webapp/wcs/tools/servlet/CategoryTreeView?sku=true";
				} else {
					parent._formDeleteSubmit.redirecturl.value ="/webapp/wcs/tools/servlet/CategoryTreeView?sku=false";
				}
			    parent._formDeleteSubmit.action = "CategoryDelete";
	
			    parent._formDeleteSubmit.submit();
		    }
		} else {
			alertDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("categoryTree_delete_disabled"))%>");
		}
	}
}

function newProductAction()
{
	var node = parent.tree.getHighlightedNode();
	var catGroupSelected = isCatalogGroupHighlighted();
	
	var url = top.getWebappPath() + "WizardView";
	var urlPara        = new Object();
	urlPara.XMLFile    = "catalog.productWizardCreate";
	urlPara.langId     = <%= cmdContext.getLanguageId() %>;
	urlPara.storeId    = <%= cmdContext.getStoreId() %>;
	

	if (node != null && catGroupSelected)
	{
		urlPara.categoryId= parent.getCatalogId(node.value);
	}
	
	top.setContent(parent.newProductBCT, url, true,urlPara);
}

function newBundleKitAction()
{
	var node = parent.tree.getHighlightedNode();
	var catGroupSelected = isCatalogGroupHighlighted();
	
	var url = top.getWebappPath() + "WizardView";
	var urlPara        = new Object();
	urlPara.XMLFile    = "catalog.KitWizard";
	urlPara.langId     = <%= cmdContext.getLanguageId() %>;
	urlPara.storeId    = <%= cmdContext.getStoreId() %>;
	
	if (node != null && catGroupSelected)
	{
		urlPara.categoryId= parent.getCatalogId(node.value);
	}
	
	top.setContent(parent.newBundleKitBCT, url, true,urlPara);
}

function productReportsAction()
{
	var url="";
    if (<%=isB2C%>)
    {
    	url = top.getWebappPath() +"ShowContextList?context=B2C_ProductsReports&contextConfigXML=reporting.OperationalReportsContext&ActionXMLFile=bi.prodRptscontextList";
    }
    else
    {
    	url = top.getWebappPath() + "ShowContextList?context=B2B_ProductsReports&contextConfigXML=reporting.OperationalReportsContext&ActionXMLFile=bi.prodRptscontextList";	
    }
	var urlPara = new Object();
	top.setContent("<%= UIUtil.toJavaScript((String)rbProduct.get("productList_button_inventory")) %>", url, true, urlPara); 
}

	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarListAttachment(element)
	//
	// - check if it is a valid integer
	//////////////////////////////////////////////////////////////////////////////////////
	function showAttachmentsAction() {

		var node = parent.tree.getHighlightedNode();

		if (node == null) {
			parent.ShowAttachmentNotSelect();
			return;
		}
		
		var catGroupSelected = isCatalogGroupHighlighted();
		var url = top.getWebPath() + "AttachmentListDialogView";
		var urlPara = new Object();
		
		if (isCatalogGroupHighlighted()) {
			urlPara.objectType = "<%=ECAttachmentConstants.EC_ATCH_OBJECT_TYPE_CATALOG_GROUP%>";
		} else {
			urlPara.objectType = "<%=ECAttachmentConstants.EC_ATCH_OBJECT_TYPE_CATALOG%>";
		}
		
		urlPara.objectId = parent.getCatalogId(node.value);
		urlPara.readOnly = !attachmentAccessGained;
		
		top.setContent("<%=UIUtil.toJavaScript((String) rbProduct.get("ProductUpdateMenuTitle_ShowAttachment"))%>", url, true, urlPara);   
	}
	
	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarAddAttachment(element)
	//
	// - check if it is a valid integer
	//////////////////////////////////////////////////////////////////////////////////////
	function addAttachmentAction() {

		var node = parent.tree.getHighlightedNode();

		if (node == null) {
			parent.AddAttachmentNotSelect();
			return;
		}
		
		if (!attachmentAccessGained) {
		
			if (isCatalogGroupHighlighted()) {
				alertDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("categoryTree_addAttachment_disabled"))%>");
			} else {
				alertDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("catalog_addAttachment_disabled"))%>");
			}
			
			return;	
		}
		
		var url = top.getWebPath() + "PickAttachmentAssetsTool";
		var urlPara = new Object();

		urlPara.objectId    = parent.getCatalogId(node.value);
		
		if (isCatalogGroupHighlighted()) {
			urlPara.objectType = "<%=ECAttachmentConstants.EC_ATCH_OBJECT_TYPE_CATALOG_GROUP%>";
		} else {
			urlPara.objectType = "<%=ECAttachmentConstants.EC_ATCH_OBJECT_TYPE_CATALOG%>";
		}
		
		urlPara.saveChanges = true;
		urlPara.returnPage = CONSTANT_TOOL_LIST;
		
		top.setContent("<%=UIUtil.toJavaScript((String) rbProduct.get("ProductUpdateMenuTitle_AddAttachment"))%>", url, true, urlPara);

	}

</SCRIPT>

</head>
<body class="content_bt">
<form id=form1 method="POST" action="--WEBBOT-SELF--">
</form>
  	<script>
  	beginButtonTable();

	<%
	if (myACHelperBean.isWriteAllowed())
	{
	%> 	
  	drawButton("btnNewCategory", parent.newButton, "createSubCategory()", "enabled");
  	drawButton("btnChangeCategory", parent.changeButton, "updateCategory()", "enabled");
  	drawButton("btnDeleteCategory", parent.deleteButton, "performCategoryDeleteFromTreePage()", "enabled");
  	
  	drawEmptyButton();
  	
  	drawButton("btnNewProduct", parent.newProductButton, "newProductAction()", "enabled");
  	drawButton("btnNewBundleKit", parent.newBundleKitButton, "newBundleKitAction()", "enabled");
	<%
	}
	%>  	
  	drawEmptyButton();
  	
	drawButton("btnListCatalogEntries", parent.listButton, "listProducts()", "enabled");
	
	drawEmptyButton();
	 
  	drawButton("btnAddAttachments", parent.addAttachmentButton, "addAttachmentAction()", "enabled"); 				
	drawButton("btnShowAttachments", parent.showAttachmentsButton, "showAttachmentsAction()", "enabled");
	
	drawEmptyButton();
	
	drawButton("btnReports", parent.productReportsButton, "productReportsAction()", "enabled");		 
	
	endButtonTable();

	<%
	if (myACHelperBean.isWriteAllowed())
	{
	%> 			
	AdjustRefreshButton(btnNewCategory);
	AdjustRefreshButton(btnChangeCategory);
	AdjustRefreshButton(btnDeleteCategory);
	AdjustRefreshButton(btnNewProduct);
	AdjustRefreshButton(btnNewBundleKit);
	<%
	}
	%>	
	AdjustRefreshButton(btnShowAttachments);
	AdjustRefreshButton(btnAddAttachments);
	AdjustRefreshButton(btnListCatalogEntries);
	AdjustRefreshButton(btnReports);
	</script>
    


</body>
</html>
