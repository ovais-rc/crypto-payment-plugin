
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%> 

<%@page import="java.util.*" %> 
<%@page import="com.ibm.commerce.tools.util.*" %> 
<%@page import="com.ibm.commerce.tools.common.*" %> 
<%@page import="com.ibm.commerce.tools.resourcebundle.*" %> 
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.contract.helper.ECContractConstants" %>
<%@page import="com.ibm.commerce.contract.util.ECContractErrorCode" %>
<%@page import="com.ibm.commerce.contract.util.ECContractCmdConstants" %>
<%@page import="com.ibm.commerce.contract.util.ContractCmdUtil" %>



<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>


<%
	CommandContext cc = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cc.getLocale();

	String contractImportTitle = "";
	String contractImportMessage = "";

	//Getting parameters from contractList
	String contractUsage = request.getParameter("contractUsage");	
	String goBack = request.getParameter("goBack");
	if (goBack == null || goBack.length() == 0)
		goBack = "false";

	Integer usage = new Integer(contractUsage);
	if(ContractCmdUtil.isBuyerContract(usage) ){ 
		contractImportTitle = (String) contractsRB.get ("contractImportTitle");
		contractImportMessage = (String) contractsRB.get ("contractImportMessage");
	}
	else if(ContractCmdUtil.isHostingContract(usage) ){ 
		contractImportTitle = (String) contractsRB.get ("contractImportResellerTitle");
		contractImportMessage = (String) contractsRB.get ("contractImportResellerMessage");
	}	
	else if(ContractCmdUtil.isReferralContract(usage) ){ 
		contractImportTitle = (String) contractsRB.get ("contractImportDistributorTitle");
		contractImportMessage = (String) contractsRB.get ("contractImportDistributorMessage");
	}
	else if(ContractCmdUtil.isDelegationGridContract(usage) ){ 
		contractImportTitle = (String) contractsRB.get ("contractImportDelegationGridTitle");
		contractImportMessage = (String) contractsRB.get ("delegationGridImportMessage");
	}	

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
 <title><%= contractImportTitle %></title>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css" />
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js">
</script>
<script type="text/javascript">


function loadPanelData() {
    if (parent.setContentFrameLoaded)
     {
      parent.setContentFrameLoaded(true);
     }
    
    //Display error message
    if (parent.get("contractExists", false))
    {
      parent.remove("contractExists");
      if ("<%=UIUtil.toJavaScript(contractUsage)%>" == "4")
      	alertDialog ("<%= UIUtil.toJavaScript((String) contractsRB.get("contractImportDistributorDuplicateError"))%>");
      else if ("<%=UIUtil.toJavaScript(contractUsage)%>" == "2")
      	alertDialog ("<%= UIUtil.toJavaScript((String) contractsRB.get("hostedStoreMarkedForDeleteError"))%>");
      else if ("<%=UIUtil.toJavaScript(contractUsage)%>" == "6")
      	alertDialog ("<%= UIUtil.toJavaScript((String) contractsRB.get("delegationGridMarkedForDeleteError"))%>");      	
      else
      	alertDialog ("<%= UIUtil.toJavaScript((String) contractsRB.get("contractMarkedForDeleteError"))%>");
    }
    else if (parent.get("ContractMarkForDelete", false))
    {
      parent.remove("ContractMarkForDelete");
      if ("<%=UIUtil.toJavaScript(contractUsage)%>" == "4")
      	alertDialog ("<%= UIUtil.toJavaScript((String) contractsRB.get("distributorMarkedForDeleteError"))%>");
      else if ("<%=UIUtil.toJavaScript(contractUsage)%>" == "2")
      	alertDialog ("<%= UIUtil.toJavaScript((String) contractsRB.get("contractImportResellerDuplicateError"))%>");
      else if ("<%=UIUtil.toJavaScript(contractUsage)%>" == "6")
      	alertDialog ("<%= UIUtil.toJavaScript((String) contractsRB.get("contractImportDelegationGridDuplicateError"))%>");      	
      else
      	alertDialog ("<%= UIUtil.toJavaScript((String) contractsRB.get("contractImportDuplicateError"))%>");
    }
    else if (parent.get("contractGenericError", false))
    {
      parent.remove("contractGenericError");
      alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractImportGenericError"))%>");
    }
    else if (parent.get("WrongContractOwnerMemberInfo", false))
    {
      parent.remove("WrongContractOwnerMemberInfo");
      alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractImportWrongContractOwnerMemberInfoError"))%>");
    }
    else if (parent.get("LocaleError", false))
    {
      parent.remove("LocaleError");
      alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractImportLocaleError"))%>");
    }
    else if (parent.get("RetrieveOrgId", false))
    {
       parent.remove("RetrieveOrgId");
      if (parent.get ("ErrorMessage")) {
      	alertDialog(parent.changeSpecialText("<%= UIUtil.toJavaScript((String) contractsRB.get("contractImportWrongParticipantInfoError"))%>", parent.get ("ErrorMessage")));
      	parent.remove("ErrorMessage");
      }
      else {
        alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractImportWrongParticipantInfoErrorNoMsg"))%>");
      }
    }    
    else if (parent.get("WrongMemberParticipantInfo", false))
    {
      parent.remove("WrongMemberParticipantInfo");
      if (parent.get ("ErrorMessage")) {
      	alertDialog(parent.changeSpecialText("<%= UIUtil.toJavaScript((String) contractsRB.get("contractImportWrongParticipantInfoError"))%>", parent.get ("ErrorMessage")));
      	parent.remove("ErrorMessage");
      }
      else {
        alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractImportWrongParticipantInfoErrorNoMsg"))%>");
      }
    }
    else if (parent.get("WrongContractState", false))
    {
      parent.remove("WrongContractState");
      alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractImportInvalidStateError"))%>");
    }
    else if (parent.get("DuplicateKeyInTC", false))    
    {
      parent.remove("DuplicateKeyInTC");
      alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractImportGenericError"))%>");    
    }
    else if (parent.get("DuplicateKeyInTPC", false))    
    {
      parent.remove("DuplicateKeyInTPC");
      alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractImportPriceTCCustomPriceListDuplicateError"))%>");    
    }
    else if (parent.get("<%=ECContractErrorCode.EC_ERR_MISSING_PRICE_TC%>", false))    
    {
      parent.remove("<%=ECContractErrorCode.EC_ERR_MISSING_PRICE_TC%>");
      alertDialog("<%=UIUtil.toJavaScript((String) contractsRB.get("contractMissingPriceTC"))%>");    
    }
    else if (parent.get("<%=ECContractErrorCode.EC_ERR_MISSING_BUYER_PARTICIPANT%>", false))    
    {
      parent.remove("<%=ECContractErrorCode.EC_ERR_MISSING_BUYER_PARTICIPANT%>");
      alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractMissingBuyerParticipant"))%>");    
    }
    else if (parent.get("<%=ECContractErrorCode.EC_ERR_CONTRACT_EXPIRED%>", false))    
    {
      parent.remove("<%=ECContractErrorCode.EC_ERR_CONTRACT_EXPIRED%>");
      alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractExpiredInvalidEndDate"))%>");    
    }
    else if (parent.get("<%=ECContractErrorCode.EC_ERR_SHIPPING_CHARGE_TC%>", false))    
    {
      parent.remove("<%=ECContractErrorCode.EC_ERR_SHIPPING_CHARGE_TC%>");
      alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractMissingShippingChargeType"))%>");    
    }
    else if (parent.get("<%=ECContractErrorCode.EC_ERR_RETURN_TC_RETURN_CHARGER_AND_REFUND_METHOD_DO_NOT_MATCH%>", false))    
    {
      parent.remove("<%=ECContractErrorCode.EC_ERR_RETURN_TC_RETURN_CHARGER_AND_REFUND_METHOD_DO_NOT_MATCH%>");
      alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractMissingReturns"))%>");    
    }
    else if (parent.get("<%=ECContractErrorCode.EC_ERR_USER_AUTHORITY_DEPLOY_IN_AUTO_APPROVAL%>", false))    
    {
      parent.remove("<%=ECContractErrorCode.EC_ERR_USER_AUTHORITY_DEPLOY_IN_AUTO_APPROVAL%>");
      alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractGenericWrongAuthorityError"))%>");    
    }
    else if (parent.get("<%=ECContractErrorCode.EC_ERR_HOST_PARTICIPANT%>", false))    
    {
      parent.remove("<%=ECContractErrorCode.EC_ERR_HOST_PARTICIPANT%>");
      alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractImportMissingHostParticipant"))%>");    
    }
    else if (parent.get("<%=ECContractErrorCode.EC_ERR_PROVIDER_PARTICIPANT%>", false))    
    {
      parent.remove("<%=ECContractErrorCode.EC_ERR_PROVIDER_PARTICIPANT%>");
      alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractImportMissingChannelParticipant"))%>");    
    }
    else if (parent.get("<%=ECContractErrorCode.EC_ERR_RECIPIENT_PARTICIPANT%>", false))    
        {
          parent.remove("<%=ECContractErrorCode.EC_ERR_RECIPIENT_PARTICIPANT%>");
          alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractImportMissingResellerParticipant"))%>");    
    }
    else if (parent.get("<%=ECContractErrorCode.EC_ERR_SUPPLIER_PARTICIPANT%>", false))    
        {
          parent.remove("<%=ECContractErrorCode.EC_ERR_SUPPLIER_PARTICIPANT%>");
          alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractImportMissingDistributorParticipant"))%>");    
    }
    else if (parent.get("<%=ECContractErrorCode.EC_ERR_MISSING_SELLER_PARTICIPANT%>", false))    
        {
          parent.remove("<%=ECContractErrorCode.EC_ERR_MISSING_SELLER_PARTICIPANT%>");
          alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractImportMissingSellerParticipant"))%>");    
    }
    else if (parent.get("<%=ECContractErrorCode.EC_ERR_ORDER_APPROVAL_TC%>", false))    
        {
          parent.remove("<%=ECContractErrorCode.EC_ERR_ORDER_APPROVAL_TC%>");
          alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractOnlyOneOrderApprovalTC"))%>");    
    }
    else if (parent.get("<%=ECContractErrorCode.EC_ERR_CANNOT_HAVE_MORE_THAN_ONE_MC_OPTIONAL_ADJUSTMENT_TC%>", false))    
        {
          parent.remove("<%=ECContractErrorCode.EC_ERR_CANNOT_HAVE_MORE_THAN_ONE_MC_OPTIONAL_ADJUSTMENT_TC%>");
          alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractOnlyOneMasterCatalogTC"))%>");    
    }
    else if (parent.get("<%=ECContractErrorCode.EC_ERR_RETURN_TC_RETURN_CHARGE%>", false))    
        {
          parent.remove("<%=ECContractErrorCode.EC_ERR_RETURN_TC_RETURN_CHARGE%>");
          alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractOnlyOneReturnChargeTC"))%>");    
    }
    else if (parent.get("<%=ECContractErrorCode.EC_ERR_NO_CANCEL_WITH_ACTIVE_CONTRACT_REFERRAL%>", false))    
        {
          parent.remove("<%=ECContractErrorCode.EC_ERR_NO_CANCEL_WITH_ACTIVE_CONTRACT_REFERRAL%>");
          alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractCannotCancelWithReference"))%>");    
    }
    else if (parent.get("<%=ECContractErrorCode.EC_ERR_NO_SUSPEND_WITH_ACTIVE_CONTRACT_REFERRAL%>", false))    
        {
          parent.remove("<%=ECContractErrorCode.EC_ERR_NO_SUSPEND_WITH_ACTIVE_CONTRACT_REFERRAL%>");
          alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractCannotSuspendWithReference"))%>");    
    }
    else if (parent.get("<%=ECContractErrorCode.EC_ERR_NO_SUBMIT_WITH_NON_ACTIVE_CONTRACT_REFERRAL%>", false))    
        {
          parent.remove("<%=ECContractErrorCode.EC_ERR_NO_SUBMIT_WITH_NON_ACTIVE_CONTRACT_REFERRAL%>");
          alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractMustReferToActiveContract"))%>");    
    }

    //Display Successful message
    if (parent.get("importDone", false))
    {
      parent.remove("importDone");
      if ("<%=UIUtil.toJavaScript(contractUsage)%>" == "4") {
      	alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractImportDistributorConfirmMessage"))%>");
	if ("<%= UIUtil.toJavaScript(goBack) %>" == "true") {
		top.goBack();
	} 
	else {
		top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("distributorListTitle"))%>",
			"/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=contract.DistributorList&cmd=ContractListView&contractUsage=2",
			false);
	}
      }
      else if ("<%=UIUtil.toJavaScript(contractUsage)%>" == "2") {
      	alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractImportResellerConfirmMessage"))%>");
	if ("<%= UIUtil.toJavaScript(goBack) %>" == "true") {
		top.goBack();
	}
	else {
		top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("resellerListTitle"))%>",
			"/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=contract.ResellerList&cmd=ContractListView&contractUsage=2",
			false);
	}
      }
      else if ("<%=UIUtil.toJavaScript(contractUsage)%>" == "6") {
      	alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("delegationGridImportConfirmMessage"))%>");
	if ("<%= UIUtil.toJavaScript(goBack) %>" == "true") {
		top.goBack();
	}
	else {
		top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("delegationGridListTitle"))%>",
			"/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=contract.DelegationGridList&cmd=ContractListView",
			false);
	}
      }	      
      else {
      	alertDialog("<%= UIUtil.toJavaScript((String) contractsRB.get("contractImportConfirmMessage"))%>");
	if ("<%= UIUtil.toJavaScript(goBack) %>" == "true") {
		top.goBack();
	}
	else {
		top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("contractListTitle"))%>",
			"/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=contract.ContractList&cmd=ContractListView",
			false);
	}
      }	
    }
    else {
	document.uploadForm.filename.focus();
    }
}


function validatePanelData() {

	//Use a check function to validate the xml extension.
	//We can put this as a check parameter' in TFW before calling Upload command.

	var ext = document.uploadForm.filename.value;
	ext = ext.substring(ext.length-3,ext.length);
	ext = ext.toLowerCase();
	if(ext != 'xml') {
		alertDialog ('<%= UIUtil.toJavaScript(contractsRB.get("contractImportInvalidFileMsg")) %>');
		return false;
	}
	else {
		return true; 
	}    
}



</script>
</head>

<body onload="loadPanelData()" class="content">

<h1><%= contractImportTitle %> </h1><br />
<p> <%= contractImportMessage %> </p> <br />
<br />

<label for="ContractImportPanel_FormInput_filename_In_uploadForm_1"><%= contractsRB.get("contractImportPrompt") %></label> <br /><br />



<form enctype="multipart/form-data" method="post" name="uploadForm" action="ContractUpload" target="NAVIGATION" id="uploadForm">
<br /><table cellpadding="0" cellspacing="0" id="ContractImportPanel_Table_1">

<input type="hidden" name="XMLFile" value="contract.ContractImportPanel" id="ContractImportPanel_FormInput_XMLFile_In_uploadForm_1" />
<input type="hidden" name="refcmd" value="ContractUpload" id="ContractImportPanel_FormInput_refcmd_In_uploadForm_1" />
<input type="hidden" name="targetStoreId" value="<%=cc.getStoreId()%>" id="ContractImportPanel_FormInput_targetStoreId_In_uploadForm_1" />

<tr>
	<td id="ContractImportPanel_TableCell_1">
		<input name="filename" type="file" size="50" id="ContractImportPanel_FormInput_filename_In_uploadForm_1" />
	</td>

	<td id="ContractImportPanel_TableCell_2">
		<input type="reset" name="Clear" value="<%=UIUtil.toJavaScript(contractsRB.get("clear"))%>" />
	</td>

</tr>

</table>
</form>

</body>


</html>
