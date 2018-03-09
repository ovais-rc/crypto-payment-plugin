<!--********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* WebSphere Commerce
*
* (c) Copyright IBM Corp. 2000, 2002
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------
*-->
<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.messaging.databeans.ProfileDataBean" %>
<%@page import="com.ibm.commerce.messaging.databeans.StoreTransDataBean" %>
<%@page import="com.ibm.commerce.messaging.util.MessagingSystemConstants" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="java.util.Hashtable" %>


<%@include file="../common/common.jsp" %>
<%@include file="../common/List.jsp" %>

<jsp:useBean id="messagingList" scope="request" class="com.ibm.commerce.messaging.databeans.ProfileDataBean">
</jsp:useBean>
<jsp:useBean id="storeTransList" scope="request" class="com.ibm.commerce.messaging.databeans.StoreTransDataBean">
</jsp:useBean>

<%! Hashtable messagingListNLS = null; %>
<%! int numberOfMessageTransports = 0; %>

<%
  String webalias = UIUtil.getWebPrefix(request);
  Integer store_id = null;
  CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
  store_id = cmdContext.getStoreId();

	try {
      // obtain the resource bundle for display
      messagingListNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.MsgMessagingNLS", getLocale());

      messagingList.setStore_ID(store_id);
      DataBeanManager.activate(messagingList, request);
      storeTransList.setStore_ID(store_id);
      DataBeanManager.activate(storeTransList, request);

   } catch (ECSystemException ecSysEx) {
    ExceptionHandler.displayJspException(request, response, ecSysEx);
   } catch (Exception exc) {
    //ECSystemException ecSysEx = new ECSystemException(null,exc.getMessage(),null);
    ExceptionHandler.displayJspException(request, response, exc);
   }

   if (messagingList != null)
   {
     numberOfMessageTransports = messagingList.getSize();
   }
%>

<HTML>
<HEAD>
<%= fHeader%>
<LINK rel=stylesheet href="<%=webalias%>tools/common/centre.css" type="text/css">
<TITLE><%= messagingListNLS.get("messagingMsgTypeTitle") %></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

function getResultsSize() { 
     return <%= numberOfMessageTransports  %>; 
}

    function newMessageTransport()
    {
      var url = top.getWebappPath() + "WizardView?XMLFile=adminconsole.MsgMessageTransportWizard&amp;<%=MessagingSystemConstants.TC_PROFILE_STORE_ID%>=<%=store_id%>&amp;<%=MessagingSystemConstants.TC_PROFILE_PROFILE_ID%>=<%=MessagingSystemConstants.NEW_PROFILE_PROFILE_ID_VALUE%>";

      if (top.setContent)
      {
        top.setContent("<%= UIUtil.toJavaScript((String) messagingListNLS.get("messagingMsgTypeAddBCTTitle")) %>",
                       url,
                       true);
      }
      else
      {
        parent.location.replace(url);
      }
    }

    function changeMessageTransport()
    {
      var url = top.getWebappPath() + "WizardView?XMLFile=adminconsole.MsgMessageTransportWizard&amp;<%=MessagingSystemConstants.TC_PROFILE_STORE_ID%>=<%=store_id%>";

      var checked = parent.getChecked();
      if (checked.length > 0)
        {
          if ( checked[0] == "select_deselect" ) {
            alertDialog("<%= UIUtil.toJavaScript((String) messagingListNLS.get("messagingTransportConfigureNote")) %>");
            return;
          }
          url += "&amp;" +  checked[0];
        }
      else {
        return;
      }
      if (top.setContent)
        {
          top.setContent("<%= UIUtil.toJavaScript((String)messagingListNLS.get("messagingMsgTypeEditBCTTitle")) %>",
                         url,
                         true);
        }
        else
        {
          parent.location.replace(url);
        }

    }
    
  function changeMessageTransportBySelect(item)
  {
  	var url = top.getWebappPath() + "WizardView?XMLFile=adminconsole.MsgMessageTransportWizard&amp;<%=MessagingSystemConstants.TC_PROFILE_STORE_ID%>=<%=store_id%>";
  	url += "&amp;" +  item;
  	
  	if (top.setContent)
        {
          top.setContent("<%= UIUtil.toJavaScript((String)messagingListNLS.get("messagingMsgTypeEditBCTTitle")) %>",
                         url,
                         true);
        }
        else
        {
          parent.location.replace(url);
        }
  }

  function deleteMessageTransport() {

		var checked = parent.getChecked();
		// verify that a profile is selected
		if ( checked.length > 0 ) {
			// confirm the delete
      if ( confirmDialog('<%= UIUtil.toJavaScript((String)messagingListNLS.get("messagingMsgTypeDeleteQuestion")) %>') ) {
				// build URL string

        var url = top.getWebappPath() + "MessagingProfileDelete?"
        var params = "URL=" + top.getWebappPath() + "NewDynamicListView?ActionXMLFile=adminconsole.MsgMessageTransport&amp;cmd=MsgMessageTransportView&amp;listsize=20&amp;startindex=0&amp;refnum=0";

        var deleteParm = "";
        var i = 0;
        if (checked.length > 0) {
          // set the first element (if select_deselect -- more than one)
          if ( checked[i] != "select_deselect" )
            deleteParm = checked[i];
          else {
            i = 1;
            if ( checked.length > 1)
              deleteParm = checked[i];
            else {
              alertDialog('<%= UIUtil.toJavaScript((String)messagingListNLS.get("messagingMsgTypeDeleteNote")) %>');
              return;
            }
          }
        }
        // increment i
        i++;
        for(; i < checked.length; i++) {
					if ( checked[i] != "select_deselect" )
            deleteParm = deleteParm + "&amp;" + checked[i];
        }
				// go to the url
        url = url + deleteParm + "&amp;" + params
        + '&authToken=' + encodeURI('${authToken}');
				// parent because the title on top should not change
        parent.location.replace(url);
			}
		}
	}

    function onLoad()
    {
      parent.loadFrames()
    }

    function getRefNum()
    {
      return <%= getRefNum() %>
    }
// -->
</script>

<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/dynamiclist.js"></SCRIPT>
</HEAD>
<BODY ONLOAD="onLoad()">
<%
          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));
	  int endIndex = getStartIndex() + getListSize();
    	  if (endIndex > numberOfMessageTransports)
      		endIndex = numberOfMessageTransports;
          int totalsize = numberOfMessageTransports;
          int totalpage = totalsize/listSize;
	
%>
<%=com.ibm.commerce.tools.common.ui.taglibs.comm.addControlPanel("adminconsole.MsgMessageTransport", totalpage, totalsize, cmdContext.getLocale() )%>

<FORM NAME="messagingForm">
<%

  if (numberOfMessageTransports > 0) {

%>

<%=addHiddenVars()%>
<INPUT TYPE='hidden' NAME='name' VALUE=''>
<INPUT TYPE='hidden' NAME='description' VALUE=''>

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistTable((String)messagingListNLS.get("messagingMsgTypeTableDesc")) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRowHeading() %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheckHeading() %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)messagingListNLS.get("messagingMsgTypeMsgTypeColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)messagingListNLS.get("messagingMsgTypeMsgSeverityColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)messagingListNLS.get("messagingMsgTypeMsgTransportColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)messagingListNLS.get("messagingTransportStatusColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>

<%
    int rowselect=1;
    String chkbox_name = null;
    Hashtable hshStoreTrans = new Hashtable();
    for (int j=0; j < storeTransList.getSize(); j++) {
        hshStoreTrans.put(storeTransList.getTransport_ID(j),storeTransList.getActive(j));
    }

    for (int i=getStartIndex(); i<endIndex ; i++)
    {
    	chkbox_name = MessagingSystemConstants.TC_PROFILE_PROFILE_ID + "=" + messagingList.getProfile_ID(i) + "&amp;" + MessagingSystemConstants.TC_PROFILE_TRANSPORT_ID + "=" + messagingList.getTransport_ID(i) + "&amp;" + MessagingSystemConstants.TC_PROFILE_MSGTYPE_ID + "=" + messagingList.getMsgType_ID(i) + "&amp;" + MessagingSystemConstants.TC_PROFILE_DEVICEFORMAT_ID + "=" + messagingList.getDeviceFormat_ID(i) + "&amp;" + MessagingSystemConstants.TC_PROFILE_LOWPRIORITY + "=" + messagingList.getLowPriority(i) + "&amp;" + MessagingSystemConstants.TC_PROFILE_HIGHPRIORITY + "=" + messagingList.getHighPriority(i) + "&amp;" + MessagingSystemConstants.TC_PROFILE_ARCHIVE + "=" + messagingList.getArchive(i);
    	String transportName = messagingList.getTransportName(i);
    	String transportId = messagingList.getTransport_ID(i);
    	String status = (String) hshStoreTrans.get(transportId);
%>

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRow(rowselect) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheck(chkbox_name, "none" ) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML((messagingListNLS.get(messagingList.getMsgTypeName(i)) != null)? (String)messagingListNLS.get(messagingList.getMsgTypeName(i)) : messagingList.getMsgTypeName(i)), "javascript:changeMessageTransportBySelect('"+ chkbox_name +"');" ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(messagingList.getLowPriority(i) + " - " + messagingList.getHighPriority(i)), "none" ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML((messagingListNLS.get(transportName) != null) ? (String) messagingListNLS.get(transportName) : transportName), "none" ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(status != null && (status.equals("1"))?(String)messagingListNLS.get("messagingTransportStatusActiveText"):(String)messagingListNLS.get("messagingTransportStatusInactiveText")), "none" ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>

<%
if(rowselect==1)
   {
     rowselect = 2;
   }else{
     rowselect = 1;
   }
}
%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistTable() %>

<%
    }
    else {
      out.println("<p>&nbsp;</p><p><blockquote>");
      out.println(messagingListNLS.get("messagingMsgTypeNoAvail"));
      out.println("</blockquote></p>");
    }
%>

</FORM>
<SCRIPT LANGUAGE="JavaScript">
<!--
          parent.afterLoads();
          parent.setResultssize(getResultsSize());

// -->
</SCRIPT>
</BODY>
</HTML>
