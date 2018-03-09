


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

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


<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.*" %>
<%@ page import="com.ibm.commerce.ordermanagement.objects.*" %>
<%@ page import="com.ibm.commerce.returns.commands.ReturnConstants" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.base.objects.WCSStringConverter" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.common.beans.StoreDataBean" %>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@ page import="com.ibm.commerce.price.beans.FormattedMonetaryAmountDataBean" %>
<%@ page import="com.ibm.commerce.price.utils.MonetaryAmount" %>
<%@ page import="com.ibm.commerce.user.beans.UserRegistrationDataBean" %>
<%@ page import="com.ibm.commerce.contract.beans.ContractDataBean" %>
<%@ page import="com.ibm.commerce.tools.optools.returns.beans.CSRReturnSearchDataBean" %>
<%@include file="../common/common.jsp" %>
<%@include file="../common/NumberFormat.jsp" %>

<%
try{
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale = cmdContext.getLocale();
	Hashtable returnsNLS = (Hashtable)ResourceDirectory.lookup("returns.ReturnsNLS", jLocale);
	JSPHelper jspHelper = new JSPHelper(request);
	
	String jLanguageID = cmdContext.getLanguageId().toString();
	
	StoreDataBean store = new StoreDataBean();
	store.setStoreId(cmdContext.getStoreId().toString());
	com.ibm.commerce.beans.DataBeanManager.activate(store, request);
	boolean isB2B = store.getStoreType() != null && (store.getStoreType().equals("B2B") || store.getStoreType().equals("BRH") || store.getStoreType().equals("BMH"));
%>
<%
	Hashtable contractsRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("returns.contractRBCopy", jLocale);
	
        Hashtable 	VendorPurchaseNLS_en_US = null;
        VendorPurchaseNLS_en_US = (Hashtable)ResourceDirectory.lookup("inventory.VendorPurchaseNLS", jLocale);

	String memberId = jspHelper.getParameter("customerId");
	if (memberId == null)
		memberId = "";
	String searchReturnNumber = jspHelper.getParameter("searchReturnNumber");
	String searchOrderNumber = jspHelper.getParameter("searchOrderNumber");
	String searchCustomerLogon = jspHelper.getParameter("searchCustomerLogon");
	String searchReturnStatus = jspHelper.getParameter("searchReturnStatus");
	searchReturnStatus = UIUtil.toHTML(searchReturnStatus);

	//GK 22100
	String memberIdForCustomerInCSAContext = jspHelper.getParameter("memberIdForCustomerInCSAContext");
	memberIdForCustomerInCSAContext = UIUtil.toHTML(memberIdForCustomerInCSAContext);
	if ( memberIdForCustomerInCSAContext == null )
	   memberIdForCustomerInCSAContext = "";

	String searchContractName = "";
	if (isB2B)
		searchContractName = jspHelper.getParameter("searchContractName");
	
	String orderbyParam = jspHelper.getParameter("orderby");
	int startIndex = Integer.parseInt(jspHelper.getParameter("startindex"));
	int listSize = Integer.parseInt(jspHelper.getParameter("listsize"));
	int endIndex = 0;
	int totalSize = 0;

	Object[] rmaList;

	if ( !memberId.equals("") )
	{
		RMAListDataBean rmaListDb = new RMAListDataBean();
		rmaListDb.setMemberId(memberId);
		rmaListDb.setStoreId(cmdContext.getStoreId().toString());
		com.ibm.commerce.beans.DataBeanManager.activate(rmaListDb, request);
		rmaList = rmaListDb.getRMAList();
		
		endIndex = startIndex + listSize;
		int rmaListlength = 0;
		if (rmaList != null) {
			rmaListlength = rmaList.length;
		}
		if (endIndex > rmaListlength) {
			endIndex = rmaListlength;
		}
		totalSize = rmaListlength;
	}
	else
	{
		CSRReturnSearchDataBean searchDb = new CSRReturnSearchDataBean();
		searchDb.setCommandContext(cmdContext);
		searchDb.setReturnId(searchReturnNumber);
		searchDb.setOrderId(searchOrderNumber);
		searchDb.setCustomerLogonId(searchCustomerLogon);
		searchDb.setReturnStatus(searchReturnStatus);
		searchDb.setContractName(searchContractName);
		searchDb.setStartIndex(new Integer(startIndex));
		searchDb.setMaxLength(new Integer(listSize));
		com.ibm.commerce.beans.DataBeanManager.activate(searchDb, request);
		rmaList = searchDb.getReturnList().getSubset().toArray();
		
		startIndex = 0;
		endIndex = rmaList.length;
		totalSize = searchDb.getReturnList().getTotalSize().intValue();
	}
	
	int totalPage = totalSize;
	if (totalPage > 0)
		totalPage--;
	totalPage /= listSize;
%>

<HTML>
<HEAD>

<LINK REL="stylesheet" HREF="<%= UIUtil.getCSSFile(jLocale) %>" TYPE="text/css">
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/ConvertToXML.js"></SCRIPT>
<SCRIPT>
function init() 
{
	parent.loadFrames();
	if (parent.setContentFrameLoaded) {
		parent.setContentFrameLoaded(true);
   	}
}
function closeDialog()
{
	top.goBack();
}
function openSummary()
{
	var checkedReturnId = parent.getChecked().toString();
	top.setContent("<%= UIUtil.toJavaScript( (String)returnsNLS.get("returnSummaryTitle") ) %>", 
	               "/webapp/wcs/tools/servlet/DialogView?XMLFile=returns.returnSummaryDialog&amp;returnId="+checkedReturnId, true);
}
function openSummaryLink(checkedReturnId)
{
	top.setContent("<%= UIUtil.toJavaScript( (String)returnsNLS.get("returnSummaryTitle") ) %>", 
	               "/webapp/wcs/tools/servlet/DialogView?XMLFile=returns.returnSummaryDialog&amp;returnId="+checkedReturnId, true);
}
function openChange()
{
	var checkedReturnId = parent.getChecked().toString();
	var key = "status"+checkedReturnId;
	
	//GK 22100
	var memberIdForCustomerInCSAContext = "<%=memberIdForCustomerInCSAContext%>";
	
	if (top.getData(key, 0) == "CLO" || top.getData(key, 0) == "CAN") {
		alertDialog("<%=UIUtil.toHTML((String)returnsNLS.get("invalidSelectionForEdit"))%>");
		return;
	}
	//GK 22100
	top.setContent("<%= UIUtil.toJavaScript( (String)returnsNLS.get("editReturnNotebookTitle") ) %>", 
	               "/webapp/wcs/tools/servlet/NotebookView?XMLFile=returns.EditReturn&amp;edit=true&amp;returnId=" + checkedReturnId + "&amp;memberIdForCustomerInCSAContext=" + memberIdForCustomerInCSAContext, true);
	               
}
function openCancelReturn()
{
	var checkedReturnId = parent.getChecked().toString();
	
	if (!checkCanceledStatus(checkedReturnId)) 
		return;
	
	var checkedCustomerId = top.getData("rmaMemberId"+checkedReturnId, 0);
	var memberIdForCustomerInCSAContext = "<%=memberIdForCustomerInCSAContext%>";
	
	var CSRReturnCancelParam = new Object();
	CSRReturnCancelParam["returnId"] = checkedReturnId;
	if (memberIdForCustomerInCSAContext == "")
		CSRReturnCancelParam["customerId"] = checkedCustomerId;
	else
		CSRReturnCancelParam["customerId"] = memberIdForCustomerInCSAContext;
	
	var redirectURL = "";
	if (<%=isB2B%>)
		redirectURL = "ReturnList?ActionXMLFile=returns.returnListB2B&cmd=ReturnList&listsize=22&startindex=0";
	else
		redirectURL = "ReturnList?ActionXMLFile=returns.returnListB2C&cmd=ReturnList&listsize=22&startindex=0";

	var redirectParameters = "&customerId=" + "<%=memberId%>";
	redirectParameters = redirectParameters + "&memberIdForCustomerInCSAContext=" + "<%=memberIdForCustomerInCSAContext%>";
	redirectParameters = redirectParameters + "&searchReturnNumber=" + "<%=searchReturnNumber%>";
	redirectParameters = redirectParameters + "&searchOrderNumber=" + "<%=searchOrderNumber%>";
	redirectParameters = redirectParameters + "&searchCustomerLogon=" + "<%= UIUtil.toJavaScript((String)searchCustomerLogon)%>";
	if (<%=isB2B%>)
		redirectParameters = redirectParameters + "&searchContractName=" + "<%= UIUtil.toJavaScript((String)searchContractName)%>";
	redirectParameters = redirectParameters + "&searchReturnStatus=" + "<%=searchReturnStatus%>";

	parent.removeEntry(checkedReturnId);
	document.CSRReturnCancelForm.XML.value = generateXML(CSRReturnCancelParam,"XML",null);
	document.CSRReturnCancelForm.URL.value = redirectURL+redirectParameters;
	document.CSRReturnCancelForm.submit();
}
function openViewReceipts()
{
	var url="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=inventory.ReturnProductsList&amp;cmd=ReturnProductsListView";
	var checkedReturnId = parent.getChecked().toString();
	url += "&rmaid=" + checkedReturnId;
	top.setContent('<%=UIUtil.toJavaScript((String)VendorPurchaseNLS_en_US.get("ReturnedProductsListScreenTitle"))%>',  url, true);
}
function openApprove()
{
	var checkedReturnId = parent.getChecked().toString();
	if (!checkReturnStatus(checkedReturnId)) 
		return;
	top.setContent("<%= UIUtil.toJavaScript( (String)returnsNLS.get("approveReturnTitle") ) %>", 
	               "/webapp/wcs/tools/servlet/DialogView?XMLFile=returns.ApproveReturn&amp;RMAId="+checkedReturnId+"&amp;customerId=<%=jspHelper.getParameter("customerId")%>", true);
}

var contractData = new Object();

function getContractId(returnId)
{
        return contractData[returnId];
}
function openContract()
{
	var checkedReturnId = parent.getChecked().toString();
	var contractId = getContractId(checkedReturnId);
	
	if (contractId.length > 0) {	
		top.setContent("<%= UIUtil.toJavaScript((String)contractsRB.get("summaryBCT")) %>",
				"/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.ContractSummary&contractId=" + contractId,
				true);
	}
}
function openFind()
{
	var memberIdForCustomerInCSAContext = "<%=memberIdForCustomerInCSAContext%>";
	
	if (memberIdForCustomerInCSAContext == "") {
		top.setContent("<%= UIUtil.toJavaScript( (String)returnsNLS.get("returnSearchTitle") ) %>", 
	               "/webapp/wcs/tools/servlet/DialogView?XMLFile=returns.returnSearchDialog&memberId=<%=memberId%>", true);
	} else {
		top.goBack();
		top.setContent("<%= UIUtil.toJavaScript( (String)returnsNLS.get("returnSearchTitle") ) %>", 
	               "/webapp/wcs/tools/servlet/DialogView?XMLFile=returns.returnSearchDialog&memberId=<%=memberIdForCustomerInCSAContext%>", false);
	}
}
function checkCanceledStatus(id)
{
	var key = "status"+id;
	if ( (top.getData(key, 0) == "CAN") || (top.getData(key, 0) == "CLO") ) {
		alertDialog("<%=UIUtil.toHTML((String)returnsNLS.get("invalidSelectionForCancel"))%>");
		return false;
	}
	return true;
}
function checkReturnStatus(id)
{
	var key = "status"+id;
	if (top.getData(key, 0) != "PND") {
		alertDialog("<%=UIUtil.toHTML((String)returnsNLS.get("refundStatusNotPendingMsg"))%>");
		return false;
	}
	return true;
}
</SCRIPT>

<TITLE><%= UIUtil.toHTML((String)returnsNLS.get("returnListTitle")) %></TITLE>

</HEAD>

<BODY class="content_list" onload="init();">

<FORM NAME="CSRReturnCancelForm" METHOD="post" ACTION="CSRReturnCancel">
	<INPUT TYPE='hidden' NAME="URL" VALUE="">
	<INPUT TYPE='hidden' NAME="XML" VALUE="">
</FORM>

<%	
	String xmlfile;
	if (isB2B)
		xmlfile = "returns.returnListB2B";
	else
		xmlfile = "returns.returnListB2C";
%>
<%= comm.addControlPanel(xmlfile, totalPage, totalSize, jLocale) %>

<FORM name="ReturnListFORM">
<%= comm.startDlistTable(UIUtil.toHTML((String)returnsNLS.get("returnListTableSummary"))) %>

<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)returnsNLS.get("returnNumberHeading"),null,false, null,false) %>
<% if (isB2B) {
%>
	<%= comm.addDlistColumnHeading((String)returnsNLS.get("contractNameHeading"),null,false,null,false) %>
<% }
%>
<%= comm.addDlistColumnHeading((String)returnsNLS.get("customerLogonIDHeading"),null,false,null,false) %>
<%= comm.addDlistColumnHeading((String)returnsNLS.get("refundStatusHeading"),null,false,null,false) %>
<%= comm.addDlistColumnHeading((String)returnsNLS.get("lastUpdateHeading"),null,false,null,false) %>
<%= comm.addDlistColumnHeading((String)returnsNLS.get("totalHeading"),null,false,null,false) %>
<%= comm.endDlistRow() %>

<%
	for (int i=startIndex; i<endIndex; i++)
	{
		RMAAccessBean rma = (RMAAccessBean) rmaList[i];
		String refundStatusTextOrg = rma.getStatus();
		String refundStatusText = refundStatusTextOrg;
		if (refundStatusText.equals(new String("PRC")))
			refundStatusText = (String)returnsNLS.get("refundStatusInProcess");
		else if (refundStatusText.equals(new String("PND")))
			refundStatusText = (String)returnsNLS.get("refundStatusPending");
		else if (refundStatusText.equals(new String("APP")))
			refundStatusText = (String)returnsNLS.get("refundStatusApproved");
		else if (refundStatusText.equals(new String("EDT")))
			refundStatusText = (String)returnsNLS.get("orderStatusBeingEdited");
		else if (refundStatusText.equals(new String("CLO")))
			refundStatusText = (String)returnsNLS.get("refundStatusClosed");
		else if (refundStatusText.equals(new String("CAN")))
			refundStatusText = (String)returnsNLS.get("refundStatusCancelled");

		String lastStatusUpdate = rma.getLastUpdate();
		if (lastStatusUpdate != null) 
			lastStatusUpdate = UIUtil.toHTML(TimestampHelper.getDateFromTimestamp(WCSStringConverter.StringToTimestamp(lastStatusUpdate), jLocale));
		else
			lastStatusUpdate = UIUtil.toHTML((String)returnsNLS.get("refundUpdateNotAvailable"));
		
		String currency = rma.getCurrency();

		
		String amount = rma.getTotalCredit();
		if (amount == null || amount.equals(""))
			amount = UIUtil.toHTML((String)returnsNLS.get("totalCreditUnknown"));
		else if (currency != null && !currency.equals(""))
		{
			FormattedMonetaryAmountDataBean formattedAmount =  new FormattedMonetaryAmountDataBean(	new MonetaryAmount( rma.getTotalCreditInEntityType(), currency ), (StoreAccessBean) store, cmdContext.getLanguageId() );

			//determine if the number is negative
			//currently the getFormattedValue method chops out the negative values
	    		boolean isNegative = false;
			if ( (amount != null) && (!amount.equals("")) ) {
				if (amount.startsWith("-"))
					isNegative = true;
			}
			if (isNegative)
				amount = "-" + formattedAmount.getPrimaryFormattedPrice().getFormattedValue().toString() + " (" + currency + ")";
			else
				amount = formattedAmount.getPrimaryFormattedPrice().getFormattedValue().toString() + " (" + currency + ")";
		}
		
		String rmaMemberId = rma.getMemberId();		
		UserRegistrationDataBean userReg = new UserRegistrationDataBean();
		userReg.setUserId(rmaMemberId);
		String memberLogonId = "";
		com.ibm.commerce.beans.DataBeanManager.activate(userReg, request);
		memberLogonId = userReg.getLogonId();
		
		String contractName = "";
		String contractId = rma.getTradingId();
		if (contractId != null && !contractId.equals(""))
		{
			ContractDataBean contract = new ContractDataBean();
			contract.setInitKey_referenceNumber(contractId);
			com.ibm.commerce.beans.DataBeanManager.activate(contract, request);
			contractName = contract.getName();
			
	%>
		<%--build contract data structure so we can get the contract id given the rma id--%>
		<SCRIPT> contractData["<%=rma.getRmaId()%>"] = "<%=contractId%>"; </SCRIPT>			
	<%
		}
	%>
	<%= comm.startDlistRow(i%2+1) %>
	<%= comm.addDlistCheck(rma.getRmaId(),"parent.setChecked()") %>
	<%= comm.addDlistColumn(rma.getRmaId(),"javascript:openSummaryLink("+rma.getRmaId()+")") %>
<% if (isB2B) {
%>
	<%= comm.addDlistColumn(contractName,"none") %>
<% }
%>
	<%= comm.addDlistColumn(memberLogonId,"none") %>
	<SCRIPT>top.saveData("<%=rmaMemberId%>","rmaMemberId<%=rma.getRmaId()%>");</SCRIPT>
	<%= comm.addDlistColumn(refundStatusText,"none") %>
	<SCRIPT>top.saveData("<%=refundStatusTextOrg%>","status<%=rma.getRmaId()%>");</SCRIPT>
	<%= comm.addDlistColumn(lastStatusUpdate,"none") %>
	<%= comm.addDlistColumn("<DIV style=\"text-align: right; font-size : 8pt\">"+amount+"</DIV>","none") %>
	<%= comm.endDlistRow() %>
	<%
	}	
%>	
<%= comm.endDlistTable() %>
</FORM>

<%
	if (totalSize < 1)
	{
		if ( memberId != null && !memberId.equals("") )
			out.println( UIUtil.toHTML((String)returnsNLS.get("noReturnUnderCustomer")) );
		else
			out.println( UIUtil.toHTML((String)returnsNLS.get("noReturnUnderConditions")) );
	}
%>
</BODY>
<SCRIPT>
parent.setResultssize(<%= totalSize %>);
parent.afterLoads();
</SCRIPT>
</HTML>

<%
}
catch (Exception e)
{
	com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
}
%>
