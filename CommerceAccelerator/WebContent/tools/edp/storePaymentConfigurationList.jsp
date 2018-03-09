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
	(Hashtable) ResourceDirectory.lookup("edp.configurationLabels", jLocale);
JSPHelper jspHelper 	= new JSPHelper(request);
// get standard list parameters


StorePaymentConfigurationListDataBean configListDB = new StorePaymentConfigurationListDataBean();
String methodType = request.getParameter("methodType");
configListDB.setMethodType(methodType);

String xmlFile="";
if(methodType.equals("payment")){

   xmlFile = "edp.storePaymentConfigurationList";
}else{
   xmlFile = "edp.storeRefundConfigurationList";
}
com.ibm.commerce.beans.DataBeanManager.activate(configListDB, request);


	String submitfinishMsg = "";
	
	if(jspHelper.getParameter("SubmitFinishMessage")!=null){
		
		submitfinishMsg = jspHelper.getParameter("SubmitFinishMessage");
			
	}
		
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
	var finMsg = '<%=submitfinishMsg%>';
    function onLoad()
    {
    	
      if(finMsg!=null && finMsg !='' && top.getData("hideDeleteAlert")=="no"){
      	alertDialog(convertFromTextToHTML(finMsg));
      	top.saveData("yes","hideDeleteAlert");	
      }
      parent.loadFrames();
    }

	function getResultsSize() {
		return <%=configListDB.getListSize()%>;
	}



</script>
</head>

<body onload="onLoad()" class="content">
<!--JSP File name :ppcListAllPluings.jsp -->
<%int startIndex = Integer.parseInt(jspHelper.getParameter("startindex"));
int listSize = Integer.parseInt(jspHelper.getParameter("listsize"));
int endIndex = startIndex + listSize;
int rowselect = 1;
int totalsize = configListDB.getListSize();
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
		
      	var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=edp.storePaymentConfigurationAdd";
      url+="&action=new&methodType="+methodType;     	
      if (top.setContent)
      { 	 
         top.setContent("<%=UIUtil.toHTML((String) labels.get("newStoreConfiguration"))%>", url, true);

      }else{
      	
        parent.location.replace(url);
      }
    }
    
  function deleteAction(){
 	var tokens = parent.getSelected().split(",");
	var paymentMethodName = tokens[0]; 
       if ( confirmDialog('<%= UIUtil.toJavaScript((String)labels.get("configurationRemoveConfirm")) %>') ) {
              
           var redirectURL='/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=edp.storePaymentConfigurationList&cmd=storePaymentConfigurationListView&methodType='+ methodType;
           var url = top.getWebappPath() + 'StorePaymentConfigurationDelete?methodType='+methodType+'&paymentMethodName='+paymentMethodName;
           url += '&URL='+redirectURL;  
           //top.setContent("", url, true);
           top.saveData("no","hideDeleteAlert");
		   parent.location.replace(url);
		  
       }
     
    }
</script>

<%=comm.addControlPanel(xmlFile, totalpage, totalsize, jLocale)%>

<form name='StorePaymentConfiguration'>
<%=comm.startDlistTable("paymentConfiguration")%>
<%=comm.startDlistRowHeading()%>
<%=comm.addDlistCheckHeading()%>
<%=comm.addDlistColumnHeading((String)labels.get("paymentMethodName"), null, false)%>
<%=comm.addDlistColumnHeading((String)labels.get("paymentConfigurationId"), null, false)%>

<%=comm.endDlistRow()%>

<%if (endIndex > configListDB.getListSize()) {
	endIndex = configListDB.getListSize();
}

// TABLE CONTENT
StringBuffer aPaymentstrBuffer = null;
StringBuffer aStrBuffer = null;
for (int i = startIndex; i < endIndex; i++) {
%> 
<%=comm.startDlistRow(rowselect)%>
<%=comm.addDlistCheck(configListDB.getPloicyName(i), "none")%>
<%=comm.addDlistColumn(configListDB.getPloicyName(i), "none")%>
<%=comm.addDlistColumn(configListDB.getConfigurationId(i), "none")%>

<%=comm.endDlistRow()%>
<%if (rowselect == 1) {
	rowselect = 2;
} else {
	rowselect = 1;
}
}%> 
<%=comm.endDlistTable()%> 
<%if (configListDB.getListSize() == 0) {
%>

<p></p>
<p></p>
<table cellspacing="0" cellpadding="3" border="0">
	<tr>
		<td colspan="7">		
		<%
		if(methodType.equals("payment")){
			out.print((String)labels.get("noPaymentConfigurationsToList"));
   	
		}else{
  			out.print((String)labels.get("noRefundConfigurationsToList"));
		}
%>
		</td>
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


