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

<jsp:useBean id="actionGroupForResourceGroupBean" class="com.ibm.commerce.accesscontrol.policyeditor.beans.ActionGroupLightListBeanUtility" >
<jsp:setProperty property="languageId" name="actionGroupForResourceGroupBean" value="<%= lang %>" />
</jsp:useBean>

<%
   
      PolicySortingAttribute sort = new PolicySortingAttribute();
      sortby = request.getParameter("orderby");
      String tempSort = sortby; 
      if ( sortby != null && !sortby.equals("null") && !sortby.equals("") ) 
      {
        if(sortby.equals("GROUPNAME"))
        {
          sort.setTableAlias("T5");
        }
        else if(sortby.equals("DISPLAYNAME"))
        {
          sort.setTableAlias("T4");
        }
        else
        {
          sort.setTableAlias("T5");
        }
        sort.addSorting(tempSort, true);
      }
      actionGroupForResourceGroupBean.setSortAtt( sort );
     
  String resourceGroupId= (String) request.getParameter("resourceGroupId");
   actionGroupForResourceGroupBean.setResourceGroupId(Integer.valueOf(resourceGroupId)) ;

   com.ibm.commerce.beans.DataBeanManager.activate(actionGroupForResourceGroupBean, request);
   ActionGroupLightDataBean[] aList = actionGroupForResourceGroupBean.getActionGroupBeans();
%>



<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

function getOwnerId() {
   return "<%= UIUtil.toJavaScript(owningOrg) %>";
}

function getResourceGroupId() {
   return "<%= UIUtil.toJavaScript(resourceGroupId) %>";
}

function getResultsSize() { 
     return <%= actionGroupForResourceGroupBean.getActionGroupBeans().length %>; 
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




function getactiongroupNewBCT() {
  return "<%= UIUtil.toJavaScript((String)PolicyUtilityNLS.get("actiongroupNewBCT")) %>";
}

function getactiongroupChangeBCT(){
  return "<%= UIUtil.toJavaScript((String)PolicyUtilityNLS.get("actiongroupChangeBCT")) %>";
}

function getactiongrouplistBCT() {
  return "<%= UIUtil.toJavaScript((String)PolicyUtilityNLS.get("actiongrouplistBCT")) %>";
}


function getShowActionsBCT(){
  return "<%= UIUtil.toJavaScript((String)PolicyUtilityNLS.get("ActionsBCT")) %>";
}

function getShowResourceGroupBCT() {
  return "<%= UIUtil.toJavaScript((String)PolicyUtilityNLS.get("ResourceGroupBCT")) %>";
}

function getShowPoliciesBCT() {
  return "<%= UIUtil.toJavaScript((String)PolicyUtilityNLS.get("PoliciesBCT")) %>";
}


// This function is needed because the Framework keeps selected items from previous visits
function deSelectAll() 
{
  for (var i=0; i < document.ActionGroupsForResourceGroupViewForm.elements.length; i++) 
  {
     var e = document.ActionGroupsForResourceGroupViewForm.elements[i];
     if (e.type == 'checkbox' && e.name != 'select_deselect') 
     {
        parent.removeEntry(e.name);
     }	
  }
}


function doShowActions() {
  checked = parent.getChecked();
  deSelectAll();

top.setContent(getShowActionsBCT(),
       top.getWebappPath() +'NewDynamicListView?ActionXMLFile=policyeditor.ActionsForActionGroupView&amp;cmd=ActionsForActionGroupView&amp;actionGroupId=' + checked + '&amp;ownerId=' + getOwnerId()
, true)
}
function doShowResourceGroup() {
  checked = parent.getChecked();
  deSelectAll();

top.setContent(getShowResourceGroupBCT(),
       top.getWebappPath() +'NewDynamicListView?ActionXMLFile=policyeditor.ResourceGroupsForActionGroupView&amp;cmd=ResourceGroupsForActionGroupView&amp;actionGroupId=' + checked + '&amp;ownerId=' + getOwnerId(), true)
}
function doShowPolicies() {
  checked = parent.getChecked();
  deSelectAll();

top.setContent(getShowPoliciesBCT(),
       top.getWebappPath() +'NewDynamicListView?ActionXMLFile=policyeditor.PoliciesForActionGroupView&amp;cmd=PoliciesForActionGroupView&amp;actionGroupId=' + checked + '&amp;ownerId=' + getOwnerId(), true)
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
          int totalsize = actionGroupForResourceGroupBean.getActionGroupBeans().length;
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

<%= comm.addControlPanel("policyeditor.ActionGroupsForResourceGroupView",totalpage,totalsize,locale) %>
<FORM NAME="ActionGroupsForResourceGroupViewForm" action="" method="GET">

<%= comm.startDlistTable(nul) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)PolicyUtilityNLS.get("NameHeader"), ActionGroupTable.GROUPNAME, sortby.equals(ActionGroupTable.GROUPNAME)) %>
<%= comm.addDlistColumnHeading((String)PolicyUtilityNLS.get("DisplayNameHeader"),ActionGroupDescriptionTable.DISPLAYNAME, sortby.equals(ActionGroupDescriptionTable.DISPLAYNAME)) %>
<%= comm.addDlistColumnHeading((String)PolicyUtilityNLS.get("DescriptionHeader"), "none", false) %>
<%= comm.endDlistRow() %>
         
<%
  for (int i = startIndex; i < endIndex ; i++)
  {
%>

<%= comm.startDlistRow(rowselect) %>

<%= comm.addDlistCheck(aList[i].getActionGroupId().toString(), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)aList[i].getActionGroupBaseName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)aList[i].getActionGroupName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)aList[i].getActionGroupDescription()), "none") %>
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
     out.println(UIUtil.toHTML((String)PolicyUtilityNLS.get("emptyActionGroupsForResourceGroupView"))); 
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

