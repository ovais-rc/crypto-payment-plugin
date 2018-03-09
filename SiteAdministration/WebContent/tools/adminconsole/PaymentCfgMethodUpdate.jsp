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
<%@ page import="com.ibm.commerce.payment.config.beans.AvailablePaymentCfgListDataBean" %>
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
Hashtable labels = (Hashtable) ResourceDirectory.lookup("adminconsole.paymentConfigurationNLS", jLocale);
JSPHelper jspHelper = new JSPHelper(request);
String action = request.getParameter("action");
String configId = request.getParameter("configId");
String methodType = request.getParameter("methodType");
String configMethod="";
// get standard list parameters
if(action.equals("new")){
	

}else if(action.equals("update")){
	 
	PaymentConfigMethodDataBean configMethodBean = new PaymentConfigMethodDataBean(); 
	configMethodBean.setConfigId(configId);
	configMethodBean.setMethodType(methodType);
	com.ibm.commerce.beans.DataBeanManager.activate(configMethodBean, request);
	configMethod = configMethodBean.getMethodName();
}

AvailablePaymentCfgListDataBean availabelCfgBean = new AvailablePaymentCfgListDataBean(); 
availabelCfgBean.setMethodType(methodType);
com.ibm.commerce.beans.DataBeanManager.activate(availabelCfgBean, request);
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
function replace(fromList,toList) {

  for(var i=0; i<fromList.options.length; i++) {
    if(fromList.options[i].selected && fromList.options[i].value != "") {
       var no = new Option();
       no.value = fromList.options[i].value;
       no.text = fromList.options[i].text;
       toList.options[toList.options.length] = no;
    }
  }
  
  for(var i=fromList.options.length-1; i>=0; i--) {
    if(fromList.options[i].selected) {
    	if(toList.length==1){
    		fromList.options[i]=null;
    	}else if(toList.length==2){

    	  	var no = new Option();
       		no.value = toList.options[0].value;
       		no.text = toList.options[0].text;
       		fromList.options[i] = no;
       		
       		toList.options[0]=null;
       		
    		
    	}
    }
  }
  
  
  // Refresh to correct for bug in IE5.5 in list box
  // If more than the list box's displayable contents are moved, a phantom
  // line appears.  This refresh corrects the problem.
  for (var i=fromList.options.length-1; i>=0; i--) {
    if(fromList.options.length!=0) {
      fromList.options[i].selected = true;
    }
  }
  for (var i=fromList.options.length-1; i>=0; i--) {
    if(fromList.options.length!=0) {
      fromList.options[i].selected = false;
    }
  }
}

function addToSelectedCollateral() {
	replace(document.configMethodForm.methodSelected, document.configMethodForm.methodAvailable);
    updateSloshBuckets(document.configMethodForm.methodSelected, document.configMethodForm.addToSloshBucketButton, document.configMethodForm.methodAvailable, document.configMethodForm.removeFromSloshBucketButton);
    
}

function removeFromSelectedCollateral() {
   move(document.configMethodForm.methodAvailable, document.configMethodForm.methodSelected);
   updateSloshBuckets(document.configMethodForm.methodAvailable, document.configMethodForm.removeFromSloshBucketButton, document.configMethodForm.methodSelected, document.configMethodForm.addToSloshBucketButton);
}
	
	function loadPanelData () {
		parent.setContentFrameLoaded(true);
		initializeSloshBuckets(document.configMethodForm.methodSelected, document.configMethodForm.removeFromSloshBucketButton, document.configMethodForm.methodAvailable, document.configMethodForm.addToSloshBucketButton);
	}
	function validatePanelData () {
	
		return true;
	}
	function savePanelData(){
	 	parent.put("action","<%=UIUtil.toJavaScript(action)%>");
	 	parent.put("methodType","<%=UIUtil.toJavaScript(methodType)%>");
		parent.put("configId",configMethodForm.configId.value);
		parent.put("methodName",configMethodForm.methodAvailable.options[0].value);
	}
</script>
</head>

<body onload="loadPanelData()" class="content">
<!--JSP File name :ppcListAllPluings.jsp -->
<form name="configMethodForm">
<table>
    <tbody>
    <tr>
    <td colspan="3">
    <label for="configId">Payment Configuration Id</label><br/>
    <input type="text" id="configId" <%if(action.equals("update")){ %> value="<%=UIUtil.toHTML(configId)%>" <%}else{%>value=""<%}%>/>
    <br/>
    <br/>
    </td>
    </tr>
	
		<tr>
			<td valign="bottom" class="selectWidth">
			<label for="methodSelected1"><%=UIUtil.toHTML((String) labels.get("availableMethods"))%></label><br/>
			<select	name="methodSelected" class='selectWidth' size='10'  id="methodSelected1"
				onchange="updateSloshBuckets(this, document.configMethodForm.addToSloshBucketButton, document.configMethodForm.methodAvailable, document.configMethodForm.removeFromSloshBucketButton);">
<%
     for (int j = 0; j < availabelCfgBean.getListSize() ; j++)
     {
     	if(!(action.equals("update") && availabelCfgBean.getConfigurationId(j).equals(configMethod)))
     	{
%>
     <option value="<%= availabelCfgBean.getConfigurationId(j) %>"><%= availabelCfgBean.getConfigurationId(j) %></option>
<%
		}
     }
%>
			</select></td>
			<td width=150px align="center">
			<br/>
			
			<input type="button" name="addToSloshBucketButton"
				value="add" style="width: 120px"
				onclick="addToSelectedCollateral();"/><br/>
			<input type="button" name="removeFromSloshBucketButton"
				value="remove" style="width: 120px"
				onclick="removeFromSelectedCollateral();"/><br/>
			</td>
			<td valign="bottom" class="selectWidth">
			<label for="methodAvailable1"><%=UIUtil.toHTML((String) labels.get("selectedMethods"))%></label><br/>
			<select	name="methodAvailable" class='selectWidth' size='10' id="methodAvailable1" 
				onchange="updateSloshBuckets(this, document.configMethodForm.removeFromSloshBucketButton, document.configMethodForm.methodSelected, document.configMethodForm.addToSloshBucketButton);">
<%
     if(action.equals("update"))
     {
%>
     <option value="<%= configMethod %>"><%= configMethod %></option>
<%
     }
%>
			</select></td>
		</tr>
	</tbody>
</table>
</form>
</body>
</html>
