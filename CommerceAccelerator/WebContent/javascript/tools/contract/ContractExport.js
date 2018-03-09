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
   addURLParameter("fileName", self.CONTENTS.document.exportForm.name.value);
   addURLParameter("contractId", self.CONTENTS.getContractId());
   addURLParameter("accountId", self.CONTENTS.getAccountId());
   addURLParameter("langId", self.CONTENTS.getLanguageId());
   addURLParameter("contractUsage", self.CONTENTS.getContractUsage());
   addURLParameter("state", self.CONTENTS.getState());
   addURLParameter("xsdName", "Package.xsd");
//   addURLParameter("all", self.CONTENTS.document.exportForm.exportAll.checked);
   addURLParameter("all", "false");
   addURLParameter("XMLFile", "contract.ContractExportPanel");
   addURLParameter("URL", "ContractExportView");
   return true;
 }

function submitErrorHandler(submitErrorMessage, submitErrorStatus)
 {
  if (submitErrorStatus == "DuplicatedContractName")
   {
    put("contractExists", true);
    gotoPanel("Export");
   }
  else
   {
    put("contractGenericError", true);
    gotoPanel("Export");
   }

 }

function submitFinishHandler(submitFinishMessage)
 {
  alertDialog(CONTENTS.getSuccessMessageNLText().replace(/%1/, submitFinishMessage));
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
