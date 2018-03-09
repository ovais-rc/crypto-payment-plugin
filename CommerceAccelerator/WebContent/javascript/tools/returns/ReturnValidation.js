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


   function submitErrorHandler (errMessage)
   {
     alertDialog(errMessage);
   }

   function submitFinishHandler (finishMessage)
   {
     CONTENTS.rmaFinishHandler(finishMessage);
   }
   
   function callRestoreCopy()
   {
     var restoreCopyURL = "/webapp/wcs/tools/servlet/CSRReturnRestoreCopy"
     var CSRReturnRestoreCopyURLParam = new Object();
     CSRReturnRestoreCopyURLParam.XML = modelToXML("XML");
     CSRReturnRestoreCopyURLParam.URL ="/webapp/wcs/tools/servlet/ReturnRestoreCopyRedirect";
          	
     top.setReturningPanel(getCurrentPanelAttribute("name"));
     top.saveData(CSRReturnRestoreCopyURLParam,"CSRReturnRestoreCopyURLParam");
     top.setContent("",restoreCopyURL, true, CSRReturnRestoreCopyURLParam);
   }

   function callReturnCancel()
   {
     var returnCancelURL = "/webapp/wcs/tools/servlet/CSRReturnCancel"
     var CSRReturnCancelURLParam = new Object();
     CSRReturnCancelURLParam.XML = modelToXML("XML");
     CSRReturnCancelURLParam.URL ="/webapp/wcs/tools/servlet/ReturnCancelGoBack";

     top.setReturningPanel(getCurrentPanelAttribute("name"));
     top.saveData(CSRReturnCancelURLParam,"CSRReturnCancelURLParam");
     top.setContent("",returnCancelURL, true, CSRReturnCancelURLParam);
   }

   function submitCancelHandler()
   {
     if (get("edit") == "true") {
     	callRestoreCopy();
     } else {
     	if (get("returnId") != "" && defined(get("returnId")) && get("returnId") != "0") {
     	   callReturnCancel();
     	   return;
     	}
	top.goBack();
     }
   }

   function cancelOnBCT() 
   {
     submitCancelHandler();
   }

    function validateAllPanels() {
    	//alert(modelToXML("XML"));
	if (get("refundPolicyId") == "" || get("refundPolicyId") == null) {
	    gotoPanel("ReturnCreditMethodPage", "policyIdMissing");
            return false;
	}
	if ((get("refundPolicyId") == "-2001" && get("usablePiSize")=="0")||(get("refundPolicyId") == "-2000" && get("piSize")=="0")){
	    gotoPanel("ReturnCreditMethodPage", "policyIdMissing");
            return false;
	}
        return true;
    }

   function preSubmitHandler()
   {
     remove("preCmdChain");
     if (getCurrentPanelAttribute("name") == "ReturnItemsPage") {
     	//setup command chain for UPDATE and PREPARE
	var preCmdChain = new Object();
	var preCommand = new Vector();
	var aCmd = new Object();
	aCmd.name = "CSRReturnItemUpdate"
	addElement(aCmd, preCommand);
	var bCmd = new Object();
	bCmd.name = "CSRReturnPrepare"
	addElement(bCmd, preCommand);
	preCmdChain.preCommand = preCommand;
	put("preCmdChain",preCmdChain);
	//alert(modelToXML("XML"));
     } else if (getCurrentPanelAttribute("name") == "ReturnCommentsPage") {
     	//setup command chain for PREPARE
	var preCmdChain = new Object();
	var preCommand = new Vector();
	var aCmd = new Object();
	aCmd.name = "CSRReturnUpdate"
	addElement(aCmd, preCommand);
	preCmdChain.preCommand = preCommand;
	put("preCmdChain",preCmdChain);
	//alert(modelToXML("XML"));
     } else if (getCurrentPanelAttribute("name") == "ReturnCreditMethodPage") {
     	//setup command chain for PREPARE
	var preCmdChain = new Object();
	var preCommand = new Vector();
	var aCmd = new Object();
	aCmd.name = "CSRReturnPrepare"
	addElement(aCmd, preCommand);
	preCmdChain.preCommand = preCommand;
	put("preCmdChain",preCmdChain);
	//alert(modelToXML("XML"));
     }
   }
   
