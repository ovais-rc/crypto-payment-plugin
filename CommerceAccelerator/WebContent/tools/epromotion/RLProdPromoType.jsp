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
<title><%=RLPromotionNLS.get("RLProdPromoType_title")%></title>
<%= fPromoHeader%>

<script language="JavaScript">
var lastBranch = 0;
var currBranch = 0;
var calCodeId = null;

var ranges = new Array();
var values = new Array();
var catentryType;

function initializeState()
{
	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null) {
			if(top.get("chosenBranch"))
			{
				lastBranch=top.get("chosenBranch");
			}

			document.typeForm.discType[eval(lastBranch)].checked = true;
			document.typeForm.discType[eval(lastBranch)].focus();
			ranges = o.<%= RLConstants.RLPROMOTION_RANGES %>;
			values = o.<%= RLConstants.RLPROMOTION_VALUES %>;
			calCodeId = o.<%= RLConstants.EC_CALCODE_ID %>;
		}
	}
	else
	{
		document.typeForm.discType[0].focus();
	}
	
    if(calCodeId == null || calCodeId == '')
    {
	    parent.setPanelAttribute( "RLProdPromoWizardRanges", "hasTab", "NO" );
	    parent.TABS.location.reload();  			    
    }

	parent.setContentFrameLoaded(true);
}


function validatePanelData()
{
  var hasMin = false;
  if(ranges.length >=2 && eval(values[0]) == 0)
  {
	hasMin=true;
  }	  

  if (typeChanged()) {
	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null) {
			if(eval(lastBranch)== 0 || eval(lastBranch)== 1 || eval(lastBranch)== 2)
			{
				if(ranges.length != 0)
				{
					var newRanges = new Array();
					var newValues = new Array();
					o.<%= RLConstants.RLPROMOTION_RANGES %> = newRanges;
					o.<%= RLConstants.RLPROMOTION_VALUES %> = newValues;
				}
				if(eval(currBranch)== 3 || eval(currBranch)== 4)
				{
					o.<%= RLConstants.RLPROMOTION_MAX_DISCOUNT_ITEM_QTY %> = "";
					o.<%= RLConstants.RLPROMOTION_REQUIRED_QTY %> = "";
					o.<%= RLConstants.RLPROMOTION_VALUE %> = "";
					o.<%= RLConstants.RLPROMOTION_DISCOUNT_ITEM_SKU %> = "";
				}
			}
			else if(eval(lastBranch)== 3)
			{
				o.<%= RLConstants.RLPROMOTION_MAX_DISCOUNT_ITEM_QTY %> = "";
				o.<%= RLConstants.RLPROMOTION_REQUIRED_QTY %> = "";
				o.<%= RLConstants.RLPROMOTION_VALUE %> = "";
			}
			else if( eval(lastBranch)== 4)
			{
				o.<%= RLConstants.RLPROMOTION_MAX_DISCOUNT_ITEM_QTY %> = "";
				o.<%= RLConstants.RLPROMOTION_REQUIRED_QTY %> = "";
				o.<%= RLConstants.RLPROMOTION_DISCOUNT_ITEM_SKU %> = "";
			}
		}
	}
  }
  else if(eval(lastBranch)== 0 || eval(lastBranch)== 1 || eval(lastBranch)== 2)
  {
	 if ((hasMin && (ranges.length >2)) || (!hasMin && (ranges.length>1))) {
		parent.setNextBranch("RLProdPromoWizardRanges");
	}
  }
  return true;
}


function savePanelData()
{

if (parent.get) {
	var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
	if (o != null)
	{
		var i = 0;
		var promotionType = "";
		while (!document.typeForm.discType[i].checked)
		{
			i++;
		}

		switch(i) 
		{
			case 0:
				if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'ProductBean' || o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> == 'ProductBean')
					promotionType = "<%= RLConstants.RLPROMOTION_PRODUCTLEVELPERCENTDISCOUNT %>";
				else if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'ItemBean' || o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> == 'ItemBean')
					promotionType = "<%= RLConstants.RLPROMOTION_ITEMLEVELPERCENTDISCOUNT %>";
				else if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'PackageBean' || o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> == 'PackageBean')
					promotionType = "<%= RLConstants.RLPROMOTION_ITEMLEVELPERCENTDISCOUNT %>";
				else if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'Category')
					promotionType = "<%= RLConstants.RLPROMOTION_CATEGORYLEVELPERCENTDISCOUNT %>";
				parent.setNextBranch("RLProdPromoPercent");
				break;
			case 1:
				if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'ProductBean' || o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> == 'ProductBean')
					promotionType = "<%= RLConstants.RLPROMOTION_PRODUCTLEVELVALUEDISCOUNT %>";
				else if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'ItemBean' || o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> == 'ItemBean')
					promotionType = "<%= RLConstants.RLPROMOTION_ITEMLEVELVALUEDISCOUNT %>";
				else if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'PackageBean' || o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> == 'PackageBean')
					promotionType = "<%= RLConstants.RLPROMOTION_ITEMLEVELVALUEDISCOUNT %>";
				else if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'Category')
					promotionType = "<%= RLConstants.RLPROMOTION_CATEGORYLEVELVALUEDISCOUNT %>";
				parent.setNextBranch("RLProdPromoFixed");
				break;
			case 2:
				if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'ProductBean' || o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> == 'ProductBean')
					promotionType = "<%= RLConstants.RLPROMOTION_PRODUCTLEVELPERITEMVALUEDISCOUNT %>";
				else if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'ItemBean' || o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> == 'ItemBean')
					promotionType = "<%= RLConstants.RLPROMOTION_ITEMLEVELPERITEMVALUEDISCOUNT %>";
				else if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'PackageBean' || o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> == 'PackageBean')
					promotionType = "<%= RLConstants.RLPROMOTION_ITEMLEVELPERITEMVALUEDISCOUNT %>";
				else if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'Category')
					promotionType = "<%= RLConstants.RLPROMOTION_CATEGORYLEVELPERITEMVALUEDISCOUNT %>";
				parent.setNextBranch("RLProdPromoFixed");
				break;
			case 3:
				if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'ItemBean' || o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> == 'ItemBean')
					promotionType = "<%= RLConstants.RLPROMOTION_ITEMLEVELSAMEITEMPERCENTDISCOUNT %>";
				else if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'ProductBean' || o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> == 'ProductBean')
	            	promotionType = "<%= RLConstants.RLPROMOTION_PRODUCTLEVELSAMEITEMPERCENTDISCOUNT %>";
	           	else if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'Category')
	            	promotionType = "<%= RLConstants.RLPROMOTION_CATEGORYLEVELSAMEITEMPERCENTDISCOUNT %>";
	            else if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'PackageBean' || o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> == 'PackageBean')
	            	promotionType = "<%= RLConstants.RLPROMOTION_ITEMLEVELSAMEITEMPERCENTDISCOUNT %>";
				parent.setNextBranch("RLProdPromoBXGY");
				break;
			case 4:
				if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'ProductBean' || o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> == 'ProductBean')
					promotionType = "<%= RLConstants.RLPROMOTION_PRODUCTLEVELBUYXGETYFREE %>";
				else if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'ItemBean' || o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> == 'ItemBean')
					promotionType = "<%= RLConstants.RLPROMOTION_ITEMLEVELBUYXGETYFREE %>";
				else if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'PackageBean' || o.<%= RLConstants.RLPROMOTION_CATENTRY_TYPE %> == 'PackageBean')
					promotionType = "<%= RLConstants.RLPROMOTION_ITEMLEVELBUYXGETYFREE %>";
				else if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'Category')
					promotionType = "<%= RLConstants.RLPROMOTION_CATEGORYLEVELBUYXGETYFREE %>";
				parent.setNextBranch("RLProdPromoGWP");
				break;
		}

		top.put("chosenBranch", i);
		top.put("lastCatentType",o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %>);
		currBranch = i;
		o.<%= RLConstants.RLPROMOTION_TYPE %> = promotionType;
	}
	}
}

function typeChanged()
{
  if (lastBranch!=currBranch)
    return true;
  else 
    return false;
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

<form name="typeForm" id="typeForm">

<h1><%=RLPromotionNLS.get("RLProdPromoType_title")%></h1>

<p><input name="discType" type="radio" checked ="checked" id="WC_RLProdPromoType_FormInput_discType_In_typeForm_1" /> <label for="WC_RLProdPromoType_FormInput_discType_In_typeForm_1"><%=RLPromotionNLS.get("RLProdPromoPercent")%></label></p>
<p><input name="discType" type="radio" id="WC_RLProdPromoType_FormInput_discType_In_typeForm_2" /> <label for="WC_RLProdPromoType_FormInput_discType_In_typeForm_2"><%=RLPromotionNLS.get("RLProdPromoFixedForAll")%></label></p>
<p><input name="discType" type="radio" id="WC_RLProdPromoType_FormInput_discType_In_typeForm_3" /> <label for="WC_RLProdPromoType_FormInput_discType_In_typeForm_3"><%=RLPromotionNLS.get("RLProdPromoFixedPerItem")%></label></p>
<p><input name="discType" type="radio" id="WC_RLProdPromoType_FormInput_discType_In_typeForm_4" /> <label for="WC_RLProdPromoType_FormInput_discType_In_typeForm_4"><%=RLPromotionNLS.get("RLProdPromoBXGY")%></label></p>
<p><input name="discType" type="radio" id="WC_RLProdPromoType_FormInput_discType_In_typeForm_5" /> <label for="WC_RLProdPromoType_FormInput_discType_In_typeForm_5"><%=RLPromotionNLS.get("RLProdPromoGWP")%></label></p>

</form>
</body>
</html>



