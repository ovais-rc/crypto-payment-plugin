<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>


<%@ page language="java" %>

<% // All JSPs require the first 4 packages for getResource.jsp which is used for multi language support %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>

<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.tools.common.ui.*" %>
<%@page import="com.ibm.commerce.tools.command.*" %>
<%@page import="com.ibm.commerce.server.*" %>


<%@ page import="java.text.MessageFormat" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.price.utils.*" %>

<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.common.beans.*" %>

<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.search.beans.*"%>
<%@ page import="com.ibm.commerce.catalog.beans.CatalogEntryDataBean" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@ include file="epromotionCommon.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%= RLPromotionNLS.get("ProductSearchResultBrowserTitle") %></title>
<%= fPromoHeader%>
<script>
top.mccmain.mcccontent.isInsideWizard = function() {
       return true;
}

function onLoad () {
	parent.loadFrames();
	parent.parent.setContentFrameLoaded(true);
}

</script>
<%
	CommandContext commandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	// Fix defect #59434 - storepath support
	//String storeId = commandContext.getStoreId().toString();
	// get all the stores found in the catalog store path
	String catalogStoreIds = commandContext.getStoreId().toString();
	try {
		 Integer[] relatedStores = commandContext.getStore().getStorePath(com.ibm.commerce.server.ECConstants.EC_STRELTYP_CATALOG);
		for (int i=0; i<relatedStores.length; i++) {
			catalogStoreIds += " " + relatedStores[i].toString();
		}
	}
	catch (Exception e) {
	}

	// Get all search specific URL parameters

	String name = request.getParameter("searchTermName");
	String nameType = request.getParameter("nameType");
	String nameCaseSensitive = request.getParameter("nameCaseSensitive");
	String nameOperator = request.getParameter("nameOperator");

	String shortDesc = request.getParameter("searchTermShortDesc");
	String shortDescType = request.getParameter("shortDescType");
	String shortDescCaseSensitive = request.getParameter("shortDescCaseSensitive");
	String shortDescOperator = request.getParameter("shortDescOperator");

	String fromPage = request.getParameter("pagename");
	String calCodeId = request.getParameter("calCodeId");
	String promoType = request.getParameter("promotype");
	// System.out.println("promotype : " + promoType);
	String beIndex = request.getParameter("startindex");
    String paSize = request.getParameter("pageSize");

    int beginIndex = 0;
    int pageSize = 0;
	if (beIndex != null && beIndex.length() != 0)
	{
		beginIndex = Integer.parseInt(beIndex);
	}
	if (paSize != null && paSize.length() != 0)
	{
		pageSize = Integer.parseInt(paSize);
	}
%>

<jsp:useBean id="catBean" scope="page" class="com.ibm.commerce.catalog.beans.CatalogEntryDataBean" />
<jsp:setProperty property="*" name="catBean" />

<jsp:useBean id="catEntSearchListBean" scope="page" class="com.ibm.commerce.tools.epromotion.databeans.RLCatEntrySearchListDataBean" />
	<jsp:setProperty property="*" name="catEntSearchListBean" />

<meta name="GENERATOR" content="IBM WebSphere Studio" />


<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js">
</script>
<script language="JavaScript" src="/wcs/javascript/tools/common/dynamiclist.js">
</script>


</head>
<body onload="onLoad();" class="content_list">

<%
	catEntSearchListBean.setCommandContext(commandContext);
	try {
					// Execute the search bean
	   	     if (fromPage.equals("RLProdPromoWhat"))
	   	     {
				   if (promoType.equalsIgnoreCase("ProductBean"))
				   {
								catEntSearchListBean.setIsItem(false);
								catEntSearchListBean.setIsPackage(false);
								catEntSearchListBean.setIsProduct(true);
								catEntSearchListBean.setIsDynamicKit(false);
								catEntSearchListBean.setIsBundle(false);
				   }  else
				   if (promoType.equalsIgnoreCase("ItemBean") || promoType.equalsIgnoreCase("PackageBean") || promoType.equalsIgnoreCase("DynamicKitBean"))
				   {
								catEntSearchListBean.setIsItem(true);
								catEntSearchListBean.setIsPackage(true); // don't care whether item or package. consider it as item
								catEntSearchListBean.setIsProduct(false);
								catEntSearchListBean.setIsDynamicKit(true);
								catEntSearchListBean.setIsBundle(false);
			       }
	   	}
	   	else if ( fromPage.equals("RLProdPromoGWP") || fromPage.equals("RLDiscountGWP") )
		   {
				catEntSearchListBean.setIsItem(true);
				catEntSearchListBean.setIsPackage(false);
				catEntSearchListBean.setIsProduct(false);
				catEntSearchListBean.setIsDynamicKit(false);
				catEntSearchListBean.setIsBundle(false);
		   }


		// Fix defect #59434 - storepath support
		//catEntSearchListBean.setStoreId(storeId);
		catEntSearchListBean.setStoreIds(catalogStoreIds);
		catEntSearchListBean.setStoreIdOperator("IN");

		catEntSearchListBean.setName(name);
		catEntSearchListBean.setNameCaseSensitive(nameCaseSensitive);
		catEntSearchListBean.setNameTermOperator(nameOperator);
		catEntSearchListBean.setNameType(nameType);

		catEntSearchListBean.setShortDesc(shortDesc);
		catEntSearchListBean.setShortDescCaseSensitive(shortDescCaseSensitive);
		catEntSearchListBean.setShortDescOperator(shortDescOperator);
		catEntSearchListBean.setShortDescType(shortDescType);

		// Fix defect #92448 - search non-mark for delete
		catEntSearchListBean.setMarkForDelete("1");
		catEntSearchListBean.setMarkForDeleteOperator(SearchConstants.OPERATOR_NOT_EQUAL);

		// n189836 - support unbounded search
		catEntSearchListBean.setAcceleratorFlag(true);

		catEntSearchListBean.setBeginIndex(String.valueOf(beginIndex));
   		com.ibm.commerce.beans.DataBeanManager.activate(catEntSearchListBean, request);

    	int resultCount =  0;
    	int totalsize = 0;
		// Get results from the search query
		CatalogEntryDataBean catalogEntries[] = null;
		catalogEntries = catEntSearchListBean.getResultList();
		if (catalogEntries != null) {
			resultCount = catalogEntries.length;
		    totalsize = Integer.valueOf(catEntSearchListBean.getResultCount()).intValue();
		}

	    int listSize = Integer.parseInt(request.getParameter("listsize"));
  	    int rowselect = 1;
	    int totalpage = totalsize/listSize;
        int endIndex = beginIndex + listSize;

%>
	<table id="WC_RLProductSearchResult_Table_1">
 	<tr>
 	<td id="WC_RLProductSearchResult_TableCell_1"><%= RLPromotionNLS.get("ProductSearchResultBrowserTitle")%>
 	</td>
 	</tr>
 	</table>

<script>

function myRefreshButtons()
{
	var fromPage = '<%=UIUtil.toJavaScript(fromPage)%>';
	var checked = parent.getChecked();
	if(checked.length > 1 && (fromPage == "RLProdPromoGWP" || fromPage == "RLDiscountGWP"))
	{
		if(defined(parent.buttons.buttonForm.ButtonAddButton)){
			parent.buttons.buttonForm.ButtonAddButton.disabled=false;
			parent.buttons.buttonForm.ButtonAddButton.className='disabled';
			parent.buttons.buttonForm.ButtonAddButton.id='disabled';
		}
	}

}


function getResultsSize () {
	return <%= totalsize %>;
}

function addAction()
{
		if(parent.buttons.buttonForm.ButtonAddButton.className =='disabled' && parent.buttons.buttonForm.ButtonAddButton.id == 'disabled'){
			return;
		}
		var rlpage = top.get("<%= RLConstants.RLPROMOTION_PROD_SEARCH_PAGE %>",null);
		if (rlpage == "RLProdPromoWhat")
		{
			top.help['MC.discount.searchResult2.Help'] = top.help['MC.discount.searchResult2Wht.Help'];
		}
		else if (rlpage == "RLProdPromoGWP" || rlpage == "RLDiscountGWP")
		{
			top.help['MC.discount.searchResult2.Help'] = top.help['MC.discount.searchResult2Gwp.Help'];
		}
		var duplicateSkuList = new Array();
		var checked = parent.getChecked().toString();
		var params = checked.split(',');

		var partNumber = new Array();
		var catEntryID = new Array();
		var catEntryType = null;
		var counter = 0;

		for (var a=0; a<params.length; a++)
		{
			var eachRow = params[a].split(';');
			partNumber[counter] = eachRow[0];
			catEntryType = eachRow[1];
			catEntryID[counter] = eachRow[2];
			counter = counter+1;
		}
		var rlpagename=top.get("<%= RLConstants.RLPROMOTION_PROD_SEARCH_PAGE %>", null);
		var calCodeId = null;
		if (rlpagename == "RLProdPromoWhat")
		{
			var rlPromo = top.getData("RLPromotion", 1);
			//alert("rlPromo " + rlPromo);
			var skulist = new Array();
			if (rlPromo != null)
			{
				var skuListToAdd = rlPromo.<%= RLConstants.RLPROMOTION_PRODUCT_SKU %>;
				//alert("In If skuListToAdd " + skuListToAdd);
				var skuListIndex = skuListToAdd.length;
				if ( skuListIndex > 0)
				{
					var counter = 0;
					for (var a=0; a<partNumber.length; a++)
					{
						var isDuplicateSku = false;
						for (var b=0; b<skuListIndex; b++)
						{
							if (skuListToAdd[b] != null)
							{
								if (trim(partNumber[a]) == trim(skuListToAdd[b]))
								{
									duplicateSkuList[counter] = partNumber[a];
									counter++;
									isDuplicateSku = true;
									break;
								}
							}
						}
						if (!isDuplicateSku)
						{
								skuListToAdd[skuListIndex] = partNumber[a];
								skuListIndex++;
						}
					}
					rlPromo.<%= RLConstants.RLPROMOTION_PRODUCT_SKU %> = skuListToAdd;
				} // end of if(skuListIndex > 0)
				else
				{
					rlPromo.<%= RLConstants.RLPROMOTION_PRODUCT_SKU %> = partNumber;
					top.sendBackData(partNumber, "RLSkuList");
				}

				rlPromo.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> = catEntryType;

				var idListToAdd = rlPromo.<%= RLConstants.RLPROMOTION_CATENTRY_ID %>;
				var idListIndex = idListToAdd.length;

				if ( idListIndex > 0)
				{
					for (var a=0; a<catEntryID.length; a++)
					{
						var idDuplicate = false;
						for (var b=0; b<idListIndex; b++)
						{
							if (trim(catEntryID[a]) == trim(idListToAdd[b]))
							{
								idDuplicate = true;
								break;
							}
						}
						if (!idDuplicate)
						{
							idListToAdd[idListIndex] = catEntryID[a];
							idListIndex++;
						}
					}
					rlPromo.<%= RLConstants.RLPROMOTION_CATENTRY_ID %> = idListToAdd;
				}
				else
				{
					rlPromo.<%= RLConstants.RLPROMOTION_CATENTRY_ID %> = catEntryID;
				}
				//top.saveData(rlPromo,"RLPromotion");
				top.sendBackData(rlPromo,"RLPromotion");
				calCodeId = rlPromo.<%= RLConstants.EC_CALCODE_ID %>;
			} // end of if (rlPromo != null)
			else
			{
				top.sendBackData(partNumber,"RLSkuList");
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
		else
		if (rlpagename == "RLProdPromoGWP")
		{
				var calCodeId = null;
				var rlPromo = top.getData("RLPromotion", 1); //raj
				if (rlPromo != null)
				{
					rlPromo.<%= RLConstants.RLPROMOTION_DISCOUNT_ITEM_SKU %> = partNumber[0];
					rlPromo.<%= RLConstants.RLPROMOTION_GWP_CATENTRY_ID %> = catEntryID[0];
					calCodeId = rlPromo.<%= RLConstants.EC_CALCODE_ID %>;
					top.sendBackData(rlPromo,"RLPromotion");
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
		else
		if (rlpagename == "RLDiscountGWP")
		{
				var calCodeId = null;
				var rlPromo = top.getData("RLPromotion", 1);
				if (rlPromo != null)
				{
					rlPromo.<%= RLConstants.RLPROMOTION_DISCOUNT_ITEM_SKU %> =  partNumber[0];
					rlPromo.<%= RLConstants.RLPROMOTION_GWP_CATENTRY_ID %> = catEntryID[0];
					calCodeId = rlPromo.<%= RLConstants.EC_CALCODE_ID %>;
					top.sendBackData(rlPromo,"RLPromotion");
				}

				if( (calCodeId == null) || (calCodeId == '') )
				{
					top.goBack();
				}else
				{
					top.goBack();
				}
		}
}


</script>

<%= comm.addControlPanel("RLPromotion.RLSearchResult", totalpage, totalsize, fLocale) %>
<form name="productSearchForm" id="productSearchForm">
<%= comm.startDlistTable((String)RLPromotionNLS.get("ProductSearchSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true, "parent.selectDeselectAll();") %>
<%= comm.addDlistColumnHeading((String)RLPromotionNLS.get("productFindSkuSearchString"),"none", false) %>
<%= comm.addDlistColumnHeading((String)RLPromotionNLS.get("productFindName"),"none", false) %>
<%= comm.addDlistColumnHeading((String)RLPromotionNLS.get("productFindShortDesc"),"none", false) %>
<%= comm.addDlistColumnHeading((String)RLPromotionNLS.get("ProductFindPrice"),"none", false) %>
<%= comm.addDlistColumnHeading((String)RLPromotionNLS.get("ProductFindType"),"none", false) %>
<%= comm.endDlistRow() %>
<%
    endIndex = beginIndex + listSize;
	if (endIndex > resultCount) {
		endIndex = resultCount;
	}

	for (int a=0; a<endIndex; a++)
	{
		catBean = catalogEntries[a];
		catBean.setCommandContext(catEntSearchListBean.getCommandContext());
%>

<%= comm.startDlistRow(rowselect) %>

<%= comm.addDlistCheck(encodeValue(catBean.getPartNumber())+";"+catBean.getType()+";"+catBean.getCatalogEntryID(), "parent.setChecked();myRefreshButtons()") %>
<%= comm.addDlistColumn(UIUtil.toHTML(catBean.getPartNumber()), "none") %>
<% if (catBean.getDescription().getName() != null)
{
%>
<%= comm.addDlistColumn(UIUtil.toHTML(catBean.getDescription().getName()), "none") %>
<%
}
else
{
%>
<%= comm.addDlistColumn("", "none") %>
<%
}
if (catBean.getDescription().getShortDescription() != null)
{
%>
<%= comm.addDlistColumn(UIUtil.toHTML(catBean.getDescription().getShortDescription()), "none") %>
<%
}
else
{
%>
<%= comm.addDlistColumn("", "none") %>
<%
}
if (catBean.isCalculatedContractPriced()) {
  if (catBean.getCalculatedContractPrice().getAmount().toString() != null){
%>
  <%= comm.addDlistColumn(UIUtil.toHTML(catBean.getCalculatedContractPrice().getPrimaryFormattedPrice().getFormattedValue()), "none") %>
<%
  }
} else if (catBean.isListPriced()) {
  if (catBean.getListPrice().getAmount().toString() != null){
%>
  <%= comm.addDlistColumn(UIUtil.toHTML(catBean.getListPrice().getPrimaryFormattedPrice().getFormattedValue()), "none") %>
<%
  }
} else {
%>
  <%= comm.addDlistColumn("", "none") %>
<%
}
if (catBean.getType().toString() != null)
{
	String beanType = catBean.getType().toString();
	if (beanType.equals("ProductBean"))
	{
		beanType = "rlProductBean";
	}
	else
	if (beanType.equals("ItemBean"))
	{
			beanType = "rlItemBean";
	}
	else
	if (beanType.equals("PackageBean") || beanType.equals("DynamicKitBean"))
	{
		beanType = "rlPackageBean";
	}


%>
<%= comm.addDlistColumn(UIUtil.toHTML(RLPromotionNLS.get(beanType).toString()), "none") %>
<%
}
%>
<%= comm.endDlistRow() %>
<%
	if (rowselect == 1) {
		rowselect = 2;
	}
	else {
		rowselect = 1;
	}
} //for
%>
<%= comm.endDlistTable() %>

<%
if(totalsize == 0)
{
    if (fromPage.equals("RLProdPromoWhat"))
	{
		if ( (calCodeId == null) || (calCodeId.equals("")) )
		{
%>
			<p></p><p>
			<%= RLPromotionNLS.get("ProductSearchEmpty") %>
<%
		}
		else
		{
%>
			</p><p></p><p>
			<%= RLPromotionNLS.get("ProductSearchEmpty") %>
			</p><p></p><p>
			<%= RLPromotionNLS.get("ProductSearchModifyEmpty") %>
<%
		}
	 }
	 else if ( (fromPage.equals("RLProdPromoGWP")) || (fromPage.equals("RLDiscountGWP")) )
	 {
%>
		</p><p></p><p>
		<%= RLPromotionNLS.get("ProductSearchEmpty") %>
		</p><p></p><p>
		<%= RLPromotionNLS.get("ProductSearchItemEmpty") %>
<%
      }
}

%>


</p></form>
<%

}
catch(Exception e) {
com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);}
%>
<script>
<!--
parent.afterLoads();
parent.setResultssize(getResultsSize());
//-->

</script>

</body>

</html>
