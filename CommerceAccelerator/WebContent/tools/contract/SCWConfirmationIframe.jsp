<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>

<%@page import="java.util.*" %> 
<%@page import="com.ibm.commerce.tools.util.*" %> 
<%@page import="com.ibm.commerce.tools.common.*" %>                          
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.tools.contract.beans.*" %> 
<%@page import="com.ibm.commerce.beans.*" %>
<%@page import="com.ibm.commerce.contract.util.*" %>
<%@page import="com.ibm.commerce.contract.helper.*" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@page import="com.ibm.commerce.common.objects.*" %>

<%@include file="../common/common.jsp" %>
<%@include file="../contract/SCWCommon.jsp" %>
<%
	try{
		// Get the Stores Web Path
		String StoresWebPath = ConfigProperties.singleton().getValue("WebServer/StoresWebPath");

    		JSPHelper jspHelper = new JSPHelper(request);	      	
   		String contract_id = jspHelper.getParameter("contractId");
   		String storeViewName = jspHelper.getParameter("storeViewName");

   		ContractDataBean contractDB = new ContractDataBean ();
   		contractDB.setContractId(contract_id);
   		DataBeanManager.activate(contractDB, request);  
   		String contractState = contractDB.getContractState();

		String store_id = null;
		String store_identifier = null;
		String store_type = null;

		StoreAccessBean storeAB = new StoreAccessBean();
		StoreAccessBean storeAB2 = null;

		Enumeration enumStoreAB = storeAB.findByCreatedByContract(new Long (contract_id));
		while (enumStoreAB.hasMoreElements()){			
			storeAB2 = (StoreAccessBean) enumStoreAB.nextElement();			
			store_id = storeAB2.getStoreEntityId();
			store_identifier = storeAB2.getIdentifier();
			store_type = storeAB2.getStoreType();
			//Only one contract per store
			break;
		}   		   		   
%>

<html>
<head>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<script>
var contractState = '<%= UIUtil.toJavaScript(contractState) %>';

function init() {

	if('<%= UIUtil.toJavaScript(store_id) %>' != 'null'){

		var store_url = "http://";
		store_url += self.location.hostname;
		store_url += '<%=UIUtil.toJavaScript(StoresWebPath)%>';
		store_url += "/";
		store_url += "<%=UIUtil.toJavaScript(storeViewName)%>?storeId=";
		store_url += encodeURI("<%= UIUtil.toJavaScript(store_id) %>");
		
		parent.storeId = "<%= UIUtil.toJavaScript(store_id) %>";
		parent.storeIdentifier = "<%= UIUtil.toJavaScript(store_identifier) %>";
		parent.store_url = store_url;		
	}

	if('<%= UIUtil.toJavaScript(store_type) %>' != 'null'){
		parent.storeType = "<%= UIUtil.toJavaScript(store_type) %>";	
	}	
	
	if(contractState == '<%= ECContractConstants.EC_STATE_ACTIVE %>' 
	   || contractState == '<%= ECContractConstants.EC_STATE_SUSPENDED %>' 
	   || contractState == '<%= ECContractConstants.EC_STATE_DEPLOY_FAILED %>'){
		parent.storeCreationStatus = contractState;
		parent.display();					
	}else{  // still in progress
		setTimeout("parent.checkStatus();", 5000);
	}
}

</script>
</head>
<body onload="init()" class="content">
</body>
</html>
<%
	}catch(Exception e){ %>
	<script language="JavaScript">
		document.URL="/webapp/wcs/tools/servlet/SCWErrorView";
	
</script>
	<% }
%>

