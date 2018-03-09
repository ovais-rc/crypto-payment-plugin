<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c)  Copyright  IBM Corp.  2000      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<?xml version="1.0"?>
<%@include file="eCouponCommon.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=eCouponWizardNLS.get("eCouponWizardOrderLevel_title")%></title>
<%=feCouponHeader%>
<script src="/wcs/javascript/tools/common/Util.js">
</script>
<script src="/wcs/javascript/tools/common/DateUtil.js">
</script>

<script language="JavaScript">
var fCurr=parent.get("eCouponCurr");

function initializeState()
{
	var visitedOrderPurchaseCondition=parent.get("visitedOrderPurchaseCondition",false);
	if(visitedOrderPurchaseCondition) {
	        if(parent.get("minAmt"))
		document.orderPurchaseConditionForm.minAmt.value=parent.numberToCurrency(parent.get("minAmt"),fCurr,"<%=fLanguageId%>");

		var hasMax=parent.get("hasMax",false);
		if(hasMax) {
		//if((parent.get("maxAmt") != null) && (parent.get("maxAmt") != "")) {
	        	if(parent.get("maxAmt"))
			document.orderPurchaseConditionForm.maxAmt.value=parent.numberToCurrency(parent.get("maxAmt"),fCurr,"<%=fLanguageId%>");
			document.orderPurchaseConditionForm.maxProvided.checked = true;
			showMax();

		}
		else
			document.orderPurchaseConditionForm.maxProvided.checked = false;
	}
	document.orderPurchaseConditionForm.minAmt.focus();
	parent.setContentFrameLoaded(true);
	return true;
}
function savePanelData()
{
	//alertDialog(" Saving Order Purchase Data");
	if ( parent.isValidCurrency(trim(document.orderPurchaseConditionForm.minAmt.value), fCurr, "<%=fLanguageId%>"))
	parent.put("minAmt",parent.currencyToNumber(trim(document.orderPurchaseConditionForm.minAmt.value),fCurr,"<%=fLanguageId%>"));

	if(document.orderPurchaseConditionForm.maxProvided.checked) {
	//if((document.orderPurchaseConditionForm.maxAmt.value != null) && (document.orderPurchaseConditionForm.maxAmt.value != "")) {
		parent.put("hasMax",true);
		if ( parent.isValidCurrency(trim(document.orderPurchaseConditionForm.maxAmt.value), fCurr, "<%=fLanguageId%>"))
		parent.put("maxAmt",parent.currencyToNumber(trim(document.orderPurchaseConditionForm.maxAmt.value),fCurr,"<%=fLanguageId%>"));
	}
	else parent.put("hasMax",false);
	parent.put("visitedOrderPurchaseCondition",true);
	return true;
}
function validatePanelData()
{
	//alertDialog("Validating Order Purchase Data");
	if (parent.currencyToNumber(trim(document.orderPurchaseConditionForm.minAmt.value), fCurr,"<%=fLanguageId%>").toString().length > 14)
		{
			reprompt(document.orderPurchaseConditionForm.minAmt,"<%= UIUtil.toJavaScript(eCouponWizardNLS.get("currencyTooLong").toString())%>");
			parent.put("visitedOrderPurchaseCondition",false);
			return false;
		}
	else if ( !parent.isValidCurrency(trim(document.orderPurchaseConditionForm.minAmt.value), fCurr, "<%=fLanguageId%>"))
		{
			reprompt(document.orderPurchaseConditionForm.minAmt,"<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponMinAmtInvalid").toString())%>");
			parent.put("visitedOrderPurchaseCondition",false);
			return false;
		}
	else if ( document.orderPurchaseConditionForm.minAmt.value <= 0)
		{
			reprompt(document.orderPurchaseConditionForm.minAmt,"<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponMinAmtInvalid").toString())%>");
			parent.put("visitedOrderPurchaseCondition",false);
			return false;
		}

	if(document.orderPurchaseConditionForm.maxProvided.checked) {
			if (parent.currencyToNumber(trim(document.orderPurchaseConditionForm.maxAmt.value), fCurr,"<%=fLanguageId%>").toString().length > 14)
		{
			reprompt(document.orderPurchaseConditionForm.maxAmt,"<%= UIUtil.toJavaScript(eCouponWizardNLS.get("currencyTooLong").toString())%>");
			parent.put("visitedOrderPurchaseCondition",false);
			return false;
		}
		else if ( !parent.isValidCurrency(trim(document.orderPurchaseConditionForm.maxAmt.value), fCurr, "<%=fLanguageId%>"))
		{
			reprompt(document.orderPurchaseConditionForm.maxAmt,"<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponMaxAmtInvalid").toString())%>");
			parent.put("visitedOrderPurchaseCondition",false);
			return false;
		}
		// Max shud be greater than Min
		if ((parent.currencyToNumber(trim(document.orderPurchaseConditionForm.maxAmt.value),fCurr,"<%=fLanguageId%>"))  <= (parent.currencyToNumber(trim(document.orderPurchaseConditionForm.minAmt.value),fCurr,"<%=fLanguageId%>")))
		{
			reprompt(document.orderPurchaseConditionForm.maxAmt,"<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponMaxMinInvalid").toString())%>");
			parent.put("visitedOrderPurchaseCondition",false);
			return false;
		}

	}
	return true;

}
function writeCurrency()
{
	var storeCurrs;
	//alertDialog(" Inside Store curr");
	storeCurrs = parent.get("storeCurrArray");
	//alertDialog(" Store Currency got ");
	document.write(storeCurrs[parent.get("eCouponCurrSelectedIndex")]);
}

function showMax() {
	if(document.orderPurchaseConditionForm.maxProvided.checked == true) {
		document.all["max"].style.display = "block";
		document.orderPurchaseConditionForm.maxAmt.focus();

		}
	else
		document.all["max"].style.display = "none";
}
//function hideMax() {
//	document.all["max"].style.display = "none";
//}


</script>
</head>

<body class="content" onload="initializeState();">
<form name="orderPurchaseConditionForm" id="orderPurchaseConditionForm">
<h1><%=eCouponWizardNLS.get("eCouponOrderPurchase")%></h1>
<label for="minAmt"><%=eCouponWizardNLS.get("eCouponMinAmt")%></label><br />
<input name="minAmt" type="text" size="14" maxlength="14" id="minAmt" />
	<script language="JavaScript">
		writeCurrency();

</script>
<p>
<label for="maxProvided"></label><input type="checkbox" name="maxProvided" onclick="javascript:showMax();" id="maxProvided" />
<label for="maxAmt"> <%=eCouponWizardNLS.get("eCouponMaxAmt")%> </label><br />
</p><div id="max" style="display:none">
<blockquote>
<input name="maxAmt" id="maxAmt" type="text" size="14" maxlength="14" />
	<script language="JavaScript">
		writeCurrency();

</script>
</blockquote>
</div>
</form>
<script>
parent.setContentFrameLoaded(true);

</script>
</body>
</html>
