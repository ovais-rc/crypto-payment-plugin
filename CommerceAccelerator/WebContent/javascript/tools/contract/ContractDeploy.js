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

function preSubmitHandler()
 {
   addURLParameter("targetStoreId", self.CONTENTS.document.deployForm.Store.options[self.CONTENTS.document.deployForm.Store.selectedIndex].value);
   addURLParameter("contractId", self.CONTENTS.getContractId());
   addURLParameter("accountId", self.CONTENTS.getAccountId());
   addURLParameter("XMLFile", "contract.ContractDeploy");
   return true;
 }

function submitErrorHandler(submitErrorMessage, submitErrorStatus)
 {
   if (submitErrorStatus == "ContractAlreadyDeployedToTheStore")
   {
    put("contractDeployAlreadyError", true);
    gotoPanel("Deploy");
   }
  else if (submitErrorStatus == "BusinessPolicyNotAvailableForTheStore")
   {
    put("contractDeployPolicyError", true);
    gotoPanel("Deploy");
   }
  else
   {
    put("contractGenericError", true);
    gotoPanel("Deploy");
   }
 }

function submitFinishHandler(submitFinishMessage)
 {
  //if (submitFinishMessage != null && submitFinishMessage != "")
	//alertDialog(submitFinishMessage);
  submitCancelHandler();
 }

function submitCancelHandler()
 {
  if (top.goBack)
   {
    top.goBack();
   }
  else
   {
    window.location.replace("NewDynamicListView?ActionXMLFile=contract.ContractList&cmd=ContractListView");
   }
 }
