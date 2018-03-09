<!--
//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------
-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="com.ibm.commerce.catalog.beans.CatalogEntryDataBean" %>
<%@ page import="com.ibm.commerce.tools.epromotion.databeans.RLCatEntrySearchListDataBean" %>
<%@ page import="com.ibm.commerce.search.beans.SearchConstants"%>
<%@include file="epromotionCommon.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=RLPromotionNLS.get("RLProdPromoGWP_title")%></title>
<jsp:useBean id="catBean" scope="page" class="com.ibm.commerce.catalog.beans.CatalogEntryDataBean" />
<jsp:setProperty property="*" name="catBean" />
<script>
var needValidation = false;

</script>
<%= fPromoHeader%>
<%
	CommandContext commandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	String storeId = commandContext.getStoreId().toString();
	
	// Fix defect #92448 - storepath support to find all the stores in the catalog store path
	String catalogStoreIds = storeId;
	try {
	  Integer[] relatedStores = commandContext.getStore().getStorePath(com.ibm.commerce.server.ECConstants.EC_STRELTYP_CATALOG);
	  for (int i=0; i<relatedStores.length; i++) {
	    catalogStoreIds += " " + relatedStores[i].toString();
	  }
	}
	catch (Exception e) {
	  System.out.println("Can not find related stores for gift search!");
	}
	
	String catEntryType = null;
	String catEntryId = null;

	boolean javaFlagNotFound = true;
	String discountSKU = request.getParameter("discountSKU");
	String calCodeId = request.getParameter("calCodeId");
	String gotoPanelName = request.getParameter("gotoPanelName");

	if ((discountSKU != null) && !(discountSKU.trim().equals("")) )
	{
		RLCatEntrySearchListDataBean searchBean = new RLCatEntrySearchListDataBean();
		searchBean.setCommandContext(commandContext);

		// Fix defect #92448 - search by storepath and search non-mark for delete
		searchBean.setMarkForDelete("1");
		searchBean.setMarkForDeleteOperator(SearchConstants.OPERATOR_NOT_EQUAL);
		// searchBean.setStoreId(storeId);
		searchBean.setStoreIds(catalogStoreIds);
		searchBean.setStoreIdOperator("IN");	
		
		searchBean.setSku(discountSKU);
		searchBean.setSkuCaseSensitive("yes");
		searchBean.setSkuOperator("EQUAL");


		com.ibm.commerce.beans.DataBeanManager.activate(searchBean, request);

	    int resultCount =  0;

		// Get results from the search query
		CatalogEntryDataBean catalogEntries[] = null;
		catalogEntries = searchBean.getResultList();
		if (catalogEntries != null) {
			resultCount = catalogEntries.length;
		}
		if (resultCount > 0)
		{
			// Update for #92448
			// this is the assumption that SKU in all the related stores is unique.
			catBean = catalogEntries[0];
			catBean.setCommandContext(searchBean.getCommandContext());
			javaFlagNotFound = false;
			catEntryType = catBean.getType();
			catEntryId = catBean.getCatalogEntryID();
			if (!(catEntryType.trim().equals("ItemBean")))
			{
					catEntryType = null;
					catEntryId = null;			   	 
			}						
		}
		else
		{
			javaFlagNotFound = true;
		}
	}
%>

<script src="/wcs/javascript/tools/common/Util.js">
</script>

<script language="JavaScript">

var calCodeId = null;
needValidation = <%= javaFlagNotFound%>;

function initializeState()
{
	var cType = '<%=UIUtil.toJavaScript(catEntryType)%>';
	var cId = '<%=UIUtil.toJavaScript(catEntryId)%>';
	var discountSku = '<%=UIUtil.toJavaScript(discountSKU)%>';
	var nextPanel = '<%=UIUtil.toJavaScript(gotoPanelName)%>'
		
	var rlPromo = top.getData("RLPromotion");
	if   (rlPromo != null)
	{
		calCodeId = rlPromo.<%= RLConstants.EC_CALCODE_ID %>;
        parent.put("<%= RLConstants.RLPROMOTION %>",rlPromo);

		var pgArray =top.getData("RLGWPPageArray",0);
		if(pgArray != null)
		{
			parent.pageArray = pgArray;
		}
        
	}
	else
	{	if (parent.get) {
			var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
			calCodeId = o.<%= RLConstants.EC_CALCODE_ID %>;
		}
	}



	if( calCodeId == null || trim(calCodeId) == '')
	{
		if(parent.getPanelAttribute("RLProdPromoGWPType","hasTab")=="NO")
		{
	  	    parent.setPanelAccess("RLProdPromoGWPType", true);
			parent.setPanelAttribute( "RLProdPromoGWPType", "hasTab", "YES" );
	        parent.setPanelAccess("RLProdPromoWhat", true);
	        parent.setPanelAttribute( "RLProdPromoWhat", "hasTab", "YES" );
			parent.TABS.location.reload();
			parent.setPreviousPanel("RLProdPromoWhat");
		}
	    parent.setPanelAttribute( "RLProdPromoWizardRanges", "hasTab", "NO" );
	    parent.TABS.location.reload();  			    
	}	
	else
	{
		parent.setPanelAttribute( "RLProdPromoGWPType", "hasTab", "YES" );
		parent.TABS.location.reload();			
	}
	
	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		var hasMax = false;
		if (o != null) {
			with (document.prodPromoGWPForm)
			{	
				rlProdGiftSku.value = o.<%= RLConstants.RLPROMOTION_DISCOUNT_ITEM_SKU %>;
				if(!isNaN(o.<%= RLConstants.RLPROMOTION_MAX_DISCOUNT_ITEM_QTY %>))
				rlProdGiftQty.value = o.<%= RLConstants.RLPROMOTION_MAX_DISCOUNT_ITEM_QTY %>;
				if(o.<%= RLConstants.RLPROMOTION_REQUIRED_QTY %> == '1' || o.<%= RLConstants.RLPROMOTION_REQUIRED_QTY %> == null || o.<%= RLConstants.RLPROMOTION_REQUIRED_QTY %> == "")
				{
					hasMax = false;
					maxRad[0].checked=true;
				}else
				{
					if(!isNaN(o.<%= RLConstants.RLPROMOTION_REQUIRED_QTY %>))
					{
						hasMax = true;
						maxRad[1].checked=true;
						rlMinProdPurchaseQty.value = o.<%= RLConstants.RLPROMOTION_REQUIRED_QTY %>;
					}	
				}
				checkMaxArea(hasMax);
			}
	     }		
	}
	
	if (trim(cType) != '' && trim(cId) != '')
	{
		if (parent.get)
		{
			var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
			if (o != null)
			{
				o.<%= RLConstants.RLPROMOTION_GWP_CATENTRY_ID %> = "<%=UIUtil.toJavaScript(catEntryId)%>";
			}
		}
		if (calCodeId == null || trim(calCodeId) == '')
		{
				parent.finish();
		}
		else
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
	else
	{
		if ( (!needValidation && trim(discountSku) != '') && (trim(cType) == null || trim(cType) == '' || trim(cId) == '' || trim(cId) == null))
		{
				needValidation = true;
				alertDialog("<%= UIUtil.toJavaScript(RLPromotionNLS.get("RLInvalidItemSKU").toString())%>");						
		}
		else
		if (needValidation && trim(discountSku) != '')
		{
			alertDialog("<%= UIUtil.toJavaScript(RLPromotionNLS.get("RLInvalidSKU").toString())%>");
		}
	}

	parent.setContentFrameLoaded(true);

	if (parent.get("prodQtyTooLong", false)) {
		parent.remove("prodQtyTooLong");
		reprompt(document.prodPromoGWPForm.rlProdGiftQty,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("prodQtyNumberTooLong").toString())%>");
		return;
	}
	if (parent.get("prodQtyNotNumber", false)) {
		parent.remove("prodQtyNotNumber");
		reprompt(document.prodPromoGWPForm.rlProdGiftQty,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("prodMinNotNumber").toString())%>");
		return;
	}
	if (parent.get("reqProdQtyTooLong", false)) {
		parent.remove("reqProdQtyTooLong");
		reprompt(document.prodPromoGWPForm.rlMinProdPurchaseQty,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("prodQtyNumberTooLong").toString())%>");
		return;
	}
	if (parent.get("reqProdQtyNotNumber", false)) {
		parent.remove("reqProdQtyNotNumber");
		reprompt(document.prodPromoGWPForm.rlMinProdPurchaseQty,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("prodMinNotNumber").toString())%>");
		return;
	}
	if (parent.get("noSKUEntered", false)) {
		parent.remove("noSKUEntered");
		alertDialog("<%= UIUtil.toJavaScript(RLPromotionNLS.get("SKUNotEntered").toString())%>");
		return;
	}
}

function savePanelData()
{

	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null) {
			with (document.prodPromoGWPForm)
			{
				o.<%= RLConstants.RLPROMOTION_DISCOUNT_ITEM_SKU %> = rlProdGiftSku.value;
				if (trim(rlProdGiftQty.value) != null && trim(rlProdGiftQty.value) != "")
				{

					o.<%= RLConstants.RLPROMOTION_MAX_DISCOUNT_ITEM_QTY %> = parent.strToNumber(trim(rlProdGiftQty.value),"<%=fLanguageId%>");
				}	
				else
				{
					o.<%= RLConstants.RLPROMOTION_MAX_DISCOUNT_ITEM_QTY %> = "";
				}	
				if (maxRad[1].checked)
				{
					if (trim(rlMinProdPurchaseQty.value) != null && trim(rlMinProdPurchaseQty.value) != "")
						o.<%= RLConstants.RLPROMOTION_REQUIRED_QTY %> = parent.strToNumber(trim(rlMinProdPurchaseQty.value),"<%=fLanguageId%>");
					else
						o.<%= RLConstants.RLPROMOTION_REQUIRED_QTY %> = "";
				}
				else
				{
					o.<%= RLConstants.RLPROMOTION_REQUIRED_QTY %> = 1;
				}
				if(o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> == 'ProductBean')
					o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_PRODUCTLEVELBUYXGETYFREE %>";
				else if(o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> == 'ItemBean')
					o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_ITEMLEVELBUYXGETYFREE %>";
				else if(o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> == 'PackageBean')
					o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_ITEMLEVELBUYXGETYFREE %>";
				else if(o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> == 'Category')
					o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_CATEGORYLEVELBUYXGETYFREE %>";
			}
		}
	}
	return true;
}

function validatePanelData()
{
	with (document.prodPromoGWPForm)
	{
		if(trim(rlProdGiftSku.value) == "" || trim(rlProdGiftSku.value) == null)
		{
			alertDialog("<%= UIUtil.toJavaScript(RLPromotionNLS.get("SKUNotEntered").toString())%>");
			return false;
		} 

		if (!validateQty(rlProdGiftQty)) return false;
		if (maxRad[1].checked)
		{
			if (!validateQty(rlMinProdPurchaseQty)) return false;
		}
	}
	if (needValidation) 
	{
		this.location.replace("/webapp/wcs/tools/servlet/RLProdPromoGWPView?discountSKU=" + document.prodPromoGWPForm.rlProdGiftSku.value);
		return false; // this will force to stay in the same panel
	} else {
		return true; // go to next panel
	}	

}


function validateNoteBookPanel(gotoPanelName){

	with (document.prodPromoGWPForm)
	{
		if(trim(rlProdGiftSku.value) == "" || trim(rlProdGiftSku.value) == null)
		{
			alertDialog("<%= UIUtil.toJavaScript(RLPromotionNLS.get("SKUNotEntered").toString())%>");
			return false;
		} 

		if (!validateQty(rlProdGiftQty)) return false;
		if (maxRad[1].checked)
		{
			if (!validateQty(rlMinProdPurchaseQty)) return false;
		}
	}
	if (needValidation) 
	{
		this.location.replace("/webapp/wcs/tools/servlet/RLProdPromoGWPView?discountSKU=" + document.prodPromoGWPForm.rlProdGiftSku.value + "&calCodeId=" + calCodeId + "&gotoPanelName="+ gotoPanelName);
		return false; // this will force to stay in the same panel
	} else {
		return true; // go to next panel
	}	
}


function validateQty(qtyField)
{
	if(parent.strToNumber(trim(qtyField.value),"<%=fLanguageId%>").toString().length > 14)
	{
		reprompt(qtyField,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("prodQtyNumberTooLong").toString())%>");
		return false;
	}
	else if ( !parent.isValidInteger(trim(qtyField.value), "<%=fLanguageId%>")) 
	{
		reprompt(qtyField,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("prodMinNotNumber").toString())%>");
		return false;
	}
	else if (!(eval(parent.strToNumber(trim(qtyField.value),"<%=fLanguageId%>")) >= 1))
	{
		reprompt(qtyField,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("prodMinNotNumber").toString())%>");
		return false;
	}
	return true;	
}

function checkMaxArea(hasMax)
{
	if (hasMax)
	{
		document.all["maxArea"].style.display = "block";
	}
	else
	{
		document.all["maxArea"].style.display = "none";
	}
}

function callSearch()
{
		// Added by veni
	
	var rlpagename = "RLProdPromoGWP";
	savePanelData();
	var productSKU = document.prodPromoGWPForm.rlProdGiftSku.value;
	top.saveModel(parent.model);
	top.saveData(parent.pageArray, "RLGWPPageArray");
	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null) {			
			top.saveData(o,"RLPromotion");
		}
	}
	top.put("inputsku",productSKU);
	top.put("<%= RLConstants.RLPROMOTION_PROD_SEARCH_PAGE %>",rlpagename);
	top.saveData(productSKU, "inputsku");
	top.setReturningPanel("RLProdPromoGWPType");
	top.setContent("<%= RLPromotionNLS.get("ProductSearchBrowserTitle") %>","/webapp/wcs/tools/servlet/RLSearchDialogView?ActionXMLFile=RLPromotion.RLSearchDialog",true);
}

function setValidationFlag()
{
	if(trim(document.prodPromoGWPForm.rlProdGiftSku.value) != '')
	{
		needValidation = true;
	}
}



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

<form name="prodPromoGWPForm" id="prodPromoGWPForm">

<h1><%=RLPromotionNLS.get("RLProdPromoGWP_title")%></h1>
<br />

<label for="prodGiftSkuLabel"><%=RLPromotionNLS.get("prodGiftSkuLabel")%></label><br />
<table border="0" cellpadding="0" cellspacing="0" id="WC_RLProdPromoGWP_Table_1">
<tr>
<td id="WC_RLProdPromoGWP_TableCell_1"> <input name="rlProdGiftSku" type="text" size="15" maxlength="64" onchange="setValidationFlag()" id="prodGiftSkuLabel" /> </td>
<td id="WC_RLProdPromoGWP_TableCell_2"> <button type="button" value='<%=RLPromotionNLS.get("findButton")%>' name="rlSearchProduct" class="enabled" style="width:auto;text-align:center" onclick="javascript:callSearch();">&nbsp;<%=RLPromotionNLS.get("findButton")%></button> </td>
</tr>
</table>


<p><label for="prodGiftQtyLabel"><%=RLPromotionNLS.get("prodGiftQtyLabel")%></label><br />
<input name="rlProdGiftQty" type="text" size="10" maxlength="14" id="prodGiftQtyLabel" />
 			<%=RLPromotionNLS.get("Items")%></p>

<%=RLPromotionNLS.get("prodPurchaseMinChoiceLabel")%><br />
<input type="radio" name="maxRad" onclick="javascript:checkMaxArea(false);" checked ="checked" id="None" /><label for="None"><%=RLPromotionNLS.get("None")%></label><br />
<input type="radio" name="maxRad" onclick="javascript:checkMaxArea(true);" id="MinQty" /><label for="MinQty"><%=RLPromotionNLS.get("prodPurchaseMinQtyLabel")%></label>
<div id="maxArea" style="display:none">
	<blockquote>
	<p><label for="purchaseAmount"><%=RLPromotionNLS.get("purchaseAmountOfQuantity")%></label><br />
	<input name="rlMinProdPurchaseQty" type="text" size="10" maxlength="14" id="purchaseAmount" />
				<%=RLPromotionNLS.get("Items")%>
	</p>			
	</blockquote>
</div>

</form>
</body>
</html>


