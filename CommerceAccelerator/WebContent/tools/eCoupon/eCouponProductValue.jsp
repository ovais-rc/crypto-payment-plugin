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
<title><%=eCouponWizardNLS.get("eCouponWizardProductValueLevel_title")%></title>
<%=feCouponHeader%>
<script src="/wcs/javascript/tools/common/Util.js">
</script>
<script src="/wcs/javascript/tools/common/dynamiclist.js">
</script>


<script language="JavaScript">

var fCurr=parent.get("eCouponCurr");
var fixedProductArray=new Array();
var percentageProductArray=new Array();
var dynlist=0;

function initializeState()
{
	var visitedProductValueForm=parent.get("visitedProductValueForm",false);
	if(visitedProductValueForm) {
		if (eval(parent.get("productType"))==0)
		{
			document.eCouponProductValueForm.productType[0].checked = true;
			document.eCouponProductValueForm.productType[0].focus();

			if(parent.get("productPercentageAmt")) {
				document.eCouponProductValueForm.productPercentageAmt.value = parent.get("productPercentageAmt");
			}
			showPercentage();

		}
		else {
			document.eCouponProductValueForm.productType[1].checked = true;
			document.eCouponProductValueForm.productType[1].focus();
			if(parent.get("productFixedAmt")) {
				document.eCouponProductValueForm.productFixedAmt.value = parent.numberToCurrency(parent.get("productFixedAmt"),fCurr,"<%=fLanguageId%>");
			}
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
		// save the checked ones
		var checkedProducts=new Array();
		checkedProducts=getCheckedProduct();
		parent.put("checkedProducts",checkedProducts);

		if (document.eCouponProductValueForm.productType[0].checked){
			parent.put("productType",0);
		if(isValidPercentage(trim(document.eCouponProductValueForm.productPercentageAmt.value),"<%=fLanguageId%>"))
		{		parent.put("productPercentageAmt",parent.strToNumber(trim(document.eCouponProductValueForm.productPercentageAmt.value),"<%=fLanguageId%>"));
		}

		}
		else {
			parent.put("productType",1);
			if(parent.isValidCurrency(trim(document.eCouponProductValueForm.productFixedAmt.value), fCurr, "<%=fLanguageId%>")) {			parent.put("productFixedAmt",parent.currencyToNumber(trim(document.eCouponProductValueForm.productFixedAmt.value),fCurr,"<%=fLanguageId%>"));
		}
		}
		parent.put("visitedProductValueForm",true);
		return true;
}

function validatePanelData()
{
	// Check if any product is selected from the purchase condition
	var checkedProducts=new Array();
	checkedProducts=getCheckedProduct();
	if(checkedProducts.length <= 0 ) {
		alertDialog('<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponNoProductSelected").toString())%>');
		return false;
	}

	if (document.eCouponProductValueForm.productType[0].checked){
			if ((!isValidPercentage(trim(document.eCouponProductValueForm.productPercentageAmt.value),"<%=fLanguageId%>")) || (eval(document.eCouponProductValueForm.productPercentageAmt.value)==0))
			{
				reprompt(document.eCouponProductValueForm.productPercentageAmt,"<%= UIUtil.toJavaScript(eCouponWizardNLS.get("percentageInvalid").toString())%>");
				return false;
			}
		}
	else {
			if (parent.currencyToNumber(trim(document.eCouponProductValueForm.productFixedAmt.value), fCurr,"<%=fLanguageId%>").toString().length >14)
		{
			reprompt(document.eCouponProductValueForm.productFixedAmt,"<%= UIUtil.toJavaScript(eCouponWizardNLS.get("currencyTooLong").toString())%>");
			return false;
		}
	else if ( (!parent.isValidCurrency(trim(document.eCouponProductValueForm.productFixedAmt.value), fCurr, "<%=fLanguageId%>")) || (eval(document.eCouponProductValueForm.productFixedAmt.value)==0))
		{
			reprompt(document.eCouponProductValueForm.productFixedAmt,"<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponFixedAmtInvalid").toString())%>");
			return false;
		}
	}
	return true;
}

function writeCurrency()
{
	document.write(parent.get("eCouponCurr"));
}

function showPercentage()
{
	document.all["percentage"].style.display = "block";
	document.all["fixed"].style.display = "none";
	document.eCouponProductValueForm.productPercentageAmt.focus();
}

function showFixed()
{
	document.all["fixed"].style.display = "block";
	document.all["percentage"].style.display = "none";
	document.eCouponProductValueForm.productFixedAmt.focus();
}

function getCheckedProduct()
{
	if(document.eCouponProductValueForm.productType[0].checked) {
		return percentageProductArray;
	}
	else {
		return fixedProductArray;
	}
}

// added for modify coupon promotion
// return true if item is checked
function isChecked(index)
{
	var tempChecked = parent.get("checkedProducts", null);
	if (tempChecked != null)
	{
		for(j=0 ; j < tempChecked.length; j++)
		{
			if (index == tempChecked[j])
			{
				return true;
			}
		}
	}
	return false;
}

function addIndex(index)
{
	if(document.eCouponProductValueForm.productType[0].checked) {
		// if it was there then remove it for clicking twice
		percentageProductArray = removeIndex(index,percentageProductArray);
	}
	else {
		fixedProductArray = removeIndex(index,fixedProductArray);
	}
	return true;
}

function removeIndex(index,pArray) {
	var tempArray=new Array();
	var added=false;
	for(i=0 ; i < pArray.length ; i++) {
		if( pArray[i] != index ) {
			tempArray[tempArray.length]=pArray[i];
		}
		else added=true;
	}
	if(added == false) tempArray[tempArray.length]=index;
	return tempArray;
}

// added for modify coupon promotion
function addDlistCheckState(name,fnc,state)
{
   var len = arguments.length;
   document.writeln("<TD CLASS=\""+list_check_style+"\"><INPUT TYPE=\"checkbox\"");
   if( len>0 && name != null ){
       if( len>1 && fnc != null && !testNone(fnc.toLowerCase()) ){
           document.write(" NAME=\""+name+"\" onClick=\""+fnc+"\"");
       }else{
           document.write(" NAME=\""+name+"\" onClick=\"parent.setChecked()\"");
       }
       if( len>2 && state != null && !testNone(state.toLowerCase()) ){
           document.write(" CHECKED");
       }
   }
   document.write("></TD>");
}


</script>
</head>

<body class="content" onload="initializeState();">
<form name="eCouponProductValueForm" id="eCouponProductValueForm">
<h1><label for="productType"><%=eCouponWizardNLS.get("eCouponProductValue")%></label></h1>

<input type="radio" name="productType" onclick="javascript:showPercentage();" checked ="checked" id="productType" />
<label for="productPercentageAmt"><%=eCouponWizardNLS.get("eCouponPercentageOffProduct")%></label><br />

<div id="percentage" style="display:none">
	<blockquote>
		<input name="productPercentageAmt" id="productPercentageAmt" type="text" size="14" maxlength="3" /> <%=eCouponWizardNLS.get("percentage_symbol")%>  <p>
<%=eCouponWizardNLS.get("eCouponProductTblList")%></p><p>
<script>
document.write("<table width=\"90%\"><tr><td>");
startDlistTable('<%= UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponProductTblList"))%>');
startDlistRowHeading();
addDlistColumnHeading("",false);
addDlistColumnHeading('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponProductSKU"))%>', null, false);
addDlistColumnHeading('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponProductQty"))%>'+'<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("byUnit"))%>', null, false);
endDlistRow();
 if(eval(parent.get("purchaseConditionType"))==0)
   {
      var products=new Array();
      var rowColor = 1;

      var classId = "list_row1";
      if(parent.get("product"))
      {
      	products=parent.get("product");

	dynlist = products.length;
      	for (var i=0; i < products.length; i++)
      	{
		startDlistRow(rowColor);

		// start added for modify coupon promotion
		if (isChecked(i) && (eval(parent.get("productType"))== 0))
		{
         		addDlistCheckState(i,'addIndex('+i+')','C');
			percentageProductArray = removeIndex(i, percentageProductArray);
		}
		else
		{
			addDlistCheck(i,'addIndex('+i+')');
		}
		// end added for modify coupon promotion

         	addDlistColumn(products[i].productSKU);
         	addDlistColumn(products[i].qty);
		endDlistRow();

		if (rowColor == 1)
            		rowColor = 2;
         	else
            		rowColor = 1;
      	}
      }
   }
	endDlistTable();
document.write("</td></tr></table>");

</script>
	</p></blockquote>
</div>

<input type="radio" name="productType" onclick="javascript:showFixed();" id="productType" />
<label for="productFixedAmt"><%=eCouponWizardNLS.get("eCouponFixedOffProduct")%></label><br />

<div id="fixed" style="display:none">
	<blockquote>
		<input name="productFixedAmt" id="productFixedAmt" type="text" size="14" maxlength="14" />
			<script language="JavaScript">
				writeCurrency();
			</script>  <p>

<%=eCouponWizardNLS.get("eCouponProductTblList")%></p><p>
	<script>
document.write("<table width=\"90%\"><tr><td>");
startDlistTable('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponProductTblList"))%>');
startDlistRowHeading();
addDlistColumnHeading("",false);
addDlistColumnHeading('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponProductSKU"))%>', null, false);
addDlistColumnHeading('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponProductQty"))%>'+'<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("byUnit"))%>', null, false);
endDlistRow();
 if(eval(parent.get("purchaseConditionType"))==0)
   {
      var products=new Array();
      if(parent.get("product")) {
        products=parent.get("product");
      	var classId = "list_row1";
	var rowColor = 1;


	dynlist = products.length;
      	for (var i=0; i < products.length; i++)
      	{
			startDlistRow(rowColor);

		// end added for modify coupon promotion
		if (isChecked(i) && (eval(parent.get("productType"))== 1))
		{
         		addDlistCheckState(i,'addIndex('+i+')','C');
			fixedProductArray = removeIndex(i, fixedProductArray);
		}
		else
		{
			addDlistCheck(i,'addIndex('+i+')');
		}
		// end added for modify coupon promotion

         	addDlistColumn(products[i].productSKU);
         	addDlistColumn(products[i].qty);
		endDlistRow();
		if (rowColor == 1)
            		rowColor = 2;
         	else
            		rowColor = 1;
      }
     }
   }
endDlistTable();
document.write("</td></tr></table>");

</script>

	</p></blockquote>
</div>
</form>
</body>
</html>
