<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.messaging.databeans.CISEditAttDataBean" %>
<%@page import="com.ibm.commerce.messaging.databeans.TransportDataBean" %>
<%@page import="com.ibm.commerce.messaging.util.MessagingSystemConstants" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.exception.ECSystemException" %>
<%@page import="com.ibm.commerce.exception.ExceptionHandler" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="com.ibm.commerce.messaging.util.ConnectorsInfo" %>
<%@page import="com.ibm.commerce.messaging.util.Specification" %>
<%@page import="java.util.Hashtable" %>

<%@include file="../common/common.jsp" %>

<jsp:useBean id="messagingList" scope="request" class="com.ibm.commerce.messaging.databeans.CISEditAttDataBean"></jsp:useBean>
<jsp:useBean id="transportList" scope="request" class="com.ibm.commerce.messaging.databeans.TransportDataBean"></jsp:useBean>
<jsp:useBean id="nlList" scope="request" class="com.ibm.commerce.messaging.databeans.NLCISEditAttDataBean"></jsp:useBean>


<%! Hashtable messagingListNLS = null; %>
<%! Hashtable adminconsoleNLS = null; %>
<%! int numberOfmessagings = 0; %>

<%
   String webalias = UIUtil.getWebPrefix(request);
   String store_id = request.getParameter(MessagingSystemConstants.TC_STORETRANS_STORE_ID);
   String transport_id = request.getParameter(MessagingSystemConstants.TC_STORETRANS_TRANSPORT_ID);
   String profile_id = request.getParameter(MessagingSystemConstants.TC_PROFILE_PROFILE_ID);
   String msgtype_id = request.getParameter(MessagingSystemConstants.TC_PROFILE_MSGTYPE_ID);
   String transport_name = null;
   List namesToMask = new ArrayList();
   
   

   CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);

  try {
      // obtain the resource bundle for display
      messagingListNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.MsgMessagingNLS", cmdContext.getLocale());
      adminconsoleNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", cmdContext.getLocale());

      DataBeanManager.activate(messagingList, request);

      nlList.setNames(messagingList.getNlNames());
      nlList.setCommandContext(cmdContext);
      DataBeanManager.activate(nlList, request);

      if ((transport_id != null) && (!transport_id.equals(""))) transportList.setTransport_ID(new Integer(transport_id));
      DataBeanManager.activate(transportList, request);
      
      // there should only be one element      
      if (transportList.getSize() > 0) {
        transport_name = transportList.getName(0);
        Vector properties = new Vector();
        // Determine which properties to mask.
        Specification connSpecs = ConnectorsInfo.getOutboundConnectionSpecification(Integer.valueOf(transportList.getTransport_ID(0)));
        if (connSpecs != null) {
        	properties.addAll(connSpecs.getProperties());
        }
        
        Specification interSpecs = ConnectorsInfo.getOutboundInteractionSpecification(Integer.valueOf(transportList.getTransport_ID(0)));
        if (interSpecs != null) {
        	if (properties != null) {
        		if (interSpecs.getProperties() != null) {
        			properties.addAll(interSpecs.getProperties());
        		}            	
            } else {
            	properties = interSpecs.getProperties();
            }
        }
                
        if (properties != null) {
        	Iterator iter = properties.iterator();
            while (iter.hasNext()) {
            	Hashtable prop = (Hashtable) iter.next();
            	String encryptProperty = (String) prop.get(Specification.ENCRYPT);
            	if (Specification.ENCRYPT_YES.equalsIgnoreCase(encryptProperty)) {
            		namesToMask.add(prop.get(Specification.ADMIN));
            	}
            }
        }                
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
<TITLE><%= ((profile_id == null) || (profile_id.equals("")))? messagingListNLS.get("messagingTransportConfigurationTitle") : messagingListNLS.get("messagingMsgTypeChangeTitle") %></TITLE>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
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

  if ((profile_id != null) && (!profile_id.equals("")))
    out.println("cancel_url = top.getWebappPath() + 'NewDynamicListView?ActionXMLFile=adminconsole.MsgMessageTransport&cmd=MsgMessageTransportView';");
  else
    out.println("cancel_url = top.getWebappPath() + 'NewDynamicListView?ActionXMLFile=adminconsole.MsgStoreTransport&cmd=MsgStoreTransportView';");

  int selectedLanguageElement = 0;
  boolean bSelectedLanguageId = false;
  if(nlList.getSpecSize()>0) {
    
    out.println("langKey = new Array(" + (nlList.numberOfElements()+1) + ");");
    for(int langCnt=0; langCnt< nlList.numberOfElements(); langCnt++) {
      out.println("langKey["+(langCnt+1)+"] = " + nlList.getLangId(langCnt) + ";");
    }
    
    for(int specCnt=0; specCnt<nlList.getSpecSize(); specCnt++) {
      out.println(nlList.getName(specCnt) + "_value = new Array(" + (nlList.numberOfElements()+1) + ");");
 
      boolean bInitialized = false;
      for (int i=0; !bInitialized && i<messagingList.numberOfElements(); i++){
        if (messagingList.getName(i).equals(nlList.getName(specCnt))) {
           out.println("langKey[0] = 0;");
           String defaultValue = messagingList.getValue(i);
           out.println(nlList.getName(specCnt) + "_value[0] = '" + UIUtil.toJavaScript(defaultValue) + "';");
           bInitialized = true;
        }
      }
      for(int langCnt=0; langCnt< nlList.numberOfElements(); langCnt++) {
        out.println(nlList.getName(specCnt) + "_value[" + (langCnt+1) + "] = '" + UIUtil.toJavaScript(nlList.getValue(nlList.getName(specCnt),langCnt)) + "';");
  	    if (!bSelectedLanguageId &&
  	        nlList.getValue(nlList.getName(specCnt),langCnt) != null &&
  	        nlList.getValue(nlList.getName(specCnt),langCnt).length() != 0) {
  	      selectedLanguageElement = langCnt;
  	      bSelectedLanguageId = true;
  	    } //if
  	  } //for loop
      out.println(nlList.getName(specCnt)+"_previouskey = " + 
                  (bSelectedLanguageId ? (selectedLanguageElement+1) : selectedLanguageElement) + "; ");
    } //for
  } //if

  if(nlList.getSpecSize()>0) {
    for(int specCnt=0; specCnt<nlList.getSpecSize(); specCnt++) {
      out.println("function storeNL"+nlList.getName(specCnt)+"Value(key) {");
      out.println("  " + nlList.getName(specCnt) + "_value[" + nlList.getName(specCnt) + "_previouskey] = messagingForm." + nlList.getName(specCnt) + ".value;");
      out.println("  messagingForm." + nlList.getName(specCnt) + ".value = " + nlList.getName(specCnt) + "_value[key];");
      out.println("  " + nlList.getName(specCnt) + "_previouskey = key;" );
      out.println("}");
  	}
  }

 

  out.println("function convertParametersToXML() {");


    out.println("parent.remove('CSEDITATT');");
    out.println("parent.remove('ISEDITATT');");
    // declare variables
    out.println(" var CSEDITATT = new Object();");
    out.println(" var ISEDITATT = new Object();");

    if(nlList.getSpecSize()>0) {
      out.println("parent.remove('NLSEDITATT');");
      out.println(" var NLSEDITATT = new Object();");
      if ((profile_id != null) && (!profile_id.equals(""))) out.println("NLSEDITATT.profile_id='"+UIUtil.toJavaScript(profile_id)+"';");
    }

    out.println("CSEDITATT.store_id='"+UIUtil.toJavaScript(store_id)+"';");
    out.println("CSEDITATT.transport_id='"+UIUtil.toJavaScript(transport_id)+"';");
    if ((profile_id != null) && (!profile_id.equals(""))) out.println("CSEDITATT.profile_id='"+UIUtil.toJavaScript(profile_id)+"';");
    if ((profile_id != null) && (!profile_id.equals(""))) out.println("ISEDITATT.profile_id='"+UIUtil.toJavaScript(profile_id)+"';");

    int CS_Index = 0;
    int IS_Index = 0;
    String objName = null;
    // assign variable values
    for (int i= 0 ; i < numberOfmessagings ; i++)
    {
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

      if(messagingList.getNLSupport(i).equalsIgnoreCase("true")) {
        out.println( messagingList.getName(i)+"_value[" + "messagingForm."+messagingList.getName(i)+"_select.value" + "]= messagingForm." + messagingList.getName(i) + ".value;");
        if ( messagingList.getOrigin(i).equals("CS") )
          out.println(objName + "." + messagingList.getName(i) + ".cseditatt_id = \"" + messagingList.getID(i) + "\";");
        else
          out.println(objName + "." + messagingList.getName(i) + ".iseditatt_id = \"" + messagingList.getID(i) + "\";");
        out.println(objName + "." + messagingList.getName(i) + ".value = " + messagingList.getName(i)+"_value[0];");
        
        for(int langCnt=0; langCnt< nlList.numberOfElements(); langCnt++) {

          out.println("NLSEDITATT." + messagingList.getName(i) + "_" + langCnt + " = new Object();");
          out.println("NLSEDITATT." + messagingList.getName(i) + "_" + langCnt + ".name = '" + messagingList.getName(i) + "_" + nlList.getLangId(langCnt) + "';");
          out.println("NLSEDITATT." + messagingList.getName(i) + "_" + langCnt + ".nlseditatt_id = \"" + nlList.getID(messagingList.getName(i),langCnt) + "\";");
          out.println("NLSEDITATT." + messagingList.getName(i) + "_" + langCnt + ".value = " + messagingList.getName(i)+"_value["+(langCnt+1)+"];");
        }
        
      } else {
        if ( messagingList.getOrigin(i).equals("CS") )
          out.println(objName + "." + messagingList.getName(i) + ".cseditatt_id = \"" + messagingList.getID(i) + "\";");
        else
          out.println(objName + "." + messagingList.getName(i) + ".iseditatt_id = \"" + messagingList.getID(i) + "\";");
        out.println(objName + "." + messagingList.getName(i) + ".value = messagingForm." + messagingList.getName(i) + ".value;");
      }
    }
    if (CS_Index > 0) out.println("parent.put('CSEDITATT', CSEDITATT);");
    if (IS_Index > 0) out.println("parent.put('ISEDITATT', ISEDITATT);");
    if(nlList.getSpecSize()>0) {
      out.println("parent.put('NLSEDITATT', NLSEDITATT);");
    }
    out.println("return true;");

  out.println("}");

  if ((profile_id != null) && (!profile_id.equals("")))  {

   out.println("function validatePanelData() {");

   out.println("var PROFILE = new Object();");
   out.println("PROFILE."+MessagingSystemConstants.TC_PROFILE_STORE_ID+"='"+UIUtil.toJavaScript(store_id)+"';");
   out.println("PROFILE."+MessagingSystemConstants.TC_PROFILE_TRANSPORT_ID+"='"+UIUtil.toJavaScript(transport_id)+"';");
   out.println("PROFILE."+MessagingSystemConstants.TC_PROFILE_PROFILE_ID+"='"+UIUtil.toJavaScript(profile_id)+"';");
   if ((msgtype_id == null) || (msgtype_id.equals("")))
    out.println("PROFILE."+MessagingSystemConstants.TC_PROFILE_MSGTYPE_ID+" = parent.getPanelAttribute('messagingMsgTypeChangeGeneralPrompt','"+MessagingSystemConstants.TC_PROFILE_MSGTYPE_ID+"');");
   else
   out.println("PROFILE."+MessagingSystemConstants.TC_PROFILE_MSGTYPE_ID+" = '"+UIUtil.toJavaScript(msgtype_id)+"';");
   out.println("PROFILE."+MessagingSystemConstants.TC_PROFILE_DEVICEFORMAT_ID+" = parent.getPanelAttribute('messagingMsgTypeChangeGeneralPrompt','"+MessagingSystemConstants.TC_PROFILE_DEVICEFORMAT_ID+"');");
   out.println("PROFILE."+MessagingSystemConstants.TC_PROFILE_LOWPRIORITY+" = parent.getPanelAttribute('messagingMsgTypeChangeGeneralPrompt','"+MessagingSystemConstants.TC_PROFILE_LOWPRIORITY+"');");
   out.println("PROFILE."+MessagingSystemConstants.TC_PROFILE_HIGHPRIORITY+" = parent.getPanelAttribute('messagingMsgTypeChangeGeneralPrompt','"+MessagingSystemConstants.TC_PROFILE_HIGHPRIORITY+"');");
   out.println("PROFILE."+MessagingSystemConstants.TC_PROFILE_ARCHIVE+" = parent.getPanelAttribute('messagingMsgTypeChangeGeneralPrompt','"+MessagingSystemConstants.TC_PROFILE_ARCHIVE+"');");
   out.println("parent.put('PROFILE', PROFILE);");
   out.println("return convertParametersToXML();");

    out.println("}");
  }
  else {
   out.println("function validatePanelData() {");
   out.println("	return convertParametersToXML();");
   out.println("}");   
  }
%>

function loadPanelData()
 {
  if (parent.setContentFrameLoaded)
   {
    parent.setContentFrameLoaded(true);
   }
   
   var authToken = parent.get("authToken");
   if (defined(authToken)) {
	parent.addURLParameter("authToken", authToken);	  
   }
 }

function savePanelData()
{
	parent.addURLParameter("authToken", "${authToken}");
}
// -->
</script>

</HEAD>
<BODY ONLOAD="loadPanelData()"  class="content">
<H1><%= ((profile_id == null) || (profile_id.equals(""))) ? messagingListNLS.get("messagingTransportConfigurationPrompt"):messagingListNLS.get("messagingMsgTypeChangePrompt")%></H1>


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
%>
<table class="list" width="75%"
summary="<%= ((profile_id == null) || (profile_id.equals(""))) ? messagingListNLS.get("messagingTransportConfigureTableDesc") : messagingListNLS.get("messagingMsgTypeChangeTableDesc") %>">

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

    for (int i= 0 ; i<endIndex ; i++)
    {    	
%>

<TR class=<%=classId%>>
<TD class="list_info1" align="left" id="row<%=i%>" headers="col1">
<nobr>&nbsp;<LABEL for="input<%=i%>"><%= (messagingListNLS.get(messagingList.getName(i)) != null)? messagingListNLS.get(messagingList.getName(i)): messagingList.getName(i) %></LABEL>&nbsp;</nobr>
</TD>
<TD class="list_info1" align="left" headers="col2 row<%=i%>">
&nbsp;<INPUT NAME="<%= messagingList.getName(i) %>" VALUE="<%

    if (messagingList.getNLSupport(i).equalsIgnoreCase("true") &&
        bSelectedLanguageId) {
      out.print(UIUtil.toHTML(nlList.getValue(messagingList.getName(i),selectedLanguageElement)));
    } else if (namesToMask.contains(messagingList.getName(i))) {
      out.print(UIUtil.toHTML(messagingList.getValue(i)) + "\" type=\"password");
    } else {
      out.print(UIUtil.toHTML(messagingList.getValue(i)));
    }

%>" SIZE="50" id="input<%=i%>">&nbsp;
<% if(messagingList.getNLSupport(i).equalsIgnoreCase("true")) { %>
<label for="input<%=i%>_options" class="hidden-label"><%=messagingListNLS.get("Options")%></label>
<SELECT
	name="<%=messagingList.getName(i)%>_select" id="input<%=i%>_options" onchange="storeNL<%=messagingList.getName(i)%>Value(value);">
	<OPTION value="0"></OPTION>
<% for(int langCnt=0; langCnt< nlList.numberOfElements(); langCnt++) { %>
	<OPTION value="<%=(langCnt+1)%>" <%
	if (bSelectedLanguageId &&
	    langCnt == selectedLanguageElement) {
		out.print("SELECTED");
	}
	%>><%=nlList.getDescription(langCnt)%></OPTION>
<% } %>
</SELECT>
<% } %>
</TD>
</TR>

<%
      if (classId.equals("list_row1"))
        classId="list_row2";
      else
        classId="list_row1";
    }
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
</BODY>
</HTML>
