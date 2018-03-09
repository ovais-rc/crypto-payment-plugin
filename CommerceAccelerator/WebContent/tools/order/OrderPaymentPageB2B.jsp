<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.order.beans.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.optools.order.commands.ECOptoolsConstants" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@include file="../common/common.jsp" %>

<%
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();
Hashtable orderMgmtNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);

CommandContext cmdContext = (CommandContext)request.getAttribute("CommandContext");
String storeId = cmdContext.getStoreId().toString();
String localeUsed = cmdContext.getLocale().toString();

com.ibm.commerce.server.JSPHelper URLParameters = new com.ibm.commerce.server.JSPHelper(request);
String firstOrderId = URLParameters.getParameter(ECOptoolsConstants.EC_OPTOOL_FIRSTORDER_ID);
String secondOrderId = URLParameters.getParameter(ECOptoolsConstants.EC_OPTOOL_SECONDORDER_ID);


//
// Check if orders actually have order items.
//
OrderDataBean orderBean = new OrderDataBean ();
OrderDataBean orderBean2 = new OrderDataBean ();
OrderItemDataBean[] afirstOrderItems = null;
OrderItemDataBean[] asecondOrderItems = null;
boolean firstOrderExist = false;
boolean secondOrderExist = false;

if ((firstOrderId != null) && !(firstOrderId.equals(""))) {
	orderBean.setOrderId(firstOrderId);
	com.ibm.commerce.beans.DataBeanManager.activate(orderBean, request);
	afirstOrderItems = orderBean.getOrderItemDataBeans();
	if (afirstOrderItems.length != 0)
		firstOrderExist = true;
}

if ((secondOrderId != null) && !(secondOrderId.equals(""))) {
	orderBean2.setOrderId(secondOrderId);
	com.ibm.commerce.beans.DataBeanManager.activate(orderBean2, request);
	asecondOrderItems = orderBean2.getOrderItemDataBeans();
	if (asecondOrderItems.length != 0)
		secondOrderExist = true;
}


boolean multiOrder = false;
if ( firstOrderExist && secondOrderExist ) {
	multiOrder = true;
}

%>

<html>
<head>
   <title><%= UIUtil.toHTML( (String)orderMgmtNLS.get("paymentOptionTitle")) %></title>
   <link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />

   <script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
   <script type="text/javascript" src="/wcs/javascript/tools/common/Vector.js"></script>
   <script type="text/javascript" src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>
   <script type="text/javascript" src="/wcs/javascript/tools/common/ConvertToXML.js"></script>
   <script type="text/javascript">
     <!-- <![CDATA[
   
      var order = parent.get("order");
      
      ////////////////////////////////////////////////////////
      // Initialize the state of this page                  //
      ////////////////////////////////////////////////////////
      function initializeState() 
      {
      	
         checkForErrors();
         parent.setContentFrameLoaded(true);
      }

      function checkForErrors() {         
         if ( defined(parent.getErrorParams()) ) {
            errorCode = parent.getErrorParams();
            errorTokens = errorCode.split("_");
            
            if (errorTokens.length == 1) {
               if (errorTokens[0] = "emptyEntries") {
                  alertDialog("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("paymentErrorMsg")) %>");
               } else if (errorTokens[0] = "nothingSelected") {
                  alertDialog("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("selectPaymentType")) %>");
               }
            }

            if (errorTokens.length == 2) {
               if (errorTokens[0] = "emptyEntries") {
                  message = "<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("paymentErrorMsg2Orders")) %>".replace(/%1/, errorTokens[1]);
                  alertDialog(message);
               } else if (errorTokens[0] = "nothingSelected") {
                  message = "<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("selectPaymentType2Orders")) %>".replace(/%1/, errorTokens[1]);
                  alertDialog(message);
               }
            }
             if (errorTokens.length == 3) {  
                 //alert("errorTokens[0]/1/2:"+errorTokens[0]+"/"+errorTokens[1]+"/"+errorTokens[2]); 
                var remainingAmount =  errorTokens[2];
                var currentRemaining = remainingAmount;
                if(this.OrderPaymentSelection.document.PaymentMethodsDisplayForm.remainingAmount.value){
                   currentRemaining = parseFloat(this.OrderPaymentSelection.document.PaymentMethodsDisplayForm.remainingAmount.value);         	 
                }     
              //  alert("remainingAmount/currentRemaining"+remainingAmount+"/"+currentRemaining);                 
             	if (remainingAmount > 0 && (currentRemaining >= remainingAmount)){             	   
              		message = "<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("orderAmountNotReconcileWithPaymentAmount")) %>";
             		alertDialog(message);
             	}            		
            }            
         }
      }
  
  
      function checkPayment(payment) {
         var returnCode = "fine";
    
         if ( defined(payment) && payment.length != 0 ) {
            paymentNotSelected = "true";
            for (var i in payment) {
               paymentNotSelected = "false";
    	       if ( (payment[i] == "") && (i != "paymentTCId") ) {
    	          returnCode = "emptyEntries";
    	          break;
    	       }
            }
            if (paymentNotSelected == "true") {
               returnCode = "nothingSelected";
            }
         } else {
            returnCode = "nothingSelected";
         }
         
         return returnCode;
      }
      
      //function that removes the specific field name from the object.
      //returns the new object without the field.
      function removeFromObj(fieldName, anObj) {
         var newObj = new Object();
         for (var i in anObj) {
            if (i != fieldName) {
               newObj[i] = anObj[i];
            }
         }
         return newObj;
      }
      
      //used to save the data in the panel to the model in both Notebook and Wizard
      function savePanelData() {
     	 var order = parent.get("order");    	     	 
      	 var paymentRemainingAmount = new Object();
      	 if (defined(this.OrderPaymentSelection.document.forms[1])){     	    
      	 	var orderToChange = order[this.OrderPaymentSelection.document.PaymentMethodsDisplayForm.displayPaymentFor.value];
      		 paymentRemainingAmount.remainingValue = parseFloat(this.OrderPaymentSelection.document.PaymentMethodsDisplayForm.remainingAmount.value);         	
       	     // alert(" paymentRemainingAmount.remainingValue:"+ paymentRemainingAmount.remainingValue);
       	     // save the payment object into the "model"
             updateEntry(orderToChange, "paymentRemainingAmount", paymentRemainingAmount);          
       	 }     
       	 var authToken = parent.get("authToken");
	 if (defined(authToken)) {
		parent.addURLParameter("authToken", authToken);
	 }       
      }
      
   function savePanelData_bak() {
         var order = parent.get("order");         
         var orderToChange = order[OrderPaymentSelection.document.form1.displayPaymentFor.value];
         var payment = new Object();
         
         // save all payment fields that are in the snipplet
         if ( defined(OrderPaymentResult.document.f1) ) {
            var paymentResultsForm = OrderPaymentResult.document.f1;
            var numberOfElements = paymentResultsForm.elements.length;
           
            var selectedIndex;
         
            for (var i=0;i<numberOfElements;i++) {
               if ( paymentResultsForm.elements[i].type == "select-one" ) {
                  selectedIndex = paymentResultsForm.elements[i].selectedIndex;
                  payment[paymentResultsForm.elements[i].name] = paymentResultsForm.elements[i].options[selectedIndex].value;
               } else {
                  payment[paymentResultsForm.elements[i].name] = paymentResultsForm.elements[i].value;
               }
            }
         }
         
         var paymentProfile = parent.get("paymentProfile");
         if (defined(paymentProfile)) {
            for (var i in paymentProfile) {
               if (defined(payment[i]) && paymentProfile[i] != "")
                  payment[i] = paymentProfile[i];
            }
         }
         
         
         // save the PurchaseOrderNumber (Optional field) if it is not empty
         // 1. assumption that there is only one element in form
         if ( defined(this.OrderPaymentPONumber) && defined(this.OrderPaymentPONumber.document.f1) ) {
            var paymentPONumberForm = OrderPaymentPONumber.document.f1;
            if ( paymentPONumberForm.elements[0].value != "" ) {
               payment[paymentPONumberForm.elements[0].name] = paymentPONumberForm.elements[0].value;
            }
         }
         
         //save billing address id if defined in the payment object
         if (defined(payment["billingAddressId"])) {
            updateEntry(orderToChange, "billingAddressId", payment["billingAddressId"]);
            payment = removeFromObj("billingAddressId", payment);
         }
         
         // save the payment object into the "model"
         updateEntry(orderToChange, "payment", payment);
      }

      function validatePanelData(){     
        //alert("remaining amount(float):"+parseFloat(this.OrderPaymentSelection.document.forms[1].remainingAmount.value));
      	if (defined(this.OrderPaymentSelection.document.forms[1])){      	
          	if(parseFloat(this.OrderPaymentSelection.document.forms[1].remainingAmount.value) > 0.00){
          		// alert("remaining amount(float):"+parseFloat(this.OrderPaymentSelection.document.forms[1].remainingAmount.value));
           	 	//gotoPanel("selectPaymentOptionTab");
           	var message = '<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("remainingPaymentAmountLargerThanZero")) %>';
           	var answer = confirmDialog(message);
	      	//if (answer == false) {	      		
	      	//}
	      	return answer;                   
         }      
      	}
      	return true;      
      }
      
    function validateNoteBookPanel() {  
		return validatePanelData();
	}
	
      function validatePanelData_bak() {
         var order = parent.get("order");
         var orderWithProblems = "";
         var paymentProblems = "fine";
         
         if ( defined(order["firstOrder"]) ) {
            var firstOrder = order["firstOrder"];
         }
         
         if ( defined(order["secondOrder"]) ) {
            var secondOrder = order["secondOrder"];
         }
         
         if ( defined(firstOrder) && (firstOrder.hasItems != "false") ) {
            var paymentProblems = checkPayment(firstOrder["payment"]);
            if ( defined(secondOrder) && (secondOrder.hasItems != "false") )
               orderWithProblems = firstOrder["id"];
         }

         if ( paymentProblems == "fine" && defined(secondOrder) && (secondOrder.hasItems != "false") ) {
            var paymentProblems = checkPayment(secondOrder["payment"]);
            if ( defined(firstOrder) && (firstOrder.hasItems != "false") )
               orderWithProblems = secondOrder["id"];            
         }
         
         if ( (paymentProblems == "emptyEntries") && (orderWithProblems == "") ) {
            //gotoPanel("selectPaymentOptionTab");
            alertDialog("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("paymentErrorMsg")) %>");
            return false;
         }
         if ( (paymentProblems == "emptyEntries") && (orderWithProblems != "") ) {
            //gotoPanel("selectPaymentOptionTab");
            message = "<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("paymentErrorMsg2Orders")) %>".replace(/%1/, orderWithProblems);
            alertDialog(message);
            return false;
         }
         if ( (paymentProblems == "nothingSelected") && (orderWithProblems == "") ) {
            //gotoPanel("selectPaymentOptionTab");
            alertDialog("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("selectPaymentType")) %>");
            return false;
         }
         if ( (paymentProblems == "nothingSelected") && (orderWithProblems != "") ) {
            //gotoPanel("selectPaymentOptionTab");
            message = "<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("selectPaymentType2Orders")) %>".replace(/%1/, orderWithProblems);
            alertDialog(message);
            return false;
         }
                  
         return true;
      }

      function visibleList(s)
      {
         if (!this.OrderPaymentSelection || this.OrderPaymentSelection.document.readyState != "complete")
            return;
   
         if (this.OrderPaymentSelection.document.forms[0])
            for (var i = 0; i < this.OrderPaymentSelection.document.forms[0].elements.length; i++) {
                  if (this.OrderPaymentSelection.document.forms[0].elements[i].type.substring(0,6) == "select") {
                     this.OrderPaymentSelection.document.forms[0].elements[i].style.visibility = s;
                  }
            }

         if (!this.OrderPaymentResult || this.OrderPaymentResult.document.readyState != "complete")
            return;
   
         if (this.OrderPaymentResult.document.forms[0])
            for (var i = 0; i < this.OrderPaymentResult.document.forms[0].elements.length; i++) {
                  if (this.OrderPaymentResult.document.forms[0].elements[i].type.substring(0,6) == "select") {
                     this.OrderPaymentResult.document.forms[0].elements[i].style.visibility = s;
                  }
            }

      }
      
      function getOrderSelectPaymentPage(){
        var url = parent.generateFullURL("/wcs/tools/order/OrderSelectPaymentB2B.html");        
        return parent.generateFullURL("/wcs/tools/order/OrderSelectPaymentB2B.html");
      }
 // function callOrderPrepare(){
 //    var csrOrderprepareRequired = parent.get("callPrepareRequired");
 //    alert("csrOrderprepareRequired:"+csrOrderprepareRequired);
 //    if(defined(csrOrderprepareRequired) && csrOrderprepareRequired == "true"){
 //       var order = parent.get("order"); 
  //      if ( defined(order["firstOrder"]) ) {
 //           var firstOrder = order["firstOrder"];
  //          var orderId = firstOrder["id"];
 //        }
 //        alert("orderId:"+orderId);
         
  //   	 parent.put("callPrepareRequired","false");
   // 	 var orderPrepareURL = "/webapp/wcs/tools/servlet/CSROrderPrepare";
    	 //var orderPrepareURLParam = new Object();
  //  	 this.OrderPaymentSelection.document.forms[1].XML =parent.modelToXML("XML");
 		
 //		 this.OrderPaymentSelection.document.forms[1].URL =orderPrepareURL+"?URL=/webapp/wcs/tools/servlet/OrderPaymentPageB2B?firstOrderId=" + orderId; 
 		// alert(" orderPrepareURLParam.URL:"+ orderPrepareURLParam.URL);	
 		// alert("orderPrepareURLParam.XML"+orderPrepareURLParam.XML);	
 		// top.saveData(orderPrepareURLParam,"orderPrepareURLParam");
  		// top.mccmain.submitForm(orderPrepareURL, orderPrepareURLParam, parent.CONTENTS); 
  //		this.OrderPaymentSelection.document.forms[1].submit();
 //    }    
 //}
      //[[>-->
      </script>
</head>

<!--frameset rows="*,*,*"-->
<frameset rows="*">
  <frame name="OrderPaymentSelection" title='<%= UIUtil.toHTML( (String)orderMgmtNLS.get("selectPaymentOptionTab_title")) %>'
	<% if (multiOrder) { %>
		src="/webapp/wcs/tools/servlet/OrderPaymentSelection?locale=<%= localeUsed %>&amp;multiOrder=true&amp;displayPaymentFor=firstOrder&amp;<%= ECOptoolsConstants.EC_OPTOOL_FIRSTORDER_ID %>=<%= firstOrderId %>&amp;<%= ECOptoolsConstants.EC_OPTOOL_SECONDORDER_ID %>=<%= secondOrderId %>"
	<% } else if ( firstOrderExist ) { %>
		src="/webapp/wcs/tools/servlet/OrderPaymentSelection?locale=<%= localeUsed %>&amp;multiOrder=false&amp;<%= ECOptoolsConstants.EC_OPTOOL_FIRSTORDER_ID %>=<%= firstOrderId %>"
	<% } else { %>
		src="/webapp/wcs/tools/servlet/OrderPaymentSelection?locale=<%= localeUsed %>&amp;multiOrder=false&amp;<%= ECOptoolsConstants.EC_OPTOOL_SECONDORDER_ID %>=<%= secondOrderId %>"
	<% } %>
    
    frameborder="0"
    noresize="noresize"
    scrolling="auto"
    marginwidth="15"
    marginheight="15" />
    <!--frame name="OrderPaymentPONumber"
    src="/wcs/tools/common/blank.html"
    title='<%= UIUtil.toHTML( (String)orderMgmtNLS.get("paymentSelectMethod")) %>'
    frameborder="0" 
    noresize="noresize"
    scrolling="auto" 
    marginwidth="15" 
    marginheight="0" /-->
  <frame name="OrderPaymentPONumber"
    src="/wcs/tools/common/blank.html"
    title='<%= UIUtil.toHTML( (String)orderMgmtNLS.get("paymentPONumberTitle")) %>'
    frameborder="0" 
    noresize="noresize" 
    scrolling="auto" 
    marginwidth="15" 
    marginheight="0" /-->
  </frameset>
</html>



