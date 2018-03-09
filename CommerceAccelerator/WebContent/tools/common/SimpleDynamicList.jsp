<%
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
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<!-- Generic JSP for all components -->

<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>	
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.*" %>

<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.lang.reflect.*" %>

<%@include file="../common/common.jsp" %>

<!-- Get user bean -->
<%
    try{
         CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
         Locale jLocale = cmdContext.getLocale();
      	   
         String xmlfile = request.getParameter("ActionXMLFile");
         Hashtable actionXML = (Hashtable)ResourceDirectory.lookup(xmlfile); 
	   Hashtable action = (Hashtable)actionXML.get("action");
	   String beanClass = (String)action.get("beanClass");
         String resourcefile = (String)action.get("resourceBundle");
	  
         Class clazz = Class.forName(beanClass);
         SimpleDynamicListBean simpleList = (SimpleDynamicListBean)clazz.newInstance();

         Hashtable NLSfile = (Hashtable) ResourceDirectory.lookup(resourcefile, jLocale); 
         String jStoreID = cmdContext.getStoreId().toString();
         String jLanguageID = cmdContext.getLanguageId().toString();
 
         simpleList.setParm("storeID",jStoreID);
         simpleList.setParm("languageID",jLanguageID);

         Hashtable parms = (Hashtable)action.get("parameter");
         for (Enumeration p=parms.keys(); p.hasMoreElements();) {
             String para = (String)p.nextElement();
             String tmpValue = request.getParameter(para);
             if(tmpValue !=null )
                simpleList.setParm(para,tmpValue);
         }
         simpleList.setParm("startindex","0");
         simpleList.setParm("endindex","0");

         com.ibm.commerce.beans.DataBeanManager.activate((com.ibm.commerce.beans.DataBean)simpleList, request);
%>
         <!-- user javascript function include here -->
         <!-- javascript function defined in XML will be included in parent frame -->

           <html>
           <head>
			<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
			<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />
            <SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<%
         Hashtable scrollcontrol = (Hashtable) action.get("scrollcontrol");
	   if (scrollcontrol != null){
	       String title = (String) scrollcontrol.get("title");
%>
           <TITLE><%= UIUtil.toHTML((String)NLSfile.get(title)) %></TITLE>
<%
	   }
%>
           </HEAD>

           <BODY class="content_list">

           <SCRIPT> parent.loadFrames()</SCRIPT>
           <SCRIPT>
                   var storeID = "<%= jStoreID %>";
                   var languageID = "<%= jLanguageID %>";

                   function getLang() {
                       return languageID;
                   }
        
                   function getStore() {
                       return storeID;
                   }

                   function getResultsSize(){
                       return <%=simpleList.getListSize()%>;
                   }

                   <%=simpleList.getUserJSfnc(NLSfile)%>

           </SCRIPT>

           <%
              int startIndex = Integer.parseInt(request.getParameter("startindex"));
              int listSize = Integer.parseInt(request.getParameter("listsize"));
              int endIndex = startIndex + listSize;
              int rowselect = 1;
              int totalsize = simpleList.getListSize();
              int totalpage = totalsize/listSize;
           %>
           <%=comm.addControlPanel(xmlfile,totalpage,totalsize,jLocale)%>
           <FORM NAME="<%=(String)action.get("formName")%>">
              <%= comm.startDlistTable((String)NLSfile.get("accessProducts")) %>
              <%= comm.startDlistRowHeading() %>
              <%= comm.addDlistCheckHeading() %>
           <% 
              String[][] tmp = simpleList.getHeadings();
              String orderByParm = request.getParameter("orderby");
              String TmpNLSHeading = "";

              for(int i=0; i<tmp.length; i++){
                  TmpNLSHeading = (String)NLSfile.get(tmp[i][0]);
           %>
                  <%= comm.addDlistColumnHeading( (TmpNLSHeading==null)?tmp[i][0]:TmpNLSHeading, 
                                                  tmp[i][1],
                                                  (orderByParm==null)?false:orderByParm.equals(tmp[i][1])) %>
           <%
              }
           %>
              <%= comm.endDlistRow() %>

           <%
              if (endIndex > simpleList.getListSize()) {
                  endIndex = simpleList.getListSize();
              }
          
              int indexFrom = startIndex;
              for (int i = indexFrom; i < endIndex; i++)
              {
           %>
                 <%= comm.startDlistRow(rowselect) %>
                 <%= comm.addDlistCheck(simpleList.getCheckBoxName(i),"none") %>
           <%
                 String[] tmpcol = simpleList.getColumns(i);
           %>
                 <%= comm.addDlistColumn( tmpcol[0], simpleList.getDefaultAction(i),(String)NLSfile.get(tmp[0][0]) ) %>
           <%
                 for(int k=1; k<tmpcol.length; k++){
           %>
                    <%= comm.addDlistColumn( tmpcol[k], "none", (String)NLSfile.get(tmp[k][0])) %>
           <%
                 }
           %>
                 <%= comm.endDlistRow() %>
           <%
                 if(rowselect==1){
                    rowselect = 2;
                 }else{
                    rowselect = 1;
                 }
              }
           %>
<%
    } catch (Exception e)	{
         com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
    }
%>
           </FORM>
           <SCRIPT>
           <!--
             parent.afterLoads();
             parent.setResultssize(getResultsSize());
           //-->
           </SCRIPT>

         </BODY>
         </HTML>