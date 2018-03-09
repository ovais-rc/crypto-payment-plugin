<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.messaging.databeans.MsgtypesDataBean" %>
<%@page import="com.ibm.commerce.messaging.databeans.TransportDataBean" %>
<%@page import="com.ibm.commerce.messaging.databeans.DeviceFmtDataBean" %>
<%@page import="com.ibm.commerce.messaging.util.MessagingSystemConstants" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.exception.ECSystemException" %>
<%@page import="com.ibm.commerce.exception.ExceptionHandler" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>

<%@include file="../common/common.jsp" %>

<jsp:useBean id="msgTypeBean" scope="request" class="com.ibm.commerce.messaging.databeans.MsgtypesDataBean"></jsp:useBean>
<jsp:useBean id="msgStoreTrans" scope="request" class="com.ibm.commerce.messaging.databeans.StoreTransDataBean"></jsp:useBean>
<jsp:useBean id="DeviceFmtList" scope="request" class="com.ibm.commerce.messaging.databeans.DeviceFmtDataBean"></jsp:useBean>
<jsp:useBean id="ProfileList" scope="request" class="com.ibm.commerce.messaging.databeans.ProfileDataBean"></jsp:useBean>

<%
   String webalias = UIUtil.getWebPrefix(request);
   String store_id = request.getParameter(MessagingSystemConstants.TC_STORETRANS_STORE_ID);
   String profile_id = request.getParameter(MessagingSystemConstants.TC_PROFILE_PROFILE_ID);
   String transport_id = request.getParameter(MessagingSystemConstants.TC_PROFILE_TRANSPORT_ID);
   String msgtype_id = request.getParameter(MessagingSystemConstants.TC_PROFILE_MSGTYPE_ID);
   String devicefmt_id = request.getParameter(MessagingSystemConstants.TC_PROFILE_DEVICEFORMAT_ID);
   String lowpriority = request.getParameter(MessagingSystemConstants.TC_PROFILE_LOWPRIORITY);
   String highpriority = request.getParameter(MessagingSystemConstants.TC_PROFILE_HIGHPRIORITY);
   String archive = request.getParameter(MessagingSystemConstants.TC_PROFILE_ARCHIVE);
   CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);

   Hashtable customNLS = null;
   try {
      customNLS =  (Hashtable)ResourceDirectory.lookup("adminconsole.MsgMessagingNLS", cmdContext.getLocale());
      if ((msgtype_id != null) && (!msgtype_id.equals(""))) msgTypeBean.setMsgType_ID(Integer.valueOf(msgtype_id));
      DataBeanManager.activate(msgTypeBean, request);
      msgStoreTrans.setStore_ID(Integer.valueOf(store_id));
      DataBeanManager.activate(msgStoreTrans, request);
      ProfileList.setStore_ID(Integer.valueOf(store_id));
      DataBeanManager.activate(ProfileList, request);
      DataBeanManager.activate(DeviceFmtList, request);
   } catch (ECSystemException ecSysEx) {
    ExceptionHandler.displayJspException(request, response, ecSysEx);
   } catch (Exception exc) {
    //ECSystemException ecSysEx = new ECSystemException(null,exc.getMessage(),null);
    ExceptionHandler.displayJspException(request, response, exc);
   }

   int msgTypeBeanSize=0, msgStoreTransSize=0, deviceFmtBeanSize=0;
   if (msgTypeBean!=null) msgTypeBeanSize=msgTypeBean.getSize();
   if (msgStoreTrans!=null) msgStoreTransSize=msgStoreTrans.getSize();
   if (DeviceFmtList!=null) deviceFmtBeanSize = DeviceFmtList.getSize();
%>
<HTML>
<HEAD>
<%= fHeader%>
<link rel=stylesheet href="<%= com.ibm.commerce.tools.util.UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css"> 
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>



function check_unique_values(msgtype, transport) {
<%
  String key = null;
  out.println(" var search_key;");
  out.println(" search_key = msgtype + ',' + transport;");
  out.println(" var profile_keys = new Array();");

  int skip_key=0;
  for(int i=0; i < ProfileList.getSize(); i++) {
    key = ProfileList.getMsgType_ID(i) + "," + ProfileList.getTransport_ID(i);
    // if a change, do not add this to the list
    // in this case, must decrement the i by one to ensure no array reference errors.
    if ((profile_id != null) && (!profile_id.equals(ProfileList.getProfile_ID(i))))
      out.println(" profile_keys["+ (i - skip_key) +"] = '"+key+"';");
    else
      skip_key++;
  }

  out.println(" for( i=0; i < profile_keys.length; i++) {");
  out.println("   if (profile_keys[i] == search_key)");
  out.println("     return false;");
  out.println(" }");
  out.println(" return true;");

%>
}



cancel_url = top.getWebappPath() + 'NewDynamicListView?ActionXMLFile=adminconsole.MsgMessageTransport&cmd=MsgMessageTransportView';

function checkNum(obj) {
  var str = obj.value;
  if (str.length == 0 || str == "" || str == null)
    return false;
  // remove leading blanks.
  var start_pos = 0;
  for(var i=0; i < str.length; i++) {
    if(str.substring(i, i+1) != ' ') {
      start_pos = i;
      break;
    }
  }
  // remove trailing blanks
  var end_pos = str.length;
  for(var i=str.length - 1; i >= 0; i--) {
    if(str.substring(i, i+1) != ' ') {
      end_pos = i + 1;
      break;
    }
  }
  // verify number
  for( var i=start_pos; i < end_pos; i++) {
    var ch = str.substring(i, i+1);
    if((ch < "0" || ch > "9") && ch != '.')
      return false;
  }
  obj.value = str.substring(start_pos, end_pos);
  return true;
}



function initVal() {
   theVal=parent.getCurrentPanelAttribute("<%=MessagingSystemConstants.TC_PROFILE_MSGTYPE_ID%>");
   if (theVal!=null) document.wizard1.msgtype.value=theVal;
   theVal=parent.getCurrentPanelAttribute("<%=MessagingSystemConstants.TC_PROFILE_LOWPRIORITY%>");
   if (theVal!=null) document.wizard1.msgFrom.value=theVal;
   theVal=parent.getCurrentPanelAttribute("<%=MessagingSystemConstants.TC_PROFILE_HIGHPRIORITY%>");
   if (theVal!=null) document.wizard1.msgTo.value=theVal;
   theVal=parent.getCurrentPanelAttribute("<%=MessagingSystemConstants.TC_PROFILE_TRANSPORT_ID%>");
   if (theVal!=null) document.wizard1.msgtransport.value=theVal;
   theVal=parent.getCurrentPanelAttribute("<%=MessagingSystemConstants.TC_PROFILE_DEVICEFORMAT_ID%>");
   if (theVal!=null) document.wizard1.msgdevicefmt.value=theVal;
   theVal=parent.getCurrentPanelAttribute("<%=MessagingSystemConstants.TC_PROFILE_ARCHIVE%>");
   if (theVal!=null) document.wizard1.archive.value=theVal;

   var authToken = parent.get("authToken");
   if (!defined(authToken)) {
       parent.put("authToken", document.wizard1.authToken.value);
   }

   parent.setContentFrameLoaded(true);
   return; }

//function savePanelData() {   return; }

function validatePanelData() {
   if (document.wizard1.msgtype.value=="none") {
      parent.alert("<%=UIUtil.toJavaScript((String)customNLS.get("messagingMsgTypeChangeMessageTypeNotSelected"))%>");
      return false; }
   if (isEmpty(document.wizard1.msgFrom.value)) {
      parent.alert("<%=UIUtil.toJavaScript((String)customNLS.get("messagingMsgTypeChangeLowPriorityNotSpecified"))%>");
      return false; }
   if (isEmpty(document.wizard1.msgTo.value)) {
      parent.alert("<%=UIUtil.toJavaScript((String)customNLS.get("messagingMsgTypeChangeHighPriorityNotSpecified"))%>");
      return false; }

   // priorty test -- ensure they are numeric
   if (!checkNum(document.wizard1.msgFrom)) {
      parent.alert("<%=UIUtil.toJavaScript((String)customNLS.get("messagingMsgTypeChangeLowPriorityNotNumeric"))%>");
      return false; }
   if (!checkNum(document.wizard1.msgTo)) {
      parent.alert("<%=UIUtil.toJavaScript((String)customNLS.get("messagingMsgTypeChangeHighPriorityNotNumeric"))%>");
      return false; }

   if (eval(document.wizard1.msgFrom.value) > eval(document.wizard1.msgTo.value) ) {
      parent.alert("<%=UIUtil.toJavaScript((String)customNLS.get("messagingMsgTypeChangePrioritiesNotOrdered"))%>");
      return false; }
   if (document.wizard1.msgtransport.value=="none") {
      parent.alert("<%=UIUtil.toJavaScript((String)customNLS.get("messagingMsgTypeChangeTransportNotSelected"))%>");
      return false; }
   if (document.wizard1.msgdevicefmt.value=="none") {
      parent.alert("<%=UIUtil.toJavaScript((String)customNLS.get("messagingMsgTypeChangeDeviceFmtNotSelected"))%>");
      return false; }

   if(!check_unique_values(document.wizard1.msgtype.value, document.wizard1.msgtransport.value)) {
      parent.alert("<%=UIUtil.toJavaScript((String)customNLS.get("messagingMsgTypeChangeNoUniqueKey"))%>");
      return false;
   }

   parent.setCurrentPanelAttribute("<%=MessagingSystemConstants.TC_STORETRANS_STORE_ID%>", "<%=UIUtil.toJavaScript(request.getParameter(MessagingSystemConstants.TC_STORETRANS_STORE_ID))%>");
   parent.setCurrentPanelAttribute("<%=MessagingSystemConstants.TC_PROFILE_PROFILE_ID%>", "<%=UIUtil.toJavaScript(request.getParameter(MessagingSystemConstants.TC_PROFILE_PROFILE_ID))%>");
   parent.setCurrentPanelAttribute("<%=MessagingSystemConstants.TC_PROFILE_MSGTYPE_ID%>", document.wizard1.msgtype.value);
   parent.setCurrentPanelAttribute("<%=MessagingSystemConstants.TC_PROFILE_DEVICEFORMAT_ID%>", document.wizard1.msgdevicefmt.value);
   parent.setCurrentPanelAttribute("<%=MessagingSystemConstants.TC_PROFILE_LOWPRIORITY%>", document.wizard1.msgFrom.value);
   parent.setCurrentPanelAttribute("<%=MessagingSystemConstants.TC_PROFILE_HIGHPRIORITY%>", document.wizard1.msgTo.value);
   parent.setCurrentPanelAttribute("<%=MessagingSystemConstants.TC_PROFILE_TRANSPORT_ID%>", document.wizard1.msgtransport.value);
   parent.setCurrentPanelAttribute("<%=MessagingSystemConstants.TC_PROFILE_ARCHIVE%>", document.wizard1.archive.checked);
   parent.put("<%=MessagingSystemConstants.TC_PROFILE_TRANSPORT_ID%>", document.wizard1.msgtransport.value);

   return true;
}

</SCRIPT>
<title><%=customNLS.get("messagingMsgTypeChangeTitle")%> </title>
</HEAD>

<BODY onload="initVal()"  class="content">
<%
if (profile_id == null || profile_id.equals(MessagingSystemConstants.NEW_PROFILE_PROFILE_ID_VALUE)) {
%>
  <H1><%=customNLS.get("messagingMsgTypeAddPrompt")%></H1>
<%
} else {
%>
  <H1><%=customNLS.get("messagingMsgTypeChangePrompt")%></H1>
<%
}
%>
  <FORM NAME="wizard1">
    <p><LABEL for="msgTypeCombo"><%=customNLS.get("messagingMsgTypeChangeMessageTypePrompt")%></LABEL><br>
    <input type="hidden" name="authToken" value="${authToken}" id="WC_MsgMessageTransportWizard_FormInput_authToken"/>
    <select name="msgtype" id="msgTypeCombo">

<%

if (profile_id == null || profile_id.equals(MessagingSystemConstants.NEW_PROFILE_PROFILE_ID_VALUE)) {
  out.println("<option value=\"none\" selected>"+customNLS.get("messagingMsgTypeChangeMsgTypeSelect")+"</option>");
  for (int i=0; i<msgTypeBeanSize; i++) {
    out.println("<option value=\"" + msgTypeBean.getMsgType_ID(i) + "\">");
    if (customNLS.get(msgTypeBean.getName(i)) != null) {
        out.println(customNLS.get(msgTypeBean.getName(i)));
    }
    else {
        out.println(msgTypeBean.getName(i));
    }
    out.println("</option>");
  }
}
else {
    out.println("<option value=\"" + msgTypeBean.getMsgType_ID(0) + "\">");
    if (customNLS.get(msgTypeBean.getName(0)) != null) {
        out.println(customNLS.get(msgTypeBean.getName(0)));
    }
    else {
        out.println(msgTypeBean.getName(0));
    }
    out.println("</option>");

}
%>
    </select></p>
    <p><%=customNLS.get("messagingMsgTypeChangeMessageSeverityPrompt")%><br>
    <LABEL for="lowpriority" class="hidden-label"><%=customNLS.get("messagingMsgTypeChangeMessageSeverityPromptLowerBound")%></LABEL>
    <input type="text" name="msgFrom"
    value="<%=(lowpriority !=null && lowpriority.length() != 0)? UIUtil.toHTML(lowpriority) : "0"%>"
    size=5 id="lowpriority">
    <%=customNLS.get("messagingMsgTypeChangeToPrompt")%>
    <LABEL for="highpriority" class="hidden-label"><%=customNLS.get("messagingMsgTypeChangeMessageSeverityPromptUpperBound")%></LABEL>
    <input type="text" name="msgTo"
    value="<%=(highpriority !=null && lowpriority.length() != 0)? UIUtil.toHTML(highpriority) : "0"%>"
    size=5 id="highpriority"></p>    
    <p><LABEL for="msgTransCombo"><%=customNLS.get("messagingMsgTypeChangeTransportPrompt")%><br>
    <select name="msgtransport" id="msgTransCombo">
<%
 out.println("<option value=\"none\">"+customNLS.get("messagingMsgTypeChangeTransportSelect")+"</option>");
 for (int i=0; i<msgStoreTransSize; i++) {
   if (msgStoreTrans.getTransportImplemented(i).equals("Y") && msgStoreTrans.getActive(i).equals("1")) {
       out.print("<option value=\""+msgStoreTrans.getTransport_ID(i)+"\" ");
       if ((transport_id != null) && (transport_id.equals(msgStoreTrans.getTransport_ID(i)))) out.print("SELECTED");
       out.print(" >\n");
       if (customNLS.get(msgStoreTrans.getTransportName(i)) != null)
         out.println(customNLS.get(msgStoreTrans.getTransportName(i)));
       else
         out.println(msgStoreTrans.getTransportName(i));
       out.println("</option>");
    }
  }
%>
    </select></p>
    <p><LABEL for="msgDeviceFmtCombo"><%=customNLS.get("messagingMsgTypeChangeDeviceFmtPrompt")%><br>
    <select name="msgdevicefmt" id="msgDeviceFmtCombo">
<%
 out.println("<option value=\"none\">"+customNLS.get("messagingMsgTypeChangeDeviceFmtSelect")+"</option>");
 for (int i=0; i<deviceFmtBeanSize; i++) {
       out.print("<option value=\""+DeviceFmtList.getDeviceFmt_ID(i)+"\" ");
       if ((devicefmt_id != null) && (devicefmt_id.equals(DeviceFmtList.getDeviceFmt_ID(i)))) out.print("SELECTED");
       out.print(" >\n");
       if (customNLS.get(DeviceFmtList.getDeviceType_ID(i)) != null)
         out.println(customNLS.get(DeviceFmtList.getDeviceType_ID(i)));
       else
         out.println(DeviceFmtList.getDisplayName(i));
       out.println("</option>");
  }
%>



    </select></p>
    <p><LABEL for="archive"><%=customNLS.get("messagingMsgTypeChangeArchiveMsg")%></LABEL>
	<INPUT TYPE="checkbox" NAME="archive" 
	id="archive"  <%=(archive.equals("1"))? "checked" : ""%>>
	</p>


  </FORM>
</BODY>
</HTML>
