<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<!--
  The sample templates, HTML and Macros are furnished by IBM as sample
examples to provide an illustration. These examples have not been
thoroughly tested under all conditions.  IBM, therefore, cannot guarrantee or
imply reliability, serviceability, of function of these programs. All
programs contained herein are provided to you "AS IS"

  The sample templates, HTML, and Macros may include the names of individuals,
companies, brands and products in order to illustrate them as completely as
possible. All of these names are ficticious and any similarity to the names
and addresses used by an actual business enterprise is entirely coincidental.

(C) Copyright IBM Corp. 1995, 2002
  -->

<head>
<STYLE TYPE="text/css">
<!--
font.question {font-family: arial, helvetica, sans-serif;font-size: 12pt;color: black;padding: 0px;margin: 0px;};
font.answer {font-family: arial, helvetica, sans-serif;font-size: 9pt;color: black;padding: 0px;margin: 0px;};
-->
</STYLE>
<title> </title>
</head>
<BODY  BGCOLOR=#ffffff TEXT=#000000 LINK=#0000ff VLINK=#ff00ff ALINK=#ff0000>
<CENTER>
<TABLE CELLSPACING=0 CELLPADDING=0 WIDTH=480 BORDER=0>
  <TR> <TD HEIGHT=20><TD WIDTH=480 HEIGHT=35 ROWSPAN=4 COLSPAN=12> </TR>
</TABLE>
</CENTER>
<FONT SIZE=+1><b><!-- Sales Assistance --></b></FONT>

<br>
<!----   jsp starts here ----------->
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.marketingcenter.events.dbobjects.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="java.util.*" %>
<%@ page session="false" %>

<%@ page contentType="text/html; charset=UTF-8" %>

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
  String peImage = imageDir + "/prod_asst.gif";
  String pcImage = imageDir + "/prod_comp.gif";
  String pCountImage = imageDir + "/pcount.gif";
  String bulletImage = imageDir + "/bullet.gif";

  response.setContentType(nls.getString("ENCODESTATEMENT")); 
 
%>

<jsp:useBean id="category" class="com.ibm.commerce.catalog.beans.CategoryDataBean" >
<jsp:setProperty property="*" name="category" />
</jsp:useBean>

<%
  try {
    com.ibm.commerce.beans.DataBeanManager.activate(category, request); 
  }
  catch(Exception e) {}

%>

<font size=+2><b> <%= category.getDescription().getShortDescription() %> </b></font>
<br>


<!-- Sales Assistant Questions and Answers -->
<jsp:useBean id="qanda" class="com.ibm.commerce.pa.beans.SalesAssistantDataBean" scope="request">
<jsp:setProperty property="*" name="qanda" />
</jsp:useBean>
<%
  //Add constraints which cannot be selected by the shopper, but which should
  //be used in constraining the list of entries available.
  //Store id isn't necessary unless the same product ids appear in multiple stores for the same category.
  //qanda.addConstraint("STOREID","=",store,"com.ibm.commerce.pa.datatype.DsInteger",languageId);
  qanda.addConstraint("LANGUAGE_ID","=",languageId,"com.ibm.commerce.pa.datatype.DsInteger",languageId);
  try {
    com.ibm.commerce.beans.DataBeanManager.activate(qanda, request);
  }
  catch(Exception e) {}

%>
<br>

<%

// Display the product count according to the languageID ... (-8 is for taiwan and -9 is for korean)

if(qanda.getCount()!=null)
{
if(languageId.equals("-8") || languageId.equals("-9"))
{
%>

<P><img src="<%=pCountImage%>" alt="" border="0" align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<BR> 
&nbsp;&nbsp;&nbsp;<FONT face="arial,helvetica" SIZE=+1><%= qanda.getCount() %></FONT><BR>
</td>


<%
}else{
%>

<P><FONT face="arial,helvetica" SIZE=+1><%= qanda.getCount() %></FONT><BR>
<img src="<%=pCountImage%>" alt="" border="0"><BR>
</td>

<%
}
}//if(qanda.getCount()!=null)
%>

<br>
<!----- Product Explorer and Product Comparison Links -------->
<br>
<jsp:useBean id="peLink" class="com.ibm.commerce.pa.beans.GenericLinkDataBean" scope="request">
<jsp:setProperty property="linkPage" name="peLink" value="pe51.jsp" />
<jsp:setProperty property="image"    name="peLink" value="<%=peImage%>" />
<jsp:setProperty property="text"     name="peLink" value="<%=nls.getString (\"ProductExplorer\")%>" />
<jsp:setProperty property="metaphor" name="peLink" value="com.ibm.commerce.pa.metaphor.ProductExplorerMetaphor" />
<jsp:setProperty property="*"        name="peLink" />
</jsp:useBean>
<%
  try {
    com.ibm.commerce.beans.DataBeanManager.activate(peLink,request);
  }
  catch(Exception e) {}

%>
<%= peLink.getDataElement().getPresentationString() %>
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
<br>
<br>
<br>



<font class="question"> 
<%= qanda.getQuestion() %>
</font>
<br>
<!-----   Answers ---->
<%
  try {
    com.ibm.commerce.pa.datatype.DsData[] answers = qanda.getAnswers();
    for (int i = 0; i < answers.length; i++)
    {
       com.ibm.commerce.pa.datatype.DsData ans = answers[i];
       %>
       <img src="<%=bulletImage%>" alt="" height=10 width=10>&nbsp<font class="answer"><%= ans.getPresentationString() %></font><br><br>
       <%
    }
  }
  catch(Exception e) {}

%>
<br>

<!-----   History ---->
<P>
<HR>
<font class="question"> 
<b>
<%=nls.getString ("History")%>
</b>
</font>
<br>

<jsp:useBean id="histDS" class="com.ibm.commerce.pa.beans.SalesAssistantHistoryDataBean" scope="request">
</jsp:useBean>

<%
  try {
    com.ibm.commerce.beans.DataBeanManager.activate(histDS, request);
  }
  catch(Exception e) {}

%>

<jsp:useBean id="historyTable" class="com.ibm.commerce.pa.widget.SalesAssistantHistoryWidget" scope="request">
<jsp:setProperty property="reverseOrder" name="historyTable" value="false" />
<jsp:setProperty property="title"        name="historyTable" value=" " />
<jsp:setProperty property="textNone"     name="historyTable" value=" " />
<jsp:setProperty property="dataBeanName" name="historyTable" value="histDS" />
</jsp:useBean>
<%
  try {
    historyTable.execute(request, response, out);
  }
  catch(Exception e) {}

%>
</body>
</html>
