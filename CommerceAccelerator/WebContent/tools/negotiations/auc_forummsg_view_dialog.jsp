<!--==========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2016
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
      String posterId = null;    
      Locale locale = null;
      
      String productId = null;
      String product_Desc = null;
      
      String forum_id = null;
            
      String msg_id = null;
      java.sql.Timestamp postTime = null;
                         
      String subject = null;
      String body = null;
      
      String msgstatus = "A";
     
      String shopperLastName = null;
      String shopperFirstName = null;
      String shopperMiddleName = null;
      
      Object parms[] = null;
                        
      String aucrfn = request.getParameter("aucrfn");    
      msg_id = request.getParameter("msg_id");
      
      CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext"); 
       
         
      if( aCommandContext!= null )
      {
         locale = aCommandContext.getLocale();
         lang = aCommandContext.getLanguageId();
      }
      
      DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.MEDIUM, locale);
          

      
      // obtain the resource bundle for display
      Hashtable forumMsgNLS = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS", locale);
               
   
   %>
   

<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<HTML>
   <HEAD>
      <META HTTP-EQUIV="Content-Type" content="text/html; charset=iso-8859-1">
      <META HTTP-EQUIV=Expires CONTENT="Mon, 01 Jan 1996 01:01:01 GMT">
      <TITLE>Auction Discussion Forum</TITLE>
      <link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">      
   </HEAD>

   <BODY class="content" ONLOAD="initializeState();">

      <jsp:useBean id="auction" class="com.ibm.commerce.negotiation.beans.AuctionDataBean" >
      <jsp:setProperty property="*" name="auction" />
      <jsp:setProperty property="auctionId" name="auction" value="<%= aucrfn %>" />
      </jsp:useBean>
   <%
      com.ibm.commerce.beans.DataBeanManager.activate(auction, request);
      productId = auction.getEntryId();
      
   %>
   
      <jsp:useBean id="anItem" class="com.ibm.commerce.catalog.beans.ItemDataBean" >
      <jsp:setProperty property="*" name="anItem" />
      <jsp:setProperty property="itemID" name="anItem" value="<%= productId %>" />
      </jsp:useBean>  

   <% 
      
      try
      {
         com.ibm.commerce.beans.DataBeanManager.activate(anItem, request);
         //Get cateentry name
         product_Desc = anItem.getDescription(lang).getName();
      }
      catch(Exception e)
      {
         product_Desc = "";
      }
      
      
      String dialog_desc = null;
      if( product_Desc != null && !product_Desc.equals("") )
      {
         dialog_desc = (String)forumMsgNLS.get("view_forum_msg_desc");
         parms = new Object[1];
         parms[0] = product_Desc;
         dialog_desc = MessageFormat.format(dialog_desc, parms);
      }                
                                                
   %> 

      <H1><%= (String)forumMsgNLS.get("view_forum_msg_title") %></H1>
   
   <% if( product_Desc != null && !product_Desc.equals("") ) { %>    
      <H1><%= dialog_desc %> - <%=(String)forumMsgNLS.get("AuctionRefNum")%>: <%=UIUtil.toHTML(aucrfn)%></H1>
   <% } %>              
      <jsp:useBean id="forumMsgBean" class="com.ibm.commerce.negotiation.beans.ForumMessageDataBean" >
      <jsp:setProperty property="*" name="forumMsgBean" />
      <jsp:setProperty property="msgId" name="forumMsgBean" value="<%= msg_id %>" />
      </jsp:useBean>


   <%
      com.ibm.commerce.beans.DataBeanManager.activate(forumMsgBean, request);
        
      subject = forumMsgBean.getMsgSubject();
      body = forumMsgBean.getMsgBody();
      postTime = forumMsgBean.getPostTimeInEntityType();
      posterId = forumMsgBean.getPosterId();
      forum_id = forumMsgBean.getForumId();
// rz 011008  
// the useBean does not work for UserRegistration
// ny 27802 begin to use UserInfoDataBean
	com.ibm.commerce.user.beans.UserInfoDataBean  aRegister = 
			new  com.ibm.commerce.user.beans.UserInfoDataBean();
	aRegister.setUserId(posterId);
// rz 011008

   %>
   
   <%     
      
      
      try
      {
         com.ibm.commerce.beans.DataBeanManager.activate(aRegister, request);                                 
         shopperFirstName = aRegister.getFirstName();
         shopperMiddleName = aRegister.getMiddleName();
         shopperLastName = aRegister.getLastName();
         if( shopperMiddleName == null )
         {
   	        shopperMiddleName = "";
         }
         if( shopperFirstName == null )
         {
   	        shopperFirstName = "";
         }
         if( shopperLastName == null )
         {
   	        shopperLastName = "";
         }
      }
      catch(Exception e)
      {
         shopperFirstName = "";
         shopperMiddleName = "";
         shopperLastName = "";

      }
                                                        
   %>
   
   <% 
      if( subject == null )
      {
         subject = "";
      
      }
      
      String author = (String)forumMsgNLS.get("author");
      parms = new Object[4];
      parms[0] = shopperFirstName;
	  parms[1] = shopperMiddleName;
	  parms[2] = shopperLastName;
      author = MessageFormat.format(author, parms);
       
   %>
       
       
       <P><%= forumMsgNLS.get("message_id") %> <I><%= UIUtil.toHTML(msg_id) %></I>
       <P><%= forumMsgNLS.get("forummsg_subject1") %> <I><%= UIUtil.toHTML(subject) %> </I>
       <P><%= forumMsgNLS.get("forummsg_sender1") %> <I><%= author %> </I>
       <P><%= forumMsgNLS.get("forummsg_date") %> <I><%= dateFormat.format( postTime ) %></I>
       <P><%= forumMsgNLS.get("forummsg_content1") %> <I> <%= UIUtil.toHTML(body) %></I>
       <P>
      
      
      <SCRIPT Language="javascript">
      
         function initializeState()
         {
            parent.setContentFrameLoaded(true);
         }
         
         
      </SCRIPT>
      <FORM Name="view" Action="">         
         <INPUT TYPE="hidden" NAME="aucrfn" VALUE=<%= UIUtil.toHTML(aucrfn) %> >
         <INPUT TYPE="hidden" NAME="forum_id" VALUE=<%= forum_id %> >
      </FORM>
   </BODY>
</HTML>

<%
}
catch(ECSystemException e)
{
   ExceptionHandler.displayJspException(request, response, e);
}
%>



