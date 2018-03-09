

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ page language="java" %>

<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.contract.beans.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.payment.beans.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.commands.ECOptoolsConstants" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.order.beans.OrderDataBean" %>
<%@ page import="com.ibm.commerce.edp.api.EDPPaymentInstruction" %>
<%@ page import="com.ibm.commerce.payments.plugin.punchout.util.PunchoutPaymentCommandUtil" %>
<%@ page import="com.ibm.commerce.registry.BusinessPolicyRegistryEntry" %>

<%@include file="../common/common.jsp" %>

<%!
public String getPayAddressId(String payTCId, HttpServletRequest request) {
	
	String payNickName = "";
	String payMemberId = "";
	String payAddressId = "";
	
	try {
		if (payTCId != null && !payTCId.equals("")) {
			PaymentTCDataBean payTC = new PaymentTCDataBean();
			payTC.setInitKey_referenceNumber(payTCId);
			com.ibm.commerce.beans.DataBeanManager.activate(payTC, request);
			payNickName = payTC.getNickName();
			payMemberId = payTC.getMemberId();
		}
		
		if (payNickName != null && !payNickName.equals("") && payMemberId != null && !payMemberId.equals("") ) {
			AddressAccessBean payAddress = new AddressAccessBean();
			payAddress = payAddress.findByNickname(payNickName, new Long(payMemberId));
			if (payAddress != null)
				payAddressId = payAddress.getAddressId();
		}
	} catch (Exception ex) {}
	
	return payAddressId;
}

%>

<%
String FIRST_ORDER = "firstOrder";
String SECOND_ORDER = "secondOrder";

CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
request.setAttribute("snippetCaller","OrderPaymentSelection");
Locale jLocale = cmdContext.getLocale();
Hashtable orderMgmtNLS = (Hashtable)ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);
Hashtable orderAddProducts 	= (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderAddProducts", jLocale);
Hashtable paymentBuyPagesNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.paymentBuyPagesNLS", jLocale);
JSPHelper URLParameters = new JSPHelper(request);
String firstOrderId = URLParameters.getParameter(ECOptoolsConstants.EC_OPTOOL_FIRSTORDER_ID);
String secondOrderId = URLParameters.getParameter(ECOptoolsConstants.EC_OPTOOL_SECONDORDER_ID);
String localeUsed = URLParameters.getParameter("locale");
String multiOrder = URLParameters.getParameter("multiOrder");
String displayPaymentFor = URLParameters.getParameter("displayPaymentFor");
String showPONumber = URLParameters.getParameter("showPONumber");
if(!("true".equals(showPONumber)&& "false".equals(showPONumber))){
	showPONumber = "true";//default is true to display the ponumber input box.. 
}
String orderId = "";
String urlPIredirect = "/webapp/wcs/tools/servlet/OrderPaymentSelection?locale="+localeUsed;	
if ( (multiOrder.equals("true")) && (displayPaymentFor.equals(FIRST_ORDER)) ) {
	orderId = firstOrderId;
	urlPIredirect += "&multiOrder=true&displayPaymentFor=firstOrder&"+ECOptoolsConstants.EC_OPTOOL_FIRSTORDER_ID+"="+firstOrderId +"&"+ ECOptoolsConstants.EC_OPTOOL_SECONDORDER_ID +"="+secondOrderId;
} else if ( (multiOrder.equals("true")) && (displayPaymentFor.equals(SECOND_ORDER)) ) {
	orderId = secondOrderId;
	urlPIredirect +="&multiOrder=true&displayPaymentFor=secondOrder&"+ECOptoolsConstants.EC_OPTOOL_FIRSTORDER_ID+"="+firstOrderId +"&"+ ECOptoolsConstants.EC_OPTOOL_SECONDORDER_ID +"="+secondOrderId;
} else if ( (multiOrder.equals("false")) && (firstOrderId != null) && (!firstOrderId.equals("")) ) {
	orderId = firstOrderId;
	displayPaymentFor = FIRST_ORDER;
	urlPIredirect +="&multiOrder=false&displayPaymentFor=firstOrder&" + ECOptoolsConstants.EC_OPTOOL_FIRSTORDER_ID + "=" + firstOrderId;
} else {
	orderId = secondOrderId;
	displayPaymentFor = SECOND_ORDER;
	urlPIredirect +="&multiOrder=false&displayPaymentFor=secondOrder&" + ECOptoolsConstants.EC_OPTOOL_SECONDORDER_ID + "=" + secondOrderId;
}
//add by cdc
OrderDataBean orderDataBean = new OrderDataBean();
orderDataBean.setOrderId(orderId);
com.ibm.commerce.beans.DataBeanManager.activate(orderDataBean, request);	
OrderDataBean.PaymentInstruction[] arrayPI = orderDataBean.getPaymentInstructions();
UsablePaymentTCListDataBean usablePaymentTCs =	new UsablePaymentTCListDataBean();
usablePaymentTCs.setOrderId(new Long(orderId));
com.ibm.commerce.beans.DataBeanManager.activate(usablePaymentTCs, request);
	// Get all usable payment TCs data from the beans
PaymentTCInfo[] paymentTCInfo = usablePaymentTCs.getPaymentTCInfo();
PaymentTCInfo[] filteredPaymentTCInfo = usablePaymentTCs.getFilteredPaymentTCInfo();
Integer storeId = usablePaymentTCs.getCommandContext().getStoreId();
Iterator punchoutIter = PunchoutPaymentCommandUtil.getPunchoutPolicies(storeId).iterator();
Set punchoutPayments = new HashSet();
while (punchoutIter.hasNext()) {
	BusinessPolicyRegistryEntry entry = (BusinessPolicyRegistryEntry) punchoutIter.next();
	punchoutPayments.add(entry.getPolicyId());
}
java.math.BigDecimal remainingAmt= orderDataBean.getPaymentAmountRemaining().getPrimaryPrice().getValue();
String customerId = orderDataBean.getMemberId();
java.math.BigDecimal orderTotal = orderDataBean.getGrandTotal().getAmount();
String billingAddressId = orderDataBean.getAddressId();

boolean requiredPONumber=orderDataBean.isPurchaseOrderNumberRequired();
if(requiredPONumber){
	showPONumber = "true";
}
String purchaseOrderNumber = orderDataBean.getPurchaseOrderNumber();
if(purchaseOrderNumber==null){
	purchaseOrderNumber="";
}

String defaultPaymentMethodName = "VISA";
// Start: Determine selected payment in drop down list. It is either the defaultPaymentMethodName or the first in the list
String edp_SelectedValue ="";
int edp_SelectedIndex =0 ;	
if(paymentTCInfo!=null && paymentTCInfo.length>0 ){
		PaymentTCInfo edp_Info = paymentTCInfo[0];
		edp_SelectedValue =edp_Info.getPolicyName();
		edp_SelectedIndex =0 ;
		for(int i=0; i<paymentTCInfo.length;i++){
			edp_Info = paymentTCInfo[i];
			if(defaultPaymentMethodName.equals(edp_Info.getPolicyName()) && !defaultPaymentMethodName.equals(edp_SelectedValue)){
					edp_SelectedValue = edp_Info.getPolicyName();
					edp_SelectedIndex = i;
			}													
		}											
}									
//end add by cdc
%>

<html>
  <head>
    <title><%= UIUtil.toHTML( (String)orderMgmtNLS.get("selectPaymentOptionTab_title")) %></title>
    <link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />
    
    <script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
    <script type="text/javascript" src="/wcs/javascript/tools/common/Vector.js"></script>
    <script type="text/javascript" src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>
  </head>
  <body class='content' onload="initializeState();"> 
  <script type="text/javascript">
     <!-- <![CDATA[

      ////////////////////////////////////////////////////////
      // Reload this page with new order selection          //
      ////////////////////////////////////////////////////////
      function displayOrderPayment(value)
      {
        parent.savePanelData();
      
      	var url = "/webapp/wcs/tools/servlet/OrderPaymentSelection?"+
		"<%= ECOptoolsConstants.EC_OPTOOL_FIRSTORDER_ID %>=<%= firstOrderId %>&"+
      		"<%= ECOptoolsConstants.EC_OPTOOL_SECONDORDER_ID %>=<%= secondOrderId %>&"+
      		"multiOrder=true&displayPaymentFor="+value;
      	
	this.location.replace(url);   
      }


      ////////////////////////////////////////////////////////
      // Initialize the state of this page                  //
      ////////////////////////////////////////////////////////
      function initializeState() 
      {
        
        var order = parent.parent.get("order");
        var orderToChange = order["<%= displayPaymentFor %>"];
        var payment = orderToChange["payment"];
                
        parent.initializeState();
      }

      //////////////////////////////////////////////////////////
      // Load the result frame according to the cassette selected
      //////////////////////////////////////////////////////////
      function reloadResultFrame(initialize)
      {
        var url;
        
        if (initialize == false) {
           var order = parent.parent.get("order");
           var orderToChange = order["<%= displayPaymentFor %>"];
           var payment = new Object();
           updateEntry(orderToChange, "payment", payment);
        }
        
        var selectedOption = document.form1.profileCassettes.selectedIndex;
   
        if (selectedOption != 0) {
           var selectedVectorIndex = document.form1.profileCassettes.options[selectedOption].value;
           var selectedProfileCassette = elementAt(selectedVectorIndex,supportedPaymentTCs);
           parent.parent.put("paymentProfile", selectedProfileCassette);
           
           // Load the result page
           //create URL dynamically depending on PaymentTCs object fields
           url = "/webapp/wcs/tools/servlet/OrderPaymentResult?";
           for (var i in selectedProfileCassette) {             
              url = url + i + "=";
              url = url + selectedProfileCassette[i] + "&";
           }
           url = url + "displayPaymentFor=<%= displayPaymentFor %>";
        } else {
           url = "/wcs/tools/common/blank.html";
        }
        
        parent.OrderPaymentResult.location.replace(url);      
        
        if (defined(parent.OrderPaymentPONumber)) {        
           // Load the PONumber page only if the buyPageInfo is not empty.
           if ( selectedOption != 0 ) {
              url2 = "/webapp/wcs/tools/servlet/OrderPaymentPONumberB2B?displayPaymentFor=<%= displayPaymentFor %>";
           } else {
              url2 = "/wcs/tools/common/blank.html";
           }
           
           parent.OrderPaymentPONumber.location.replace(url2);
        }
      }
      //Support For Customers,Shopping Under Multiple Accounts. 
	   function getFromTop(){
		var orgName = top.get("selectedOrgName");
		//alert("orgname:" + orgName);
		//top.remove("selectedOrgName");
		return orgName; 
		
	}
	
	function getSelectedOrgIdFromTop(){
		var orgId = top.get("selectedOrg");
		return orgId; 
		
	}

function showHideLayer() { //IE v6.0	
	var args = showHideLayer.arguments;	  
   // alert("showHideLayer.arguments.length:"+showHideLayer.arguments.length);
   // alert("showHideLayer.arguments:"+args[0]);
   	var selectObj = findObject(args[0]);
    if (selectObj== null) {
    	alert(args[i] + " not found"); 
    	return;
    }
	
	for(var j=0; j < selectObj.options.length; j++) {
		    var divName = 'PaymentMethodLayer_' + (j);
		    var currentObj = findObject(divName);
		    if (currentObj != null) {
				if (currentObj.style != null) { 
					currentObj=currentObj.style;
					if (j == selectObj.selectedIndex) {
						currentObj.visibility='visible';
						currentObj.display='block';
					} else {
						currentObj.visibility='hidden';
						currentObj.display='none';
					}				
				} else {
					alert("divName = " + divName + " found but has no style");
				}
			} else {
				alert("divName = " + divName + " not found");
			}
		}
 }

function findObject(objId, doc) { //v4.01
	if(doc == null) {
		doc=document;
	}
	var idx = objId.indexOf("?");
	if( idx > 0 && parent.frames.length != null) {
	   doc=parent.frames[objId.substring(idx+1)].document; 
	   objId=objId.substring(0,idx);
	}
	var obj =  doc[objId];
	if((obj == null) && doc.all != null) {
		obj = doc.all[objId];
	}
	//look up in all the forms of the current document referernced by doc.
	var i;
	for (i=0; (obj == null) && i<doc.forms.length; i++) {
		obj = doc.forms[i][objId];
	}
	for(i=0; (obj == null) && doc.layers && i<doc.layers.length; i++) {
		obj = findObj(objId, doc.layers[i].document);
	}
	if(obj == null && (doc.getElementById != null)) {
		obj = doc.getElementById(objId);
	}
	return obj;
}
function submitPIInfo(formName)
{	var now = new Date();
	var lastday = 1;
	var lastmonth = 1;
	
	var poRequired ='<%=requiredPONumber%>';
	
	var tempOrgId = getSelectedOrgIdFromTop();
	if (tempOrgId != undefined){
		formName.activeOrgId.value = tempOrgId;
	}
	
	<%if("true".equals(showPONumber)){%>
	if (document.PONumberInfo.purchaseorder_id != null && formName.purchaseorder_id != null) {
      	formName.purchaseorder_id.value = document.PONumberInfo.purchaseorder_id.value;
  	 }
  	<%}%>
	
    //check Expiry for PPC payment.
	if (formName.expire_month != null) {
		lastmonth = new Number(formName.expire_month.value) + 1;
		if (lastmonth > 13) {
			lastmonth = 1;
		}
	}
	var expiry = 2000;
	if (formName.expire_year != null) {
		expiry = new Date(formName.expire_year.value,lastmonth - 1,lastday);
	}
     //check Expiry for StanderdCreditCard of Old payment.
    if(formName.cardExpiryMonth != null){
        lastmonth = new Number(formName.cardExpiryMonth.value) + 1;
		if (lastmonth > 13) {
			lastmonth = 1;
		}
    }
    if(formName.cardExpiryYear != null){
       expiry = new Date(formName.cardExpiryYear.value,lastmonth - 1,lastday);
    }
	
	if (formName.piAmount !=null && parseFloat(formName.piAmount.value) < 0){
        var message = "<%=UIUtil.toHTML((String) orderMgmtNLS.get("amountLessThanZero"))%>";
    	alertDialog(message);
	// account is checked for StandardCreditCard
	} else if (formName.cardNumber != null && formName.cardNumber.value == "") {
        var message = "<%=UIUtil.toHTML((String) orderMgmtNLS.get("noAccountNumber"))%>";
    	alertDialog(message);
    // account is checked for StandardAmex, StandardMasterCard, StandardVisa, StandardLOC and StandardCheck
    
     } else if (formName.account != null && formName.account.value == "") {
        var message = "<%=UIUtil.toHTML((String) orderMgmtNLS.get("noAccountNumber"))%>";
    	alertDialog(message);
    // expiry date can be checked for StandardCreditCard
    } else if (formName.cardExpiryMonth != null && formName.cardExpiryYear != null && now >= expiry) {
    	var message = "<%=UIUtil.toHTML((String) orderMgmtNLS.get("invalidExpiryDate"))%>";
    	alertDialog(message);
    // expiry date can be checked for credit cards StandardAmex, StandardMasterCard and StandardVisa
    } else if (formName.expire_month != null && formName.expire_year != null && now >= expiry) {
    	var message = "<%=UIUtil.toHTML((String) orderMgmtNLS.get("invalidExpiryDate"))%>";
    	alertDialog(message);
    } else if (formName.piAmount != null && formName.piAmount.value == "") {
    	var message = "<%=UIUtil.toHTML((String) orderMgmtNLS.get("noAmount"))%>";
    	alertDialog(message);
    } else if (formName.check_routing_number != null && formName.check_routing_number.value == "") {
        var message = "<%=UIUtil.toHTML((String) orderMgmtNLS.get("noRoutingNumber"))%>";
    	alertDialog(message);
    } else if (formName.billing_address_id != null && formName.billing_address_id.value == "") {
        var message = "<%=UIUtil.toHTML((String) orderMgmtNLS.get("noBillingAddress"))%>";
    	alertDialog(message);
    <%if("true".equals(showPONumber)){%>	
    } else if (poRequired == "true" && formName.purchaseorder_id != null && formName.purchaseorder_id.value == "") {
        var message = "<%=UIUtil.toHTML((String) orderMgmtNLS.get("noPurchaseOrder"))%>";
    	alertDialog(message);
    <%}%>
    } else {        
            // Add the payment method to the order
    		if (checkParameters(formName)){
    		//location.reload() 
    			if(parent.parent.setContentFrameLoaded){
    				 parent.parent.setContentFrameLoaded(false);
    		 	}
    		 	top.showProgressIndicator(true);    			
    			formName.submit();    			  			
            }   	
	}
 }
 
 //check parameters, more parameters should be added here
function checkParameters(formName){
  var orderTotal = '<%=orderTotal%>';
  var amtRemaining = '<%=remainingAmt%>';
  if (formName.cc_cvc != null && trim(formName.cc_cvc.value)!= null && trim(formName.cc_cvc.value)!= ""){
        if (!isNumber(formName.cc_cvc.value)) {
           var message = "<%=UIUtil.toHTML((String) orderMgmtNLS.get("cvvnotNumeric"))%>";
    	   alertDialog(message);
    	   return false;
        }
  }
  var originalAmt = 0.0;
  var currentReming = amtRemaining;
  if (formName.piAmount != null) {
      if (trim(formName.piAmount.defaultValue) != null) {
          originalAmt = parseFloat(formName.piAmount.defaultValue);
          if (originalAmt == amtRemaining) {
             originalAmt = 0.0;
          }
      }
      if ( trim(formName.piAmount.value)!= null ) {
          var newTotal = parseFloat(formName.piAmount.value) - parseFloat(originalAmt) - parseFloat(amtRemaining);
          currentReming = parseFloat(amtRemaining)-(parseFloat(formName.piAmount.value) - parseFloat(originalAmt));
         // alert("new total:"+newTotal);
         // alert("piAmount.value:"+formName.piAmount.value);
         //  alert("originalAmt.value:"+originalAmt);
          //alert("amtRemaining.value:"+amtRemaining);
         // alert("currentReming.value:"+currentReming);           
          
          if (parseFloat(newTotal) > 0.0) {
	      	var message = "<%=UIUtil.toHTML((String) orderMgmtNLS.get("paymentAmountLargerThanOrderAmount"))%>";
	      	var answer = confirmDialog(message);
	      	if (answer == false) {
	      		formName.reset();
	      	}
	      	if(answer && currentReming!=amtRemaining ){
	      	 	updateRemainingAmt(currentReming);	      	
	      	}
	      	return answer;
	      }
	  }
  }else if(amtRemaining<0){
  	var message = "<%=UIUtil.toHTML((String) orderMgmtNLS.get("paymentAmountLargerThanOrderAmount"))%>";
	var answer = confirmDialog(message);
	if (answer == false) {
	  formName.reset();
	}	
	return answer;
  
  }
  
  return true;
}
function updateRemainingAmt(toRemainingValue){
	var order = parent.parent.get("order");
    var orderToChange = order["<%= displayPaymentFor %>"];
    var paymentRemainingAmount = orderToChange["paymentRemainingAmount"];
    if ((defined (paymentRemainingAmount))&&(defined(paymentRemainingAmount.remainingValue))){ 
    paymentRemainingAmount.remainingValue=toRemainingValue;
    }
    parent.updateEntry(orderToChange, "paymentRemainingAmount", paymentRemainingAmount)
}

function isNumber(word)
	{
   	var numbers="0123456789";
   	var word=trim(word);
	for (var i=0; i < word.length; i++)
	{
		if (numbers.indexOf(word.charAt(i)) == -1) 
		return false;
	}
	return true;
}

function removePIInfo(formName){
    var orderId = formName.orderId.value;
    var piId = formName.piId.value;
    var tempOrgId = getSelectedOrgIdFromTop();
	if (tempOrgId != undefined){
		document.forms.PaymentMethodsDisplayForm.activeOrgId.value = tempOrgId;
	}
	//var piRemoveURL = "PIRemove?orderId="+orderId+"&piId="+piId+"&URL=<%=urlPIredirect%>";
	//var piRemoveURL = "PIRemove?orderId="+orderId+"&piId="+piId;
	var piRemoveURL = "CSRPIRemove?orderId="+orderId+"&piId="+piId;
	//alert("piRemoveURL:"+piRemoveURL);
	//alert("before remove"); 
	if(parent.parent.setContentFrameLoaded){
  		parent.parent.setContentFrameLoaded(false);
    }
	top.showProgressIndicator(true);
	document.forms.PaymentMethodsDisplayForm.action=piRemoveURL;
	document.forms.PaymentMethodsDisplayForm.URL.value='<%=urlPIredirect%>';//parent.getOrderSelectPaymentPage();//"/webapp/wcs/tools/servlet/OrderPaymentPageB2B?firstOrderId="+orderId;
	var amtRemaining = '<%=remainingAmt%>';
	var removedPiAmount = formName.piAmount.value;
	var newRemaining = parseFloat(removedPiAmount)+parseFloat(amtRemaining);
	//alert("amtRemaining/removedPiAmount/newRemaining:"+amtRemaining+"/"+removedPiAmount+"/"+newRemaining);
	updateRemainingAmt(newRemaining); 
	//alert(" top.mccmain.mcccontent.CONTENTS.location:"+ top.mccmain.mcccontent.CONTENTS.location);
    //top.mccmain.mcccontent.CONTENTS.location.reload();
    //parent.parent.displayPanel("selectPaymentPageNavTabTitle",new Object());	
   //	alert("here:"+ parent.getOrderSelectPaymentPage());
    document.forms.PaymentMethodsDisplayForm.submit(); 
   //  parent.parent.CONTENTS.location.href = parent.getOrderSelectPaymentPage();//parent.parent.generateFullURL("/wcs/tools/order/OrderSelectPaymentB2B.html");
   // parent.parent.CONTENTS.location.replace(url);
   // document.location.replace(getRedirectURL());
   // alert("after remove"); 
  
   //var paymentSelectionURL 		= "/webapp/wcs/tools/servlet/OrderPaymentSelection";
        
    //   urlPIredirect += "&multiOrder=true&displayPaymentFor=firstOrder&"+ECOptoolsConstants.EC_OPTOOL_FIRSTORDER_ID+"="+firstOrderId +"&"+ ECOptoolsConstants.EC_OPTOOL_SECONDORDER_ID +"="+secondOrderId;"
	//	var URLParam = new Object();
	//	URLParam=
	//	URLParam.XMLFile = "order.orderAddProductItemDetailsDialogB2B";		
	//	top.saveData(URLParam,"OrderPaymentSelctionURLParam");
	//	top.mccmain.submitForm(paymentSelectionURL,URLParam);
}
function accountChanged(formname)
{
	// alertDialog("Before change: "+formname.valueFromPaymentTC.value);
	   formname.valueFromPaymentTC.value = "false";
	// alertDialog("After change: "+formname.valueFromPaymentTC.value);
}
function getRedirectURL() {
    var url = "/webapp/wcs/tools/servlet/OrderPaymentPageB2B?firstOrderId=<%=orderId%>";
	//if ( defined(parent.getErrorParams()) )
	//	url = url + "&errorCode=" + parent.getErrorParams();

	return url;
}
    //[[>-->
    </script>    

<!--Support For Customers,Shopping Under Multiple Accounts. -->

<h1><%= UIUtil.toHTML( (String)orderMgmtNLS.get("selectPaymentOptionTab")) %></h1>
<!--input type="hidden" name="displayPaymentFor" value="<%= displayPaymentFor %>" /-->
<table border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td valign="bottom" align="left">
            <%= UIUtil.toHTML((String)orderAddProducts.get("activeOrganization")) %>
          </td>
          <td>
          &nbsp;&nbsp;
          </td>
          <td valign="bottom" align="left">
            <i><script>document.write(getFromTop()); </script></i>
          </td>
        </tr>
        
   </table>
   <br />


<table width="100%" border="0">
    <!-- begin input the purchase order number section-->
    <% if("true".equalsIgnoreCase(showPONumber)){%>
	        <!-- The form for the purchase order number is deprecated-->
	    	    <form name="PONumberInfo"  id="PONumberInfo">
                    <input type="hidden" name = "purchaseorder_id" id="purchaseorder_id1" value ="default" id="PaymentMethodsDisplay_InputText_46" />
				</form>
    <%}%>
    <!-- end input the purchase order number section-->


	<%// This row will contain payment intructions available for selection and a form for the currently
	  //selected payment method that can be added to the order %>	
	<tr>
		<td colspan="4" valign="middle" >
			<table cellpadding="2" cellspacing="1"  border="0" id="EDP_PaymentMethodsDisplay_Table_1">
				<tr>
					<td colspan="2" id="EDP_PaymentMethodsDisplay_TableCell_13b">
						<table border="0" cellpadding="2" cellspacing="1">
							<tr>
								<td>
									<%=UIUtil.toHTML((String) orderMgmtNLS.get("addPaymentMethod"))%>
								</td>
							</tr>
							<tr>
								<td>							        
									<!--Start:  Displays the avialble Payment methods in a pre-populated list box -->
									<form id="PaymentMethodsDisplayForm" name="PaymentMethodsDisplayForm" method="post" >
		    						<input type="hidden" name="orderId" value="<%=orderId%>" />	
		    						<input type=hidden name="URL" value="/" />	
		    						<input type="hidden" name="customerId" value="<%=customerId%>" />
		    						<input type="hidden" name="activeOrgId" value="" />
									<input type="hidden" name="clearForUser" value="true" />
		    						<input type="hidden"  name="displayPaymentFor" id="displayPaymentFor" value="<%= displayPaymentFor %>" />
		    						<input type=hidden name="errorViewName" value="CSROrderPrepareErrorView" />								
									<table border="0" cellpadding="2" cellspacing="1">
										<tr>
											<td align="left" valign="top"  id="PaymentMethodsDisplay_TableCell_11">
												<label for="paymentMethod">
												<span class="required">*</span>
												<!--strong--><%=UIUtil.toHTML((String) orderMgmtNLS.get("paymentSelectMethod"))%><!--/strong-->
												</label>
											</td>				
												
											
											<td align="left" valign="top"  id="PaymentMethodsDisplay_TableCell_12">
												
											    <%// Start: Show the payment drop down list. If nothing to show indicate that there are no payment methods.%>
												<%
												if(filteredPaymentTCInfo!=null && filteredPaymentTCInfo.length>0 ){	
												 	PaymentTCInfo edp_Info = filteredPaymentTCInfo[0];											
													%>
													<select name="paymentMethod" id="paymentMethod" onchange="showHideLayer('paymentMethod');" >
													<% for(int i =0 ;i<filteredPaymentTCInfo.length; i++){
															edp_Info = filteredPaymentTCInfo[i];%>
												    	    <%-- policy name is unique --%>
															<option <%if (i == edp_SelectedIndex){%> selected="selected" <%}%>
																	value="<%=edp_Info.getPolicyName()%>" <%if(punchoutPayments.contains(edp_Info.getPolicyId())){ %>disabled="disabled"<%} %>> 
																	<%=edp_Info.getPaymentMethodDisplayName()%>
															</option>														
													<%}%> 
													</select>  
												<%}else {%>
												    <select name="paymentMethod" id="paymentMethod" onchange="javascript:document.PaymentMethodsDisplayForm.submit()" >
													    	<option selected="selected" value="<%=UIUtil.toHTML((String) orderMgmtNLS.get("noPaymentMethods"))%>"/>
													</select>
													<br/><font color="red"><%=UIUtil.toHTML((String) orderMgmtNLS.get("noPaymentMethodsAvailable"))%></font>								
												
												<%}%>
											</td>
										</tr>									
										<tr>
											<%//Start: Show the remaining amount -- the amount not yet allocated to a payment method. %>
											<td id="PaymentMethodsDisplay_TableCell_13">
						    					<label for="OrderRemainingAmount"><!--strong--><%=UIUtil.toHTML((String) orderMgmtNLS.get("paymentAmountRemaining"))%><!--/strong--></label>
						    				</td>
											<td id="PaymentMethodsDisplay_TableCell_14">
											    <input <%if (remainingAmt.doubleValue()<0.0) {%> class="error" <%}%>
											    	type="text" name="remainingAmount" id="OrderRemainingAmount" readonly="readonly" value="<%=remainingAmt%>" />
											</td>
										</tr>
									</table>
									</form>
									<%//End: displays the available Payment methods in a pre populated list box--%>								
								</td>
							</tr>
							
							<%// This row contains the input form for the selected payment method
							  //Note: all the payment methods are from the edp_PaymentTCBean are shown but only the selected one is visible
							%>
							
						<%
						if(filteredPaymentTCInfo!=null && filteredPaymentTCInfo.length>0){
							PaymentTCInfo edp_Info = filteredPaymentTCInfo[0];	
							java.util.HashMap protocolData = new java.util.HashMap();
							for(int i =0 ;i < filteredPaymentTCInfo.length; i++){
								edp_Info = filteredPaymentTCInfo[i]	;
								String curentPaymentTCId =edp_Info.getTCId();
								if(curentPaymentTCId == null || "null".equalsIgnoreCase(curentPaymentTCId) || curentPaymentTCId.trim().length()<=0){
								   curentPaymentTCId = "";
								}
								String edp_PIInfo_Form = "PIInfo_" + i;
								java.math.BigDecimal edp_PayMethodAmount = remainingAmt;
								java.math.BigDecimal edp_OrderTotalAmount = orderTotal;
								if(edp_PayMethodAmount.doubleValue()< 0.00){
									edp_PayMethodAmount = new java.math.BigDecimal(0.00);											
								}								
								//System.out.println("edp_SelectedIndex="+edp_SelectedIndex);				
							%>
							<tr id="PaymentMethodLayer_<%=i%>" <%if(edp_SelectedIndex == i){%> style="visibility: visible; display: block;"<%} else {%> style="visibility: hidden; display: none;"<%}%>>
								<td>							
									<!-- Start:  This form is invoked on the click of Add button after entering the mandatory payment fields-->
									<form name="<%=edp_PIInfo_Form%>" method="post" action="CSRPIAdd">
										<input type="hidden" name="orderId" value="<%=orderId%>" /> 
										<input type="hidden" name="customerId" value="<%=customerId%>" />
										<input type="hidden" name="activeOrgId" value="" />
										<input type="hidden" name="clearForUser" value="true" />										
										<input type="hidden" name="URL" value="<%=urlPIredirect%>" />											
										<input type="hidden" name="payMethodId" value="<%=edp_Info.getPolicyName()%>" />
										<input type="hidden" name="payment_method" value="<%=edp_Info.getPolicyName()%>" />
										<input type="hidden" name="errorViewName" value="CSROrderPrepareErrorView" />
                                                                                <input type="hidden" name="policyId" value="<%=edp_Info.getPolicyId()%>" />
										<!--Start:gets and includes the full path of the attribute page name with the extension as .jsp. If remaining amount is negative amount, just leave it blank-->
										<%if(edp_Info.getAttrPageName() != null){											    
												 String attrPagePath = "/tools/order/buyPages/" + edp_Info.getAttrPageName() + ".jsp";
													//request.setAttribute("cardType", paymentMethod);
							 				        request.setAttribute("resourceBundle", paymentBuyPagesNLS);
							 				        request.setAttribute("protocolData",protocolData);
							 				        request.setAttribute("edp_PayMethodAmount",edp_PayMethodAmount);
							 				        request.setAttribute("edp_OrderTotalAmount",edp_OrderTotalAmount);
							 				        request.setAttribute("forPIUPdate","Y");
												request.setAttribute("paymentTCInfo",edp_Info);							 				        												
											%><jsp:include page="<%=attrPagePath%>" flush="true">
												<jsp:param name="paymentTCId" value="<%=curentPaymentTCId%>" />
												<jsp:param name="showPONumber" value="<%=showPONumber%>" />
												<jsp:param name="currentBillingAddress" value="<%=billingAddressId%>" />
												<jsp:param name="orderId" value="<%=orderId%>" />											
											 </jsp:include>
										  <%}%>									
										<!--End:  gets and includes the full path of the attribute page name with the extension as .jsp-->
									</form>															
									<table width="100%" border="0" cellpadding="2" cellspacing="1">
											<tr>
												<td valign="middle" id="PaymentMethodsDisplay_TableCell_13_<%=i%>">
													<button type="button" style="width:auto" id="PaymentMethodsDisplayButton" name="PaymentMethodsDisplayButton" onclick="submitPIInfo(document.<%=edp_PIInfo_Form%>); return false;" >
														<%=UIUtil.toHTML((String) orderMgmtNLS.get("addPaymentMethod"))%>
													</button>
												</td>
												<td>												
												</td>																														
											</tr>
									</table>																
								</td>			
						 	</tr>
						<%}}%>
					 <!--This ends the input form for the selected payment method-->
					</table>
				</td>
			</tr>
		</table>
	</td>
</tr>
	<%--
	*********************
	* This is the beginning of the existing payment intructions for the order (in sub-rows)
	*********************
	--%>
<tr>
   <td colspan="4" valign="middle">
   <%       
   		for(int i=0; i<arrayPI.length; i++){
			EDPPaymentInstruction edppi = arrayPI[i].getPaymentInstruction();
			String paymentMethod =  edppi.getPaymentMethod();
			//Long paymentMethodId =edppi.getId();
	        HashMap protocolData = edppi.getProtocolData();
	        Long edppiId = edppi.getId();
                Long policyId = edppi.getPolicyId();
	  		java.math.BigDecimal paymentMethodAmount =   arrayPI[i].getFormattedAmount().getPrimaryPrice().getValue();
			java.math.BigDecimal orderTotalAmount = orderTotal;
			String edit_Form = "PIInfoEdit_"+edppiId; %>			
			<form name='<%=edit_Form%>' method='post' action='CSRPIEdit'>
			<input type="hidden" name="orderId"	value="<%=orderId%>"/>
			<input type="hidden" name="customerId" value="<%=customerId%>" />
			<input type="hidden" name="activeOrgId" value="" />
			<input type="hidden" name="clearForUser" value="true" />
			<input type="hidden" name="URL"  value="<%=urlPIredirect%>" />	
			<input type="hidden" name="errorViewName" value="CSROrderPrepareErrorView" />
			<input type="hidden" name="payMethodId"	value="<%=paymentMethod%>" /> 
			<input type="hidden" name="payment_method" value="<%=paymentMethod%>" /> 
			<input type="hidden" name="piId" value="<%=edppiId%>" /> 
                        <input type="hidden" name="policyId" value="<%=policyId%>" />
 			
 			<%String attrPageName =""; 	
 			  String paymentMethodName = "";
			  for (int j = 0; j < paymentTCInfo.length; j++) {
			 	 PaymentTCInfo info = paymentTCInfo[j];	
			 	 String tempPaymentTCId =info.getTCId(); 
			 	 if(tempPaymentTCId == null || "null".equalsIgnoreCase(tempPaymentTCId) || tempPaymentTCId.trim().length()<=0){
								  tempPaymentTCId = "";
				}
		      	 attrPageName = info.getAttrPageName(); 	
			 	 if(attrPageName !=null){
						//Gets the attribute Page name for the selected Payment method
					if(info.getPolicyName().equals(paymentMethod)){
			   			attrPageName = info.getAttrPageName();
	 	 	 			paymentMethodName = info.getShortDescription();	%>	
	 	 	 		<table border="0" cellpadding="2" cellspacing="1"> 	 	 
			 		<tr>
						<td align="left" colspan="4" valign="top">   
							<table border="0" cellpadding="2" cellspacing="1">
								<tr>
									<td><%=paymentMethodName%></td>
								</tr>
								<tr>
									<td>
											<%  String includePage = "";
											if(attrPageName != null && attrPageName.length()>0)
							 				{ includePage = "/tools/order/buyPages/" + attrPageName + ".jsp";}
							 				   //request.setAttribute("cardType", paymentMethod);
							 				   request.setAttribute("resourceBundle", paymentBuyPagesNLS);
							 				   request.setAttribute("protocolData",protocolData);
							 				   request.setAttribute("edp_PayMethodAmount",paymentMethodAmount);
							 				   request.setAttribute("edp_OrderTotalAmount",orderTotalAmount);
							 				   request.setAttribute("forPIUPdate","Y");
							 				   //request.setAttribute("orderId",orderId);
											 %>									
										<jsp:include page="<%= includePage %>" flush="true" >
										<jsp:param name="edp_PayMethodAmount" value="<%= paymentMethodAmount%>" />
										<jsp:param name="edp_OrderTotalAmount" value="<%= orderTotalAmount%>" />
										<jsp:param name="paymentTCId" value="<%=tempPaymentTCId%>" />
										<jsp:param name="orderId" value="<%=orderId%>" />
										<jsp:param name="showPONumber" value="<%=showPONumber%>" />
										</jsp:include> 
										<table border="0" cellpadding="2" cellspacing="1">
											<tr>												
												<td valign="middle" id="PaymentMethods_TableCell_33">													
													<button type="button" id="updatePaymentMethod" name="updatePaymentMethod" onclick="submitPIInfo(document.<%=edit_Form%>); return false;" <%if(punchoutPayments.contains(info.getPolicyId())){ %>disabled="disabled"<%} %>><%=UIUtil.toHTML((String) orderMgmtNLS.get("updatePaymentMethod"))%></button>
												</td>
												<td valign="middle" id="PaymentMethods_TableCell_34">												
													<button type="button" id="removePaymentMethod" name="removePaymentMethod" onclick="removePIInfo(document.<%=edit_Form%>)" <%if(punchoutPayments.contains(info.getPolicyId())){ %>disabled="disabled"<%} %>><%=UIUtil.toHTML((String) orderMgmtNLS.get("removePaymentMethod"))%></button>
												</td>
											</tr>					
										</table>
						  			</td>
					  			</tr>	
			       			</table>
			    		</td>
		   			</tr>
		   		</table> 	
		   			<%break;
		   			}//end	Gets the attribute Page  
				  }	//end if(attrPageName !=null)
				}//end for%>		
			</form>
		 <%}//end for each pi%>
		</td>			
	</tr>
	<%--
	*********************
	* This is the end of the existing payment intructions for the order (in sub-rows)
	*********************
	--%>
</table>	

</body>
</html>



