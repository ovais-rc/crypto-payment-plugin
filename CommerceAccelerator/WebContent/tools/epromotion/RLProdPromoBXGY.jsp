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
<%@include file="epromotionCommon.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=RLPromotionNLS.get("RLProdPromoBXGY_title")%></title>
<%= fPromoHeader%>

<script src="/wcs/javascript/tools/common/Util.js">
</script>

<script language="JavaScript">
	var rlpromo = parent.get("<%= RLConstants.RLPROMOTION %>", null);
	var merchandiseType = rlpromo.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %>;
	var calCodeId = null;

function initializeState()
{
		if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null) {
			calCodeId = o.<%= RLConstants.EC_CALCODE_ID %>;
			with (document.bxgyForm)
			{	
			   if(merchandiseType == "Category"){							
				   var inList = o.<%= RLConstants.RLPROMOTION_CATGROUP_CODE %>;
				  // alert("inList  " + inList);
			   }
			   else
			   {			   	   
			   	   var inList = o.<%= RLConstants.RLPROMOTION_PRODUCT_SKU %>;
				  // alert("inList  " + inList);
			   }
			   for (var i=0; i<inList.length; i++) {
				rlProdXSku.options[i] = new Option(
				inList[i], // name
				inList[i], // value
				false,    // defaultSelected
				false);   // selected
				}					  
				 
				var requiredQty = o.<%= RLConstants.RLPROMOTION_REQUIRED_QTY %>;
				if (requiredQty != null && requiredQty != "")
				{
					rlProdXQty.value = requiredQty;
				}	
				
				var percentDiscount = o.<%= RLConstants.RLPROMOTION_VALUE %>;
				if (percentDiscount != null && percentDiscount != "")
				{
					percentageDiscount.value = percentDiscount;
				}
				var maxDiscountItemQty = o.<%= RLConstants.RLPROMOTION_MAX_DISCOUNT_ITEM_QTY %>;
				if( maxDiscountItemQty != null && maxDiscountItemQty != "")
				{
					rlMaxProdYQty.value = maxDiscountItemQty;
				}
			} // end of with
		} // o!null
	  } // end of parent.get
	//document.bxgyForm.rlProdXSku.focus();
	parent.setContentFrameLoaded(true);

	if (parent.get("prodQtyTooLong", false)) {
		parent.remove("prodQtyTooLong");
		reprompt(document.bxgyForm.rlProdXQty,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("prodQtyNumberTooLong").toString())%>");
		return;
	}
	if (parent.get("prodQtyNotNumber", false)) {
		parent.remove("prodQtyNotNumber");
		reprompt(document.bxgyForm.rlProdXQty,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("prodMinNotNumber").toString())%>");
		return;
	}
	if (parent.get("percentNotValid", false)) {
		parent.remove("percentNotValid");
		reprompt(document.bxgyForm.percentageDiscount,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("percentageInvalid").toString())%>");
		return;
	}
	if (parent.get("maxProdQtyTooLong", false)) {
		parent.remove("maxProdQtyTooLong");
		reprompt(document.bxgyForm.rlMaxProdYQty,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("prodQtyNumberTooLong").toString())%>");
		return;
	}
	if (parent.get("maxProdQtyNotNumber", false)) {
		parent.remove("maxProdQtyNotNumber");
		reprompt(document.bxgyForm.rlMaxProdYQty,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("prodMinNotNumber").toString())%>");
		return;
	}
}


function savePanelData()
{
		if (parent.get) {
			var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
			if (o != null) {
				with (document.bxgyForm)
				{
					if (trim(rlProdXQty.value) != null && trim(rlProdXQty.value) != "")
						o.<%= RLConstants.RLPROMOTION_REQUIRED_QTY %> = parent.strToNumber(trim(rlProdXQty.value),"<%=fLanguageId%>");
	                else	
						o.<%= RLConstants.RLPROMOTION_REQUIRED_QTY %> = "";
					if (trim(percentageDiscount.value) != null && trim(percentageDiscount.value) != "")
						o.<%= RLConstants.RLPROMOTION_VALUE %> = parent.strToNumber(trim(percentageDiscount.value),"<%=fLanguageId%>");
					else
						o.<%= RLConstants.RLPROMOTION_VALUE %> = "";
	
					if (trim(rlMaxProdYQty.value)!= null && trim(rlMaxProdYQty.value) != "")
						o.<%= RLConstants.RLPROMOTION_MAX_DISCOUNT_ITEM_QTY %> = parent.strToNumber(trim(rlMaxProdYQty.value),"<%=fLanguageId%>");
					else
						o.<%= RLConstants.RLPROMOTION_MAX_DISCOUNT_ITEM_QTY %> = 1;
						
					if(o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> == 'ItemBean')
					{
						o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_ITEMLEVELSAMEITEMPERCENTDISCOUNT %>";
					}
					else if (o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> == 'ProductBean')
					{
						o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_PRODUCTLEVELSAMEITEMPERCENTDISCOUNT %>"
					}	
					else if (o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> == 'Category')  
					{
						o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_CATEGORYLEVELSAMEITEMPERCENTDISCOUNT %>"
					}	
				} // end of with
			}
		}
	return true;
}


function validatePanelData()
{ 
		with (document.bxgyForm)
		{
			if (!validateQty(rlProdXQty)) return false;
			if (!isValidPercentage(trim(percentageDiscount.value),"<%=fLanguageId%>"))
			{
				reprompt(percentageDiscount,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("percentageInvalid").toString())%>");
				return false;
			}
	
			if (!validateQty(rlMaxProdYQty)) return false;
		}
	return true;

}

function validateNoteBookPanel(){
	return validatePanelData();
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

function isValidPercentage(pValue, languageId)
{
	// Changed for defect 179712
	if ( !parent.isValidNumber(pValue, languageId))
	{
		return false;
	}
	else if( ! (eval(pValue) <= 100))
	{
		return false;
	}
	else if (! (eval(pValue) >= 0) )
	{
		return false;
	}
	return true;
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

<form name="bxgyForm" id="bxgyForm">

<h1><%=RLPromotionNLS.get("buyXGetY")%></h1>
<br />
<p><label for="rlProdXSku">
<script language="JavaScript">
if(merchandiseType=="Category")
{
document.write('<%=RLPromotionNLS.get("categoryLabel")%>');
}
else
{
document.write('<%=RLPromotionNLS.get("prodXLabel")%>');
}
</script>
</label><br/>
 <select name="rlProdXSku" style="width:300; font-family: arial" multiple="multiple" size="8" disabled="disabled" id="rlProdXSku">
    </select></p>

<p><label for="prodXQtyLabel"><%=RLPromotionNLS.get("prodXQtyLabel")%></label><br/>
<input name="rlProdXQty" type="text" size="10" maxlength="14" id="prodXQtyLabel"/></p>

<p><label for="prodYMaxQty"><%=RLPromotionNLS.get("prodYMaxQty")%></label><br />
<input name="rlMaxProdYQty" type="text" value= "1" size="10" maxlength="14" id="prodYMaxQty" /><%=RLPromotionNLS.get("Items")%></p>
	
<label for="DiscountBXGY"><%=RLPromotionNLS.get("DiscountBXGY")%></label><br/>
<input name="percentageDiscount" type="text" size="6" maxlength="6" id="DiscountBXGY" /> <%=RLPromotionNLS.get("percentage_symbol")%>


</form>
</body>
</html>


