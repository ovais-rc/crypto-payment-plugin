<!--==========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
===========================================================================-->

<%@ page import="com.ibm.commerce.negotiation.beans.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.ibm.commerce.command.*"%> 
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.*" %>
<%@page import="com.ibm.commerce.exception.*" %>
<%@page import="java.text.*" %>

<%@include file="../common/common.jsp" %>


<%
try
{
%>

   <%
                   
      Integer lang = null;
      String forum_id = "1";
               
      String productId = null;
      String product_Desc = null;
      
      String subject = null;
      String body = null;
      
      Object parms[] = null;
                        
      String aucrfn = request.getParameter("aucrfn");
                              
      forum_id = request.getParameter("forum_id");
      
      CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext"); 
      
      Locale locale = null; 
         
      if( aCommandContext!= null )
      {
         locale = aCommandContext.getLocale();
         lang = aCommandContext.getLanguageId();   
      }
      
      // obtain the resource bundle for display
      Hashtable forumMsgNLS = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS", locale);
      
      
   %>
   
      <jsp:useBean id="auction" class="com.ibm.commerce.negotiation.beans.AuctionDataBean" >
      <jsp:setProperty property="*" name="auction" />
      <jsp:setProperty property="auctionId" name="auction" value="<%= aucrfn %>" />
      </jsp:useBean>
   <%
      com.ibm.commerce.beans.DataBeanManager.activate(auction, request);
      productId = auction.getEntryId();
      
   %>

   
      <jsp:useBean id="anItem" class="com.ibm.commerce.catalog.beans.CatalogEntryDataBean" >
      <jsp:setProperty property="*" name="anItem" />
      <jsp:setProperty property="catalogEntryID" name="anItem" value="<%= productId %>" />
      </jsp:useBean>  

   <% 
      try
      {
         com.ibm.commerce.beans.DataBeanManager.activate(anItem, request);
         product_Desc = anItem.getDescription(lang).getName();
         
      }
      catch(Exception e)
      {
         product_Desc = "";
      }                
      
      String dialog_desc = null;
      if( product_Desc != null && !product_Desc.equals("") )
      {
         dialog_desc = (String)forumMsgNLS.get("add_forum_msg_desc");
         parms = new Object[1];
         parms[0] = product_Desc;
         dialog_desc = MessageFormat.format(dialog_desc, parms);
      }
      else
      {
         dialog_desc = (String)forumMsgNLS.get("add_forum_msg_desc1");
      } 
      
                                            
   %> 
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<HTML>
   <HEAD>
      <META HTTP-EQUIV="Content-Type" content="text/html; charset=iso-8859-1">
      <META HTTP-EQUIV=Expires CONTENT="Mon, 01 Jan 1996 01:01:01 GMT">
      <TITLE>Adding Message</TITLE> 
      <link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
   </HEAD>

   <BODY class="content" ONLOAD="initializeState();">

      <H1><%= (String)forumMsgNLS.get("add_forum_msg_title") %></H1>
      <H1><%= dialog_desc %> - <%=(String)forumMsgNLS.get("AuctionRefNum")%>: <%=UIUtil.toHTML(aucrfn)%></H1>
               
      <FORM Name="compose" Action="" id="compose">
          
          <LABEL for="WC_ForumAddDialog_subject_In_compose">
         <%= (String)forumMsgNLS.get("forummsg_your_subject") + " " + (String)forumMsgNLS.get("required") %>
        </LABEL><BR>
	     <INPUT TYPE="text" NAME="subject" SIZE="64" MAXLENGTH="254" VALUE="" id="WC_ForumAddDialog_subject_In_compose">
         
         <BR><BR>
         <LABEL for="WC_ForumAddDialog_body_In_compose">
	     <%= forumMsgNLS.get("forummsg_your_msg") %>
         </LABEL><BR>
	     <TEXTAREA NAME="body" COLS=55 ROWS=7 WRAP=VIRTUAL id="WC_ForumAddDialog_body_In_compose"><%= "" %></TEXTAREA>
         
         
         
         <INPUT TYPE="hidden" NAME="aucrfn" VALUE=<%= UIUtil.toHTML(aucrfn) %> id="WC_ForumAddDialog_aucrfn_In_compose">
         <INPUT TYPE="hidden" NAME="forum_id" VALUE=<%= UIUtil.toHTML(forum_id) %> id="WC_ForumAddDialog_forumId_In_compose">
         
         <SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"> </SCRIPT>

         <SCRIPT LANGUAGE="JavaScript">

                        
            function validatePanelData()
            {
              
               var form = document.compose;
	           if( form.subject.value == "" )
               {
	              
                  var msg = "<%= forumMsgNLS.get("forum_msg_blank") %>";
                  
	              alertDialog(msg);
	              form.subject.focus();
	              return false;
	           }

	           var msgMaxLength = 254;
	           if( !isValidUTF8length(form.subject.value, msgMaxLength) )
               {
	              msg = "<%= forumMsgNLS.get("msgInvalidSize") %>";
                  alertDialog(msg);
	              form.subject.focus();
                  form.subject.select();
	              return false;
               }
               return true; 

            }
            
            function initializeState()
            {
               parent.setContentFrameLoaded(true);
            }

            
            function savePanelData()
            {
               parent.put("aucrfn", "<%=UIUtil.toJavaScript( aucrfn )%>");
               parent.put("forum_id", "<%= UIUtil.toJavaScript(forum_id) %>");
               parent.put("subject", document.compose.subject.value );
               parent.put("body", document.compose.body.value );
               
               parent.addURLParameter("authToken", "${authToken}");
            }
                 
         </SCRIPT>
	     <P>
         <CENTER>
      </FORM> 
      <P>
   </BODY>
</HTML>

<%
}
catch(ECSystemException e)
{
   ExceptionHandler.displayJspException(request, response, e);
}
%>


