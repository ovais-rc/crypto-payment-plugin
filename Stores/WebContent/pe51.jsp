<!-- 
  //*----
  //* @deprecated The Product Advisor feature has been deprecated. For more information, see <a href="../../../../../../com.ibm.commerce.productadvisor.doc/concepts/cpaintro.htm">Product Advisor</a>.
  //*----
-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 1995, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<!--
  The sample templates, HTML and Macros are furnished by IBM as sample
examples to provide an illustration. These examples have not been
thoroughly tested under all conditions.  IBM, therefore, cannot guarantee or
imply reliability, serviceability, of function of these programs. All
programs contained herein are provided to you "AS IS"

  The sample templates, HTML, and Macros may include the names of individuals,
companies, brands and products in order to illustrate them as completely as
possible. All of these names are fictitious and any similarity to the names
and addresses used by an actual business enterprise is entirely coincidental.
 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<HTML  lang="en" xml:lang="en">

<head>
<title> </title>
</HEAD>
<BODY  BGCOLOR=#ffffff TEXT=#000000 LINK=#0000ff VLINK=#ff00ff ALINK=#ff0000>
<CENTER>
<TABLE CELLSPACING=0 CELLPADDING=0 WIDTH=480 BORDER=0>
  <TR> <TD HEIGHT=20><TD WIDTH=480 HEIGHT=35 ROWSPAN=4 COLSPAN=12> <!-- Store Image --> </TR>
</TABLE>
</CENTER>

<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="java.util.*" %>
<%@ page session="false" %>


<%
  String categoryId = request.getParameter(ECConstants.EC_CATEGORY_ID);
  String shopperGroup = request.getParameter("group");
  String languageId;
  String store;
  String localeString = null;
  Locale locale = Locale.getDefault();
  CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");
  if( aCommandContext!= null )
  {
     locale = aCommandContext.getLocale();
     localeString = locale.toString();
  }
  ResourceBundle nls = ResourceBundle.getBundle("com.ibm.commerce.tools.pa.properties.paSampleJSPs", locale);

  languageId = aCommandContext.getLanguageId().toString();
  store = aCommandContext.getStoreId().toString();
  String imageDir = "/wcs/tools/pa/icons/" + localeString;
  String pcImage = imageDir + "/prod_comp.gif";
  String saImage = imageDir + "/sale_asst.gif";
  String pCountImage = imageDir + "/pcount.gif";
  String resetAllImage = imageDir + "/reset_all.gif";
  String undoImage =  "<img src="+imageDir+"/resetone.gif border=0>";
  String undoAll = nls.getString ("UndoAll");

  response.setContentType(nls.getString("ENCODESTATEMENT")); 

%>

<FONT SIZE=+1><b><!-- Product Exploration --></b></FONT>
<br>
<jsp:useBean id="category" class="com.ibm.commerce.catalog.beans.CategoryDataBean" >
<jsp:setProperty property="*" name="category" />
</jsp:useBean>


<%
  try {
    com.ibm.commerce.beans.DataBeanManager.activate(category, request);
  }
  catch(Exception e) {}

%>
<font size=+2><b>
<%= category.getDescription().getShortDescription() %>
</b></font>

<table>
<tr>
<td>


<jsp:useBean id="peDS" class="com.ibm.commerce.pa.beans.ProductExploreDataBean" scope="request">
	<jsp:setProperty property="*" name="peDS" />
</jsp:useBean>
<%
  //Add constraints which cannot be selected by the shopper, but which should
  //be used in constraining the list of entries available.
  //Store id isn't necessary unless the same product ids appear in multiple stores for the same category.
  //peDS.addConstraint("STOREID","=",store,"com.ibm.commerce.pa.datatype.DsInteger",languageId);
  peDS.addConstraint("LANGUAGE_ID","=",languageId,"com.ibm.commerce.pa.datatype.DsInteger",languageId);
  //Restrict search to match shopper's group, if available
  if (shopperGroup != null)
    peDS.addConstraint("IPSGNBR","=",shopperGroup,"com.ibm.commerce.pa.datatype.DsInteger",languageId);
  try {
    com.ibm.commerce.beans.DataBeanManager.activate(peDS, request);
  }
  catch(Exception e) {}



%>






<%

// Display the product count according to the languageID ... (-8 is for taiwan and -9 is for korean)
if(peDS.getCount()!=null)
{
if(languageId.equals("-8") || languageId.equals("-9"))
{
%>

<P><img src="<%=pCountImage%>" alt="" border="0" align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<BR> 
&nbsp;&nbsp;&nbsp;<FONT face="arial,helvetica" SIZE=+1><%= peDS.getCount() %></FONT><BR>
</td>


<%
}else{
%>

<P><FONT face="arial,helvetica" SIZE=+1><%= peDS.getCount() %></FONT><BR>
<img src="<%=pCountImage%>" alt="" border="0"><BR>
</td>

<%
}
}//Endof if(peDS.getCount()!=null)
%>


<td>
<jsp:useBean id="pcLink" class="com.ibm.commerce.pa.beans.GenericLinkDataBean" scope="request">
<jsp:setProperty property="linkPage" name="pcLink" value="pc51.jsp" />
<jsp:setProperty property="image"    name="pcLink" value="<%=pcImage%>" />
<jsp:setProperty property="text"     name="pcLink" value="<%=nls.getString (\"ProductComparison\")%>" />
<jsp:setProperty property="metaphor" name="pcLink" value="com.ibm.commerce.pa.metaphor.ProductComparerMetaphor" />
<jsp:setProperty property="*" name="pcLink" />
</jsp:useBean>
<%
  try {
    com.ibm.commerce.beans.DataBeanManager.activate(pcLink,request);
  }
  catch(Exception e) {}

%>
<%= pcLink.getDataElement().getPresentationString() %>
<jsp:useBean id="saLink" class="com.ibm.commerce.pa.beans.GenericLinkDataBean" scope="request" >
<jsp:setProperty property="linkPage" name="saLink" value="sa51.jsp"/>
<jsp:setProperty property="image"  name="saLink"   value="<%=saImage%>"/>
<jsp:setProperty property="text"  name="saLink"    value="<%=nls.getString (\"SalesAssistant\")%>"/>
<jsp:setProperty property="passConstraints"  name="saLink"    value="false"/>
<jsp:setProperty property="metaphor" name="saLink" value="com.ibm.commerce.pa.metaphor.SalesAssistantMetaphor" />
<jsp:setProperty property="*"        name="saLink" />
</jsp:useBean>

<%
  try {
    com.ibm.commerce.beans.DataBeanManager.activate(saLink, request);
  }
  catch(Exception e) {}

%>
<%= saLink.getDataElement().getPresentationString() %>
</td>
<td>
<%
  if (com.ibm.commerce.pa.util.ConstraintCollector.constraintsExist(request)) {%>

  <A href="pe51.jsp?<%=ECConstants.EC_CATEGORY_ID%>=<c:out value="<%= categoryId %>" />&<%=ECConstants.EC_LANGUAGE_ID%>=<c:out value="<%= languageId %>" />&<%=ECConstants.EC_STORE_ID%>=<c:out value="<%= store %>" />"><IMG src="<%=resetAllImage%>" alt="<%=undoAll%>" border="0"></A>
  <BR><FONT Size=-1><%=nls.getString ("UndoAll")%></FONT>
  <% }
%>
</td>

</tr>
</table>

<jsp:useBean id="peHeader" class="com.ibm.commerce.pa.widget.TableElement" scope="request">
    <jsp:setProperty name="peHeader" property="bgColor" value="#9999CC" />
    <jsp:setProperty name="peHeader" property="align"   value="LEFT" />
    <jsp:setProperty name="peHeader" property="font"    value="<font size='+1' face='helvitica,arial' weight=900>" />
    <jsp:setProperty property="*" name="peHeader" />
</jsp:useBean>
<jsp:useBean id="peCell" class="com.ibm.commerce.pa.widget.TableElement" scope="request">
    <jsp:setProperty name="peCell" property="bgColor" value="#CCCCFF" />
    <jsp:setProperty name="peCell" property="align"   value="LEFT" />
    <jsp:setProperty name="peCell" property="font"    value="<font size='-1' face='helvitica,arial'>" />
    <jsp:setProperty property="*" name="peCell" />
</jsp:useBean>
<!--------------- PE TABLE begin-------------------------->
<%
  String myValue = ECConstants.EC_CATEGORY_ID+","+ ECConstants.EC_STORE_ID+","+ ECConstants.EC_LANGUAGE_ID+",constr,user,currency";
%>
<TABLE CELLPADDING=5 CELLSPACING=2 BORDER=0 WIDTH=100% BGCOLOR=#ccccff >
<jsp:useBean id="peTable" class="com.ibm.commerce.pa.widget.DynamicForm" scope="request">
    <jsp:setProperty name="peTable" property="dataBeanName"      value="peDS" />
    <jsp:setProperty name="peTable" property="orientation"       value="VERTICAL" />
    <jsp:setProperty name="peTable" property="headerElementName" value="peHeader" />
    <jsp:setProperty name="peTable" property="cellElementName"   value="peCell" />
    <!-- param name="widgetType"        value="com.ibm.commerce.pa.widget.DropDownListFormElement" -->
</jsp:useBean>
    <jsp:setProperty name="peTable" property="action"            value="pe51.jsp" /> 
    <jsp:setProperty name="peTable" property="hiddenValues"      value="<%=myValue%>" />
    <jsp:setProperty name="peTable" property="formMode"          value="multi" />
    <jsp:setProperty name="peTable" property="undoText"          value="<%=undoImage%>" />
<%
  try {
    peTable.execute(request, response, out);
  }
  catch(Exception e) {}

%>
</TABLE>
<!--------------- PE TABLE end-------------------------->

</BODY>
</HTML>
