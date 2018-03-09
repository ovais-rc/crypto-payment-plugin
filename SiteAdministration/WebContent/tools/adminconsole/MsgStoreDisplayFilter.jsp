<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!-- ========================================================================
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
 ===========================================================================-->

<%@page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.ibm.commerce.command.*"%>
<%@ page import="com.ibm.commerce.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.ubf.util.*" %>
<%@ page import="com.ibm.commerce.approval.util.*" %>
<%@ page import="com.ibm.commerce.approval.beans.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="com.ibm.commerce.messaging.util.MessagingSystemConstants" %>


<%@include file="../common/common.jsp" %>

<%
try
{
%>

<HTML>
<HEAD>
<%= fHeader%>

<%        
   Locale locale = null;
   String lang = null;
   String tableName = "MSGSTORE";
   String webalias = UIUtil.getWebPrefix(request);                      

   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext"); 
   Integer store_id = aCommandContext.getStoreId();
   long userId = aCommandContext.getUserId().longValue();      
   locale = aCommandContext.getLocale();
   lang = aCommandContext.getLanguageId().toString();
      
   // obtain the resource bundle for display
   //Hashtable searchNLS = (Hashtable)ResourceDirectory.lookup("approvals.approvalsNLS", locale);
   
   Hashtable messagingListNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.MsgMessagingNLS", locale);
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%= UIUtil.toHTML((String)messagingListNLS.get("messagingMsgStoreSearchTitle")) %></TITLE>

<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/DateUtil.js"></SCRIPT>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/NumberFormat.js"></SCRIPT>
<SCRIPT Language="JavaScript">


function initializeState()
{
  parent.setContentFrameLoaded(true);
}

function setupDate()
{
}

function savePanelData()
{

}


function doPrompt (field,msg)
{
    alertDialog(msg);
    field.focus();
}

function validatePanelData()
{
}

function getApprovalsBCT()
{
  return "<%= UIUtil.toJavaScript((String)messagingListNLS.get("messagingMsgStoreTitle")) %>";
}

</SCRIPT>

<jsp:useBean id="msgStoreTrans" class="com.ibm.commerce.messaging.databeans.StoreTransDataBean">
</jsp:useBean>

<%
  
   msgStoreTrans.setStore_ID(store_id);
   DataBeanManager.activate(msgStoreTrans, request);

%>

<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>
<BODY ONLOAD="initializeState();" class="content">
<SCRIPT FOR=document EVENT="onClick()">
   document.all.CalFrame.style.display="none";
</SCRIPT>
<H1><%= UIUtil.toHTML((String)messagingListNLS.get("messagingMsgStoreSearchTitle")) %></H1>
 <FORM Name="SearchForm" >   
 <INPUT TYPE="HIDDEN" NAME="tableName" VALUE="<%= tableName %>">

	<TABLE>


        <TR><TD ALIGN="LEFT"><LABEL for="transportId1"><%= UIUtil.toHTML((String)messagingListNLS.get("messagingMsgViewMsgTransportColumn")) %></LABEL></TD></TR>
        <TR><TD><SELECT NAME="transportId" id="transportId1">

<%       	     
   int msgStoreTransSize = 0;
   if (msgStoreTrans!=null) {
       msgStoreTransSize=msgStoreTrans.getSize();
   }
   for (int i=0; i<msgStoreTransSize; i++) {
    if (msgStoreTrans.getTransportImplemented(i).equals("Y")) {
       out.print("<option value=\""+msgStoreTrans.getTransport_ID(i)+"\" ");
       if (i == 0) {
         out.print("SELECTED");
       }
       out.print(" >\n");
       if (messagingListNLS.get(msgStoreTrans.getTransportName(i)) != null)
         out.println(UIUtil.toHTML(
             (messagingListNLS.get(msgStoreTrans.getTransportName(i))).toString()
             ));
       else
         out.println(UIUtil.toHTML(
             (msgStoreTrans.getTransportName(i)).toString()
             ));
       out.println("</option>");
    }
  }
%>
        </SELECT></TD></TR>	


        <TR><TD ALIGN="LEFT"><BR/><LABEL for="deliveryStatus1"><%= UIUtil.toHTML((String)messagingListNLS.get("messagingMsgDeliveryStatus")) %></LABEL></TD></TR>
        <TR><TD>
            <SELECT NAME="deliveryStatus" id="deliveryStatus1">
            <OPTION VALUE="0" SELECTED><%= UIUtil.toHTML((String)messagingListNLS.get("messagingMsgStatusFailed")) %> 
            <OPTION VALUE="1"><%= UIUtil.toHTML((String)messagingListNLS.get("messagingMsgStatusPending")) %>
            </SELECT>
            </TD>
        </TR>


</TABLE>
</FORM>

</BODY>
</HTML>

<%
}
catch(Exception e)
{
   ExceptionHandler.displayJspException(request, response, e);
}
%>

