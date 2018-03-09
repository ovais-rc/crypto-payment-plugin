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
<title><%=RLPromotionNLS.get("RLProdPromoPercent_title")%></title>
<%=fPromoHeader%>
<script src="/wcs/javascript/tools/common/Util.js">
</script>

<script language="JavaScript">

var fCurr=parent.getCurrency();
var calCodeId = null;

if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null)
			calCodeId = o.<%= RLConstants.EC_CALCODE_ID %>;
}

function initializeState()
{
	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		var percentDiscount;
		if (o != null)
		{
			var ranges = o.<%= RLConstants.RLPROMOTION_RANGES %>;
			var values = o.<%= RLConstants.RLPROMOTION_VALUES %>;
			var hasMin=	false;
			if (ranges.length == 2)
			{
				if(eval(values[0]) == 0)
				{
					percentDiscount = values[1];
					if ((percentDiscount != null) && (percentDiscount != "") && !isNaN(percentDiscount))
					{
						document.percentageForm.percentageDiscount.value=percentDiscount;
					}	
										
					minQual = ranges[1];
			
					if ((minQual != null) && (trim(minQual) != '') && !isNaN(minQual))
					{
						//added for NaN fix					
						hasMin = true;
						document.percentageForm.minRad[1].checked = true;
						document.percentageForm.minQual.value=parent.strToNumber(minQual,"<%=fLanguageId%>");					
						
					}
				}
				else
				{
					document.percentageForm.minRad[0].checked = true;
					percentDiscount = values[0];
					if ((percentDiscount != null) && (percentDiscount != "") && !isNaN(percentDiscount))
					{
						document.percentageForm.percentageDiscount.value=percentDiscount;
					}	
				}	
			}
			else if (ranges.length == 1)
			{
				document.percentageForm.minRad[0].checked = true;
				percentDiscount = values[0];
				if ((percentDiscount != null) && (percentDiscount != "") && !isNaN(percentDiscount))
				{
					document.percentageForm.percentageDiscount.value=percentDiscount;
				}	
			}
            checkMinArea(hasMin);
		}
	}
	
    if(calCodeId == null || calCodeId == '')
    {
	   parent.setPanelAttribute( "RLProdPromoFixedType", "hasTab", "NO" );
	   parent.setPanelAttribute( "RLProdPromoBXGYType", "hasTab", "NO" );
	   parent.setPanelAttribute( "RLProdPromoGWPType", "hasTab", "NO" );
       parent.TABS.location.reload();  			    
	}  
	
	document.percentageForm.percentageDiscount.focus();
	parent.setContentFrameLoaded(true);

	if (parent.get("percentageInvalid", false)) {
		parent.remove("percentageInvalid");
		reprompt(document.percentageForm.percentageDiscount,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("percentageInvalid").toString())%>");
		return;
	}

	if (parent.get("numberTooLong", false)) {
		parent.remove("numberTooLong");
		reprompt(document.percentageForm.minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("numberTooLong").toString())%>");
		return;
	}

	if (parent.get("minQualNotNumber", false)) {
		parent.remove("minQualNotNumber");
		reprompt(document.percentageForm.minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("minQualNotNumber").toString())%>");
		return;
	}
}

function validatePanelData()
{
	// set the target of next button in wizard branching
      if(calCodeId == null || calCodeId == '')
      {
		parent.setNextBranch("RLProdPromoWizardRanges");    
	}
	
	if (!isValidPercentage(trim(document.percentageForm.percentageDiscount.value),"<%=fLanguageId%>"))
	{
		reprompt(document.percentageForm.percentageDiscount,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("percentageInvalid").toString())%>");
		return false;
	}
	if (document.percentageForm.minRad[1].checked)
	{
		if (parent.strToNumber(trim(document.percentageForm.minQual.value), "<%=fLanguageId%>").toString().length > 14)
		{
			reprompt(document.percentageForm.minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("numberTooLong").toString())%>");
			return false;
		}
		else if ( !parent.isValidInteger(trim(document.percentageForm.minQual.value), "<%=fLanguageId%>"))
		{
			reprompt(document.percentageForm.minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("minQualNotNumber").toString())%>");
			return false;
		}
		else if (!(eval(parent.strToNumber(trim(document.percentageForm.minQual.value),"<%=fLanguageId%>")) > 0))
    {
      reprompt(document.percentageForm.minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("minQualNotNumber").toString())%>");
			return false;
    }
    else if (eval(parent.strToNumber(trim(document.percentageForm.minQual.value),"<%=fLanguageId%>")) == 0)
    {
      reprompt(document.percentageForm.minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("minQualNotNumber").toString())%>");
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
    	if ( trim(document.percentageForm.percentageDiscount.value) != null && trim(document.percentageForm.percentageDiscount.value) != "")
    	{
			numPercent=parent.strToNumber(trim(document.percentageForm.percentageDiscount.value),"<%=fLanguageId%>");
		}	
	
	if (document.percentageForm.minRad[1].checked)
	{
		if (trim(document.percentageForm.minQual.value) != null && trim(document.percentageForm.minQual.value) != "")
		{
			var numMin = null;
			numMin = parent.strToNumber(trim(document.percentageForm.minQual.value), "<%=fLanguageId%>");
		}
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
			o.<%= RLConstants.RLPROMOTION_RANGES %> = ranges;
			o.<%= RLConstants.RLPROMOTION_VALUES %> = values;
			if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'ProductBean')
				o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_PRODUCTLEVELPERCENTDISCOUNT %>";
			else if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'ItemBean')
				o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_ITEMLEVELPERCENTDISCOUNT %>";
			else if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'PackageBean')
				o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_ITEMLEVELPERCENTDISCOUNT %>";
			else if(o.<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %> == 'Category')
				o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_CATEGORYLEVELPERCENTDISCOUNT %>";
		      if(calCodeId == null || calCodeId == '')
		      {
				parent.setPanelAccess("RLProdPromoWizardRanges", true );
				parent.setPanelAttribute( "RLProdPromoWizardRanges", "hasTab", "YES" );
			  }
		}
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

<h1><%=RLPromotionNLS.get("RLProdPromoPercent")%></h1>
<br />
<label for="Discount"><%=RLPromotionNLS.get("Discount")%></label><br />
<input name="percentageDiscount" type="text" size="6" maxlength="6" id="Discount" /> <%=RLPromotionNLS.get("percentage_symbol")%>


<p><%=RLPromotionNLS.get("minQualTitle")%><br />
<input type="radio" name="minRad" onclick="javascript:checkMinArea(false);" checked ="checked" id="None" /><label for="None"><%=RLPromotionNLS.get("None")%></label><br />
<input type="radio" name="minRad" onclick="javascript:checkMinArea(true);" id="minQty" /><label for="minQty"><%=RLPromotionNLS.get("minQual")%></label></p>
<div id="minArea" style="display:none">
	<blockquote>
		<p><label for="purchaseAmount"><%=RLPromotionNLS.get("purchaseAmountOfQuantity")%></label><br />
		<input name="minQual" type="text" size="14" maxlength="14" id="purchaseAmount" />
			<%=RLPromotionNLS.get("Items")%>
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


