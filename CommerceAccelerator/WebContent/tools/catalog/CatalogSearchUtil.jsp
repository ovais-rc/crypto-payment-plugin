<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>


<%--
// CatalogSearchUtil is a helper jsp to be included in the result pages when using
// CatEntrySearchDialog and CatGrpSearchDialog.
//
// This helper defines the searchType; the xmlFile, the startIndex and the listSize 
// for dynamic list and dynamic tree; as well as the search databeans, namely, 
// catEntrySearchDB for catalog entries and categorySearchDB for categories.
// 
// Results can be obtained as follows:
// 	catEntrySearchDB.getResultList();	or
//	categorySearchDB.getResultList();
--%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.search.beans.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.CompositeCatalogEntryAccessBean" %>
<%@ page import="com.ibm.commerce.ras.*" %>
<%@ page import="com.ibm.commerce.search.beans.SearchConstants" %>
<%@ page import="com.ibm.commerce.tools.common.ToolsConfiguration" %>

<%@include file="../catalog/DefaultContractBehavior.jspf" %>

<%--
//---------------------------------------------------------------------
//- Method Declarion
//---------------------------------------------------------------------
--%>

<%!
///////////////////////
// sets the parameters for catalog entry search
///////////////////////
public void setCatentryParameters(JSPHelper helper, AdvancedCatEntrySearchListDataBean catEntrySearchDB) {
	String catalogID, name, nameOp, searchScope, displayNum, sortBy, storeId, languageId;
	String startCategory, startCategoryOp, sku, skuOp, manuNum, manuNumOp, manuName, manuNameOp, published, notPublished;
	String searchProduct, searchItem, searchPackage, searchBundle, searchDynamicKit, startIndex;

	String SEARCH_OPERATOR_LIKE 		= com.ibm.commerce.search.beans.SearchConstants.OPERATOR_LIKE;
	String SEARCH_OPERATOR_EQUAL 		= com.ibm.commerce.search.beans.SearchConstants.OPERATOR_EQUAL;
	String SEARCH_CASE_SENSITIVE_NO 	= "no";
	String SEARCH_CASE_SENSITIVE_YES	= "yes";
	String SEARCH_DISTINCT_NO			= "no";

	catalogID    		= helper.getParameter("catID");
	storeId			= helper.getParameter("storeId");
	languageId		= helper.getParameter("languageId");
	name                 	= helper.getParameter("name");
	nameOp               	= helper.getParameter("nameOp");
	searchScope          	= helper.getParameter("searchScope");
	displayNum	    	= helper.getParameter("displayNum");
        sortBy                  = helper.getParameter("orderby");
	startCategory	  	= helper.getParameter("category");
	startCategoryOp		= helper.getParameter("categoryOp");
	sku               	= helper.getParameter("sku");
	skuOp		    	= helper.getParameter("skuOp");
	manuNum		    	= helper.getParameter("manuNum");
	manuNumOp	    	= helper.getParameter("manuNumOp");
	manuName                = helper.getParameter("manuName");
	manuNameOp	    	= helper.getParameter("manuNameOp");	
	published		= helper.getParameter("CEpublished");
	notPublished		= helper.getParameter("CEnotPublished");
	searchProduct           = helper.getParameter("searchProduct");
	searchItem	    	= helper.getParameter("searchItem");
	searchPackage           = helper.getParameter("searchPackage");
	searchBundle            = helper.getParameter("searchBundle");
	searchDynamicKit	= helper.getParameter("searchDynKit");
	startIndex        = helper.getParameter("startIndex");
	 
	//Trim the parameters
	if (name != null) {
		name = name.trim();
	}

	if (startCategory != null) {
		startCategory = startCategory.trim();
	}

	if (sku != null) {
		sku = sku.trim();
	}

	if (manuNum != null) {
		manuNum = manuNum.trim();
	}

	if (manuName != null) {
		manuName = manuName.trim();
	}

	try {
		// store ID
		if (storeId != null && !storeId.equals("")) {
			catEntrySearchDB.setStoreId(storeId);
		}
	
		//Manually setting the result type and markedForDelete flag
		//catEntrySearchDB.setResultType("");
		catEntrySearchDB.setMarkForDelete("0");

		//set the Language ID
		catEntrySearchDB.setLangId( languageId );

		//search result type:
		catEntrySearchDB.setIsProduct (new Boolean (searchProduct).booleanValue());
		catEntrySearchDB.setIsItem (new Boolean (searchItem).booleanValue());
		catEntrySearchDB.setIsPackage (new Boolean (searchPackage).booleanValue());
		catEntrySearchDB.setIsBundle (new Boolean (searchBundle).booleanValue());
		catEntrySearchDB.setIsDynamicKit (new Boolean (searchDynamicKit).booleanValue());

		// startIndex
		if (startIndex != null) {
			catEntrySearchDB.setBeginIndex(startIndex);
		}

		//catalog
		if (catalogID != null && !catalogID.equals("")) {
			catEntrySearchDB.setCatalogId(catalogID);
		}
		

		//category
		//if (categoryID != null && !categoryID.equals(""))
		//	catEntrySearchDB.setCategoryId(categoryID);
		//
		
		//Category Name    
		if (startCategory != null && !startCategory.equals("")) {
			catEntrySearchDB.setCategoryTerm(startCategory);
			if (startCategoryOp.equals(SEARCH_OPERATOR_EQUAL)) {
				catEntrySearchDB.setCategoryTermOperator(SEARCH_OPERATOR_EQUAL);
				catEntrySearchDB.setCategoryTermCaseSensitive(SEARCH_CASE_SENSITIVE_YES);
				catEntrySearchDB.setCategoryType("EXACT");

			} else {
				catEntrySearchDB.setCategoryTermOperator(SEARCH_OPERATOR_LIKE);
				catEntrySearchDB.setCategoryTermCaseSensitive(SEARCH_CASE_SENSITIVE_NO);
			}

			catEntrySearchDB.setSearchTermScope(new Integer (2));
		}

		// sku
		if (sku != null && !sku.equals("")) {
			catEntrySearchDB.setSku(sku);
			if (skuOp.equals(SEARCH_OPERATOR_EQUAL)) {
				catEntrySearchDB.setSkuOperator(SEARCH_OPERATOR_EQUAL);
				catEntrySearchDB.setSkuCaseSensitive(SEARCH_CASE_SENSITIVE_YES);
			} else {
				catEntrySearchDB.setSkuOperator(SEARCH_OPERATOR_LIKE);
				catEntrySearchDB.setSkuCaseSensitive(SEARCH_CASE_SENSITIVE_NO);
			}
		}

		//name    
		if (name != null && !name.equals("")) {
			catEntrySearchDB.setSearchTerm(name);
			if (nameOp.equals(SEARCH_OPERATOR_EQUAL)) {
				catEntrySearchDB.setSearchTermOperator(SEARCH_OPERATOR_EQUAL);
				catEntrySearchDB.setSearchTermCaseSensitive(SEARCH_CASE_SENSITIVE_YES);
				catEntrySearchDB.setSearchType("EXACT");
			} else {
				catEntrySearchDB.setSearchTermOperator(SEARCH_OPERATOR_LIKE);
				catEntrySearchDB.setSearchTermCaseSensitive(SEARCH_CASE_SENSITIVE_NO);
			}

			// search scope
			//By default in the catalog entry search databean,  it is set to 1,  which mean search for name and short description
			//Set it to a 2 means search on the name field only
			// 1 = search on name + short description
			// 2 = search on name only
			if (new Boolean (searchScope).booleanValue())
			{
				catEntrySearchDB.setSearchTermScope(new Integer (1));
			} else {
				catEntrySearchDB.setSearchTermScope(new Integer (2));
			}
			
		}

		//manufacturer
		if (manuName != null && !manuName.equals("")) {
			catEntrySearchDB.setManufacturer(manuName);
			if (manuNameOp.equals(SEARCH_OPERATOR_EQUAL)) {
				catEntrySearchDB.setManufacturerOperator(SEARCH_OPERATOR_EQUAL);
				catEntrySearchDB.setManufacturerCaseSensitive(SEARCH_CASE_SENSITIVE_YES);
			} else {
				catEntrySearchDB.setManufacturerOperator(SEARCH_OPERATOR_LIKE);
				catEntrySearchDB.setManufacturerCaseSensitive(SEARCH_CASE_SENSITIVE_NO);
			}
		}

		//manufacturer part number
		if (manuNum != null && !manuNum.equals("")) {
			catEntrySearchDB.setManufacturerPartNum(manuNum);
			if (manuNumOp.equals(SEARCH_OPERATOR_EQUAL)) {
				catEntrySearchDB.setManufacturerPartNumOperator(SEARCH_OPERATOR_EQUAL);
				catEntrySearchDB.setManufacturerPartNumCaseSensitive(SEARCH_CASE_SENSITIVE_YES);
			} else {
				catEntrySearchDB.setManufacturerPartNumOperator(SEARCH_OPERATOR_LIKE);
				catEntrySearchDB.setManufacturerPartNumCaseSensitive(SEARCH_CASE_SENSITIVE_NO);
			}
		}

		//published flag
		if (new Boolean(published).booleanValue()) {
			if (!new Boolean(notPublished).booleanValue()) {
				catEntrySearchDB.setPublished("1");
			}
		} else {
			if (new Boolean(notPublished).booleanValue()) {
				catEntrySearchDB.setPublished("0");
			}
		}

		//Order By   
		catEntrySearchDB.setDistinct("yes"); 
	        if (sortBy != null && !sortBy.equals (""))
        	{
        		if (sortBy.equals("SKU"))
            		{
				catEntrySearchDB.setOrderBy1( "CatEntrySKU" );
            		} else {
                		if (sortBy.equals("Name"))
                		{
					catEntrySearchDB.setOrderBy1( "CatEntDescName" );
	                	} else {
					catEntrySearchDB.setOrderBy1( "CatEntrySKU" );
	                 	}
	            	}
		} else {
			catEntrySearchDB.setOrderBy1( "CatEntrySKU" );              
	        }

		//display number
		if (displayNum != null && !displayNum.equals("")) {
			catEntrySearchDB.setPageSize(displayNum);
			catEntrySearchDB.setAcceleratorFlag(true);
			}	
			
	} catch (Exception ex) {
		  ECTrace.trace(ECTraceIdentifiers.COMPONENT_CATALOGTOOL, this.getClass().getName(), "setCatentryParameters",
					"Exception in data bean creation.");
	}
}

///////////////////////
// sets the parameters for category search
///////////////////////
public void setCategoryParameters(JSPHelper helper, CategorySearchListDataBean categorySearchDB) {
	String catalogID, name, nameOp, searchScope, displayNum;
	String identifier, identifierOp, published, notPublished;
	
	String SEARCH_OPERATOR_LIKE 		= "LIKE";
	String SEARCH_OPERATOR_EQUAL		= "=";
	String SEARCH_CASE_SENSITIVE_NO 	= "no";
	String SEARCH_CASE_SENSITIVE_YES	= "yes";
	String SEARCH_TYPE_EXACT		= "EXACT";
	String SEARCH_TYPE_ALL			= "ALL";

	catalogID	= helper.getParameter("catID");
	name		= helper.getParameter("name");
	nameOp		= helper.getParameter("nameOp");
	searchScope	= helper.getParameter("searchScope");
	displayNum	= helper.getParameter("displayNum");
	identifier	= helper.getParameter("identifier");
	identifierOp	= helper.getParameter("identifierOp");
	published	= helper.getParameter("CGpublished");
	notPublished	= helper.getParameter("CGnotPublished");

	//Trim the parameters
	if (name != null) {
		name = name.trim();
	}
	if (name != null) {
		identifier = identifier.trim();
	}

	//catalog
	//if (catalogID != null && !catalogID.equals(""))
	//	searchDB.setCatalogId(catalogID);
	//

	try {
		//identifier
		if (identifier != null && !identifier.equals("")) {
			categorySearchDB.setIdentifier(identifier);
			if (identifierOp.equals(SEARCH_OPERATOR_EQUAL)) {
				categorySearchDB.setIdentifierType(SEARCH_TYPE_EXACT);
				categorySearchDB.setIdentifierCaseSensitive(SEARCH_CASE_SENSITIVE_YES);
			} else {
				categorySearchDB.setIdentifierType(SEARCH_TYPE_ALL);
				categorySearchDB.setIdentifierCaseSensitive(SEARCH_CASE_SENSITIVE_NO);
			}
		}

		//name    
		if (name != null && !name.equals("")) {
			categorySearchDB.setName(name);
			if (nameOp.equals(SEARCH_OPERATOR_EQUAL)) {
				categorySearchDB.setNameTermOperator(SEARCH_OPERATOR_EQUAL);
				categorySearchDB.setNameCaseSensitive(SEARCH_CASE_SENSITIVE_YES);
			} else {
				categorySearchDB.setNameTermOperator(SEARCH_OPERATOR_LIKE);
				categorySearchDB.setNameCaseSensitive(SEARCH_CASE_SENSITIVE_NO);
			}

			// search scope
	//			if (new Boolean (searchScope).booleanValue())
	//				categorySearchDB.setSearchTermScope(new Integer (1));
		}

		//published flag
		if (new Boolean(published).booleanValue()) {
			if (!new Boolean(notPublished).booleanValue()) {
				categorySearchDB.setPublished("1");
			}
		} else {
			if (new Boolean(notPublished).booleanValue()) {
				categorySearchDB.setPublished("0");
			}
		}

		//display number
		if (displayNum != null && !displayNum.equals("")) {
			categorySearchDB.setPageSize(displayNum);
		}

	} catch (Exception ex) {
		  ECTrace.trace(ECTraceIdentifiers.COMPONENT_CATALOGTOOL, this.getClass().getName(), "setCategoryParameters",
					"Exception in data bean creation.");
	}
}

//------------------------
// Catalog Entry Helper functions
//------------------------
//////////////////////////////
// gets the short description for the catalog entry
//////////////////////////////
public String getShortDescription(CatalogEntryDataBean catEntry) {
	String desc = "";
	
	try {
		desc = catEntry.getDescription().getShortDescription();
	} catch (Exception ex) {
		  ECTrace.trace(ECTraceIdentifiers.COMPONENT_CATALOGTOOL, this.getClass().getName(), "getShortDescription",
					"Exception in getShortDescription().");
	}
	
	return desc;
}

//////////////////////////////
// gets the long description for the catalog entry
//////////////////////////////
public String getLongDescription(CatalogEntryDataBean catEntry) {
	String desc = "";
	
	try {
		desc = catEntry.getDescription().getLongDescription();
	} catch (Exception ex) {
		  ECTrace.trace(ECTraceIdentifiers.COMPONENT_CATALOGTOOL, this.getClass().getName(), "getLongDescription",
					"Exception in getLongDescription().");
	}
	
	return desc;
}

//////////////////////////////
// gets the name for the catalog entry
//////////////////////////////
public String getName(CatalogEntryDataBean catEntry) {
	String name = "";
	
	try {
		name = catEntry.getDescription().getName();
	} catch (Exception ex) {
		  ECTrace.trace(ECTraceIdentifiers.COMPONENT_CATALOGTOOL, this.getClass().getName(), "getName",
					"Exception in getName().");
	}
	
	return name;
}

//////////////////////////////
// gets the aux description 1 for the catalog entry
//////////////////////////////
public String getAuxDescription1(CatalogEntryDataBean catEntry) {
	String desc = "";
	
	try {
		desc = catEntry.getDescription().getAuxDescription1();
	} catch (Exception ex) {
		  ECTrace.trace(ECTraceIdentifiers.COMPONENT_CATALOGTOOL, this.getClass().getName(), "getAuxDescription1",
					"Exception in getAuxDescription1().");
	}
	
	return desc;
}

//////////////////////////////
// gets the aux description 2 for the catalog entry
//////////////////////////////
public String getAuxDescription2(CatalogEntryDataBean catEntry) {
	String desc = "";
	
	try {
		desc = catEntry.getDescription().getAuxDescription2();
	} catch (Exception ex) {
		  ECTrace.trace(ECTraceIdentifiers.COMPONENT_CATALOGTOOL, this.getClass().getName(), "getAuxDescription2",
					"Exception in getAuxDescription2().");
	}

	return desc;
}

//////////////////////////////
// gets the thumbnail for the catalog entry
//////////////////////////////
public String getThumbNail(CatalogEntryDataBean catEntry) {
	String thumbnail = "";
	
	try {
		thumbnail = catEntry.getDescription().getThumbNail();
	} catch (Exception ex) {
		  ECTrace.trace(ECTraceIdentifiers.COMPONENT_CATALOGTOOL, this.getClass().getName(), "getThumbNail",
					"Exception in getThumbNail().");	
	}
	
	return thumbnail;
}

//////////////////////////////
// gets the fullimage for the catalog entry
//////////////////////////////
public String getFullImage(CatalogEntryDataBean catEntry) {
	String image = "";
	
	try {
		image = catEntry.getDescription().getFullImage();
	} catch (Exception ex) {
		  ECTrace.trace(ECTraceIdentifiers.COMPONENT_CATALOGTOOL, this.getClass().getName(), "getFullImage",
					"Exception in getFullImage()");
	}
	
	return image;
}

//////////////////////////////
// gets the children products of the catalog entry
//////////////////////////////
public ProductDataBean[] getChildrenProducts(CatalogEntryDataBean catEntry) {
	PackageDataBean packageDB = null;
	BundleDataBean bundleDB = null;
	ProductDataBean[] children = null;
	
	try {
		if (catEntry.getType().equals("PackageBean")) {
			packageDB = new PackageDataBean(catEntry);
			CompositeProductDataBean[] products = packageDB.getPackagedProducts();
			
			children = new ProductDataBean[products.length];
			
			for (int i=0; i<products.length; i++) {
				children[i] = products[i].getProduct();
				children[i].setAdminMode(true);
			}
				
		} else if (catEntry.getType().equals("BundleBean")) {
			bundleDB = new BundleDataBean(catEntry);
			CompositeProductDataBean[] products = bundleDB.getBundledProducts();
			
			children = new ProductDataBean[products.length];
			
			for (int i=0; i<products.length; i++) {
				children[i] = products[i].getProduct();
				children[i].setAdminMode(true);
			}
				
		}
	} catch (Exception ex) {
		  ECTrace.trace(ECTraceIdentifiers.COMPONENT_CATALOGTOOL, this.getClass().getName(), "getChildrenProducts",
					"Exception in getChildrenProducts().");	
	}
	
	return children;
}

//////////////////////////////
// gets the children packages of the catalog entry
//////////////////////////////
public PackageDataBean[] getChildrenPackages(CatalogEntryDataBean catEntry) {
	BundleDataBean bundleDB = null;
	PackageDataBean[] children = null;
	
	try {
		if (catEntry.getType().equals("BundleBean")) {
			bundleDB = new BundleDataBean(catEntry);
			CompositePackageDataBean[] packages = bundleDB.getBundledPackages();
			
			children = new PackageDataBean[packages.length];
			
			for (int i=0; i<packages.length; i++) {
				children[i] = packages[i].getPackage();
				children[i].setAdminMode(true);
			}
				
		}
	} catch (Exception ex) {
		  ECTrace.trace(ECTraceIdentifiers.COMPONENT_CATALOGTOOL, this.getClass().getName(), "getChildrenPackages",
					"Exception in getChildrenPackages().");		
	}
	
	return children;
}


//////////////////////////////
// gets the children items of the catalog entry
//////////////////////////////
public ItemDataBean[] getChildrenItems(CatalogEntryDataBean catEntry) {
	PackageDataBean packageDB = null;
	BundleDataBean bundleDB = null;
	ItemDataBean[] children = null;
	
	try {
		if (catEntry.getType().equals("PackageBean")) {
			packageDB = new PackageDataBean(catEntry);
			CompositeItemDataBean[] items = packageDB.getPackagedItems();
			
			children = new ItemDataBean[items.length];
			
			for (int i=0; i<items.length; i++) {
				children[i] = items[i].getItem();
				children[i].setAdminMode(true);
			}
				
		} else if (catEntry.getType().equals("BundleBean")) {
			bundleDB = new BundleDataBean(catEntry);
			CompositeItemDataBean[] items = bundleDB.getBundledItems();
			
			children = new ItemDataBean[items.length];
			
			for (int i=0; i<items.length; i++) {
				children[i] = items[i].getItem();
				children[i].setAdminMode(true);
			}
				
		}
	} catch (Exception ex) {
		  ECTrace.trace(ECTraceIdentifiers.COMPONENT_CATALOGTOOL, this.getClass().getName(), "getChildrenItems",
					"Exception in getChildrenItems().");			
	}
	
	return children;
}


//////////////////////////////
// gets the children object of the catalog entries
//////////////////////////////
public CatalogEntryAccessBean[] getChildren(CatalogEntryDataBean catEntry) {
	PackageDataBean packageDB = null;
	BundleDataBean bundleDB = null;
	CatalogEntryAccessBean[] children = null;

	try {
		if (catEntry.getType().equals("PackageBean")) {
			packageDB = new PackageDataBean(catEntry);
			CompositeCatalogEntryAccessBean[] items = (CompositeCatalogEntryAccessBean[])packageDB.getPackagedItems();
			CompositeCatalogEntryAccessBean[] products = (CompositeCatalogEntryAccessBean[])packageDB.getPackagedProducts();
			
			children = new CatalogEntryAccessBean[items.length + products.length];

			for (int i=0; i<items.length; i++) {
				children[i] = items[i].getCompositeCatalogEntry(); 
			}
			
			for (int i=0; i<products.length; i++)  {
				children[i+items.length] = products[i].getCompositeCatalogEntry(); 
			}
			
		} else if (catEntry.getType().equals("BundleBean")) {
			bundleDB = new BundleDataBean(catEntry);
			CompositeCatalogEntryAccessBean[] items = (CompositeCatalogEntryAccessBean[])bundleDB.getBundledItems();
			CompositeCatalogEntryAccessBean[] products = (CompositeCatalogEntryAccessBean[])bundleDB.getBundledProducts();
			CompositeCatalogEntryAccessBean[] packages = (CompositeCatalogEntryAccessBean[])bundleDB.getBundledPackages();
			
			children = new CatalogEntryAccessBean[items.length + products.length + packages.length];
			
			for (int i=0; i<items.length; i++) {
				children[i] = items[i].getCompositeCatalogEntry();
			}
				
			for (int i=0; i<products.length; i++) {
				children[i+items.length] = products[i].getCompositeCatalogEntry();
			}
				
			for (int i=0; i<packages.length; i++) {
				children[i+items.length+products.length] = packages[i].getCompositeCatalogEntry();
			}
		}
	} catch (Exception ex) {
		  ECTrace.trace(ECTraceIdentifiers.COMPONENT_CATALOGTOOL, this.getClass().getName(), "getChildren",
					"Exception in getChildren().");				
	}

	return children;
}


//------------------------
// Category Helper functions
//------------------------
//////////////////////////////
// gets the short description for the category
//////////////////////////////
public String getShortDescription(CategoryDataBean category) {
	String desc = "";
	
	try {
		desc = category.getDescription().getShortDescription();
	} catch (Exception ex) {
		  ECTrace.trace(ECTraceIdentifiers.COMPONENT_CATALOGTOOL, this.getClass().getName(), "getShortDescription",
					"Exception in getShortDescription().");				
	}
	
	return desc;
}

//////////////////////////////
// gets the long description for the category
//////////////////////////////
public String getLongDescription(CategoryDataBean category) {
	String desc = "";
	
	try {
		desc = category.getDescription().getLongDescription();
	} catch (Exception ex) {
		  ECTrace.trace(ECTraceIdentifiers.COMPONENT_CATALOGTOOL, this.getClass().getName(), "getLongDescription",
					"Exception in getLongDescription().");				
	}
	
	return desc;
}

//////////////////////////////
// gets the name for the category
//////////////////////////////
public String getName(CategoryDataBean category) {
	String name = "";
	
	try {
		name = category.getDescription().getName();
	} catch (Exception ex) {
	    ECTrace.trace(ECTraceIdentifiers.COMPONENT_CATALOGTOOL, this.getClass().getName(), "getName",
					"Exception in getName().");				
	}
	
	return name;
}

//////////////////////////////
// gets the keyword for the category
//////////////////////////////
public String getKeyword(CategoryDataBean category) {
	String keyword = "";
	
	try {
		keyword = category.getDescription().getKeyWord();
	} catch (Exception ex) {
	    ECTrace.trace(ECTraceIdentifiers.COMPONENT_CATALOGTOOL, this.getClass().getName(), "getKeyword",
					"Exception in getKeyword().");				
	}
	
	return keyword;
}


%>

<%--
//---------------------------------------------------------------------
//- Logic Section
//---------------------------------------------------------------------
--%>

<%
	JSPHelper searchJSPHelper	= new JSPHelper(request);
	String searchType		= searchJSPHelper.getParameter("searchType");
	//String xmlFile 	                = searchJSPHelper.getParameter("ActionXMLFile");
	String actionEP			= searchJSPHelper.getParameter("actionEP");

	if (actionEP == null) {
		actionEP = "";
	}

	AdvancedCatEntrySearchListDataBean catEntrySearchDB = null;
	CategorySearchListDataBean categorySearchDB = null;
	
	if ((searchType != null && searchType.trim().equals("") == false) || actionEP.equals("GO_BACK")) {
		////////////////////////////
		// catentry search
		////////////////////////////
		if (searchType.equals("catentry") || searchType.equals("product") || 
		    searchType.equals("item") || searchType.equals("notItem") || 
		    searchType.equals("package")) {

			try {
				catEntrySearchDB = new AdvancedCatEntrySearchListDataBean();
				
				// Out-of-box, Accelerator behaves like the store front. So if products are excluded
				// in the default store contract, then we won't be able to browse or search them in Accelerator.
				// By default, the method isRemoveDefaultContract() returns false. 
				// By changing this method to return true, then we remove any default contract that
				// we pass to ProductSetEntitlementHelper.
				// isRemoveDefaultContract() is defined in the file DefaultContractBehavior.jspf
				
				boolean removeDefaultContract = isRemoveDefaultContract();
				
				catEntrySearchDB.setRemoveDefaultContract(removeDefaultContract);
				
				setCatentryParameters(searchJSPHelper, catEntrySearchDB);
				com.ibm.commerce.beans.DataBeanManager.activate(catEntrySearchDB, request);
			} catch (Exception ex) {
			    ECTrace.trace(ECTraceIdentifiers.COMPONENT_CATALOGTOOL, this.getClass().getName(), "main",
						"Exception in AdvancedCatEntrySearchListDataBean().");				
			}


		///////////////////////////
		// category search
		///////////////////////////
		} else {

			try {
				categorySearchDB = new CategorySearchListDataBean();
				setCategoryParameters(searchJSPHelper, categorySearchDB);
				com.ibm.commerce.beans.DataBeanManager.activate(categorySearchDB, request);
			} catch (Exception ex) {
			    ECTrace.trace(ECTraceIdentifiers.COMPONENT_CATALOGTOOL, this.getClass().getName(), "main",
						"Exception in CategorySearchListDataBean().");				
			}

		}
	}

	
%>
