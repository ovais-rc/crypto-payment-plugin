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
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.payment.ppc.beans.*" %>
<%@ page import="com.ibm.commerce.payments.plugincontroller.PaymentInstruction" %>
<%@include file="../common/common.jsp" %>
<%@include file="../common/NumberFormat.jsp" %>


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
Hashtable ppcLabels =
	(Hashtable) ResourceDirectory.lookup("edp.ppcLabels", jLocale);

JSPHelper jspHelper = new JSPHelper(request);

// get standard list parameters
String xmlFile = "edp.ppcListAllPlugins";

PPCListAllPluginsDataBean pluginList = new PPCListAllPluginsDataBean();


com.ibm.commerce.beans.DataBeanManager.activate(pluginList, request);

%>
<html>
<head>
<link rel="stylesheet" href="<%=UIUtil.getCSSFile(jLocale)%>" type="text/css" />
<title><%=ppcLabels.get("title")%></title>

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
		return <%=pluginList.getPluginsList().size()%>;
	}



</script>
</head>

<body onload="onLoad()" class="content">
<!--JSP File name :ppcListAllPluings.jsp -->
<%int startIndex = Integer.parseInt(jspHelper.getParameter("startindex"));
int listSize = Integer.parseInt(jspHelper.getParameter("listsize"));
int endIndex = startIndex + listSize;
int rowselect = 1;
int totalsize = pluginList.getPluginsList().size();
int totalpage = totalsize / listSize;

//pluginList.setStartIndex((new Integer(startIndex)).toString());
//pluginList.setMaxLength((new Integer(listSize)).toString());

int actualSize = listSize;
if (totalsize < listSize) {
	actualSize = totalsize;
}
%>
<script type="text/javascript">
    function findPendingPayments(){
    	var tokens = parent.getSelected().split(",");
		var pluginName = tokens[0];

	
	
      	var url="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=edp.ppcListPendingPaymentsForPlugin&amp;cmd=ppcListPendingPaymentsForPluginView";
        
    	url += "&pluginName=" + pluginName;
          	
      if (top.setContent)
      { 	 
         top.setContent("<%=UIUtil.toHTML((String) ppcLabels.get("ListPendingPaymentTitle"))%>", url, true);

      }else{
      	
        parent.location.replace(url);
      }
    }
    
     function findPendingCredits(){
        var tokens = parent.getSelected().split(",");
		var pluginName = tokens[0];

	
	
      	var url="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=edp.ppcListPendingCreditsForPlugin&amp;cmd=ppcListPendingCreditsForPluginView";
        
    	url += "&pluginName=" + pluginName;
          	
      if (top.setContent)
      { 	 
         top.setContent("<%=UIUtil.toHTML((String) ppcLabels.get("ListPendingCreditTitle"))%>", url, true);

      }else{
      	
        parent.location.replace(url);
      }
     }

</script>
<%=comm.addControlPanel(xmlFile, totalpage, totalsize, jLocale)%>

<form name='ppcListAllPlugins'>
<%=comm.startDlistTable("CSOrderListTableSummary")%>
<%=comm.startDlistRowHeading()%>
<%=comm.addDlistCheckHeading()%>
<%=comm.addDlistColumnHeading((String)ppcLabels.get("pluginname"), null, false)%>
<%=comm.addDlistColumnHeading((String)ppcLabels.get("vendor"), null, false)%>
<%=comm.addDlistColumnHeading((String)ppcLabels.get("version"), null, false)%>

<%=comm.endDlistRow()%>

<%if (endIndex > pluginList.getListSize()) {
	endIndex = pluginList.getListSize();
}

// TABLE CONTENT
StringBuffer aPaymentstrBuffer = null;
StringBuffer aStrBuffer = null;
for (int i = startIndex; i < endIndex; i++) {
%> 
<%=comm.startDlistRow(rowselect)%>
<%=comm.addDlistCheck(pluginList.getPluginsListData(i).getName(), "none")%>
<%=comm.addDlistColumn(pluginList.getPluginsListData(i).getName(), "none")%>
<%=comm.addDlistColumn(pluginList.getPluginsListData(i).getVendor(), "none")%>
<%=comm.addDlistColumn(pluginList.getPluginsListData(i).getVersion(), "none")%>



<%=comm.endDlistRow()%>
<%if (rowselect == 1) {
	rowselect = 2;
} else {
	rowselect = 1;
}
}%> 
<%=comm.endDlistTable()%> 
<%if (pluginList.getListSize() == 0) {
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


