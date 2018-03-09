 

<%@page import="java.util.*" %>
<%@page import="java.io.*" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2013 All Rights Reserved.

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

<% String sql = request.getParameter("sqlstring"); %>

<% 
  if (!"127.0.0.1".equals(request.getRemoteAddr()) && !"0:0:0:0:0:0:0:1".equals(request.getRemoteAddr())) {
  %>
    You are unauthorized to access this page from a remote machine.
  <%
    return;
  }
%>

<html>
<body onload="document.SQLForm.sqlstring.focus()">
<form name="SQLForm" method="post">
  <label for="sqlstring">Enter SQL statements then click <b>Submit Query</b>.  Terminate all SQL statements with a semi-colon (;)</label><br />
  <textarea name="sqlstring" cols="100" rows="10" id="sqlstring"><%= (sql == null)?(""):(UIUtil.toHTML(sql)) %></textarea>
  <br />
  <input type="submit" value="Submit Query" />&nbsp;&nbsp; 
  <input type="reset" value="Clear All" onclick="document.SQLForm.sqlstring.defaultValue = '';"/></form>

  <% 
  java.sql.Statement statement = null;
  if (sql != null) {
    Exception exception = null;
    try {
      javax.sql.DataSource datasource = com.ibm.commerce.base.helpers.BaseJDBCHelper.getDataSource();
      java.sql.Connection connection = datasource.getConnection();
      statement = connection.createStatement();

      BufferedReader reader = new BufferedReader(new StringReader(sql));
      String line = null;

      StringBuffer queryBuffer = null;
      while ((line = reader.readLine()) != null) {
        if (queryBuffer == null) {
          queryBuffer = new StringBuffer();
        }
        if (line.length() > 0 && !line.startsWith("--")) {
          queryBuffer.append(line).append(" ");
          if (line.lastIndexOf(";") == -1) {
            continue;
          }
          
          String query = queryBuffer.substring(0, queryBuffer.lastIndexOf(";"));
          out.println("<br/>");
          out.println("<h3>Query: " + query + "</h3>");
          boolean result = statement.execute(query);
          java.sql.ResultSet resultSet = statement.getResultSet();
          if (resultSet != null) {
            java.sql.ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
  %>
  <table width="100%" cellpadding="0" cellspacing="0" border="1">
    <tr>
    <% for (int i = 0; i < resultSetMetaData.getColumnCount(); i++) { %>
      <td><b><%=resultSetMetaData.getColumnName(i + 1)%></b></td>
    <% } %>
    </tr>
  <%
  while (resultSet.next()) { 
  %>
    <tr>
    <% 
    for (int i = 0; i < resultSetMetaData.getColumnCount(); i++) {
      Object object = resultSet.getObject(i + 1);
    %>
      <td>
        <%
        if (object != null && object instanceof byte[]) {
          String hexString = "";
          byte byteArray[] = (byte[]) object;
          for (int j = 0; j < byteArray.length; j++) {
            if (byteArray[j] < 16) {
              hexString += "0";
            }
            hexString += Integer.toHexString((int) byteArray[j]);
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
    }
    %>
    </tr>
  <%
  }
  %>
  <% 
  resultSet.close();
  queryBuffer = null;
  %>
  </table>
          <% } else { // resultSet == null %>
          Statement resulted in <%=statement.getUpdateCount()%> updates.
          <% 
               queryBuffer = null; 
             } 
          %>
        <%
        } // query.length
      } // while line != null
      statement.close();
      reader.close();
    } catch (Exception e) {
      if (statement != null) {
        statement.close();
      }
      exception = e;
    }
    if (exception != null) {
    %>
    <%=exception%>
    <% } // exception != null
  } // sql != null
  %>
</body>
</html>
