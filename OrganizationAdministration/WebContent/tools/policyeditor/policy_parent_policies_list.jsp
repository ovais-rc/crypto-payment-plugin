<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %> 
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.ibm.commerce.command.*"%>
<%@ page import="com.ibm.commerce.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.accesscontrol.policyeditor.util.*" %>
<%@ page import="com.ibm.commerce.accesscontrol.policyeditor.beans.*" %>
<%@ page import="com.ibm.commerce.accesscontrol.policyeditor.dbutil.*" %>

<%@include file="../common/common.jsp" %>

<%
try
{
%>

<HTML>
<HEAD>
<%= fHeader%>

<%        
   Locale locale = null;
   String lang = null;
   String sortby = null;
   String origOrg = null;
   String currentOrg = null;
   Long theOrg = null;
   String origOrderBy = null;
   String startIndex = null;
   String lstSize = null;
   String numberOfHits = null;
   boolean haveNumberOfHits = false;
                                
   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext"); 
      
         
   if( aCommandContext!= null )
   {
      locale = aCommandContext.getLocale();
      lang = aCommandContext.getLanguageId().toString();
   }

    origOrg = (String) request.getParameter("origOrg");
    currentOrg = (String) request.getParameter("currentOrg");
    origOrderBy = (String) request.getParameter("origOrderBy");
    sortby = request.getParameter("orderby");
    startIndex = (String) request.getParameter("startindex");
    lstSize = (String) request.getParameter("listsize");
    int listSize = Integer.parseInt(lstSize);
    numberOfHits = (String) request.getParameter("numberOfHits");
    String SiteAdminValue = (String) request.getParameter("SiteAdminValue");

    if(numberOfHits != null && !numberOfHits.equals(""))
     haveNumberOfHits = true;
                 
   // obtain the resource bundle for display
   Hashtable policyListNLS = (Hashtable)ResourceDirectory.lookup("policyeditor.policyeditorNLS", locale);      
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%= UIUtil.toHTML((String)policyListNLS.get("parentPoliciesListTitle")) %></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

var SiteAdmin = <%=(SiteAdminValue == null ? null : new Long(SiteAdminValue) )%>;

function getListSize() { 
     return <%= listSize %>; 
}

function onLoad() {
  parent.loadFrames();
}

function getSortby() {
  return "<%= UIUtil.toJavaScript(sortby) %>";
}

function getOrigOrderBy() {
   return "<%= UIUtil.toJavaScript(origOrderBy) %>";
}

function getPolicyListBCT() {
   return "<%= UIUtil.toJavaScript((String)policyListNLS.get("policylistBCT")) %>";
}

function getParentPoliciesBCT(){
  return "<%= UIUtil.toJavaScript((String)policyListNLS.get("parentPoliciesBCT")) %>";
}

function changeOrg() {
   var s = document.policyListForm.searchOrg.selectedIndex;
   var o = document.policyListForm.searchOrg.options[s].value;
   var orig = document.policyListForm.origOrg.value;
   var theURL2 = top.getWebappPath() +'NewDynamicListView?ActionXMLFile=policyeditor.parentPoliciesList' +    
                 '&amp;cmd=ParentPoliciesListView&amp;currentOrg=' + o + '&amp;origOrderBy=' + getOrigOrderBy() +
                 '&amp;origOrg=' + orig + '&amp;orderby=' + getSortby()+ '&amp;SiteAdminValue=' + SiteAdmin ;
  top.setContent(getParentPoliciesBCT(), theURL2, false);
}

function goBack() {
  var orig = document.policyListForm.origOrg.value;
  top.mccbanner.removebct();
if(SiteAdmin==1)
{  top.setContent(getPolicyListBCT(),top.getWebappPath() +'NewDynamicListView?ActionXMLFile=policyeditor.PoliciesForSiteAdminView&amp;cmd=PoliciesForSiteAdminView&amp;searchOrg=' + orig +
  '&amp;orderby=' + getOrigOrderBy(), false);
}
else
{
top.setContent(getPolicyListBCT(),top.getWebappPath() +'NewDynamicListView?ActionXMLFile=policyeditor.policyList&amp;cmd=PolicyListView&amp;searchOrg=' + orig +
  '&amp;orderby=' + getOrigOrderBy(), false);
}
}

// -->
</SCRIPT>

<jsp:useBean id="orgListBean" class="com.ibm.commerce.accesscontrol.policyeditor.beans.PolicyMaintenanceOrgLightListBean" >
<jsp:setProperty property="*" name="orgListBean" />
<jsp:setProperty property="orgId" name="orgListBean" value="<%= origOrg %>" />
<jsp:setProperty property="ancestorsFlag" name="orgListBean" value="Y" />
</jsp:useBean>

<%
orgListBean.setCommandContext(aCommandContext);
com.ibm.commerce.beans.DataBeanManager.activate(orgListBean, request);
PolicyMaintenanceOrgLightDataBean[] oList = orgListBean.getOrgBeans();
// If this is the first time, there will be no current (selected) organization.  Start with the first
// one in the list which is the immediate parent of the original organization.
if(currentOrg == null || currentOrg.equals(""))
{
  currentOrg = oList[0].getOrgEntityId().toString();
}
theOrg = Long.valueOf(currentOrg);
%>

<jsp:useBean id="policyListBean" class="com.ibm.commerce.accesscontrol.policyeditor.beans.PolicyLightListBean" >
<jsp:setProperty property="*" name="policyListBean" />
<jsp:setProperty property="ownerId" name="policyListBean" value="<%= currentOrg %>" />
<jsp:setProperty property="languageId" name="policyListBean" value="<%= lang %>" />
<jsp:setProperty property="viewOnly" name="policyListBean" value="1" />
<jsp:setProperty property="startIndex" name="policyListBean" value="<%= startIndex %>" />
<jsp:setProperty property="hitsPerPage" name="policyListBean" value="<%= lstSize %>" />
</jsp:useBean>

<%
   
   PolicySortingAttribute sort = new PolicySortingAttribute();
   
   String tempSort = sortby; 

   if ( sortby != null && !sortby.equals("null") && !sortby.equals("") ) 
   {
     if(sortby.equals(PolicyDescriptionTable.DESCRIPTION) || sortby.equals(PolicyDescriptionTable.DISPLAYNAME))
     {
       sort.setTableAlias("T2");
     }
     else if(sortby.equals("MBRGRPNAME"))
     {
       sort.setTableAlias("T4");
     }
     else if(sortby.equals("GROUPNAME"))
     {
       sort.setTableAlias("T8");
     }
     else if(sortby.equals("GRPNAME"))
     {
       sort.setTableAlias("T9");
     }
     else if(sortby.equals("RELATIONNAME"))
     {
       sort.setTableAlias("T10");
     }
     else
     {
       sort.setTableAlias("T1");
     }
     sort.addSorting(tempSort, true);
    }
    
   policyListBean.setSortAtt( sort );
   policyListBean.setCommandContext(aCommandContext);
   if(haveNumberOfHits)
      policyListBean.setNumberOfHits(numberOfHits);
   com.ibm.commerce.beans.DataBeanManager.activate(policyListBean, request);
   PolicyLightDataBean[] aList = policyListBean.getPolicyBeans();
   if(!haveNumberOfHits)
   {
        numberOfHits = policyListBean.getNumberOfHits();
   }
%>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

function getResultsSize() {
   return <%= (numberOfHits == null ? null : UIUtil.toJavaScript(numberOfHits)) %>;
}

function getCurrentOrg () {
   return <%= (currentOrg == null ? null : UIUtil.toJavaScript(currentOrg)) %>
}

// -->
</script>


<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

</HEAD>
<BODY class="content_list">
<SCRIPT LANGUAGE="JavaScript">
<!--
//For IE
if (document.all) {
    onLoad();
}
//-->
</SCRIPT>


<%
   int start = Integer.parseInt(startIndex);
   int rowselect = 1;
   int totalsize = Integer.parseInt(numberOfHits);
   int totalpage = totalsize/listSize;
   // addControlPanel adds 1 to the page count which is ok unless the division doesn't result in a remainder
   if(totalsize == totalpage * listSize)
   {
     totalpage--;
   }
   String nul = null;
   int currentpage = (start / listSize) + 1;
%>

<%= comm.addControlPanel("policyeditor.parentPoliciesList",totalpage,totalsize,locale) %>
<FORM NAME="policyListForm" action="" method="POST">

<LABEL for="searchOrg1">
<%= UIUtil.toHTML((String)policyListNLS.get("view")) %>
</LABEL>
<BR>
<SELECT NAME="searchOrg" onChange="changeOrg()" id="searchOrg1">
<%
  for (int i = 0; i < oList.length ; i++)
  {
%>
  <OPTION VALUE="<%= oList[i].getOrgEntityId().toString() %>"
<%
   if(oList[i].getOrgEntityId().equals(theOrg))
   {
%>
   selected
<%
   }
%>
  ><%= UIUtil.toHTML(oList[i].getOrgEntityName()) %>
<%
   }
%>
</SELECT>

<%= comm.startDlistTable(nul) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistColumnHeading((String) policyListNLS.get("policyNameHeader"), PolicyTable.POLICYNAME, sortby.equals(PolicyTable.POLICYNAME)) %>
<%= comm.addDlistColumnHeading((String) policyListNLS.get("displayNameHeader"), PolicyDescriptionTable.DISPLAYNAME, sortby.equals(PolicyDescriptionTable.DISPLAYNAME)) %>
<%= comm.addDlistColumnHeading((String)policyListNLS.get("policyDescriptionHeader"), PolicyDescriptionTable.DESCRIPTION, sortby.equals(PolicyDescriptionTable.DESCRIPTION)) %>
<%= comm.addDlistColumnHeading((String)policyListNLS.get("policyUserGroupHeader"), "MBRGRPNAME", sortby.equals("MBRGRPNAME")) %>
<%= comm.addDlistColumnHeading((String)policyListNLS.get("policyActionGroupHeader"), "GROUPNAME", sortby.equals("GROUPNAME")) %>
<%= comm.addDlistColumnHeading((String)policyListNLS.get("policyResourceGroupHeader"), "GRPNAME", sortby.equals("GRPNAME")) %>
<%= comm.addDlistColumnHeading((String)policyListNLS.get("policyRelationshipHeader"), "RELATIONNAME", sortby.equals("RELATIONNAME")) %>
<%= comm.endDlistRow() %>
         
<%
  for (int i = 0; i < aList.length ; i++)
  {
%>

<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)aList[i].getPolicyDefaultName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)aList[i].getPolicyName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)aList[i].getPolicyDescription()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)aList[i].getUserGroupName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)aList[i].getActionGroupDefaultName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)aList[i].getResourceGroupDefaultName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)aList[i].getRelationDefaultName()), "none") %>
<%= comm.endDlistRow() %>
  
<%   
     if(rowselect==1){
       rowselect = 2;
     }
     else{
       rowselect = 1;
     } 
   }    // end for
%>   

<%= comm.endDlistTable() %>

   <INPUT TYPE="HIDDEN" NAME="origOrg" VALUE="<%= UIUtil.toHTML(origOrg) %>"> 
</FORM>

<%
if( Integer.parseInt(numberOfHits) == 0) 
{
%>
<P>
<P>
<% 
     out.println( UIUtil.toHTML((String)policyListNLS.get("emptyPolicyList")) ); 
   }
%>

<SCRIPT>
<!--
<%
if(!haveNumberOfHits)
{
%>
  parent.generalForm.numberOfHits.value = "<%= UIUtil.toJavaScript(numberOfHits) %>";
<%
}
%>

parent.afterLoads();
parent.setResultssize(getResultsSize());

function visibleList(s){
  document.policyListForm.searchOrg.style.visibility = s;
}
//-->
</SCRIPT>
</BODY>
</HTML>

<%
}
catch(Exception e)
{
   ExceptionHandler.displayJspException(request, response, e);
}
%>