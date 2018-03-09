<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.payment.ppc.beans.*" %>
<%@ page import="com.ibm.commerce.payments.plugincontroller.Credit" %>
<%@ page import="com.ibm.commerce.payments.plugincontroller.PPCConstants" %>
<%@ page import="com.ibm.commerce.payments.plugin.ExtendedData" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="../common/NumberFormat.jsp" %>
<%@include file="ppcUtil.jsp" %>

<%
  	// obtain the resource bundle for display
	CommandContext cmdContextLocale = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   	Locale jLocale 		= cmdContextLocale.getLocale();
   	Integer langId		= cmdContextLocale.getLanguageId();
   	String storeId 	= cmdContextLocale.getStoreId().toString();
   	String currency		= cmdContextLocale.getCurrency();
   	Hashtable ppcLabels 	= (Hashtable)ResourceDirectory.lookup("edp.ppcLabels", jLocale);	
	
	
	JSPHelper jspHelper 	= new JSPHelper(request);

	String creditId 	= request.getParameter("creditId");
	
    PPCGetCreditDataBean creditDataBean	= new PPCGetCreditDataBean();	
	creditDataBean.setCreditId(creditId);
	
	com.ibm.commerce.beans.DataBeanManager.activate(creditDataBean, request);
	
	Credit credit = creditDataBean.getCredit();	
	String piId =credit.getPaymentInstruction().getId();
	int state = credit.getState();
	String currentStauts = converterStateOfCredit(state);
	
	String strexpectedAmount = getFormattedAmount(credit.getExpectedAmount(),currency,langId,storeId);
	String strcreditingAmount = getFormattedAmount(credit.getCreditingAmount(),currency,langId,storeId);
	String strcreditedAmount = getFormattedAmount(credit.getCreditedAmount(),currency,langId,storeId);
	String strreversingCreditedAmount = getFormattedAmount(credit.getReversingCreditedAmount(),currency,langId,storeId);
	

	String requestedAmount = "";
	String pendingType = "";
	if(credit.getCreditingAmount().compareTo(PPCConstants.ZERO_AMOUNT) > 0){
		pendingType = "credit";
		requestedAmount=strcreditingAmount;
	}else if(credit.getReversingCreditedAmount().compareTo(PPCConstants.ZERO_AMOUNT) > 0){
		pendingType = "reverseCredit";
		requestedAmount=strreversingCreditedAmount;
	}
%>

<html>

<head>

<title></title>

<script src="/wcs/javascript/tools/common/Util.js"></script>
<SCRIPT SRC="/wcs/javascript/tools/common/NumberFormat.js"></SCRIPT>
<script language="JavaScript">
	var creditback = "";
	creditback = top.getData("creditback");
	var currency = "<%=currency%>";
	var langId ="<%=langId%>";
	var pendingType = "<%= pendingType%>";
	var requestedAmount = currencyToNumber('<%=requestedAmount%>',currency,langId);

function loadPanelData () {
    if (parent.setContentFrameLoaded)
	{
	   parent.setContentFrameLoaded(true);
	}
	
	if(creditback == "creditback"){

		document.editCreditForm.processedAmount.value = top.getData("processedAmount");		
		
		document.editCreditForm.reasonCode.value = top.getData("reasonCode");
		document.editCreditForm.referenceNumber.value = top.getData("referenceNumber");
		document.editCreditForm.responseCode.value = top.getData("responseCode");
		if(top.getData("responseCode")=="1"){
			document.editCreditForm.transactionResult.failure.checked="checked";
			changeReasonCode('failure');
		}
		document.editCreditForm.comment.value = top.getData("comment");
	}
}
function validatePanelData(){
    var processAmt = currencyToNumber(editCreditForm.processedAmount.value,currency,langId);
	
	if(editCreditForm.responseCode.value=="0"){
	
		if(parent.isValidCurrency(editCreditForm.processedAmount.value, currency, langId)){
			if(processAmt<=0){
				parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("processAmountLogicError"))%>');
				return false;
			}
			
		}else{
			parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorProcessAmountFormat"))%>');
			return false;
		}
		
	}else{		
	    if(editCreditForm.reasonCode.value==''||editCreditForm.reasonCode.value==null){
			parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorReasonCodeIsZero"))%>');
			return false;
		}		
		if(editCreditForm.reasonCode.value=="0"){
			parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorReasonCodeIsZero"))%>');
			return false;
		}			
	}

    if(editCreditForm.referenceNumber.value == null || editCreditForm.referenceNumber.value == ''){
		parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorReferenceNumber"))%>');
		return false;
	}
	
	return true;
}
function validateNoteBookPanel () {

	var processAmt = currencyToNumber(editCreditForm.processedAmount.value,currency,langId);
	
	if(editCreditForm.responseCode.value=="0"){
	
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
		
		if(editCreditForm.reasonCode.value=="0"){
			parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorReasonCodeIsZero"))%>');
			return false;
		}
					
	}

	if(editCreditForm.referenceNumber.value != null && editCreditForm.referenceNumber.value != ''){
		if(!parent.isValidNumber(editCreditForm.referenceNumber.value)){
			parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorReferenceNumber"))%>');
			return false;
		}
	}else{
		parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorReferenceNumber"))%>');
		return false;
	}
	
	return true;	
}

function savePanelData(){
	
	top.saveData(editCreditForm.processedAmount.value, "processedAmount");	
	
	
	top.saveData(editCreditForm.reasonCode.value, "reasonCode");
	top.saveData(editCreditForm.referenceNumber.value, "referenceNumber");
	top.saveData(editCreditForm.responseCode.value, "responseCode");
	top.saveData(editCreditForm.comment.value, "comment");
	
	
	parent.put("processedAmount",currencyToNumber(document.editCreditForm.processedAmount.value,currency,langId));
	parent.put("reasonCode",document.editCreditForm.reasonCode.value);
	parent.put("referenceNumber",document.editCreditForm.referenceNumber.value);
	parent.put("responseCode",document.editCreditForm.responseCode.value);
	parent.put("comment",document.editCreditForm.comment.value);
	top.saveData("creditback", "creditback");
}

function changeReasonCode(transactionResult){

	if(transactionResult=="success"){
		//document.editCreditForm.reasonCode.value = "0";
		
		document.editCreditForm.responseCode.value = "0";
		document.editCreditForm.processedAmount.value= numberToCurrency(requestedAmount, currency, langId);

		document.all.reasonCodeSpan1.style.display='none';
		document.all.reasonCodeSpan2.style.display='none';		

		document.all.processedAmountSpan1.style.display='block';
		document.all.processedAmountSpan2.style.display='block';	

	}else if(transactionResult=="failure"){
		//document.editCreditForm.reasonCode.value = "1";
		
		document.editCreditForm.responseCode.value = "1";
				
		document.all.reasonCodeSpan1.style.display='block';
		document.all.reasonCodeSpan2.style.display='block';		
		
		document.all.processedAmountSpan1.style.display='none';
		document.all.processedAmountSpan2.style.display='none';		
	}
}

</script>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
</head>

<body onLoad="loadPanelData()" CLASS="content">
<!--JSP File name :ppcEditCredit.jsp -->
<form  name="editCreditForm">

<h1><%=UIUtil.toHTML((String)ppcLabels.get("editPendingCredit"))%></h1>
<table>
	<tbody>
		<TR>
			<TD colspan="2">
				<% out.println( UIUtil.toHTML((String)ppcLabels.get("update")) 
		              + " "+UIUtil.toHTML((String)ppcLabels.get(pendingType))
				 	  + " "+UIUtil.toHTML((String)ppcLabels.get("financialTransactionData"))
				);%>
			
			</TD></tr> 
		<TR>
			<TD nowrap width="226"><%=UIUtil.toHTML((String)ppcLabels.get("requestedAmount"))%>: </TD>
			<TD nowrap width="300"><%=requestedAmount%></TD>
		</tr>
	</TBODY>
</TABLE>		
<hr>		
<TABLE border="0">

	<TBODY>		
		<TR >
		<TD width="242"><%=(String)ppcLabels.get("transactionResult")+" "+(String)ppcLabels.get("required")%></TD>
		</TR>
		<TR >
		<TD width="340">
			<INPUT type="radio" name="transactionResult" id="success" onclick="changeReasonCode('success')" checked="checked"><label for="success"><%=UIUtil.toHTML(" "+(String)ppcLabels.get("success"))%></label>
			<INPUT type="radio" name="transactionResult" id="failure" onclick="changeReasonCode('failure')" ><label for="failure"><%=UIUtil.toHTML(" "+(String)ppcLabels.get("failure"))%></label>
			<INPUT type="hidden" name ="responseCode" value=""> 
		</TD>
		</TR>
		<TR >
		<TD width="264"></TD>
		</TR>
		
		<tr>				 
			<TD width="242"><span id="reasonCodeSpan1" style=""><label for="reasonCode"><%=(String)ppcLabels.get("reasonCode")+" "+(String)ppcLabels.get("required")%></label></span></TD>
		</TR>
		<TR >	
			<TD width="340"><span id="reasonCodeSpan2" style=""><INPUT name="reasonCode" id="reasonCode" type="text" maxlength="256"></span></TD>
		</TR>
		<TR >	
			<TD width="264"><span id="reasonCodeSpan3" style=""></span></TD>
		</tr>
		<TR>
			<TD width="242"><span id="processedAmountSpan1" style=""><label for="processedAmount"><%=(String)ppcLabels.get("processedAmount")+" "+(String)ppcLabels.get("required")%></label></span></TD>
		</TR>
		<TR >	
			<TD width="340"><span id="processedAmountSpan2" style=""><INPUT  name="processedAmount" id="processedAmount" type="text" maxlength="256" value="<%=requestedAmount%>"></span></TD>
		</TR>
		<TR >	
			<TD width="264"><span id="processedAmountSpan3" style=""></span></TD>
		</tr>		
		<TR>
			<TD width="242"><label for="referenceNumber"><%=(String)ppcLabels.get("referenceNumber")+" "+(String)ppcLabels.get("required")%></label></TD>
		</TR>
		<TR >	
			<TD width="340"><INPUT name="referenceNumber" id="referenceNumber" type="text" maxlength="256" value=""></TD>
		</TR>
		<TR>
			<TD width="242"><LABEL for='comment'><%=UIUtil.toHTML((String)ppcLabels.get("comment"))%></LABEL></TD>
		</TR>
		<TR >
			<TD><INPUT name="comment" id="comment" type="text" maxlength="256" value="" ></TD>			
		</tr>
		</TBODY>
	</TABLE>
<HR>
	<h1><%= UIUtil.toHTML((String)ppcLabels.get("creditSummary")) %></h1>
	<TABLE border="0">
	<TBODY>
		<TR>
			<TD width="224"><B><label for="creditId"><%=UIUtil.toHTML((String)ppcLabels.get("creditId"))%> :</label></B></TD>
			<TD  id="creditId"><%=credit.getId()%></TD>
		</TR>
		<TR>
			<TD width="224"><B><label for="state"><%=UIUtil.toHTML((String)ppcLabels.get("state"))%> :</label></B></TD>
			<TD id="state">				
				<%= (String)ppcLabels.get(converterStateOfCredit(state))%>
			</TD>

		</TR>
		<TR>
			<TD width="224"><B><label for="creditedAmount"><%=UIUtil.toHTML((String)ppcLabels.get("creditedAmount"))%> :</label></B></TD>
			<TD id="creditedAmount"><%=strcreditedAmount%></TD>
		</TR>
		<TR>
			<TD width="224"><B><label for="creditingAmount"><%=UIUtil.toHTML((String)ppcLabels.get("creditingAmount"))%> :</label></B></TD>
			<TD id="creditingAmount"><%=strcreditingAmount%></TD>
		</TR>
		<TR>
			<TD width="224"><B><label for="reversingCreditedAmount"><%=UIUtil.toHTML((String)ppcLabels.get("reversingCreditedAmount"))%> :</label></B></TD>
			<TD id="reversingCreditedAmount"><%=strreversingCreditedAmount%></TD>
		</TR>
		<TR>
			<TD width="224"><B><label for="expectedAmount"><%=UIUtil.toHTML((String)ppcLabels.get("expectedAmount"))%> :</label></B></TD>
			<TD id="approvedAmount"><%=strexpectedAmount%></TD>
				
		</TR>
	
		
	</TBODY>
</TABLE>
</form>
<SCRIPT language="JavaScript"> changeReasonCode('success');</SCRIPT>
<%
	HashMap protocolData = new HashMap();
	PPCGetPaymentInstructionDataBean ppcGetPIdata = new PPCGetPaymentInstructionDataBean();
	ppcGetPIdata.setPIId(piId);
	com.ibm.commerce.beans.DataBeanManager.activate(ppcGetPIdata, request);
	protocolData = ppcGetPIdata.getPaymentInstruction().getExtendedData();

PPCPIExtendedDataDataBean piExtDataBean = new PPCPIExtendedDataDataBean();
piExtDataBean.setPIId(piId);

com.ibm.commerce.beans.DataBeanManager.activate(piExtDataBean, request);

ExtendedData extData = piExtDataBean.getExtendedData();
 HashMap hashData = extData.getExtendedDataAsHashMap();
Set keySet = hashData.keySet();
Iterator iter = keySet.iterator();
%>
<HR>
<h1>
<%= UIUtil.toHTML((String)ppcLabels.get("PIExtendedData")) %>
</h1>
<TABLE border="0">
	<TBODY>
	<%while (iter.hasNext()) {
		String key = (String) iter.next();
		String showKey = (String)ppcLabels.get(key);	
		String value = (hashData.get(key)).toString();
		if(protocolData.get(key) != null){
			value = protocolData.get(key).toString();
		}	
	%>
		<TR>
			<TD><b><label for="<%=value%>"><%=showKey == null?key:showKey%> :</label></b></TD>
			<TD width="333" id="<%=value%>"><%=value%></TD>
					
		</TR>
	<%}%>
	</tbody>
</table>
</body>

</html>
