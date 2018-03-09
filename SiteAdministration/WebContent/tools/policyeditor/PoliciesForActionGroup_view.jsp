<!-- ========================================================================
//********************************************************************  
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
 ===========================================================================-->



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
   String userId = null;    
   Locale locale = null;
   String storeId = null;
   String lang = null;
   String sortby = null;
   String searchOrg = null;
   String owningOrg = null;
   String registerType = null;
   String resultmsg = null;
   String actGrpsNotDeleted = null;                          

   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext"); 
      
         
   if( aCommandContext!= null )
   {
      locale = aCommandContext.getLocale();
      storeId = aCommandContext.getStoreId().toString();
      lang = aCommandContext.getLanguageId().toString();
      userId = aCommandContext.getUserId().toString();
      registerType = aCommandContext.getUser().getRegisterType();
   }

    resultmsg = (String) request.getParameter("resultmsg");
    owningOrg = (String) request.getParameter("ownerId"); 
 
   // obtain the resource bundle for display
   Hashtable PolicyUtilityNLS = (Hashtable)ResourceDirectory.lookup("policyeditor.policyeditorNLS", locale);      
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%= UIUtil.toHTML((String)PolicyUtilityNLS.get("ResourcesViewTitle")) %></TITLE>

<jsp:useBean id="policiesForActionGroupBean" class="com.ibm.commerce.accesscontrol.policyeditor.beans.PolicyLightListBeanUtility" >
<jsp:setProperty property="languageId" name="policiesForActionGroupBean" value="<%= lang %>" />
</jsp:useBean>

<%
   
      PolicySortingAttribute sort = new PolicySortingAttribute();
      sortby = request.getParameter("orderby");
      String tempSort = sortby; 
     if ( sortby != null && !sortby.equals("null") && !sortby.equals("") ) 
      {
       if(sortby.equals(PolicyDescriptionTable.DESCRIPTION) || sortby.equals(PolicyDescriptionTable.DISPLAYNAME))
        {
          sort.setTableAlias("T1");
        }
        
        else
        {
          sort.setTableAlias("T2");
        }
        sort.addSorting(tempSort, true);
      }
      policiesForActionGroupBean.setSortAtt( sort );
     
      String actionGroupId= (String) request.getParameter("actionGroupId");
   policiesForActionGroupBean.setActionGroupId(Integer.valueOf(actionGroupId)) ;
 com.ibm.commerce.beans.DataBeanManager.activate(policiesForActionGroupBean, request);
   PolicyLightDataBean[] aList = policiesForActionGroupBean.getPolicyBeans();
%>



<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
function getOwnerId() {
   return "<%= UIUtil.toJavaScript(owningOrg) %>";
}

function getActionGroupId() {
   return "<%= UIUtil.toJavaScript(actionGroupId) %>";
}


function getResultsSize() { 
     return <%= policiesForActionGroupBean.getPolicyBeans().length %>; 
}


function onLoad() {
  parent.loadFrames();
}

function getLang() {
  return "<%= lang %>";
}

function getSortby() {
     return "<%= UIUtil.toJavaScript(sortby) %>";
}


function getPolicyNewBCT() {
  return "<%= UIUtil.toJavaScript((String)PolicyUtilityNLS.get("policyNewBCT")) %>";
}

function getPolicyChangeBCT(){
  return "<%= UIUtil.toJavaScript((String)PolicyUtilityNLS.get("policyChangeBCT")) %>";
}


function getPolicyListBCT() {
  return "<%= UIUtil.toJavaScript((String)PolicyUtilityNLS.get("policylistBCT")) %>";
}


function getShowResourcesBCT() {
  return "<%= UIUtil.toJavaScript((String)PolicyUtilityNLS.get("ResourcesBCT")) %>";
}

function getShowActionsBCT(){
  return "<%= UIUtil.toJavaScript((String)PolicyUtilityNLS.get("ActionsBCT")) %>";
}

function getShowActionGroupBCT(){
  return "<%= UIUtil.toJavaScript((String)PolicyUtilityNLS.get("ActionGroupBCT")) %>";
}

function getShowResourceGroupBCT() {
  return "<%= UIUtil.toJavaScript((String)PolicyUtilityNLS.get("ResourceGroupBCT")) %>";
}
function getShowPolicyDetailsBCT() {
  return "<%= UIUtil.toJavaScript((String)PolicyUtilityNLS.get("PolicyDetailsBCT")) %>";
}
function getShowMemberGroupBCT() {
  return "<%= UIUtil.toJavaScript((String)PolicyUtilityNLS.get("MemberGroupBCT")) %>";
}


// This function is needed because the Framework keeps selected items from previous visits
function deSelectAll() 
{
  for (var i=0; i < document.PoliciesForActionGroupViewForm.elements.length; i++) 
  {
     var e = document.PoliciesForActionGroupViewForm.elements[i];
     if (e.type == 'checkbox' && e.name != 'select_deselect') 
     {
        parent.removeEntry(e.name);
     }	
  }
}


function doShowResources() {

  checked = parent.getChecked();
  deSelectAll();

top.setContent(getShowResourcesBCT(),
       top.getWebappPath() +'NewDynamicListView?ActionXMLFile=policyeditor.ResourcesForPolicyView&amp;cmd=ResourcesForPolicyView&amp;policyId=' + checked + '&amp;ownerId=' + getOwnerId(), true)
}

function doShowActions() {
  checked = parent.getChecked();
  deSelectAll();

top.setContent(getShowActionsBCT(),
       top.getWebappPath() +'NewDynamicListView?ActionXMLFile=policyeditor.ActionsForPolicyView&amp;cmd=ActionsForPolicyView&amp;policyId=' + checked + '&amp;ownerId=' + getOwnerId(), true)
}
function doShowResourceGroup() {
  checked = parent.getChecked();
  deSelectAll();

top.setContent(getShowResourceGroupBCT(),
       top.getWebappPath() +'NewDynamicListView?ActionXMLFile=policyeditor.ResourceGroupForPolicyView&amp;cmd=ResourceGroupForPolicyView&amp;policyId=' + checked + '&amp;ownerId=' + getOwnerId(), true)
}
function doShowActionGroup() {
  checked = parent.getChecked();
  deSelectAll();

top.setContent(getShowActionGroupBCT(),
       top.getWebappPath() +'NewDynamicListView?ActionXMLFile=policyeditor.ActionGroupForPolicyView&amp;cmd=ActionGroupForPolicyView&amp;policyId=' + checked + '&amp;ownerId=' + getOwnerId(), true)
}

function doShowPolicyDetails() {

  checked = parent.getChecked();
  deSelectAll();

top.setContent(getShowPolicyDetailsBCT(),
       top.getWebappPath() +'DialogView?XMLFile=policyeditor.PolicyDetailsForPolicyView&amp;policyId=' + checked +
       '&amp;ActionXMLFile=policyeditor.policyList&amp;cmd=PolicyListView' +
       '&amp;viewname=NewDynamicListView&amp;ownerId=' + getOwnerId(), true)

}
function doShowMemberGroup() {
  checked = parent.getChecked();
  deSelectAll();

top.setContent(getShowMemberGroupBCT(),
       top.getWebappPath() +'NewDynamicListView?ActionXMLFile=policyeditor.MemberGroupsForPolicyView&amp;cmd=MemberGroupsForPolicyView&amp;policyId=' + checked + '&amp;ownerId=' + getOwnerId(), true)
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
          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));
          int endIndex = startIndex + listSize;
          if (endIndex > aList.length )
          {
            endIndex = aList.length;
          }
          int rowselect = 1;
          int totalsize = policiesForActionGroupBean.getPolicyBeans().length;
          int totalpage = totalsize/listSize;
          // addControlPanel adds 1 to the page count which is ok unless the division doesn't result in a remainder
          if(totalsize == totalpage * listSize)
          {
            totalpage--;
          }
          String nul = null;
          int currentpage = (startIndex / listSize) + 1;
          String statusString = null;
          int status;
%>

<%= comm.addControlPanel("policyeditor.PoliciesForActionGroupView",totalpage,totalsize,locale) %>
<FORM NAME="PoliciesForActionGroupViewForm" action="" method="GET">

<%= comm.startDlistTable(nul) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)PolicyUtilityNLS.get("NameHeader"), PolicyTable.POLICYNAME, sortby.equals(PolicyTable.POLICYNAME)) %>
<%= comm.addDlistColumnHeading((String)PolicyUtilityNLS.get("DisplayNameHeader"),PolicyDescriptionTable.DISPLAYNAME, sortby.equals(PolicyDescriptionTable.DISPLAYNAME)) %>
<%= comm.addDlistColumnHeading((String)PolicyUtilityNLS.get("DescriptionHeader"),PolicyDescriptionTable.DESCRIPTION, sortby.equals(PolicyDescriptionTable.DESCRIPTION)) %>
<%= comm.endDlistRow() %>
         
<%
  for (int i = startIndex; i < endIndex ; i++)
  {
%>

<%= comm.startDlistRow(rowselect) %>

<%= comm.addDlistCheck(aList[i].getPolicyId().toString(), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)aList[i].getPolicyDefaultName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)aList[i].getPolicyName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)aList[i].getPolicyDescription()), "none") %>

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

   
</FORM>

<% if( aList.length == 0 ) {%>
<P>
<P>
<% 
     out.println(UIUtil.toHTML((String)PolicyUtilityNLS.get("emptyPoliciesForActionGroupView"))); 
   }
%>


<SCRIPT>
<!--
           parent.afterLoads();
           parent.setResultssize(getResultsSize());
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

