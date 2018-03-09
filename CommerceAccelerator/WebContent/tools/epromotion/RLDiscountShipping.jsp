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
<%@ page import="com.ibm.commerce.fulfillment.objects.*" %>
<%@ page import="com.ibm.commerce.fulfillment.beans.*" %>
<%@ page import="com.ibm.commerce.fulfillment.commands.*" %>
<%@include file="epromotionCommon.jsp" %>


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=RLPromotionNLS.get("RLDiscountShipping_title")%></title>
<%=fPromoHeader%>

<jsp:useBean id="shippingModeList" scope="request" class="com.ibm.commerce.tools.epromotion.databeans.RLDiscountShippingModeDataBean">
</jsp:useBean>
<%
	com.ibm.commerce.beans.DataBeanManager.activate(shippingModeList, request);
%>

<script src="/wcs/javascript/tools/common/Util.js">
</script>

<script language="JavaScript">

var fCurr=parent.getCurrency();
var calCodeId = null;

function initializeState()
{
	
	var shippingCost="";
	var shippingAdjustmentType = 1;
	var shippingModes = new Array();
	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null) {
			var ranges = o.<%= RLConstants.RLPROMOTION_RANGES %>;
			var values = o.<%= RLConstants.RLPROMOTION_VALUES %>;
			calCodeId = o.<%= RLConstants.EC_CALCODE_ID %>;
			shippingAdjustmentType = o.<%= RLConstants.RLPROMOTION_ADJUSTMENT_TYPE %>;
			if (ranges.length == 1)
			{
				var minQual = ranges[0];
				if(eval(minQual) == 0)
				{
					document.shippingForm.minRad[0].checked = true;
					checkMinArea(false);
				}
				else if ((minQual != null) && (minQual != "") && !isNaN(minQual))
				{
					document.shippingForm.minRad[1].checked = true;
					document.shippingForm.minQual.value=parent.numberToCurrency(minQual,fCurr,"<%=fLanguageId%>");
					checkMinArea(true);
				}
				shippingCost=values[0];
			}


			var shipModes = parent.get("shippingModes", null);
			if(shipModes == null)
			{
			<%
				int i=0;
				while (i<shippingModeList.getLength())
				{
			%>
				var smode = new Object();
				smode.desc ="<%=UIUtil.toJavaScript(shippingModeList.getShipModeDesc(i).toString())%>";
				smode.id  ="<%=shippingModeList.getShipModeId(i)%>";
				shippingModes[shippingModes.length] = smode ;
			<%
				i++;
				}
			%>

			parent.put("shippingModes", shippingModes);
			}


			var allShippingModes = parent.get("shippingModes", null);
			if(allShippingModes == null)
			{
				document.shippingForm.allShippingModes.options[0] = new Option( '<%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountAllShippingModes").toString())%>', "null", true, true);
			}
			else
			{
				for ( var i=0; i< allShippingModes.length; i++) 
				{
					var shippingModeDesc = allShippingModes[i].desc;
					var shippingModeId = allShippingModes[i].id; 
					document.shippingForm.allShippingModes.options[i] = new Option( shippingModeDesc, shippingModeId, false, false);
					if(shippingModeId == eval(trim('o.<%= RLConstants.RLPROMOTION_SHIPMODEID %>')) ) 
					{
						document.shippingForm.allShippingModes.options[i].selected=true;
					}
					else				
					{
						document.shippingForm.allShippingModes.options[i].selected=false;
					}
				}
			}
           

			if (eval(shippingCost)== 0 && shippingAdjustmentType == 0)
			{
				
				document.shippingForm.hasCost[1].checked = true;
				document.shippingForm.shippingCost.value=parent.numberToCurrency(shippingCost,fCurr,"<%=fLanguageId%>");
				checkAmoArea(true);
			}
			else if (eval(shippingCost)=="" )
			{
				document.shippingForm.hasCost[0].checked = true;
				checkAmoArea(false);
			}
			else if ((shippingCost != null) && (shippingCost != "") && !isNaN(shippingCost))
			{
				if (shippingAdjustmentType == 0) {
				    document.shippingForm.hasCost[1].checked = true;
				} else if (shippingAdjustmentType == 1) {
				    document.shippingForm.hasCost[2].checked = true;
				} else if (shippingAdjustmentType == 2) {
				    document.shippingForm.hasCost[3].checked = true;
				}
				document.shippingForm.shippingCost.value=parent.numberToCurrency(shippingCost,fCurr,"<%=fLanguageId%>");
				checkAmoArea(true);
			}
		}
	}
	parent.setContentFrameLoaded(true);


	if (parent.get("currencyTooLong", false)) {
		parent.remove("currencyTooLong");
		reprompt(document.shippingForm.shippingCost,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("currencyTooLong").toString())%>");
		return;
	}
	if (parent.get("currencyInvalid", false)) {
		parent.remove("currencyInvalid");
		reprompt(document.shippingForm.shippingCost,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("currencyInvalid").toString())%>");
		return;
	}
	if (parent.get("minCurrencyTooLong", false)) {
		parent.remove("minCurrencyTooLong");
		reprompt(document.shippingForm.minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("currencyTooLong").toString())%>");
		return;
	}
	if (parent.get("minCurrencyInvalid", false)) {
		parent.remove("minCurrencyInvalid");
		reprompt(document.shippingForm.minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("minQualPurchaseAmountInvalid").toString())%>");
		return;
	}
	if (parent.get("noShipModeSelected", false)) {
		parent.remove("noShipModeSelected");
		reprompt(document.shippingForm.allShippingModes,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("shipModeNotSelected").toString())%>");
		return;
	}
}


function validatePanelData()
{
	if (document.shippingForm.hasCost[1].checked || document.shippingForm.hasCost[2].checked || document.shippingForm.hasCost[3].checked)
	{
		if (parent.currencyToNumber(trim(document.shippingForm.shippingCost.value), fCurr,"<%=fLanguageId%>").toString().length >14)
		{
			reprompt(document.shippingForm.shippingCost,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("currencyTooLong").toString())%>");
			return false;
		}
		else if ( !parent.isValidCurrency(trim(document.shippingForm.shippingCost.value), fCurr, "<%=fLanguageId%>"))
		{
			reprompt(document.shippingForm.shippingCost,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("currencyInvalid").toString())%>");
			return false;
		}
	}

	if (document.shippingForm.minRad[1].checked)
	{
		if (parent.currencyToNumber(trim(document.shippingForm.minQual.value), fCurr,"<%=fLanguageId%>").toString().length > 14)
		{
			reprompt(document.shippingForm.minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("currencyTooLong").toString())%>");
			return false;
		}
		else if ( !parent.isValidCurrency(trim(document.shippingForm.minQual.value), fCurr, "<%=fLanguageId%>"))
		{
			reprompt(document.shippingForm.minQual,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("minQualPurchaseAmountInvalid").toString())%>");
			return false;
		}
	}

	if(getSelected(document.shippingForm.allShippingModes) == "")
	{
		reprompt(document.shippingForm.allShippingModes,"<%= UIUtil.toJavaScript(RLPromotionNLS.get("shipModeNotSelected").toString())%>");
		return false;
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
	var adjustmentType=1;
	var numShip=0;
	var numMin=0;
	if (document.shippingForm.hasCost[1].checked)
	{
	    parent.put("hasShipCost",true);	
	    if (trim(document.shippingForm.shippingCost.value) != null && trim(document.shippingForm.shippingCost.value) != "")
	  	   numShip=parent.currencyToNumber(trim(document.shippingForm.shippingCost.value), fCurr,"<%=fLanguageId%>");
	  	adjustmentType=0; // 0 means: wholeOrder
	}
	if (document.shippingForm.hasCost[2].checked)
	{
	    parent.put("hasShipCost",true);	
	    if (trim(document.shippingForm.shippingCost.value) != null && trim(document.shippingForm.shippingCost.value) != "")
	  	   numShip=parent.currencyToNumber(trim(document.shippingForm.shippingCost.value), fCurr,"<%=fLanguageId%>");
	  	adjustmentType=1; // 1 means: AllAffectedItems
	}
	if (document.shippingForm.hasCost[3].checked)
	{
	    parent.put("hasShipCost",true);	
	    if (trim(document.shippingForm.shippingCost.value) != null && trim(document.shippingForm.shippingCost.value) != "")
	  	   numShip=parent.currencyToNumber(trim(document.shippingForm.shippingCost.value), fCurr,"<%=fLanguageId%>");
	  	adjustmentType=2; // 2 means: IndividualAffectedItems
	}


	if (document.shippingForm.minRad[1].checked)
	{
		parent.put("hasMinShipRang",true);
		if (trim(document.shippingForm.minQual.value) != null && trim(document.shippingForm.minQual.value) != "")
			numMin=parent.currencyToNumber(trim(document.shippingForm.minQual.value), fCurr,"<%=fLanguageId%>");
		ranges[0]=numMin;
		values[0]=numShip;
	}
	else
	{
		ranges[0]=0;
		values[0]=numShip;
	}

	if (parent.get) {
		var o = parent.get("<%= RLConstants.RLPROMOTION %>", null);
		if (o != null) {
			o.<%= RLConstants.RLPROMOTION_RANGES %> = ranges;
			o.<%= RLConstants.RLPROMOTION_VALUES %> = values;
			o.<%= RLConstants.RLPROMOTION_ADJUSTMENT_TYPE %> = adjustmentType;
			o.<%= RLConstants.RLPROMOTION_SHIPMODEID %> = getSelected(document.shippingForm.allShippingModes);
			o.<%= RLConstants.RLPROMOTION_TYPE %> = "<%= RLConstants.RLPROMOTION_ORDERLEVELFIXEDSHIPPINGDISCOUNT %>";
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

function getSelected(aComponent)
{
   for (var i=0; i< aComponent.options.length; i++) {
       if (aComponent.options[i].selected) {
	   return aComponent.options[i].value;
       }
   }
   return "";
}


function checkAmoArea(hasAmo)
{
	if (hasAmo)
	{
		document.all["amoArea"].style.display = "block";
	}
	else
	{
		document.all["amoArea"].style.display = "none";
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

<form name="shippingForm" id="shippingForm">

<h1><%=RLPromotionNLS.get("RLDiscountShipping")%></h1>
<br />

<input type="radio" name="hasCost" onclick="javascript:checkAmoArea(false);" checked ="checked" id="freeShipping" /><label for="freeShipping"><%=RLPromotionNLS.get("freeShipping")%></label><br />
<input type="radio" name="hasCost" onclick="javascript:checkAmoArea(true);" id="discountedShippingPerOrder" /><label for="discountedShippingPerOrder"><%=RLPromotionNLS.get("DiscountedShippingPerOrder")%></label><br />
<input type="radio" name="hasCost" onclick="javascript:checkAmoArea(true);" id="discountedShippingAllItems" /><label for="discountedShippingAllItems"><%=RLPromotionNLS.get("DiscountedShippingOnTotalAllAffectedItems")%></label><br />
<input type="radio" name="hasCost" onclick="javascript:checkAmoArea(true);" id="discountedShippingPerItem" /><label for="discountedShippingPerItem"><%=RLPromotionNLS.get("DiscountedShippingPerItem")%></label><br />
<div id="amoArea" style="display:none">
	<blockquote>
	<label for="shippingCosts"><%=RLPromotionNLS.get("shippingCosts")%></label><br />
	<input name="shippingCost" type="text" size="14" maxlength="21" id="shippingCosts" />
			<script language="JavaScript">
				document.write(parent.getCurrency());
			</script>
	</blockquote>
</div>

<p><label for="shippingModeTitle"><%=RLPromotionNLS.get("shippingModeTitle")%></label><br />
<select name="allShippingModes" class="selectWidth" id="shippingModeTitle">
 <!-- all available shipping Modes for the store -->
</select>
</p>

<br /><%=RLPromotionNLS.get("minQualTitle")%><br />
<input type="radio" name="minRad" onclick="javascript:checkMinArea(false);" checked ="checked" id="None" /><label for="None"><%=RLPromotionNLS.get("None")%></label><br />
<input type="radio" name="minRad" onclick="javascript:checkMinArea(true);" id="minQty" /><label for="minQty"><%=RLPromotionNLS.get("minQual")%></label>
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

</form>
</body>
</html>


