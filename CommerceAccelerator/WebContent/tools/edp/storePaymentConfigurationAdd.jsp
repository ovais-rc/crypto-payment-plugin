<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* 5724-A18
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>

<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>
<%@ page import="com.ibm.commerce.ras.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.payment.config.beans.StorePaymentConfigurationListDataBean" %>
<%@ page import="com.ibm.commerce.payment.config.beans.PaymentConfigurationListDataBean" %>
<%@ page import="com.ibm.commerce.payment.config.beans.PaymentConfigMethodDataBean" %>
<%@include file="../common/common.jsp" %>

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
CommandContext cmdContextLocale = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();
Integer langId = cmdContextLocale.getLanguageId();
Integer storeId = cmdContextLocale.getStoreId();
String currency = cmdContextLocale.getCurrency();
Hashtable labels = (Hashtable) ResourceDirectory.lookup("edp.configurationLabels", jLocale);
JSPHelper jspHelper = new JSPHelper(request);
String action = request.getParameter("action");
String configId = request.getParameter("configId");
String methodType = request.getParameter("methodType");
String configMethod="";
// get standard list parameters


PaymentConfigurationListDataBean configListBean = new PaymentConfigurationListDataBean(); 
configListBean.setMethodType(methodType);
com.ibm.commerce.beans.DataBeanManager.activate(configListBean, request);


StorePaymentConfigurationListDataBean storeConfigListBean = new StorePaymentConfigurationListDataBean(); 
storeConfigListBean.setMethodType(methodType);
com.ibm.commerce.beans.DataBeanManager.activate(storeConfigListBean, request);

%>
<html>
<head>
<link rel="stylesheet" href="<%=UIUtil.getCSSFile(jLocale)%>"
	type="text/css" />
<title><%=labels.get("title")%></title>

<script src="/wcs/javascript/tools/common/Util.js"></script>
<script src="/wcs/javascript/tools/common/SwapList.js"></script>
<script language="JavaScript" type="text/javascript">
//---------------------------------------------------------------------
//  Required javascript function for dynamic list
//---------------------------------------------------------------------
	function loadPanelData () {
		parent.setContentFrameLoaded(true);		
	}
	function validatePanelData () {
	
		return true;
	}
	
	function savePanelData(){
	 	parent.put("action","<%=UIUtil.toJavaScript(action)%>");
	 	parent.put("methodType","<%=UIUtil.toJavaScript(methodType)%>");		 	
		parent.put("configId",configMethodForm.methodSelected.options[configMethodForm.methodSelected.selectedIndex].value);
	}
</script>
</head>

<body onload="loadPanelData()" class="content">
<!--JSP File name :ppcListAllPluings.jsp -->
<form name="configMethodForm">
<table>
<tbody>
<tr>
<td class="h1" height="40" valign="bottom" style="padding-left: 25px; padding-bottom: 20px;">
<%
		if(methodType.equals("payment")){
    		out.print(UIUtil.toHTML((String) labels.get("newStorePaymentConfiguration")));
   
    	}else{
    		out.print(UIUtil.toHTML((String) labels.get("newStoreRefundConfiguration")));
    	}
    	
    	%>
    	</td>
</tr>	
		<tr>			
			<td valign="bottom" class="selectWidth" style="padding-left: 25px; padding-bottom: 20px;">
			<label for="methodSelected1">
			<%
    		if(methodType.equals("payment")){
    			out.print(UIUtil.toHTML((String) labels.get("availablePaymentMethods")));   
    		}else{
    			out.print(UIUtil.toHTML((String) labels.get("availableRefundMethods")));
   			}
    		%>
			</label><br/>
			<select	name="methodSelected" class='selectWidth' size='10'  id="methodSelected1">
<%
     for (int j = 0; j < configListBean.getListSize() ; j++)
     {
     	boolean found=false;
		for(int i=0;i<storeConfigListBean.getListSize() ; i++){
			
			if(storeConfigListBean.getConfigurationId(i).equals(configListBean.getConfigurationId(j))){
			
				found = true;
				continue;
			}
		}
		if(!found){
%>
     <option value="<%= configListBean.getConfigurationId(j) %>"><%= configListBean.getConfigurationId(j) %></option>
<%
			
		}
     }
%>
			</select></td>


		</tr>
	</tbody>
</table>
</form>
</body>
</html>
