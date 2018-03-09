<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.payment.ppc.beans.*" %>
<%@ page import="com.ibm.commerce.payments.plugincontroller.Payment" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="../common/NumberFormat.jsp" %>
<%@ include file="ppcUtil.jsp" %>

<%
  	// obtain the resource bundle for display
	CommandContext cmdContextLocale = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   	Locale jLocale 		= cmdContextLocale.getLocale();
   	Integer langId		= cmdContextLocale.getLanguageId();
   	String storeId 	= cmdContextLocale.getStoreId().toString();
   	String currency		= cmdContextLocale.getCurrency();
   	Hashtable ppcLabels 	= (Hashtable)ResourceDirectory.lookup("edp.ppcLabels", jLocale);
    
    JSPHelper jspHelper = new JSPHelper(request);
	String paymentId 	= request.getParameter("paymentId");
	String piId         = request.getParameter("piId");
	String orderId      = request.getParameter("orderId");
	boolean isdependent = true;
	PaymentInstruction paymentInstruction = null;
	//payment properties
	String paymentID = "";
	String requestedAmount = "";
	String expectedAmount = "";
	String approvingAmount = "";
	String approvedAmount = "";
	String depositingAmount = "";
	String depositedAmount = "";
	String reversingApprovedAmount = "";
	String reversingDepositedAmount = "";
	String creditedAmount = "";
	String creditingAmount = "";
	
	//If dependant credit , payment id is not null
	if(paymentId != null && !paymentId.equals("")){
	
	    PPCGetPaymentDataBean paymentDataBean	= new PPCGetPaymentDataBean();	
	    paymentDataBean.setPaymentId(paymentId);
		//active data bean
		com.ibm.commerce.beans.DataBeanManager.activate(paymentDataBean, request);
		//get payment objexr
		Payment payment = paymentDataBean.getPayment();	
		paymentInstruction = payment.getPaymentInstruction();
		//set payment properties
		paymentID = payment.getId();
	    expectedAmount = getFormattedAmount(payment.getExpectedAmount(),currency,langId,storeId);
	    approvingAmount = getFormattedAmount(payment.getApprovingAmount(),currency,langId,storeId);
	    approvedAmount = getFormattedAmount(payment.getApprovedAmount(),currency,langId,storeId);
	    depositingAmount = getFormattedAmount(payment.getDepositingAmount(),currency,langId,storeId);
	    depositedAmount = getFormattedAmount(payment.getDepositedAmount(),currency,langId,storeId);
	    reversingApprovedAmount =  getFormattedAmount(payment.getReversingApprovedAmount(),currency,langId,storeId);
	    reversingDepositedAmount = getFormattedAmount(payment.getReversingDepositedAmount(),currency,langId,storeId);
	    creditedAmount = getFormattedAmount(payment.getCreditedAmount(),currency,langId,storeId);
	    creditingAmount = getFormattedAmount(payment.getCreditingAmount(),currency,langId,storeId);
	    requestedAmount = getFormattedAmount(payment.getDepositedAmount().subtract(payment.getCreditedAmount()).subtract(payment.getCreditingAmount()),currency,langId,storeId);
		
	}else{
	    isdependent = false;
	    PPCListPIsForOrderDataBean orderPIList = new PPCListPIsForOrderDataBean();
        PPCListPIsForReturnDataBean rmaPIList = new PPCListPIsForReturnDataBean();
        orderPIList.setOrderId(orderId);
        orderPIList.setStoreId(storeId);
        com.ibm.commerce.beans.DataBeanManager.activate(orderPIList, request);
	    for (int i = 0; i < orderPIList.getPaymentInstructionList().size(); i++) {
	       paymentInstruction = orderPIList.getPIListData(i);
	      if (paymentInstruction.getId().equals(piId)) {
	          break;
	        }
	    }
	}
	//set payment instruction properties
	DateFormat df = DateFormat.getDateTimeInstance();
    String timeCreated = df.format(new Date(paymentInstruction.getTimeCreated()));
    String timeUpdated = df.format(new Date(paymentInstruction.getTimeUpdated()));
    int state = paymentInstruction.getState();
    String accountNumber = paymentInstruction.getAccountNumber();
    String paymentSystemName = paymentInstruction.getPaymentSystemName();
    String stateLable = (String) ppcLabels.get(converterStateOfPI(state));
    String amount = getFormattedAmount(paymentInstruction.getAmount(), currency, langId, storeId);
    String piApprovedAmount = getFormattedAmount(paymentInstruction.getApprovedAmount(), currency, langId, storeId);
    String piApprovingAmount = getFormattedAmount(paymentInstruction.getApprovingAmount(), currency, langId, storeId);
    String piDepositedAmount = getFormattedAmount(paymentInstruction.getDepositedAmount(), currency, langId, storeId);
    String piDepositingAmount = getFormattedAmount(paymentInstruction.getDepositingAmount(), currency, langId, storeId);
    String piCreditedAmount = getFormattedAmount(paymentInstruction.getCreditedAmount(), currency, langId, storeId);
    String piCreditingAmount = getFormattedAmount(paymentInstruction.getCreditingAmount(), currency, langId, storeId);
    String piReversingApprovedAmount = getFormattedAmount(paymentInstruction.getReversingApprovedAmount(), currency, langId,storeId);
    String piReversingDepositedAmount = getFormattedAmount(paymentInstruction.getReversingDepositedAmount(), currency, langId,storeId);
    String piReversingCreditedAmount = getFormattedAmount(paymentInstruction.getReversingCreditedAmount(), currency, langId, storeId);
    String piCurrency = paymentInstruction.getCurrency();
	
%>

<html lang="en">

<head>
<TITLE>This is the LanguageISO639 rule</TITLE>
<script src="/wcs/javascript/tools/common/Util.js"></script>
<SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT> 
<SCRIPT SRC="/wcs/javascript/tools/common/NumberFormat.js"></SCRIPT>

<script language="JavaScript">
  	var backpayment = "";
	backpayment = top.getData("backpayment");	
	var currency = "<%=currency%>";	
	var langId ="<%=langId%>";
	
	var requestedAmount = currencyToNumber('<%=requestedAmount%>',currency,langId);
	var depositedAmount = currencyToNumber('<%=depositedAmount%>',currency,langId);
	
	function loadPanelData(){
	
	   if(backpayment == "backpayment"){
			
			document.createCreditForm.reasonCode.value = top.getData("reasonCode");
			document.createCreditForm.referenceNumber.value = top.getData("referenceNumber");
			document.createCreditForm.responseCode.value = top.getData("responseCode");
			if(top.getData("responseCode")=="1"){
				document.createCreditForm.transactionResult.failure.checked="checked";
				changeReasonCode('failure');
			}
	 	
	   }
	   
       if (parent.setContentFrameLoaded){
		   parent.setContentFrameLoaded(true);
	   }
    }
	

	function validatePanelData(){
	    
	  var creditAmount = currencyToNumber(createCreditForm.creditAmount.value,currency,langId);
	 
	  if(!parent.isValidNumber(creditAmount)){
	       parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorProcessAmountFormat"))%>');
		   return false;
	  }
	  if(depositedAmount<=0 || creditAmount > requestedAmount){
	       parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorProcessAmountFormat"))%>');
	       return false;
	  }
	  return true;
	}
	
	
	function validateNoteBookPanel() {

	var processAmt = currencyToNumber(createCreditForm.creditAmount.value,currency,langId);
	
	if(createCreditForm.responseCode.value=="0"){
	
		if(parent.isValidNumber(processAmt)){
				
			if(processAmt>requestedAmount){
				parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("processAmountBigerThanRequestAmount"))%>');
				return false;
			}
			if(processAmt<=0){
				parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("processAmountLogicError"))%>');
				return false;
			}
			
		}else{
			parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorProcessAmountFormat"))%>');
			return false;
		}
		
	}else{		
		
		if(createCreditForm.reasonCode.value=="0"){
			parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorReasonCodeIsZero"))%>');
			return false;
		}
					
	}

	if(createCreditForm.referenceNumber.value != null && createCreditForm.referenceNumber.value != ''){
		if(!parent.isValidNumber(createCreditForm.referenceNumber.value)){
			parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorReferenceNumber"))%>');
			return false;
		}
	}else{
		parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorReferenceNumber"))%>');
		return false;
	}
	
	
   }
	
	function savePanelData(){
	   top.saveData(createCreditForm.creditAmount.value, "creditAmount");	
	 parent.put("creditAmount",currencyToNumber(document.createCreditForm.creditAmount.value,currency,langId));
	}

</script>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">

<body onLoad="loadPanelData()" CLASS="content">
<!--JSP File name :ppcEditPayment.jsp -->
<IFRAME STYLE="display:none;position:absolute;width:198;height:230;z-index=100" ID="CalFrame" TITLE="calendarTitle" MARGINHEIGHT=0 MARGINWIDTH=0  FRAMEBORDER=0 SCROLLING=NO SRC="/webapp/wcs/tools/servlet/tools/common/Calendar.jsp" ></IFRAME>
<form  name="createCreditForm">

<h1><%=UIUtil.toHTML((String)ppcLabels.get("creditAgainstPayment"))%></h1>

<table>
	<tbody>
		<TR>
			<TD colspan="2"><B><label for="creditAmount"><%=UIUtil.toHTML((String)ppcLabels.get("creditNotification"))%></label></B></TD>
			
			<TD nowrap width="339"><INPUT  name="creditAmount" id="creditAmount" type="text" maxlength="256" value="<%=requestedAmount%>"></TD>
			</TR>
		
	</TBODY>
</TABLE>
<HR><h1><%=UIUtil.toHTML((String)ppcLabels.get("pisummary"))%></h1>
<TABLE style="padding-left: 25px;">
	<TBODY>

		<TR>
			<TD width="226"><B><label for="piId"><%=UIUtil.toHTML((String) ppcLabels.get("payInstId"))%>
			:</label></B></TD>
			<TD width="333" id="piId"><%=UIUtil.toHTML(piId)%></TD>
		</TR>
		<tr>
			<TD width="226"><B><label for="state"><%=UIUtil.toHTML((String) ppcLabels.get("state"))%>
			:</label></B></TD>
			<TD width="333" id="state"><%=stateLable%>
			</TD>
		</TR>
		<TR>
			<TD width="226"><B><label for="accountNumber"><%=UIUtil.toHTML((String) ppcLabels.get("accountNumber"))%>
			:</label></B></TD>
			<TD width="333" id="accountNumber"><%=accountNumber%></TD>
		</tr>
		<TR>
			<TD width="226"><B><label for="paymentSystemName"><%=UIUtil.toHTML((String) ppcLabels.get("paymentSystemName"))%>
			:</label></B></TD>
			<TD width="333" id="paymentSystemName"><%=paymentSystemName%></TD>
		</tr>
		<TR>
			<TD width="226"><B><label for="amount"><%=UIUtil.toHTML((String) ppcLabels.get("amount"))%>
			:</label></B></TD>
			<TD width="333" id="amount"><%=amount%></TD>
		</tr>
		<TR>
			<TD width="226"><B><label for="currency"><%=UIUtil.toHTML((String) ppcLabels.get("currency"))%>
			:</label></B></TD>
			<TD width="333" id="currency"><%=currency%></TD>
		</tr>
		<TR>
			<TD width="226"><B><label for="approvingAmount"><%=UIUtil.toHTML((String) ppcLabels.get("approvingAmount"))%>
			:</label></B></TD>
			<TD width="333" id="approvingAmount"><%=piApprovingAmount%></TD>
		</tr>
		<tr>
			<TD width="226"><B><label for="approvedAmount"><%=UIUtil.toHTML((String) ppcLabels.get("approvedAmount"))%>
			:</label></B></TD>
			<TD width="333" id="approvedAmount"><%=piApprovedAmount%></TD>

		</TR>
		<TR>
			<TD width="226"><B><label for="depositingAmount"><%=UIUtil.toHTML((String) ppcLabels.get("depositingAmount"))%>
			:</label></B></TD>
			<TD width="333" id="depositingAmount"><%=piDepositingAmount%></TD>
		</tr>
		<tr>
			<TD width="226"><B><label for="depositedAmount"><%=UIUtil.toHTML((String) ppcLabels.get("depositedAmount"))%>
			:</label></B></TD>
			<TD width="333" id="depositedAmount"><%=piDepositedAmount%></TD>
		</TR>
		<TR>
			<TD width="226"><B><label for="creditingAmount"><%=UIUtil.toHTML((String) ppcLabels.get("creditingAmount"))%>
			:</label></B></TD>
			<TD width="333" id="creditingAmount"><%=piDepositingAmount%></TD>
		</tr>
		<tr>
			<TD width="226"><B><label for="creditedAmount"><%=UIUtil.toHTML((String) ppcLabels.get("creditedAmount"))%>
			:</label></B></TD>
			<TD width="333" id="creditedAmount"><%=piCreditedAmount%></TD>
		</TR>
		<TR>
			<TD width="226"><B><label for="reversingApprovedAmount"><%=UIUtil.toHTML((String) ppcLabels.get("reversingApprovedAmount"))%>
			:</label></B></TD>
			<TD width="333" id="reversingApprovedAmount"><%=piReversingApprovedAmount%></TD>
		</tr>
		<tr>
			<TD width="226"><B><label for="reversingDepositedAmount"><%=UIUtil.toHTML((String) ppcLabels.get("reversingDepositedAmount"))%>
			:</label></B></TD>
			<TD width="333" id="reversingDepositedAmount"><%=piReversingDepositedAmount%></TD>
		</TR>
		<TR>
			<TD width="226"><B><label for="reversingCreditedAmount"><%=UIUtil.toHTML((String) ppcLabels.get("reversingCreditedAmount"))%>
			:</label></B></TD>
			<TD width="333" id="reversingCreditedAmount"><%=piReversingCreditedAmount%></TD>
		</tr>
		<tr>
			<TD width="226"><B><label for="timeCreated"><%=UIUtil.toHTML((String) ppcLabels.get("timeCreated"))%>
			:</label></B></TD>
			<TD width="333" id="timeCreated"><%=timeCreated%></TD>
		</TR>
		<TR>
			<TD width="226"><B><label for="timeUpdated"><%=UIUtil.toHTML((String) ppcLabels.get("timeUpdated"))%>
			:</label></B></TD>
			<TD width="333" id="timeUpdated"><%=timeUpdated%></TD>
		</tr>
	</tbody>
</table>



<% if(isdependent){ %>		
<HR><h1><%=UIUtil.toHTML((String)ppcLabels.get("paymentsummary"))%></h1>
<TABLE border="0">
	<TBODY>
		<TR>
			<TD width="226"><B><label for="paymentId"><%=UIUtil.toHTML((String)ppcLabels.get("paymentId"))%> :</label></B></TD>
			<TD width="333" id="paymentId"><%=paymentID%></TD>					
		</TR>
		<TR>
			<TD width="226"><B><label for="paymentExpectedAmount"><%=UIUtil.toHTML((String)ppcLabels.get("expectedAmount"))%> :</label></B></TD>			
			<TD width="333" id="paymentExpectedAmount"><%=expectedAmount%></TD>
		</tr>

		<TR>
			<TD width="226"><B><label for="paymentApprovingAmount"><%=UIUtil.toHTML((String)ppcLabels.get("approvingAmount"))%> :</label></B></TD>
			<TD width="333" id="paymentApprovingAmount"><%=approvingAmount%></TD>
		</tr>
		<tr>
			<TD width="226"><B><label for="paymentApprovedAmount"><%=UIUtil.toHTML((String)ppcLabels.get("approvedAmount"))%> :</label></B></TD>
			<TD width="333" id="paymentApprovedAmount"><%=approvedAmount%></TD>
			
		</TR>
		<TR>
			<TD width="226"><B><label for="paymentDepositingAmount"><%=UIUtil.toHTML((String)ppcLabels.get("depositingAmount"))%> :</label></B></TD>
			<TD width="333" id="paymentDepositingAmount"><%=depositingAmount%></TD>
		</tr>
		<tr>
			<TD width="226"><B><label for="paymentDepositedAmount"><%=UIUtil.toHTML((String)ppcLabels.get("depositedAmount"))%> :</label></B></TD>
			<TD width="333" id="paymentDepositedAmount"><%=depositedAmount%></TD>
		</TR>
		<TR>
			<TD width="226"><B><label for="paymentReversingApprovedAmount"><%=UIUtil.toHTML((String)ppcLabels.get("reversingApprovedAmount"))%> :</label></B></TD>
			<TD width="333" id="paymentReversingApprovedAmount"><%=reversingApprovedAmount%></TD>
		</tr>
		<tr>
			<TD width="226"><B><label for="paymentReversingDepositedAmount"><%=UIUtil.toHTML((String)ppcLabels.get("reversingDepositedAmount"))%> :</label></B></TD>
			<TD width="333" id="paymentReversingDepositedAmount"><%=reversingDepositedAmount%></TD>
		</TR>	
		<tr>
			<TD width="226"><B><label for="paymentCreditingAmount"><%=UIUtil.toHTML((String)ppcLabels.get("creditingAmount"))%> :</label></B></TD>
			<TD width="333" id="paymentCreditingAmount"><%=creditingAmount%></TD>
		</TR>
		<tr>
			<TD width="226"><B><label for="paymentCreditedAmount"><%=UIUtil.toHTML((String)ppcLabels.get("creditedAmount"))%> :</label></B></TD>
			<TD width="333" id="paymentCreditedAmount"><%=creditedAmount%></TD>
		</TR>	
		</tbody>
		</table>
 <%} %>		
</form>
</body>

</html>
