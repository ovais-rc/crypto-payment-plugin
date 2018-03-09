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

function submitErrorHandler (errMessage, errorStatus) {
  if (errMessage != null && errMessage != "") {
  	errMessage=CONTENTS.getErrorMsg(errMessage);
	alertDialog(errMessage);
	}
}

function submitFinishHandler(submitFinishMessage)
 {
  if (submitFinishMessage != null && submitFinishMessage != "")
	alertDialog(submitFinishMessage);
	top.goBack();
} 

function submitCancelHandler() {
	if (CONTENTS.getCancelConfirmationMsg()!=null && CONTENTS.getCancelConfirmationMsg() !="") {
		if (confirmDialog(CONTENTS.getCancelConfirmationMsg())) {
			top.goBack();
		}
	}
	else {
		top.goBack();
		}
}

function preSubmitHandler() {
	put("queueId",CONTENTS.getQueueId());
	put("allCSR",CONTENTS.getAllCSR());
	put("CSRIds",CONTENTS.getAssignedCSRs());
}
