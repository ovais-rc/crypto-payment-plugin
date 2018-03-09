<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006, 2016
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>
<%--
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
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">


<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.*" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.RMADataBean" %>
<%@ page import="com.ibm.commerce.edp.beans.EDPPaymentInstructionsDataBean" %>
<%@ page import="com.ibm.commerce.edp.beans.EDPRefundInstructionsDataBean" %>
<%@ page import="com.ibm.commerce.edp.api.EDPPaymentInstruction" %>
<%@ page import="com.ibm.commerce.payment.beans.UsableRefundTCListDataBean" %>
<%@ page import="com.ibm.commerce.payment.beans.UsablePaymentTCListDataBean" %>
<%@ page import="com.ibm.commerce.edp.refunds.RefundInstructionData" %>
<%@ page import="com.ibm.commerce.payment.beans.RefundTCInfo" %>
<%@ page import="com.ibm.commerce.payment.beans.PaymentTCInfo" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.RMAItemDataBean" %>
<%@ page import="com.ibm.commerce.order.beans.OrderItemDataBean" %>
<%@ page import="com.ibm.commerce.order.beans.OrderDataBean" %>
<%@ page import="com.ibm.commerce.contract.beans.BusinessPolicyDataBean" %>
<%@ page import="com.ibm.commerce.payment.rules.EDPServices" %>
<%@ page import="com.ibm.commerce.edp.model.PaymentInstructionData"%>
<%@include file="../common/common.jsp" %>
<%
try{
       CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
       Locale jLocale = cmdContext.getLocale();
       Hashtable returnsNLS = (Hashtable)ResourceDirectory.lookup("returns.ReturnsNLS", jLocale);
       JSPHelper jspHelper = new JSPHelper(request);
       String jLanguageID = cmdContext.getLanguageId().toString();
%>

<HTML>
<HEAD>

<LINK REL="stylesheet" HREF="<%= UIUtil.getCSSFile(jLocale) %>" TYPE="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/ConvertToXML.js"></SCRIPT>
<SCRIPT> 
  var pisInScript = new Array();
  var piDescsInScript = new Array();
  var creditLineName;
  var selectRefundPolicyId;
  var piSize;
  var isRefundInstructionExists = false;
</SCRIPT>

<%
       String returnId = jspHelper.getParameter("returnId");
       RMADataBean rma = new RMADataBean();
       rma.setRmaId(returnId);
        com.ibm.commerce.beans.DataBeanManager.activate(rma, request);
       boolean isCLSeleted = false;
%>

<%
request.setAttribute("returnId", returnId);
request.setAttribute("returnsNLS", returnsNLS);
%>
<jsp:include page="/tools/returns/ReturnFinishHandler.jsp" flush="true" />
<%
UsableRefundTCListDataBean refundTCs = new UsableRefundTCListDataBean();
refundTCs.setRmaId(returnId);
com.ibm.commerce.beans.DataBeanManager.activate(refundTCs, request);
RefundTCInfo[] refundTCInfo = refundTCs.getRefundTCInfo();
Long orderId = rma.getRefundAgainstOrdIdInEntityType();
if (orderId==null){
  java.sql.Timestamp oldDate = new java.sql.Timestamp(1);
  java.sql.Timestamp newDate = new java.sql.Timestamp(1);
  RMAItemDataBean[] rmaItems = rma.getRmaItemDataBeans();
  RMAItemDataBean abRMAItem = new RMAItemDataBean();
  OrderItemDataBean abOrderItem = new OrderItemDataBean();
  OrderDataBean abOrder = null;
  Long newOrderId = null;
  for (int m=0; m<rmaItems.length; m++){
    abRMAItem = rmaItems[m];
    abOrderItem = abRMAItem.getOrderItemDataBean();
    if (abOrderItem !=null){
      newOrderId = abOrderItem.getOrderIdInEntityType();
      abOrder = new OrderDataBean();
      abOrder.setOrderId(newOrderId.toString());
      com.ibm.commerce.beans.DataBeanManager.activate(abOrder,request);
      newDate = abOrder.getPlaceOrderTimeInEntityType();
      if ((newDate!=null)&&(newDate.after(oldDate))){
        orderId = newOrderId;
		oldDate = newDate;
      }
    }
  }
}
EDPPaymentInstructionsDataBean bean = new EDPPaymentInstructionsDataBean();
bean.setOrderId(orderId);
com.ibm.commerce.beans.DataBeanManager.activate(bean, request);
UsablePaymentTCListDataBean paymentTCs = new UsablePaymentTCListDataBean();
paymentTCs.setOrderId(orderId);
com.ibm.commerce.beans.DataBeanManager.activate(paymentTCs,request);
PaymentTCInfo[] paymentTCInfos = paymentTCs.getPaymentTCInfo();
java.util.ArrayList pis = bean.getPaymentInstructions();
int size = pis.size();
java.util.ArrayList piDescs = new ArrayList();
java.util.ArrayList usablePis = new ArrayList();
Long paymentPolicyId = null;
if (size>0){
    EDPPaymentInstruction pi = (EDPPaymentInstruction) pis.get(0);
    PaymentInstructionData piData = new PaymentInstructionData();
    paymentPolicyId = pi.getPolicyId();
    int k = 0;
    for (int i = 0; i< pis.size(); i++){
      
      pi = (EDPPaymentInstruction) pis.get(i);
      piData = EDPServices.getServices().getOmfAccessor().getOMF().getPaymentInstruction(pi.getId());
      if (piData.getRefundAllowed().booleanValue()){
        usablePis.add(k,pi);
        paymentPolicyId = pi.getPolicyId();
        for (int j =0; j< paymentTCInfos.length;j++){
          PaymentTCInfo curPaymentTCInfo = paymentTCInfos[j];
          if (curPaymentTCInfo.getPolicyId().equalsIgnoreCase(
	          paymentPolicyId.toString())){
              String paymentMethodDesc = curPaymentTCInfo.getPaymentMethodDisplayName();
              piDescs.add(k,paymentMethodDesc);
              k++;
              break;
          }
        }
      }
  
    }
    Long curPolicyId = pi.getPolicyId();
    BusinessPolicyDataBean policyDataBean = new BusinessPolicyDataBean();
    policyDataBean.setDataBeanKeyPolicyId(curPolicyId.toString());
    com.ibm.commerce.beans.DataBeanManager.activate(policyDataBean,request);
    String properties = policyDataBean.getProperties();
if (properties.indexOf("compatibleMode=false")>-1){
%>
 <script>
   creditLineName = "LineOfCredit";
 </script>
<%
}else{
%>
  <script>
   creditLineName = "Credit";
  </script>
<%
}
for (int i = 0; i< usablePis.size(); i++){
%>
  <script>
    pisInScript[<%=i%>]="<%=((EDPPaymentInstruction)(usablePis.get(i))).getPolicyId()%>";
    piDescsInScript[<%=i%>]="<%=(String)(piDescs.get(i))%>";
  </script>
<%
}
}
%>
<script>
  piSize = "<%=size%>";
  parent.put("piSize",piSize);
  parent.put("usablePiSize",pisInScript.length);
</script>
<SCRIPT>
function init() 
{
   var creditMethodPolicyID = parent.get("refundPolicyId");
   var i = 0;
   for ( i = 0; i < document.creditMethodForm.creditMethodSelect.options.length; i++ )
   {
      if ( document.creditMethodForm.creditMethodSelect.options[i].value == creditMethodPolicyID )
      {  
         document.creditMethodForm.creditMethodSelect.options[i].selected = true;
         break;
      }
   }

   parent.put("prev",parent.getCurrentPanelAttribute("name"));
   if (parent.setContentFrameLoaded) {
      parent.setContentFrameLoaded(true);
   }
}
function savePanelData()
{      var j=0;
       var creditMethod = document.creditMethodForm.creditMethodSelect.value;
       parent.put("refundPolicyId",creditMethod);
       if ((selectRefundPolicyId =="-2001")&&((typeof   (document.paymentMethodForm.creditMethodSelect2))   !=   "undefined")){
         parent.put("paymentPolicyId",document.paymentMethodForm.creditMethodSelect2.value);
         for (j = 0; j < document.paymentMethodForm.creditMethodSelect2.options.length; j++ ){
           if ( document.paymentMethodForm.creditMethodSelect2.options[j].selected ){
             parent.put("paymentPolicyName",piDescsInScript[j]);
             break;
           }
         }
       }else if (selectRefundPolicyId =="-2000"){
         parent.put("paymentPolicyId",<%=paymentPolicyId%>);
         parent.put("paymentPolicyName",creditLineName);
       }
       
}
function validatePanelData(){
  if(((pisInScript.length==0) && (selectRefundPolicyId =="-2001"||selectRefundPolicyId =="-2002"))||((selectRefundPolicyId =="-2000")&&(piSize=="0"))){
      alertDialog('<%=UIUtil.toHTML((String)returnsNLS.get("noRefundMethodMsg"))%>');
      return false;
  }
}
function showPaymentMethod(policyId)
{      var table=document.getElementById("WC_C_PaymentMethod_Table_1");
       selectRefundPolicyId = policyId;
       if ((policyId == "-2001")&&(pisInScript.length!=0)){
            var thisLabel = "<%= (String)returnsNLS.get("originalPaymentMethodInstructions") %>";
            var dropDown = "<DIV>"+thisLabel+"</DIV><BR><BR>";
            dropDown += "<SELECT name=\"creditMethodSelect2\" ID=\"creditMethodSelect2\">";
            for (k=0;k<<%=usablePis.size()%>;k++){
              option = "<OPTION value=\""+pisInScript[k]+"\">"+piDescsInScript[k]+"</OPTION>";
              dropDown += option;
            }
            dropDown += "</SELECT>";
            table.rows[0].cells[0].innerHTML = dropDown;   
       }
       if (policyId == "-2000" || policyId == "-2002"){
          table.rows[0].cells[0].innerHTML = "";
       }
       
}
</SCRIPT>

<TITLE><%= UIUtil.toHTML((String)returnsNLS.get("returnCreditMethodTitle")) %></TITLE>

</HEAD>

<BODY onload="init();" class="content">

<H1><%= UIUtil.toHTML((String)returnsNLS.get("returnCreditMethodTitle")) %></H1>

<DIV><%= (String)returnsNLS.get("returnCreditMethodInstructions") %></DIV><BR><BR>

<%
  if (refundTCInfo == null || refundTCInfo.length==0){
%>
  <script>
     alertDialog('<%=UIUtil.toHTML((String)returnsNLS.get("noRefundMethodMsg"))%>');
     top.goBack();
  </script>
<%}%>
<FORM name="creditMethodForm">
<LABEL for="creditMethodSelect1"></LABEL><SELECT name="creditMethodSelect" ID="creditMethodSelect1" onchange="showPaymentMethod(this.value)">
<%
if (refundTCInfo != null && refundTCInfo.length >0) {
    for (int i=0; i < refundTCInfo.length; i++) {
        %>
              <OPTION value="<%=refundTCInfo[i].getPolicyId()%>"><%=refundTCInfo[i].getShortDescription()%></OPTION>
<%
       }
}

%>
</SELECT>
</FORM>

<FORM name="paymentMethodForm">
  <table id = "WC_C_PaymentMethod_Table_1">
    <tr><td id ="WC_C_PaymentMethod_TableCell_11"></td></tr>
  </table>
</FORM>
<%
EDPRefundInstructionsDataBean refundDataBean = new EDPRefundInstructionsDataBean();
refundDataBean.setRmaId(new Long(returnId));
com.ibm.commerce.beans.DataBeanManager.activate(refundDataBean, request);
List existingRefundInstructions = refundDataBean.getRefundInstructions();
RefundInstructionData currentRefundInstructionData = null;
if(existingRefundInstructions!=null){
	for(int k=0;k<existingRefundInstructions.size();k++){
		RefundInstructionData temp = (RefundInstructionData)existingRefundInstructions.get(k);
		if(!temp.getCanceled().booleanValue()){
			currentRefundInstructionData = temp;
			%>
			<script>
			   isRefundInstructionExists = true;
			   var refundInstructionPolicyId = <%=currentRefundInstructionData.getPolicyId().toString()%>;
			</script>
			<%
			break;
		}
	}
}
%>
<script>
  var curPolicyId;
  if (typeof (parent.get("refundPolicyId"))   !=   "undefined"){
      curPolicyId = parent.get("refundPolicyId");
  }else{
      curPolicyId = document.creditMethodForm.creditMethodSelect.value
  }
  showPaymentMethod(curPolicyId);
  
  if(curPolicyId == "-2001" && isRefundInstructionExists == true){
  	var m;
  	for (m = 0; m < document.paymentMethodForm.creditMethodSelect2.options.length; m++ ){
  		if(pisInScript[m]==refundInstructionPolicyId){
  			document.paymentMethodForm.creditMethodSelect2.options[m].selected = true;
  			break;
  		}
        
      }
  } 
</script>


</BODY>
</HTML>

<%
}
catch (Exception e)
{
       com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
}
%>
