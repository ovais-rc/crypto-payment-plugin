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


   function submitErrorHandler (errMessage)
   {
     //alertDialog(errMessage);
     if(errMessage != null){
       var errMsgTokens = errMessage.split("-");
       if (errMsgTokens.length == 2) {
          if (errMsgTokens[0] == "orderAmountNotReconcileWithPaymentAmount")
     		{  errMessage = errMsgTokens[1];
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
   	if (errMessage == "changeStatusDatabaseError")
        	alertDialog(changeStatusDatabaseErrorMsg);
        else if (errMessage == "")
             	alertDialog(noResourceBundleMsg);
        else
             	alertDialog(errMessage);

   }

   function submitFinishHandler (finishMessage)
   {
     alertDialog(finishMessage);
     top.goBack();
   }
   
   function callCancelOrder() {
   	
   	var order = get("order");
   	var firstOrder = null;
   	var secondOrder = null;
   	var orders = null;
   	
   	
   	if (order != null) {
   		orders = new Vector();
   		firstOrder = order.firstOrder;
   		secondOrder = order.secondOrder;
   		
   		if ((firstOrder != null) && (trim(firstOrder.id) != "")) {

   			addElement(firstOrder.id, orders);
   			
   			if ((secondOrder != null) && (trim(secondOrder.id) != "") ) {
   				addElement(secondOrder.id, orders);
   			}
   	  
			var cancelURL = "/webapp/wcs/tools/servlet/CSROrderCancel";
	   		var urlParam = new Object();
   	
	   		put("sendEmail", "false");
	   		put("selectedOrders", orders);
			put("notifyShopper", "no");
			put("commentField", "");
   	
	   		urlParam.XML = modelToXML("XML");
		   	urlParam.URL = "/webapp/wcs/tools/servlet/OrderRollBackRedirect";
   	
		   	top.saveData(urlParam, "CancelOrderURLParam");
		   	top.mccmain.submitForm(cancelURL, urlParam);
		} else {
			top.goBack();
		}
	} else {
	
		top.goBack();
	}
   }
   
   function submitCancelHandler()
   {
     callCancelOrder();
   
   }
   
   function cancelOnBCT() 
   {
     callCancelOrder();
   }
   


  /*
   -- validateAllPanels(name)
   -- Return true if all data is valid
   -- already done all the validation inside individual panel
   -- */
  function validateAllPanels()
  {
    return true;
  }
