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
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %> 
<%@ page import="com.ibm.commerce.payment.ppc.beans.*" %>
<%@ page import="com.ibm.commerce.payments.plugincontroller.Payment" %>
<%@include file="../common/common.jsp" %>
<%@include file="../common/NumberFormat.jsp" %>
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
	String pluginName 	= request.getParameter("pluginName");

	// get standard list parameters
	String xmlFile 	= "edp.ppcListPendingPaymentsForPlugin";//jspHelper.getParameter("XMLFile");

	PPCListPendingPaymentsForPluginDataBean paymentsList	= new PPCListPendingPaymentsForPluginDataBean();	
		
	if(pluginName!=null && !pluginName.equals("")){
		paymentsList.setPluginName(pluginName);
		
	}
	
	paymentsList.setStoreId(storeId);
	com.ibm.commerce.beans.DataBeanManager.activate(paymentsList, request);
	
	PPCListAllPluginsDataBean pluginList = new PPCListAllPluginsDataBean();

	com.ibm.commerce.beans.DataBeanManager.activate(pluginList, request);

%>
<html>
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
      parent.loadFrames();      
      
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
		
		
        var url="/webapp/wcs/tools/servlet/WizardView?XMLFile=edp.ppcEditPaymentWizard";
        
        url += "&paymentId=" + paymentId;
        
        if (top.setContent)
        {        
         	top.setContent("<%= UIUtil.toHTML((String)ppcLabels.get("editPaymentPanel")) %>", url, true);
      	}else{
        	parent.location.replace(url);
      	}
      
    } 
	function listBySysName(){
				
		var url="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=edp.ppcListPendingPaymentsForPlugin&amp;cmd=ppcListPendingPaymentsForPluginView";
        
        url += "&pluginName=" + eval("paymentSystemName").value;       
       
        parent.location.replace(url); 
		
	}
	
//---------------------------------------------------------------------
//  GUI functions  onload="onLoad()"
//---------------------------------------------------------------------



</script>
</head>

<body onload="onLoad()" class="content">
<!--JSP File name :ppcListPendingPaymentsForPlugin.jsp -->
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
<table border="0" cellpadding="0" cellspacing="0" id="WC_InitiativeList_Table_1">
	<tr>
		<td>
			<label for="paymentSystemName"><%=(String)ppcLabels.get("filterByPaymentSystem")%></label>
			<br />
			<select id="paymentSystemName" name="paymentSystemName" onchange="listBySysName();">
				<option value="" ><%=(String)ppcLabels.get("allPaymentSystem")%></option>
				<%for (int i=0;i<pluginList.getListSize();i++){%>
				<option value="<%=pluginList.getPluginsListData(i).getName()%>" <%if(pluginList.getPluginsListData(i).getName().equals(pluginName)){%> selected <%}%>><%=pluginList.getPluginsListData(i).getName()%></option>
				<%}%>
			</select>
		</td>
	</tr>
</table>
<form name='ppcListPendingPaymentsForPlugin'><%= comm.startDlistTable("CSOrderListTableSummary") %>

<%= comm.startDlistRowHeading() %> <%= comm.addDlistCheckHeading() %> <%= comm.addDlistColumnHeading((String)ppcLabels.get("paymentId"), null, false,"100",false) %>
<%= comm.addDlistColumnHeading((String)ppcLabels.get("state"), null, false,null,false)%>
<%= comm.addDlistColumnHeading((String)ppcLabels.get("paymentSystemName"), null,false,null,false)%>
<%= comm.addDlistColumnHeading((String)ppcLabels.get("avsCommonCode"),null,false,null,false) %>
<%= comm.addDlistColumnHeading((String)ppcLabels.get("expectedAmount"), null, false,null,false)%>

<%= comm.addDlistColumnHeading((String)ppcLabels.get("timeExpired"),null,false,null,false)%>
<%= comm.addDlistColumnHeading((String)ppcLabels.get("timeCreated"),null,false,null,false)%>
<%= comm.addDlistColumnHeading((String)ppcLabels.get("timeUpdated"),null,false,null,false)%>
<%= comm.endDlistRow() %> <%
	if (endIndex > paymentsList.getListSize()) {
		endIndex = paymentsList.getListSize();
	} 

	
	// TABLE CONTENT
	StringBuffer aPaymentstrBuffer	=	null;
	StringBuffer aStrBuffer = null;
	
	DateFormat df = DateFormat.getDateTimeInstance();

	for (int i = startIndex; i<endIndex; i++) {
	
	String timeExpired="";
	if(paymentsList.getPaymentListData(i).getTimeExpired()==0){
		timeExpired="-";
	}else{
		timeExpired = df.format(new Date(paymentsList.getPaymentListData(i).getTimeExpired()));	
	}
	
	
	String timeCreated = df.format(new Date(paymentsList.getPaymentListData(i).getTimeCreated()));
	String timeUpdated = df.format(new Date(paymentsList.getPaymentListData(i).getTimeUpdated()));
	int state =paymentsList.getPaymentListData(i).getState();
	String statue = (String)ppcLabels.get(converterStateOfPayment(state));
	
	String paySysName = paymentsList.getPaymentListData(i).getPaymentInstruction().getPaymentPluginName();
	short avsCode = paymentsList.getPaymentListData(i).getAvsCommonCode();
	BigDecimal expectedAmount = paymentsList.getPaymentListData(i).getExpectedAmount();
	
	String strexpectedAmount = getFormattedAmount(expectedAmount,currency,langId,storeId);

	String strAvscode = converterAVSCode(avsCode);
	if( avsCode!= -1){
		strAvscode = avsCode +" "+(String)ppcLabels.get(strAvscode); 
	}else{
		strAvscode = ""; 
	}
	
	%> 
	<%= comm.startDlistRow(rowselect) %> 
	<%= comm.addDlistCheck(paymentsList.getPaymentListData(i).getId(), "none") %>
    <%= comm.addDlistColumn(paymentsList.getPaymentListData(i).getId(), "none") %>
    <%= comm.addDlistColumn(statue, "none") %> 
    <%= comm.addDlistColumn(paySysName, "none") %>
    <%= comm.addDlistColumn(strAvscode, "none") %> 
    <%= comm.addDlistColumn(strexpectedAmount, "none") %>
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

	%> <%= comm.endDlistTable() %> <%
	if (paymentsList.getListSize() == 0) {
%>

<p></p>
<p></p>
<table cellspacing="0" cellpadding="3" border="0">
	<tr>
		<td colspan="7"><%=(String)ppcLabels.get("noPaymentToList")%></td>
	</tr>
</table>
<% }
%></form>

<script>
   parent.afterLoads();
   parent.setResultssize(<%=totalsize%>);
   parent.setButtonPos("0px", "57px");
</script>


</body>
</html>


