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

<%@page import="java.util.*,
                        com.ibm.commerce.tools.xml.*,
                        com.ibm.commerce.tools.util.*,
                        com.ibm.commerce.tools.common.*,
                        com.ibm.commerce.server.*,
                        com.ibm.commerce.command.*,
                        com.ibm.commerce.datatype.TypedProperty,
                        com.ibm.commerce.beans.DataBeanManager,
                        com.ibm.commerce.bi.databeans.*"%>

<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>

<jsp:useBean id="context" beanName="com.ibm.commerce.bi.databeans.ContextDataBean" type="com.ibm.commerce.bi.databeans.ContextDataBean">
    <jsp:setProperty name="context" property="*"/>
    <% DataBeanManager.activate(context, request); %>
</jsp:useBean>

<% response.setContentType("text/html;charset=UTF-8"); %>

<% // prevent it from being invoked by type the jsp name in the address
   CommandContext thisCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   if (thisCommandContext == null) {
     System.out.println("commandContext is null");
     return;
   }
%>

<%
int totalsize = 0;

try{
    ActionEntry[] entries = context.getResults();
    ActionEntry anEntry;

    // Get the NLS resource bundle from the databean
    Hashtable contextNLS = context.getContextNLS();   
    if (contextNLS == null) {
        out.println("!!!! Resouces bundle is null");
        return;
    }


    if( context.isContextExist() == false)
    {
            out.println((String) contextNLS.get("theContext") + UIUtil.toHTML(context.getContext()) + contextNLS.get("notDefined"));
            return;
    }

    // No entry
    if(entries.length == 0){
        String msg = (String) contextNLS.get("noApplicableActions");
        // If cannot find the String in resource bundle, an English version is displaied.
        if( msg == null)
            msg = "There are no applicable actions.";
        out.println( msg );
        return;
    }

    String displayTitle;
    // if the displayKey is missing from the context
    if(context.getDisplayKey() != null){
            displayTitle = (String) contextNLS.get(context.getDisplayKey());
    }
    else{
            displayTitle=null;
    }

%>

<HTML>
    <HEAD>
            <TITLE><%=displayTitle %></TITLE>
            <LINK rel="stylesheet" href="<%=UIUtil.getCSSFile(thisCommandContext.getLocale()) %>" type="text/css">
    	    <SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
        <SCRIPT>
            function onLoad()
            {
                parent.loadFrames();
                //If there is only one entry in the context, load it.
                if(<%= entries.length %> == 1  && <%=context.isAutoLaunch()%>){
                    top.setContent("<%=(String) contextNLS.get(entries[0].getBreadCrumbTrailTextKey()) %>","<%= entries[0].getUrl() %>", false);
                    // stop the progress indicator
                    top.showProgressIndicator(false);
                }
            }
        
                function getUserNLSTitle()
                {
                        return "<%=displayTitle %>";
                }
        </SCRIPT>
    </HEAD>
        <BODY class="content_list">
        <SCRIPT>
            <!--
            // For IE
            if (document.all) {
                onLoad();
            }
            //-->
        </SCRIPT>
<% // Needed for dynamic list
    int startIndex = Integer.parseInt(request.getParameter("startindex"));
    int listSize = Integer.parseInt(request.getParameter("listsize"));
    int endIndex = startIndex + listSize;
    int isHighLightedRow = 1;
    
    totalsize = entries.length;
    
    int totalpage = totalsize/listSize;
    int remain = totalsize % listSize;
    // one is added in addControlPanel();
    if (remain == 0)
         totalpage--;

%>
    <%=comm.addControlPanel(request.getParameter("ActionXMLFile"),totalpage,totalsize,context.getLocale())%>
    <FORM NAME="ContextListFORM">
    <%= comm.startDlistTable(displayTitle)  %>
    <%= comm.startDlistRowHeading() %>
    <%= comm.addDlistColumnHeading((String)contextNLS.get("contextListColumn1Heading"),null,false,"30%" ) %>
    <%= comm.addDlistColumnHeading((String)contextNLS.get("contextListColumn2Heading"),null,false,"70%" ) %>
    <%= comm.endDlistRow() %>
 
<%
    if (endIndex > totalsize) {
        endIndex = totalsize;
    }
          
    String nlsEntryName;
    String nlsEntryDescription;
    int indexFrom = startIndex;
    for (int i = indexFrom; i < endIndex; i++)
    {
        StringBuffer urlStrb = new StringBuffer(1024);
        

        anEntry = entries[i];

        // when there is no url, it needs to be set to "none".
        if(anEntry.getUrl() == null) {
            urlStrb.append("none");
        }
        else{
            urlStrb.append( "javascript: top.setContent('" );
            urlStrb.append( UIUtil.toJavaScript((String) contextNLS.get(anEntry.getBreadCrumbTrailTextKey())) );
                urlStrb.append( "', '" );
                urlStrb.append( anEntry.getUrl() );
                urlStrb.append( "', true)" );
        }
             
        // A null is returned if the key is missing from the XML file
        if(anEntry.getNameKey() != null)
            nlsEntryName = (String) contextNLS.get(anEntry.getNameKey());
        else
            nlsEntryName = null;
                
        if( anEntry.getDescriptionKey() != null)
            nlsEntryDescription = (String) contextNLS.get(anEntry.getDescriptionKey());
        else
            nlsEntryDescription = null;
                
%>
    <%= comm.startDlistRow(isHighLightedRow) %>
    <%= comm.addDlistColumn( nlsEntryName , urlStrb.toString() ) %>
    <%= comm.addDlistColumn( nlsEntryDescription ,"none" ) %>
    <%= comm.endDlistRow() %>
<%
        if(isHighLightedRow == 1)
            isHighLightedRow = 2;
        else
            isHighLightedRow = 1;
    } // for 
} catch (Exception e)   {
    com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
}
%>

    <%= comm.endDlistTable() %>
    </FORM>
    <SCRIPT>
        <!--
        parent.afterLoads();
        parent.setResultssize(<%=totalsize %>);
        //-->
    </SCRIPT>
    </BODY>
</HTML>
