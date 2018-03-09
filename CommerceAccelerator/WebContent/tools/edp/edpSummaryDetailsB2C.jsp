<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="com.ibm.commerce.edp.beans.*" %>
<%@ page import="com.ibm.commerce.order.beans.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.edp.activitylog.*" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.price.beans.FormattedMonetaryAmountDataBean" %>
<%@ page import="com.ibm.commerce.price.utils.MonetaryAmount" %>
<%@ page import="com.ibm.commerce.common.beans.StoreDataBean" %>
<%@ page import="com.ibm.commerce.edp.activitylog.ActivityLoggerBean" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.sql.*" %>


<%@include file="../common/common.jsp" %>


<%
	CommandContext cmdContext = (CommandContext)request.getAttribute("CommandContext");
	Locale jLocale = cmdContext.getLocale();
	Integer storeId = cmdContext.getStoreId();
    Integer langId		= cmdContext.getLanguageId();

	//getting the payment labels from EDP resoource bundle
	Hashtable edpLabels = (Hashtable)ResourceDirectory.lookup("edp.edpLabels", jLocale);
		
	
	JSPHelper URLParameters = new JSPHelper(request);
	String sendNotification = URLParameters.getParameter("sendNotification");
	Long orderId = new Long(URLParameters.getParameter("orderId"));
	String classId="list_row2";
	
	OrderDataBean orderBean = new OrderDataBean ();
    com.ibm.commerce.common.beans.StoreDataBean iStoreDB = new com.ibm.commerce.common.beans.StoreDataBean();
    iStoreDB.setStoreId(storeId.toString());

    if ((classId != null) && !(classId.equals(""))) {
	  orderBean.setSecurityCheck(false);
	  orderBean.setOrderId(orderId.toString());
	  com.ibm.commerce.beans.DataBeanManager.activate(orderBean, request);
	}
	String currency = orderBean.getCurrency();
%>	
<%!
	public String getFormattedAmount(BigDecimal amount, String currency,Integer langId, StoreDataBean iStoreDB) {
	  try {
		FormattedMonetaryAmountDataBean formattedAmount =  new FormattedMonetaryAmountDataBean(
				new MonetaryAmount(amount, currency),
				iStoreDB, langId);
		
		return formattedAmount.getPrimaryFormattedPrice().toString();
	  } catch (Exception exc) {
		  return "";
	  }
   }
    
   public String getMaskedAccountNumber(String accountNumber){
     String result = "";
     if (accountNumber !=null &&  !accountNumber.equals("")) {
		 StringBuffer displayAccountNumber = new StringBuffer();
		 for (int i=0; i<accountNumber.length()-4; i++) {
		     if (accountNumber.charAt(i) != '-' && accountNumber.charAt(i) != ' ') {
		     	 displayAccountNumber.append("*");
		     }
		 }
	 displayAccountNumber.append(accountNumber.substring(accountNumber.length()-4));
     result = displayAccountNumber.toString();
     }
     return result;
  }
  
  public String getOperation(ActivityLogRecordData aData){
     String operation = aData.getOperation();
     String result = "";
     if (operation.equalsIgnoreCase(ActivityLoggerBean.OPERATION_CREATE)){
        result = "operationCreate";
     }else if (operation.equalsIgnoreCase(ActivityLoggerBean.OPERATION_REMOVE)){
        result = "operationRemove";
     }else if (operation.equalsIgnoreCase(ActivityLoggerBean.OPERATION_CANCEL)){
        result = "operationCancel";
     }else if (operation.equalsIgnoreCase(ActivityLoggerBean.OPERATION_UPDATE)){
        result = "operationUpdate";
     }else if (operation.equalsIgnoreCase(ActivityLoggerBean.OPERATION_APPROVE)){
        result = "operationApprove";
     }else if (operation.equalsIgnoreCase(ActivityLoggerBean.OPERATION_APPROVEANDDEPOSIT)){
        result = "operationApproveAndDeposit";
     }else if (operation.equalsIgnoreCase(ActivityLoggerBean.OPERATION_DEPOSIT)){
        result = "operationDeposit";
     }else if (operation.equalsIgnoreCase(ActivityLoggerBean.OPERATION_REFUND)){
        result = "operationRefund";
     }else if (operation.equalsIgnoreCase(ActivityLoggerBean.OPERATION_REVERSE_REFUND)){
        result = "operationReverseRefund";
     }else if (operation.equalsIgnoreCase(ActivityLoggerBean.OPERATION_REVERSE_APPROVAL)){
        result = "operationReverseApproval";
     }else if (operation.equalsIgnoreCase(ActivityLoggerBean.OPERATION_REVERSE_DEPOSIT)){
        result = "operationReverseDeposit";
     }
     return result;
  }
  public String getOperationResult(ActivityLogRecordData aData){
     String operationResult = aData.getOperationResult();
     String result = "";
     if (operationResult.equalsIgnoreCase(ActivityLoggerBean.OPERATION_RESULTS_SUCCESS)){
        result = "resultSuccess";
     }else if (operationResult.equalsIgnoreCase(ActivityLoggerBean.OPERATION_RESULTS_FAILED)){
        result = "resultFail";
     }else if (operationResult.equalsIgnoreCase(ActivityLoggerBean.OPERATION_RESULTS_PENDING)){
        result = "resultPending";
     }
     return result;
  }
  public String getType(ActivityLogRecordData aData){
     String type = aData.getType();
     String result = "";
     if (type.equalsIgnoreCase(ActivityLoggerBean.RECORD_TYPE_PAYMENT_INSTRUCTION)){
        result = "typePaymentInstruction";
     }else if (type.equalsIgnoreCase(ActivityLoggerBean.RECORD_TYPE_PAYMENT)){
        result = "typePayment";
     }
     return result;
  }
%>


 <HTML>
  <HEAD> 

  <link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
    
  
    <TITLE><%= UIUtil.toHTML(edpLabels.get("paymentSummaryDetDialogTitle").toString()) %></TITLE>   
    <script src="/wcs/javascript/tools/common/Util.js"></script>
    <script src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>
    <script src="/wcs/javascript/tools/common/Vector.js"></script>

<script>
    function init() {
      	parent.setContentFrameLoaded(true);
      	}

</script>

  </HEAD>

  
    <BODY CLASS=content ONLOAD="init();">  
	<H1><%=UIUtil.toHTML((String)edpLabels.get("edpDetailsTitle")) %></H1>  
	
	<table>
       <tr>
         <td>
         <%= UIUtil.toHTML((String)edpLabels.get("edpSummaryOrderId")+(String)edpLabels.get("edpSummaryLabelTextSeparator")) %>
         <td/>
         <td><i>
         <%=orderId%>
         <i/><td/>
       </tr>
       <tr>
         <td>
         <%= UIUtil.toHTML((String)edpLabels.get("edpSummarycurrency")+(String)edpLabels.get("edpSummaryLabelTextSeparator")) %>
         <td/>
         <td><i>
         <%=currency%>
         <i/><td/>
       </tr>
  </table>
	
	<!-- Payment Instuction/Payment Activity History information -->
      	<BR><P><B><%= UIUtil.toHTML((String)edpLabels.get("paymentHistory")) %></B>
      	<BR><BR> 
   	
	<table class="list" width=95% cellpadding=2 cellspacing=1 summary="<%= UIUtil.toHTML((String)edpLabels.get("edpSummaryPIActivityHistoryTable")) %>" >
		<tr class="list_roles" align="center"> 
			<td class="list_header" id="iOp" align="left"><%= UIUtil.toHTML(edpLabels.get("Operation").toString()) %></td>
			<td class="list_header" id="iOp" align="left"><%= UIUtil.toHTML(edpLabels.get("Type").toString()) %></td>
			<td class="list_header" id="iAm" align="left"><%= UIUtil.toHTML(edpLabels.get("Amount").toString()) %></td>
			<td class="list_header" id="iAc" align="left"><%= UIUtil.toHTML(edpLabels.get("Account").toString()) %></td>
			<td class="list_header" id="iTs" align="left"><%= UIUtil.toHTML(edpLabels.get("Timestamp").toString()) %></td>
			<td class="list_header" id="iPR" align="left"><%= UIUtil.toHTML(edpLabels.get("OperationResult").toString()) %></td>

		</tr>

<%
//Get Payment Activity History
	
	try{
    	EDPCompleteOrderActivityDataBean pdpPIActivityHistoryDataBean	=	new EDPCompleteOrderActivityDataBean();
	    pdpPIActivityHistoryDataBean.setOrderId(orderId);
	    com.ibm.commerce.beans.DataBeanManager.activate(pdpPIActivityHistoryDataBean, request);
		java.util.ArrayList alActiveLogs = pdpPIActivityHistoryDataBean.getPaymentActivityHistory();
		Iterator   iterator = alActiveLogs.iterator();
   		while (iterator.hasNext()) { %> <TR CLASS=<%= UIUtil.toHTML(classId) %>> <%
			ActivityLogRecordData recordData = (ActivityLogRecordData) iterator.next();
			String paymentSummaryOperationTimeStamp = "";
        %>
			<TD CLASS="list_info1" align="left"><%= UIUtil.toHTML((String)edpLabels.get(getOperation(recordData))) %></TD>
			<TD CLASS="list_info1" align="left"><%= UIUtil.toHTML((String)edpLabels.get(getType(recordData))) %></TD>
			<TD CLASS="list_info1" align="left"><%= getFormattedAmount(recordData.getAmount(),currency,langId,iStoreDB) %></TD>
			<%
		      String accountNumber = (String)recordData.getAccount();
		      String maskedAccountNumber =getMaskedAccountNumber(accountNumber);
			%>
			<TD CLASS="list_info1" align="left"><%= UIUtil.toHTML(maskedAccountNumber) %></TD>
		   
			
		<% 
		if (recordData.getTimestamp()!= null) { 
			paymentSummaryOperationTimeStamp = TimestampHelper.getDateTimeFromTimestamp(recordData.getTimestamp(), jLocale);
		} else
		 	paymentSummaryOperationTimeStamp = (String) edpLabels.get("edpSummaryNotAvailable");
		%>	
		    <TD CLASS="list_info1" align="left"><%= UIUtil.toHTML(paymentSummaryOperationTimeStamp) %></TD>
		    <TD CLASS="list_info1" align="left"><%= UIUtil.toHTML((String)edpLabels.get(getOperationResult(recordData))) %></TD>
        </TR>
			
			<% 
			
				if (classId.equals("list_row2")) {
					classId="list_row1";
				} else {
					classId="list_row2";
				}
			
			} //while loop 
		}catch(Exception e){}
			
		%>
		</TABLE>
	</BODY>
  
</HTML>