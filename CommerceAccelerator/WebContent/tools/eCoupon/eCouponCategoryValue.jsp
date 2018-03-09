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
<title><%=eCouponWizardNLS.get("eCouponWizardCategoryValueLevel_title")%></title>
<%=feCouponHeader%>
<script src="/wcs/javascript/tools/common/Util.js">
</script>
<script src="/wcs/javascript/tools/common/dynamiclist.js">
</script>


<script language="JavaScript">

var fCurr=parent.get("eCouponCurr");
var fixedCategoryArray=new Array();
var percentageCategoryArray=new Array();
var dynlist=0;

function initializeState()
{
	var visitedCategoryValueForm=parent.get("visitedCategoryValueForm",false);
	if(visitedCategoryValueForm) {

		if (eval(parent.get("categoryType"))==0)
		{
			document.eCouponCategoryValueForm.categoryType[0].checked = true;
			document.eCouponCategoryValueForm.categoryType[0].focus();

			if(parent.get("categoryPercentageAmt")) {
				document.eCouponCategoryValueForm.categoryPercentageAmt.value =
					parent.get("categoryPercentageAmt");
			}
			showPercentage();

		}
		else {
			document.eCouponCategoryValueForm.categoryType[1].checked = true;
			document.eCouponCategoryValueForm.categoryType[1].focus();
			if(parent.get("categoryFixedAmt")) {
				document.eCouponCategoryValueForm.categoryFixedAmt.value =
					parent.numberToCurrency(parent.get("categoryFixedAmt"),fCurr,"<%=fLanguageId%>");
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
	else if(  (eval(pValue) > 100))
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
		var checkedCategorys=new Array();
		checkedCategorys=getCheckedCategory();
		parent.put("checkedCategorys",checkedCategorys);

		if (document.eCouponCategoryValueForm.categoryType[0].checked){
			parent.put("categoryType",0);
		if(isValidPercentage(trim(document.eCouponCategoryValueForm.categoryPercentageAmt.value),"<%=fLanguageId%>"))
		{
			parent.put("categoryPercentageAmt",parent.strToNumber(trim(document.eCouponCategoryValueForm.categoryPercentageAmt.value),"<%=fLanguageId%>"));
		}

		}
		else {
			parent.put("categoryType",1);
			if(parent.isValidCurrency(trim(document.eCouponCategoryValueForm.categoryFixedAmt.value), fCurr, "<%=fLanguageId%>")) {
			parent.put("categoryFixedAmt",parent.currencyToNumber(trim(document.eCouponCategoryValueForm.categoryFixedAmt.value),fCurr,"<%=fLanguageId%>"));
		}
		}
		parent.put("visitedCategoryValueForm",true);
		return true;
}

function validatePanelData()
{
	// Check if any category is selected from the purchase condition
	var checkedCategorys=new Array();
	checkedCategorys=getCheckedCategory();
	if(checkedCategorys.length <= 0 ) {
		alertDialog('<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponNoCategorySelected").toString())%>');
		return false;
	}

	if (document.eCouponCategoryValueForm.categoryType[0].checked){
			if ((!isValidPercentage(trim(document.eCouponCategoryValueForm.categoryPercentageAmt.value),"<%=fLanguageId%>")) || (eval(document.eCouponCategoryValueForm.categoryPercentageAmt.value)==0))
			{
				reprompt(document.eCouponCategoryValueForm.categoryPercentageAmt,"<%= UIUtil.toJavaScript(eCouponWizardNLS.get("percentageInvalid").toString())%>");
				return false;
			}
		}
	else {
			if (parent.currencyToNumber(trim(document.eCouponCategoryValueForm.categoryFixedAmt.value), fCurr,"<%=fLanguageId%>").toString().length >14)
		{
			reprompt(document.eCouponCategoryValueForm.categoryFixedAmt,"<%= UIUtil.toJavaScript(eCouponWizardNLS.get("currencyTooLong").toString())%>");
			return false;
		}
	else if ( (!parent.isValidCurrency(trim(document.eCouponCategoryValueForm.categoryFixedAmt.value), fCurr, "<%=fLanguageId%>")) || (eval(document.eCouponCategoryValueForm.categoryFixedAmt.value)==0))
		{
			reprompt(document.eCouponCategoryValueForm.categoryFixedAmt,"<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponFixedAmtInvalid").toString())%>");
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
	document.eCouponCategoryValueForm.categoryPercentageAmt.focus();
}

function showFixed()
{
	document.all["fixed"].style.display = "block";
	document.all["percentage"].style.display = "none";
	document.eCouponCategoryValueForm.categoryFixedAmt.focus();
}

function getCheckedCategory()
{
	if(document.eCouponCategoryValueForm.categoryType[0].checked) {
		return percentageCategoryArray;
	}
	else {
		return fixedCategoryArray;
	}
}

function addIndex(index)
{
	if(document.eCouponCategoryValueForm.categoryType[0].checked) {
		// if it was there then remove it for clicking twice
		percentageCategoryArray = removeIndex(index,percentageCategoryArray);
	}
	else {
		fixedCategoryArray = removeIndex(index,fixedCategoryArray);
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
   document.writeln("<td class=\""+list_check_style+"\"><input type=\"checkbox\"");
   if( len>0 && name != null ){
       if( len>1 && fnc != null && !testNone(fnc.toLowerCase()) ){
           document.write(" name=\""+name+"\" onclick=\""+fnc+"\"");
       }else{
           document.write(" name=\""+name+"\" onclick=\"parent.setChecked()\"");
       }
       if( len>2 && state != null && !testNone(state.toLowerCase()) ){
           document.write(" checked ='checked' ");
       }
   }
   document.write("></td>");
}

// added for modify coupon promotion
// return true if item is checked
function isChecked(index)
{
	var tempChecked = parent.get("checkedCategorys", null);
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


</script>
</head>

<body class="content_list" onload="initializeState();">
<form name="eCouponCategoryValueForm" id="eCouponCategoryValueForm">
<h1><label for="categoryType"><%=eCouponWizardNLS.get("eCouponCategoryValue")%></label></h1>

<input type="radio" name="categoryType" onclick="javascript:showPercentage();" checked ="checked" id="categoryType" />
<label for="categoryPercentageAmt"><%=eCouponWizardNLS.get("eCouponPercentageOffCategory")%></label><br />

<div id="percentage" style="display:none">
	<blockquote>
		<input name="categoryPercentageAmt" id="categoryPercentageAmt" type="text" size="14" maxlength="3" /> <%=eCouponWizardNLS.get("percentage_symbol")%>  <p>
<%=eCouponWizardNLS.get("eCouponCategoryTblList")%></p><p>
<script>
document.write("<table width=\"90%\"><tr><td>");
startDlistTable('<%= UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponCategoryTblList"))%>');
startDlistRowHeading();
addDlistColumnHeading("",false);
addDlistColumnHeading('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponCategorySKU"))%>', null, false);
addDlistColumnHeading('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponCategoryShortMinQty"))%>', null, false);
addDlistColumnHeading('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponCategoryShortMaxQty"))%>', null, false);
addDlistColumnHeading('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponCategoryShortMinAmt"))%>', null, false);
addDlistColumnHeading('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponCategoryShortMaxAmt"))%>', null, false);

endDlistRow();
 if(eval(parent.get("purchaseConditionType"))==2)
   {
      var categorys=new Array();
      var rowColor = 1;

      if(parent.get("category"))
      {
      	categorys=parent.get("category");

	dynlist = categorys.length;
      	for (var i=0; i < categorys.length; i++)

      	{
		startDlistRow(rowColor);

		// end added for modify coupon promotion
		if (isChecked(i) && (eval(parent.get("categoryType"))== 0))
		{
         		addDlistCheckState(i,'addIndex('+i+')','C');
			percentageCategoryArray = removeIndex(i, percentageCategoryArray);
		}
		else
		{
			addDlistCheck(i,'addIndex('+i+')');
		}
         	// end added for modify coupon promotion

         	addDlistColumn(categorys[i].categorySKU);
         	addDlistColumn(categorys[i].minCatQty);
         	addDlistColumn(categorys[i].maxCatQty);
         	addDlistColumn(categorys[i].minCatAmt);
         	addDlistColumn(categorys[i].maxCatAmt);

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

<input type="radio" name="categoryType" onclick="javascript:showFixed();" id="categoryType" />
<label for="categoryFixedAmt"><%=eCouponWizardNLS.get("eCouponFixedOffCategory")%></label><br />

<div id="fixed" style="display:none">
	<blockquote>
		<input name="categoryFixedAmt" id="categoryFixedAmt" type="text" size="14" maxlength="14" />
			<script language="JavaScript">
				writeCurrency();
			</script>

<p><%=eCouponWizardNLS.get("eCouponCategoryTblList")%></p>
	<script>
document.write("<table width=\"90%\"><tr><td>");
startDlistTable('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponCategoryTblList"))%>');
startDlistRowHeading();
addDlistColumnHeading("",false);
addDlistColumnHeading('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponCategorySKU"))%>', null, false);
addDlistColumnHeading('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponCategoryShortMinQty"))%>', null, false);
addDlistColumnHeading('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponCategoryShortMaxQty"))%>', null, false);
addDlistColumnHeading('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponCategoryShortMinAmt"))%>', null, false);
addDlistColumnHeading('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponCategoryShortMaxAmt"))%>', null, false);

endDlistRow();

 if(eval(parent.get("purchaseConditionType"))==2)
   {
      var categorys=new Array();
      if(parent.get("category")) {
        categorys=parent.get("category");
	var rowColor = 1;


	dynlist = categorys.length;
      	for (var i=0; i < categorys.length; i++)
      	{
		startDlistRow(rowColor);

		// end added for modify coupon promotion
		if (isChecked(i) && (eval(parent.get("categoryType"))== 1))
		{
         		addDlistCheckState(i,'addIndex('+i+')','C');
			fixedCategoryArray = removeIndex(i, fixedCategoryArray);
		}
		else
		{
			addDlistCheck(i,'addIndex('+i+')');
		}
		// end added for modify coupon promotion

         	addDlistColumn(categorys[i].categorySKU);
         	addDlistColumn(categorys[i].minCatQty);
         	addDlistColumn(categorys[i].maxCatQty);
         	addDlistColumn(categorys[i].minCatAmt);
         	addDlistColumn(categorys[i].maxCatAmt);
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

	</blockquote>
</div>
</form>
</body>
</html>
