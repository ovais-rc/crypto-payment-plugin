<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.tools.catalog.commands.*" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbProduct  = (Hashtable) ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
	Hashtable rbCategory = (Hashtable)ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	Hashtable rbPMT= (Hashtable) ResourceDirectory.lookup("catalog.CategoryNLS", cmdContext.getLocale());
	String 	strPMT=(String)rbPMT.get("catalogSearch_PLUResultTitle");

	com.ibm.commerce.server.JSPHelper jspHelper = new com.ibm.commerce.server.JSPHelper(request);	
	String strCatalogId = jspHelper.getParameter("rfnbr");

	//retrieve the start category when returning from PMT
	String strStartCategory = jspHelper.getParameter("startCategory"); 
	if(strStartCategory==null || strStartCategory.length()==0)
		strStartCategory="0";
	String strStartParent= jspHelper.getParameter("startParent");
	if(strStartParent==null || strStartParent.length()==0)
		strStartParent="0";
		

	//the displayNumberOfProducts parameter passed through url decide if the numbers on the trees need to display or not
	String strDisplayNumberOfProducts = jspHelper.getParameter("displayNumberOfProducts");
	if (strDisplayNumberOfProducts == null || strDisplayNumberOfProducts.equals("false") == false)
	{
		strDisplayNumberOfProducts = "true";	//enabled by default
	}
	else
		strDisplayNumberOfProducts="false";
	
	//check if the SKU function is enabled	
	String strExtFunctionSKU = jspHelper.getParameter("ExtFunctionSKU");
	if (strExtFunctionSKU!= null && strExtFunctionSKU.equals("true"))
		strExtFunctionSKU= "true";	
	else
		strExtFunctionSKU="false"; //disabled by default
		
	
	boolean bStoreViewOnly=false;    
    try 
    {
		AccessControlHelperDataBean dbAccHelper= new AccessControlHelperDataBean();
		dbAccHelper.setInterfaceName(NavCatCategoryCreateControllerCmd.NAME);
		DataBeanManager.activate(dbAccHelper,cmdContext);
		bStoreViewOnly=dbAccHelper.isReadOnly();
    }
    catch ( Exception e)
    {
    }
%>

<HTML>

<SCRIPT>

	//////////////////////////////////////////////////////////////////////////////////////
	// - preload images for the two trees
	//////////////////////////////////////////////////////////////////////////////////////
	var arrayImages= new Array();
	arrayImages[arrayImages.length]="/wcs/images/tools/catalog/link.gif";
	arrayImages[arrayImages.length]="/wcs/images/tools/catalog/folderlockedclosed.gif";
	arrayImages[arrayImages.length]="/wcs/images/tools/catalog/folderlockedopen.gif";
	arrayImages[arrayImages.length]="/wcs/images/tools/catalog/folderclosed.gif";
	arrayImages[arrayImages.length]="/wcs/images/tools/catalog/folderopen.gif";
	arrayImages[arrayImages.length]="/wcs/images/tools/catalog/linebottom.gif";
	arrayImages[arrayImages.length]="/wcs/images/tools/catalog/linemiddle.gif";
	arrayImages[arrayImages.length]="/wcs/images/tools/catalog/linestraight.gif";
	arrayImages[arrayImages.length]="/wcs/images/tools/catalog/linetop.gif";
	
	function preLoadImages()
	{
		for(var i=0; i<arrayImages.length; i++)
		{
			var src=arrayImages[i];
			arrayImages[i]=new Image();
			arrayImages[i].src=src;
		}	
	}
	preLoadImages();

	//////////////////////////////////////////////////////////////////////////////////////
	// Variables to maintain state information
	//////////////////////////////////////////////////////////////////////////////////////
	var workframeReady = false;                  // true indicates that a command has completed, false indicates that the system is updating
	var showSourceProductsInitialState = null;   // maintains the current screen state when entering the show source products screen
	var showTargetProductsInitialState = null;   // maintains the current screen state when entering the show target products screen
	var showSourceEditInitialState = null;       // maintains the current screen state when entering the edit category screen

	var currentSourceArray = new Array();

	var currentSourceDetailCatalog = null;                // The current tree catalog
	var currentTargetDetailCatalog = "<%=strCatalogId%>"; // The current tree catalog

	var currentTargetTreeElement = null;   // The currently selected target element
	var currentSourceTreeElement = null;   // The currently selected source element

	var currentTargetCategoryIdentifier = null;   // The currently selected target category identifier
	var currentSourceCategoryIdentifier = null;   // The currently selected source category identifier

	var currentSourceProductsOnly = false;  // This value is set to true when the source buttons must reflect products only
	var currentTargetProductsOnly = false;  // This value is set to true when the target buttons must reflect products only

	var sourceTreeStatus = null;
	var targetTreeStatus = null;

	var targetIndex = 0; // The index of the current target frameset
	var sourceIndex = 0; // The index of the current source frameset

	var bStoreViewOnly=<%=bStoreViewOnly%>;

	var amidone = false;

	//////////////////////////////////////////////////////////////////////////////////////
	// stateObject(element)
	//
	// - create a target or source element to maintain the state of the screen
	//////////////////////////////////////////////////////////////////////////////////////
	function stateObject(element)
	{
		this.element = element;
		this.index = -1;
		this.rowString = "";
		this.titleString = "";
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// currentStateObject()
	//
	// - creates both a target and a source state object maintaining the current
	//   state of the screen
	//////////////////////////////////////////////////////////////////////////////////////
	function currentStateObject()
	{
		this.targetObject = new stateObject(currentTargetTreeElement);
		this.targetObject.index       = targetIndex;
		this.targetObject.rowString   = targetFrameFS.rows;
		this.targetObject.titleString = targetTitleFrame.getTitleValue();

		this.sourceObject = new stateObject(currentSourceTreeElement);
		this.sourceObject.index       = sourceIndex;
		this.sourceObject.rowString   = sourceFrameFS.rows;
		this.sourceObject.titleString = sourceTitleFrame.getTitleValue();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called when the frame is loaded
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad()
	{
		top.showProgressIndicator(true);
		setSourceFrame(5, "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceInformation_Title"))%>");
		amidone = true;
		targetTreeFrame.onFirstLoad();
		top.showProgressIndicator(false);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setSourceFrame(index, title)
	//
	// @param index - the index into the frameset array
	// @param title - the title to display in the source title frame
	//
	// - this function will display the requested frame
	//////////////////////////////////////////////////////////////////////////////////////
	function setSourceFrame(index, title)
	{
		if (sourceIndex == index) return;
		currentSourceArray[sourceIndex] = currentSourceTreeElement;
		currentSourceTreeElement = currentSourceArray[index];

		sourceIndex = eval(index);
		sourceTitleFrame.setTitleValue(title);
		sourceTitleFrame.setIcons(index);

		if (index == 0) {
			sourceFrameFS.rows = "*, 0, 0, 0, 0, 0, 0";
			if (sourceTreeFrameButtons.setButtons) 
				sourceTreeFrameButtons.setButtons();	
		} else if (index == 1) {
			sourceFrameFS.rows = "0, *, 0, 0, 0, 0, 0";
		} else if (index == 2) {
			sourceFrameFS.rows = "0, 0, *, 0, 0, 0, 0";
		} else if (index == 3) {
			sourceFrameFS.rows = "0, 0, 0, *, 0, 0, 0";
		} else if (index == 4) {
			sourceFrameFS.rows = "0, 0, 0, 0, *, 0, 0";
		} else if (index == 5) {
			sourceFrameFS.rows = "0, 0, 0, 0, 0, *, 0";
		} else if (index == 6) {
			sourceFrameFS.rows = "0, 0, 0, 0, 0, 0, *";
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setTargetFrame(index, title)
	//
	// @param index - the index into the frameset array
	// @param title - the title to display in the target title frame
	//
	// - this function will display the requested frame
	//////////////////////////////////////////////////////////////////////////////////////
	function setTargetFrame(index, title)
	{
		targetIndex = eval(index);
		targetTitleFrame.setTitleValue(title);
		currentSourceProductsOnly = false;

		if (index == 0) {
			targetFrameFS.rows = "*, 0, 0, 0, 0, 0";
		} else if (index == 1) {
			currentSourceProductsOnly = true;
			targetFrameFS.rows = "0, *, 0, 0, 0, 0";
		} else if (index == 2) {
			targetFrameFS.rows = "0, 0, *, 0, 0, 0";
		} else if (index == 3) {
			targetFrameFS.rows = "0, 0, 0, *, 0, 0";
		} else if (index == 4) {
			targetFrameFS.rows = "0, 0, 0, 0, *, 0";
		} else if (index == 5) {
			targetFrameFS.rows = "0, 0, 0, 0, 0, *";
		}

		resetSourceButtons();  // redisplay the buttons based on a target frame change
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setWorkframeReady(value)
	//
	// @param value - true if workframe is ready, otherwise false
	//
	// - set true/false to indicate whether or not the workframe is ready for more work
	//////////////////////////////////////////////////////////////////////////////////////
	function setWorkframeReady(value)
	{
		workframeReady = value;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// getWorkframeReady()
	//
	// - returns true if the workframe is ready for more work
	//////////////////////////////////////////////////////////////////////////////////////
	function getWorkframeReady()
	{
		return workframeReady;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setSourceElement(element,bLocked)
	//
	// @param element - the current source element from the tree
	// @param bLocked - boolean: true to indicate the element is locked ; false otherwise
	//
	// - set the current source element
	//////////////////////////////////////////////////////////////////////////////////////
	function setSourceElement(element,bLocked)
	{
		currentSourceTreeElement = element;
		sourceLocked=bLocked;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setTargetElement(element,bLocked)
	//
	// @param element - the current target element from the tree
	// @param bLocked - boolean: true to indicate the element is locked ; false otherwise
	//
	// - set the current target element
	//////////////////////////////////////////////////////////////////////////////////////
	function setTargetElement(element,bLocked)
	{
		currentTargetTreeElement = element;
		targetLocked=bLocked;
		setButtonsByTargetLockStatus(currentTargetTreeElement.LOCK);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// elementType(type)
	//
	// @param type - the catentry type to display
	//
	// - return the displayed value for this type
	//////////////////////////////////////////////////////////////////////////////////////
	function elementType(type)
	{
		switch (type)
		{
			case "ProductBean":
				return '<IMG SRC="/wcs/images/tools/catalog/product_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_product"))%>">';
			case "ProductItemBean":
				return '<IMG SRC="/wcs/images/tools/catalog/productitem_grey.gif" ALT="Orderable Product">';
			case "ItemBean":
				return '<IMG SRC="/wcs/images/tools/catalog/skuitem_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_item"))%>">';
			case "PackageBean":
				return '<IMG SRC="/wcs/images/tools/catalog/bundle_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_package"))%>">';
			case "BundleBean":
				return '<IMG SRC="/wcs/images/tools/catalog/package_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_bundle"))%>">';
			case "DynamicKitBean":
				return '<IMG SRC="/wcs/images/tools/catalog/dynamkit_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_dynKit"))%>">';
		}
		return "X";
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// resetSourceButtons()
	//
	// - reset the buttons based on the frameset
	//////////////////////////////////////////////////////////////////////////////////////
	function resetSourceButtons()
	{
		if (categoriesResult.resetButtons) categoriesResult.resetButtons();
		if (sourceTreeFrame.resetButtons)  sourceTreeFrame.resetButtons();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setButtonsByTargetLockStatus(status)
	//
	// @param status - true or false indicating the lock status of the current target
	//
	// - this function sets the buttons appropriately to enabled or disabled
	//////////////////////////////////////////////////////////////////////////////////////
	function setButtonsByTargetLockStatus(status)
	{
		if (targetTreeFrame.setByLockStatus) targetTreeFrame.setByLockStatus(status);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// showSourceProducts(title, catalogId, categoryId)
	//
	// @param catalogId - the catalog id of the products
	// @param categoryId - the list of categories of the products to display   1234,5678
	//
	// - display the product detail screen
	// - capture the current state of the screen so that it can be returned after exiting
	//////////////////////////////////////////////////////////////////////////////////////
	var m_SourceProducts_CatalogId=null;
	var m_SourceProducts_CategoryId=null;
	function showSourceProducts(title, catalogId, categoryId)
	{
		showSourceProductsInitialState = new currentStateObject();

		currentSourceCategoryIdentifier = title;
		if (catalogId == null)  catalogId  = currentSourceDetailCatalog;
		if (categoryId == null) categoryId = currentSourceTreeElement.id;

		var urlPara = new Object();
		urlPara.catalogId  = catalogId;
		urlPara.categoryId = categoryId;
		urlPara.ExtFunctionSKU=bExtFunctionSKU;
		top.mccmain.submitForm("/webapp/wcs/tools/servlet/NavCatSourceProducts", urlPara, "sourceProductsContents");

		setSourceFrame(1, "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatDialog_showProductsTitle"))%>");
		
		m_SourceProducts_CatalogId=catalogId;
		m_SourceProducts_CategoryId=categoryId;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// hideSourceProducts()
	//
	// - reset the screen to what it was before entering show Products
	//////////////////////////////////////////////////////////////////////////////////////
	function hideSourceProducts()
	{
		sourceProductsContents.location.href = "/wcs/tools/common/blank.html";
		setSourceFrame(showSourceProductsInitialState.sourceObject.index, showSourceProductsInitialState.sourceObject.titleString);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// showTargetProducts()
	//
	// - display the product detail screen
	// - capture the current state of the screen so that it can be returned after exiting
	//////////////////////////////////////////////////////////////////////////////////////
	function showTargetProducts()
	{
		showTargetProductsInitialState = new currentStateObject();

		var urlPara = new Object();
		urlPara.catalogId  = currentTargetDetailCatalog;
		urlPara.categoryId = currentTargetTreeElement.id;
		urlPara.ExtFunctionSKU=bExtFunctionSKU;
		top.mccmain.submitForm("/webapp/wcs/tools/servlet/NavCatTargetProducts", urlPara, "targetProductsContents");

		var categoryName = currentTargetTreeElement.children(1).firstChild.nodeValue;
		setTargetFrame(1, "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatDialog_showProductsTitle"))%>");
		//if (targetProductsContentsButtons.inptAdd) targetProductsContentsButtons.inptAdd.focus();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// hideTargetProducts()
	//
	// - reset the screen to what it was before entering show Products
	//////////////////////////////////////////////////////////////////////////////////////
	function hideTargetProducts()
	{
		targetProductsContents.location.href = "/wcs/tools/common/blank.html";
		setTargetFrame(showTargetProductsInitialState.targetObject.index, showTargetProductsInitialState.targetObject.titleString);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// refreshTargetProducts(value)
	//
	// @param value - value is a field that can be used to determine redirect logic
	//
	// - display the product detail screen again
	//////////////////////////////////////////////////////////////////////////////////////
	function refreshTargetProducts(value)
	{
		if (targetProductsContents.refresh)
			 targetProductsContents.refresh(value);
		else
		{	 
			var urlPara = new Object();
			urlPara.catalogId  = currentTargetDetailCatalog;
			urlPara.categoryId = currentTargetTreeElement.id;
			urlPara.ExtFunctionSKU=bExtFunctionSKU;
			top.mccmain.submitForm("/webapp/wcs/tools/servlet/NavCatTargetProducts", urlPara, "targetProductsContents");
		}	
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// launchPMT()
	//
	// - launch the PMT tool
	//////////////////////////////////////////////////////////////////////////////////////
	function launchPMT()
	{
		//save current highlight
		top.mccbanner.trail[top.mccbanner.counter].parameters.startCategory = currentTargetTreeElement.id;
		top.mccbanner.trail[top.mccbanner.counter].parameters.startParent   = currentTargetTreeElement.PARENTCAT;
		top.mccbanner.trail[top.mccbanner.counter].parameters.rfnbr = targetTreeFrame.currentCatalogId;
	
		var title = currentTargetTreeElement.children(1).firstChild.nodeValue+ " - " + "<%=UIUtil.toJavaScript(strPMT)%>";
		//
		// Ensure that if we hit the bct find we flush the saved data
		top.put("ProductUpdateDetailDataExists", "false");
		top.setContent(title, "/webapp/wcs/tools/servlet/ProductUpdateDialog?catgroupID=" + currentTargetTreeElement.id+"&amp;ExtFunctionSKU="+bExtFunctionSKU, true);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// showEditCategory()
	//
	// - display the edit category screen
	// - capture the current state of the screen so that it can be returned after exiting
	//////////////////////////////////////////////////////////////////////////////////////
	function showEditCategory()
	{
		showSourceEditInitialState = new currentStateObject();

		var urlPara = new Object();
		urlPara.catalogId  = currentTargetDetailCatalog;
		urlPara.catgroupId = currentTargetTreeElement.id;
		top.mccmain.submitForm("/webapp/wcs/tools/servlet/NavCatUpdateCategory", urlPara, "editFrame");

		setSourceFrame(4, "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceTitle_Frame4"))%>");
		if (editFrame.categoryName) editFrame.categoryName.focus();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// hideEditCategory()
	//
	// - hide the edit category screen
	//////////////////////////////////////////////////////////////////////////////////////
	function hideEditCategory()
	{
		editFrame.location.href = "/wcs/tools/common/blank.html";
		setSourceFrame(5, "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceInformation_Title"))%>");
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// hideCreateCategory()
	//
	// - hide the create category screen
	//////////////////////////////////////////////////////////////////////////////////////
	function hideCreateCategory()
	{
		setSourceFrame(5, "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceInformation_Title"))%>");
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// showTargetChildren()
	//
	// - display the children detail screen
	// - capture the current state of the screen so that it can be returned after exiting
	//////////////////////////////////////////////////////////////////////////////////////
	function showTargetChildren()
	{
		showTargetProductsInitialState = new currentStateObject();

		var urlPara = new Object();
		urlPara.catalogId  = currentTargetDetailCatalog;
		urlPara.categoryId = currentTargetTreeElement.id;
		top.mccmain.submitForm("/webapp/wcs/tools/servlet/NavCatTargetChildren", urlPara, "targetChildrenContent");

		setTargetFrame(3, "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatDialog_showChildrenTitle"))%>");
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// hideTargetChildren()
	//
	// - reset the screen to what it was before entering show Children
	//////////////////////////////////////////////////////////////////////////////////////
	function hideTargetChildren()
	{
		targetChildrenContent.location.href = "/wcs/tools/common/blank.html";
		setTargetFrame(showTargetProductsInitialState.targetObject.index, showTargetProductsInitialState.targetObject.titleString);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// refreshTargetChildren(value)
	//
	// @param value - value is a field that can be used to determine redirect logic
	//
	// - display the children detail screen again
	//////////////////////////////////////////////////////////////////////////////////////
	function refreshTargetChildren(value)
	{
		if (targetChildrenContent.refresh) targetChildrenContent.refresh(value);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// refreshTargetTree(value)
	//
	// @param value - value is a return value
	//
	// - display the tree screen again
	//////////////////////////////////////////////////////////////////////////////////////
	function refreshTargetTree(value,openSubTree)
	{
		var urlPara = new Object();
		if(value != null)
		{
			var strArray = value.split(",");
			urlPara.catalogId     = currentTargetDetailCatalog;
			urlPara.startCategory = strArray[0];
			urlPara.startParent   = strArray[1];
			urlPara.displayNumberOfProducts=bDisplayNumberOfProducts;
			urlPara.ExtFunctionSKU=bExtFunctionSKU;
		}
		else
		{
			urlPara.catalogId     = currentTargetDetailCatalog;
			urlPara.displayNumberOfProducts=bDisplayNumberOfProducts;
			urlPara.ExtFunctionSKU=bExtFunctionSKU;
			if(currentTargetTreeElement != null)
			{
				urlPara.startCategory = currentTargetTreeElement.id;
				urlPara.startParent   = currentTargetTreeElement.PARENTCAT;
				if((openSubTree!=null) && (openSubTree==true))
					urlPara.isOpen	= true;
				else if(currentTargetTreeElement.parentNode.isOpen != undefined)
					urlPara.isOpen	= currentTargetTreeElement.parentNode.isOpen;
			}	
		}	
		top.mccmain.submitForm("/webapp/wcs/tools/servlet/NavCatTargetTree", urlPara, "targetTreeFrame");
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// refreshSource()
	//
	// - when source catalog == target catalog, refreshing target need to include source 
	//////////////////////////////////////////////////////////////////////////////////////
	function refreshSourceTree()
	{
		var urlPara = new Object();
		urlPara.catalogId     = currentSourceDetailCatalog;
		urlPara.displayNumberOfProducts=bDisplayNumberOfProducts;
		urlPara.ExtFunctionSKU=bExtFunctionSKU;
		if(currentSourceTreeElement != null)
		{
			urlPara.startCategory = currentSourceTreeElement.id;
			urlPara.startParent   = currentSourceTreeElement.PARENTCAT;
			if(currentSourceTreeElement.parentNode != null)
			if(currentSourceTreeElement.parentNode.isOpen != undefined)
				urlPara.isOpen	= currentSourceTreeElement.parentNode.isOpen;
		}	
		
		top.mccmain.submitForm("/webapp/wcs/tools/servlet/NavCatSourceTree", urlPara, "sourceTreeFrame");
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// updateCategoryProductCounts(strCatalogId, strCategoryId, strNumOfProducts)
	//
	// - update the product counts on the tree. This function is called from the target product list page
	//////////////////////////////////////////////////////////////////////////////////////
	function updateCategoryProductCounts(strCatalogId, strCategoryId, strNumOfProducts)
	{
		if(bDisplayNumberOfProducts)
		{
			if(currentTargetDetailCatalog != null)
			 if(currentTargetDetailCatalog == strCatalogId)
			  if(targetTreeFrame.updateCategoryProductCounts)
			 	  targetTreeFrame.updateCategoryProductCounts(strCategoryId, strNumOfProducts);
	
			if(currentSourceDetailCatalog != null)
			 if(currentSourceDetailCatalog == strCatalogId)
			  if(sourceTreeFrame.updateCategoryProductCounts)
			 	  sourceTreeFrame.updateCategoryProductCounts(strCategoryId, strNumOfProducts);
		}
				
		if(sourceProductsContents.refresh)
		  if(m_SourceProducts_CatalogId=strCatalogId)
		  {
		  	if(m_SourceProducts_CategoryId.indexOf(strCategoryId) != -1) 		 //check if the category's products are listed
		  		sourceProductsContents.refresh("none");
		  }		
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// replaceField(strInput, replaceString)
	//
	// @param strInput - the input string to be parsed containing ?'s
	// @param replaceString - the string which will replace the ?
	//
	// - this function replaces a ? with the replace string
	//////////////////////////////////////////////////////////////////////////////////////
	function replaceField(strInput, replaceString)
	{
		var strOutput = "";
		for (var i=0; i<strInput.length; i++)
		{
			if (strInput.charAt(i) == '?')
			{
				strOutput = strOutput + replaceString;
			} else {
				strOutput = strOutput + strInput.charAt(i);
			}
		}
		return strOutput;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setNavCatSourceCatalogList()
	//
	// - display the tree frame as the list of selectable catalogs
	//////////////////////////////////////////////////////////////////////////////////////
	function setNavCatSourceCatalogList()
	{
		sourceTreeFrame.location.href        = "/webapp/wcs/tools/servlet/NavCatSourceCatalogList";
		sourceTreeFrameButtons.location.href = "/webapp/wcs/tools/servlet/NavCatSourceCatalogListButtons";
		
		m_bSourceCatalogList=true;
	}

	m_bSourceCatalogList=true;

	//////////////////////////////////////////////////////////////////////////////////////
	// setNavCatSourceTree(catalog, category)
	//
	// @param catalog - the selected catalog to display
	// @param category - the id of the category to begin with
	//
	// - display the tree frame as a tree of the selected catalog
	//////////////////////////////////////////////////////////////////////////////////////
	function setNavCatSourceTree(catalog, category)
	{
		currentSourceDetailCatalog = catalog;

		var urlPara = new Object();
		urlPara.catalogId  = catalog;
		urlPara.startCategory = category;
		urlPara.displayNumberOfProducts=bDisplayNumberOfProducts;
		urlPara.ExtFunctionSKU=bExtFunctionSKU;
		
		top.mccmain.submitForm("/webapp/wcs/tools/servlet/NavCatSourceTree", urlPara, "sourceTreeFrame");
		top.mccmain.submitForm("/webapp/wcs/tools/servlet/NavCatSourceTreeButtons", urlPara, "sourceTreeFrameButtons");
		
		m_bSourceTreeInvalidated=false;
		m_bSourceCatalogList=false;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setCatgroupSearchResults(urlPara)
	//
	// @param urlPara - the url parameters to pass
	//
	// - set the contents of the search result page
	//////////////////////////////////////////////////////////////////////////////////////
	function setCatgroupSearchResults(urlPara)
	{
		top.mccmain.submitForm("/webapp/wcs/tools/servlet/NavCatCategoriesSearchResult", urlPara, "categoriesResult");
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// showTargetTemplates()
	//
	// - display the category display template screen
	// - capture the current state of the screen so that it can be returned after exiting
	//////////////////////////////////////////////////////////////////////////////////////
	function showTargetTemplates()
	{
		showTargetProductsInitialState = new currentStateObject();

		frameset1.cols = "100%, 0, 0";

		var urlPara = new Object();
		urlPara.catalogId  = currentTargetDetailCatalog;
		urlPara.categoryId = currentTargetTreeElement.id;
		top.mccmain.submitForm("/webapp/wcs/tools/servlet/NavCatTargetCategoryDisplay", urlPara, "targetCategoryDisplay");
		top.mccmain.submitForm("/webapp/wcs/tools/servlet/NavCatTargetCategoryDisplay2", urlPara, "targetCategoryDisplay2");

		var categoryName = currentTargetTreeElement.children(1).firstChild.nodeValue;
		setTargetFrame(2, "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatDialog_showTemplateTitle"))%>");
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// hideTargetTemplates()
	//
	// - reset the screen to what it was before entering the category display template screen
	//////////////////////////////////////////////////////////////////////////////////////
	function hideTargetTemplates()
	{
		frameset1.cols = "50%, 50%, 0";

		targetCategoryDisplay.location.href = "/wcs/tools/common/blank.html";
		targetCategoryDisplay2.location.href = "/wcs/tools/common/blank.html";
		setTargetFrame(showTargetProductsInitialState.targetObject.index, showTargetProductsInitialState.targetObject.titleString);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// targetTreeElementChanged()
	//
	// - process a change of the target tree element
	//////////////////////////////////////////////////////////////////////////////////////
	function targetTreeElementChanged()
	{
		//if (sourceIndex == 2 || sourceIndex == 4)
		if (sourceIndex == 4)
		{
			hideEditCategory();
			//setSourceFrame(5, "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceInformation_Title"))%>");
		}
		
		resetSourceButtons();
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// setCatentrySearchResults(urlPara)
	//
	// @param urlPara - the url parameters to pass
	//
	// - set the contents of the search result page
	//////////////////////////////////////////////////////////////////////////////////////
	function setCatentrySearchResults(urlParam)
	{
		top.mccmain.submitForm("/webapp/wcs/tools/servlet/NavCatCatentrySearchResult", urlParam, "catentrySearchResultFrame");
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// getHelp()
	//
	// - return F1 help key for the page
	//////////////////////////////////////////////////////////////////////////////////////
	function getHelp()
	{
		var strPanelHelpKey=getCurrentPanelHelpKey();
		if(strPanelHelpKey==null)
			return "MC.catalogTool.salesCatalogDesign.Help";
		else
			return strPanelHelpKey;	
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// getCurrentPanelHelpKey()
	//
	// - return F1 help key for current panel
	//////////////////////////////////////////////////////////////////////////////////////
	var m_strShowPanelHelp="";	
	function getCurrentPanelHelpKey()
	{
		if(m_strShowPanelHelp=='TARGET')
		{
			switch(targetIndex)
			{
				case 0:	return "MC.catalogTool.salesCatalogTargetTree.Help";
				case 1: return "MC.catalogTool.salesCatalogEditCatentries.Help";
				case 3: return "MC.catalogTool.salesCatalogListSubCategories.Help";
			}
			return null;
		}
		else if(m_strShowPanelHelp=='SOURCE')
		{
			switch(sourceIndex)
			{
				case 0: if(m_bSourceCatalogList)
							return "MC.catalogTool.salesCatalogSelectCatalog.Help";
						else
							return "MC.catalogTool.salesCatalogSourceTree.Help";
				
				case 1: return "MC.catalogTool.salesCatalogListCatentries.Help";
				case 2: return "MC.catalogTool.salesCatalogNewCategory.Help";
				
				case 3: if (sourceContentFrame3.rows=="*,0,35")
							return "MC.catalogTool.salesCatalogFindCategories.Help";
						else
							return "MC.catalogTool.salesCatalogFindCategoryResults.Help";
												
				case 4: return "MC.catalogTool.salesCatalogChangeCategory.Help";
				case 5: return null;
				
				case 6: if (catentrySearchFS.rows=="*,0,35")
							return "MC.catalogTool.salesCatalogFindCatentries.Help";
						else
							return "MC.catalogTool.salesCatalogFindCatentryResults.Help";	
			}
			return null;
		}
		else
			return null;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////
	// openPanelHelp(strTargetSource)
	//
	// - open help window for current TARGET or SOURCE panel
	//////////////////////////////////////////////////////////////////////////////////////
	function openPanelHelp(strTargetSource)
	{
		if((strTargetSource=='TARGET') || (strTargetSource=='SOURCE'))
		{
			m_strShowPanelHelp=strTargetSource;
			top.openHelp();
		}
	}
	
	 var targetLocked=false;
	 var sourceLocked=false;
	 
	//////////////////////////////////////////////////////////////////////////////////////
	// isCurrentTargetTreeElementLock()
	//
	// - returns true or false to indicate if the current target tree element is locked or not.
	//////////////////////////////////////////////////////////////////////////////////////
	function isCurrentTargetTreeElementLock()
	{
		return targetLocked;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// isCurrentSourceTreeElementLock()
	//
	// - returns true or false to indicate if the current source tree element is locked or not.
	//////////////////////////////////////////////////////////////////////////////////////
	function isCurrentSourceTreeElementLock()
	{
		return sourceLocked;
	}

	
	//////////////////////////////////////////////////////////////////////////////////////
	// bDisplayNumberOfProducts
	//
	// - if the the numbers on tree should be displayed or not
	//////////////////////////////////////////////////////////////////////////////////////
	var bDisplayNumberOfProducts=<%=strDisplayNumberOfProducts%>;
	
	var bExtFunctionSKU=<%=strExtFunctionSKU%>;

</SCRIPT>


<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=frameset1 NAME=frameset1 COLS="50%,50%,0" STYLE="border-width:0px;" ONLOAD=onLoad()>

	<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=targetFS NAME=targetFS ROWS="30,*,0,0" STYLE="border-width:2px; border-style:inset;">
		<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetTitle_Title"))%>" NAME=targetTitleFrame  SRC="/webapp/wcs/tools/servlet/NavCatTargetTitle">
		<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=targetFrameFS NAME=targetFrameFS ROWS="*, 0, 0, 0, 0, 0">
			<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=targetTreeFS NAME=targetTreeFS COLS="*, 140">
				<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetTree_Title"))%>" NAME=targetTreeFrame        SRC="/webapp/wcs/tools/servlet/NavCatTargetTree?catalogId=<%=strCatalogId%>&amp;displayNumberOfProducts=<%=strDisplayNumberOfProducts%>&amp;ExtFunctionSKU=<%=strExtFunctionSKU%>&amp;startCategory=<%=strStartCategory%>&amp;startParent=<%=strStartParent%>">
				<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetTreeButtons_Title"))%>" NAME=targetTreeFrameButtons SRC="/webapp/wcs/tools/servlet/NavCatTargetTreeButtons">
			</FRAMESET>
			<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=targetProductsFS NAME=targetProductsFS ROWS="*, 35">
				<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=targetProductsContentsFS NAME=targetProductsContentsFS COLS="*, 140">
					<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetProducts_Title"))%>" NAME=targetProductsContents        SRC="/wcs/tools/common/blank.html">
					<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetProductsButtons_Title"))%>" NAME=targetProductsContentsButtons SCROLLING=NO SRC="/webapp/wcs/tools/servlet/NavCatTargetProductsButtons">
				</FRAMESET>
				<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetProductsBottom_Title"))%>" NAME=targetProductsBottom SCROLLING=NO SRC="/webapp/wcs/tools/servlet/NavCatTargetProductsBottom">
			</FRAMESET>
			<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=categoryDisplayFS NAME=categoryDisplayFS ROWS="*,50%, 35">
				<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=categoryDisplayContentsFS NAME=categoryDisplayContentsFS COLS="*, 140">
					<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetCategoryDisplay_Title"))%>"        NAME=targetCategoryDisplay        SRC="/wcs/tools/common/blank.html">
					<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetCategoryDisplayButtons_Title"))%>" NAME=targetCategoryDisplayButtons SCROLLING=NO SRC="/webapp/wcs/tools/servlet/NavCatTargetCategoryDisplayButtons">
				</FRAMESET>
				<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=categoryDisplayContents2FS NAME=categoryDisplayContents2FS COLS="*, 140">
					<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetCategoryDisplay2_Title"))%>"        NAME=targetCategoryDisplay2        SRC="/wcs/tools/common/blank.html">
					<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetCategoryDisplayButtons2_Title"))%>" NAME=targetCategoryDisplayButtons2 SCROLLING=NO SRC="/webapp/wcs/tools/servlet/NavCatTargetCategoryDisplayButtons2">
				</FRAMESET>
				<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetCategoryDisplayBottom_Title"))%>" NAME=targetCategoryDisplayBottom SCROLLING=NO SRC="/webapp/wcs/tools/servlet/NavCatTargetCategoryDisplayBottom">
			</FRAMESET>
			<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=targetChildrenFS NAME=targetChildrenFS ROWS="*, 35">
				<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=targetChildrenContentFS NAME=targetChildrenContentFS COLS="*, 140">
					<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetChildren_Title"))%>" NAME=targetChildrenContent SRC="/wcs/tools/common/blank.html">
					<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetChildrenButtons_Title"))%>" NAME=targetChildrenButtons SCROLLING=NO SRC="/webapp/wcs/tools/servlet/NavCatTargetChildrenButtons">
				</FRAMESET>
				<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetChildrenBottom_Title"))%>" NAME=targetChildrenBottom SCROLLING=NO SRC="/webapp/wcs/tools/servlet/NavCatTargetChildrenBottom">
			</FRAMESET>
			<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetTitle_Title"))%>" NAME=targetFrame4 SRC="/wcs/tools/common/blank.html">
			<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetTitle_Title"))%>" NAME=targetFrame5 SRC="/wcs/tools/common/blank.html">
		</FRAMESET>
	</FRAMESET>

	<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=sourceFS NAME=sourceFS ROWS="30,*" STYLE="border-width:2px; border-style:inset;">
		<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceTitle_Title"))%>" NAME=sourceTitleFrame    SRC="/webapp/wcs/tools/servlet/NavCatSourceTitle">
		<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=sourceFrameFS NAME=sourceFrameFS ROWS="0, 0, 0, 0, 0, *, 0 ">
			<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=sourceFrame1FS NAME=sourceFrame1FS ROWS="*, 0">
				<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=sourceTreeFS NAME=sourceTreeFS COLS="*, 140">
					<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceTree_Title"))%>"        NAME=sourceTreeFrame        SRC="/webapp/wcs/tools/servlet/NavCatSourceCatalogList">;
					<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceTreeButtons_Title"))%>" NAME=sourceTreeFrameButtons SRC="/webapp/wcs/tools/servlet/NavCatSourceCatalogListButtons">;
				</FRAMESET>
			</FRAMESET>
			<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=sourceProductsFS NAME=sourceProductsFS ROWS="*, 35">
				<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=sourceProductsContentFS NAME=sourceProductsContentFS COLS="*, 140">
					<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceProducts_Title"))%>"        NAME=sourceProductsContents       SRC="/wcs/tools/common/blank.html">
					<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceProductsButtons_Title"))%>" NAME=sourceProductsContentButtons SRC="/webapp/wcs/tools/servlet/NavCatSourceProductsButtons">
				</FRAMESET>
				<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceProductsBottom_Title"))%>" NAME=sourceProductsBottom SRC="/webapp/wcs/tools/servlet/NavCatSourceProductsBottom">
			</FRAMESET>
			<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=createCategoryFS NAME=createCategoryFS ROWS="*,35">
				<FRAME FRAMEBORDER=NO FRAMESPACING=0 SCROLLING=NO TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceCreateCategory_Title"))%>"        NAME=createCategory        SRC="/webapp/wcs/tools/servlet/NavCatSourceCreateCategory">
				<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceCreateCategoryButtons_Title"))%>" NAME=createCategoryButtons SRC="/webapp/wcs/tools/servlet/NavCatSourceCreateCategoryButtons">
			</FRAMESET>
			<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=sourceContentFrame3 NAME=sourceContentFrame3 ROWS="*,0,35">
				<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoriesSearch_Title"))%>" NAME=categoriesSearch        SRC="/webapp/wcs/tools/servlet/NavCatCategoriesSearch">
				<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=categoriesResultFS NAME=categoriesResultFS COLS="*, 140">
					<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoriesSearchResult_Title"))%>"        NAME=categoriesResult        SRC="/wcs/tools/common/blank.html">
					<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoriesSearchResultButtons_Title"))%>" NAME=categoriesResultButtons SRC="/webapp/wcs/tools/servlet/NavCatCategoriesSearchResultButtons">
				</FRAMESET>
				<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoriesSearchButtons_Title"))%>" NAME=categoriesSearchButtons SCROLLING=NO SRC="/webapp/wcs/tools/servlet/NavCatCategoriesSearchButtons">
			</FRAMESET>
			<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=editFramesFS NAME=rightFramesFS ROWS="*,35">
				<FRAME FRAMEBORDER=NO FRAMESPACING=0 SCROLLING=NO TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceUpdateCategory_Title"))%>"        NAME=editFrame        SRC="/wcs/tools/common/blank.html">
				<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceUpdateCategoryButtons_Title"))%>" NAME=editFrameButtons SRC="/webapp/wcs/tools/servlet/NavCatUpdateCategoryButtons">
			</FRAMESET> 
			<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceInformation_Title"))%>" NAME=navCatSourceInformation SRC="/webapp/wcs/tools/servlet/NavCatSourceInformation">
			
			<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=catentrySearchFS NAME=catentrySearchFS ROWS="*,0,35">
				<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatCatentrySearchDialog_Title"))%>" NAME=catentrySearchFrame SRC="/webapp/wcs/tools/servlet/NavCatCatentrySearch">
				<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=catentrySearchResultFS NAME=catentrySearchResultFS COLS="*, 140">
					<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatCatentrySearchResult_Title"))%>"        NAME=catentrySearchResultFrame        SRC="/wcs/tools/common/blank.html">
					<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatCatentrySearchResultButtons_Title"))%>" NAME=catentrySearchResultButtonsFrame SRC="/webapp/wcs/tools/servlet/NavCatCatentrySearchResultButtons">
				</FRAMESET>
				<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatCatentrySearchButtons_Title"))%>" NAME=catentrySearchButtonsFrame SCROLLING=NO SRC="/webapp/wcs/tools/servlet/NavCatCatentrySearchButtons">
			</FRAMESET>

		</FRAMESET>
	</FRAMESET>

	<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatWorkFrame_Title"))%>" NAME=workingFrame SRC="/webapp/wcs/tools/servlet/NavCatWorkFrame">

</FRAMESET>


</HTML>

