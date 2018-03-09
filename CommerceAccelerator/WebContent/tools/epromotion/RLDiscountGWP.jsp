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
<title><%=RLPromotionNLS.get("RLDiscountGWP_title")%></title>
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
	  System.out.println("Can not find related stores for search!");
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
var fCurr = null;
needValidation = <%= javaFlagNotFound%>;

var rlPromo = top.getData("RLPromotion",0);
if   (rlPromo != null)
{
	fCurr = rlPromo.<%= RLConstants.RLPROMOTION_CURRENCY %>;
}
else
{
	fCurr=parent.getCurrency();
}

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
   		var pgArray =top.getData("RLDiscountGWPPageArray",0);
		if(pgArray != null)
		{
			parent.pageArray = pgArray;
		}       
	}
	else
	{	
		if (parent.get)
		 {
			var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
			calCodeId = o.<%= RLConstants.EC_CALCODE_ID %>;
 		}
	}

	if( calCodeId == null || calCodeId == '')
	{
		if(parent.getPanelAttribute("RLDiscountGWPType","hasTab")=="NO")
		{
		    parent.setPanelAccess("RLDiscountGWPType", true);
			parent.setPanelAttribute( "RLDiscountGWPType", "hasTab", "YES" );
		    parent.setPanelAttribute( "RLDiscountWizardRanges", "hasTab", "NO" );
			parent.TABS.location.reload();
			parent.setPreviousPanel("RLPromotionProperties");
		}
		else
		{
		    parent.setPanelAttribute( "RLDiscountWizardRanges", "hasTab", "NO" );
			parent.TABS.location.reload();
		}	
	}
	else
	{
		parent.setPanelAttribute( "RLDiscountGWPType", "hasTab", "YES" );
		parent.TABS.location.reload();
	}
	
	
	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		var hasMin = false;
		if (o != null) {
			with (document.discountGWPForm)
			{	
				var discountSKU = o.<%= RLConstants.RLPROMOTION_DISCOUNT_ITEM_SKU %>;
				if(discountSKU != null && trim(discountSKU)!= '')
				{
					rlProdGiftSku.value = discountSKU;								
				}
				var ranges = o.<%= RLConstants.RLPROMOTION_RANGES %>;
				var values = o.<%= RLConstants.RLPROMOTION_VALUES %>;
				if (ranges.length == 1)
				{
					var minQualify = ranges[0];
					if(eval(minQualify) == 0)
					{
						minRad[0].checked = true;
						checkMinArea(false);
					}
					else if ((minQualify != null) && (minQualify != "") && !isNaN(minQualify))
					{
						minRad[1].checked = true;
						minQual.value=parent.numberToCurrency(minQualify,fCurr,"<%=fLanguageId%>");
						checkMinArea(true);
					}
					if (values[0] != null && values[0] != "" && !isNaN(values[0]))
					{
						rlProdGiftQty.value=values[0];
					}	
				}

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

	if (parent.get("prodQtyNumberTooLong", false)) {
		parent.remove("prodQtyNumberTooLong");
		reprompt(document.discountGWPForm.rlProdGiftQty,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("prodQtyNumberTooLong").toString())%>");
		return;
	}
	if (parent.get("prodMinNotNumber", false)) {
		parent.remove("prodMinNotNumber");
		reprompt(document.discountGWPForm.rlProdGiftQty,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("prodMinNotNumber").toString())%>");
		return;
	}
	if (parent.get("minCurrencyTooLong", false)) {
		parent.remove("minCurrencyTooLong");
		reprompt(document.discountGWPForm.minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("currencyTooLong").toString())%>");
		return;
	}
	if (parent.get("minCurrencyInvalid", false)) {
		parent.remove("minCurrencyInvalid");
		reprompt(document.discountGWPForm.minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("minQualPurchaseAmountInvalid").toString())%>");
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
	var ranges=new Array();
	var values=new Array();	
	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null) {
			with (document.discountGWPForm)
			{
				o.<%= RLConstants.RLPROMOTION_DISCOUNT_ITEM_SKU %> = rlProdGiftSku.value;
				var freebieQuantity = "";
				if (trim(rlProdGiftQty.value) != null && trim(rlProdGiftQty.value)!= "")
					freebieQuantity = parent.strToNumber(trim(rlProdGiftQty.value),"<%=fLanguageId%>");

				if (minRad[1].checked)
				{
					parent.put("hasMinQualGWP",true);
					var minPurchase = "";
					if (trim(minQual.value) != null && trim(minQual.value) != "")
						minPurchase=parent.currencyToNumber(trim(minQual.value), fCurr,"<%=fLanguageId%>");
					ranges[0]=minPurchase;
					values[0]=freebieQuantity;
				}
				else
				{
					ranges[0]=0;
					values[0]=freebieQuantity;
				}
				o.<%= RLConstants.RLPROMOTION_RANGES %> = ranges;
				o.<%= RLConstants.RLPROMOTION_VALUES %> = values;
				o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_ORDERLEVELFREEGIFT %>";
			}
		}
	}
	return true;
}

function validatePanelData()
{
	with (document.discountGWPForm)
	{
		if(trim(rlProdGiftSku.value) == "" || trim(rlProdGiftSku.value) == null)
		{
			alertDialog("<%= UIUtil.toJavaScript(RLPromotionNLS.get("SKUNotEntered").toString())%>");
			return false;
		} 
		if (!validateQty(rlProdGiftQty)) return false;
		if (minRad[1].checked)
		{
			if (parent.currencyToNumber(trim(minQual.value), fCurr,"<%=fLanguageId%>").toString().length > 14)
			{
				reprompt(minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("currencyTooLong").toString())%>");
				return false;
			}
			else if ( !parent.isValidCurrency(trim(minQual.value), fCurr, "<%=fLanguageId%>"))
			{
				reprompt(minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("minQualPurchaseAmountInvalid").toString())%>");
				return false;
			}
		}
	}
	if (needValidation) 
	{
		this.location.replace("/webapp/wcs/tools/servlet/RLDiscountGWPView?discountSKU=" + document.discountGWPForm.rlProdGiftSku.value);
		return false; // this will force to stay in the same panel
	} else {
		return true; // go to next panel
	}	
}


function validateNoteBookPanel(gotoPanelName){
	with (document.discountGWPForm)
	{
		if(trim(rlProdGiftSku.value) == "" || trim(rlProdGiftSku.value) == null)
		{
			alertDialog("<%= UIUtil.toJavaScript(RLPromotionNLS.get("SKUNotEntered").toString())%>");
			return false;
		} 
		if (!validateQty(rlProdGiftQty)) return false;
		if (minRad[1].checked)
		{
			if (parent.currencyToNumber(trim(minQual.value), fCurr,"<%=fLanguageId%>").toString().length > 14)
			{
				reprompt(minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("currencyTooLong").toString())%>");
				return false;
			}
			else if ( !parent.isValidCurrency(trim(minQual.value), fCurr, "<%=fLanguageId%>"))
			{
				reprompt(minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("minQualPurchaseAmountInvalid").toString())%>");
				return false;
			}
		}
	}
	if (needValidation) 
	{
		this.location.replace("/webapp/wcs/tools/servlet/RLDiscountGWPView?discountSKU=" + document.discountGWPForm.rlProdGiftSku.value + "&calCodeId=" + calCodeId + "&gotoPanelName="+ gotoPanelName);
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

function checkMinArea(hasMin)
{
	if (hasMin)
	{
		document.all["minArea"].style.display = "block";
	}
	else
	{
		document.all["minArea"].style.display = "none";
	}
}

function callSearch()
{
	// Added by veni
	var rlpagename = "RLDiscountGWP";
	savePanelData();
	var productSKU = document.discountGWPForm.rlProdGiftSku.value;
	top.saveModel(parent.model);
	if( calCodeId == null || calCodeId == '')
	{
		top.saveData(parent.pageArray, "RLDiscountGWPPageArray");
	}

	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null) {
			o.<%= RLConstants.RLPROMOTION_CURRENCY %> = fCurr;
			top.saveData(o,"RLPromotion");
		}
	}
	top.put("inputsku",productSKU);	
	top.put("<%= RLConstants.RLPROMOTION_PROD_SEARCH_PAGE %>", rlpagename);
	top.saveData(productSKU, "inputsku");
	top.setReturningPanel("RLDiscountGWPType");
	top.setContent("<%= RLPromotionNLS.get("ProductSearchBrowserTitle") %>","/webapp/wcs/tools/servlet/RLSearchDialogView?ActionXMLFile=RLPromotion.RLSearchDialog",true);
}

function setValidationFlag()
{
	if(trim(document.discountGWPForm.rlProdGiftSku.value) != '')
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

<form name="discountGWPForm" id="discountGWPForm">

<h1><%=RLPromotionNLS.get("RLDiscountGWP_title")%></h1>
<br />

<label for="prodGiftSkuLabel"><%=RLPromotionNLS.get("prodGiftSkuLabel")%></label><br />
<table border="0" cellpadding="0" cellspacing="0" id="WC_RLDiscountGWP_Table_1">
<tr>
<td id="WC_RLDiscountGWP_TableCell_1"> <input name="rlProdGiftSku" type="text" size="15" maxlength="64" onchange="setValidationFlag()" id="prodGiftSkuLabel" /> </td>
<td id="WC_RLDiscountGWP_TableCell_2"> <button type="button" value='<%=RLPromotionNLS.get("findButton")%>' name="rlSearchProduct" class="enabled" style="width:auto;text-align:center" onclick="javascript:callSearch();">&nbsp;<%=RLPromotionNLS.get("findButton")%></button> </td>
</tr>
</table>


<p><label for="prodGiftQtyLabel"><%=RLPromotionNLS.get("prodGiftQtyLabel")%></label><br />
<input name="rlProdGiftQty" type="text" size="10" maxlength="14" id="prodGiftQtyLabel" /></p>

<p><%=RLPromotionNLS.get("minQualTitle")%><br />
<input type="radio" name="minRad" onclick="javascript:checkMinArea(false);" checked ="checked" id="None" /><label for="None"><%=RLPromotionNLS.get("None")%></label><br />
<input type="radio" name="minRad" onclick="javascript:checkMinArea(true);" id="minQty" /><label for="minQty"><%=RLPromotionNLS.get("minQual")%></label></p>
<div id="minArea" style="display:none">
	<blockquote>
		<p><label for="purchaseAmount"><%=RLPromotionNLS.get("purchaseAmount")%></label><br />
		<input name="minQual" type="text" size="14" maxlength="21" id="purchaseAmount" />
			<script language="JavaScript">
				document.write(fCurr);					
			</script>
		</p>
	</blockquote>
</div>

</form>
</body>
</html>


