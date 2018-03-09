<!--==========================================================================
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
  ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page language="java"
import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.tools.contract.beans.InvoicingTCDataBean,
	com.ibm.commerce.tools.util.UIUtil" %>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<html>

<head>
 <%= fHeader %>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

 <title><%= contractsRB.get("contractInvoicingPanelPrompt") %></title>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>

 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Invoicing.js">
</script>

 <script LANGUAGE="JavaScript">

function loadPanelData()
 {
  with (document.invoicingForm)
   {
    if (parent.setContentFrameLoaded)
     {
      parent.setContentFrameLoaded(true);
     }

    if (parent.get)
     {
      var hereBefore = parent.get("ContractInvoicingModelLoaded", null);
      if (hereBefore != null) {
	//alert('Invoicing - back to same page - load from model');
	// have been to this page before - load from the model
        var o = parent.get("ContractInvoicingModel", null);
	if (o != null) {
		Email.checked = o.eMail;
		InTheBox.checked = o.inTheBox;
		RegularMail.checked = o.regularMail;
	}

     } else {
	// this is the first time on this page
	//alert('Invoicing - first time on page');

	// create the model
        var cim = new Object();
	cim.eMail = "";
	cim.inTheBox = "";
	cim.regularMail = "";
	cim.contractHaseMail = false;
	cim.contractHasinTheBox = false;
	cim.contractHasregularMail = false;
	cim.contractHaseMailReferenceNumber = "";
	cim.contractHasinTheBoxReferenceNumber = "";
	cim.contractHasregularMailReferenceNumber = "";

        parent.put("ContractInvoicingModel", cim);
	parent.put("ContractInvoicingModelLoaded", true);

	// check if this is an update
	if (<%= foundAccountId %> == true) {
		//alert('Load from the databean');
		// load the data from the databean
		<%
		// Create an instance of the databean to use if we are doing an update
		if (foundAccountId) {
			InvoicingTCDataBean tc = new InvoicingTCDataBean(new Long(accountId), new Integer(fLanguageId));
			DataBeanManager.activate(tc, request);
			if (tc.getHasEMail()) {
				out.println("Email.checked = true;");
				out.println("cim.contractHaseMail = true;");
				out.println("cim.contractHaseMailReferenceNumber = '" + tc.getHasEMailReferenceNumber() + "';");
			}
			if (tc.getHasInTheBox()) {
				out.println("InTheBox.checked = true;");
				out.println("cim.contractHasinTheBox = true;");
				out.println("cim.contractHasinTheBoxReferenceNumber = '" + tc.getHasInTheBoxReferenceNumber() + "';");
			}
			if (tc.getHasRegularMail()) {
				out.println("RegularMail.checked = true;");
				out.println("cim.contractHasregularMail = true;");
				out.println("cim.contractHasregularMailReferenceNumber = '" + tc.getHasRegularMailReferenceNumber() + "';");
			}
		}
		%>
	} else {
		Email.checked = false;
		InTheBox.checked = false;
		RegularMail.checked = false;
	}

     }

    // handle error messages back from the validate page


    }
   }
 }

function savePanelData()
 {
  //alert ('Invoicing savePanelData');
  with (document.invoicingForm)
   {
    if (parent.get)
     {
        var o = parent.get("ContractInvoicingModel", null);
        if (o != null) {
		o.eMail = Email.checked;
	        o.inTheBox = InTheBox.checked;
	        o.regularMail = RegularMail.checked;
        }
     }
   }
 }


</script>

</head>

<body ONLOAD="loadPanelData()" class="content">

<h1><%= contractsRB.get("contractInvoicingPanelPrompt") %></h1>

<form NAME="invoicingForm" id="invoicingForm">

<%= contractsRB.get("contractInvoicingText") %>
<br>
<br>

<input NAME="Email" TYPE="CHECKBOX" VALUE="CHECKED" id="ContractInvoicing_FormInput_Email_In_invoicingForm_1">
    <label for="ContractInvoicing_FormInput_Email_In_invoicingForm_1"><%= contractsRB.get("contractInvoicingEmail") %></label>
<br>
<input NAME="InTheBox" TYPE="CHECKBOX" VALUE="CHECKED" id="ContractInvoicing_FormInput_InTheBox_In_invoicingForm_1">
    <label for="ContractInvoicing_FormInput_InTheBox_In_invoicingForm_1"><%= contractsRB.get("contractInvoicingInTheBox") %></label>
<br>
<input NAME="RegularMail" TYPE="CHECKBOX" VALUE="CHECKED" id="ContractInvoicing_FormInput_RegularMail_In_invoicingForm_1">
    <label for="ContractInvoicing_FormInput_RegularMail_In_invoicingForm_1"><%= contractsRB.get("contractInvoicingRegularMail") %></label>

</form>
</body>
</html>


