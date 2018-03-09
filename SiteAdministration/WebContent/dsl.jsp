
 

<%@page import="java.util.*" %>
<%@page import="java.io.*" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="com.ibm.commerce.foundation.internal.client.services.identity.*" %>
<%@page import="com.ibm.commerce.foundation.identity.*" %>
<%@page import="com.ibm.commerce.foundation.internal.server.services.businesscontext.ContextInternalService" %>
<%@page import="com.ibm.commerce.foundation.server.services.businesscontext.ContextServiceFactory" %>
<%@page import="com.ibm.commerce.component.contextservice.ActivityData" %>
<%@page import="com.ibm.commerce.foundation.server.services.dataaccess.SelectionCriteria" %>
<%@page import="com.ibm.commerce.foundation.client.util.oagis.SelectionCriteriaHelper" %>
<%@page import="com.ibm.commerce.foundation.internal.server.services.dataaccess.util.QueryTemplateValidationHelper" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="com.ibm.commerce.foundation.internal.server.services.dataaccess.queryservice.SQLProcessor" %>
<%@page import="com.ibm.commerce.foundation.internal.server.services.dataaccess.queryservice.XPathSQLProcessor" %>
<%@page import="com.ibm.commerce.foundation.internal.server.services.dataaccess.queryservice.XPathSQLPagingCountProcessor" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%!
private static String quote(Object o) {
  if (o instanceof String) {
    String s = (String) o;
    StringBuffer stringbuffer = new StringBuffer();
    stringbuffer.append("'");
    int i = s == null ? 0 : s.length();
    for (int j = 0; j < i; j++) {
      char c = s.charAt(j);
      switch (c) {
        case 60 : // '<'
          stringbuffer.append("&lt;");
          break;

        case 62 : // '>'
          stringbuffer.append("&gt;");
          break;

        case 38 : // '&'
          stringbuffer.append("&amp;");
          break;

        case 34 : // '"'
          stringbuffer.append("&quot;");
          break;

        default :
          stringbuffer.append(c);
          break;
      }
    }
    stringbuffer.append("'");
    return stringbuffer.toString();
  }
  return o.toString();
}
%>

<% String componentId = request.getParameter("componentids"); %>
<% String accessProfile = request.getParameter("accessprofiles"); %>
<% String xpathStr = request.getParameter("xpath"); %>
<% String storeId = request.getParameter("storeId"); %>
<% String languageId = request.getParameter("languageId"); %>
<% String xpathName = request.getParameter("xpathnames"); %>
<% boolean customOnlyChecked = (request.getParameter("customXPathOnly") != null ? true : false);%>

<% 
  if (!"127.0.0.1".equals(request.getRemoteAddr()) && !"0:0:0:0:0:0:0:1".equals(request.getRemoteAddr())) {
  %>
    You are unauthorized to access this page from a remote machine.
  <%
    return;
  }
%>

<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<body ONLOAD="loadPanelData();">
<form name="QueryTemplateForm" method="post">
  <% 
  Exception exception = null;
  SQLProcessor sqlProcessor = null;
  List componentIds = QueryTemplateValidationHelper.getComponentIds();
  int numOfComponents = componentIds.size();
  List componentXPathKeys = new ArrayList();
  List componentExtXPathKeys = new ArrayList();
  boolean[] hasExts = new boolean[numOfComponents];
  StringBuffer sbQuery = new StringBuffer(100);
  boolean initialized = false; 
  try {
  if (numOfComponents > 0) {
  	  for (int i=0; i < numOfComponents; i++) {
  	  	 String compId = (String) componentIds.get(i);
  	  	 componentXPathKeys.add(QueryTemplateValidationHelper.getXPathKeys(compId));
  	  	 Object[] extXPathKeys = QueryTemplateValidationHelper.getExtensionXPathKeys(compId);
  	  	 componentExtXPathKeys.add(extXPathKeys);
  	  	 if (extXPathKeys != null && extXPathKeys.length > 0) {
	  		hasExts[i] = true;
	  	 }
	  	 
  	  }
  	  initialized = true;
  }
  
 
  %>
  
  <table border=0>
  <tr>
  <b>Query Template File Syntax Validator</b>
  </tr>
  <tr> 
    <td width=800 colspan=3>
     <br>
    Use this page to validate your query template file syntax.  <br><br>
    From the <b>Component</b> list, select a value. 
    The <b>XPath keys</b>, <b>XPath</b>, <b>Access Profile</b>, and <b>Language ID</b> fields are populated 
    listing values specific to the component. Complete all fields. In the <b>XPath</b> field complete the values 
    of the attributes and elements if necessary. Then click <b>Submit Query</b>.<br><br> 
    The page refreshes showing information about your query such as the Search Expression, SQL statements, parameters used in the SQL statements, and the result of the query.<br><br>
    </td>
  </tr>
  <tr>
   <td VALIGN=TOP>
    <label for="componentid">Component:</label>
   </td>
   <td>
	  <select name="componentids" id="componentid" size="3" onchange="updateXPathKey(this.selectedIndex)" >	
	      <%for (int x=0; x<numOfComponents; x++) {%>
		  <option value="<%=componentIds.get(x) %>"><%=componentIds.get(x)%></option>	
		  <%} %>
	  </select>
	  <div id="extensionDiv" style="display: none; margin-left: 0">
		<label for="customflag">Show Custom XPath Only: </label>
		<INPUT TYPE="CHECKBOX" NAME="customXPathOnly" id="customflag" VALUE="custom" CHECKED onclick="updateXPathKey(document.QueryTemplateForm.componentids.selectedIndex,this.checked)"><BR>
	</div>
	 </td>
  </tr>
  
	<tr>
   <td VALIGN=TOP>
	  <label for="xpathname">XPath keys:</label>
   </td>
   <td>	 
	  <select name="xpathnames" id="xpathname" size="1" onchange="updateXPathAndAccessProfile(this.selectedIndex)">	
	  </select>
	 </td>
  </tr>
	<tr>	 
   <td VALIGN=TOP>
	  <label for="xpath">XPath:</label>
   </td>
   <td>	 	 
	  <textarea name="xpath" cols="100" rows="3" id="xpath"><%= (xpathStr == null)?(""):(UIUtil.toHTML(xpathStr)) %></textarea>
	 </td>
	</tr>
	<tr>
   <td VALIGN=TOP>
	  <label for="accessprofile">Access Profile:</label>
   </td>
   <td>	
	  <select name="accessprofiles" id="accessprofile" size="1">	
	  </select>
	 </td>
  </tr>	
	<tr>
   <td VALIGN=TOP>	
	  <label for="storeid">Store ID:</label>
   </td>
   <td>	
	  <textarea name=storeId cols="10" rows="1" id="storeid"><%= (storeId == null)?(""):(UIUtil.toHTML(storeId)) %></textarea>
	 </td>
  </tr>	
	<tr>
   <td VALIGN=TOP>	
	  <label for="languageid">Language ID: </label>
   </td>
   <td>	
	  <textarea  name=languageId cols="10" rows="1" id="languageid"><%= (languageId == null)?("-1"):(UIUtil.toHTML(languageId)) %></textarea><BR>
 	 </td>
  </tr>
 </table>
  

  <input type="submit" value="Submit Query" />&nbsp;&nbsp; 
  <input type="reset" value="Clear All" onclick="document.QueryTemplateForm.xpath.defaultValue = '';"/>
</form>

<%
	if (null != componentId && null != xpathStr) {
		 
//		try {
			IdentityService identityService = IdentityServiceFactory.getIdentityService();
			HashMap sessionData = new HashMap();
			sessionData.put("storeId", storeId);
			StringTokenizer strTokens = new StringTokenizer(languageId, ",");
			String langId = null;
	        if (strTokens.hasMoreTokens()) {
	            langId = strTokens.nextToken();
	        }
			sessionData.put("langId", langId);
			IdentityToken identityToken = identityService.begin(null, null, new IdentityServiceDataObject(sessionData));
			IdentityManager idManager = IdentityManagerFactory.getIdentityManager();
			idManager.setIdentity(identityToken);
			ContextInternalService bcs = (ContextInternalService)ContextServiceFactory.getContextService();
			bcs.startRequest(new ActivityData(sessionData));
			
			// build SelectionCriteria
			
		  SelectionCriteria sc = new SelectionCriteria();
		    	
		  
		  sbQuery.append("{") // access profile
				       .append(SelectionCriteriaHelper.STR_ACCESS_PROFILE_PARAMETER)
					   .append("=").append(accessProfile)
					   .append(";").append("_wcf.dataLanguageIds")
					   .append("='").append(languageId)
					   .append("'}")
					   .append(xpathStr); // xpath
		    	
		    	sc.setXPath(sbQuery.toString());
		    	sc.setComponentId(componentId);
		    %>
		    <h3>Search Expression:</h3> <%=UIUtil.toHTML(sbQuery.toString())%>
		    <% 
		    List sqlProcessors = QueryTemplateValidationHelper.getSQLProcessors(sc, componentId);	
		    Connection conn = com.ibm.commerce.foundation.server.databaseconnection.DatabaseConnectionManager.instance().getConnection(componentId);
		    PreparedStatement stmt = null;	
		    	for (int i=0; i<sqlProcessors.size(); i++) {
		    		ResultSet resultSet = null;
		    		
		    		sqlProcessor = (SQLProcessor) sqlProcessors.get(i);
		    		String sql = sqlProcessor.getSql();
		    		
		    		List parameters = sqlProcessor.getSqlParameterValues();
		    		stmt = conn.prepareStatement(sql);
		    		if (sqlProcessor instanceof XPathSQLPagingCountProcessor) {%>
		    		<h3> Paging Count SQL: </h3> 
		    		<% } else if (sqlProcessor instanceof XPathSQLProcessor) { %>
		    		<h3>SQL: </h3> 
		    		<%} else { %>
		    		<h3>Associated XPath Name:</h3> <%= sqlProcessor.getXPathName() %>
		    		<h3>Associated SQL:  </h3> 
		    		<%} %>
		    		<%=sql%> <br><br>
		    		Parameters:  <%= parameters %><br><br>
		    		<% 
		    		for (int j=0; j < parameters.size(); j++) {
						stmt.setObject(j+1, parameters.get(j));
					}
					resultSet = stmt.executeQuery();
					 if (resultSet != null) {
            			java.sql.ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
  			%>
  <table width="100%" cellpadding="0" cellspacing="0" border="1">
    <tr>
    <% for (int k = 0; k < resultSetMetaData.getColumnCount(); k++) { %>
      <td><b><%=resultSetMetaData.getColumnName(k + 1)%></b></td>
    <% } %>
    </tr>
    <br>
  <%
  while (resultSet.next()) { 
  %>
    <tr>
    <% 
    for (int m = 0; m < resultSetMetaData.getColumnCount(); m++) {
      Object object = resultSet.getObject(m + 1);
    %>
      <td>
        <%
        if (object != null && object instanceof byte[]) {
          String hexString = "";
          byte byteArray[] = (byte[]) object;
          for (int n = 0; n < byteArray.length; n++) {
            if (byteArray[n] < 16) {
              hexString += "0";
            }
            hexString += Integer.toHexString((int) byteArray[n]);
          }
        %>
          X'<%=hexString%>'
        <%
        } else if (object instanceof java.sql.Clob) {
          java.sql.Clob clob = (java.sql.Clob) object;
          String clobString = clob.getSubString(1, (int)clob.length());
        %>
          <pre><%=(clobString == null) ? "NULL" : quote(clobString)%></pre>
        <% 
        } else {
        %>
          <%=(object == null) ? "NULL" : quote(object)%>
        <%
        }
        %>
      </td>
    <%
    } // end for (int i = 0; i < resultSetMetaData.getColumnCount(); i++)
    %>
    </tr>
  <%
  }  // end while(resultSet.next())
  
  resultSet.close();
  } //if (resultSet != null)
  %>
  </table>
  <% 
  stmt.close();
  
  } // for (int i=0; i<sqlProcessors.size(); i++) 
			bcs.endRequest();
			idManager.setIdentity(null);
			identityService.complete(identityToken);
 
  }
  
   } catch (Exception e) {
		 exception = e;
  }
    if (exception != null) {
      if (sbQuery.toString().length() > 0) {
      %>
      	Search Expression: <br><%=UIUtil.toHTML(sbQuery.toString())%><br><br>
      <%} %>
      <% 
      if (null != sqlProcessor) { %>
    	<br><br>
    	SQL: <br> <%=sqlProcessor.getSql()%> <br><br>
    	Error: <br>  <%=exception%> <br><br>
    	XPathName: <%=sqlProcessor.getXPathName()%> <br><br>
		Template File Name:  <%=sqlProcessor.getTemplateFileName()%><br><br>
		<%
	  } else { %>
		Error: <br>  <%=exception%>
		<% } 
	 }
%>



<script type="text/javascript">

var componentlist=document.QueryTemplateForm.componentids;
var xpathnameslist=document.QueryTemplateForm.xpathnames;
var accessprofilelist=document.QueryTemplateForm.accessprofiles;
var selectedComponentId;
var customOnly = document.QueryTemplateForm.customXPathOnly.checked;


function updateXPathKey(selectedComponentIdIndex){

 var len;
 customOnly = document.QueryTemplateForm.customXPathOnly.checked;
 
 
	 if (selectedComponentIdIndex >= 0){
		selectedComponentId = selectedComponentIdIndex;
		xpathnameslist.options.length=0;
		<% 
		   if (initialized) {
			   int y = 0;
			   boolean found = false;
			   while (!found && y < numOfComponents) {%>
			   		if (selectedComponentIdIndex == <%=y%>) {
			   			if (<%=hasExts[y]%>) {
		     				extensionDiv.style.display = "block";
		     			} else {
		     				extensionDiv.style.display = "none";
		     			}
		     			
		     			if (customOnly && <%=hasExts[y] %>) {
		     				<%Object[] xpathKeys = (Object[]) componentExtXPathKeys.get(y);; %>
		  	 	 			extensionDiv.style.display = "block";
		  	 	 			<%	for (int i=0; i<xpathKeys.length; i++) { %>
			  					xpathnameslist.options[<%=i%>]=new Option("<%=xpathKeys[i]%>", "<%=xpathKeys[i]%>");
			   					updateXPathAndAccessProfile(0);
			 	 			<% }  %>
		  	 	 		} else if (!<%= hasExts[y] %> || !customOnly) {
		  	 	 			<% xpathKeys = (Object[]) componentXPathKeys.get(y);%>
		  	 	 			<%	for (int i=0; i<xpathKeys.length; i++) { %>
			  					xpathnameslist.options[<%=i%>]=new Option("<%=xpathKeys[i]%>", "<%=xpathKeys[i]%>");
			   					updateXPathAndAccessProfile(0);
			 	 		<% }  %>
		  	 	 		}
			   		}
			   <% y++ ;
			   } 
		   }%>
	 
 }
}

function updateXPathAndAccessProfile(selectedXPathNameIndex)  {
	var accessprofileslist=document.QueryTemplateForm.accessprofiles;
	accessprofileslist.options.length=0;
	var selectedValue = document.QueryTemplateForm.xpathnames.options[selectedXPathNameIndex].value;
	var values = selectedValue.split("+");
	document.getElementById("xpath").innerHTML = values[0];
	if (values.length ==2) {
		accessprofileslist.options[0]=new Option(values[1], values[1]);
	} 
	
}

function loadPanelData() {

   // component list
    for (var i=0; i<componentlist.length; i++) {
      if (componentlist.options[i].value == "<%= UIUtil.toJavaScript(componentId) %>") {
      	 document.QueryTemplateForm.customXPathOnly.checked = <%= customOnlyChecked %>;
         componentlist.selectedIndex = i;
         
         updateXPathKey(i);
         
         // xpath list
         for (var j=0; j<xpathnameslist.length; j++) {
            if (xpathnameslist.options[j].value == "<%= UIUtil.toJavaScript(xpathName) %>") {
               xpathnameslist.selectedIndex = j;
               updateXPathAndAccessProfile(j);
               document.getElementById("xpath").innerHTML = "<%= UIUtil.toJavaScript(xpathStr) %>";
               
               // access profile list
               for (var k=0; k<accessprofilelist.length; k++) {
                   if (accessprofilelist.options[k].value == "<%= UIUtil.toJavaScript(accessProfile) %>") {
                      accessprofilelist.selectedIndex = k;
                      break;
                   }
               }
               break;
            }
         }
         break;
      }
    }
    
}
</script>


</body>
</html>
