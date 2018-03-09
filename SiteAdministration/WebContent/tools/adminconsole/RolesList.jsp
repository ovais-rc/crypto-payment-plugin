

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<HTML>

<%@ page language="java" %>


<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.test.*" %>

<%@ page import="com.ibm.commerce.base.objects.*"   %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>
<%@ page import="com.ibm.commerce.member.constants.ECMemberConstants" %>


<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>

<%@include file="../common/common.jsp" %>


      <%
      try {
      
      	// Set Command Context
        CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
        Locale jLocale = cmdContext.getLocale();
        Hashtable rolesNLS = (Hashtable) ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", jLocale);
        String webalias = UIUtil.getWebPrefix(request);
   	String sortby = null;             
   	String lstSize= null;
   	int numberOfRoles = 0;
   	Integer[] rootRoles = null;
   	String [][] roleNames = null;
   
    	sortby = request.getParameter("sortby");   
    	lstSize = (String) request.getParameter("listsize");    	
   	OrgEntityDataBean oedb = new OrgEntityDataBean();
   	oedb.setOrgEntityId(ECMemberConstants.EC_DB_ROOT_ORGANIZATION_ID);
   
   	com.ibm.commerce.beans.DataBeanManager.activate(oedb, request);
   
   	rootRoles = oedb.getRoles();
   	roleNames = new String[rootRoles.length][3];
   
      
	for (int i =0; i < rootRoles.length; i++) {
   
      		RoleDataBean rdb = new RoleDataBean();
      		rdb.setDataBeanKeyRoleId(rootRoles[i].toString());
      
	        com.ibm.commerce.beans.DataBeanManager.activate(rdb, request);
      
      		roleNames[i][0] = rootRoles[i].toString();
      		roleNames[i][1] = rdb.getName();
      		String desc = rdb.getDescription();
      		
      		if (desc == null) 
      		  roleNames[i][2] = "";
      		else 
      		  roleNames[i][2] = desc;
      
      		numberOfRoles = rootRoles.length;

     	}      
     	
     	java.text.Collator collator = java.text.Collator.getInstance(jLocale);
	String[] tmp;
	for (int i = 0; i < roleNames.length; i++) {
			for (int j = i + 1; j < roleNames.length; j++) {
				if (collator.compare(roleNames[i][1], roleNames[j][1]) > 0) {
					tmp = roleNames[i];
					roleNames[i] = roleNames[j];
					roleNames[j] = tmp;
			}
		}
	}

          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize   = Integer.parseInt(request.getParameter("listsize"));
          int endIndex   = startIndex + listSize;
          int totalsize  = numberOfRoles;
          int totalpage  = totalsize/listSize;
        
      %>


    <HEAD>
      <%= fHeader %>
      <LINK rel=stylesheet href="<%=UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">
      <SCRIPT SRC="<%=webalias%>javascript/tools/common/dynamiclist.js"></SCRIPT>

      <TITLE><%= UIUtil.toHTML((String)rolesNLS.get("roles")) %></TITLE>


      <SCRIPT>

        function onLoad()
        {
          parent.loadFrames();
        }

        function getRefNum()
        {
          return parent.getChecked();
        }

        function getResultsSize(){
          return <%=numberOfRoles%>;
        }

	function getUserNLSTitle(){
	  return "<%=rolesNLS.get("roles")%>";
        }

        function button_Discounts() {
            alert("button_Discounts()");
        }

        function newRole(){
      	    var url = top.getWebappPath() + "DialogView?XMLFile=adminconsole.RolesDialog";
      	    if (top.setContent){
        	top.setContent("<%= UIUtil.toJavaScript((String)rolesNLS.get("roleAdd")) %>",
                	       url,
                       	       true);
        	parent.location.replace(url);               
      		}
      	     else{
        
        	parent.location.replace(url);
      		}
    	}

    	
	function showParent(){
	
		alertDialog("show parent");
		
	}

	function getSortby() {
  
  		return "<%= UIUtil.toJavaScript(sortby) %>";
  
	}

      </SCRIPT>
      <SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>




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
      <%=comm.addControlPanel("adminconsole.RolesList",totalpage,totalsize,jLocale)%>
      <FORM NAME="rolesForm">
        <%= comm.startDlistTable("myDynamicRolesListTable") %>
        <%= comm.startDlistRowHeading() %>
        <%= comm.addDlistCheckHeading() %>
        <%= comm.addDlistColumnHeading((String)rolesNLS.get("memberGroupGeneralName"),null, false) %>
        <%= comm.addDlistColumnHeading((String)rolesNLS.get("memberGroupGeneralDesc"),null,false) %>
        <%= comm.endDlistRow() %>


          <%
          if (endIndex > numberOfRoles) {
            endIndex = numberOfRoles;
          }

          int indexFrom = startIndex;
          for (int i = indexFrom; i < endIndex; i++)
          {
          %>
	        <%= comm.startDlistRow( (i % 2) +1) %>
        	<%= comm.addDlistCheck ( roleNames[i][0],"none") %>
        	<%= comm.addDlistColumn( roleNames[i][1],"none") %>
        	<%= comm.addDlistColumn( roleNames[i][2],"none") %>
        	<%= comm.endDlistRow() %>
        	<%
          }

      } catch (Exception e)	{

         com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
      }
    %>
        <%= comm.endDlistTable() %>

      </FORM>


      <SCRIPT>
        <!--
          parent.afterLoads();
          parent.setResultssize(getResultsSize());
        //-->
      </SCRIPT>

    </BODY>

  </HTML>


