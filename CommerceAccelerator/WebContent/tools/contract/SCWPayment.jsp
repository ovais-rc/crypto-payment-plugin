<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>

<html>
<head>

<%@page import="java.util.*"%>
<%@page import="com.ibm.commerce.tools.util.*"%>
<%@page import="com.ibm.commerce.tools.catalog.util.*"%>
<%@page import="com.ibm.commerce.contract.util.ECContractCmdConstants"%>
<%@page import="com.ibm.commerce.beans.*"%>
<%@page import="com.ibm.commerce.payment.beans.PaymentPolicyListDataBean"%>
<%@page import="com.ibm.commerce.tools.contract.beans.PolicyDataBean"%>
<%@page import="com.ibm.commerce.tools.contract.beans.PolicyListDataBean"%>
<%@page import="com.ibm.commerce.common.objects.LanguageDescriptionAccessBean"%>
<%@page import="com.ibm.commerce.command.CommandContext"%>
<%@ page import="com.ibm.commerce.tools.contract.beans.StoreCreationWizardDataBean" %>
<%@ page import="com.ibm.commerce.tools.util.StringPair" %>
<%@page import="com.ibm.commerce.tools.common.ui.taglibs.*"%>
<%@ page import="com.ibm.commerce.tools.optools.order.beans.*" %>

<%@include file="../common/common.jsp" %>
<%@include file="../common/NumberFormat.jsp" %>
<%@include file="../contract/SCWCommon.jsp" %>
<%
  	try{
  	        boolean foundOfflineCardCassettePolicy=false;
  	        boolean foundCODCassettePolicy=false;
  	        boolean foundBillMeCassettePolicy=false;
  	        boolean displayTrueForOfflineCardCassette=false;
  	        boolean displayTrueForCODCassette=false;
  	        boolean displayTrueForBillMeCassette=false;
  	        String cassettePolicyOfflineCard = "";
  	        String cassettePolicyCOD = "";
  	        String cassettePolicyBillMe = "";
  	        
  		Vector policiesAlreadyConfigured = new Vector();
  		Vector policiesToChooseFrom = new Vector();
  		
   		StoreCreationWizardDataBean scDB = new StoreCreationWizardDataBean ();
   		DataBeanManager.activate(scDB, request);
   		boolean bPaymentServerIsUp = false;
   		boolean bPaymentOverride = false;
   		boolean bPaymentCheck = false;
   		boolean bUsingOtherPaymentSoftware = false;

        	// Getting paymentOverride cookie
        	Cookie[] cookies = request.getCookies();   
        	for (int i = 0; i < cookies.length; i++){
			if (cookies[i].getName().equalsIgnoreCase("paymentOverrideCookie")) {
				Boolean booPaymentCookieValue = new Boolean (cookies[i].getValue());
				bPaymentOverride = booPaymentCookieValue.booleanValue();
			}
			if (cookies[i].getName().equalsIgnoreCase("paymentCheckCookie")) {
				Boolean booPaymentCheckCookieValue = new Boolean (cookies[i].getValue());
				bPaymentCheck = booPaymentCheckCookieValue.booleanValue();
			}			
		}

//bPaymentOverride=true;//For Testing
//bPaymentServerIsUp=true;//For Testing

		//Check if Payments Server is up and running.
        	if(!bPaymentOverride){
        		try {
        			bPaymentServerIsUp = QueryPMBean.isPMOperational();
        		} catch (Exception ex) {
        			bPaymentServerIsUp = false;        			
        		}
        	}

//TEST
//bPaymentServerIsUp = false;   
//TEST
        	if (bPaymentOverride) {
        		bUsingOtherPaymentSoftware = true;
        	}

        	//If payment server is down, need to tell command to override payment.
        	if (!bPaymentServerIsUp) {
       			bPaymentOverride = true;
        	}

        	//Pass payment override to the command
		if (bPaymentOverride) { %>
			<script language="JavaScript">
				top.put("paymentOverride", "<%= bPaymentOverride %>");			
			
</script>
		<% }



		// Getting the payment options from the resource bundle		
		int count = 0;
		while(true){		
			if(fixedResourceBundle.get("customOfflinePayment_internalName_option_" + (count + 1)) == null){
				break;
			} 			
			count++;				
		}		
		String[][] customOffline_paymentOptions = null;
		boolean isCustomOfflinePaymentOptionsAvailable = false;
		if(count > 0){
			isCustomOfflinePaymentOptionsAvailable = true;
			customOffline_paymentOptions = new String[count][2];

			for(int i=0; i < count; i++){
				customOffline_paymentOptions[i][0] = (String) fixedResourceBundle.get("customOfflinePayment_internalName_option_" + (i + 1));
				customOffline_paymentOptions[i][1] = (String) resourceBundle.get("customOfflinePayment_displayText_option_" + (i + 1));			
			}		
		}


		// Getting the brand options from the resource bundle
		int brandCount = 0;
		while(true){		
			if(fixedResourceBundle.get("offlineCard_brand_internalName_option_" + (brandCount + 1)) == null){
				break;
			} 			
			brandCount++;				
		}					
		String[][] customOffline_brandOptions = null;
		boolean isBrandOptionsAvailable = false;
		if(brandCount > 0){		
			isBrandOptionsAvailable = true;
			customOffline_brandOptions = new String[brandCount][2];

			for(int i=0; i < brandCount; i++){
				customOffline_brandOptions[i][0] = (String) fixedResourceBundle.get("offlineCard_brand_internalName_option_" + (i + 1));
				customOffline_brandOptions[i][1] = (String) resourceBundle.get("offlineCard_brand_displayText_option_" + (i + 1));			
			}		
		}		
%>
<%
           final String DISPLAY_MODE_FALSE = "display=false";
           final String CASSETTE_NAME = "cassetteName=";
           final String OFFLINE_CARD = "OfflineCard";
           final String CUSTOM_OFFLINE = "CustomOffline";
           final String CUSTOM_OFFLINE_COD = "offlineMethod=COD";
           final String CUSTOM_OFFLINE_BILLME = "offlineMethod=BillMe";
           final String ELEMENT_COD = "COD";
           final String ELEMENT_BILLME = "BillMe";
             
           PolicyListDataBean policyList = new PolicyListDataBean();
           policyList.setPolicyType(policyList.TYPE_PAYMENT);
           DataBeanManager.activate(policyList, request);
           PolicyDataBean policy[] = policyList.getPolicyList();
           for (int i = 0; i < policy.length; i++) {
                String policyName = policy[i].getPolicyName();
                //always filter out the credit and void checkout policies.
                if (!PaymentPolicyListDataBean.isCreditPaymentPolicy(policyName) && !policyName.equals(PaymentPolicyListDataBean.POLICY_NAME_VOID_CHECKOUT))
                {
                    String policyProperties = policy[i].getProperties();
                    if (policyProperties != null) {
                     if (policyProperties.indexOf(CASSETTE_NAME) != -1) {
                       // this is a PM cassette - we want to get the policy info for the OfflineCard and CustomOffline (COD and BillMe) policies
                       if (bPaymentServerIsUp) {
                           if (policyProperties.indexOf(CASSETTE_NAME + OFFLINE_CARD) != -1) {
                           	foundOfflineCardCassettePolicy = true;
                           	cassettePolicyOfflineCard = policy[i].getId().toString();
                           	if (policyProperties.indexOf(DISPLAY_MODE_FALSE) == -1) {
                           	   // preselected policy the store must use
                           	   displayTrueForOfflineCardCassette = true;
                           	}
                           }
                           else if (policyProperties.indexOf(CASSETTE_NAME + CUSTOM_OFFLINE) != -1 && policyProperties.indexOf(CUSTOM_OFFLINE_COD) != -1) {
                           	foundCODCassettePolicy = true;
                           	cassettePolicyCOD = policy[i].getId().toString();
                           	if (policyProperties.indexOf(DISPLAY_MODE_FALSE) == -1) {
                           	   // preselected policy the store must use
                           	   displayTrueForCODCassette = true;
                           	}
                           }
                           else if (policyProperties.indexOf(CASSETTE_NAME + CUSTOM_OFFLINE) != -1 && policyProperties.indexOf(CUSTOM_OFFLINE_BILLME) != -1) {
                                foundBillMeCassettePolicy = true;
                                cassettePolicyBillMe = policy[i].getId().toString();
                                if (policyProperties.indexOf(DISPLAY_MODE_FALSE) == -1) {
                                   // preselected policy the store must use
                           	   displayTrueForBillMeCassette = true;
                           	}
                           }
                       }   
                    } else {
                        // these are the new payment policies, non PM versions
                       if (policyProperties.indexOf(DISPLAY_MODE_FALSE) != -1) {
                           // we want to list policies with "display=false" as potential policies to copy to the store
                           Vector v = new Vector(2);
                    	   v.addElement(policy[i].getLongDescription());
                    	   v.addElement(policy[i].getId().toString());
                    	   policiesToChooseFrom.addElement(v);
                       } else {
                          // display is true, so this is a preselected policy the store must use
                          policiesAlreadyConfigured.addElement(policy[i].getLongDescription());
                       }
                     }
                    }
                }
           }
%>                     
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js">
</script>
<script language="JavaScript" src="/wcs/javascript/tools/common/SwapList.js">
</script>
<script language="JavaScript" src="/wcs/javascript/tools/common/dynamiclist.js">
</script>
<script language="JavaScript" src="/wcs/javascript/tools/contract/ContractUtil.js">
</script>
<script language="JavaScript" src="/wcs/javascript/tools/common/Vector.js">
</script>
<script language="JavaScript">

var debug=false; // global flag to turn on alerts.

var checkBoxes = new Array();
var payments = new Object();
payments.paymentList = new Array();
var offlineCardList = new Array();
  
  
function paymentRow(type, brand, brandName, curr, currName, paymentMethodName, paymentMethodNameDisplayText){
	var newPaymentRow = new Object();
	newPaymentRow.paymentType = type;
	newPaymentRow.brand = brand;
	newPaymentRow.brandName = brandName;
	newPaymentRow.currency = curr;
	newPaymentRow.currencyName = currName;
	newPaymentRow.paymentMethodName = paymentMethodName;
	newPaymentRow.paymentMethodNameDisplayText = paymentMethodNameDisplayText;	
	return newPaymentRow;
}


function initializeDynamicList(tableName) {

<%
if (bPaymentServerIsUp) {
%>
  	startDlistTable(tableName,'100%');
  	startDlistRowHeading();
  	addDlistCheckHeading(true,'setAllCheckBoxesCheckedTo(this.checked);');
  
  	var columnHeading1 = "<%=UIUtil.toJavaScript(resourceBundle.get("paymentBrandInTable"))%>";
  	var columnHeading2 = "<%=UIUtil.toJavaScript(resourceBundle.get("paymentCurrencyInTable"))%>";
  
  	for(var i=0; i < 15;i++){
  		columnHeading1 = columnHeading1 + '&nbsp;';
  	} 
  	for(var i=0; i < 30;i++){
  		columnHeading2 = columnHeading2 + '&nbsp;';
  	}
  	addDlistColumnHeading(columnHeading1,true,null,null,null);
  	addDlistColumnHeading(columnHeading2,true,null,null,null);
  	endDlistRowHeading();
  	endDlistTable();
<%
 } //end if (bPaymentServerIsUp)
%>  	
}


function validatePanelData(){
	if(<%=bPaymentCheck%> && payments.paymentList.length == 0){	
		alertDialog("<%=UIUtil.toHTML((String)resourceBundle.get("paymentOptionRequired"))%>");
		return false;	
	}
	return true;
}

function appendOfflineCardListToPaymentList(){
	alertDebug("In appendOfflineCardListToPaymentList() function");
	for(var i = 0; i < offlineCardList.length; i++){
		payments.paymentList[payments.paymentList.length++] = offlineCardList[i];	
	}
	alertDebug("In appendOfflineCardListToPaymentList() function --- Length of paymentList: " + payments.paymentList.length);
}


function setAllCheckBoxesCheckedTo(checkedValue) {
  	for(var i=0;i<checkBoxes.length;i++) {
    		checkBoxes[i].checked=checkedValue;
  	}
  	enableButtonsBasedOnCheckboxes();
}


function outputValuesToDynamicList(tableName) {
  	checkBoxes=new Array();
  	var dynamicListRowIndex = 1;
 	
 	for (var i=0;i<offlineCardList.length;i++) {	
 		       		
 	  		insRow(tableName, dynamicListRowIndex);
          		insCheckBox(tableName,dynamicListRowIndex,0,checkBoxName(tableName,i),'enableButtonsBasedOnCheckboxes()',i);
          		checkBoxes[i] = eval(checkBoxName(tableName,i)); 
          		
          		var brand = offlineCardList[i].brand;
          		if(offlineCardList[i].brandName != ''){
          			brand = offlineCardList[i].brandName;
          		}  		
          		brand = '<TABLE border=0><TR><TD class="list_info1">' + brand + '</TD></TR></TABLE>';          		         	         

          		var currencyName = '<TABLE border=0><TR><TD class="list_info1">' + offlineCardList[i].currencyName + '</TD></TR></TABLE>';          		         	         
          		          		
          		insCell(tableName, dynamicListRowIndex, 1, brand);
          		insCell(tableName, dynamicListRowIndex, 2, currencyName);
          		dynamicListRowIndex++;         
        }
}


function getCheckedArray() {
  	var checkedArray=new Array();
  	for(var i=0;i<checkBoxes.length;i++) {
    		if (checkBoxes[i].checked){
    	 		checkedArray[checkedArray.length]=Number(checkBoxes[i].value);
    		}
  	}
  	return checkedArray;
}


function checkBoxName(tableName, i) {
  	return tableName + 'CheckBox' + i;
}


function addButtonAction() {
	
	var selectBrand = '';
	var inputTextBrand = '';
	var brandHTMLObject = null;
	
	<%
	if(isBrandOptionsAvailable){
	%>
		selectBrand = document.getElementById("selectPaymentBrand").value;
		brandHTMLObject = document.getElementById("selectPaymentBrand");
	<%
	}else{
	%>
		inputTextBrand = document.getElementById("paymentBrand").value;
		brandHTMLObject = document.getElementById("paymentBrand");
	<%
	}
	%>
		
	var curr = document.getElementById("paymentCurrency").value;
		
	if((inputTextBrand != '' || selectBrand != 'specifyBrand') && curr != 'specifyCurrency'){
			
		var brandToAdd = null;
		if(inputTextBrand != ''){
			brandToAdd = inputTextBrand;
		}else{
			brandToAdd = selectBrand;
		}	
			
		if(!doesBrandAndCurrencyExist(brandToAdd, curr)){
			if(inputTextBrand != '' && !parent.isValidInputText(brandToAdd)){
				alertDialog("<%=UIUtil.toJavaScript(resourceBundle.get("brandInvalid"))%>");
				brandHTMLObject.focus();			
			}else{					
				clearDynamicList('valueList');
				var currName = document.getElementById("paymentCurrency").options[document.getElementById("paymentCurrency").selectedIndex].innerText;
				
				var brandNameToAdd = '';
				if(selectBrand != 'specifyBrand' && selectBrand != ''){
					brandNameToAdd = document.getElementById("selectPaymentBrand").options[document.getElementById("selectPaymentBrand").selectedIndex].innerText;
				}
				// adding to the offline card list					
				offlineCardList[offlineCardList.length++] = new paymentRow("<%=ECContractCmdConstants.EC_CONTRACT_SCW_PAYMENTS_OFFLINE_CARD%>", brandToAdd, brandNameToAdd, curr, currName, '', '');
				outputValuesToDynamicList('valueList');
				if(inputTextBrand != ''){
					document.getElementById("paymentBrand").value = '';
				}
				brandHTMLObject.focus();
			}
		}else{
			alertDialog("<%=UIUtil.toJavaScript((String)resourceBundle.get("brandCurrencyDuplicate"))%>");
			brandHTMLObject.focus();
		}
	}else{		
		if(inputTextBrand == ''){			
			alertDialog("<%=UIUtil.toJavaScript((String)resourceBundle.get("brandEmpty"))%>");
			brandHTMLObject.focus();
		}else if(selectBrand == 'specifyBrand'){			
			alertDialog("<%=UIUtil.toJavaScript((String)resourceBundle.get("selectBrandEmpty"))%>");
			brandHTMLObject.focus();
		}else if(curr == 'specifyCurrency'){			
			alertDialog("<%=UIUtil.toJavaScript((String)resourceBundle.get("currencyEmpty"))%>");
			document.getElementById("paymentCurrency").focus();
		}	
					
	}
	
	// change the state of the addButton.
	changeAddButtonState();		
}


function removeButtonAction(){
	// clear the dynamic list
	clearDynamicList('valueList');	
	removeFromOfflineCardList();	
	outputValuesToDynamicList('valueList');
	enableButtonsBasedOnCheckboxes();
}


function removeFromOfflineCardList(){
	var oldOfflineCardList = new Array();

	// make a copy of offlineCardList
	for(var i=0; i < offlineCardList.length; i++){	
		oldOfflineCardList[i] = offlineCardList[i];	
	}	
	offlineCardList = new Array();
	
	var currentlyChecked = getCheckedArray();	
	for(var k=0; k < currentlyChecked.length; k++){	
		oldOfflineCardList[currentlyChecked[k]] = null;		
	}
		
	// building the new offlineCardList
	for(var j=0; j < oldOfflineCardList.length; j++){		
		if(oldOfflineCardList[j] != null){
			offlineCardList[offlineCardList.length++] = oldOfflineCardList[j];
		}	
	}	
}



function doesBrandAndCurrencyExist(brand, currency){
	for(var i=0; i < offlineCardList.length; i++){	
		if(offlineCardList[i] != null && offlineCardList[i].brand == brand && offlineCardList[i].currency == currency){		
			return true;
		}
	}	
	return false;
}


function clearDynamicList(tableName) {
  	while (eval(tableName).rows.length>1) {
    		delRow(tableName,1);
  	}
}


function enableButtonsBasedOnCheckboxes() {
  	var checkedCount =0;
  	for(var i=0;i<checkBoxes.length;i++) {  
    		if (checkBoxes[i].checked) checkedCount++;    
  	}
  	eval(select_deselect).checked=(checkedCount==checkBoxes.length && checkedCount!=0);
  	if (checkedCount==0) {
    		enableNone();    
  	}else{
    		enableMultiple();    
  	}
}

function loadCheckValue (entryField, value) {
   if (entryField.value == value) {
      entryField.checked = true;
   }
}

function loadCheckValues (entryField, value) {
   for (var i=0; i<entryField.length; i++) {
      if (entryField[i].value == value) {
         entryField[i].checked = true;
         break;
      }
   }
}

function enableNone() { 
  removeButton.className='disabled';
  removeButton.disabled=true;
}


function enableMultiple() {    
  removeButton.className='enabled';
  removeButton.disabled=false;
}


function displayOfflineCard(){	
	changeAddButtonState();
	if(document.getElementById("paymentType_offlineCard").checked){		
		document.getElementById("offlineCard_div").style.display = "block";
		document.getElementById("paymentTable").style.display = "block";		
		clearDynamicList('valueList');		
		outputValuesToDynamicList('valueList');			
	}else{	
		document.getElementById("offlineCard_div").style.display = "none";
		document.getElementById("paymentTable").style.display = "none";
	}		
}


function displayPaymentOptions(){	
	<%
	if(isCustomOfflinePaymentOptionsAvailable){
		for(int j=0; j < customOffline_paymentOptions.length; j++){
	%>
			 for (var i=0;i<payments.paymentList.length;i++) {	
 				if(payments.paymentList[i].paymentType == "<%=ECContractCmdConstants.EC_CONTRACT_SCW_PAYMENTS_CUSTOM_OFFLINE%>" && 
 				   payments.paymentList[i].paymentMethodName == "<%=UIUtil.toJavaScript(customOffline_paymentOptions[j][0])%>"){
 	  				document.getElementById("<%=UIUtil.toJavaScript(customOffline_paymentOptions[j][0])%>").checked = true;	         		
          			}    		
        		 }		 		
	<%
		}
	}	
	%>
	
	if(offlineCardList.length > 0){
 	  	document.getElementById("paymentType_offlineCard").checked = true;	         		
       	}     
       	
       	// if we don't have the policy for OfflineCard or CustomOffline (COD, BillMe), then disable the checkbox
       	if ("<%= foundOfflineCardCassettePolicy %>" == "false") {
       	     document.getElementById("paymentType_offlineCard").disabled = true;	
        }
        
       	if ("<%= foundCODCassettePolicy %>" == "false") {
       	     document.getElementById("<%=ELEMENT_COD%>").disabled = true;	
        }
       	if ("<%= foundBillMeCassettePolicy %>" == "false") {
       	     document.getElementById("<%=ELEMENT_BILLME%>").disabled = true;	
        }     
	
}

function init(){
	
	alertDebug("In init() function");
	
<%			
	if (bPaymentServerIsUp) {
%>		
		document.all.PaymentSection.style.display =  "block";
<%
	}
%>			
			
	if(parent.get("payments") != null){
<%			
	    if (bPaymentServerIsUp) {
%>	
		payments.paymentList = parent.get("payments").paymentList;
		setOfflineCardList();
<%
	    }
%>		
           payments.selectedMethods = parent.get("payments").selectedMethods;
	   for (var i=0; i<payments.selectedMethods.length; i++) {
	        if (<%= policiesToChooseFrom.size() %> == 1) {
                   loadCheckValue(document.paymentForm.PaymentPolicy, payments.selectedMethods[i]);
                }
                else if (<%= policiesToChooseFrom.size() %> > 1) {
		   loadCheckValues(document.paymentForm.PaymentPolicy, payments.selectedMethods[i]); 
		}
 	   }               
	} else {
	
	}
<%			
	if (bPaymentServerIsUp) {
%>	
	   displayPaymentOptions();
	   displayOfflineCard();
	   clearDynamicList('valueList');	
	   outputValuesToDynamicList('valueList');
	   enableButtonsBasedOnCheckboxes();
<%
	}
%>	                      
	parent.setContentFrameLoaded(true);
}


function setOfflineCardList(){
	alertDebug("In setOfflineCardList --- Setting the offline card list");

	for(var i = 0; i < payments.paymentList.length; i++){
		if(payments.paymentList[i].paymentType == "<%=ECContractCmdConstants.EC_CONTRACT_SCW_PAYMENTS_OFFLINE_CARD%>"){
			offlineCardList[offlineCardList.length++] = payments.paymentList[i];
		}	
	}
	alertDebug("Length of offline card list: " + offlineCardList.length);
}



function changeAddButtonState(){
	
	if(document.getElementById("paymentType_offlineCard").checked){
	
		var brand = '';

		<%
		if(isBrandOptionsAvailable){
		%>
			brand = document.getElementById("selectPaymentBrand").value;
		<%
		}else{
		%>
			brand = document.getElementById("paymentBrand").value;
		<%
		}
		%>
		
		if(brand != 'specifyBrand' && brand != '' && document.getElementById("paymentCurrency").value != 'specifyCurrency'){
			addButton.className='enabled';
			addButton.disabled=false;
		}else{
			addButton.className='disabled';
			addButton.disabled=true;
		}
	}
}

function savePanelData() {

	alertDebug("In savePanelData");
	payments.paymentList = new Array();
	payments.cassetteMethods = new Array();
	var cassetteCounter=0;

	if(!document.getElementById("paymentType_offlineCard").checked){
		// do not include the offline card payments --- reset the array of offline card payments
		offlineCardList = new Array();
		alertDebug("In SavePanelData() --- reset the offline card list");
	} else {
	     // if the policy is selected, but it was not a preselected policy, then we need to copy it to the store
	     if ("<%= foundOfflineCardCassettePolicy %>" == "true" && "<%= displayTrueForOfflineCardCassette %>" == "false") {
                payments.cassetteMethods[cassetteCounter++] = "<%= cassettePolicyOfflineCard %>";
             }
	}

	// for each of the custom_offline payment options that is checked,  add it to the model.	
	<%
	if(isCustomOfflinePaymentOptionsAvailable){
		for(int i=0; i < customOffline_paymentOptions.length; i++){
	%>
			if(document.getElementById("<%=UIUtil.toJavaScript(customOffline_paymentOptions[i][0])%>").checked){		
		 		payments.paymentList[payments.paymentList.length++] = new paymentRow("<%=ECContractCmdConstants.EC_CONTRACT_SCW_PAYMENTS_CUSTOM_OFFLINE%>", '', '', '', '', "<%=UIUtil.toJavaScript(customOffline_paymentOptions[i][0])%>", parent.changeSpecialText("<%=UIUtil.toJavaScript(customOffline_paymentOptions[i][1])%>", "<%=UIUtil.toJavaScript(customOffline_paymentOptions[i][0])%>" ));		
		 		// if the policy is selected, but it was not a preselected policy, then we need to copy it to the store
		 		if ("<%=UIUtil.toJavaScript(customOffline_paymentOptions[i][0])%>" == "<%=ELEMENT_COD%>") {
		 		         if ("<%= foundCODCassettePolicy %>" == "true" && "<%= displayTrueForCODCassette %>" == "false") {
                                            payments.cassetteMethods[cassetteCounter++] = "<%= cassettePolicyCOD %>";
                                         }
		 		} else if ("<%=UIUtil.toJavaScript(customOffline_paymentOptions[i][0])%>" == "<%=ELEMENT_BILLME%>") {
		 		        if ("<%= foundBillMeCassettePolicy %>" == "true" && "<%= displayTrueForBillMeCassette %>" == "false") {
                                            payments.cassetteMethods[cassetteCounter++] = "<%= cassettePolicyBillMe %>";
                                        }
		 		}
			}	
	<%
		}
	}	
	%>
	
	appendOfflineCardListToPaymentList();
	payments.selectedMethods = new Array();
	payments.selectedMethodsText = new Array();
        var checkCounter = 0;
        // save all the selected new payment policies - non PM policies
        if (defined(document.paymentForm.PaymentPolicy)) {
	        if (<%= policiesToChooseFrom.size() %> == 1) {
		  if (document.paymentForm.PaymentPolicy.checked) {
                       payments.selectedMethods[checkCounter] = document.paymentForm.PaymentPolicy.value;
                       // save the text for the summary page
                       payments.selectedMethodsText[checkCounter] = document.paymentForm.PaymentPolicy.id;
                       checkCounter++;
                  }
                }
                else if (<%= policiesToChooseFrom.size() %> > 1) {        
                  for (var i=0; i<document.paymentForm.PaymentPolicy.length; i++) {
		    if (document.paymentForm.PaymentPolicy[i].checked) {
                       payments.selectedMethods[checkCounter] = document.paymentForm.PaymentPolicy[i].value;
                       // save the text for the summary page
                       payments.selectedMethodsText[checkCounter] = document.paymentForm.PaymentPolicy[i].id;
                       checkCounter++;
                    }
		  }          
               }
        }
        
        // save the text of the preselected non PM policies for the summary page
     <% for (int plcy = 0; plcy < policiesAlreadyConfigured.size(); plcy++) { %>
           payments.selectedMethodsText[checkCounter++] = "<%=UIUtil.toHTML((String)policiesAlreadyConfigured.elementAt(plcy))%>";
     <% }  %>     
        
   	parent.put("payments", payments);
}



</script>

</head>

<body CLASS="content" ONLOAD="init();">
<h1><%=UIUtil.toHTML((String)resourceBundle.get("paymentPanelTitle"))%></h1>

<%=UIUtil.toHTML((String)resourceBundle.get("paymentChoosePolicies"))%><br><br>

<form NAME="paymentForm" id="paymentForm">
<table border=0 id="SCWPayment_Table_1">
  <% for (int plcy = 0; plcy < policiesAlreadyConfigured.size(); plcy++) {
  %>
      <tr>
      <td id="SCWPayment_MethodTableCell_1_<%=plcy%>">
         
         <label for="<%=UIUtil.toJavaScript((String)policiesAlreadyConfigured.elementAt(plcy))%>">
         <input disabled checked id="<%=UIUtil.toJavaScript((String)policiesAlreadyConfigured.elementAt(plcy))%>" type="checkbox" name="PreSelectedPaymentPolicy" value="<%=UIUtil.toJavaScript((String)policiesAlreadyConfigured.elementAt(plcy))%>">
         <%=UIUtil.toHTML((String)policiesAlreadyConfigured.elementAt(plcy))%>
         </label>
      </td></tr>       
  <%
     }
  %>
<%
   for (int j=0; j<policiesToChooseFrom.size(); j++) {
      Vector v = (Vector)policiesToChooseFrom.elementAt(j);
%>   
      <tr>
      <td id="SCWPayment_MethodTableCell_1_<%=j%>">
         
         <label for="<%=UIUtil.toJavaScript((String)v.elementAt(0))%>">
         <input id="<%=UIUtil.toJavaScript((String)v.elementAt(0))%>" type="checkbox" name="PaymentPolicy" value="<%=UIUtil.toJavaScript((String)v.elementAt(1))%>">
         <%=UIUtil.toHTML((String)v.elementAt(0))%>
         </label>
      </td></tr>
<%      
   }
%>   
</table>
</form>
<div id="PaymentSection" style="display: none; margin-left: 0">
<table border=0 id="SCWPayment_Table_2">
 <%
 if(customOffline_paymentOptions != null){

 	for(int i=0; i < customOffline_paymentOptions.length; i++){
 %>	

 <tr>
  <td id="SCWPayment_TableCell_1_<%=i%>">

   <input type="checkbox" id="<%=UIUtil.toJavaScript(customOffline_paymentOptions[i][0])%>" onclick="displayOfflineCard();">
   	<label for="<%=UIUtil.toJavaScript(customOffline_paymentOptions[i][0])%>">
   	<script language="JavaScript">
   	 	document.write(parent.changeSpecialText("<%=UIUtil.toHTML(customOffline_paymentOptions[i][1])%>", "<%=UIUtil.toJavaScript(customOffline_paymentOptions[i][0])%>"));
   	
</script>
   	</label>
  </td>
 </tr>

 <%
 	}
 }
 %>

 <tr>
  <td id="SCWPayment_TableCell_2">

   <input type="checkbox" id="paymentType_offlineCard" onclick="displayOfflineCard();">
   <LABEL for="paymentType_offlineCard">
   <%=UIUtil.toHTML((String)resourceBundle.get("paymentType_offlineCard"))%>
   </LABEL>

  </td>
 </tr>

</table>

<table CELLPADDING=0 CELLSPACING=0 BORDER=0 id="SCWPayment_Table_2">
 <tr>
  <td id="SCWPayment_TableCell_3">
   <div id="offlineCard_div">
    <table border="0" id="SCWPayment_Table_3">
     <tr>
      <td id="SCWPayment_TableCell_4">
           <%
     		if(isBrandOptionsAvailable){
     	   %>
        	<label for="selectPaymentBrand">
     	   <%
        	}else{
     	   %>
        	<label for="paymentBrand">
     	   <%
     		}
     	   %>            
		<%=UIUtil.toHTML((String)resourceBundle.get("paymentBrand"))%>
		</label>
      </td>
      <td id="SCWPayment_TableCell_5">
        <label for="paymentCurrency">
	<%=UIUtil.toHTML((String)resourceBundle.get("paymentCurrency"))%>
	</label>
      </td>
      <td id="SCWPayment_TableCell_6"> &nbsp;
      </td>
     </tr>
     <tr>

     <%
     if(isBrandOptionsAvailable){
     %>
      <td id="SCWPayment_TableCell_7">
     		<select id="selectPaymentBrand" SIZE=1 width=100% onchange="changeAddButtonState();">
			<option value="specifyBrand" selected><%=UIUtil.toHTML((String)resourceBundle.get("GeneralPleaseSpecify"))%></option>
     <%
      			for(int i=0; i < customOffline_brandOptions.length; i++){
     %>
     				<option value="<%= UIUtil.toJavaScript(customOffline_brandOptions[i][0]) %>"><%= UIUtil.toHTML(customOffline_brandOptions[i][1]) %></option>
     <%
     			}
     %>	
     		</select>
      </td>
     <%
     }else{
     %>

      <td id="SCWPayment_TableCell_8">
	<input id="paymentBrand" type="TEXT" maxlength="30" size=30 onkeypress="changeAddButtonState();parent.KeyListener(event);" onkeydown="changeAddButtonState();" onkeyup="changeAddButtonState();"></INPUT>
      </td>

     <%
     }
     %> 


      <td id="SCWPayment_TableCell_9">
	<select id="paymentCurrency" SIZE=1 width=100% onchange="changeAddButtonState();">
		<option value="specifyCurrency" selected><%=UIUtil.toHTML((String)resourceBundle.get("GeneralPleaseSpecify"))%></option>
		<%
			Vector curr = scDB.getCurrencies();							
			if (!curr.isEmpty()) {
				for (int i = 0; i < curr.size(); i++) {
					StringPair currStringPair = (StringPair)curr.elementAt(i);
					String currId = currStringPair.getKey();
					String currDesc = currStringPair.getValue();					
					%>															
						<option value="<%= UIUtil.toJavaScript(currId) %>"><%= UIUtil.toHTML(currDesc) %></option>
					<%
				}
			}							
		%>
   	</select>
      </td>
      <td id="SCWPayment_TableCell_10">
             <button type="BUTTON" value="Add" name="addButton" CLASS="disabled" STYLE="width:auto" onClick="if(this.className=='enabled') addButtonAction();"><%=UIUtil.toHTML((String)resourceBundle.get("addButton"))%></button>
      </td>


     </tr>
    </table>
   </div>
  </td>
 </tr>
 <tr>
  <td height=5px id="SCWPayment_TableCell_11">
  </td>
 </tr>
</table>


<div id="paymentTable">
 <table id="layoutTable" border="0">
  <tr>
    <td align="LEFT" valign="TOP" id="SCWPayment_TableCell_12">
      <div style="overflow:auto;height:275px">
      	<script language="JavaScript">
        	initializeDynamicList('valueList');
      	
</script>
      </div>
    </td>
    <td align="LEFT" valign="TOP" id="SCWPayment_TableCell_13">
      <div id="listActionsDiv">
       <table cellpadding=0 cellspacing=0 border=0 id="SCWPayment_Table_5">
        <tr>
          <td id="SCWPayment_TableCell_14">
            <button type="BUTTON" value="Delete" name="removeButton" class="enabled" style="width:auto" onClick="if(this.className=='enabled') removeButtonAction();"><%=UIUtil.toHTML((String)resourceBundle.get("deletePaymentButton"))%></button>
          </td>
        </tr>
      </table>
      </div>
    </td>
  </tr>
</table>
</div>

</div>

</body>
</html>
<%
    }catch (Exception e){ %>
	<script language="JavaScript">
		document.URL="/webapp/wcs/tools/servlet/SCWErrorView";
	
</script>
    <% }	
%>


