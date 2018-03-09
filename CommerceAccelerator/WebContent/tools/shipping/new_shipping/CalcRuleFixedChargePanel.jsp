<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.shipping.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.fulfillment.beans.*" %>


<%@ include file="ShippingCommon.jsp" %>
<%@ include file="../../common/NumberFormat.jsp" %>

<%
	try {
  	CalcRuleDetailsDataBean ruleBean = new CalcRuleDetailsDataBean();
  	String calcRuleId = request.getParameter(ShippingConstants.PARAMETER_CALCRULE_ID);
	boolean foundCalcRuleId = (calcRuleId != null && calcRuleId.length() > 0);
    String readOnly = request.getParameter(ShippingConstants.PARAMETER_READONLY);
    boolean editable = (readOnly == null || readOnly.equals("")|| readOnly.equalsIgnoreCase("false"));
    String disabledString = " disabled";
    if(editable){
    	disabledString = "";
    }
		
	try{
		DataBeanManager.activate(ruleBean, request);
	}
	catch(Exception e){
		e.printStackTrace();
	}
	
	RangeCharges fixCharge = ruleBean.getFixedCharges();
	String defaultCurrency = ruleBean.getPreferredCurrency();
	String[] currencies = ruleBean.getStoreCurrencies();
	System.out.println("numberOfCurrencies " + currencies.length);

%>

<html><head>
<%= fHeader %>
<style type='text/css'>
.selectWidth {width: 200px;}
.selectWidenWidth {width: 300px;}
.disabledBox {background: #c0c0c0;}
.enabledBox {background: #ffffff;}
</style>
<title><%= shippingRB.get(ShippingConstants.MSG_CALCRULE_CHARGES_PANEL_TITLE) %></title>
<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/shipping/ShippingUtil.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/shipping/ShipCharges.js"></script>
<script language="JavaScript">
<!---- hide script from old browsers


var isSummary=<%=(request.getParameter(ShippingConstants.PARAMETER_IS_SUMMARY) == null ? "null" : UIUtil.toJavaScript(request.getParameter(ShippingConstants.PARAMETER_IS_SUMMARY)))%>;
var storeLanguageId = '<%=fLanguageId%>';
var preferredCurrency = '<%=defaultCurrency%>';
var errorReported=false; 
var storeCurrencies = new Array();
var debug = false;
<%
for(int i=0;i<currencies.length;i++) {
%>
  storeCurrencies[<%= i %> ]='<%= currencies[i] %>';
<%
}
%>


var fixedCharges = new Array();  // supposed to be hashtable to keep currency-charge pairs


function newCurrencySelected(){

	with (document.fixedChargeForm) {

		var num2cur = '';
		if (fixedCharges[currencySelect.value] != null && fixedCharges[currencySelect.value].length != 0) {
			var num2cur = parent.numberToCurrency(fixedCharges[currencySelect.value],currencySelect.value, storeLanguageId)
		}
		//var num2cur = (fixedCharges[currencySelect.value] != undefined ? parent.numberToCurrency(fixedCharges[currencySelect.value], currencySelect.value, storeLanguageId) : "");
 		loadValue(fixedChargeInput, num2cur);
 		
 	}
			
     
}

function chargeInputOnBlur() {

  	with (document.fixedChargeForm) {
		fixedChargeInput.value = trim(fixedChargeInput.value);
 	
 		validationFailed=false;
  
  		var inputIsValidCurrency = isValidCurrency(fixedChargeInput.value, currencySelect.value, storeLanguageId);
 		var inputIsNull = fixedChargeInput.value == "";

  		if (!inputIsValidCurrency && !inputIsNull) {

    		errorReported=true;  
    		validationFailed=true;

    		fixedChargeInput.select();
    		parent.alertDialog("<%=UIUtil.toJavaScript(shippingRB.get(ShippingConstants.MSG_CURRENCY_INVALID))%>");
    		fixedChargeInput.focus();

    		errorReported=false;  
    		return false;

  		}

  		var cur2num = "";
 		var num2cur = "";

  		if (inputIsValidCurrency) {

    		cur2num = currencyToNumber(fixedChargeInput.value, currencySelect.value, storeLanguageId);  
    		num2cur = numberToCurrency(cur2num, currencySelect.value, storeLanguageId);

    		cur2numstr = new String(cur2num);

    		if (cur2numstr.length > 14) {
      			errorReported=true;  
      			validationFailed=true;

      			fixedChargeInput.select();
      			parent.alertDialog("<%=UIUtil.toJavaScript(shippingRB.get(ShippingConstants.MSG_CHARGE_TOO_LONG))%>");
      			fixedChargeInput.focus();
    
      			errorReported=false;  
      			return false;
    		}

  		}
  
  
        if(debug == true ) alert("currencySelect.value " + currencySelect.value);
  	  	fixedCharges[currencySelect.value] = cur2num;
   	 	fixedChargeInput.value=num2cur;
  	  	resizeChargeInput();
  	  	
  } // end of with

  return true;

}

function maxFormattedCurrencyLength(currencies) {
  var maxFormattedCurrencyLength = 0;
  
    for(var j=0; j < currencies.length; j++) {
      var inputLength = parent.numberToCurrency(fixedCharges[currencies[j]], currencies[j], storeLanguageId).length;
      if (inputLength > maxFormattedCurrencyLength) {
        maxFormattedCurrencyLength = inputLength;
      }
    }
 
  return maxFormattedCurrencyLength;
}

function resizeChargeInput() {
  currencyInputSize = maxFormattedCurrencyLength(storeCurrencies);
  if(currencyInputSize < 15){
  	 currencyInputSize = 15;
  }
  //fixedChargeInput.size = currencyInputSize;
  
}



function loadPanelData(){

	with (document.fixedChargeForm) {
	    	if (parent.setContentFrameLoaded) {
			parent.setContentFrameLoaded(true);
		}
	
		if (parent.get) {
			var o = parent.get("<%= ShippingConstants.ELEMENT_CALCRULE_DETAILS_BEAN %>", null);
			if (o != null) {
				
				<% if (fixCharge != null) {
					for(int i=0;i<currencies.length;i++) { 
						BigDecimal currCurrencyPrice = fixCharge.getCurrencyCharge(currencies[i]); %>
						fixedCharges["<%=currencies[i]%>"]=<%=(currCurrencyPrice != null ? currCurrencyPrice.toString() : "''")%>;         
					<% }
				} %>
			}
				
			if( fixedCharges == null ){ 
				fixedCharges = new Array();
			}
			
			// set selected index to the store's preferred currency 
			currencyIndex = indexOfValueList(currencySelect, preferredCurrency);
				
			if(currencyIndex >= 0){
				currencySelect.selectedIndex = currencyIndex;
				var num2cur = '';
				if (fixedCharges[currencySelect.value] != null && fixedCharges[currencySelect.value].length != 0) {
					var num2cur = parent.numberToCurrency(fixedCharges[currencySelect.value],currencySelect.value, storeLanguageId)
				}
				//var num2cur = (fixedCharges[currencySelect.value] != null ? parent.numberToCurrency(fixedCharges[currencySelect.value], 																	currencySelect.value, storeLanguageId) : "");
				loadValue(fixedChargeInput, num2cur);
			}

			
		}
		
		if (parent.get("chargeValueTooLong", false)) {
				parent.remove("chargeValueTooLong");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CHARGE_TOO_LONG)) %>");
				fixedChargeInput.select();
				fixedChargeInput.focus();
				return;
		}
		
		if (parent.get("currencyInvalid", false)) {
				parent.remove("currencyInvalid");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CURRENCY_INVALID)) %>");
				fixedChargeInput.select();
				fixedChargeInput.focus();
				return;
		}
	if ( ("<%=disabledString%>" == "") ||("<%=disabledString%>" == null)){
		fixedChargeInput.focus();
		}
	}
}



function validatePanelData() {

	//for(var i=0;i<storeCurrencies.length;i++) {
		if(fixedCharges[preferredCurrency].length == 0) {
			for (var i=0; i < document.fixedChargeForm.currencySelect.length; i++) {
				if (document.fixedChargeForm.currencySelect[i].value = preferredCurrency) {
					document.fixedChargeForm.currencySelect[i].selected = true;
					document.fixedChargeForm.fixedChargeInput.value="";
					if ( ("<%=disabledString%>" == "") ||("<%=disabledString%>" == null)){
						document.fixedChargeForm.fixedChargeInput.focus();
					}
					break;
				}
			}
        		alertDialog("<%=UIUtil.toJavaScript(shippingRB.get(ShippingConstants.MSG_MANDATORY_DEFAULT_CURRENCY_CHARGE))%>");
        		return false;
      		}
    	//}  

	//validation of the fixed charge input is done with onblur event for the charge input field
	return true;

}



function savePanelData() {

   if(!isSummary) {
  	with (document.fixedChargeForm) {
		if (parent.get) {
			var o = parent.get("<%= ShippingConstants.ELEMENT_CALCRULE_DETAILS_BEAN %>", null);
			if (o != null) {
				var rangeCharges = new Object();
				rangeCharges.startingNumberOfUnits = 0;
				if( debug == true ) alert("fixedCharges " + fixedCharges[currencySelect.value]);
				var fixedCharges1 = new Array();
				
				for(var i=0; i < storeCurrencies.length; i++) {
					//if (fixedCharges[storeCurrencies[i]] == null || fixedCharges[storeCurrencies[i]] == '') {
					//	fixedCharges1[i] = 0;
					//} else {
						fixedCharges1[i] = fixedCharges[storeCurrencies[i]];
					//}
				}
				
				rangeCharges.currencyCharges = fixedCharges1;
				o.<%= ShippingConstants.ELEMENT_SCALE_LOOKUP_METHOD %> = <%=(new Integer(ShippingConstants.CALSCALE_CALMETHOD_ID_QUANTITY).toString()) %>;
				o.<%= ShippingConstants.ELEMENT_RANGE_METHOD %> = <%= (new Integer(ShippingConstants.CALRANGE_CALMETHOD_ID_FIXED).toString()) %>;
				o.<%= ShippingConstants.ELEMENT_FIXED_CHARGES %> = fixedCharges1;
				o.<%= ShippingConstants.ELEMENT_UNIT_OF_MEASURE %> = null
				o.<%= ShippingConstants.ELEMENT_RANGES %> = null;
				var shjrules = o.<%= ShippingConstants.ELEMENT_SHPJRULES %>;
			}
		}
	}
  }
  else {
    top.goBack();
  }
}

//-->
</script>
<meta name="GENERATOR" content="IBM WebSphere Studio">
</head>



<body onload="loadPanelData()" class="content">

<h1><%=UIUtil.toHTML((String) shippingRB.get("fixedChargesPrompt"))%></h1>
<LINE3><%=UIUtil.toHTML((String) shippingRB.get("calcRuleFixedChargeDesc"))%></LINE3>

<p>
<form name="fixedChargeForm">


<%=UIUtil.toHTML((String)shippingRB.get(ShippingConstants.MSG_CURRENCY_PROMPT))%><BR>
	<LABEL for="currencySelect">
	<select name="currencySelect" id="currencySelect" onchange="newCurrencySelected()" <%=disabledString%>>
		<script>
			document.writeln('<option value="' + preferredCurrency + '"> ' + preferredCurrency + ' -- <%=UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_PREFFERED_CURRENCY))%></option>');
			for(var i=0;i < storeCurrencies.length; i++) {
				if (storeCurrencies[i]!=preferredCurrency) {
    				document.writeln('<option value="' + storeCurrencies[i] + '"> ' + storeCurrencies[i] + '</option>');
  				}
			}
		</script>
	</select>
	</LABEL>
</p>
<p><%= shippingRB.get(ShippingConstants.MSG_SHIP_CHARGE_PROMPT) %><br/>
	<LABEL for="fixedChargeInput"><input name="fixedChargeInput" id="fixedChargeInput" type="text" size="30" maxlength="64" onblur="chargeInputOnBlur()" <%=disabledString%>></LABEL>
	
</p>


</form>

</body>

</html>
<% } catch (Exception e) { e.printStackTrace();} %>