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
<title><%=RLPromotionNLS.get("RLDiscountPercent_title")%></title>
<%=fPromoHeader%>
<script src="/wcs/javascript/tools/common/Util.js">
</script>

<script language="JavaScript">
var calCodeId = null;
if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null)
			calCodeId = o.<%= RLConstants.EC_CALCODE_ID %>;
}

var fCurr=parent.getCurrency();


function initializeState()
{
	var percentDiscount;
	var hasMin = false;
	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null)
		{
			var ranges = o.<%= RLConstants.RLPROMOTION_RANGES %>;
			var values = o.<%= RLConstants.RLPROMOTION_VALUES %>;
			if (ranges.length >= 2)
			{
				if(eval(values[0]) == 0)
				{
					percentDiscount = values[1];
					if (percentDiscount != null && percentDiscount != "" && !isNaN(percentDiscount))
					{
						document.percentageForm.percentageDiscount.value=percentDiscount;
					}	
					minQual = ranges[1];
			
					if ((minQual != null) && (minQual != "") && !isNaN(minQual))
					{
						//added for NaN fix
						hasMin = true;
						document.percentageForm.minRad[1].checked = true;			
						document.percentageForm.minQual.value=parent.numberToCurrency(minQual,fCurr,"<%=fLanguageId%>");
					}
				}
				else
				{
					document.percentageForm.minRad[0].checked = true;
					//added for NaN fix
					percentDiscount = values[0];
					if (percentDiscount != null && percentDiscount != "" && !isNaN(percentDiscount))
					{
						document.percentageForm.percentageDiscount.value=percentDiscount;
					}	
				}
			}
			else if (ranges.length == 1)
			{
				document.percentageForm.minRad[0].checked = true;
				//added for NaN fix
				percentDiscount = values[0];
				if (percentDiscount != null && percentDiscount != "" && !isNaN(percentDiscount))
				{
					document.percentageForm.percentageDiscount.value=percentDiscount;
				}	
			}

		      checkMinArea(hasMin);
		}
	}
	
    if(calCodeId == null || calCodeId == '')
    {
		parent.setPanelAccess("RLDiscountPercentType", true);
		parent.setPanelAttribute( "RLDiscountPercentType", "hasTab", "YES" );

	    parent.setPanelAttribute( "RLDiscountFixedType", "hasTab", "NO" );
	    parent.setPanelAttribute( "RLDiscountShippingType", "hasTab", "NO" );
	    parent.setPanelAttribute( "RLDiscountGWPType", "hasTab", "NO" );
       	parent.TABS.location.reload();    
	}  
	
	document.percentageForm.percentageDiscount.focus();
	parent.setContentFrameLoaded(true);
	
	if (parent.get("percentageInvalid", false)) {
		parent.remove("percentageInvalid");
		reprompt(document.percentageForm.percentageDiscount,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("percentageInvalid").toString())%>");
		return;
	}

	if (parent.get("currencyTooLong", false)) {
		parent.remove("currencyTooLong");
		reprompt(document.percentageForm.minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("currencyTooLong").toString())%>");
		return;
	}

	if (parent.get("minQualPurchaseAmountInvalid", false)) {
		parent.remove("minQualPurchaseAmountInvalid");
		reprompt(document.percentageForm.minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("minQualPurchaseAmountInvalid").toString())%>");
		return;
	}
}


function validatePanelData()
{
    if(calCodeId == null || trim(calCodeId) == '')
    {
		// set the target of next button in wizard branching
		parent.setNextBranch("RLDiscountWizardRanges");    
	}
	
	if (!isValidPercentage(trim(document.percentageForm.percentageDiscount.value),"<%=fLanguageId%>"))
	{
		reprompt(document.percentageForm.percentageDiscount,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("percentageInvalid").toString())%>");
		return false;
	}
	if (document.percentageForm.minRad[1].checked)
	{
		if (parent.currencyToNumber(trim(document.percentageForm.minQual.value), fCurr,"<%=fLanguageId%>").toString().length > 14)
		{
			reprompt(document.percentageForm.minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("currencyTooLong").toString())%>");
			return false;
		}
		else if ( !parent.isValidCurrency(trim(document.percentageForm.minQual.value), fCurr, "<%=fLanguageId%>"))
		{
			reprompt(document.percentageForm.minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("minQualPurchaseAmountInvalid").toString())%>");
			return false;
		}
	}	
	return true;
}


function validateNoteBookPanel(){
	return validatePanelData();
}

function savePanelData()
{
	var ranges=new Array();
	var values=new Array();	

	var numPercent="";
	if (trim(document.percentageForm.percentageDiscount.value) != null && trim(document.percentageForm.percentageDiscount.value) != "" )
      	numPercent=parent.strToNumber(trim(document.percentageForm.percentageDiscount.value),"<%=fLanguageId%>");
	if (document.percentageForm.minRad[1].checked)
	{
		var numMin=0;
		if (trim(document.percentageForm.minQual.value) != null && trim(document.percentageForm.minQual.value) != "")
			numMin=parent.currencyToNumber(trim(document.percentageForm.minQual.value), fCurr,"<%=fLanguageId%>");
		ranges[0]=0;
		values[0]=0;
		ranges[1]=numMin;
		values[1]=numPercent;
	}
	else
	{
		ranges[0]=0;
		values[0]=numPercent;
	}

	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null) {
			var tempRange = o.<%= RLConstants.RLPROMOTION_RANGES %>;
			var tempValue = o.<%= RLConstants.RLPROMOTION_VALUES %>;
			// check if any modification 
			if (((document.percentageForm.minRad[1].checked) && (tempRange[0]==ranges[0]) && (tempRange[1]==ranges[1]) && (tempValue[0]==values[0]) && (tempValue[1]==values[1])) || ((!document.percentageForm.minRad[1].checked) && (tempRange[0]==ranges[0]) && (tempValue[0]==values[0]))) {
				o.<%= RLConstants.RLPROMOTION_RANGES %> = tempRange;
				o.<%= RLConstants.RLPROMOTION_VALUES %> = tempValue;
			} else {
				o.<%= RLConstants.RLPROMOTION_RANGES %> = ranges;
				o.<%= RLConstants.RLPROMOTION_VALUES %> = values;
			}
			o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_ORDERLEVELPERCENTDISCOUNT %>";
  
		      if(calCodeId == null || calCodeId == '')
		      {
			parent.setPanelAccess("RLDiscountWizardRanges", true );
			parent.setPanelAttribute( "RLDiscountWizardRanges", "hasTab", "YES" );
			}
		}
	}
  return true;
}

function isValidPercentage(pValue, languageId)
{	// Changed for defect 179712
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


</script>
<meta name="GENERATOR" content="IBM WebSphere Studio" />
</head>
<body class="content" onload="javascript:initializeState();">
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

<form name="percentageForm" id="percentageForm">

<h1><%=RLPromotionNLS.get("RLDiscountPercent")%></h1>
<br />
<label for="Discount"><%=RLPromotionNLS.get("Discount")%></label><br />
<input name="percentageDiscount" type="text" size="6" maxlength="6" id="Discount" /> <%=RLPromotionNLS.get("percentage_symbol")%>


<p><%=RLPromotionNLS.get("minQualTitle")%><br />
<input type="radio" name="minRad" onclick="javascript:checkMinArea(false);" checked ="checked" id="None" /><label for="None"><%=RLPromotionNLS.get("None")%></label><br />
<input type="radio" name="minRad" onclick="javascript:checkMinArea(true);" id="minQty" /><label for="minQty"><%=RLPromotionNLS.get("minQual")%></label></p>
<div id="minArea" style="display:none">
	<blockquote>
		<p><label for="purchaseAmount"><%=RLPromotionNLS.get("purchaseAmount")%></label><br />
		<input name="minQual" type="text" size="14" maxlength="21" id="purchaseAmount" />
			<script language="JavaScript">
				document.write(parent.getCurrency());
			
</script>
		</p>
	</blockquote>
</div>

<script language="JavaScript">
  if(calCodeId == null || calCodeId == '')
  {
	document.write('<p><%= UIUtil.toJavaScript(RLPromotionNLS.get("multiRangeGuide").toString())%></p>');  
  }	

</script>

</form>
</body>
</html>


