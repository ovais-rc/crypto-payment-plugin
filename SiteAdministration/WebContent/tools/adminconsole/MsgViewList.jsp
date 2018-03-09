<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
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
<%@page import="com.ibm.commerce.messaging.util.MessagingSystemConstants" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>


<%@include file="../common/common.jsp" %>
<%@include file="../common/List.jsp" %>

<jsp:useBean id="msgViewList" scope="request" class="com.ibm.commerce.messaging.databeans.MsgViewDataBean">
</jsp:useBean>

<%! Hashtable messagingListNLS = null; %>
<%! int numberOfMessageTransports = 0; %>

<%

  String webalias = UIUtil.getWebPrefix(request);
//  Integer store_id = null;
  CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
  Integer store_id = cmdContext.getStoreId();
  Integer table = new Integer(request.getParameter(MessagingSystemConstants.MSG_VIEW_TABLE));
	try {
      // obtain the resource bundle for display
      messagingListNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.MsgMessagingNLS", getLocale());
      if(store_id.intValue()!=0) {
      	msgViewList.setStore_id(store_id);
      } else {
        msgViewList.setStore_id(null);
      }
      msgViewList.setTransport_id(new Integer(request.getParameter(MessagingSystemConstants.MSG_VIEW_TRANSPORT_ID)));
      msgViewList.setStart_msgid(new Long(0));
      msgViewList.setTable(table);
      if(table.intValue()==1) {
         msgViewList.setMsgStatus(new Integer(request.getParameter("delivery")));
      }
      DataBeanManager.activate(msgViewList, request);

   } catch (ECSystemException ecSysEx) {
    ExceptionHandler.displayJspException(request, response, ecSysEx);
   } catch (Exception exc) {
    //ECSystemException ecSysEx = new ECSystemException(null,exc.getMessage(),null);
    ExceptionHandler.displayJspException(request, response, exc);
   }

   if (msgViewList != null)
   {
     numberOfMessageTransports = msgViewList.getSize();
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


    function resendMsg()
    {
      var url = top.getWebappPath() + "DialogView?XMLFile=adminconsole.MsgArchiveDetail&amp;<%=MessagingSystemConstants.MSG_VIEW_STORE_ID%>=<%=store_id%>&amp;<%=MessagingSystemConstants.MSG_VIEW_PROFILE_ID%>=-1";
	url += "&amp;<%=MessagingSystemConstants.MSG_VIEW_TRANSPORT_ID%>=<%=msgViewList.getTransportId()%>&amp;<%=MessagingSystemConstants.MSG_VIEW_TABLE%>=<%=table.toString()%>";
      var checked = parent.getChecked();

      if (checked.length > 0)
        {
          if ( checked[0] == "select_deselect" ) {
            alertDialog("<%= UIUtil.toJavaScript((String) messagingListNLS.get("messagingTransportConfigureNote")) %>");
            return;
          }
          url += "&amp;<%=MessagingSystemConstants.MSG_VIEW_MSG_ID%>=" +  checked[0];
        }
      else {
        return;
      }
      if (top.setContent)
        {
          top.setContent("<%= UIUtil.toJavaScript((String)messagingListNLS.get("messagingMsgArchiveConfigTitle")) %>",
                         url,
                         true);
        }
        else
        {
          parent.location.replace(url);
        }

    }
    
  function resendMsgBySelect(item)
  {
  	var url = top.getWebappPath() + "DialogView?XMLFile=adminconsole.MsgArchiveDetail&amp;<%=MessagingSystemConstants.MSG_VIEW_STORE_ID%>=<%=store_id%>&amp;<%=MessagingSystemConstants.MSG_VIEW_PROFILE_ID%>=-1";
  	url += "&amp;<%=MessagingSystemConstants.MSG_VIEW_MSG_ID%>=" +  item;
	url += "&amp;<%=MessagingSystemConstants.MSG_VIEW_TRANSPORT_ID%>=<%=msgViewList.getTransportId()%>&amp;<%=MessagingSystemConstants.MSG_VIEW_TABLE%>=<%=table.toString()%>";
  	
  	if (top.setContent)
        {
          top.setContent("<%= UIUtil.toJavaScript((String)messagingListNLS.get("messagingMsgArchiveConfigTitle")) %>",
                         url,
                         true);
        }
        else
        {
          parent.location.replace(url);
        }
  }

  function researchMsg()
  {
<% if(table.intValue()==0) { %>
  	var url = top.getWebappPath() + "DialogView?XMLFile=adminconsole.MsgArchiveDisplayFilter";
//    top.setContent("<%= UIUtil.toJavaScript((String)messagingListNLS.get("messagingMsgArchiveSearchTitle")) %>",
//                    url,
//                    false);
    top.goBack(1);
<% } else if(table.intValue()==1) { %>
	var url = top.getWebappPath() + "DialogView?XMLFile=adminconsole.MsgStoreDisplayFilter";
//    top.setContent("<%= UIUtil.toJavaScript((String)messagingListNLS.get("messagingMsgStoreSearchTitle")) %>",
//                    url,
//                    false);
    top.goBack(1);
<% } %>
  }


  function deleteMsg() {

		var checked = parent.getChecked();
		// verify that a profile is selected
		if ( checked.length > 0 ) {
			// confirm the delete
      if ( confirmDialog('<%= UIUtil.toJavaScript((String)messagingListNLS.get("messagingMsgViewDeleteQuestion")) %>') ) {
				// build URL string

        var url = top.getWebappPath() + "DeleteMsgFromStorage?"
        
        <% if(table.intValue()==0) { %>
           var params = "URL=" + top.getWebappPath() + "NewDynamicListView?ActionXMLFile=adminconsole.MsgArchiveListFromFind&amp;cmd=AwaitingMsgStoreDisplayFilterView&amp;listsize=20&amp;startindex=0&amp;refnum=0&amp;delivery=<%=UIUtil.toJavaScript(request.getParameter("delivery"))%>&amp;<%=MessagingSystemConstants.MSG_VIEW_TRANSPORT_ID%>=<%=msgViewList.getTransportId()%>&amp;<%=MessagingSystemConstants.MSG_VIEW_TABLE%>=<%=table.toString()%>&amp;<%=MessagingSystemConstants.MSG_VIEW_PROFILE_ID%>=-1";
        <% } else if(table.intValue()==1) { %>
           var params = "URL=" + top.getWebappPath() + "NewDynamicListView?ActionXMLFile=adminconsole.MsgStoreListFromFind&amp;cmd=AwaitingMsgStoreDisplayFilterView&amp;listsize=20&amp;startindex=0&amp;refnum=0&amp;delivery=<%=UIUtil.toJavaScript(request.getParameter("delivery"))%>&amp;<%=MessagingSystemConstants.MSG_VIEW_TRANSPORT_ID%>=<%=msgViewList.getTransportId()%>&amp;<%=MessagingSystemConstants.MSG_VIEW_TABLE%>=<%=table.toString()%>&amp;<%=MessagingSystemConstants.MSG_VIEW_PROFILE_ID%>=-1";
        <% } %>
        var deleteParm = "<%=MessagingSystemConstants.MSG_VIEW_MSG_ID%>=";
        var i = 0;
        if (checked.length > 0) {
          // set the first element (if select_deselect -- more than one)
          if ( checked[i] != "select_deselect" )
            deleteParm += checked[i];
          else {
            i = 1;
            if ( checked.length > 1)
              deleteParm += checked[i];
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
            deleteParm = deleteParm + "," + checked[i];
        }
				// go to the url
        url = url + deleteParm + "&amp;" + params;
				// parent because the title on top should not change
        parent.location.replace(url);
			}
		}	}

  function incrementRetries() {

		var checked = parent.getChecked();
		// verify that a profile is selected
		if ( checked.length > 0 ) {
			// confirm the delete
      if ( confirmDialog('<%= UIUtil.toJavaScript((String)messagingListNLS.get("messagingMsgViewIncrementQuestion")) %>') ) {
				// build URL string

        var url = top.getWebappPath() + "IncrementRetries?"
        var params = "URL=" + top.getWebappPath() + "NewDynamicListView?ActionXMLFile=adminconsole.MsgStoreListFromFind&amp;cmd=AwaitingMsgStoreDisplayFilterView&amp;listsize=20&amp;startindex=0&amp;refnum=0&amp;delivery=<%=UIUtil.toJavaScript(request.getParameter("delivery"))%>&amp;<%=MessagingSystemConstants.MSG_VIEW_TRANSPORT_ID%>=<%=msgViewList.getTransportId()%>&amp;<%=MessagingSystemConstants.MSG_VIEW_TABLE%>=<%=table.toString()%>&amp;<%=MessagingSystemConstants.MSG_VIEW_PROFILE_ID%>=-1";
        params += "&amp;error_URL=DialogView?XMLFile=adminconsole.MsgViewError";

        var deleteParm = "<%=MessagingSystemConstants.MSG_VIEW_MSG_ID%>=";
        var i = 0;
        if (checked.length > 0) {
          // set the first element (if select_deselect -- more than one)
          if ( checked[i] != "select_deselect" )
            deleteParm += checked[i];
          else {
            i = 1;
            if ( checked.length > 1)
              deleteParm += checked[i];
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
            deleteParm = deleteParm + "," + checked[i];
        }
				// go to the url
        url = url + deleteParm + "&amp;" + params;
				// parent because the title on top should not change
        parent.location.replace(url);
			}
		}
	}

    function onLoad()
    {
      parent.loadFrames();
      <%if(numberOfMessageTransports>=150){%>
	   alertDialog('<%= UIUtil.toJavaScript((String)messagingListNLS.get("messageMsgViewTooManyMatches"))%>');
      <%}%>
    }

    function getRefNum()
    {
      return <%= getRefNum() %>
    }
// -->
</script>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
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
<%=com.ibm.commerce.tools.common.ui.taglibs.comm.addControlPanel("adminconsole.MsgArchiveListFromFind", totalpage, totalsize, cmdContext.getLocale() )%>

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
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)messagingListNLS.get("messagingMsgViewMsgIDColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)messagingListNLS.get("messagingMsgViewMsgTransportColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)messagingListNLS.get("messagingMsgViewMsgStoreIDColumn"), null, false )%>
<%  if(table.intValue()==1) { %>
	<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)messagingListNLS.get("messagingMsgViewMsgRetriesColumn"), null, false )%>
<% } %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>

<%
    int rowselect=1;
    String chkbox_name = null;
    for (int i=getStartIndex(); i<endIndex ; i++)
    {
    	chkbox_name = msgViewList.getMsgId(i);
%>

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRow(rowselect) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheck(chkbox_name, "none" ) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(msgViewList.getMsgId(i)), "javascript:resendMsgBySelect('"+ chkbox_name +"');" ) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML((messagingListNLS.get(msgViewList.getTransportName(i)) != null) ? (String) messagingListNLS.get(msgViewList.getTransportName(i)) : msgViewList.getTransportName(i)), "none" ) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(msgViewList.getStoreId(i)), "none" ) %> 
<%  if(table.intValue()==1) { %>
	<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(msgViewList.getRetries(i)), "none" ) %>
<% } %>
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
      out.println(messagingListNLS.get("messagingMsgViewNoAvail"));
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
