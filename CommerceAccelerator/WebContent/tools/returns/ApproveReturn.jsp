
<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">


<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.*" %>
<%@ page import="com.ibm.commerce.ordermanagement.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.CatalogEntryDataBean" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.CatalogEntryDescriptionDataBean" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@include file="../common/common.jsp" %>

<%
try{
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale = cmdContext.getLocale();
	Hashtable returnsNLS = (Hashtable)ResourceDirectory.lookup("returns.ReturnsNLS", jLocale);
	JSPHelper jspHelper = new JSPHelper(request);

	String jLanguageId = cmdContext.getLanguageId().toString();
%>

<HTML>
<HEAD>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css"> 

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>
function init() 
{
   if (parent.setContentFrameLoaded) {
      parent.setContentFrameLoaded(true);
   }
}
</SCRIPT>

<TITLE><%= UIUtil.toHTML((String)returnsNLS.get("approveReturnTitle")) %></TITLE>

</HEAD>

<BODY CLASS=content onload="init();">

<H1><%= UIUtil.toHTML((String)returnsNLS.get("approveReturnTitle")) %></H1>

<%
	String RMAId = jspHelper.getParameter("RMAId");
	String customerId = jspHelper.getParameter("customerId");
	RMAItemListDataBean rmaItemListDB = new RMAItemListDataBean();
	rmaItemListDB.setRmaId(RMAId);
	com.ibm.commerce.beans.DataBeanManager.activate(rmaItemListDB, request);
	RMAItemAccessBean[] rmaItemListAB = rmaItemListDB.getRMAItemList();

%>

<P><%=returnsNLS.get("approveReturnInstruction")%>
<P>
<TABLE class="list_role_on" style="height: auto" BORDER=0 CELLPADDING=1 CELLSPACING=1 WIDTH="100%" >
<TR class="list_roles">
	<TD class="list_header"><%= UIUtil.toHTML((String)returnsNLS.get("approveReturnProductName")) %></TD>
	<TD class="list_header"><%= UIUtil.toHTML((String)returnsNLS.get("approveReturnSku")) %></TD>
	<TD class="list_header"><%= UIUtil.toHTML((String)returnsNLS.get("approveReturnReject")) %></TD>
</TR>

<%	for (int i=0; i < rmaItemListAB.length; i++) {
		CatalogEntryDataBean item = new CatalogEntryDataBean();
		item.setCatalogEntryID(rmaItemListAB[i].getCatalogEntryId());
		com.ibm.commerce.beans.DataBeanManager.activate(item, request);

		CatalogEntryDescriptionDataBean itemDescription = new CatalogEntryDescriptionDataBean();
		itemDescription.setItemRefNum(item.getCatalogEntryReferenceNumber());
		itemDescription.setInitKey_language_id(jLanguageId);
		com.ibm.commerce.beans.DataBeanManager.activate(itemDescription, request);

		Enumeration ReturnDenyEnum = new ReturnDenyReasonDataBean().findByRMAItemId(rmaItemListAB[i].getRmaItemIdInEntityType());

		while (ReturnDenyEnum.hasMoreElements()) {
			ReturnDenyReasonAccessBean denyReasonAB = (ReturnDenyReasonAccessBean) ReturnDenyEnum.nextElement();

			ReturnDenyReasonDescriptionDataBean denyReasonDescDB = new ReturnDenyReasonDescriptionDataBean();
			denyReasonDescDB.setDataBeanKeyLanguageId(jLanguageId);
			denyReasonDescDB.setDataBeanKeyRtnDnyRsnId(denyReasonAB.getRtnDnyRsnId());
			com.ibm.commerce.beans.DataBeanManager.activate(denyReasonDescDB, request);

			String denyReasonDesc = denyReasonDescDB.getDescription();
			String denyReasonToDisplay = (denyReasonDesc == null || denyReasonDesc.equals("") ) ? denyReasonAB.getCode() : denyReasonDesc;

%>
<TR class="list_row1">
	<TD><%= UIUtil.toHTML(itemDescription.getName())%></TD>
	<TD><%= UIUtil.toHTML(item.getPartNumber())%></TD>
	<TD><%= UIUtil.toHTML(denyReasonToDisplay)%></TD>
</TR>

<%
		}
	}
%>

</TABLE>

<SCRIPT>
  function savePanelData() {    
  }
  function validatePanelData()
  {
    return true;
  }
  function performApprove() {
     document.returnApproveForm.submit();
  }
</SCRIPT>
<FORM NAME="returnApproveForm" target="_parent" METHOD="post" ACTION="AdminReturnApprove">
  <INPUT TYPE="hidden" NAME="RMAId" VALUE="<%=RMAId%>">
  <INPUT TYPE="hidden" NAME="URL" VALUE="ApproveReturnRedirect">
</FORM>
</BODY>
</HTML>

<%
}
catch (Exception e)
{	System.out.println(e);
	out.println(e);
}
%>
