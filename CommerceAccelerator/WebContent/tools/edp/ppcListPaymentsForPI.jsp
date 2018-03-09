<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>

<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %> 
<%@ page import="com.ibm.commerce.payment.ppc.beans.*" %>
<%@ page import="com.ibm.commerce.payments.plugincontroller.Payment" %>
<%@ page import="com.ibm.commerce.payments.plugincontroller.PPCConstants" %>
<%@ page import="com.ibm.commerce.edp.config.ConfigurationService" %>
<%@ page import="com.ibm.commerce.edp.config.PaymentGroupConfiguration" %>
<%@ page import="com.ibm.commerce.edp.parsers.paymentmethodconfigurations.PaymentMethodConfigurations" %>
<%@ page import="com.ibm.commerce.edp.parsers.paymentmappings.PaymentMappings" %>
<%@ page import="com.ibm.commerce.edp.parsers.paymentmethodconfigurations.PaymentMethodConfiguration" %>
<%@ page import="com.ibm.commerce.payment.rules.EDPServices" %>
<%@ page import="com.ibm.commerce.edp.model.PaymentInstructionData" %>
<%@ page import="com.ibm.commerce.payment.ppc.beans.PPCGetPaymentDataBean" %>
<%@include file="../common/common.jsp" %>
<%@include file="ppcUtil.jsp" %>
<%--
//---------------------------------------------------------------------
//- Method Declarion
//---------------------------------------------------------------------
--%>

<%--
//---------------------------------------------------------------------
//- Logic Section
//---------------------------------------------------------------------
--%>
<%

   	// obtain the resource bundle for display
	CommandContext cmdContextLocale = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   	Locale jLocale 		= cmdContextLocale.getLocale();
   	Integer langId		= cmdContextLocale.getLanguageId();
   	String storeId 	= cmdContextLocale.getStoreId().toString();
   	String currency		= cmdContextLocale.getCurrency();
   	Hashtable ppcLabels 	= (Hashtable)ResourceDirectory.lookup("edp.ppcLabels", jLocale);	

	JSPHelper jspHelper 	= new JSPHelper(request);	
	String piId 	= request.getParameter("piId");

	// get standard list parameters
	String xmlFile 	= "edp.ppcListPaymentsForPI";//jspHelper.getParameter("XMLFile");

	PPCListPaymentsForPIDataBean paymentsList	= new PPCListPaymentsForPIDataBean();	
	paymentsList.setPIId(piId);
	
	com.ibm.commerce.beans.DataBeanManager.activate(paymentsList, request);	
	//Add refund without return logic
	//Get isDependentCreditRequired configuration point value
	boolean isdependent = true;
	if(paymentsList.getListSize() > 0){
	PaymentInstructionData paymentInstruction = EDPServices.getServices().getOmfAccessor().getOMF().findPaymentInstructionByBackendId(piId);
    //get payment method name
    String method = paymentInstruction.getPaymentMethod();
    PaymentGroupConfiguration paymentGroupConfiguration = ConfigurationService
             .getPaymentGroupConfiguration(paymentInstruction.getPaymentConfigurationGroupId());  
    PaymentMethodConfigurations configurations = paymentGroupConfiguration.getPaymentMethodConfigurations(); 
    PaymentMappings mappings = paymentGroupConfiguration.getMappings();
    String configurationName = "";
    //get configuration name
    for(int i=0; i < mappings.getMappingCount();i++){
         String methodName = mappings.getMapping(i).getPaymentMethod();
         if(method.equals(methodName)){
             configurationName = mappings.getMapping(i).getPaymentConfiguration();
            break;
          }
    }
    //set isdependent value
    for(int i =0;i < configurations.getPaymentMethodConfigurationCount();i++){
        PaymentMethodConfiguration configuration = configurations.getPaymentMethodConfiguration(i);
       if(configuration.getName().equals(configurationName)){
           if(!configuration.isDependentCreditRequired())
               isdependent = false;
           break;
        }
    }
	}//End
	
%>
<html lang="en">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" /> 
<title><%= ppcLabels.get("title") %></title>

<script src="/wcs/javascript/tools/common/Util.js"></script>
<script src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" type="text/javascript">

//---------------------------------------------------------------------
//  Required javascript function for dynamic list
//---------------------------------------------------------------------
    function onLoad()
    {
      parent.loadFrames()
    }

	function getResultsSize() {
		return <%=paymentsList.getPaymentsList().size() %>;
	}
//---------------------------------------------------------------------
//  user defined javascript functions 
//---------------------------------------------------------------------

    function editPayment(){

	
		var tokens = parent.getSelected().split(",");
		var paymentId = tokens[0];
		var i = paymentId.indexOf("#");	
		
		paymentId = paymentId.substring(0,i);
		
        var url="/webapp/wcs/tools/servlet/WizardView?XMLFile=edp.ppcEditPaymentWizard";
        
        url += "&paymentId=" + paymentId;  
        
        if (top.setContent)
        {
        
         	top.setContent("<%= UIUtil.toHTML((String)ppcLabels.get("editPendingPayment")) %>", url, true);

      	}else{
        	parent.location.replace(url);
      	}
      
    }
    //updated in refund without return case
    function checkButton(){
    	//parent.refreshButtons();
    	var flag = "false";
    	<%
    	  if(isdependent){
    	%>
    	    flag = "true"  <%}%>
    	var tokens = parent.getSelected().split(",");
		var paymentId = tokens[0];
		if(tokens.length == 1){
		  if(paymentId.indexOf("Y")>0 ){			
			enableButton(parent.buttons.buttonForm.editButtonButton);
			disableButton(parent.buttons.buttonForm.creditButtonButton);
		  }else{	
			disableButton(parent.buttons.buttonForm.editButtonButton);
			if(paymentId.indexOf("C")>0 && flag == "true"){
			   enableButton(parent.buttons.buttonForm.creditButtonButton);
			}  
			else
			   disableButton(parent.buttons.buttonForm.creditButtonButton); 						
		  }
		}
		
    } 
    
 	function disableButton(b) {
		if (defined(b)) {
			b.disabled=true;
			b.className='disabled';
			b.id='disabled';
		}
	}

	// code for disbling the button
	function enableButton(b) {
		if (defined(b)) {
			b.disabled=false;
			b.className='enabled';
			b.id='enabled';
		}
	}   
	
	function selectAllButtons() {
       		parent.selectDeselectAll();
       		checkButton();
	}
	
	//add for refund without return 
	//the function will be executed after click credit button
	function dependentCredit(){


		var tokens = parent.getSelected().split(",");
		var paymentId = tokens[0];
		var i = paymentId.indexOf("#");	

		paymentId = paymentId.substring(0,i);

        var url="/webapp/wcs/tools/servlet/WizardView?XMLFile=edp.ppcCreateCreditWizard";

        url += "&paymentId=" + paymentId;  

        if (top.setContent)
        {

         	top.setContent("<%= UIUtil.toHTML((String)ppcLabels.get("creditAgainstPayment")) %>", url, true);

      	}else{
        	parent.location.replace(url);
      	}

    }
</script>
</head>

<body onload="onLoad()" class="content">
<!--JSP File name :ppcListPaymentsForPI.jsp -->
<%
	int startIndex 	= Integer.parseInt(jspHelper.getParameter("startindex"));
	int listSize 	= Integer.parseInt(jspHelper.getParameter("listsize"));
	int endIndex	= startIndex + listSize;
	int rowselect 	= 1;
	int totalsize	= paymentsList.getPaymentsList().size();
	int totalpage	= totalsize / listSize;

	int actualSize = listSize;
	if (totalsize < listSize) {
		actualSize = totalsize;
	}
%>
<%= comm.addControlPanel(xmlFile, totalpage, totalsize, jLocale) %>

<form name='ppcListPaymentsForPI'>
	<%= comm.startDlistTable("PaymentListTableSummary") %>
	<%= comm.startDlistRowHeading() %>
	<%= comm.addDlistCheckHeading(true, "selectAllButtons()") %>
	<%= comm.addDlistColumnHeading((String)ppcLabels.get("paymentId"), null, false,null,false) %>
	<%= comm.addDlistColumnHeading((String)ppcLabels.get("state"), null, false,null,false) %>
	<%= comm.addDlistColumnHeading((String)ppcLabels.get("paymentSystemName"), null,false,null,false)%>
	<%= comm.addDlistColumnHeading((String)ppcLabels.get("avsCommonCode"),null, false,null,false) %>
	<%= comm.addDlistColumnHeading((String)ppcLabels.get("expectedAmount"), null, false,null,false) %>
	<%= comm.addDlistColumnHeading((String)ppcLabels.get("approvedAmount"), null, false,null,false) %>
	<%= comm.addDlistColumnHeading((String)ppcLabels.get("approvingAmount"), null, false,null,false) %>
	<%= comm.addDlistColumnHeading((String)ppcLabels.get("depositedAmount"), null, false,null,false) %>
	<%= comm.addDlistColumnHeading((String)ppcLabels.get("depositingAmount"), null, false,null,false) %>
	<%= comm.addDlistColumnHeading((String)ppcLabels.get("reversingApprovedAmount"),null, false,null,false) %>
	<%= comm.addDlistColumnHeading((String)ppcLabels.get("reversingDepositedAmount"),null, false,null,false) %>
	<!--add for refund without return case when dependant credit, credited and crediting columns will be displayed in payment table -->
	<% if(isdependent){ %>
	<%= comm.addDlistColumnHeading((String)ppcLabels.get("creditingAmount"),null, false,null,false) %>
	<%= comm.addDlistColumnHeading((String)ppcLabels.get("creditedAmount"),null, false,null,false) %>
	<%} %>
	<%= comm.addDlistColumnHeading((String)ppcLabels.get("timeExpired"),null,false,null,false)%>
	<%= comm.addDlistColumnHeading((String)ppcLabels.get("timeCreated"),null,false,null,false)%>
	<%= comm.addDlistColumnHeading((String)ppcLabels.get("timeUpdated"),null,false,null,false)%>
	<%= comm.endDlistRow() %>
	
	<%
	if (endIndex > paymentsList.getListSize()) {
		endIndex = paymentsList.getListSize();
	}

	
	// TABLE CONTENT
	StringBuffer aPaymentstrBuffer	=	null;
	StringBuffer aStrBuffer = null;
	
	DateFormat df = DateFormat.getDateTimeInstance();
	String timeExpired = "";
	for (int i = startIndex; i<endIndex; i++) {
	if(paymentsList.getPaymentListData(i).getTimeExpired()==0){
		timeExpired="-";
	}else{
		timeExpired = df.format(new Date(paymentsList.getPaymentListData(i).getTimeExpired()));	
	}
	String timeCreated = df.format(new Date(paymentsList.getPaymentListData(i).getTimeCreated()));
	String timeUpdated = df.format(new Date(paymentsList.getPaymentListData(i).getTimeUpdated()));
	int state =paymentsList.getPaymentListData(i).getState();
	String statue = (String)ppcLabels.get(converterStateOfPayment(state));
	
	String paySysName = paymentsList.getPaymentListData(i).getPaymentInstruction().getPaymentSystemName();
	
	BigDecimal expectedAmount = paymentsList.getPaymentListData(i).getExpectedAmount();
	BigDecimal approvedAmount = paymentsList.getPaymentListData(i).getApprovedAmount();
	BigDecimal approvingAmount = paymentsList.getPaymentListData(i).getApprovingAmount();
	BigDecimal depositedAmount = paymentsList.getPaymentListData(i).getDepositedAmount();
	BigDecimal depositingAmount = paymentsList.getPaymentListData(i).getDepositingAmount();
	BigDecimal reversingApprovedAmount = paymentsList.getPaymentListData(i).getReversingApprovedAmount();
	BigDecimal reversingDepositedAmount = paymentsList.getPaymentListData(i).getReversingDepositedAmount();

	
	String strexpectedAmount = getFormattedAmount(expectedAmount,currency,langId,storeId);
	String strapprovedAmount = getFormattedAmount(approvedAmount,currency,langId,storeId);
	String strapprovingAmount = getFormattedAmount(approvingAmount,currency,langId,storeId);
	String strdepositedAmount = getFormattedAmount(depositedAmount,currency,langId,storeId);
	String strdepositingAmount = getFormattedAmount(depositingAmount,currency,langId,storeId);
	String strreversingApprovedAmount = getFormattedAmount(reversingApprovedAmount,currency,langId,storeId);
	String strreversingDepositedAmount = getFormattedAmount(reversingDepositedAmount,currency,langId,storeId);
	
	
	PPCGetPaymentDataBean paymentDataBean	= new PPCGetPaymentDataBean();	
	paymentDataBean.setPaymentId(paymentsList.getPaymentListData(i).getId());
	//active data bean
	com.ibm.commerce.beans.DataBeanManager.activate(paymentDataBean, request);
	Payment payment = paymentDataBean.getPayment();	
    BigDecimal creditingAmount = payment.getCreditingAmount();
    BigDecimal creditedAmount = payment.getCreditedAmount();
	String strCreditingAmount = getFormattedAmount(creditingAmount,currency,langId,storeId);	
	String strCreditedAmount = getFormattedAmount(creditedAmount,currency,langId,storeId);
	String strAvscode = converterAVSCode(paymentsList.getPaymentListData(i).getAvsCommonCode());
	
	strAvscode = (String)ppcLabels.get(strAvscode); 
	%>
	
		<%= comm.startDlistRow(rowselect) %>
			<%
			
				if( (approvingAmount.compareTo(PPCConstants.ZERO_AMOUNT) > 0
					||depositingAmount.compareTo(PPCConstants.ZERO_AMOUNT) > 0
					||reversingApprovedAmount.compareTo(PPCConstants.ZERO_AMOUNT) > 0
					||reversingDepositedAmount.compareTo(PPCConstants.ZERO_AMOUNT) > 0)&& (state!=5) ){
			%>
					<%= comm.addDlistCheck(paymentsList.getPaymentListData(i).getId()+"#Y", "parent.setChecked();checkButton()") %>
			<!--updated for refund without return case when dependant credit.-->
			<%		
				}else{
			      if(state!=5){
			%>		
			         <%= comm.addDlistCheck(paymentsList.getPaymentListData(i).getId()+"#NC", "parent.setChecked();checkButton()") %>
				  <%}else { %>
					<%= comm.addDlistCheck(paymentsList.getPaymentListData(i).getId()+"#N", "parent.setChecked();checkButton()") %>
				  <%}%>
			<%
				}
			%>			
			<%= comm.addDlistColumn(paymentsList.getPaymentListData(i).getId(), "none") %>
			<%= comm.addDlistColumn(statue, "none", "white-space: nowrap") %>
			<%= comm.addDlistColumn(paySysName, "none") %>
			<%= comm.addDlistColumn(strAvscode, "none") %>
			<%= comm.addDlistColumn(strexpectedAmount, "none") %>
			<%= comm.addDlistColumn(strapprovedAmount, "none") %>
			<%= comm.addDlistColumn(strapprovingAmount, "none") %>
			<%= comm.addDlistColumn(strdepositedAmount, "none") %>
			<%= comm.addDlistColumn(strdepositingAmount, "none") %>
			<%= comm.addDlistColumn(strreversingApprovedAmount, "none") %>
			<%= comm.addDlistColumn(strreversingDepositedAmount, "none") %>
			<!--add for refund without return case when dependant credit, credited and crediting columns will be displayed in payment table -->
			<% if(isdependent){ %>
			   <%= comm.addDlistColumn(strCreditingAmount, "none") %>
			   <%= comm.addDlistColumn(strCreditedAmount, "none") %>
			<%} %>
			<%= comm.addDlistColumn(timeExpired, "none") %>
			<%= comm.addDlistColumn(timeCreated, "none") %>
			<%= comm.addDlistColumn(timeUpdated, "none") %>
			
		<%= comm.endDlistRow() %>
	
		<% 
		if (rowselect == 1) {
			rowselect = 2;
		} else {
			rowselect = 1;
		}
	}

	%>	
	<%= comm.endDlistTable() %>

<%
	if (paymentsList.getListSize() == 0) {
%>

<p></p><p>
</p><table cellspacing="0" cellpadding="3" border="0">
<tr>
	<td colspan="7">
		<%=(String)ppcLabels.get("noPaymentToList")%>
	</td>
</tr>
</table>	
<% }
%>
</form>

<script>
   parent.afterLoads();
   parent.setResultssize(<%=totalsize%>);

</script>

</body>
</html>


