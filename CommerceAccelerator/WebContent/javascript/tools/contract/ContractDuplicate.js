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
   addURLParameter("name", self.CONTENTS.document.duplicateForm.name.value);
   addURLParameter("contractId", self.CONTENTS.getContractId());
   addURLParameter("XMLFile", "contract.ContractDuplicate");
   return true;
 }

function submitErrorHandler(submitErrorMessage, submitErrorStatus)
 {
  if (submitErrorStatus == "DuplicatedContractName")
   {
    put("contractExists", true);
    gotoPanel("Duplicate");
   }
  else
   {
    put("contractGenericError", true);
    gotoPanel("Duplicate");
   }

 }

function submitFinishHandler(submitFinishMessage)
 {
  if (submitFinishMessage != null && submitFinishMessage != "")
	alertDialog(submitFinishMessage);
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
