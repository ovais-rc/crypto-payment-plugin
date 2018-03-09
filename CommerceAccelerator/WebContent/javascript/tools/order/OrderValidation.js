//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*


   var wait = true;
   var saveIsRunning = false;

   function submitErrorHandler (errMessage, errStatus)
   {
    var remainingAmount ="";
    if(errMessage != null){
       var errMsgTokens = errMessage.split("-");
       if (errMsgTokens.length == 2) {
            if (errMsgTokens[0] == "orderAmountNotReconcileWithPaymentAmount")
     		{ errMessage = errMsgTokens[1];
		 alertDialog(errMessage);
		 gotoPanel("selectPaymentPageNavTabTitle");
		}    
		   if (errMsgTokens[0] == "poException")
     		{  errMessage = errMsgTokens[1];
		       alertDialog(errMessage);
		       gotoPanel("PONumberPageNavTabTitle");
		     } 
     	}    
    }    
     alertDialog(errMessage);
     if (errStatus == "_ERR_ORDER_IS_LOCKED" || errStatus == "_ERR_ORDER_IS_NOT_LOCKED" || errStatus == "_ERR_USER_AUTHORITY") {
     	top.goBack();
     }
   }

   function submitFinishHandler (finishMessage)
   {
     alertDialog(finishMessage);
     top.goBack();
   }
   
   function callOrderRollBack()
   {
     var rollBackURL = "/webapp/wcs/tools/servlet/CSROrderRollBack"
     var CSROrderRollBackURLParam = new Object();
     CSROrderRollBackURLParam.XML = modelToXML("XML");
     CSROrderRollBackURLParam.URL ="/webapp/wcs/tools/servlet/OrderRollBackRedirect";
          	
     top.saveData(CSROrderRollBackURLParam,"CSROrderRollBackURLParam");
     top.mccmain.submitForm(rollBackURL, CSROrderRollBackURLParam);
   
   
   }
   
   function callOrderEditEnd()
   {    
      var order = get("order");
      var editedOrderId;
      var editedOrder;
      if ( defined(order["firstOrder"]) ) {
          editedOrder = order["firstOrder"];
          if(editedOrder!=null){
            editedOrderId = editedOrder["id"];         
          }
       }      
     
     var orderEditEndURL = "/webapp/wcs/tools/servlet/AdvancedOrderEditEnd?orderId="+editedOrderId;   
     var CSROrderEditEndURLParam = new Object();
     //CSROrderEditEndURLParam.XML = modelToXML("XML");
    // CSROrderEditEndURLParam.URL ="RedirectView?URL=OrderRollBackRedirect";
          	
     //top.saveData(CSROrderEditEndURLParam,"CSROrderEditEndURLParam");
     top.mccmain.submitForm(orderEditEndURL, CSROrderEditEndURLParam);  
   }
   function submitCancelHandler()
   {
     //callOrderRollBack();
     callOrderEditEnd();
     if (top.mccbanner)
		{top.mccbanner.waitForCancel = false;}
	
   	 top.goBack();
     
   }
   
   function cancelOnBCT() 
   {
     	//callOrderRollBack();
       saveOrderAction()
   }
   
  /*
   -- checkPayment(paymentObject)
   -- Return "fine" if paymentObject is correct
   -- Return "emptyEntries" if paymentObject has empty fields
   -- Return "nothingSelected" if paymentObject has no payment method
   -- */   
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
   
  /*
   -- validatePayment()
   -- Return true if all data is valid
   -- Return false if something is wrong and re-directs to payment page
   -- */   
   function validatePayment(){      
        var order = get("order");
   	    var remainingAmount = 0;    	     	  	       
        if (defined(order["firstOrder"])) {
         var  firstOrder = order["firstOrder"];   
        }
        
      if(defined(firstOrder) && (firstOrder.hasItems != "false") && defined(firstOrder["paymentRemainingAmount"])){
         var paymentRemainingAmount = firstOrder["paymentRemainingAmount"];         
         if(paymentRemainingAmount.remainingValue != null){        	 
        	remainingAmount = paymentRemainingAmount.remainingValue;                
        } 
       }                
       if (remainingAmount > 0.00) {
           err = "paymentErrorMsg_paymentRemainingAmount_"+remainingAmount;
           gotoPanel("selectPaymentPageNavTabTitle", err);
          return false;
        }
       
       // var callPrepareRequired = get("callPrepareRequired"); 
   		//alert("callPrepareRequired:"+callPrepareRequired);
		//if(defined(callPrepareRequired)&& callPrepareRequired == "true" ){
		//    err = "paymentErrorMsg_paymentRemainingAmount";
		//	gotoPanel("selectPaymentPageNavTabTitle");
		//	return false;
		//} 
              // }
         
         return true;
   }
   function validatePayment_bak() {
         var order = get("order");
         var orderWithProblems = "";
         var paymentProblems = "fine";
         
         if ( defined(order["firstOrder"]) ) {
            var firstOrder = order["firstOrder"];
         }
         
         if ( defined(order["secondOrder"]) ) {
            var secondOrder = order["secondOrder"];
            
            if (!defined(secondOrder["billingAddressId"])) {
            	secondOrder.billingAddressId = "";
            }
         }
         
         if ( defined(firstOrder) && (firstOrder.hasItems != "false") ) {
            var paymentProblems = checkPayment(firstOrder["payment"]);
            if ( defined(secondOrder) && (secondOrder.hasItems != "false"))
               orderWithProblems = firstOrder["id"];
         }

         if ( paymentProblems == "fine" && defined(secondOrder) && (secondOrder.hasItems != "false") ) {
            var paymentProblems = checkPayment(secondOrder["payment"]);
            if ( defined(firstOrder) && (firstOrder.hasItems != "false") )
               orderWithProblems = secondOrder["id"];            
         }
         
         if ( (paymentProblems == "emptyEntries") && (orderWithProblems == "") ) {
            err = "paymentErrorMsg";
            gotoPanel("selectPaymentPageNavTabTitle", err);
            return false;
         }
         if ( (paymentProblems == "emptyEntries") && (orderWithProblems != "") ) {
            err = "paymentErrorMsg" + "_" + orderWithProblems;
            gotoPanel("selectPaymentPageNavTabTitle", err);
            return false;
         }
         if ( (paymentProblems == "nothingSelected") && (orderWithProblems == "") ) {
            err = "selectPaymentType";
            gotoPanel("selectPaymentPageNavTabTitle", err);
            return false;
         }
         if ( (paymentProblems == "nothingSelected") && (orderWithProblems != "") ) {
            err = "selectPaymentType" + "_" + orderWithProblems;
            gotoPanel("selectPaymentPageNavTabTitle", err);
            return false;
         }
                  
         return true;
   }


  /*
   -- validateAllPanels(name)
   -- Return true if all data is valid
   -- already done all the validation inside individual panel
   -- */
  function validateAllPanels()
  {
    
    return validatePayment();
  }
 function saveOrderAction(){ 
     put("isSave", "true");

    finish();
  	} 	
 function submitOrderAction(){
   put("isSave", "false");
   finish();
 }
