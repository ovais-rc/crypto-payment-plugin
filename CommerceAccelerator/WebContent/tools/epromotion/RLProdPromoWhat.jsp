

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ page import="com.ibm.commerce.catalog.beans.CatalogEntryDataBean" %>
<%@ page import="com.ibm.commerce.tools.epromotion.databeans.RLCatEntrySearchListDataBean" %>
<%@ page import="com.ibm.commerce.catalog.beans.CategoryDataBean" %>
<%@ page import="com.ibm.commerce.search.beans.CategorySearchListDataBean" %>
<%@ page import="com.ibm.commerce.search.beans.SearchConstants"%>
<%@ page import="com.ibm.commerce.search.rulequery.RuleQuery"%>
<%@include file="epromotionCommon.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=RLPromotionNLS.get("RLProdPromoWhat_title")%></title>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<%= fPromoHeader%>
<jsp:useBean id="catBean" scope="page" class="com.ibm.commerce.catalog.beans.CatalogEntryDataBean" />
<jsp:setProperty property="*" name="catBean" />

<script>
	var needValidation = false; // script falg to set for validation of skus in the list
	var idArray = new Array(); // holds the catentry_ids or category_ids for the sku/category list
	var badSkusArray = new Array(); // holds the bad skus entered by the user; needed to show it to the user;
	var invalidTypeSkusArray = new Array(); // holds the invalid skus, but not bad skus
	var badCgryArray = new Array(); // holds the bad categories entered by the user; needed to show it to the user;

</script>

<%
	CommandContext commandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	String storeId = commandContext.getStoreId().toString();
	String catEntryType = null; 
	String catEntryId = null;

	boolean javaFlagNotFound = true; // java flag to reload the same page if bad/invalid skus found 
	String prodSKU = UIUtil.toHTML(request.getParameter("prodSKU")); // skulist passed in the request for validation. Initially null
	
	String promoType = request.getParameter("promotype"); // Type of the merchadise
	String calCodeId = request.getParameter("calCodeId"); // calcodeId if modification

	boolean isCatGroupIdRequired = false;

	String gotoPanelName = request.getParameter("gotoPanelName"); // next panel name in modification
  	Vector badSkuList = null;
	Vector invalidTypeSkuList = null;
	Vector catEntryIdList = null;
	Vector badCategories = null;
	Vector categoryIdList = null;
	int noOfBadSkus = -1; // initially -1 : skus not validated; 0 : no bad skus after validation; >1 : has bad skus after validation
	int noOfInvalidTypeSkus = -1; // initially -1 : skus not validated; 0 : no invalid skus after validation; >1 : has invalid skus after validation
	int noOfBadCategories = -1;	
			Vector addedCatGroups = null;

	if ((prodSKU != null) && !(prodSKU.trim().equals("")) ) // First time when the page loads, doesn't requrie any validations 
	{	
		if(promoType.equals("Category"))
			{
				CategoryDataBean categories[] = null;
				CategoryDataBean category = null;
				
				StringTokenizer tokens = new StringTokenizer(prodSKU,",");
				String eachCgry = null;					
					int counter = 0;
				while( tokens.hasMoreTokens()) 
				{ 
					eachCgry = tokens.nextToken();
					eachCgry = decodeValue(eachCgry);
					// System.out.println("Category " + eachCgry.trim());

					CategorySearchListDataBean categoryList = new CategorySearchListDataBean();	
					categoryList.setCommandContext(commandContext);
					// categoryList.setStoreId(commandContext.getStoreId().toString());
					//set the store ID parameter to support store path
					Integer anStoreId = commandContext.getStoreId();
					if ( anStoreId != null){
					 	Vector vStoreIDs = new RuleQuery().findStorePaths(anStoreId.intValue());
					 	categoryList.setStoreId(((vStoreIDs.toString()).substring(1,(vStoreIDs.toString()).length())).replace(']',' ').trim() );
					 	categoryList.setStoreIdOperator( SearchConstants.OPERATOR_IN );
					}
					//set the search on categories that are not marked for delete
					categoryList.setMarkForDelete("1");
					categoryList.setMarkForDeleteOperator( SearchConstants.OPERATOR_NOT_EQUAL);
					// set the search criteria that only return the published categories:
					categoryList.setPublished("1");
					categoryList.setPublishedOperator(	SearchConstants.OPERATOR_EQUAL );
					categoryList.setLangId(commandContext.getLanguageId().toString());		
					categoryList.setUserId(commandContext.getUserId().intValue());
					categoryList.setIdentifier(eachCgry.trim());		
					categoryList.setIdentifierCaseSensitive("yes");
					categoryList.setIdentifierOperator("EQUAL");
					categoryList.setIdentifierType("EXACT");						
					categoryList.populate();

					int totalsize = Integer.parseInt(categoryList.getResultCount());
				  	categories = categoryList.getResultList();

				    if ((totalsize > 0)) // category found in the database
					{
						category = categories[0];

						// store categoryid in the vector
						if (categoryIdList == null)
						{
							categoryIdList = new Vector();
						}			
						categoryIdList.add(category.getCategoryId());
							String catIdentifer = category.getIdentifier();
							String catId = category.getCategoryId();
							if (addedCatGroups == null) {
								addedCatGroups = new Vector();
							}
							addedCatGroups.add(catIdentifer + "|" + catId);
					}
					else // if categoryname is bad
					{						
						if (badCategories == null)
						{
							badCategories = new Vector();
						}
						badCategories.add(eachCgry);
					}
				} // while eachCgry
				  //check whether any bad categories found
				if (badCategories == null) 
				{  // no bad categories 
				  	javaFlagNotFound = false; // validated; no badcategories; go to the next page
				  	noOfBadCategories = 0;
			  		for (int a=0; a<categoryIdList.size(); a++)
			  		{				  	
	%>
				<script> 
						idArray['<%=a%>']='<%=(String)categoryIdList.elementAt(a)%>';
				
</script>
	<%
					}
				 }
				 else  // bad categories found
				 if (badCategories != null)
				 { 
				 		noOfBadCategories = badCategories.size();	
				  		for (int a=0; a<noOfBadCategories; a++)
				  		{
		%>
					<script>  
						badCgryArray['<%=a%>']='<%= (String)badCategories.elementAt(a) %>'; 
					
</script>

		<%
						}
	  				  javaFlagNotFound = true; // validated;  bad categories found; load the same page
	    		  }			

			}							
			else
			{  // product/item
			// Tokeniz and validate each sku in the string prodSKU, that we have got 
			// from request (SKUList)
				RLCatEntrySearchListDataBean searchBean = new RLCatEntrySearchListDataBean();
				searchBean.setCommandContext(commandContext);
				StringTokenizer tokens = new StringTokenizer(prodSKU,",");
				String eachSKU = null;	
				
				// Fix defect #92448 - storepath support
				// get all the stores found in the catalog store path
				String catalogStoreIds = commandContext.getStoreId().toString();
				try {
				  Integer[] relatedStores = commandContext.getStore().getStorePath(com.ibm.commerce.server.ECConstants.EC_STRELTYP_CATALOG);
				  for (int i=0; i<relatedStores.length; i++) {
				    catalogStoreIds += " " + relatedStores[i].toString();
				  }
				}
				catch (Exception e) {
				  System.out.println("Can not find related stores before search!");
				}

				while( tokens.hasMoreTokens()) { 
					eachSKU = tokens.nextToken();
					eachSKU = decodeValue(eachSKU);

					// Fix defect #92448 - search by storepath and search non-mark for delete
					searchBean.setMarkForDelete("1");
					searchBean.setMarkForDeleteOperator(SearchConstants.OPERATOR_NOT_EQUAL);
					// searchBean.setStoreId(storeId);
					searchBean.setStoreIds(catalogStoreIds);
					searchBean.setStoreIdOperator("IN");					

					searchBean.setSku(eachSKU.trim());
					searchBean.setSkuCaseSensitive("yes");
					searchBean.setSkuOperator("EQUAL");

					searchBean.populate();

				    int resultCount =  0;
				    int totalSize = 0;

					// Get results from the search query
					CatalogEntryDataBean catalogEntries[] = null;
					catalogEntries = searchBean.getResultList();
					if (catalogEntries != null) {
					    totalSize = Integer.valueOf(searchBean.getResultCount()).intValue();			
						resultCount = catalogEntries.length;			
					}

					if ((resultCount > 0) && (totalSize != 0)) // sku found in the database
					{
						catBean = catalogEntries[0];
						if(promoType.trim().equalsIgnoreCase("ItemBean") || promoType.trim().equalsIgnoreCase("PackageBean") || promoType.trim().equalsIgnoreCase("DynamicKitBean"))
						{
							if (promoType.trim().equalsIgnoreCase(catBean.getType()) || catBean.getType().equalsIgnoreCase("PackageBean") || catBean.getType().equalsIgnoreCase("ItemBean") || catBean.getType().equalsIgnoreCase("DynamicKitBean"))
							{
								catEntryType = promoType;
								// store catentryid in the vector
								if (catEntryIdList == null)
								{
									catEntryIdList = new Vector();
								}

								catEntryIdList.addElement(catBean.getCatalogEntryID());
							}
							else // if sku is not bad, but invalid type
							{
								if (invalidTypeSkuList == null)
								{
									invalidTypeSkuList = new Vector();
								}
								invalidTypeSkuList.addElement(eachSKU);
							}
						}
						else
						{
							if (promoType.trim().equalsIgnoreCase(catBean.getType()))
							{
								catEntryType = promoType;
								// store catentryid in the vectors
								if (catEntryIdList == null)
								{
									catEntryIdList = new Vector();
								}

								catEntryIdList.addElement(catBean.getCatalogEntryID());
							}
							else // if sku is not bad, but invalid type
							{
								if (invalidTypeSkuList == null)
								{
									invalidTypeSkuList = new Vector();
								}
								invalidTypeSkuList.addElement(eachSKU);
							}
						}

					}
					else	 // sku not found in the database
					{
						if (badSkuList == null)
						{
							badSkuList = new Vector();
						}
						badSkuList.addElement(eachSKU);
					}

				  } // while eachSKU

				  //check whether any bad skus found
				  if ((badSkuList == null) && (invalidTypeSkuList == null))
				  {  // no bad skus 
				  	  javaFlagNotFound = false; // validated; no bad/invalid skus; go to the next page
				  	  noOfBadSkus = 0;
				  	  noOfInvalidTypeSkus = 0;
				  		for (int a=0; a<catEntryIdList.size(); a++)
				  		{

	%>
				<script> 
						idArray['<%=a%>']='<%=(String)catEntryIdList.elementAt(a)%>';
				
</script>

	<%
						}
				  }
				  else  // bad/invalid skus found
				  {
					  if (badSkuList != null)
					  { 
					  		noOfBadSkus = badSkuList.size();	
					  		for (int a=0; a<noOfBadSkus; a++)
					  		{
		%>
						<script> 
							 badSkusArray['<%=a%>']='<%= (String)badSkuList.elementAt(a) %>';
						
</script>
		<%
							}
					  }
					  if (invalidTypeSkuList != null)
					  { 
					  		noOfInvalidTypeSkus = invalidTypeSkuList.size();	
					  		for (int a=0; a<noOfInvalidTypeSkus; a++)
					  		{
		%>
						<script> 
							invalidTypeSkusArray['<%=a%>']='<%= (String)invalidTypeSkuList.elementAt(a) %>';
					    
</script>
		<%
							}
					  }
	  				  javaFlagNotFound = true; // validated;  bad/invalid skus found; load the same page
				  }
			} //if product/item
	} // end of if(prodSKU != null)
%>

<script src="/wcs/javascript/tools/common/Util.js">
</script>
<script language="JavaScript">

var calCodeId = null;
var promotype = null;
var whichDiscountType = null;
needValidation = <%= javaFlagNotFound%>;

	var noOfbadSkus = <%=noOfBadSkus%>;
	var noOfInvalidTypeSkus = <%=noOfInvalidTypeSkus%>;
	var noOfBadCategories = <%=noOfBadCategories%>;
	var merchanType = null;

function savePanelData()
{
	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null) {
			 // save the sku list into the object
				var tempSkuList = new Array();
				var tempCgryList = new Array();	
				var skuType = o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE%>;			
				if (trim(skuType ) == 'ProductBean')
				{					
					for (var i=0; i<document.whatForm.rlProdSKUList.options.length; i++) {
						if (document.whatForm.rlProdSKUList.options[i].value != null && trim(document.whatForm.rlProdSKUList.options[i].value) != '')
						{
							tempSkuList[i] = escape(document.whatForm.rlProdSKUList.options[i].value);
						}
					}		
					o.<%= RLConstants.RLPROMOTION_PRODUCT_SKU %> = tempSkuList;						
					if (calCodeId == null || trim(calCodeId) == '')
					{ 
						var ranges = o.<%= RLConstants.RLPROMOTION_RANGES %>;
						var values = o.<%= RLConstants.RLPROMOTION_VALUES %>;
						if(ranges.length > 2 || (ranges.length == 2 && eval(values[0]) != 0) )
						{
				  	    	parent.setNextBranch("RLProdPromoWizardRanges");
						}
						else if(o.<%= RLConstants.RLPRODPROMO_TYPEALIAS %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELPERCENTDISCOUNT %>")
						{
							o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_PRODUCTLEVELPERCENTDISCOUNT %>";
							parent.setNextBranch("RLProdPromoPercentType");
						}
						else if(o.<%= RLConstants.RLPRODPROMO_TYPEALIAS %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELPERITEMVALUEDISCOUNT %>")
						{
							o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_PRODUCTLEVELPERITEMVALUEDISCOUNT %>";
							parent.setNextBranch("RLProdPromoFixedType");
						}
						else if(o.<%= RLConstants.RLPRODPROMO_TYPEALIAS %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELVALUEDISCOUNT %>")
						{
							o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_PRODUCTLEVELVALUEDISCOUNT %>";
							parent.setNextBranch("RLProdPromoFixedType");
						}
						else if(o.<%= RLConstants.RLPRODPROMO_TYPEALIAS %> == "<%= RLConstants.RLPROMOTION_ITEMLEVELSAMEITEMPERCENTDISCOUNT %>")
						{
							o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_ITEMLEVELSAMEITEMPERCENTDISCOUNT %>";
							parent.setNextBranch("RLProdPromoBXGYType");
						}
						else if(o.<%= RLConstants.RLPRODPROMO_TYPEALIAS %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELBUYXGETYFREE %>")
						{
							o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_PRODUCTLEVELBUYXGETYFREE %>";
							parent.setNextBranch("RLProdPromoGWPType");
						}
					}	
				}
				else if (trim(skuType ) == 'PackageBean' || trim(skuType ) == 'ItemBean' || trim(skuType ) == 'DynamicKitBean')
				{
					for (var i=0; i<document.whatForm.rlItemSKUList.options.length; i++) {
						if (document.whatForm.rlItemSKUList.options[i].value != null && trim(document.whatForm.rlItemSKUList.options[i].value) != '')
						{
							tempSkuList[i] = escape(document.whatForm.rlItemSKUList.options[i].value);
						}
					}
					o.<%= RLConstants.RLPROMOTION_PRODUCT_SKU %> = tempSkuList;						
					if (calCodeId == null || trim(calCodeId) == '')
					{ 
						var ranges = o.<%= RLConstants.RLPROMOTION_RANGES %>;
						var values = o.<%= RLConstants.RLPROMOTION_VALUES %>;
						if(ranges.length > 2 || (ranges.length == 2 && eval(values[0]) != 0) )
						{
				  	    	parent.setNextBranch("RLProdPromoWizardRanges");
						}
						else if(o.<%= RLConstants.RLPRODPROMO_TYPEALIAS %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELPERCENTDISCOUNT %>")
						{
							o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_ITEMLEVELPERCENTDISCOUNT %>";
							parent.setNextBranch("RLProdPromoPercentType");
						}
						else if(o.<%= RLConstants.RLPRODPROMO_TYPEALIAS %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELPERITEMVALUEDISCOUNT %>")
						{
							o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_ITEMLEVELPERITEMVALUEDISCOUNT %>";
							parent.setNextBranch("RLProdPromoFixedType");
						}
						else if(o.<%= RLConstants.RLPRODPROMO_TYPEALIAS %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELVALUEDISCOUNT %>")
						{
							o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_ITEMLEVELVALUEDISCOUNT %>";
							parent.setNextBranch("RLProdPromoFixedType");
						}
						else if(o.<%= RLConstants.RLPRODPROMO_TYPEALIAS %> == "<%= RLConstants.RLPROMOTION_ITEMLEVELSAMEITEMPERCENTDISCOUNT %>")
						{
							o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_ITEMLEVELSAMEITEMPERCENTDISCOUNT %>";
							parent.setNextBranch("RLProdPromoBXGYType");
						}
						else if(o.<%= RLConstants.RLPRODPROMO_TYPEALIAS %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELBUYXGETYFREE %>")
						{
							o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_ITEMLEVELBUYXGETYFREE %>";
							parent.setNextBranch("RLProdPromoGWPType");
						}
					}
				}			
				else if (trim(skuType ) == 'Category') // save category list into object
				{					
					for (var i=0; i<document.whatForm.rlCgryList.options.length; i++) {
						if (document.whatForm.rlCgryList.options[i].value != null && trim(document.whatForm.rlCgryList.options[i].value) != '')
						{
							tempCgryList[i] = escape(document.whatForm.rlCgryList.options[i].value);
						}
					}					
					o.<%=  RLConstants.RLPROMOTION_CATGROUP_CODE  %> = tempCgryList;					
					if (calCodeId == null || trim(calCodeId) == '')
					{ 
						var ranges = o.<%= RLConstants.RLPROMOTION_RANGES %>;
						var values = o.<%= RLConstants.RLPROMOTION_VALUES %>;
						if(ranges.length > 2 || (ranges.length == 2 && eval(values[0]) != 0) )
						{
				  	    	parent.setNextBranch("RLProdPromoWizardRanges");
						}
						else if(o.<%= RLConstants.RLPRODPROMO_TYPEALIAS %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELPERCENTDISCOUNT %>")
						{
							o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_CATEGORYLEVELPERCENTDISCOUNT %>";
							parent.setNextBranch("RLProdPromoPercentType");
						}
						else if(o.<%= RLConstants.RLPRODPROMO_TYPEALIAS %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELPERITEMVALUEDISCOUNT %>")
						{
							o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_CATEGORYLEVELPERITEMVALUEDISCOUNT %>";
							parent.setNextBranch("RLProdPromoFixedType");
						}
						else if(o.<%= RLConstants.RLPRODPROMO_TYPEALIAS %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELVALUEDISCOUNT %>")
						{
							o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_CATEGORYLEVELVALUEDISCOUNT %>";
							parent.setNextBranch("RLProdPromoFixedType");
						}
						else if(o.<%= RLConstants.RLPRODPROMO_TYPEALIAS %> == "<%= RLConstants.RLPROMOTION_ITEMLEVELSAMEITEMPERCENTDISCOUNT %>")
						{
							o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_ITEMLEVELSAMEITEMPERCENTDISCOUNT %>";
							parent.setNextBranch("RLProdPromoBXGYType");
						}
						else if(o.<%= RLConstants.RLPRODPROMO_TYPEALIAS %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELBUYXGETYFREE %>")
						{
							o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_CATEGORYLEVELBUYXGETYFREE %>";
							parent.setNextBranch("RLProdPromoGWPType");
						}
					}	
				}
				
				o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> = trim(skuType );  
		}
	}
}

function validatePanelData()
{
	with (document.whatForm)
	{
			var obj = parent.get("<%= RLConstants.RLPROMOTION %>", null);
			if(obj.<%=RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'Category')
			{ 
				if(rlCgryList.options.length <=0)
				{
					alertDialog("<%= UIUtil.toJavaScript(RLPromotionNLS.get("CategoryNotEntered").toString())%>");
					return false;
				}
			}
			else
			{
				if(rlProdSKUList.options.length <= 0 && rlItemSKUList.options.length <= 0 )
				{
					alertDialog("<%= UIUtil.toJavaScript(RLPromotionNLS.get("PurchaseSKUNotEntered").toString())%>");
					return false;
				} 
			}
	}

	if (needValidation) 
	{
			var obj = parent.get("<%= RLConstants.RLPROMOTION %>", null);
			var merchandisetype = obj.<%=RLConstants.RLPROMOTION_MERCHANDISE_TYPE %>;		
			
			if(merchandisetype == "Category")
			{
				var catList = obj.<%=RLConstants.RLPROMOTION_CATGROUP_CODE %>;
				this.location.replace("/webapp/wcs/tools/servlet/RLProdPromoWhatView?prodSKU=" + encodeURIComponent(catList) + "&calCodeId=" + calCodeId +"&promotype=" + merchandisetype );
			}
			else
			{
				var skulist = obj.<%=RLConstants.RLPROMOTION_PRODUCT_SKU%>;
				this.location.replace("/webapp/wcs/tools/servlet/RLProdPromoWhatView?prodSKU=" + encodeURIComponent(skulist) + "&calCodeId=" + calCodeId +"&promotype=" + merchandisetype );
			}
			return false; // this will force to stay in the same panel
	} else {
		return true; // go to next panel
	}	
	
}

function validateNoteBookPanel(gotoPanelName){
	with (document.whatForm)
	{
			var obj = parent.get("<%= RLConstants.RLPROMOTION %>", null);
			if(obj.<%=RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'Category')
			{ 
				if(rlCgryList.options.length <=0)
				{
					alertDialog("<%= UIUtil.toJavaScript(RLPromotionNLS.get("CategoryNotEntered").toString())%>");
					return false;
				}
			}
			else
			{
				if(rlProdSKUList.options.length <= 0 && rlItemSKUList.options.length <= 0 )
				{
					alertDialog("<%= UIUtil.toJavaScript(RLPromotionNLS.get("PurchaseSKUNotEntered").toString())%>");
					return false;
				} 
			}
	}

	if (needValidation) 
	{
			var obj = parent.get("<%= RLConstants.RLPROMOTION %>", null);
			var merchandisetype = obj.<%=RLConstants.RLPROMOTION_MERCHANDISE_TYPE %>;		
						
			if(merchandisetype == "Category")
			{
				var catList = obj.<%=RLConstants.RLPROMOTION_CATGROUP_CODE %>;
				this.location.replace("/webapp/wcs/tools/servlet/RLProdPromoWhatView?prodSKU=" + encodeURIComponent(catList) + "&calCodeId=" + calCodeId +"&promotype=" + merchandisetype+"&gotoPanelName="+ gotoPanelName );
			
			}
			else
			{
				var skulist = obj.<%=RLConstants.RLPROMOTION_PRODUCT_SKU%>;
				this.location.replace("/webapp/wcs/tools/servlet/RLProdPromoWhatView?prodSKU=" + encodeURIComponent(skulist) + "&calCodeId=" + calCodeId +"&promotype=" + merchandisetype+"&gotoPanelName="+ gotoPanelName );
			}
			return false; // this will force to stay in the same panel
	} else {
		return true; // go to next panel
	}		
}

function callSearch()
{
	// Added by Veni
	var rlpagename = "RLProdPromoWhat";
	var productSKU = document.whatForm.rlSku.value;
	top.saveModel(parent.parent.model);
	top.saveData(parent.pageArray, "RLProdPromoWhatPageArray");	
	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null) {
			top.saveData(o,"RLPromotion");
		}
	}
	top.put("inputsku",productSKU);	
	top.put("<%= RLConstants.RLPROMOTION_PROD_SEARCH_PAGE %>", rlpagename);
	top.showContent("/webapp/wcs/tools/servlet/RLSearchDialogView?ActionXMLFile=RLPromotion.RLSearchDialog");
}

function setValidationFlag()
{
	if(trim(document.whatForm.rlSku.value) != '')
	{
		needValidation = true;
	}
}

function callSKUSearch(skuList)
{
	var rlpagename = "RLProdPromoWhat";
	var tempSkuList = new Array();
	for (var i=0; i<skuList.options.length; i++) {
		if (skuList.options[i].value != null && trim(skuList.options[i].value) != '')
		{
			tempSkuList[i] = skuList.options[i].value;
		}
	}
		
	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null) {	
			o.<%= RLConstants.RLPROMOTION_PRODUCT_SKU %> = tempSkuList;		
			o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> = o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %>;
			top.saveData(o,"RLPromotion");	// save object on top.(Required in Search Dialog)		
		}
	}
	
	top.saveData(tempSkuList,"RLSkuList");	
	top.put("RLSkuList", tempSkuList);		
	top.saveModel(parent.model);
	top.saveData(parent.pageArray, "RLProdPromoWhatPageArray");	
	top.put("<%= RLConstants.RLPROMOTION_PROD_SEARCH_PAGE %>", rlpagename);
	top.put("fromSearchPage",true);	 
	
	top.setReturningPanel("RLProdPromoWhat");
	top.setContent("<%= RLPromotionNLS.get("ProductSearchBrowserTitle") %>", "/webapp/wcs/tools/servlet/RLSearchDialogView?ActionXMLFile=RLPromotion.RLSearchDialog",true);
}

function callCategorySearch(cgryList)
{
	var rlpagename = "RLProdPromoWhat";
	var tempCgryList = new Array();
	for (var i=0; i<cgryList.options.length; i++) {
		if (cgryList.options[i].value != null && trim(cgryList.options[i].value) != '')
		{
			tempCgryList[i] = cgryList.options[i].value;
		}
	}
	
	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null) {			
			o.<%=  RLConstants.RLPROMOTION_CATGROUP_CODE  %> = tempCgryList; //Category List stored here		
			o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> =  o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %>;
          	top.saveData(o,"RLPromotion");			
		}
	}
	top.saveData(tempCgryList,"RLCategoryList");
	top.put("RLCategoryList", tempCgryList);	
	top.saveModel(parent.model);	
	top.saveData(parent.pageArray, "RLProdPromoWhatPageArray");
	top.put("<%= RLConstants.RLPROMOTION_PROD_SEARCH_PAGE %>", rlpagename);
	top.put("fromSearchPage",true);		
	
	top.setReturningPanel("RLProdPromoWhat");
	top.setContent("<%= RLPromotionNLS.get("RLCgrySearchTitle") %>", "/webapp/wcs/tools/servlet/DialogView?XMLFile=RLPromotion.RLCategorySearchDialog",true);
}

function callBrowseDialog()
{	
	// set browsing tree parameters
	var bp = new Object();
	bp.selectionType = "CE";
	bp.locationType = "allType";
	bp.catalogId = "";
	bp.categoryId = "";
	
	var tempCgryList = new Array();
	for (var i=0; i<document.whatForm.rlCgryList.options.length; i++) {
		if (document.whatForm.rlCgryList.options[i].value != null && trim(document.whatForm.rlCgryList.options[i].value) != '')
		{
			tempCgryList[i] = escape(document.whatForm.rlCgryList.options[i].value);
		}
	}
	
	if (parent.get) {
	
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null) {
			o.<%=  RLConstants.RLPROMOTION_CATGROUP_CODE  %> = tempCgryList; //Category List stored here		
			o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> =  o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %>;
           	top.saveData(o,"RLPromotion");			
		}
	}
	
	top.saveData(tempCgryList,"RLCategoryList");
	// save the panel
	savePanelData();
	// set flag to record that we are going on a product browser
	top.saveData("product", "whenAddFind");
	top.saveData(bp, "browseParameters");
	top.saveData(true, "allowMultiple");	
	top.saveModel(parent.model);
	// save the states of the tabs
	top.saveData(parent.pageArray, "initiativePageArray");
	top.put("fromSearchPage",true);
	top.setReturningPanel("RLProdPromoWhat");
  
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=RLPromotion.RLCategoryBrowseDialog";
	top.setContent("<%= RLPromotionNLS.get("CategoryBrowsePanelTitle") %>", url, true);	
}

function addToList(listItem, inputList) {
	needValidation = true; // set needValidation flag to true each time new sku is added
	var inputItem = trim(listItem.value);
	if (validateInputListItem(trim(listItem.value), inputList)) {
		var nextOptionIndex = inputList.options.length;
		inputList.options[nextOptionIndex] = new Option(
			inputItem, // name
			inputItem, // value
			false,    // defaultSelected
			false);   // selected
		listItem.value = '';		
	}
}

// validate the list item before adding to the list
function validateInputListItem (listItem, inList) {
	var obj = parent.get("<%= RLConstants.RLPROMOTION %>", null);
	var skuType = null;
	if(obj != null)
	{
		skuType = obj.<%=RLConstants.RLPROMOTION_MERCHANDISE_TYPE %>;
	}
	if (isEmpty(listItem)) {
		if(skuType =='Category'){
			alertDialog('<%=UIUtil.toJavaScript(RLPromotionNLS.get("RLEmptyCategory").toString())%>');		
		}
		else{
			alertDialog('<%=UIUtil.toJavaScript(RLPromotionNLS.get("RLEmptySKU").toString())%>');
		}
		
		return false;
	}
	// check for duplicate sku
	for (var i=0; i<inList.length; i++) {
		if (listItem == inList.options[i].value)
		{
			if(skuType =='Category'){
				alertDialog('<%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDuplicateCategory").toString())%>');
			}
			else{
				alertDialog('<%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDuplicateSKU").toString())%>');
			}
			return false;
		}
	}
	return true;
}

// This function removes the list item from the inList
function removeFromList (inList) {
	var obj = parent.get("<%= RLConstants.RLPROMOTION %>", null);
	var skuType = null;
	if(obj != null)
	{
		skuType = obj.<%=RLConstants.RLPROMOTION_MERCHANDISE_TYPE %>;
	}
	var emptySelection = true;
	for (var i=inList.options.length-1; i>=0; i--) {
		if (inList.options[i].selected && inList.options[i].value != "") {
			removeFromCatGroupIdArray(inList.options[i].value);
			inList.options[i] = null; // remove the selection from the list
			emptySelection = false;
		}
	}
	if (emptySelection) {
		if(skuType =='Category'){
			alertDialog('<%=UIUtil.toJavaScript(RLPromotionNLS.get("RLNoCategorySelected").toString())%>');
		}
		else{ // if item/product/category
			alertDialog('<%=UIUtil.toJavaScript(RLPromotionNLS.get("RLNoSKUSelected").toString())%>');
		}
	}
}



function showProductSelectFields()
{
	var obj = parent.get("<%= RLConstants.RLPROMOTION %>", null);
	if(obj != null)
	{
		obj.<%=RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> = 'ProductBean';
	}
	top.put("<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE%>", "ProductBean");
	hideitemSelectFields();
	hideCategorySelectFields();
	document.all["productSelect"].style.display = "block";
}

function showCategorySelectFields()
{
	var obj = parent.get("<%= RLConstants.RLPROMOTION %>", null);
	if(obj != null)
	{
		obj.<%=RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> = 'Category';
	}
	top.put("<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE%>", "Category");	
	hideitemSelectFields();
	hideProductSelectFields();
	document.all["categorySelect"].style.display = "block";
}

function hideProductSelectFields()
{
	document.all["productSelect"].style.display = "none";
}

function hideCategorySelectFields()
{
	document.all["categorySelect"].style.display = "none";
}

function showItemSelectFields()
{
	var obj = parent.get("<%= RLConstants.RLPROMOTION %>", null);
	if(obj != null)
	{
		obj.<%=RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> = 'ItemBean';
	}
	
	top.put("<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE%>", "ItemBean");	
	hideCategorySelectFields();
	hideProductSelectFields();
	document.all["itemSelect"].style.display = "block";
}

function hideitemSelectFields()
{
	document.all["itemSelect"].style.display = "none";
}


function disableButton(b) {
	if (defined(b)) {
		b.disabled=true;
		b.className='disabled';
		b.id='disabled';
	}
}

function enableButton(b) {
	if (defined(b)) {
		b.disabled=false;
		b.className='enabled';
		b.id='enabled';
	}
}	

function getCatGroupIdArray() {
	var addedCatGpsList = new Array();
	<% if (addedCatGroups != null) { 
		for (int i = 0;i < addedCatGroups.size(); i++) { 
		%>
			addedCatGpsList['<%= i %>'] = '<%= addedCatGroups.get(i) %>';
	<% } }%>
	var cgceMapList = top.getData("RLCatGrpCatEntMapList");
	var catGpIdArray = new Array();
	if (cgceMapList != null) {
		for (var i=0; i<cgceMapList.length; i++) {
			var sep1Index = cgceMapList[i].indexOf("|");
			var sep2Index = cgceMapList[i].substring(sep1Index+1, cgceMapList[i].length).indexOf("|") + sep1Index + 1;
			var catGpId = trim(cgceMapList[i].substring(sep1Index+1, cgceMapList[i].length));
			catGpIdArray[catGpIdArray.length] = catGpId;
		}
	}
	for (var i=0; i<addedCatGpsList.length; i++) {
		var sep1Index = addedCatGpsList[i].indexOf("|");
		var sep2Index = addedCatGpsList[i].substring(sep1Index+1, addedCatGpsList[i].length).indexOf("|") + sep1Index + 1;
		var catGpName = trim(addedCatGpsList[i].substring(0, sep1Index));
		var catGpId = trim(addedCatGpsList[i].substring(sep1Index+1, addedCatGpsList[i].length));
		if (cgceMapList == null || cgceMapList == undefined) {
			catGpIdArray[catGpIdArray.length] = catGpId;
		} else {
			var found = false;
			for (var j=0; j<cgceMapList.length; j++) {
				var sep1TempIndex = cgceMapList[j].indexOf("|");
				var tempCatGpName = trim(cgceMapList[j].substring(0, sep1TempIndex));
				if (tempCatGpName == catGpName) {
					found = true;
					break;
				}
			}
			if (found == false) {
				catGpIdArray[catGpIdArray.length] = catGpId;
			}	
		}
	}	
	return catGpIdArray;
}

function removeFromCatGroupIdArray(catGpNameToRemove) {
	var cgceMapList = top.getData("RLCatGrpCatEntMapList");
	var tempArray = new Array();
	if (cgceMapList != null) {
		for (var i=0; i<cgceMapList.length; i++) {
			var sep1Index = cgceMapList[i].indexOf("|");
			var sep2Index = cgceMapList[i].substring(sep1Index+1, cgceMapList[i].length).indexOf("|") + sep1Index + 1;
			var catGpName = trim(cgceMapList[i].substring(0, sep1Index));
			if (catGpName != catGpNameToRemove) {
				tempArray[tempArray.length] = cgceMapList[i];
			}
		}
	}
	top.saveData(tempArray,"RLCatGrpCatEntMapList");	
}

function initializeState()
{
		var fromSearchPage = top.get("fromSearchPage");
		// If the user has returned from search page., get RLPromotion object 
		// from top and put it in parent
		if(fromSearchPage != 'undefined' && fromSearchPage == true)
		{
			top.put("fromSearchPage", false);
			var rlPromo = top.getData("RLPromotion");
						
			parent.put("<%= RLConstants.RLPROMOTION %>", rlPromo);			
		}
		
		var obj = parent.get("<%= RLConstants.RLPROMOTION %>", null); // Get the object from parent
		if (obj!= null) 
		{ 
			calCodeId = obj.<%= RLConstants.EC_CALCODE_ID %>;
			merchanType = obj.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %>;						
		}
		else
		{			
			merchanType = top.get("<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE%>"); 
		}

		if(parent.getPanelAttribute( "RLProdPromoWizardRanges", "hasTab") == "NO")
		{
	   		parent.setPanelAttribute( "RLProdPromoWhat", "hasTab", "YES" );
			parent.TABS.location.reload();
		}	
				
		if ((merchanType != null) && (merchanType != '') )
		{
			if(merchanType =='Category')
			{
				var prodSku = '<%=UIUtil.toJavaScript(prodSKU)%>';
				var nextPanel = '<%=UIUtil.toJavaScript(gotoPanelName)%>'
				var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
				var catList = null;	
				if (o != null)
				{					
					calCodeId = o.<%= RLConstants.EC_CALCODE_ID %>;	
					catList = o.<%= RLConstants.RLPROMOTION_CATGROUP_CODE %>;
					promotype = o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %>; 
					top.put("<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE%>", promotype); 						
				}
				else  // if creation, get the saved values from top
				{ 					
					catList = top.getData("RLCategoryList",null);
					promotype = top.get("<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE%>");						
				}
				// for modification initialize noOfbadCategories to 0 first time the page is loaded
				// keep a flag isFirstTime to track this.
				var isFirstTime = false;
				if(((calCodeId != null) && trim(calCodeId) != '') && (noOfBadCategories ==-1) &&(needValidation))
				{				  
					noOfBadCategories =0;				
					isFirstTime = true;
				}
				
				// This condition is entered when
				// 1. Loads first time for modification
				// 2. After validation no bad categories found
				if (noOfBadCategories == 0)
				{ 		
				  	if (parent.get)
				  	{    
						var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
						if (o != null)
						{
							var tempCatlist = o.<%= RLConstants.RLPROMOTION_CATGROUP_CODE %>;
					   		var tempCatType = o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %>; 
					  	 	top.put("<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE%>", tempCatType); 
					   		if(tempCatlist.length > 0)
							{
								document.whatForm.merchandise[2].checked=true;
								document.whatForm.merchandise[2].focus();
								document.all["categorySelect"].style.display = "block";
								document.whatForm.merchandise[0].disabled=true;
								document.whatForm.merchandise[1].disabled=true;
							
								for (var i=0; i<tempCatlist.length; i++) {
									var nextOptionIndex = document.whatForm.rlCgryList.options.length;
									if (tempCatlist[i] != 'undefined')								
									{ 									
										document.whatForm.rlCgryList.options[nextOptionIndex] = new Option(
											unescape(tempCatlist[i]), // name
											unescape(tempCatlist[i]), // value
											false,    // defaultSelected
											false);   // selected
									}
								} // end for
								o.<%= RLConstants.RLPROMOTION_CATGROUP_CODE %> = document.whatForm.rlCgryList;							
						   		document.whatForm.rlCgryName.value = "";					   	
						 	} // end tempcatlist.length > 0
						 	else
						 	{
						 		document.whatForm.merchandise[2].checked=true;
								document.whatForm.merchandise[2].focus();
								document.all["categorySelect"].style.display = "block";
								document.whatForm.merchandise[0].disabled=true;
								document.whatForm.merchandise[1].disabled=true;
							}						 
						
						   if (<%=isCatGroupIdRequired%>)
						   {
							o.<%= RLConstants.RLPROMOTION_CATGROUP_ID %> = getCatGroupIdArray();
						    }else{
								
								o.<%= RLConstants.RLPROMOTION_CATGROUP_ID %> = idArray;
	    							
							}
						
							if (calCodeId == null || trim(calCodeId) == '') // go to when page in the wizard during creation
							{ 
		     					o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> = top.get('<%=RLConstants.RLPROMOTION_MERCHANDISE_TYPE%>'); 				
								parent.gotoNextPanel();
							} 
							else // if modifcation, next panel/finish
							{	
								if (!isFirstTime)  // if loaded first time for modification, need not have to go to the next panel
								{	
									if (nextPanel == null || trim(nextPanel) == '' || nextPanel == 'undefined')
									{
										parent.finish();
									}
									else
									{
										parent.gotoPanel(nextPanel);
									}
								}
								else
								{									
									parent.gotoPanel(nextPanel);					
								}
							}					
						} //o!=null
				  	}  //parent.get		
			  	}     // if noOfBadCategories ==0
				else
				{  // found some bad category entries. Remove them and alert them on to the page and load the same page.				
					if (needValidation && trim(prodSku) != '' && (noOfBadCategories >0)  ) 				
					{	
						alertDialog('<p>' + '<%=UIUtil.toJavaScript(RLPromotionNLS.get("RLInvalidCgryMsg").toString())%>' + '</p> <p>&nbsp;&nbsp;' + badCgryArray +'</p>');			
					}	
					if(catList != null && catList.length > 0) 
					{ 		
						document.whatForm.merchandise[2].checked=true;
						document.whatForm.merchandise[2].focus();
						document.all["categorySelect"].style.display = "block";
						if (calCodeId != null && trim(calCodeId) != '' )
						{
							document.whatForm.merchandise[0].disabled=true;
							document.whatForm.merchandise[1].disabled=true;
						}
						
						for (var i=0; i<catList.length; i++) {
							var nextOptionIndex = document.whatForm.rlCgryList.options.length;
							var createOption = true;
							for (var j=0; j<badCgryArray.length; j++) {	
								if (catList[i] != 'undefined') { 													
									if(catList[i] == badCgryArray[j]){
										createOption = false;
										break;
									}									
								}											
							}
							if (createOption)
							{
								document.whatForm.rlCgryList.options[nextOptionIndex] = new Option(
									unescape(catList[i]), // name
									unescape(catList[i]), // value
									false,    // defaultSelected
									false);   // selected	
							}
										
						} // end of for
						
					} // end of if catList.length
					else
					{						
						document.whatForm.merchandise[2].checked=true;
						document.whatForm.merchandise[2].focus();
						document.all["categorySelect"].style.display = "block";
					}
					
				   	document.whatForm.rlCgryName.value = "";		
				} // if badCategories <> 0	   		
			}		
			else  // if Merchandise Type is ItemBean/ProductBean
			{
				var prodSku = '<%=UIUtil.toJavaScript(prodSKU)%>';
				var nextPanel = '<%=UIUtil.toJavaScript(gotoPanelName)%>'
				var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
				var skuList = null;
				var skuType = null;
				if (o != null)
				{
					calCodeId = o.<%= RLConstants.EC_CALCODE_ID %>;	
					skuList = o.<%= RLConstants.RLPROMOTION_PRODUCT_SKU %>;
					promotype = o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %>; 
					skuType = o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %>; 
					top.put("<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE%>", skuType); 		
				}								
				else  // if creation, get the saved values from top
				{
					skuList = top.getData("RLSkuList",null);
					skuType = top.get("<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE%>");		      
				}
				// for modification initialize noOfbadSkus & noOfInvalidTypeSkus to 0 first time the page is loaded
				// keep a flag isFirstTime to track this.
				var isFirstTime = false;
				if(((calCodeId != null) && trim(calCodeId) != '') && (noOfbadSkus ==-1) &&(noOfInvalidTypeSkus ==-1) &&(needValidation))
				{
					noOfbadSkus =0;
					noOfInvalidTypeSkus =0;
					isFirstTime = true;
				}
				// This condition is entered when
				// 1. Loads first time for modification
				// 2. After validation no bad/invalid skus found
				if ((noOfbadSkus == 0) && (noOfInvalidTypeSkus == 0)) 
				{ 		    	
				  if (parent.get)
				   {    
					var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
					if (o != null)
					{   
						var tempskulist = o.<%= RLConstants.RLPROMOTION_PRODUCT_SKU %>;
						var tempskuType = o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %>; 
					   	top.put("<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE%>", tempskuType); 
					   	if(tempskulist.length > 0)
						{
							if (trim(tempskuType) == 'ProductBean')
							{
								document.whatForm.merchandise[0].checked=true;
								document.whatForm.merchandise[0].focus();
								document.all["productSelect"].style.display = "block";
								document.whatForm.merchandise[1].disabled=true;
								document.whatForm.merchandise[2].disabled=true;
							
									for (var i=0; i<tempskulist.length; i++) {
									var nextOptionIndex = document.whatForm.rlProdSKUList.options.length;
									if (tempskulist[i] != 'undefined')								
									{ 									
											document.whatForm.rlProdSKUList.options[nextOptionIndex] = new Option(
											unescape(tempskulist[i]), // name
											unescape(tempskulist[i]), // value
											false,    // defaultSelected
											false);   // selected
									}
								}
								o.<%= RLConstants.RLPROMOTION_PRODUCT_SKU %> = document.whatForm.rlProdSKUList;							
							}
							else if (trim(tempskuType) == 'ItemBean' || trim(tempskuType) == 'PackageBean' || trim(tempskuType) == 'DynamicKitBean')
							{
								document.whatForm.merchandise[1].checked=true;
								document.whatForm.merchandise[1].focus();
								document.all["itemSelect"].style.display = "block";
								document.whatForm.merchandise[0].disabled=true;
								document.whatForm.merchandise[2].disabled=true;
	
								for (var i=0; i<tempskulist.length; i++) {
									var nextOptionIndex = document.whatForm.rlItemSKUList.options.length;
									if (tempskulist[i] != 'undefined')
									{ 
											document.whatForm.rlItemSKUList.options[nextOptionIndex] = new Option(									
											unescape(tempskulist[i]), // name
											unescape(tempskulist[i]), // value
											false,    // defaultSelected
											false);   // selected
									}
								}
								o.<%= RLConstants.RLPROMOTION_PRODUCT_SKU %> = document.whatForm.rlItemSKUList;								
							}
						
						   	document.whatForm.rlProdSku.value = "";
						   	document.whatForm.rlItemSku.value = "";
						}
						else
						{
							if (trim(tempskuType) == 'ProductBean'){
							    document.whatForm.merchandise[0].checked=true;
								document.whatForm.merchandise[0].focus();
								document.all["productSelect"].style.display = "block";
								document.whatForm.merchandise[1].disabled=true;
								document.whatForm.merchandise[2].disabled=true;
							}
							else if (trim(tempskuType) == 'ItemBean' || trim(tempskuType) == 'PackageBean' || trim(tempskuType) == 'DynamicKitBean'){
								document.whatForm.merchandise[1].checked=true;
								document.whatForm.merchandise[1].focus();
								document.all["itemSelect"].style.display = "block";
								document.whatForm.merchandise[0].disabled=true;
								document.whatForm.merchandise[2].disabled=true;
	                        }
							
						}
						
						o.<%= RLConstants.RLPROMOTION_CATENTRY_ID %> = idArray;
						
						if (calCodeId == null || trim(calCodeId) == '') // go to when page in the wizard during creation
						{ 
		     				o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> = top.get('<%=RLConstants.RLPROMOTION_MERCHANDISE_TYPE%>');				
							o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> = top.get('<%=RLConstants.RLPROMOTION_MERCHANDISE_TYPE%>');				
							parent.put("<%= RLConstants.RLPROMOTION %>",o);
							parent.gotoNextPanel();
						} 
						else // if modifcation, next panel/finish
						{	if (!isFirstTime)  // if loaded first time for modification, need not have to go to the next panel
							{				
								if (nextPanel == null || trim(nextPanel) == '' || nextPanel == 'undefined')
								{
									parent.finish();
								}
								else
								{
									parent.gotoPanel(nextPanel);					
								}
							}
						}
					}
				}		
			
			  }
			 else // if (noOfBadSkus == 0 && noOfInvalidSkus == 0)
			 {  // found some bad/invalid skus. Remove them and alert them on to the page and load the same page.
			
				if (needValidation && trim(prodSku) != '' && (noOfbadSkus >0 || noOfInvalidTypeSkus >0)  ) 
				{				
					if(	noOfbadSkus > 0 && noOfInvalidTypeSkus > 0)
					{
						alertDialog('<p>' + '<%=UIUtil.toJavaScript(RLPromotionNLS.get("RLInvalidSKUMsg").toString())%>' + '</p> <p>&nbsp;&nbsp;'+invalidTypeSkusArray+ "," + badSkusArray +'</p>');
					}
					else if(noOfbadSkus > 0)
					{		
						alertDialog('<p>' + '<%=UIUtil.toJavaScript(RLPromotionNLS.get("RLBadSkuMsg").toString())%>' + ' </p> <p>&nbsp;&nbsp;'+badSkusArray+'</p>');
					}
					else if(noOfInvalidTypeSkus > 0)
					{		
						alertDialog('<p>' + '<%=UIUtil.toJavaScript(RLPromotionNLS.get("RLInvalidSKUMsg").toString())%>' + '</p> <p>&nbsp;&nbsp;'+invalidTypeSkusArray+'</p>');
					}
					
				}	
				    if(skuList != null && skuList.length > 0) 
					{ 	
						if (trim(skuType) == 'ProductBean')
						{												
								document.whatForm.merchandise[0].checked=true;
								document.whatForm.merchandise[0].focus();
								document.all["productSelect"].style.display = "block";
								if (calCodeId != null && trim(calCodeId) != '' )
								{
									document.whatForm.merchandise[1].disabled=true;
									document.whatForm.merchandise[2].disabled=true;
								}
						
							for (var i=0; i<skuList.length; i++) {
								var nextOptionIndex = document.whatForm.rlProdSKUList.options.length;
								var createOption = true;
								for (var j=0; j<badSkusArray.length; j++) {	
									if (skuList[i] != 'undefined') { 													
										if(skuList[i] == badSkusArray[j]){
											createOption = false;
											break;
										}									
									}											
								}
								if(createOption == true){
									for(var k=0; k<invalidTypeSkusArray.length; k++) {
										if (skuList[i] != 'undefined') { 													
											if(skuList[i] == invalidTypeSkusArray[k]){
												createOption = false;
												break;
											}									
										}	
									}
									if (createOption)
									{
										document.whatForm.rlProdSKUList.options[nextOptionIndex] = new Option(
											unescape(skuList[i]), // name
											unescape(skuList[i]), // value
											false,    // defaultSelected
											false);   // selected	
									}
								}
								
							}
						}
						else if (trim(skuType) == 'ItemBean' || trim(skuType) == 'PackageBean' || trim(skuType) == 'DynamicKitBean')
						{
							document.whatForm.merchandise[1].checked=true;
							document.whatForm.merchandise[1].focus();
							document.all["itemSelect"].style.display = "block";
							if (calCodeId != null && trim(calCodeId) != '' )
							{
								document.whatForm.merchandise[0].disabled=true;
								document.whatForm.merchandise[2].disabled=true;
							}
						
							for (var i=0; i<skuList.length; i++) {
								var nextOptionIndex = document.whatForm.rlItemSKUList.options.length;
								var createOption = true;
								for (var j=0; j<badSkusArray.length; j++) {	
									if (skuList[i] != 'undefined') { 													
										if(skuList[i] == badSkusArray[j]){
											createOption = false;
								    		break;
										}									
									}	
								}
								if(createOption == true){
									for(var k=0; k<invalidTypeSkusArray.length; k++) {
										if (skuList[i] != 'undefined') { 													
											if(skuList[i] == invalidTypeSkusArray[k]){
												createOption = false;
												break;
											}									
										}	
									}
									if (createOption)
									{
										document.whatForm.rlItemSKUList.options[nextOptionIndex] = new Option(
											unescape(skuList[i]), // name
											unescape(skuList[i]), // value
											false,    // defaultSelected
											false);   // selected	
									}
								}									
							 }
						} // end of else if itembean
					} // end of if sku.length
					else
					{
						if (trim(skuType) == 'ProductBean')
						{
							document.whatForm.merchandise[0].checked=true;
							document.whatForm.merchandise[0].focus();
							showProductSelectFields();			
						}
						else if(trim(skuType) == 'ItemBean' || trim(skuType) == 'PackageBean' || trim(skuType) == 'DynamicKitBean')
						{
							document.whatForm.merchandise[1].checked=true;
							document.whatForm.merchandise[1].focus();
							showItemSelectFields();			
						}
						
					}
				   	document.whatForm.rlProdSku.value = "";
				   	document.whatForm.rlItemSku.value = "";					
			}
		  } // end of itemBean/ProductBean
		} // (merchantType not null)		     
		else // In creation when the page is loaded first time, select Product promotion radio button by default
		{
			document.whatForm.merchandise[0].checked=true;
			document.whatForm.merchandise[0].focus();
			showProductSelectFields();					
		}
	
	 	
	if (parent.get) 
	{
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null) 
		{ 	
			calCodeId = o.<%= RLConstants.EC_CALCODE_ID %>;
			whichDiscountType = o.<%= RLConstants.RLPROMOTION_TYPE %>;
			if( calCodeId != null && calCodeId != '')
			{
				if( whichDiscountType != null || whichDiscountType != '')
				{
			        var pgArray = top.getData("RLProdPromoWhatPageArray");
			        if(pgArray != null)
			        {
			        	parent.pageArray = pgArray;
			        }

				    if (whichDiscountType == "<%= RLConstants.RLPROMOTION_ITEMLEVELPERCENTDISCOUNT %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELPERCENTDISCOUNT %>" || whichDiscountType == "<%= RLConstants.RLPROMOTION_CATEGORYLEVELPERCENTDISCOUNT %>"
				    	|| whichDiscountType == "<%= RLConstants.RLPROMOTION_ITEMLEVELPERITEMVALUEDISCOUNT %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELPERITEMVALUEDISCOUNT %>" || whichDiscountType == "<%=  RLConstants.RLPROMOTION_CATEGORYLEVELPERITEMVALUEDISCOUNT  %>"
				    	|| whichDiscountType == "<%= RLConstants.RLPROMOTION_ITEMLEVELVALUEDISCOUNT %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELVALUEDISCOUNT %>" || whichDiscountType == "<%=  RLConstants.RLPROMOTION_CATEGORYLEVELVALUEDISCOUNT %>"){
			      		parent.setPanelAttribute( "RLProdPromoWizardRanges", "hasTab", "YES" );
		                parent.TABS.location.reload();
				    }else if (whichDiscountType == "<%= RLConstants.RLPROMOTION_ITEMLEVELSAMEITEMPERCENTDISCOUNT %>" || whichDiscountType == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELSAMEITEMPERCENTDISCOUNT %>" || whichDiscountType == "<%=  RLConstants.RLPROMOTION_CATEGORYLEVELSAMEITEMPERCENTDISCOUNT %>"){
			      		parent.setPanelAttribute( "RLProdPromoBXGYType", "hasTab", "YES" );
		                parent.TABS.location.reload();
				    }else if (whichDiscountType == "<%= RLConstants.RLPROMOTION_ITEMLEVELBUYXGETYFREE %>" || o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELBUYXGETYFREE %>" || whichDiscountType == "<%=  RLConstants.RLPROMOTION_CATEGORYLEVELBUYXGETYFREE %>"){
			      		parent.setPanelAttribute( "RLProdPromoGWPType", "hasTab", "YES" );
		                parent.TABS.location.reload();
				    }
				}  //end of if whichDiscountType.			
			}  // end of calcode!=null
		
		}	// end if o!=null
	} // end if parent.get

	parent.setContentFrameLoaded(true);
   
	if (parent.get("CategoryNotEntered", false)) {	
		parent.remove("CategoryNotEntered");
		alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("CategoryNotEntered").toString())%>');
		return;
	}
	if (parent.get("PurchaseSKUNotEntered", false)) {
		parent.remove("PurchaseSKUNotEntered");
		alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("PurchaseSKUNotEntered").toString())%>');
		return;
	}
		
	if (parent.get("cannotBeAProduct", false)) {
		parent.remove("cannotBeAProduct");
		alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("cannotBeAProduct").toString())%>');
		return;
	}

} // end Initialize state
	
	


</script>
<meta name="GENERATOR" content="IBM WebSphere Studio" />
</head>

<body class="content" onload="initializeState();">
<!-- ============================================================================
The sample Templates, HTML and Macros are furnished by IBM as simple
examples to provide an illustration. These examples have not been
thoroughly tested under all conditions.  IBM, therefore, cannot guarantee reliability, 
serviceability or function of these programs. All programs contained herein are provided 
to you "AS IS".

The sample Templates, HTML and Macros may include the names of individuals,
companies, brands and products in order to illustrate them as completely as
possible.  All of these are names are ficticious and any similarity to the names
and addresses used by actual persons or business enterprises is entirely coincidental.

Licensed Materials - Property of IBM

5697-D24

(c)  Copyright  IBM Corp.  1997, 1999.      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or 
disclosure restricted by GSA ADP Schedule Contract with IBM Corp

=============================================================================== -->

<form name="whatForm" id="whatForm">

<h1><%=RLPromotionNLS.get("RLProdPromoWhat_title")%></h1>
<br />

<p>
   <input type="radio" name="merchandise" value="true" onclick="javascript:showProductSelectFields()" id="WC_RLProdPromoWhat_FormInput_merchandise_In_whatForm_1" />
<label for="WC_RLProdPromoWhat_FormInput_merchandise_In_whatForm_1"><%=RLPromotionNLS.get("RLProdSelectMsg")%> </label>
</p>
<div id="productSelect" style="display:none;margin-left: 22">
   <table id="WC_RLProdPromoWhat_Table_1">
    <tr>
		<td id="WC_RLProdPromoWhat_TableCell_1"> <b> <label for="rlProdSku"><%=RLPromotionNLS.get("RLProdLabel")%></label> </b> </td><td id="WC_RLProdPromoWhat_TableCell_2">
    </td></tr><tr>
    	<td valign="top" id="WC_RLProdPromoWhat_TableCell_3"><input name="rlProdSku" style="width:345px" maxlength="64" onchange="enableButton(document.whatForm.r1AddProdSKU)" id="rlProdSku" /></td>
    	<td valign="top" id="WC_RLProdPromoWhat_TableCell_4"><button value='<%=RLPromotionNLS.get("RLAddButton")%>' name="rlAddProdSKU" onclick="javascript:addToList(document.whatForm.rlProdSku, document.whatForm.rlProdSKUList)" class="general" style="text-align: left; padding-left: 5px;">&nbsp;<%=RLPromotionNLS.get("RLAddButton")%></button></td>
	</tr><tr>
    	<td colspan="2" id="WC_RLProdPromoWhat_TableCell_6"><b> <label for="rlProdSKUList"><%=RLPromotionNLS.get("RLSkuListLabel")%></label> </b></td>
    </tr><tr>
    	<td id="WC_RLProdPromoWhat_TableCell_7"><select name="rlProdSKUList" style="width:350px; font-family: arial"  multiple ="multiple" size="8" id="rlProdSKUList"> </select></td>
    	<td valign="top" id="WC_RLProdPromoWhat_TableCell_8">
    		<button value='<%=RLPromotionNLS.get("findButton")%>' name="rlSearchProduct" onclick="javascript:callSKUSearch(document.whatForm.rlProdSKUList)" class="general" style="text-align: left; padding-left: 5px;">&nbsp;<%=RLPromotionNLS.get("findButton")%></button><br />
    		<button value='<%=RLPromotionNLS.get("RLRemoveButton")%>' name="rlRemoveProdSKUs" onclick="javascript:removeFromList(document.whatForm.rlProdSKUList)" class="general" style="text-align: left; padding-left: 5px;">&nbsp;<%=RLPromotionNLS.get("RLRemoveButton")%></button>
    	</td>
	</tr>
   </table>
</div>

<p>
   <input type="radio" name="merchandise" value="true" onclick="javascript:showItemSelectFields()" id="WC_RLProdPromoWhat_FormInput_merchandise_In_whatForm_2" />
<label for="WC_RLProdPromoWhat_FormInput_merchandise_In_whatForm_2"><%=RLPromotionNLS.get("RLItemSelectMsg")%> </label>
</p>
<div id="itemSelect" style="display:none;margin-left: 22">
   <table id="WC_RLProdPromoWhat_Table_2">
    <tr>
		<td id="WC_RLProdPromoWhat_TableCell_9"> <b> <label for="rlItemSku"><%=RLPromotionNLS.get("RLItemLabel")%></label> </b> </td>
		<td id="WC_RLProdPromoWhat_TableCell_10"></td>
    </tr>
    <tr>
        <td valign="top" id="WC_RLProdPromoWhat_TableCell_11"><input name="rlItemSku" style="width:345px" maxlength="64" onchange="enableButton(document.whatForm.r1AddItemSKU)" id="rlItemSku" /></td>
		<td valign="top" id="WC_RLProdPromoWhat_TableCell_12"><button value='<%=RLPromotionNLS.get("RLAddButton")%>' name="rlAddProdSKU" onclick="javascript:addToList(document.whatForm.rlItemSku, document.whatForm.rlItemSKUList)" class="general" style="text-align: left; padding-left: 5px;">&nbsp;<%=RLPromotionNLS.get("RLAddButton")%></button>		</td>
    </tr>
    <tr>
    	<td colspan="2" id="WC_RLProdPromoWhat_TableCell_14"> <b> <label for="rlItemSKUList"><%=RLPromotionNLS.get("RLSkuListLabel")%></label> </b> </td>
    </tr><tr>
    	<td id="WC_RLProdPromoWhat_TableCell_15"><select name="rlItemSKUList" style="width:350px; font-family: arial"  multiple ="multiple" size="8" id="rlItemSKUList"></select></td>
    	<td valign="top" id="WC_RLProdPromoWhat_TableCell_16">
			<button value='<%=RLPromotionNLS.get("findButton")%>' name="rlSearchItem" onclick="javascript:callSKUSearch(document.whatForm.rlItemSKUList)" class="general" style="text-align: left; padding-left: 5px;">&nbsp;<%=RLPromotionNLS.get("findButton")%></button><br />
	    	<button value='<%=RLPromotionNLS.get("RLRemoveButton")%>' name="rlRemoveItemSKUs" onclick="javascript:removeFromList(document.whatForm.rlItemSKUList)" class="general" style="text-align: left; padding-left: 5px;">&nbsp;<%=RLPromotionNLS.get("RLRemoveButton")%></button>
    	</td>
    </tr>
   </table>
</div>

<p>
	<input type="radio" name="merchandise" value="true" onclick="javascript:showCategorySelectFields()" id="WC_RLProdPromoWhat_FormInput_merchandise_In_whatForm_3" /> <label for="WC_RLProdPromoWhat_FormInput_merchandise_In_whatForm_3"><%=RLPromotionNLS.get("RLCategorySelectMsg")%> </label>

</p>
<div id="categorySelect" style="display:none;margin-left: 22" >
   <table id="WC_RLProdPromoWhat_Table_3">
    <tr>
		<td id="WC_RLProdPromoWhat_TableCell_17"> <b> <label for="rlCgryName"><%=RLPromotionNLS.get("RLCategoryLabel")%></label> </b> </td>
		<td id="WC_RLProdPromoWhat_TableCell_18"></td>
    </tr>
    <tr>
    	<td valign="top" id="WC_RLProdPromoWhat_TableCell_19"><input name="rlCgryName" style="width:345px" maxlength="254" onchange="enableButton(document.whatForm.r1AddCgry)" id="rlCgryName" /></td>
   		<td valign="top" id="WC_RLProdPromoWhat_TableCell_20"><button value='<%=RLPromotionNLS.get("RLAddButton")%>' name="rlAddCgry" onclick="javascript:addToList(document.whatForm.rlCgryName, document.whatForm.rlCgryList)" class="general" style="text-align: left; padding-left: 5px;">&nbsp;<%=RLPromotionNLS.get("RLAddButton")%></button></td>
	</tr><tr>
		<td colspan="2" id="WC_RLProdPromoWhat_TableCell_23"> <b> <label for="rlCgryList"><%=RLPromotionNLS.get("RLCategoryListLabel")%></label> </b> </td>
    </tr><tr>
    	<td id="WC_RLProdPromoWhat_TableCell_24"><select name="rlCgryList" style="width:350px; font-family: arial" multiple ="multiple" size="8" id="rlCgryList"></select></td>
    	<td valign="top" id="WC_RLProdPromoWhat_TableCell_21">
    		<button value='<%=RLPromotionNLS.get("browseButton")%>' name="rlBrowseCgry" onclick="javascript:callBrowseDialog()" class="general" style="text-align: left; padding-left: 5px;">&nbsp;<%=RLPromotionNLS.get("browseButton")%></button><br />
       		<button value='<%=RLPromotionNLS.get("findButton")%>' name="rlSearchCgry" onclick="javascript:callCategorySearch(document.whatForm.rlCgryList)" class="general" style="text-align: left; padding-left: 5px;">&nbsp;<%=RLPromotionNLS.get("findButton")%></button><br />
    		<button value='<%=RLPromotionNLS.get("RLRemoveButton")%>' name="rlRemoveCgry" onclick="javascript:removeFromList(document.whatForm.rlCgryList)" class="general" style="text-align: left; padding-left: 5px;">&nbsp;<%=RLPromotionNLS.get("RLRemoveButton")%></button>
    	</td>
    </tr>
   </table>
</div>

</form>
</body>
</html>