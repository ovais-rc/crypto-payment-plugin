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

function validateInvoicing() {
  return true;
}

function submitInvoicing(account) {
  var o = get("ContractInvoicingModel");
  if (o != null) {
        var tcArray = new Array();
	if (o.eMail == true || o.contractHaseMail == true) {
		var invoice = new Object();
		invoice = new Object();
		invoice.deliveryMethod = "eMail";
		tcArray[tcArray.length] = invoice;
		if (o.eMail == true && o.contractHaseMail == true) {
			invoice.action = "noaction";
			invoice.referenceNumber = o.contractHaseMailReferenceNumber;
		}
		else if (o.eMail == true) {
			invoice.action = "new";
		}
		else if (o.contractHaseMail == true) {
			invoice.action = "delete";
			invoice.referenceNumber = o.contractHaseMailReferenceNumber;
		}
	} 
	if (o.inTheBox == true || o.contractHasinTheBox == true) {
		var invoice = new Object();
		invoice.deliveryMethod = "printed";
		tcArray[tcArray.length] = invoice;
		if (o.inTheBox == true && o.contractHasinTheBox == true) {
			invoice.action = "noaction";
			invoice.referenceNumber = o.contractHasinTheBoxReferenceNumber;
		}
		else if (o.inTheBox == true) {
			invoice.action = "new";
		}
		else if (o.contractHasinTheBox == true) {
			invoice.action = "delete";
			invoice.referenceNumber = o.contractHasinTheBoxReferenceNumber;
		}
	}
	if (o.regularMail == true || o.contractHasregularMail == true) {
		var invoice = new Object();
		invoice.deliveryMethod = "regularMail";
		tcArray[tcArray.length] = invoice;
		if (o.regularMail == true && o.contractHasregularMail == true) {
			invoice.action = "noaction";
			invoice.referenceNumber = o.contractHasregularMailReferenceNumber;
		}
		else if (o.regularMail == true) {
			invoice.action = "new";
		}
		else if (o.contractHasregularMail == true) {
			invoice.action = "delete";
			invoice.referenceNumber = o.contractHasregularMailReferenceNumber;
		}
	}
	if (tcArray.length > 0)
		account.InvoiceTC = tcArray;
  }

 return true;
}
