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
<title><%=RLPromotionNLS.get("RLDiscountFixed_title")%></title>
<%=fPromoHeader%>
<script src="/wcs/javascript/tools/common/Util.js">
</script>
<script language="JavaScript">
var MYRLPROMOTIONTYPE;
var fCurr=parent.getCurrency();
var calCodeId = null;

if (parent.get) {
	var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
	if (o != null)
	{
			if(o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ITEMLEVELPERITEMVALUEDISCOUNT %>" )
			{
			  MYRLPROMOTIONTYPE="<%= RLConstants.RLPROMOTION_ITEMLEVELPERITEMVALUEDISCOUNT %>";
			}
			else if(o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_ITEMLEVELVALUEDISCOUNT %>" )
			{
			  MYRLPROMOTIONTYPE="<%= RLConstants.RLPROMOTION_ITEMLEVELVALUEDISCOUNT %>";
			}
			else if(o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELPERITEMVALUEDISCOUNT %>" )
			{
			  MYRLPROMOTIONTYPE="<%= RLConstants.RLPROMOTION_PRODUCTLEVELPERITEMVALUEDISCOUNT %>";
			}
			else if(o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_PRODUCTLEVELVALUEDISCOUNT %>" )
			{
			  MYRLPROMOTIONTYPE="<%= RLConstants.RLPROMOTION_PRODUCTLEVELVALUEDISCOUNT %>";
			}
			else if(o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_CATEGORYLEVELPERITEMVALUEDISCOUNT %>" )
			{
			  MYRLPROMOTIONTYPE="<%= RLConstants.RLPROMOTION_CATEGORYLEVELPERITEMVALUEDISCOUNT %>";
			}
			else if(o.<%= RLConstants.RLPROMOTION_TYPE %> == "<%= RLConstants.RLPROMOTION_CATEGORYLEVELVALUEDISCOUNT %>" )
			{
			  MYRLPROMOTIONTYPE="<%= RLConstants.RLPROMOTION_CATEGORYLEVELVALUEDISCOUNT %>";
			}
		
		calCodeId = o.<%= RLConstants.EC_CALCODE_ID %>;
	}
}


function initializeState()
{

      if(calCodeId == null || calCodeId == '')
      {
	    parent.setPanelAttribute( "RLProdPromoBXGYType", "hasTab", "NO" );
	    parent.setPanelAttribute( "RLProdPromoGWPType", "hasTab", "NO" );
       	parent.TABS.location.reload();  			    
	  }  

	var hasMin=false;
	var fixedDiscount=0;
	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null)
		{
			var ranges = o.<%= RLConstants.RLPROMOTION_RANGES %>;
			var values = o.<%= RLConstants.RLPROMOTION_VALUES %>;
			if (ranges.length >=2)
			{
				if(eval(values[0]) == 0)
				{
					var minQual=0;
					fixedDiscount=values[1];
					if ((fixedDiscount != null) && (fixedDiscount != "") && !isNaN(fixedDiscount))
						document.fixedForm.fixedDiscount.value=parent.numberToCurrency(fixedDiscount,fCurr,"<%=fLanguageId%>");
					minQual=ranges[1];
			
					if ((minQual != null) && (minQual != "") && !isNaN(minQual))
					{
						hasMin=true;
						document.fixedForm.minRad[1].checked = true;					
						document.fixedForm.minQual.value=parent.strToNumber(minQual,"<%=fLanguageId%>");
					}			
				}
				else
				{
					fixedDiscount=values[0];
					if ((fixedDiscount != null) && (fixedDiscount != "") && !isNaN(fixedDiscount))
					{
						document.fixedForm.fixedDiscount.value=parent.numberToCurrency(fixedDiscount,fCurr,"<%=fLanguageId%>");
					}
					document.fixedForm.minRad[0].checked = true;
				}		
			}
			else
			{
				fixedDiscount=values[0];
				if ((fixedDiscount != null) && (fixedDiscount != "") && !isNaN(fixedDiscount))
				{
					document.fixedForm.fixedDiscount.value=parent.numberToCurrency(fixedDiscount,fCurr,"<%=fLanguageId%>");
				}
				document.fixedForm.minRad[0].checked = true;
			}	

			checkMinArea(hasMin);
		}
	}
		document.fixedForm.fixedDiscount.focus();
		parent.setContentFrameLoaded(true);

	if (parent.get("currencyInvalid", false)) {
		parent.remove("currencyInvalid");
		reprompt(document.fixedForm.fixedDiscount,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("currencyInvalid").toString())%>");
	      return;
	}
	if (parent.get("currencyTooLong", false)) {
		parent.remove("currencyTooLong");
		reprompt(document.fixedForm.fixedDiscount,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("currencyTooLong").toString())%>");
	      return;
	}
	if (parent.get("numberTooLong", false)) {
		parent.remove("numberTooLong");
		reprompt(document.fixedForm.minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("numberTooLong").toString())%>");
	      return;
	}
	if (parent.get("minQualNotNumber", false)) {
		parent.remove("minQualNotNumber");
		reprompt(document.fixedForm.minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("minQualNotNumber").toString())%>");
	      return;
	}
}


function validatePanelData()
{
   if(calCodeId == null || calCodeId == '')
   {
		// set the target of next button in wizard branching
		parent.setNextBranch("RLProdPromoWizardRanges");
	}
	
	parent.put("visitedRLProdPromoFixed", true);
	var numValue=parent.currencyToNumber(trim(document.fixedForm.fixedDiscount.value), fCurr,"<%=fLanguageId%>");


	if (numValue.toString().length >14)
	{
		reprompt(document.fixedForm.fixedDiscount,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("currencyTooLong").toString())%>");
		return false;
	}
	else if ( !parent.isValidCurrency(trim(document.fixedForm.fixedDiscount.value), fCurr, "<%=fLanguageId%>"))
	{
		reprompt(document.fixedForm.fixedDiscount,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("currencyInvalid").toString())%>");
		return false;
	}

	if (document.fixedForm.minRad[1].checked)
	{
		var numMin=parent.strToNumber(trim(document.fixedForm.minQual.value),"<%=fLanguageId%>");
		if (numMin.toString().length > 14)
		{
			reprompt(document.fixedForm.minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("numberTooLong").toString())%>");
			return false;
		}
		else if ( !parent.isValidInteger(trim(document.fixedForm.minQual.value), "<%=fLanguageId%>"))
		{
			reprompt(document.fixedForm.minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("minQualNotNumber").toString())%>");
			return false;
		}
		else if (eval(numMin) <= 0)
		{
			reprompt(document.fixedForm.minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("minQualNotNumber").toString())%>");
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

	var numValue="";
	if (trim(document.fixedForm.fixedDiscount.value) != null && trim(document.fixedForm.fixedDiscount.value) != "")
		numValue=parent.currencyToNumber(trim(document.fixedForm.fixedDiscount.value), fCurr,"<%=fLanguageId%>");
	if (document.fixedForm.minRad[1].checked)
	{     
		var numMin = "";
		if (trim(document.fixedForm.minQual.value) != null && trim(document.fixedForm.minQual.value) != "")
			numMin=parent.strToNumber(trim(document.fixedForm.minQual.value),"<%=fLanguageId%>");
		ranges[0]=0;
		values[0]=0;
		ranges[1]=numMin;
		values[1]=numValue;
		parent.put("hasMin", true);
	}
	else
	{
		ranges[0]=0;
		values[0]=numValue;
		parent.put("hasMin", false);
	}

	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null) {
			o.<%= RLConstants.RLPROMOTION_RANGES %> = ranges;
			o.<%= RLConstants.RLPROMOTION_VALUES %> = values;
			o.<%= RLConstants.RLPROMOTION_TYPE %> = MYRLPROMOTIONTYPE;
			
		      if(calCodeId == null || calCodeId == '')
		      {
				parent.setPanelAccess("RLProdPromoWizardRanges", true );
				parent.setPanelAttribute( "RLProdPromoWizardRanges", "hasTab", "YES" );
			}
		}
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

<form name="fixedForm" id="fixedForm">
<script>

  if (MYRLPROMOTIONTYPE=="ItemLevelPerItemValueDiscount" || MYRLPROMOTIONTYPE=="ProductLevelPerItemValueDiscount" || MYRLPROMOTIONTYPE=="CategoryLevelPerItemValueDiscount") {
    document.write('<h1><%=RLPromotionNLS.get("RLProdPromoFixedPerItem")%></h1>');
  } else if (MYRLPROMOTIONTYPE=="ItemLevelValueDiscount" || MYRLPROMOTIONTYPE=="ProductLevelValueDiscount" || MYRLPROMOTIONTYPE=="CategoryLevelValueDiscount") {
    document.write('<h1><%=RLPromotionNLS.get("RLProdPromoFixedForAll")%></h1>');
  }
</script>
<br />
<label for="Discount"><%=RLPromotionNLS.get("Discount")%></label><br />
<input name="fixedDiscount" type="text" size="14" maxlength="18" id="Discount" />
	<script language="JavaScript">
		document.write(parent.getCurrency());
	
</script>


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


