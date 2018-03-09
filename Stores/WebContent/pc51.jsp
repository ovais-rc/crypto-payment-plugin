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

<!-- 
  //*----
  //* @deprecated The Product Advisor feature has been deprecated. For more information, see <a href="../../../../../../com.ibm.commerce.productadvisor.doc/concepts/cpaintro.htm">Product Advisor</a>.
  //*----
-->

<%@page language="java" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML  lang="en" xml:lang="en">
<head>
<title> </title>
</HEAD>
<BODY  BGCOLOR=#ffffff TEXT=#000000 LINK=#0000ff VLINK=#ff00ff ALINK=#ff0000>
<CENTER>

<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.marketingcenter.events.dbobjects.*" %>
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
  String peImage = imageDir + "/prod_asst.gif";
  String saImage = imageDir + "/sale_asst.gif";
  String sortImage = imageDir + "/sort.gif";
  String pCountImage = imageDir + "/pcount.gif";

  response.setContentType(nls.getString("ENCODESTATEMENT")); 

%>

<TABLE CELLSPACING=0 CELLPADDING=0 WIDTH=480 BORDER=0>
  <TR> <TD HEIGHT=20><TD WIDTH=480 HEIGHT=35 ROWSPAN=4 COLSPAN=12> </TR>
</TABLE>
</CENTER>

<!--------------- PC TABLE begin-------------------------->
<P>
<jsp:useBean id="pcHeader" class="com.ibm.commerce.pa.widget.TableElement" scope="request" >
<jsp:setProperty property="bgColor" name="pcHeader" value="#9999CC"/>
<jsp:setProperty property="align" name="pcHeader" value="CENTER"/>
<jsp:setProperty property="font" name="pcHeader" value="<font size='+1' face='helvitica,arial' weight=900>"/>
<jsp:setProperty property="*" name="pcHeader" />
</jsp:useBean>


<jsp:useBean id="pcCell" class="com.ibm.commerce.pa.widget.TableElement" scope="request">
<jsp:setProperty property="bgColor" name="pcCell" value="#CCCCFF"/>
<jsp:setProperty property="align" name="pcCell" value="LEFT"/>
<jsp:setProperty property="font" name="pcCell"  value="<font size='-1' face='helvitica,arial'>"/>
<jsp:setProperty property="*" name="pcCell" />
</jsp:useBean>

<%
  String prodParameterNames = ECConstants.EC_CATALOG_ID+","+ECConstants.EC_PRODUCT_ID+","+ECConstants.EC_STORE_ID+","+ECConstants.EC_LANGUAGE_ID;
	
  String pcStatsURL = "/webapp/wcs/stores/servlet/ClickInfo?evtype=PcProdDispClick"+
				"&" + PCStatsConstants.CATGROUP_ID + "=" + categoryId +
				"&" + PCStatsConstants.PCCLICKS + "=1" +
				"&" + ECConstants.EC_URL + "=/webapp/wcs/stores/servlet/ProductDisplay";
				
%>
<jsp:useBean id="pcDS" class="com.ibm.commerce.pa.beans.ProductCompareDataBean" scope="request">
<jsp:setProperty property="productLinkName" name="pcDS" value="<%= pcStatsURL%>"/>
<jsp:setProperty property="productLinkParameters" name="pcDS" value="<%= prodParameterNames%>"/>
<jsp:setProperty property="*" name="pcDS" />
</jsp:useBean>

<%
  //Add constraints which cannot be selected by the shopper, but which should
  //be used in constraining the list of entries available.
  //Store id isn't necessary unless the same product ids appear in multiple stores for the same category.
  //    pcDS.addConstraint("STOREID","=",store,"com.ibm.commerce.pa.datatype.DsInteger",languageId);
  pcDS.addConstraint("LANGUAGE_ID","=",languageId,"com.ibm.commerce.pa.datatype.DsInteger",languageId);
  try {
    com.ibm.commerce.beans.DataBeanManager.activate(pcDS, request);
  }
  catch(Exception e)
  {
	%>  <!-- No products to display --><BR> <%
  }
%>

<jsp:useBean id="sortByDS" class="com.ibm.commerce.pa.beans.SortByColumnDataBean" scope="request">
<jsp:setProperty property="parentName"  name="sortByDS" value="pcDS"/>
<jsp:setProperty property="image"    name="sortByDS"    value="<%=sortImage%>"/>
<jsp:setProperty property="text"      name="sortByDS"   value="<%=nls.getString (\"Sort\")%>"/>
<jsp:setProperty property="heading"  name="sortByDS"    value="Sort by"/>
<jsp:setProperty property="*" name="sortByDS" />
</jsp:useBean>


<%
  try {
    com.ibm.commerce.beans.DataBeanManager.activate(sortByDS, request);
  }
  catch(Exception e) {}
%>

<FONT SIZE=+1><!-- Side-by-Side Comparison of Product Features --></FONT><BR>
<jsp:useBean id="category" class="com.ibm.commerce.catalog.beans.CategoryDataBean" >
<jsp:setProperty property="*" name="category" />
</jsp:useBean>

<% 
  try {
    com.ibm.commerce.beans.DataBeanManager.activate(category, request);
  }
  catch(Exception e) {}

%>

<h1> <%= category.getDescription().getShortDescription() %> </h1>


<table>
<tr>
<td>


<%

// Display the product count according to the languageID ... (-8 is for taiwan and -9 is for korean)

if(pcDS.getCount()!=null)
{
if(languageId.equals("-8") || languageId.equals("-9"))
{
%>

<P><img src="<%=pCountImage%>" alt="" border="0" align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<BR> 
&nbsp;&nbsp;&nbsp;<FONT face="arial,helvetica" SIZE=+1><%= pcDS.getCount() %></FONT><BR>
</td>


<%
}else{
%>

<P><FONT face="arial,helvetica" SIZE=+1><%= pcDS.getCount() %></FONT><BR>
<img src="<%=pCountImage%>" alt="" border="0"><BR>
</td>

<%
}
}//Endof if(pcDS.getCount()!=null)
%>

<td>
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
</td>
<td>
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
</tr>
</table>


<TABLE CELLPADDING=5 CELLSPACING=2 BORDER=0>
<!-- TABLE CELLPADDING=5 CELLSPACING=2 BORDER=0 BGCOLOR=#ffcc99 -->
<jsp:useBean id="pcTable" class="com.ibm.commerce.pa.widget.DynamicTable" scope="request">
<jsp:setProperty property="dataBeanName"  name="pcTable"  value="pcDS"/>
<jsp:setProperty property="orientation"   name="pcTable"    value="VERTICAL"/>
<jsp:setProperty property="headerElementName" name="pcTable" value="pcHeader"/>
<jsp:setProperty property="cellElementName" name="pcTable"  value="pcCell"/>
<jsp:setProperty property="altCellBgColor"  name="pcTable"  value="#ffffff"/>
<jsp:setProperty property="*" name="pcTable" />
</jsp:useBean>

<%
  try {
    pcTable.execute(request, response, out);
  }
  catch(Exception e) {}

%>
    <!-- param name="itemNames"         value="prnbr, prsdesc, ppprc" -->
    <!-- param name="pageSize"          value="5" -->
</TABLE>
<P>

</BODY>
</HTML>
