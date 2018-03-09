<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.messaging.databeans.CISEditAttDataBean" %>
<%@page import="com.ibm.commerce.messaging.databeans.TransportDataBean" %>
<%@page import="com.ibm.commerce.messaging.util.MessagingSystemConstants" %>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.exception.ECSystemException" %>
<%@page import="com.ibm.commerce.exception.ExceptionHandler" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="com.ibm.commerce.messaging.outboundservice.Messaging" %>
<%@page import="com.ibm.commerce.common.beans.LanguageDescriptionDataBean" %>
<%@page import="com.ibm.commerce.common.beans.LanguageDataBean" %>
<%@include file="../common/common.jsp" %>

<jsp:useBean id="messagingList" scope="request" class="com.ibm.commerce.messaging.databeans.CISEditAttDataBean"></jsp:useBean>
<jsp:useBean id="transportList" scope="request" class="com.ibm.commerce.messaging.databeans.TransportDataBean"></jsp:useBean>
<jsp:useBean id="msgObject" scope="request" class="com.ibm.commerce.messaging.databeans.MsgObjectDataBean"></jsp:useBean>
<jsp:useBean id="langDSList" scope="request" class="com.ibm.commerce.common.beans.LanguageDescriptionDataBean"></jsp:useBean>
<jsp:useBean id="langList" scope="request" class="com.ibm.commerce.common.beans.LanguageDataBean"></jsp:useBean>

<%! Hashtable messagingListNLS = null; %>
<%! Hashtable adminconsoleNLS = null; %>
<%! int numberOfmessagings = 0; %>

<%

   String store_id = request.getParameter(MessagingSystemConstants.MSG_VIEW_STORE_ID);
   String transport_id = request.getParameter(MessagingSystemConstants.MSG_VIEW_TRANSPORT_ID);
//   String profile_id = request.getParameter(MessagingSystemConstants.TC_PROFILE_PROFILE_ID);
   String msg_id = request.getParameter(MessagingSystemConstants.MSG_VIEW_MSG_ID);
   String transport_name = null;
//   profile_id = "1";

   CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);

  try {
      // obtain the resource bundle for display
      messagingListNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.MsgMessagingNLS", cmdContext.getLocale());
      adminconsoleNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", cmdContext.getLocale());
      DataBeanManager.activate(messagingList, request);


      if ((transport_id != null) && (!transport_id.equals(""))) {
          transportList.setTransport_ID(new Integer(transport_id));
      }
      if ((transport_id != null) && (!transport_id.equals(""))) {
          msgObject.setTransportId(new Integer(transport_id));
      }
      if ((msg_id != null) && (!msg_id.equals(""))) {
          msgObject.setMsgId(new Long(msg_id));
      }
      msgObject.setMode(new Integer(request.getParameter("table")));
      DataBeanManager.activate(transportList, request);
      DataBeanManager.activate(msgObject, request);
      // there should only be one element
      if (transportList.getSize() > 0) {
        transport_name = transportList.getName(0);
      }

  } catch (ECSystemException ecSysEx) {
      ExceptionHandler.displayJspException(request, response, ecSysEx);
  } catch (Exception exc) {
      //ECSystemException ecSysEx = new ECSystemException(null,exc.getMessage(),null);
      ExceptionHandler.displayJspException(request, response, exc);
  }


   if (messagingList != null)
   {
     numberOfmessagings = messagingList.numberOfElements();
   }
%>

<HTML>
<HEAD>
<%= fHeader%>
<link rel=stylesheet href="<%= com.ibm.commerce.tools.util.UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css"> 
<TITLE><%= messagingListNLS.get("messagingMsgTypeChangeTitle") %></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

      function lengthValidation( param ) {
          if (!parent.isValidUTF8length(param.value, 254)) {
               param.focus();
               param.select();
               window.alert('<%=UIUtil.toJavaScript(adminconsoleNLS.get("AdminConsoleExceedMaxLength"))%>');
               return false;
          }
          return true;
      }

<%

//  if ((profile_id != null) && (!profile_id.equals("")))
    out.println("cancel_url = '/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=adminconsole.MsgMessageTransport&cmd=MsgMessageTransportView';");
//  else
//    out.println("cancel_url = '/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=adminconsole.MsgStoreTransport&cmd=MsgStoreTransportView';");

  out.println("function convertParametersToXML() {");


    out.println("parent.remove('CSEDITATT');");
    out.println("parent.remove('ISEDITATT');");
    // declare variables
    out.println(" var CSEDITATT = new Object();");
    out.println(" var ISEDITATT = new Object();");

//    out.println("CSEDITATT.store_id='"+store_id+"';");
//    out.println("CSEDITATT.transport_id='"+transport_id+"';");
//    if ((profile_id != null) && (!profile_id.equals(""))) out.println("CSEDITATT.profile_id='"+profile_id+"';");
//    if ((profile_id != null) && (!profile_id.equals(""))) out.println("ISEDITATT.profile_id='"+profile_id+"';");

    int CS_Index = 0;
    int IS_Index = 0;
    String objName = null;
    // assign variable values
    for (int i= 0 ; i < numberOfmessagings ; i++)
    {
      if(messagingList.getNLSupport(i).equalsIgnoreCase("false")) {
        out.println("if (!lengthValidation(messagingForm." + messagingList.getName(i) + ")) return false;");
        if ( messagingList.getOrigin(i).equals("CS") ) {
          objName = "CSEDITATT";
          CS_Index++;
        }
        else {
          objName = "ISEDITATT";
          IS_Index++;
        }
        out.println(objName + "." + messagingList.getName(i) + " = new Object();");
//      if ( messagingList.getOrigin(i).equals("CS") )
//        out.println(objName + "." + messagingList.getName(i) + ".cseditatt_id = \"" + messagingList.getID(i) + "\";");
//      else
//        out.println(objName + "." + messagingList.getName(i) + ".iseditatt_id = \"" + messagingList.getID(i) + "\";");
//      out.println(objName + "." + messagingList.getName(i) + ".value = messagingForm." + messagingList.getName(i) + ".value;");
        out.println(objName + "." + messagingList.getName(i) + "= messagingForm." + messagingList.getName(i) + ".value;");
//      out.println(objName + "." + messagingList.getName(i) + ".value = '" + msgObject.getMsgConfigData("messagingList.getName(i)") + "';");
      }
    }
    if (CS_Index > 0) {
        out.println("parent.put('CSEDITATT', CSEDITATT);");
    }
    if (IS_Index > 0) {
        out.println("parent.put('ISEDITATT', ISEDITATT);");
    }
    out.println("return true;");

  out.println("}");

//  if ((profile_id != null) && (!profile_id.equals("")))  {

   out.println("function validatePanelData() {");

   out.println("var MSG = new Object();");
   out.println("MSG."+MessagingSystemConstants.MSG_VIEW_STORE_ID+"='"+UIUtil.toJavaScript(store_id)+"';");
   out.println("MSG."+MessagingSystemConstants.MSG_VIEW_TRANSPORT_ID+"='"+UIUtil.toJavaScript(transport_id)+"';");
   out.println("MSG."+MessagingSystemConstants.MSG_VIEW_MSG_ID+" = '"+UIUtil.toJavaScript(msg_id)+"';");
   out.println("MSG.mode = '" + UIUtil.toJavaScript(request.getParameter("table")) + "'");
   out.println("parent.put('MSG', MSG);");
   out.println("return convertParametersToXML();");

    out.println("}");

//  }
//  else {
//   out.println("function validatePanelData() {");
//   out.println("	return convertParametersToXML();");
//   out.println("}");   
//  }
%>

function loadPanelData()
 {
  if (parent.setContentFrameLoaded)
   {
    parent.setContentFrameLoaded(true);
   }
 }

// -->
</script>

<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>
<BODY ONLOAD="loadPanelData()"  class="content">
<H1><%=messagingListNLS.get("messagingMsgArchiveConfigTitle")%></H1>
<FORM NAME="messagingForm">
<%

  if (numberOfmessagings > 0) {

%>
<%
    if( transport_name != null) {
      if (messagingListNLS.get(transport_name) != null) {
        out.println(messagingListNLS.get(transport_name));
      }
      else {
        out.println(transport_name);
      }
    }
    out.println("&nbsp;" + UIUtil.toHTML(msg_id));
%>
<table class="list" width="75%"
summary="<%= messagingListNLS.get("messagingMsgTypeChangeTableDesc") %>">

<TR class="list_roles">

<!-- XXX need to fix up the orderBy paramaters -->
<TD class="list_header" id="col1">
<nobr>&nbsp;&nbsp;&nbsp;<%= messagingListNLS.get("messagingTransportConfigurationParameterColumn") %>&nbsp;&nbsp;&nbsp;</nobr>
</TD>

<TD width="100%" class="list_header" id="col2">
<nobr>&nbsp;&nbsp;&nbsp;<%= messagingListNLS.get("messagingTransportConfigurationValueColumn") %>&nbsp;&nbsp;&nbsp;</nobr>
</TD>


</TR>

<!-- Need to have a for loop to lookfor all the member groups -->
<%
    String classId = "list_row1";
    int endIndex = numberOfmessagings;
    String configValue = null;
    Messaging msg = msgObject.getMsgObject();
    for (int i= 0 ; i<endIndex ; i++)
    {
%>

<TR class=<%=classId%>>
<TD class="list_info1" align="left" id="row<%=i%>" headers="col1">
<nobr>&nbsp;<LABEL for="input<%=i%>"><%= (messagingListNLS.get(messagingList.getName(i)) != null)? messagingListNLS.get(messagingList.getName(i)): messagingList.getName(i) %></LABEL>&nbsp;</nobr>
</TD>
<% if(messagingList.getNLSupport(i).equalsIgnoreCase("true")) {
      String msgContent = msgObject.getMsgContent(cmdContext.getLanguageId().toString());
      if (msgContent == null) {
        msgContent = msgObject.getMsgContent("MsgDefaultLang");
     }
      if (msgContent != null) {
        configValue = msg.getConfigData(messagingList.getName(i),cmdContext.getLanguageId().toString());
        if (configValue == null || configValue.equals(MessagingSystemConstants.MS_NULL)) {
          configValue = msg.getConfigData(messagingList.getName(i));
          if (configValue == null || configValue.equals(MessagingSystemConstants.MS_NULL)) {
            configValue = "";
          }
        }
      } else {
        configValue = (String)messagingListNLS.get("messagingMsgViewContentNoAvail");
      }
%>
<TD class="list_info1" align="left" headers="col2 row<%=i%>">
&nbsp;<%=configValue%><INPUT NAME="<%= messagingList.getName(i) %>" VALUE="" SIZE="50" id="input<%=i%>" type=hidden>&nbsp;
</TD>
</TR>

<%   } else { 
       configValue = msgObject.getMsgConfigData(messagingList.getName(i));
       if(configValue==null) {
         configValue = "";
       } else if(configValue.equals(MessagingSystemConstants.MS_NULL)) {
         configValue = "";
       }
%>
<TD class="list_info1" align="left" headers="col2 row<%=i%>">
&nbsp;<INPUT NAME="<%= messagingList.getName(i) %>" 
<%
	if(messagingList.getName(i).equalsIgnoreCase("password")) {
		out.print("type=\"password\"");
	}
%> 
VALUE="<%= configValue %>" SIZE="50" id="input<%=i%>">&nbsp;
</TD>

<%   } %>
<%
      if (classId.equals("list_row1"))
        classId="list_row2";
      else
        classId="list_row1";
    } //for loop
%>
</TABLE>
<%
    }
    else {
      if( transport_name != null) {
        if (messagingListNLS.get(transport_name) != null) {
          out.println("<h4>"+messagingListNLS.get(transport_name)+"</h4>");
        }
        else {
          out.println("<h4>"+transport_name+"</h4>");
        }
      }
      out.println("<BLOCKQUOTE>&nbsp;&nbsp;&nbsp;&nbsp;");
      out.println(messagingListNLS.get("messagingTransportConfigureNoAvail"));
      out.println("</BLOCKQUOTE></p><p>&nbsp;</p>");

    }
%>

</FORM>
<%
  String msgContent = msgObject.getMsgContent(cmdContext.getLanguageId().toString());
  if (msgContent == null) {
    msgContent = msgObject.getMsgContent("MsgDefaultLang");
  }
  if (msgContent == null) {

    out.println(messagingListNLS.get("messagingMsgViewContentNoAvail"));
	try {
      Enumeration languages = langList.findAll();
      out.println("<p>"+adminconsoleNLS.get("AdminConsoleLanglistname"));
    
      while (languages.hasMoreElements()) {
        LanguageDataBean langdb = (LanguageDataBean) languages.nextElement();
        String lang = langdb.getLanguageId();
        langdb = null;
        msgContent = msgObject.getMsgContent(lang);
        if (msgContent != null) {
          langDSList.setDataBeanKeyDescriptionLanguageId(lang);
          try {
            DataBeanManager.activate(langDSList, request);
          } catch (Exception exc) {
            System.out.println(exc.getMessage());
            out.println("&nbsp;&nbsp;" + lang);         
          }
          out.println("&nbsp;&nbsp;" + langDSList.getDescription());
        }
      }
    } catch (Exception exc) {
      ExceptionHandler.displayJspException(request, response, exc);
    } finally {
       out.println("</p>");
    }

  } else {
     out.println(msgContent);
  }

    
%>
</BODY>
</HTML>
