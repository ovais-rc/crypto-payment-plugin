<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c)  Copyright  IBM Corp.  2000      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@include file="eCouponCommon.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=eCouponWizardNLS.get("eCouponWizardOrderValueLevel_title")%></title>
<%=feCouponHeader%>
<script src="/wcs/javascript/tools/common/Util.js">
</script>

<script language="JavaScript">

var fCurr=parent.get("eCouponCurr");

function initializeState()
{

	var visitedOrderValueForm=parent.get("visitedOrderValueForm",false);
	if(visitedOrderValueForm) {

		if (eval(parent.get("orderType"))==0)
		{
			document.eCouponOrderValueForm.orderType[0].checked = true;
			document.eCouponOrderValueForm.orderType[0].focus();

			if(parent.get("orderPercentageAmt"))
				document.eCouponOrderValueForm.orderPercentageAmt.value = parent.get("orderPercentageAmt");
			showPercentage();

		}
		else {
			document.eCouponOrderValueForm.orderType[1].checked = true;
			document.eCouponOrderValueForm.orderType[1].focus();
			if(parent.get("orderFixedAmt"))
			document.eCouponOrderValueForm.orderFixedAmt.value = parent.numberToCurrency(parent.get("orderFixedAmt"),fCurr,"<%=fLanguageId%>");
			showFixed();
		}
	}
	else showPercentage();

	parent.setContentFrameLoaded(true);
}

function isValidPercentage(pValue, languageId)
{
	if ( !parent.isValidInteger(pValue, languageId))
	{
		return false;
	}
	else if( ! (eval(pValue) < 100))
	{
		return false;
	}
	else if (! (eval(pValue) > 0) )
	{
		return false;
	}
	return true;
}


function savePanelData()
{
		//alertDialog(" abc");
		if (document.eCouponOrderValueForm.orderType[0].checked){
			parent.put("orderType",0);

	if(isValidPercentage(trim(document.eCouponOrderValueForm.orderPercentageAmt.value),"<%=fLanguageId%>")){
		parent.put("orderPercentageAmt",parent.strToNumber(trim(document.eCouponOrderValueForm.orderPercentageAmt.value),"<%=fLanguageId%>"));
}

		}
		else {
			parent.put("orderType",1);
if(parent.isValidCurrency(trim(document.eCouponOrderValueForm.orderFixedAmt.value), fCurr, "<%=fLanguageId%>")) {
			parent.put("orderFixedAmt",parent.currencyToNumber(trim(document.eCouponOrderValueForm.orderFixedAmt.value),fCurr,"<%=fLanguageId%>"));
}
		}
		parent.put("visitedOrderValueForm",true);
		return true;
}

function validatePanelData()
{
		if (document.eCouponOrderValueForm.orderType[0].checked){
			if ((!isValidPercentage(trim(document.eCouponOrderValueForm.orderPercentageAmt.value),"<%=fLanguageId%>")) || (eval(document.eCouponOrderValueForm.orderPercentageAmt.value)==0) )
			{
				reprompt(document.eCouponOrderValueForm.orderPercentageAmt,"<%= UIUtil.toJavaScript(eCouponWizardNLS.get("percentageInvalid").toString())%>");
				return false;
			}
		}
		else {

			if(document.eCouponOrderValueForm.orderFixedAmt.value >= parent.get("minAmt")) {
			  reprompt(document.eCouponOrderValueForm.orderFixedAmt, "<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponFixedAmtInvalid").toString())%>");
			  return false;
			}
			else if (parent.currencyToNumber(trim(document.eCouponOrderValueForm.orderFixedAmt.value), fCurr,"<%=fLanguageId%>").toString().length >14)
		{
			reprompt(document.eCouponOrderValueForm.orderFixedAmt,"<%= UIUtil.toJavaScript(eCouponWizardNLS.get("currencyTooLong").toString())%>");
			return false;
		}
		else if ( (!parent.isValidCurrency(trim(document.eCouponOrderValueForm.orderFixedAmt.value), fCurr, "<%=fLanguageId%>")) || (eval(document.eCouponOrderValueForm.orderFixedAmt.value)==0))
		{
			reprompt(document.eCouponOrderValueForm.orderFixedAmt,"<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponFixedAmtInvalid").toString())%>");
			return false;
		}
	}
	return true;
}

function writeCurrency()
{
	//var storeCurrs = parent.get("storeCurrArray");
	//document.write(storeCurrs[parent.get("eCouponCurrSelectedIndex")]);
	document.write(parent.get("eCouponCurr"));
}

function showPercentage()
{
	document.all["percentage"].style.display = "block";
	document.all["fixed"].style.display = "none";
	document.eCouponOrderValueForm.orderPercentageAmt.focus();
}

function showFixed()
{
	document.all["fixed"].style.display = "block";
	document.all["percentage"].style.display = "none";
	document.eCouponOrderValueForm.orderFixedAmt.focus();
}



</script>
</head>

<body class="content" onload="initializeState();">

<form name="eCouponOrderValueForm" id="eCouponOrderValueForm">

<h1><label for="orderType"><%=eCouponWizardNLS.get("eCouponOrderValue")%></label></h1>

<input type="radio" name="orderType" onclick="javascript:showPercentage();" checked ="checked" id="orderType" />
<label for="orderPercentageAmt"><%=eCouponWizardNLS.get("eCouponPercentageOffOrder")%></label><br />
<div id="percentage" style="display:none">
	<blockquote>
		<input name="orderPercentageAmt" id="orderPercentageAmt" type="text" size="14" maxlength="3" /> <%=eCouponWizardNLS.get("percentage_symbol")%>
	</blockquote>
</div>
<input type="radio" name="orderType" onclick="javascript:showFixed();" id="orderType" />
<label for="orderFixedAmt"><%=eCouponWizardNLS.get("eCouponFixedOffOrder")%></label>
<div id="fixed" style="display:none">
	<blockquote>
		<input name="orderFixedAmt" id="orderFixedAmt" type="text" size="14" maxlength="14" />
			<script language="JavaScript">
				writeCurrency();

</script>
	</blockquote>
</div>
</form>
</body>
</html>
