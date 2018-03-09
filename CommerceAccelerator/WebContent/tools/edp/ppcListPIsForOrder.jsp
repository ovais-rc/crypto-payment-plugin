<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

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
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>

<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.payment.ppc.beans.*" %>
<%@ page import="com.ibm.commerce.payment.beans.*" %>
<%@ page import="com.ibm.commerce.contract.objects.*" %>
<%@ page import="com.ibm.commerce.payments.plugincontroller.PaymentInstruction" %>
<%@ page import="com.ibm.commerce.edp.config.ConfigurationService" %>
<%@ page import="com.ibm.commerce.edp.config.PaymentGroupConfiguration" %>
<%@ page import="com.ibm.commerce.edp.parsers.paymentmethodconfigurations.PaymentMethodConfigurations" %>
<%@ page import="com.ibm.commerce.edp.parsers.paymentmappings.PaymentMappings" %>
<%@ page import="com.ibm.commerce.edp.parsers.paymentmethodconfigurations.PaymentMethodConfiguration" %>
<%@ page import="com.ibm.commerce.payment.rules.EDPServices" %>
<%@ page import="com.ibm.commerce.edp.model.PaymentInstructionData" %>
<%@ page import="com.ibm.commerce.edp.utils.Constants"%>
<%@include file="../common/common.jsp" %>
<%@include file="../common/NumberFormat.jsp" %>
<%@include file="ppcUtil.jsp" %>

<%--
//---------------------------------------------------------------------
//- Method Declarion
//---------------------------------------------------------------------
--%>
<%!

%>
<%--
//---------------------------------------------------------------------
//- Logic Section
//---------------------------------------------------------------------
--%>
<%

// obtain the resource bundle for display
CommandContext cmdContextLocale =
	(CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();
Integer langId = cmdContextLocale.getLanguageId();
String storeId = cmdContextLocale.getStoreId().toString();
String currency = cmdContextLocale.getCurrency();
Hashtable ppcLabels =(Hashtable) ResourceDirectory.lookup("edp.ppcLabels", jLocale);

JSPHelper jspHelper = new JSPHelper(request);
String searchOrderId = request.getParameter("orderId").trim();

// get standard list parameters
String xmlFile = "edp.ppcListPIsForOrder";

PPCListPIsForOrderDataBean piList = new PPCListPIsForOrderDataBean();

piList.setOrderId(searchOrderId);
piList.setStoreId(storeId);
com.ibm.commerce.beans.DataBeanManager.activate(piList, request);



%>
<html lang="en">
<head>
<link rel="stylesheet" href="<%=UIUtil.getCSSFile(jLocale)%>"
	type="text/css" />
<title><%=ppcLabels.get("title")%></title>

<script src="/wcs/javascript/tools/common/Util.js"></script>
<script src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" type="text/javascript">
<!-- <![CDATA[

	

//---------------------------------------------------------------------
//  Required javascript function for dynamic list
//---------------------------------------------------------------------
    function onLoad()
    {
      parent.loadFrames()
    }

	function getResultsSize() {
		return <%=piList.getPaymentInstructionList().size()%>;
	}
//---------------------------------------------------------------------
//  user defined javascript functions 
//---------------------------------------------------------------------
	
	
    function findPayment(){
    	var tokens = parent.getSelected().split(",");
		var piId = tokens[0];	
	
      	var url="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=edp.ppcListPaymentsForPI&amp;cmd=ppcListPaymentsForPIView";
        
    	url += "&piId=" + piId;
          	
      if (top.setContent)
      { 	 
         top.setContent("<%=UIUtil.toHTML((String) ppcLabels.get("ListPaymentTitle"))%>", url, true);

      }else{
      	
        parent.location.replace(url);
      }
    }
    
     function findCredit(){
        var tokens = parent.getSelected().split(",");
		var piId = tokens[0];	
	
      	var url="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=edp.ppcListCreditsForPI&amp;cmd=ppcListCreditsForPIView";
        
    	url += "&piId=" + piId;
          	
      if (top.setContent)
      { 	 
         top.setContent("<%=UIUtil.toHTML((String) ppcLabels.get("ListCreditTitle"))%>", url, true);

      }else{      	
        parent.location.replace(url);
      }
     }
  
	function showExtendedData(){
     	var orderId = <%=(searchOrderId == null ? null : UIUtil.toJavaScript(searchOrderId))%>;
     	
     	var tokens = parent.getSelected().split(",");
		var piId = tokens[0];
	
      	var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=edp.ppcPIExtendedDialog";
        
    	url += "&orderId="+orderId + "&piId=" + piId;
        	
      	if (top.setContent)
      	{ 	 
       	  top.setContent("<%=UIUtil.toHTML((String) ppcLabels.get("extendedData"))%>", url, true);
	
      	}else{      	
      	  parent.location.replace(url);
      	}
     
     }
     
     	function editExtendedData(){
     	var orderId = <%=(searchOrderId == null ? null : UIUtil.toJavaScript(searchOrderId))%>;
     	
     	var tokens = parent.getSelected().split(",");
		var piId = tokens[0];
	
      	var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=edp.ppcEditPIExtDataDialog";
        
    	url += "&orderId="+orderId + "&piId=" + piId;
        	
      	if (top.setContent)
      	{ 	 
       	  top.setContent("<%=UIUtil.toHTML((String) ppcLabels.get("extendedData"))%>", url, true);
	
      	}else{      	
      	  parent.location.replace(url);
      	}
     
     }
     
	function viewPI(){
		var orderId = <%=(searchOrderId == null ? null : UIUtil.toJavaScript(searchOrderId))%>;
		var tokens = parent.getSelected().split(",");
		var piId = tokens[0];
	
      	var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=edp.ppcPISummary";
        
    	url += "&orderId="+orderId + "&piId=" + piId;
        
      if (top.setContent)
      {
         top.setContent("<%=UIUtil.toHTML((String) ppcLabels.get("PISummary"))%>", url, true);

      }else{
      	
        parent.location.replace(url);
      }
	}
	//Add the method for refund without return case
	//The method will be executed after click the credit button for indepandant way
	function independentCredit(){

        var orderId = <%=(searchOrderId == null ? null : UIUtil.toJavaScript(searchOrderId))%>;
		var tokens = parent.getSelected().split(",");
		var piId = tokens[0];	
		var i = piId.indexOf("#");	
		piId = piId.substring(0,i);
		

        var url="/webapp/wcs/tools/servlet/WizardView?XMLFile=edp.ppcCreateCreditWizard";

        url += "&orderId="+orderId + "&piId=" +  piId;
        if (top.setContent)
        {

         	top.setContent("<%= UIUtil.toHTML((String)ppcLabels.get("creditAgainstPayment")) %>", url, true);

      	}else{
        	parent.location.replace(url);
      	}

    }
    //Add the method for refund without return case.
    //The method supports select all or deselect all button.
    function selectAllButtons() {
       		parent.selectDeselectAll();
       		checkButton();
	}
    
    //Add the method for refund without return case.
    //The method executes the logic of checking credit button.
    function checkButton() {
    	var tokens = parent.getSelected().split(",");
    	
		var piId = tokens[0];
		
		if(piId.indexOf("true")>0 ){			
			disableButton(parent.buttons.buttonForm.creditButtonButton);
		}else{			
			enableButton(parent.buttons.buttonForm.editButtonButton);
		}
		 
		
	}
	
	//Add the method for refund without return case
	//Disable current button 
	function disableButton(b) {
		if (defined(b)) {
			b.disabled=true;
			b.className='disabled';
			b.id='disabled';
		}
	}

	//Add the method for refund without return case
	//Enable current button
	function enableButton(b) {
		if (defined(b)) {
			b.disabled=false;
			b.className='enabled';
			b.id='enabled';
		}
	}   

//---------------------------------------------------------------------
//  GUI functions  onload="onLoad()"
//---------------------------------------------------------------------


//[[>-->
</script>
</head>

<body onload="onLoad()" class="content">
<!--JSP File name :ppcListPIsForOrder.jsp -->
<%int startIndex = Integer.parseInt(jspHelper.getParameter("startindex"));
int listSize = Integer.parseInt(jspHelper.getParameter("listsize"));
int endIndex = startIndex + listSize;
int rowselect = 1;
int totalsize = piList.getPaymentInstructionList().size();
int totalpage = totalsize / listSize;

int actualSize = listSize;
if (totalsize < listSize) {
	actualSize = totalsize;
}
%>
<script type="text/javascript">

</script>
<%=comm.addControlPanel(xmlFile, totalpage, totalsize, jLocale)%>

<form name='ppcListPIsForOrder'>
<%=comm.startDlistTable("OrderPIListTableSummary")%>
<%=comm.startDlistRowHeading()%> 
<%=comm.addDlistCheckHeading(true,"selectAllButtons()")%>
<%=comm.addDlistColumnHeading((String)ppcLabels.get("payInstId"), null, false,null,false)%>
<%=comm.addDlistColumnHeading((String)ppcLabels.get("payment_method"), null, false,null,false)%>
<%=comm.addDlistColumnHeading((String)ppcLabels.get("state"), null, false,null,false)%>
<%=comm.addDlistColumnHeading((String)ppcLabels.get("amount"), null, false,null,false)%>
<%=comm.addDlistColumnHeading((String)ppcLabels.get("approvedAmount"), null, false,null,false)%>
<%=comm.addDlistColumnHeading((String)ppcLabels.get("approvingAmount"), null, false,null,false)%>
<%=comm.addDlistColumnHeading((String)ppcLabels.get("depositedAmount"), null, false,null,false)%>
<%=comm.addDlistColumnHeading((String)ppcLabels.get("depositingAmount"), null, false,null,false)%>
<%=comm.addDlistColumnHeading((String)ppcLabels.get("creditedAmount"), null, false,null,false)%>
<%=comm.addDlistColumnHeading((String)ppcLabels.get("creditingAmount"), null, false,null,false)%>

<%=comm.endDlistRow()%>

<%if (endIndex > piList.getListSize()) {
	endIndex = piList.getListSize();
}

// TABLE CONTENT

for (int i = startIndex; i < endIndex; i++) {
	int state = piList.getPIListData(i).getState();
	String statue = (String)ppcLabels.get(converterStateOfPI(state));
	String amount = getFormattedAmount(piList.getPIListData(i).getAmount(),currency,langId,storeId);
	String approvedAmount = getFormattedAmount(piList.getPIListData(i).getApprovedAmount(),currency,langId,storeId);
	String approvingAmount = getFormattedAmount(piList.getPIListData(i).getApprovingAmount(),currency,langId,storeId);
	String depositedAmount = getFormattedAmount(piList.getPIListData(i).getDepositedAmount(),currency,langId,storeId);
	String depositingAmount = getFormattedAmount(piList.getPIListData(i).getDepositingAmount(),currency,langId,storeId);
	String creditedAmount = getFormattedAmount(piList.getPIListData(i).getCreditedAmount(),currency,langId,storeId);
	String creditingAmount = getFormattedAmount(piList.getPIListData(i).getCreditingAmount(),currency,langId,storeId);
	//Add refund without return logic here
	//Get isDependentCreditRequired configuration point value
	boolean isdependent = true;
	PaymentInstructionData paymentInstruction = EDPServices.getServices().getOmfAccessor().getOMF().findPaymentInstructionByBackendId(piList.getPIListData(i).getId());
    //get payment method name
    String method = paymentInstruction.getPaymentMethod();
    if(method == null){
       method = Constants.EMPTY_STRING;
    } 
    PaymentGroupConfiguration paymentGroupConfiguration = ConfigurationService
             .getPaymentGroupConfiguration(paymentInstruction.getPaymentConfigurationGroupId());  
    PaymentMethodConfigurations configurations = paymentGroupConfiguration.getPaymentMethodConfigurations(); 
    PaymentMappings mappings = paymentGroupConfiguration.getMappings();
    String configurationName = Constants.EMPTY_STRING;
    //get configuration name
    for(int j=0; j < mappings.getMappingCount();j++){
         String methodName = mappings.getMapping(j).getPaymentMethod();
         if(method.equals(methodName)){
             configurationName = mappings.getMapping(j).getPaymentConfiguration();
            break;
          }
    }
    
    //to translate the payment method name
    String paymentMethodName = method;
	BusinessPolicyAccessBean policyForPaymentMethod = new BusinessPolicyAccessBean();
	if(paymentInstruction.getPolicyId()!=null){
         String policyId = paymentInstruction.getPolicyId().toString();
	     policyForPaymentMethod.setInitKey_policyId(policyId);
	     PaymentPolicyInfo policyInfo = PaymentPolicyInfo.createFromAccessBean(policyForPaymentMethod, cmdContextLocale);
	     if(policyInfo!=null){
	          if (policyInfo.getShortDescription() != null && policyInfo.getShortDescription().length() > 0) {
	                paymentMethodName = policyInfo.getShortDescription();
	          }
	     }
	}
    
    //set isdependent value
    for(int j =0;j < configurations.getPaymentMethodConfigurationCount();j++){
        PaymentMethodConfiguration configuration = configurations.getPaymentMethodConfiguration(j);
       if(configuration.getName().equals(configurationName)){
           if(!configuration.isDependentCreditRequired())
               isdependent = false;
           break;
        }
    }
    //End
	
%> 
<%=comm.startDlistRow(rowselect)%>
<%=comm.addDlistCheck(piList.getPIListData(i).getId().toString() + "#C" + isdependent , "parent.setChecked();checkButton()")%>
<%=comm.addDlistColumn(piList.getPIListData(i).getId(), "none")%>
<%=comm.addDlistColumn(paymentMethodName, "none")%>
<%=comm.addDlistColumn(statue, "none", "white-space: nowrap")%>
<%=comm.addDlistColumn(amount, "none")%>
<%=comm.addDlistColumn(approvedAmount, "none")%>
<%=comm.addDlistColumn(approvingAmount, "none")%>
<%=comm.addDlistColumn(depositedAmount, "none")%>
<%=comm.addDlistColumn(depositingAmount, "none")%>
<%=comm.addDlistColumn(creditedAmount, "none")%>
<%=comm.addDlistColumn(creditingAmount, "none")%>


<%=comm.endDlistRow()%>
<%if (rowselect == 1) {
	rowselect = 2;
} else {
	rowselect = 1;
}
}%> 
<%=comm.endDlistTable()%> 
<%if (piList.getListSize() == 0) {
%>

<p></p>
<p></p>
<table cellspacing="0" cellpadding="3" border="0">
	<tr>
		<td colspan="7"><%=(String)ppcLabels.get("noPaymentInstructionToList")%></td>
	</tr>
</table>
<%}
%></form>

<script>
   parent.afterLoads();
   parent.setResultssize(<%=totalsize%>);

</script>

</body>
</html>


