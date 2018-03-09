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
<?xml version="1.0"?>
<%@include file="epromotionCommon.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=RLPromotionNLS.get("RLDiscountType_title")%></title>
<%= fPromoHeader%>

<script language="JavaScript">
var lastBranch = 0;
var currBranch = 0;

var ranges = new Array();
var values = new Array();

function initializeState()
{
	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null) {
			if(o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ORDERLEVELPERCENTDISCOUNT %>")
			{
			lastBranch=0;
			}
			else if (o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ORDERLEVELVALUEDISCOUNT %>")
			{
			lastBranch=1;
			}
			else if (o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ORDERLEVELFIXEDSHIPPINGDISCOUNT %>")
			{
			lastBranch=2;
			}
			else if (o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ORDERLEVELFREEGIFT %>")
			{
			lastBranch=3;
			}

			document.typeForm.discType[eval(lastBranch)].checked = true;
			document.typeForm.discType[eval(lastBranch)].focus();
			ranges = o.<%= RLConstants.RLPROMOTION_RANGES %>;
			values = o.<%= RLConstants.RLPROMOTION_VALUES %>;
		}
	}
	else
	{
			document.typeForm.discType[0].focus();
	}

    parent.setPanelAttribute( "RLDiscountWizardRanges", "hasTab", "NO" );
    parent.TABS.location.reload();  			    
	
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
	if(ranges.length != 0)
	{
		var newRanges = new Array();
		var newValues = new Array();
		if (parent.get) {
			var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
			if (o != null) {
				o.<%= RLConstants.RLPROMOTION_RANGES %> = newRanges;
				o.<%= RLConstants.RLPROMOTION_VALUES %> = newValues;
				if(eval(lastBranch) == 0 || eval(lastBranch) == 1)
				{
				}
				else if(eval(lastBranch) == 2)
				{
					o.<%= RLConstants.RLPROMOTION_SHIPMODEID %> = "";	
				}
				else if(eval(lastBranch) == 3)
				{
					o.<%= RLConstants.RLPROMOTION_DISCOUNT_ITEM_SKU %> = "";
				}
			}
		}
	}

  } else if ((hasMin && (ranges.length >2)) || (!hasMin && (ranges.length>1))) {
    parent.setNextBranch("RLDiscountWizardRanges");
  }
}


function savePanelData()
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
			promotionType = "<%= RLConstants.RLPROMOTION_ORDERLEVELPERCENTDISCOUNT %>";
			parent.setNextBranch("RLDiscountPercent");
			break;
		case 1:
			promotionType = "<%= RLConstants.RLPROMOTION_ORDERLEVELVALUEDISCOUNT %>";
			parent.setNextBranch("RLDiscountFixed");
			break;
		case 2:
			promotionType = "<%= RLConstants.RLPROMOTION_ORDERLEVELFIXEDSHIPPINGDISCOUNT %>";
			parent.setNextBranch("RLDiscountShipping");
			break;
		case 3:
			promotionType = "<%= RLConstants.RLPROMOTION_ORDERLEVELFREEGIFT %>";
			parent.setNextBranch("RLDiscountGWP");
			break;
	}
	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null) {
			o.<%= RLConstants.RLPROMOTION_TYPE %> = promotionType;
		}
	}
	currBranch = i;
    return true;
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

<h1><%=RLPromotionNLS.get("RLDiscountType_title")%></h1>

<p><input name="discType" type="radio" checked ="checked" id="WC_RLDiscountType_FormInput_discType_In_typeForm_1" /> <label for="WC_RLDiscountType_FormInput_discType_In_typeForm_1"><%=RLPromotionNLS.get("RLDiscountPercent")%></label></p>
<p><input name="discType" type="radio" id="WC_RLDiscountType_FormInput_discType_In_typeForm_2" /> <label for="WC_RLDiscountType_FormInput_discType_In_typeForm_2"><%=RLPromotionNLS.get("RLDiscountFixed")%></label></p>
<p><input name="discType" type="radio" id="WC_RLDiscountType_FormInput_discType_In_typeForm_3" /> <label for="WC_RLDiscountType_FormInput_discType_In_typeForm_3"><%=RLPromotionNLS.get("RLDiscountShipping")%></label></p>
<p><input name="discType" type="radio" id="WC_RLDiscountType_FormInput_discType_In_typeForm_4" /> <label for="WC_RLDiscountType_FormInput_discType_In_typeForm_4"><%=RLPromotionNLS.get("RLDiscountGWP")%></label></p>

</form>
</body>
</html>



