<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2015 All Rights Reserved.

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
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.payment.ppc.beans.*" %>
<%@ page import="com.ibm.commerce.payments.plugincontroller.Payment" %>
<%@ page import="com.ibm.commerce.payments.plugincontroller.PPCConstants" %>
<%@ page import="com.ibm.commerce.payments.plugin.ExtendedData" %>
<%@ page import="com.ibm.commerce.edp.api.EDPPaymentInstruction"%>
<%@ page import="com.ibm.commerce.edp.beans.EDPPaymentInstructionsDataBean" %>
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
	
	
	//JSPHelper jspHelper 	= new JSPHelper(request);

	String paymentId 	= request.getParameter("paymentId");	
    PPCGetPaymentDataBean paymentDataBean	= new PPCGetPaymentDataBean();	
	paymentDataBean.setPaymentId(paymentId);
	
	com.ibm.commerce.beans.DataBeanManager.activate(paymentDataBean, request);
	
	Payment payment = paymentDataBean.getPayment();	
	String piId =payment.getPaymentInstruction().getId();
	String orderId = payment.getPaymentInstruction().getOrderId();
	
	int state = payment.getState();
	int year,month,day;
	if(payment.getTimeExpired()!=0){
		Date expiredTime = new Date(payment.getTimeExpired());
	 
		Calendar cal = Calendar.getInstance(jLocale);
			
		cal.setTime(expiredTime);		
		year = cal.get(Calendar.YEAR);
		month = cal.get(Calendar.MONTH);
		day = cal.get(Calendar.DAY_OF_MONTH);
	}else{
		year = 0;
		month = 0;
		day = 0;
	}
	
	DateFormat df = DateFormat.getDateTimeInstance();
	String timeExpired = "";
	
	if(payment.getTimeExpired()==0){
		timeExpired="-";
	}else{
	    timeExpired = df.format(new Date(payment.getTimeExpired()));
	}
	String currentStauts = converterStateOfPayment(state);
	
	int currentAvsCode = payment.getAvsCommonCode();
	
	String expectedAmount = getFormattedAmount(payment.getExpectedAmount(),currency,langId,storeId);
	String approvingAmount = getFormattedAmount(payment.getApprovingAmount(),currency,langId,storeId);
	String approvedAmount = getFormattedAmount(payment.getApprovedAmount(),currency,langId,storeId);
	String depositingAmount = getFormattedAmount(payment.getDepositingAmount(),currency,langId,storeId);
	String depositedAmount = getFormattedAmount(payment.getDepositedAmount(),currency,langId,storeId);
	String reversingApprovedAmount =  getFormattedAmount(payment.getReversingApprovedAmount(),currency,langId,storeId);
	String reversingDepositedAmount = getFormattedAmount(payment.getReversingDepositedAmount(),currency,langId,storeId);
	String requestedAmount = "";
	String pendingType = "";
	if(payment.getApprovingAmount().compareTo(PPCConstants.ZERO_AMOUNT) > 0 
		&& payment.getDepositingAmount().compareTo(PPCConstants.ZERO_AMOUNT)>0){
		pendingType = "approveAndDeposit";
		requestedAmount=depositingAmount;
	}else if(payment.getApprovingAmount().compareTo(PPCConstants.ZERO_AMOUNT) > 0){
		pendingType = "approve";
		requestedAmount=approvingAmount;
	}else if(payment.getDepositingAmount().compareTo(PPCConstants.ZERO_AMOUNT) > 0){
		pendingType = "deposit";
		requestedAmount=depositingAmount;
	}else if(payment.getReversingApprovedAmount().compareTo(PPCConstants.ZERO_AMOUNT) > 0){
		pendingType = "reverseApproved";
		requestedAmount=reversingApprovedAmount;
	}else if(payment.getReversingDepositedAmount().compareTo(PPCConstants.ZERO_AMOUNT) > 0){
		pendingType = "reverseDeposited";
		requestedAmount=reversingDepositedAmount;
	}
	
%>

<html>

<head>

<title><%=UIUtil.toHTML((String)ppcLabels.get("title"))%></title>
<script src="/wcs/javascript/tools/common/Util.js"></script>
<SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT> 
<SCRIPT SRC="/wcs/javascript/tools/common/NumberFormat.js"></SCRIPT>

<script language="JavaScript">
  	var backpayment = "";
	backpayment = top.getData("backpayment");	
	var currency = "<%=currency%>";	
	var langId ="<%=langId%>";
	var pendingType = "<%= pendingType%>";
	
	<% if(pendingType.equals("approve") || pendingType.equals("approveAndDeposit")){%>
		var approve=true;
	
	<%}else{%>
		var approve=false;		
	<%}%>
	
	var requestedAmount = currencyToNumber('<%=requestedAmount%>',currency,langId);
function loadPanelData () {

    if(approve){
	    init();
	}
   
	
	if(backpayment == "backpayment"){
	
		document.editPaymentForm.processedAmount.value = top.getData("processedAmount");	
		
		document.editPaymentForm.reasonCode.value = top.getData("reasonCode");
		document.editPaymentForm.referenceNumber.value = top.getData("referenceNumber");
		document.editPaymentForm.responseCode.value = top.getData("responseCode");
		if(top.getData("responseCode")=="1"){
			document.editPaymentForm.transactionResult.failure.checked="checked";
			changeReasonCode('failure');
		}
		document.editPaymentForm.comment.value = top.getData("comment");
		if(approve){
		document.editPaymentForm.avsCommonCode.value = top.getData("avsCommonCode");
		document.editPaymentForm.YEAR1.value = top.getData("expiredYear");
		document.editPaymentForm.MONTH1.value = top.getData("expiredMonth");
		document.editPaymentForm.DAY1.value = top.getData("expiredDay");
		}
	}
	
	if (parent.setContentFrameLoaded)
	{
	   parent.setContentFrameLoaded(true);
	}
}
function validatePanelData(){
    
    var processAmt = currencyToNumber(editPaymentForm.processedAmount.value,currency,langId);
	
	if(editPaymentForm.responseCode.value=="0"){
	
		if(parent.isValidCurrency(editPaymentForm.processedAmount.value, currency, langId)){
			if(processAmt<=0){
				parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("processAmountLogicError"))%>');
				return false;
			}
			
		}else{
			parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorProcessAmountFormat"))%>');
			return false;
		}
		
	}else{
	    if(editPaymentForm.reasonCode.value==''||editPaymentForm.reasonCode.value==null){
			parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorReasonCodeIsZero"))%>');
			return false;
		}		
		if(editPaymentForm.reasonCode.value=="0"){
			parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorReasonCodeIsZero"))%>');
			return false;
		}			
	}

    if(editPaymentForm.referenceNumber.value == null || editPaymentForm.referenceNumber.value == ''){
		parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorReferenceNumber"))%>');
		return false;
	}
	
	if(approve){
		var year = trim(editPaymentForm.YEAR1.value);
		var month = trim(editPaymentForm.MONTH1.value);
		var day = trim(editPaymentForm.DAY1.value);
		if(year=='' || month=='' || day ==''){
			parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorExpiredDate"))%>');
			return false;
		}
		if( year!=0 || month!=0 || day != 0){
			if(!(validDate(year,month,day))){
				parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorExpiredDate"))%>');
				return false;
			}
			else if(!validateStartEndDateTime(getCurrentYear(),getCurrentMonth(),getCurrentDay(),year,month,day,null,null)){
			    parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorExpiredDateBeforeToday"))%>');
			    return false;
			}
		}
	}
	return true;
}

function validateNoteBookPanel() {

	var processAmt = currencyToNumber(editPaymentForm.processedAmount.value,currency,langId);
	
	if(editPaymentForm.responseCode.value=="0"){
	
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
		
		if(editPaymentForm.reasonCode.value=="0"){
			parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorReasonCodeIsZero"))%>');
			return false;
		}
					
	}

	if(editPaymentForm.referenceNumber.value == null || editPaymentForm.referenceNumber.value == ''){
		parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorReferenceNumber"))%>');
		return false;
	}
	
	if(approve){
	
		
		var year = trim(editPaymentForm.YEAR1.value);
		var month = trim(editPaymentForm.MONTH1.value);
		var day = trim(editPaymentForm.DAY1.value);
		
		if(year=='' || month=='' || day ==''){
		
			parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorExpiredDate"))%>');
			return false;
		}
		if( year!=0 || month!=0 || day != 0){
			
			if(!(validateIntRange(year,1900,9999) && validateIntRange(month,1,12) && validateIntRange(day,1,31))){
				parent.alertDialog('<%=UIUtil.toJavaScript((String)ppcLabels.get("errorExpiredDate"))%>');
				return false;
			}
		}
		
		
	}
	return true;
}
function validateIntRange(intStr, min, max) {
	
    if (intStr == null || min == null || max == null){
    	
        return false;
    }
    if (isNaN(intStr)){
        
        return false;
    }
      
    var iValue = intStr; 
    
    if (!(iValue >= min && iValue <= max)){
     	
    	
        return false;
    }
    return true;
}

function trim(inString) {
   var retString = inString;
   var ch = retString.substring(0,1);
   while(ch == " "){
      retString=retString.substring(1,retString.length);
      ch=retString.substring(0,1);
   }
   ch=retString.substring(retString.length-1,retString.length)
   while(ch == " "){
      retString=retString.substring(0,retString.length-1);
      ch=retString.substring(retString.length-1,retString.length);
   }
   return retString;
}
function savePanelData(){
	
	top.saveData(editPaymentForm.processedAmount.value, "processedAmount");		
	
	top.saveData(editPaymentForm.reasonCode.value, "reasonCode");
	top.saveData(editPaymentForm.referenceNumber.value, "referenceNumber");
	top.saveData(editPaymentForm.responseCode.value, "responseCode");
	top.saveData(editPaymentForm.comment.value, "comment");
	
	if(approve){
	
	top.saveData(editPaymentForm.avsCommonCode.value, "avsCommonCode");
	top.saveData(editPaymentForm.YEAR1.value, "expiredYear");
	top.saveData(editPaymentForm.MONTH1.value, "expiredMonth");	
	top.saveData(editPaymentForm.DAY1.value, "expiredDay");
	
	}
	
	parent.put("processedAmount",currencyToNumber(document.editPaymentForm.processedAmount.value,currency,langId));
	
	parent.put("reasonCode",document.editPaymentForm.reasonCode.value);
	parent.put("referenceNumber",document.editPaymentForm.referenceNumber.value);
	parent.put("responseCode",document.editPaymentForm.responseCode.value);
	parent.put("comment",document.editPaymentForm.comment.value);
	
	if(approve){
	parent.put("avsCommonCode",document.editPaymentForm.avsCommonCode.value);
	parent.put("expiredYear",document.editPaymentForm.YEAR1.value);
	parent.put("expiredMonth",document.editPaymentForm.MONTH1.value);
	parent.put("expiredDay",document.editPaymentForm.DAY1.value);
	
	}
	
	parent.put("pendingType",pendingType);
	top.saveData("backpayment", "backpayment");
}

function isValidIntegerInput(integerInputValue) {
  return parent.isValidInteger(integerInputValue, langId);
}

function isValidCurrencyInput(currencyInputValue) {
  return parent.isValidCurrency(currencyInputValue, currency, langId);
}
function init() {
    document.editPaymentForm.YEAR1.value = <%= year%>;
    document.editPaymentForm.MONTH1.value = <%= month%>;
    document.editPaymentForm.DAY1.value = <%= day%>;
    
}
function setupDate() {
    window.yearField = document.editPaymentForm.YEAR1;
    window.monthField = document.editPaymentForm.MONTH1;
    window.dayField = document.editPaymentForm.DAY1;
}  

function getFormatAmount(amount){
	return parent.numberToCurrency(amount, currency, langId);
}

function changeReasonCode(transactionResult){
	
	if(transactionResult=="success"){
		//document.editPaymentForm.reasonCode.value = "0";
		
		document.editPaymentForm.responseCode.value = "0";
		document.editPaymentForm.processedAmount.value= numberToCurrency(requestedAmount, currency, langId);
		
		document.all.reasonCodeSpan1.style.display='none';
		document.all.reasonCodeSpan2.style.display='none';
		
		document.all.processedAmountSpan1.style.display='block';
		document.all.processedAmountSpan2.style.display='block';

	}else if(transactionResult=="failure"){
		//document.editPaymentForm.reasonCode.value = "1";
		
		document.editPaymentForm.responseCode.value = "1";
				
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
<!--JSP File name :ppcEditPayment.jsp -->
<IFRAME STYLE="display:none;position:absolute;width:198;height:230;z-index=100" ID="CalFrame" TITLE="calendarTitle" MARGINHEIGHT=0 MARGINWIDTH=0  FRAMEBORDER=0 SCROLLING=NO SRC="/webapp/wcs/tools/servlet/tools/common/Calendar.jsp" ></IFRAME>
<form  name="editPaymentForm">

<h1><%=UIUtil.toHTML((String)ppcLabels.get("editPendingPayment"))%></h1>
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
		
			<TD nowrap width="226">
				
					<label for="transactionResult"><%=(String)ppcLabels.get("transactionResult")+" "+(String)ppcLabels.get("required")%></label><br/>
					<INPUT type="radio" name="transactionResult" id="success" onclick="changeReasonCode('success')" checked="checked"><label for="success"><%=UIUtil.toHTML(" "+(String)ppcLabels.get("success"))%></label>
					<INPUT type="radio" name="transactionResult" id="failure" onclick="changeReasonCode('failure')" ><label for="failure"><%=UIUtil.toHTML(" "+(String)ppcLabels.get("failure"))%></label>
					<INPUT type="hidden" name ="responseCode" value="">				
				
			</TD>
		</TR>
		<TR>							
			<TD nowrap width="226"><span id="reasonCodeSpan1" style=""><label for="reasonCode"><%=(String)ppcLabels.get("reasonCode")+" "+(String)ppcLabels.get("required")%></label></span></TD>
		</TR>
		<TR>	
			<TD nowrap width="339"><span id="reasonCodeSpan2" style=""><INPUT name="reasonCode" id="reasonCode" type="text" maxlength="256" value=""></span></TD>
		</TR>	
		<TR>
			<TD nowrap width="226"><span id="processedAmountSpan1" style=""><label for="processedAmount"><%=(String)ppcLabels.get("processedAmount")+" "+(String)ppcLabels.get("required")%></label></span></TD>
		</TR>
		<TR>	
			<TD nowrap width="339"><span id="processedAmountSpan2" style=""><INPUT  name="processedAmount" id="processedAmount" type="text" maxlength="256" value="<%=requestedAmount%>"></span></TD>
		</TR>	
		<TR>
			<TD nowrap width="226"><label for="referenceNumber"><%=(String)ppcLabels.get("referenceNumber")+" "+(String)ppcLabels.get("required")%></label></TD>
		</TR>
		<TR>	
			<TD nowrap width="339"><INPUT name="referenceNumber" id="referenceNumber" type="text" maxlength="256" value=""></TD>
		</TR>
		<%
		if(pendingType.equals("approve") || pendingType.equals("approveAndDeposit")){
		
		 %>
		<tr>
			<TD nowrap width="226"><LABEL for="avsCommonCode"><%=UIUtil.toHTML((String)ppcLabels.get("avsCommonCode"))%></LABEL></TD>
		</TR>
		<TR>	
			<TD nowrap width="339"><SELECT name="avsCommonCode" id="avsCommonCode">
			
				<OPTION value="<%= Payment.AVS_COMPLETE_MATCH %>"
					<%if(currentAvsCode==Payment.AVS_COMPLETE_MATCH){%> selected <%}%>><%=Payment.AVS_COMPLETE_MATCH + " " + (String)ppcLabels.get(converterAVSCode(Payment.AVS_COMPLETE_MATCH)) %></OPTION>
				<OPTION value="<%= Payment.AVS_STREET_ADDRES_MATCH %>"
					<%if(currentAvsCode==Payment.AVS_STREET_ADDRES_MATCH){%> selected <%}%>><%=Payment.AVS_STREET_ADDRES_MATCH + " " + (String)ppcLabels.get(converterAVSCode(Payment.AVS_STREET_ADDRES_MATCH))%></OPTION>
				<OPTION value="<%= Payment.AVS_POSTALCODE_MATCH %>"
					<%if(currentAvsCode==Payment.AVS_POSTALCODE_MATCH){%> selected <%}%>><%=Payment.AVS_POSTALCODE_MATCH + " " + (String)ppcLabels.get(converterAVSCode(Payment.AVS_POSTALCODE_MATCH))%></OPTION>
				<OPTION value="<%= Payment.AVS_NO_MATCH %>"
					<%if(currentAvsCode==Payment.AVS_NO_MATCH){%> selected <%}%>><%=Payment.AVS_NO_MATCH + " " + (String)ppcLabels.get(converterAVSCode(Payment.AVS_NO_MATCH))%></OPTION>
				<OPTION value="<%= Payment.AVS_OTHER_RESPONSE %>"
					<%if(currentAvsCode==Payment.AVS_OTHER_RESPONSE){%> selected <%}%>><%=Payment.AVS_OTHER_RESPONSE + " " + (String)ppcLabels.get(converterAVSCode(Payment.AVS_OTHER_RESPONSE))%></OPTION>

			</SELECT>
			</TD>
		</TR>
			
		<TR>	
			<TD nowrap width="339">	
			<TABLE border="0">
				<TBODY>
				<TR>
					<TD nowrap colspan="4"><%=UIUtil.toHTML((String)ppcLabels.get("expiredDate"))%></TD>
				</TR>	
					<TR>
						<TD><LABEL for='year1'><%=(String)ppcLabels.get("year")%></LABEL></TD>
						<TD> <LABEL for='month1'><%=(String)ppcLabels.get("month")%></LABEL>	</TD>
						<TD><LABEL for='day1'><%=(String)ppcLabels.get("day")%></LABEL>    </TD>
						<TD></TD>
					</TR>
					<TR>
						<TD><INPUT TYPE=TEXT VALUE="" NAME=YEAR1 SIZE=4 ID='year1'></TD>
						<TD><INPUT TYPE=TEXT VALUE="" NAME=MONTH1 SIZE=2 ID='month1'></TD>
						<TD><INPUT TYPE=TEXT VALUE="" NAME=DAY1 SIZE=2 ID='day1'>  </TD>
						<TD><A HREF="javascript:setupDate();showCalendar(document.editPaymentForm.calImg1)">
						<IMG SRC="/wcs/images/tools/calendar/calendar.gif" BORDER=0 id="calImg1" alt="<%=UIUtil.toHTML((String)ppcLabels.get("expiredDate"))%>"/></A></TD>
					</TR>
				</TBODY>
			</TABLE>
			</TD>
		</TR>		
		<% 
			}
		%>
		
		<TR>
			<TD nowrap width="226"><LABEL for='comment'><%=UIUtil.toHTML((String)ppcLabels.get("comment"))%></LABEL></TD>
		</TR>
		<TR>	
			<TD nowrap><INPUT name="comment" id="comment" type="text" maxlength="256" value="" ></TD>
			
		</tr> 	
	</TBODY>
</TABLE>
<HR>
<h1>
		<%= UIUtil.toHTML((String)ppcLabels.get("paymentSummary")) %>
</h1>
<TABLE border="0">
	<TBODY>
		<TR>
			<TD width="226"><B><label for="paymentId"><%=UIUtil.toHTML((String)ppcLabels.get("paymentId"))%> :</label></B></TD>
			<TD width="333" id="paymentId"><%=payment.getId()%></TD>					
		</TR>
		<tr>
			<TD width="226"><B><label for="state"><%=UIUtil.toHTML((String)ppcLabels.get("state"))%> :</label></B></TD>
			<TD width="333" id="state"><%= (String)ppcLabels.get(converterStateOfPayment(state))%>
			</TD>			
		</TR>
		<TR>
			<TD width="226"><B><label for="expectedAmount"><%=UIUtil.toHTML((String)ppcLabels.get("expectedAmount"))%> :</label></B></TD>			
			<TD width="333" id="expectedAmount"><%=expectedAmount%></TD>
		</tr>

		<TR>
			<TD width="226"><B><label for="approvingAmount"><%=UIUtil.toHTML((String)ppcLabels.get("approvingAmount"))%> :</label></B></TD>
			<TD width="333" id="approvingAmount"><%=approvingAmount%></TD>
		</tr>
		<tr>
			<TD width="226"><B><label for="approvedAmount"><%=UIUtil.toHTML((String)ppcLabels.get("approvedAmount"))%> :</label></B></TD>
			<TD width="333" id="approvedAmount"><%=approvedAmount%></TD>
			
		</TR>
		<TR>
			<TD width="226"><B><label for="depositingAmount"><%=UIUtil.toHTML((String)ppcLabels.get("depositingAmount"))%> :</label></B></TD>
			<TD width="333" id="depositingAmount"><%=depositingAmount%></TD>
		</tr>
		<tr>
			<TD width="226"><B><label for="depositedAmount"><%=UIUtil.toHTML((String)ppcLabels.get("depositedAmount"))%> :</label></B></TD>
			<TD width="333" id="depositedAmount"><%=depositedAmount%></TD>
		</TR>
		<TR>
			<TD width="226"><B><label for="reversingApprovedAmount"><%=UIUtil.toHTML((String)ppcLabels.get("reversingApprovedAmount"))%> :</label></B></TD>
			<TD width="333" id="reversingApprovedAmount"><%=reversingApprovedAmount%></TD>
		</tr>
		<tr>
			<TD width="226"><B><label for="reversingDepositedAmount"><%=UIUtil.toHTML((String)ppcLabels.get("reversingDepositedAmount"))%> :</label></B></TD>
			<TD width="333" id="reversingDepositedAmount"><%=reversingDepositedAmount%></TD>
		</TR>		
		</tbody>
		</table>
		
</form>
<%
HashMap protocolData = null;
if(orderId != null && !orderId.equals("")){
     EDPPaymentInstructionsDataBean edpPIDataBean = new EDPPaymentInstructionsDataBean();
     edpPIDataBean.setOrderId(new Long(orderId));
     com.ibm.commerce.beans.DataBeanManager.activate(edpPIDataBean, request);
     ArrayList pis = edpPIDataBean.getPaymentInstructions();
	 Iterator iteForPI = pis.iterator();
	 while(iteForPI.hasNext()){
	      EDPPaymentInstruction aPI = (EDPPaymentInstruction)iteForPI.next();
		   if(aPI!=null && aPI.getBackendPIId() != null && aPI.getBackendPIId().toString().equals(piId)){
		        protocolData = aPI.getProtocolData();
		        break;
		   }
	 }
}

if(protocolData == null || protocolData.isEmpty()){
	PPCPIExtendedDataDataBean piExtDataBean = new PPCPIExtendedDataDataBean();
	piExtDataBean.setPIId(piId);
	com.ibm.commerce.beans.DataBeanManager.activate(piExtDataBean, request);

	ExtendedData extData = piExtDataBean.getExtendedData();
 	protocolData = extData.getExtendedDataAsHashMap();
}

HashMap hashData = protocolData;  	
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
		String value = "";
		if(hashData.get(key) != null){
		    value = (hashData.get(key)).toString();
		}	
		
	
	%>
		<TR>
			<TD><B><label for="<%=value%>"><%=showKey == null?key:showKey%> :</label></B></TD>
			<TD width="333" id="<%=value%>" ><%=value%></TD>
		</TR>
	<%}%>
	</tbody>
</table>
<SCRIPT language="JavaScript"> changeReasonCode('success');</SCRIPT>

</body>

</html>
