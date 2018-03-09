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

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

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
<%@ page import="com.ibm.commerce.ras.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.payment.config.beans.PaymentConfigurationListDataBean" %>

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
CommandContext cmdContextLocale =
	(CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();
Integer langId = cmdContextLocale.getLanguageId();
Integer storeId = cmdContextLocale.getStoreId();
String currency = cmdContextLocale.getCurrency();
Hashtable labels =
	(Hashtable) ResourceDirectory.lookup("adminconsole.paymentConfigurationNLS", jLocale);
JSPHelper jspHelper 	= new JSPHelper(request);
// get standard list parameters
String xmlFile = "adminconsole.paymentConfigurationList";

PaymentConfigurationListDataBean configList = new PaymentConfigurationListDataBean();
String methodType = request.getParameter("methodType");
configList.setMethodType(methodType);
com.ibm.commerce.beans.DataBeanManager.activate(configList, request);

%>
<html>
<head>
<link rel="stylesheet" href="<%=UIUtil.getCSSFile(jLocale)%>" type="text/css" />
<title><%=labels.get("title")%></title>

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
		return <%=configList.getListSize()%>;
	}



</script>
</head>

<body onload="onLoad()" class="content">
<!--JSP File name :ppcListAllPluings.jsp -->
<%int startIndex = Integer.parseInt(jspHelper.getParameter("startindex"));
int listSize = Integer.parseInt(jspHelper.getParameter("listsize"));
int endIndex = startIndex + listSize;
int rowselect = 1;
int totalsize = configList.getListSize();
int totalpage = totalsize / listSize;

//pluginList.setStartIndex((new Integer(startIndex)).toString());
//pluginList.setMaxLength((new Integer(listSize)).toString());

int actualSize = listSize;
if (totalsize < listSize) {
	actualSize = totalsize;
}
%>
<script type="text/javascript">
	var methodType = "<%=UIUtil.toJavaScript(methodType)%>";
	
    function newAction(){
		
      	var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=adminconsole.paymentCfgMethodUpdate";
      url+="&action=new&methodType="+methodType;     	
      if (top.setContent)
      {
         top.setContent("<%=UIUtil.toHTML((String) labels.get("newConfiguration"))%>", url, true);

      }else{
      	
        parent.location.replace(url);
      }
    }
 function updateAction(){
 	var tokens = parent.getSelected().split(",");
	var configId = tokens[0]; 
    var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=adminconsole.paymentCfgMethodUpdate";
        
    	url += "&action=update&configId=" +configId+"&methodType="+methodType;
      
      if (top.setContent)
      {
         top.setContent("<%=UIUtil.toHTML((String) labels.get("changeConfiguration"))%>", url, true);

      }else{
      	
        parent.location.replace(url);
      }
    }
    
  function deleteAction(){
 	var tokens = parent.getSelected().split(",");
	var configId = tokens[0]; 

       if ( confirmDialog('<%= UIUtil.toJavaScript((String)labels.get("configurationRemoveConfirm")) %>') ) {
              
           <% // only one can be removed at a time %>
           var url = top.getWebappPath() + 'PaymentConfigurationDelete?URL=MsgMessagingSystemResponseView&' +"action=delete&configId="+configId+"&methodType="+methodType;
               
           top.setContent("", url, true);

       }        
    }
</script>
<%=comm.addControlPanel(xmlFile, totalpage, totalsize, jLocale)%>

<form name='PaymentConfigList'>
<%=comm.startDlistTable("paymentConfiguration")%>
<%=comm.startDlistRowHeading()%>
<%=comm.addDlistCheckHeading()%>
<%=comm.addDlistColumnHeading((String)labels.get("paymentConfigurationId"), null, false)%>
<%if(methodType.equals("payment")){%>
<%=comm.addDlistColumnHeading((String)labels.get("paymentMethodName"), null, false)%>
<%}else{%>
<%=comm.addDlistColumnHeading((String)labels.get("refundMethodName"), null, false)%>
<%}%>
<%=comm.endDlistRow()%>

<%if (endIndex > configList.getListSize()) {
	endIndex = configList.getListSize();
}

// TABLE CONTENT
StringBuffer aPaymentstrBuffer = null;
StringBuffer aStrBuffer = null;
for (int i = startIndex; i < endIndex; i++) {
%> 
<%=comm.startDlistRow(rowselect)%>
<%=comm.addDlistCheck(configList.getConfigurationId(i), "none")%>
<%=comm.addDlistColumn(configList.getConfigurationId(i), "none")%>
<%=comm.addDlistColumn(configList.getConfigurationMethodName(i), "none")%>
<%=comm.endDlistRow()%>
<%if (rowselect == 1) {
	rowselect = 2;
} else {
	rowselect = 1;
}
}%> 
<%=comm.endDlistTable()%> 
<%if (configList.getListSize() == 0) {
%>

<p></p>
<p></p>
<table cellspacing="0" cellpadding="3" border="0">
	<tr>
		<td colspan="7"><%=(String)labels.get("noPaymentConfigurationsToList")%></td>
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


