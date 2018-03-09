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
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
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
	String xmlFile 	= "edp.ppcListPendingCreditsForPlugin";//jspHelper.getParameter("XMLFile");

	PPCListPendingCreditsForPluginDataBean creditsList	= new PPCListPendingCreditsForPluginDataBean();	
	if(pluginName!=null && !pluginName.equals("")){
		creditsList.setPluginName(pluginName);
		
	}
	creditsList.setStoreId(storeId);
	com.ibm.commerce.beans.DataBeanManager.activate(creditsList, request);
	
	
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
      parent.loadFrames()
    }

	function getResultsSize() {
		return <%=creditsList.getCreditsList().size() %>;
	}
	
    function editCredit(){
		var tokens = parent.getSelected().split(",");
		var creditId = tokens[0];		
		
        var url="/webapp/wcs/tools/servlet/WizardView?XMLFile=edp.ppcEditCreditWizard";
        
        url += "&creditId=" + creditId;
          	
        if (top.setContent)
        {
        
         top.setContent("<%= UIUtil.toHTML((String)ppcLabels.get("editCreditPanel")) %>", url, true);

      }else{
        parent.location.replace(url);
      }
    } 
    
    function listBySysName(){
				
		var url="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=edp.ppcListPendingCreditsForPlugin&amp;cmd=ppcListPendingCreditsForPluginView";
        
        url += "&pluginName=" + eval("paymentSystemName").value;       
       
        parent.location.replace(url); 
		
	}
</script>
</head>

<body onload="onLoad()" class="content">
<!--JSP File name :ppcListPendingCreditForPluing.jsp -->
<%
	int startIndex 	= Integer.parseInt(jspHelper.getParameter("startindex"));
	int listSize 	= Integer.parseInt(jspHelper.getParameter("listsize"));
	int endIndex	= startIndex + listSize;
	int rowselect 	= 1;
	int totalsize	= creditsList.getCreditsList().size();
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
<form name='ppcListPendingCreditsForPlugin'>

	<%= comm.startDlistTable("CSOrderListTableSummary") %>
	<%= comm.startDlistRowHeading() %>
	<%= comm.addDlistCheckHeading() %>
	<%= comm.addDlistColumnHeading((String)ppcLabels.get("creditId"), null, false,null,false) %>
	<%= comm.addDlistColumnHeading((String)ppcLabels.get("state"), null, false,null,false) %>	
    <%= comm.addDlistColumnHeading((String)ppcLabels.get("paymentSystemName"), null,false,null,false)%>	
	<%= comm.addDlistColumnHeading((String)ppcLabels.get("expectedAmount"), null, false,null,false) %>
	<%= comm.addDlistColumnHeading((String)ppcLabels.get("creditingAmount"), null, false,null,false) %>
	<%= comm.addDlistColumnHeading((String)ppcLabels.get("creditedAmount"), null, false,null,false) %>
	<%= comm.addDlistColumnHeading((String)ppcLabels.get("reversingCreditedAmount"), null,false,null,false)%>	

	<%= comm.addDlistColumnHeading((String)ppcLabels.get("timeCreated"),null,false,null,false)%>
	<%= comm.addDlistColumnHeading((String)ppcLabels.get("timeUpdated"),null,false,null,false)%>
	<%= comm.endDlistRow() %>
	
	<%
	if (endIndex > creditsList.getListSize()) {
		endIndex = creditsList.getListSize();
	}

	
	// TABLE CONTENT
	StringBuffer aPaymentstrBuffer	=	null;
	StringBuffer aStrBuffer = null;
	
	DateFormat df = DateFormat.getDateTimeInstance();
	for (int i = startIndex; i<endIndex; i++) {
	String timeCreated = df.format(new Date(creditsList.getCreditListData(i).getTimeCreated()));
	String timeUpdated = df.format(new Date(creditsList.getCreditListData(i).getTimeUpdated()));
	int state =creditsList.getCreditListData(i).getState();
	String statue = (String)ppcLabels.get(converterStateOfCredit(state));
	String paySysName = creditsList.getCreditListData(i).getPaymentInstruction().getPaymentPluginName();
	BigDecimal expectedAmount = creditsList.getCreditListData(i).getExpectedAmount();
	BigDecimal creditingAmount = creditsList.getCreditListData(i).getCreditingAmount();
	BigDecimal creditedAmount = creditsList.getCreditListData(i).getCreditedAmount();
	BigDecimal reversingCreditedAmount = creditsList.getCreditListData(i).getReversingCreditedAmount();
	
	String strexpectedAmount = getFormattedAmount(expectedAmount,currency,langId,storeId);
	String strcreditingAmount = getFormattedAmount(creditingAmount,currency,langId,storeId);
	String strcreditedAmount = getFormattedAmount(creditedAmount,currency,langId,storeId);
	String strreversingCreditedAmount = getFormattedAmount(reversingCreditedAmount,currency,langId,storeId);
	
	%>
	
		<%= comm.startDlistRow(rowselect) %>
			<%= comm.addDlistCheck(creditsList.getCreditListData(i).getId(), "none") %>
			<%= comm.addDlistColumn(creditsList.getCreditListData(i).getId(), "none") %>
			<%= comm.addDlistColumn(statue, "none") %>
			<%= comm.addDlistColumn(paySysName, "none") %>
			<%= comm.addDlistColumn(strexpectedAmount, "none") %>
			<%= comm.addDlistColumn(strcreditingAmount, "none") %>
			<%= comm.addDlistColumn(strcreditedAmount, "none") %>
			<%= comm.addDlistColumn(strreversingCreditedAmount, "none") %>
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
	if (creditsList.getListSize() == 0) {
%>

<p></p><p>
</p><table cellspacing="0" cellpadding="3" border="0">
<tr>
	<td colspan="7">
		<%=(String)ppcLabels.get("noCreditToList")%>
	</td>
</tr>
</table>	
<% }
%>
</form>

<script>
   parent.afterLoads();
   parent.setResultssize(<%=totalsize%>);
   parent.setButtonPos("0px", "57px");
</script>

</body>
</html>


