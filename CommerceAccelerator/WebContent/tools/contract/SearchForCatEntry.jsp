<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
--%>

<%@ page language="java" %>
<%@ page import="java.util.*" %>

<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.command.CommandFactory" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.ras.ECTrace" %>
<%@ page import="com.ibm.commerce.ras.ECTraceIdentifiers" %>
<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>



<%--
//---------------------------------------------------------------------
//
// Name       : SearchForCatEntry.jsp
//
// Description: This JSP applies given search criteria and performs
//              searching of category entries. It uses the given
//              keyword to search against both category entry names
//              and SKU fields.
//              Based on the search results, it will generate the
//              proper javascript functions allowing the callers
//              to call-back for retrieving the search results. It
//              is designed to be used with an IFRAME and does not
//              produce any GUI to users.
//
// Parameters : The parameters for using this JSP are described below:
//
//              searchType   - specify the search type, valid options
//                             are listed below:
//                            -1 - No search should be performed
//                             0 - No criteria, it will search all
//                             1 - Match case, beginning with
//                             2 - Match case, containing
//                             3 - Ignore case, beginning with
//                             4 - Ignore case, containing
//                             5 - Exact match
//
//              searchString - specify the search keyword
//
//              maxThreshold - the max. number of returning matched
//                             results allowed
//
// Output     : There are three javascript functions will be generated
//              after this JSP being executed. The caller programs can
//              invoke these javascript functions to access the search
//              result. The javascript functions are list below:
//                 - getSearchResultCondition()
//                 - getResultIdList()
//                 - getResultNameList()
//                 - getResultSKUList()
//
//---------------------------------------------------------------------
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

<%--
//---------------------------------------------------------------------
//- Method Declarion
//---------------------------------------------------------------------
--%>


<%!

private static final String SEARCHTYPE_MATCH_CASE_BEGINNING_WITH="SEARCHTYPE_MATCH_CASE_BEGINNING_WITH";
private static final String SEARCHTYPE_MATCH_CASE_CONTAINING="SEARCHTYPE_MATCH_CASE_CONTAINING";
private static final String SEARCHTYPE_IGNORE_CASE_BEGINNING_WITH="SEARCHTYPE_IGNORE_CASE_BEGINNING_WITH";
private static final String SEARCHTYPE_IGNORE_CASE_CONTAINING="SEARCHTYPE_IGNORE_CASE_CONTAINING";
private static final String SEARCHTYPE_EXACT_MATCH="SEARCHTYPE_EXACT_MATCH";
private static final String SEARCHTYPE_SEARCH_ALL="SEARCHTYPE_SEARCH_ALL";


///////////////////////
// sets the parameters for catalog entry search
///////////////////////
public void setCatentryParameters(AdvancedCatEntrySearchListDataBean catEntrySearchDB,
                                  HashMap searchParameters)
{
   String catalogID, name, nameSearchType, searchScope, displayNum, sortBy, storeId, languageId;
   String startCategory, startCategoryOp, sku, skuOp, manuNum, manuNumOp, manuName, manuNameOp, published, notPublished;
   String searchProduct, searchItem, searchPackage, searchBundle, searchDynamicKit, startIndex;

   String SEARCH_OPERATOR_LIKE      = com.ibm.commerce.search.beans.SearchConstants.OPERATOR_LIKE;
   String SEARCH_OPERATOR_EQUAL     = com.ibm.commerce.search.beans.SearchConstants.OPERATOR_EQUAL;
   String SEARCH_CASE_SENSITIVE_NO  = "no";
   String SEARCH_CASE_SENSITIVE_YES = "yes";
   String SEARCH_DISTINCT_NO        = "no";


   catalogID        = (String) searchParameters.get("catalogID");
   storeId          = (String) searchParameters.get("storeId");
   languageId       = (String) searchParameters.get("languageId");
   name             = (String) searchParameters.get("name");
   nameSearchType   = (String) searchParameters.get("nameSearchType");
   searchScope      = (String) searchParameters.get("searchScope");
   displayNum       = (String) searchParameters.get("displayNum");
   sortBy           = (String) searchParameters.get("sortBy");
   startCategory    = (String) searchParameters.get("startCategory");
   startCategoryOp  = (String) searchParameters.get("startCategoryOp");
   sku              = (String) searchParameters.get("sku");
   skuOp            = (String) searchParameters.get("skuOp");
   manuNum          = (String) searchParameters.get("manuNum");
   manuNumOp        = (String) searchParameters.get("manuNumOp");
   manuName         = (String) searchParameters.get("manuName");
   manuNameOp       = (String) searchParameters.get("manuNameOp");
   published        = (String) searchParameters.get("published");
   notPublished     = (String) searchParameters.get("notPublished");
   searchProduct    = (String) searchParameters.get("searchProduct");
   searchItem       = (String) searchParameters.get("searchItem");
   searchPackage    = (String) searchParameters.get("searchPackage");
   searchBundle     = (String) searchParameters.get("searchBundle");
   searchDynamicKit = (String) searchParameters.get("searchDynamicKit");
   startIndex       = (String) searchParameters.get("startIndex");

/***
   String debugMsg = "***DEBUG*** setCatentryParameters: " +
      "  catalogID       =" + catalogID        +
      ", storeId         =" + storeId          +
      ", languageId      =" + languageId       +
      ", name            =" + name             +
      ", nameSearchType  =" + nameSearchType   +
      ", searchScope     =" + searchScope      +
      ", displayNum      =" + displayNum       +
      ", sortBy          =" + sortBy           +
      ", startCategory   =" + startCategory    +
      ", startCategoryOp =" + startCategoryOp  +
      ", sku             =" + sku              +
      ", skuOp           =" + skuOp            +
      ", manuNum         =" + manuNum          +
      ", manuNumOp       =" + manuNumOp        +
      ", manuName        =" + manuName         +
      ", manuNameOp      =" + manuNameOp       +
      ", published       =" + published        +
      ", notPublished    =" + notPublished     +
      ", searchProduct   =" + searchProduct    +
      ", searchItem      =" + searchItem       +
      ", searchPackage   =" + searchPackage    +
      ", searchBundle    =" + searchBundle     +
      ", searchDynamicKit=" + searchDynamicKit +
      ", startIndex      =" + startIndex       ;
   System.out.println(debugMsg);
***/


   //Trim the parameters
   if (name != null) { name = name.trim(); }

   if (startCategory != null) { startCategory = startCategory.trim(); }

   if (sku != null) { sku = sku.trim(); }

   if (manuNum != null) { manuNum = manuNum.trim(); }

   if (manuName != null) { manuName = manuName.trim(); }

   try
   {
      // store ID
      if (storeId != null && !storeId.equals(""))
      {
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
      if (startIndex != null)
      {
         catEntrySearchDB.setBeginIndex(startIndex);
      }

      //catalog
      if (catalogID != null && !catalogID.equals(""))
      {
         catEntrySearchDB.setCatalogId(catalogID);
      }

      //Category Name
      if (startCategory != null && !startCategory.equals(""))
      {
         catEntrySearchDB.setCategoryTerm(startCategory);
         if (startCategoryOp.equals(SEARCH_OPERATOR_EQUAL))
         {
            catEntrySearchDB.setCategoryTermOperator(SEARCH_OPERATOR_EQUAL);
            catEntrySearchDB.setCategoryTermCaseSensitive(SEARCH_CASE_SENSITIVE_YES);
            catEntrySearchDB.setCategoryType("EXACT");
         }
         else
         {
            catEntrySearchDB.setCategoryTermOperator(SEARCH_OPERATOR_LIKE);
            catEntrySearchDB.setCategoryTermCaseSensitive(SEARCH_CASE_SENSITIVE_NO);
         }

         catEntrySearchDB.setSearchTermScope(new Integer (2));
      }

      // sku
      if (sku != null && !sku.equals(""))
      {
         catEntrySearchDB.setSku(sku);
         if (skuOp.equals(SEARCH_OPERATOR_EQUAL))
         {
            catEntrySearchDB.setSkuOperator(SEARCH_OPERATOR_EQUAL);
            catEntrySearchDB.setSkuCaseSensitive(SEARCH_CASE_SENSITIVE_YES);
         }
         else
         {
            catEntrySearchDB.setSkuOperator(SEARCH_OPERATOR_LIKE);
            catEntrySearchDB.setSkuCaseSensitive(SEARCH_CASE_SENSITIVE_NO);
         }
      }


      //name
      if (!SEARCHTYPE_SEARCH_ALL.equals(nameSearchType))
      {
         if (name != null && !name.equals(""))
         {
            catEntrySearchDB.setSearchTerm(name);

            // Search Type Selection
            if (SEARCHTYPE_MATCH_CASE_BEGINNING_WITH.equals(nameSearchType))
            {
               catEntrySearchDB.setSearchTermOperator(SEARCH_OPERATOR_LIKE);
               catEntrySearchDB.setSearchTermCaseSensitive(SEARCH_CASE_SENSITIVE_YES);
            }
            else if (SEARCHTYPE_MATCH_CASE_CONTAINING.equals(nameSearchType))
            {
               catEntrySearchDB.setSearchTermOperator(SEARCH_OPERATOR_LIKE);
               catEntrySearchDB.setSearchTermCaseSensitive(SEARCH_CASE_SENSITIVE_YES);
            }
            else if (SEARCHTYPE_IGNORE_CASE_BEGINNING_WITH.equals(nameSearchType))
            {
               catEntrySearchDB.setSearchTermOperator(SEARCH_OPERATOR_LIKE);
               catEntrySearchDB.setSearchTermCaseSensitive(SEARCH_CASE_SENSITIVE_NO);
            }
            else if (SEARCHTYPE_IGNORE_CASE_CONTAINING.equals(nameSearchType))
            {
               catEntrySearchDB.setSearchTermOperator(SEARCH_OPERATOR_LIKE);
               catEntrySearchDB.setSearchTermCaseSensitive(SEARCH_CASE_SENSITIVE_NO);
            }
            else if (SEARCHTYPE_EXACT_MATCH.equals(nameSearchType))
            {
               catEntrySearchDB.setSearchTermOperator(SEARCH_OPERATOR_EQUAL);
               catEntrySearchDB.setSearchTermCaseSensitive(SEARCH_CASE_SENSITIVE_YES);
               catEntrySearchDB.setSearchType("EXACT");
            }

            // search scope
            // By default in the catalog entry search databean,  it is set to 1,
            // which means search for name and short description.
            // Set it to a 2 means search on the name field only
            // 1 = search on name + short description
            // 2 = search on name only
            if (new Boolean (searchScope).booleanValue())
            {
               catEntrySearchDB.setSearchTermScope(new Integer (1));
            }
            else
            {
               catEntrySearchDB.setSearchTermScope(new Integer (2));
            }

         }
      }



      //manufacturer
      if (manuName != null && !manuName.equals(""))
      {
         catEntrySearchDB.setManufacturer(manuName);
         if (manuNameOp.equals(SEARCH_OPERATOR_EQUAL))
         {
            catEntrySearchDB.setManufacturerOperator(SEARCH_OPERATOR_EQUAL);
            catEntrySearchDB.setManufacturerCaseSensitive(SEARCH_CASE_SENSITIVE_YES);
         }
         else
         {
            catEntrySearchDB.setManufacturerOperator(SEARCH_OPERATOR_LIKE);
            catEntrySearchDB.setManufacturerCaseSensitive(SEARCH_CASE_SENSITIVE_NO);
         }
      }

      //manufacturer part number
      if (manuNum != null && !manuNum.equals(""))
      {
         catEntrySearchDB.setManufacturerPartNum(manuNum);
         if (manuNumOp.equals(SEARCH_OPERATOR_EQUAL))
         {
            catEntrySearchDB.setManufacturerPartNumOperator(SEARCH_OPERATOR_EQUAL);
            catEntrySearchDB.setManufacturerPartNumCaseSensitive(SEARCH_CASE_SENSITIVE_YES);
         }
         else
         {
            catEntrySearchDB.setManufacturerPartNumOperator(SEARCH_OPERATOR_LIKE);
            catEntrySearchDB.setManufacturerPartNumCaseSensitive(SEARCH_CASE_SENSITIVE_NO);
         }
      }

      //published flag
      if (new Boolean(published).booleanValue())
      {
         if (!new Boolean(notPublished).booleanValue())
         {
            catEntrySearchDB.setPublished("1");
         }
      }
      else
      {
         if (new Boolean(notPublished).booleanValue())
         {
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
         }
         else
         {
            if (sortBy.equals("Name"))
            {
               catEntrySearchDB.setOrderBy1( "CatEntDescName" );
            }
            else
            {
               catEntrySearchDB.setOrderBy1( "CatEntrySKU" );
            }
         }
      }
      else
      {
         catEntrySearchDB.setOrderBy1( "CatEntrySKU" );
      }

      //display number
      if (displayNum != null && !displayNum.equals(""))
      {
         catEntrySearchDB.setPageSize(displayNum);
         System.out.println("displayNum is set to pagesize: " + displayNum);
      }
      else
      {
         System.out.println("displayNum is NOT set to pagesize: " + displayNum);
      }

   }
   catch (Exception ex)
   {
        ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT, this.getClass().getName(), "setCatentryParameters",
               "Exception in data bean creation.");
        System.out.println("Exception: " + ex);
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
        ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT, this.getClass().getName(), "getShortDescription",
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
        ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT, this.getClass().getName(), "getLongDescription",
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
        ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT, this.getClass().getName(), "getName",
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
        ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT, this.getClass().getName(), "getAuxDescription1",
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
        ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT, this.getClass().getName(), "getAuxDescription2",
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
        ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT, this.getClass().getName(), "getThumbNail",
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
        ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT, this.getClass().getName(), "getFullImage",
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
        ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT, this.getClass().getName(), "getChildrenProducts",
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
        ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT, this.getClass().getName(), "getChildrenPackages",
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
        ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT, this.getClass().getName(), "getChildrenItems",
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
        ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT, this.getClass().getName(), "getChildren",
               "Exception in getChildren().");
   }

   return children;
}



%>

<%--
//---------------------------------------------------------------------
//- Logic Section
//---------------------------------------------------------------------
--%>


<%

try
{
   // Parameters may be encrypted. Use JSPHelper to get URL parameter
   // instead of request.getParameter().
   JSPHelper jhelper = new JSPHelper(request);

   // Declare all wiring variables
   int searchType   = 0;
   int maxThreshold = 0;
   String searchString = jhelper.getParameter("searchString");
   Vector catEntryIDList = new Vector();
   Vector catEntryNameList = new Vector();
   Vector catEntrySKUList = new Vector();


   // This indicates the following search result conditions:
   //    '0' - no match found
   //    '1' - match found within max. threshold
   //    '2' - match found exceeding max. threshold
   int searchResultCondition = 0;


   // Ready the search type
   try
      { searchType = Integer.parseInt(jhelper.getParameter("searchType")); }
   catch (NumberFormatException ne)
      { searchType = 0; } // default to search all


   // Ready the search max threshold value
   try
   {
      maxThreshold = Integer.parseInt(jhelper.getParameter("maxThreshold"));
   }
   catch (NumberFormatException ne)
   {
      maxThreshold = 100; // default to 100
      ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                    "tools/contract/SearchForCatEntry.jsp",
                    "service",
                    "Invalid maxThreshold=" + jhelper.getParameter("maxThreshold") + ", default to 100 now.");
   }



   //-------------------------------------------------------
   // Programming Logic For Performing Catalog Entry Search
   //-------------------------------------------------------

   AdvancedCatEntrySearchListDataBean catEntrySearchDB  = null;
   AdvancedCatEntrySearchListDataBean catEntrySearchDB2 = null;
   JSPHelper searchJSPHelper = new JSPHelper(request);
   String catdbSearchType = "catentry";

   // Check no search request, if true then set searchResult to '0' and skip
   if (searchType==-1)
   {
      searchResultCondition = 0; // set to '0' means no result found
      catdbSearchType = "";      // set to empty string can skip the search
   }


   ////////////////////////////
   // catentry search
   ////////////////////////////
   if (catdbSearchType.equals("catentry") ||
       catdbSearchType.equals("product")  ||
       catdbSearchType.equals("item")     ||
       catdbSearchType.equals("notItem")  ||
       catdbSearchType.equals("package"))
   {

      try
      {
         catEntrySearchDB  = new AdvancedCatEntrySearchListDataBean();
         catEntrySearchDB2 = new AdvancedCatEntrySearchListDataBean();
         HashMap seachCriterias = new HashMap();

         seachCriterias.put("name", searchString);
         seachCriterias.put("sortBy", "Name");

         // Search product items only, no bundles
         seachCriterias.put("searchItem", "true");

         // Setup the proper search type
         switch (searchType)
         {
            case 1 : seachCriterias.put("nameSearchType", SEARCHTYPE_MATCH_CASE_BEGINNING_WITH); break;
            case 2 : seachCriterias.put("nameSearchType", SEARCHTYPE_MATCH_CASE_CONTAINING);     break;
            case 3 : seachCriterias.put("nameSearchType", SEARCHTYPE_IGNORE_CASE_BEGINNING_WITH);break;
            case 4 : seachCriterias.put("nameSearchType", SEARCHTYPE_IGNORE_CASE_CONTAINING);    break;
            case 5 : seachCriterias.put("nameSearchType", SEARCHTYPE_EXACT_MATCH);               break;
            default: seachCriterias.put("nameSearchType", SEARCHTYPE_SEARCH_ALL);                break;
         }

         // displayNum restricts the number of entries return, so we need to increment
         // by '1' to enable the checking of exceeding maxThreshold in later codes.
         seachCriterias.put("displayNum", Integer.toString(maxThreshold+1));

         setCatentryParameters(catEntrySearchDB, seachCriterias);
         com.ibm.commerce.beans.DataBeanManager.activate(catEntrySearchDB, request);
         CatalogEntryDataBean[] myList = catEntrySearchDB.getResultList();

         // Search again using keyword as SKU
         seachCriterias.put("sku", searchString);
         setCatentryParameters(catEntrySearchDB2, seachCriterias);
         com.ibm.commerce.beans.DataBeanManager.activate(catEntrySearchDB2, request);
         CatalogEntryDataBean[] myList2 = catEntrySearchDB2.getResultList();


         //----------------------------
         // Process the resulting list
         //----------------------------

         int totalFoundByName = (myList==null)  ? 0 : myList.length;
         int totalFoundBySKU  = (myList2==null) ? 0 : myList2.length;
         int totalFound = totalFoundByName + totalFoundBySKU;

         if (totalFound==0)
         {
            // Cann't find any matching results
            searchResultCondition = 0;
            ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                    "tools/contract/SearchForCatEntry.jsp",
                    "service",
                    "Cannot find any matching results, myList & myList2's length=0, searchResultCondition=0.");

         }
         else
         {
            //-------------------------------------------------------------
            // Check the number of found results exceeding given threshold
            //-------------------------------------------------------------

            if (totalFound > maxThreshold)
            {
               // Search found results exceed the given max. threshold value
               searchResultCondition = 2;
               ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                             "tools/contract/SearchForCatEntry.jsp",
                             "service",
                             "Found results exceed the given max. threshold value, searchResultCondition=2, totalFoundByName="
                             + totalFoundByName + ", totalFoundBySKU=" + totalFoundBySKU);
            }
            else
            {
               searchResultCondition = 1;
               ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                             "tools/contract/SearchForCatEntry.jsp",
                             "service",
                             "totalFoundByName=" + totalFoundByName + ", totalFoundBySKU=" + totalFoundBySKU);

               //--------------------------------------------------------------------
               // Traverse the result lists and retrieve all the catentry IDs & names
               //--------------------------------------------------------------------

               for (int i=0; i<totalFoundByName; i++)
               {
                  // Prepare the ID, name, & SKU lists for later access
                  catEntryIDList.addElement(myList[i].getCatalogEntryID());
                  StringBuffer tmpName = new StringBuffer(getName(myList[i]));
                  tmpName.append(" (").append(myList[i].getPartNumber()).append(")");
                  catEntryNameList.addElement(tmpName.toString());
                  catEntrySKUList.addElement(myList[i].getPartNumber());

               } //end-for-i

               for (int i2=0; i2<totalFoundBySKU; i2++)
               {
                  // Don't add any duplicated entry
                  if (catEntryIDList.contains(myList2[i2].getCatalogEntryID()))
                  {
                     continue;
                  }

                  // Prepare the ID, name, & SKU lists for later access
                  catEntryIDList.addElement(myList2[i2].getCatalogEntryID());
                  StringBuffer tmpName = new StringBuffer(getName(myList2[i2]));
                  tmpName.append(" (").append(myList2[i2].getPartNumber()).append(")");
                  catEntryNameList.addElement(tmpName.toString());
                  catEntrySKUList.addElement(myList2[i2].getPartNumber());

               } //end-for-i2

            }//end-else (totalFound > maxThreshold)

         }//end-if-else (totalFound==0)

      }
      catch (Exception ex)
      {
         ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                       "tools/contract/SearchForCatEntry.jsp",
                       "service",
                       "Exception in AdvancedCatEntrySearchListDataBean(), exception=" + ex.toString());
         ex.printStackTrace();
      }

   }//end-if (catdbSearchType.equals("catentry"))

%>



<html>
<head>

<script>

/////////////////////////////////////////////////////////////////////////////
// Function: getSearchResultCondition
// Desc.   : Return the search result condition after the search.
// Input   : void
// Output  : Possible returning values are listed below:
//             '0' - no match found
//             '1' - match found within max. threshold
//             '2' - match found exceeding max. threshold
/////////////////////////////////////////////////////////////////////////////
function getSearchResultCondition()
{
   return <%= searchResultCondition %>;
}


/////////////////////////////////////////////////////////////////////////////
// Function: getResultIdList
// Desc.   : Return the list of catagory entry ID values from the
//           search result
// Input   : void
// Output  : an array of category entry IDs
/////////////////////////////////////////////////////////////////////////////
function getResultIdList()
{
   var resultIDs = new Array();
<%
   for (int i=0; i<catEntryIDList.size(); i++)
   {
      String id = (String) catEntryIDList.elementAt(i);
      if (id != null)
      {
         out.println("   resultIDs[" + i + "] = '"
                    + UIUtil.toJavaScript(id)
                    + "';" );
      }//end-if

   }//end-for
%>
   return resultIDs;
}


/////////////////////////////////////////////////////////////////////////////
// Function: getResultNameList
// Desc.   : Return the list of catagory entry name values from the
//           search result
// Input   : void
// Output  : an array of catagory entry names
/////////////////////////////////////////////////////////////////////////////
function getResultNameList()
{
   var resultNames = new Array();
<%
   for (int i=0; i<catEntryIDList.size(); i++)
   {
      String name = (String) catEntryNameList.elementAt(i);
      if (name != null)
      {
         out.println("   resultNames[" + i + "] = '"
                    + UIUtil.toJavaScript(name)
                    + "';" );
      }//end-if

   }//end-for
%>
   return resultNames;
}


/////////////////////////////////////////////////////////////////////////////
// Function: getResultSKUList
// Desc.   : Return the list of catagory part number (SKU) values from the
//           search result
// Input   : void
// Output  : an array of catagory entry SKU part numbers
/////////////////////////////////////////////////////////////////////////////
function getResultSKUList()
{
   var resultSKUs = new Array();
<%
   for (int i=0; i<catEntryIDList.size(); i++)
   {
      String sku = (String) catEntrySKUList.elementAt(i);
      if (sku != null)
      {
         out.println("   resultSKUs[" + i + "] = '"
                    + UIUtil.toJavaScript(sku)
                    + "';" );
      }//end-if

   }//end-for
%>
   return resultSKUs;
}

</script>




</head>
<body>
</body>
</html>
<%
}
catch (Exception e)
{
   e.printStackTrace();
}


%>

