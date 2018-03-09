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
<%@page import="com.ibm.commerce.messaging.databeans.StoreTransDataBean" %>
<%@page import="com.ibm.commerce.messaging.util.MessagingSystemConstants" %>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>


<%@include file="../common/common.jsp" %>
<%@include file="../common/List.jsp" %>

<jsp:useBean id="messagingList" scope="request" class="com.ibm.commerce.messaging.databeans.StoreTransDataBean">
</jsp:useBean>

<%! Hashtable messagingListNLS = null; %>
<%! int numberOfStoreTransports = 0; %>

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

   } catch (ECSystemException ecSysEx) {
    ExceptionHandler.displayJspException(request, response, ecSysEx);
   } catch (Exception exc) {
    //ECSystemException ecSysEx = new ECSystemException(null,exc.getMessage(),null);
    ExceptionHandler.displayJspException(request, response, exc);
   }

   if (messagingList != null)
   {
     numberOfStoreTransports = messagingList.getSize();
   }
%>

<HTML>
<HEAD>
<%= fHeader%>
<LINK rel=stylesheet href="<%=webalias%>tools/common/centre.css" type="text/css">
<TITLE><%= messagingListNLS.get("messagingTransportTitle") %></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

function getResultsSize() { 
     return <%= numberOfStoreTransports  %>; 
}

    function addStoreTransport()
    {
      var url = top.getWebappPath() + "NewDynamicListView?ActionXMLFile=adminconsole.MsgStoreTransportAdd&cmd=MsgStoreTransportAddView&listsize=20&startindex=0&refnum=0&<%=MessagingSystemConstants.TC_STORETRANS_STORE_ID%>=<%=store_id%>";
      if (top.setContent)
      {
          top.setContent("<%= UIUtil.toJavaScript((String)messagingListNLS.get("messagingTransportAddTitle")) %>",
            url,
            true);
      }
      else
      {
          parent.location.replace(url);
      }
    }

    function configureStoreTransport()
    {

      var url = top.getWebappPath() + "DialogView?XMLFile=adminconsole.MsgStoreTransportConfig";

      var checked = parent.getChecked();
      if (checked.length > 0)
      {
        if ( checked[0] == "select_deselect" ) {
          window.alert("<%= UIUtil.toJavaScript((String)messagingListNLS.get("messagingTransportConfigureNote")) %>");
          return;
        }
        url += "&amp;<%=MessagingSystemConstants.TC_STORETRANS_STORE_ID%>=<%=store_id%>&amp;<%=MessagingSystemConstants.TC_STORETRANS_TRANSPORT_ID%>=" +  checked[0];
      }
      else {
        return;
      }
      if (top.setContent)
      {
        top.setContent("<%= UIUtil.toJavaScript((String)messagingListNLS.get("messagingTransportConfigurationTitle")) %>",
                       url,
                       true);
      }
      else
      {
        parent.location.replace(url);
      }
  }
    
  function configureStoreTransportBySelect(item) {
      var url = top.getWebappPath() + "DialogView?XMLFile=adminconsole.MsgStoreTransportConfig";
      url += "&amp;<%=MessagingSystemConstants.TC_STORETRANS_STORE_ID%>=<%=store_id%>&amp;<%=MessagingSystemConstants.TC_STORETRANS_TRANSPORT_ID%>=" +  item;
      if (top.setContent)
        {
          top.setContent("<%= UIUtil.toJavaScript((String)messagingListNLS.get("messagingTransportConfigurationTitle")) %>",
                         url,
                         true);
        }
        else
        {
          parent.location.replace(url);
        }  
  }

  function activate_deactivateStoreTransport() {

      var checked = parent.getChecked();
      // verify that a profile is selected
      if ( checked.length > 0 ) {
      // confirm the delete
      // build URL string

        var deleteParm = "";
        var i = 0;
        if (checked.length > 0) {
          // set the first element (if select_deselect -- more than one)
          if ( checked[i] != "select_deselect" ) {
            deleteParm += checked[i];
          }
          else {
            i = 1;
            if ( checked.length > 1)
              deleteParm += checked[i];
            else {
              window.alert("<%= UIUtil.toJavaScript((String)messagingListNLS.get("messagingTransportChangeStatusNote")) %>");
              return;
            }
          }
          i++;
          for(;i<checked.length;i++) {
            deleteParm = deleteParm + "," + checked[i];
          }
        }
        else {
          return;
        }

        document.forms["updateStatusForm"].elements["<%=MessagingSystemConstants.TC_STORETRANS_TRANSPORT_ID%>"].value = deleteParm;
        document.forms["updateStatusForm"].submit();
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
   if (endIndex > numberOfStoreTransports){
      endIndex = numberOfStoreTransports;
   }
   int totalsize = numberOfStoreTransports;
   int totalpage = totalsize/listSize;
	
%>
<%=com.ibm.commerce.tools.common.ui.taglibs.comm.addControlPanel("adminconsole.MsgStoreTransport", totalpage, totalsize, cmdContext.getLocale() )%>
<FORM NAME="messagingForm">
<%
   if (numberOfStoreTransports > 0) {
%>
<%=addHiddenVars()%>
<INPUT TYPE="hidden" NAME="<%=MessagingSystemConstants.TC_STORETRANS_STORE_ID%>" VALUE="<%=store_id%>">
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistTable((String)messagingListNLS.get("messagingTransportTableDesc")) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRowHeading() %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheckHeading() %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)messagingListNLS.get("messagingTransportNameColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)messagingListNLS.get("messagingTransportDescriptionColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)messagingListNLS.get("messagingTransportStatusColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>

<%
    int rowselect=1;
    String chkbox_name = null;
    for (int i=getStartIndex(); i<endIndex ; i++)
    {
    	if (messagingList.getTransportImplemented(i).equals("Y")) {
    		chkbox_name = messagingList.getTransport_ID(i);
%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRow(rowselect) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheck(chkbox_name, "none" ) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML((messagingListNLS.get(messagingList.getTransportName(i)) != null)? (String)messagingListNLS.get(messagingList.getTransportName(i)) : messagingList.getTransportName(i)), "javascript:configureStoreTransportBySelect('"+ chkbox_name +"');" ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML((messagingListNLS.get(messagingList.getTransportDescription(i)) != null)? (String)messagingListNLS.get(messagingList.getTransportDescription(i)) : messagingList.getTransportDescription(i)), "none" ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML((messagingList.getActive(i).equals("1"))?(String)messagingListNLS.get("messagingTransportStatusActiveText"):(String)messagingListNLS.get("messagingTransportStatusInactiveText")), "none" ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>
<%
         if(rowselect==1)
         {
           rowselect = 2;
         } else {
           rowselect = 1;
         }
       } //if
    } //for
%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistTable() %>
<%
   } else {
     out.println("<p>&nbsp;</p><p><blockquote>");
     out.println(messagingListNLS.get("messagingTransportNoAvail"));
     out.println("</blockquote></p>");
   }
   
%>
</FORM>

<form name="updateStatusForm" action="StoreTransUpdate" target="_parent" method="POST">
	<input type="hidden" name="URL" value="NewDynamicListView?ActionXMLFile=adminconsole.MsgStoreTransport&amp;cmd=MsgStoreTransportView&amp;listsize=20&amp;startindex=0&amp;refnum=0&amp;<%=MessagingSystemConstants.TC_STORETRANS_STORE_ID%>=<%=store_id%>"/>
	<input type="hidden" name="<%=MessagingSystemConstants.TC_STORETRANS_TRANSPORT_ID%>"/>
	<input type="hidden" name="<%=MessagingSystemConstants.TC_STORETRANS_STORE_ID%>" value="<%=store_id%>"/>
	<input type="hidden" name="authToken" value="${authToken}"/
</form>

<SCRIPT LANGUAGE="JavaScript">
<!--
          parent.afterLoads();
          parent.setResultssize(getResultsSize());
// -->
</SCRIPT>
</BODY>
</HTML>
