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
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.messaging.databeans.StoreTransDataBean" %>
<%@page import="com.ibm.commerce.messaging.databeans.TransportDataBean" %>
<%@page import="com.ibm.commerce.messaging.util.MessagingSystemConstants" %>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>

<%@include file="../common/common.jsp" %>
<%@include file="../common/List.jsp" %>

<jsp:useBean id="messagingTransport" scope="request" class="com.ibm.commerce.messaging.databeans.TransportDataBean"></jsp:useBean>
<jsp:useBean id="messagingStoreTrans" scope="request" class="com.ibm.commerce.messaging.databeans.StoreTransDataBean"></jsp:useBean>

<%! Hashtable messagingListNLS = null; %>
<%! int numberOfTransports = 0; %>
<%! String[] availableTransId = null; %>
<%! String[] availableTransName = null; %>
<%! String[] availableTransDesc = null; %>

<%
    String webalias = UIUtil.getWebPrefix(request);

    CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Integer store_id = cmdContext.getStoreId();
    try {
      // obtain the resource bundle for display
      messagingListNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.MsgMessagingNLS", getLocale());

      messagingStoreTrans.setStore_ID(store_id);
      DataBeanManager.activate(messagingStoreTrans, request);
      DataBeanManager.activate(messagingTransport, request);

   } catch (ECSystemException ecSysEx) {
      ExceptionHandler.displayJspException(request, response, ecSysEx);
   } catch (Exception exc) {
      //ECSystemException ecSysEx = new ECSystemException(null,exc.getMessage(),null);
      ExceptionHandler.displayJspException(request, response, exc);
   }

    if (messagingTransport != null && messagingStoreTrans != null)
    {
        Hashtable existStoreTrans = new Hashtable();
        for (int i = 0; i < messagingStoreTrans.getSize(); i++) {
            existStoreTrans.put(messagingStoreTrans.getTransport_ID(i), messagingStoreTrans.getTransportName(i));
        }
        Vector availableName = new Vector();
        Vector availableId = new Vector();
        Vector availableDesc = new Vector();
        for (int i = 0; i < messagingTransport.getSize(); i++) {
          if (messagingTransport.getImplemented(i).equals("Y")) {
              String id = messagingTransport.getTransport_ID(i);
              if (existStoreTrans.get(id) == null) {
                 availableId.addElement(id);
                 availableName.addElement(messagingTransport.getName(i));
                 availableDesc.addElement(messagingTransport.getDescription(i));
              }
          }
        }
        numberOfTransports = availableId.size();

        availableTransId = new String[numberOfTransports];
        availableTransName = new String[numberOfTransports];
        availableTransDesc = new String[numberOfTransports];

        availableId.copyInto(availableTransId);
        availableName.copyInto(availableTransName);
        availableDesc.copyInto(availableTransDesc);
    }
%>

<HTML>
<HEAD>
<%= fHeader%>
<LINK rel=stylesheet href="<%=webalias%>tools/common/centre.css" type="text/css">
<TITLE><%= messagingListNLS.get("messagingTransportAddTitle") %></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

function getResultsSize() { 
     return <%= numberOfTransports  %>; 
}

function okStoreTransportAdd() {
    var url = top.getWebappPath() + "StoreTransCreate?";
    var params = "URL=" + "MsgMessagingSystemResponseView&amp;<%=MessagingSystemConstants.TC_STORETRANS_STORE_ID%>=<%=store_id%>&amp;<%=MessagingSystemConstants.TC_STORETRANS_ACTIVE%>=1";
    var checked = parent.getChecked();

    var addParm = "";
    var i = 0;
    if (checked.length > 0) {
          // set the first element (if select_deselect -- more than one)
          if ( checked[i] != "select_deselect" )
            addParm = "<%=MessagingSystemConstants.TC_STORETRANS_TRANSPORT_ID%>=" + checked[i];
          else {
            i = 1;
            if ( checked.length > 1)
              addParm = "<%=MessagingSystemConstants.TC_STORETRANS_TRANSPORT_ID%>=" + checked[i];
            else {
              window.alert("<%= UIUtil.toJavaScript((String)messagingListNLS.get("messagingTransportAddNote")) %>");
              return;
            }
          }
          // increment i
          i++;
          for(; i < checked.length; i++) {
            if ( checked[i] != "select_deselect" )
                addParm = addParm + "," + checked[i];
          }
          // go to the url
          url = url + addParm + "&amp;" + params;
    } else {
          return;
    }
    // parent because the title on top should not change
    parent.location.replace(url);
}

function cancelStoreTransportAdd() {

	if (top.goBack)
        {
          top.goBack();
        }
        else
        {
          var url = top.getWebappPath() + "NewDynamicListView?ActionXMLFile=adminconsole.MsgStoreTransport&amp;cmd=MsgStoreTransportView&amp;listsize=20&amp;startindex=0&amp;refnum=0&amp;<%=MessagingSystemConstants.TC_STORETRANS_STORE_ID%>=<%=store_id%>";
          parent.location.replace(url);
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
   if (endIndex > numberOfTransports){
      endIndex = numberOfTransports;
   }
   int totalsize = numberOfTransports;
   int totalpage = totalsize/listSize;
	
%>
<%=com.ibm.commerce.tools.common.ui.taglibs.comm.addControlPanel("adminconsole.MsgStoreTransportAdd", totalpage, totalsize, cmdContext.getLocale() )%>
<FORM NAME="messagingForm">
<INPUT TYPE="hidden" NAME="<%=MessagingSystemConstants.TC_STORETRANS_STORE_ID%>" VALUE="<%=store_id%>">
<%
  if (availableTransName.length > 0) {
%>
<%=addHiddenVars()%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistTable((String)messagingListNLS.get("messagingTransportAddTableDesc")) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRowHeading() %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheckHeading() %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)messagingListNLS.get("messagingTransportAddNameColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)messagingListNLS.get("messagingTransportDescriptionColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>
<!-- Need to have a for loop to lookfor all the member groups -->
<%
    int rowselect=1;
    String chkbox_name = null;

    for (int i=getStartIndex(); i<endIndex ; i++)
    {
      chkbox_name = availableTransId[i];
%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRow(rowselect) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheck(chkbox_name, "none" ) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML((messagingListNLS.get(availableTransName[i]) != null)? (String)messagingListNLS.get(availableTransName[i]) : availableTransName[i]), "none" ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML((messagingListNLS.get(availableTransDesc[i]) != null)? (String)messagingListNLS.get(availableTransDesc[i]) : availableTransDesc[i]), "none" ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>
<%
      if(rowselect==1)
      {
        rowselect = 2;
      } else {
        rowselect = 1;
      }
   } //for
  } else {
      out.println("<p>&nbsp;</p><p><blockquote>");
      out.println(messagingListNLS.get("messagingTransportAddNoAvail"));
      out.println("</blockquote></p>");
  }
%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistTable() %>
</FORM>
<SCRIPT LANGUAGE="JavaScript">
<!--
   parent.afterLoads();
   parent.setResultssize(getResultsSize());

// -->
</SCRIPT>
</BODY>
</HTML>
