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

  function submitErrorHandler (errMessage)
  {
     alert("Inside my version of submitErrorHandler()");
     alert(errMessage);
  }

  function submitFinishHandler (finishMessage)
  {
     self.CONTENTS.doEdit();	
     self.opener.focus();
  }

// Currently the dialog doesn't call submit Cancel Handler - cancel in this dialog is performed by 
// cancelRuleService function
  function submitCancelHandler() {
	self.CONTENTS.cancel();
	self.opener.focus();
	//self.close();
  }


 function cancelRuleService() {
	self.CONTENTS.doCancel();
 }


  function editRuleService() 
  {	
	self.CONTENTS.doEdit();
  }
  
 