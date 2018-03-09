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
   String resGrpsNotDeleted = null;
                          
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
 
   // obtain the resource bundle for display
   Hashtable resourcegroupListNLS = (Hashtable)ResourceDirectory.lookup("policyeditor.policyeditorNLS", locale);      
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%= UIUtil.toHTML((String)resourcegroupListNLS.get("resourceGroupListTitle")) %></TITLE>

<jsp:useBean id="resourcegroupListBean" class="com.ibm.commerce.accesscontrol.policyeditor.beans.ResourceGroupLightListBean" >
<jsp:setProperty property="*" name="resourcegroupListBean" />
<jsp:setProperty property="languageId" name="resourcegroupListBean" value="<%= lang %>" />
</jsp:useBean>

<%

      PolicySortingAttribute sort = new PolicySortingAttribute();
      sortby = request.getParameter("orderby");
      String tempSort = sortby; 
      if ( sortby != null && !sortby.equals("null") && !sortby.equals("") ) 
      {
        if(sortby.equals("GRPNAME"))
        {
          sort.setTableAlias("T1");
        }
        else if(sortby.equals("DISPLAYNAME"))
        {
          sort.setTableAlias("T2");
        }
        else
        {
          sort.setTableAlias("T1");
        }
        sort.addSorting(tempSort, true);
      }
      resourcegroupListBean.setSortAtt( sort );  
     
   com.ibm.commerce.beans.DataBeanManager.activate(resourcegroupListBean, request);
   ResourceGroupLightDataBean[] aList = resourcegroupListBean.getResourceGroupBeans();
%>



<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers


function getResultsSize() { 
     return <%= resourcegroupListBean.getResourceGroupBeans().length %>; 
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



function getresourcegroupNewBCT() {
  return "<%= UIUtil.toJavaScript((String)resourcegroupListNLS.get("resourcegroupNewBCT")) %>";
}

function getresourcegroupChangeBCT(){
  return "<%= UIUtil.toJavaScript((String)resourcegroupListNLS.get("resourcegroupChangeBCT")) %>";
}

function getresourcegrouplistBCT() {
  return "<%= UIUtil.toJavaScript((String)resourcegroupListNLS.get("resourcegrouplistBCT")) %>";
}

function getShowResourcesBCT(){
  return "<%= UIUtil.toJavaScript((String)resourcegroupListNLS.get("ResourcesBCT")) %>";
}

function getShowActionGroupBCT() {
  return "<%= UIUtil.toJavaScript((String)resourcegroupListNLS.get("ActionGroupBCT")) %>";
}

function getShowPoliciesBCT() {
  return "<%= UIUtil.toJavaScript((String)resourcegroupListNLS.get("PoliciesBCT")) %>";
}

// This function is needed because the Framework keeps selected items from previous visits
function deSelectAll() 
{
  for (var i=0; i < document.resourcegroupListForm.elements.length; i++) 
  {
     var e = document.resourcegroupListForm.elements[i];
     if (e.type == 'checkbox' && e.name != 'select_deselect') 
     {
        parent.removeEntry(e.name);
//        e.checked = false;
     }	
  }
}

function doNew() {
  deSelectAll();
      var theURL =top.getWebappPath() +'WizardView?XMLFile=policyeditor.resourcegroupNew' +
       '&amp;viewname=NewDynamicListView'+
       '&amp;ActionXMLFile=policyeditor.resourcegroupsList&amp;cmd=resourcegroupListView';

 top.setContent(getresourcegroupNewBCT(), theURL, true)
}

function doChange() {
  checked = parent.getChecked();
  deSelectAll();
      var theURL =top.getWebappPath() +'WizardView?XMLFile=policyeditor.resourcegroupChange' +
       '&authToken=' + encodeURI('${authToken}') +
       '&amp;resGrpId=' + checked +
       '&amp;viewname=NewDynamicListView&amp;lang=' + getLang() +
       '&amp;ActionXMLFile=policyeditor.resourcegroupsList&amp;cmd=resourcegroupListView';
//    alert(theURL);

  top.setContent(getresourcegroupChangeBCT(), theURL, true)
}

function doDelete() {
  checked = parent.getChecked();
  var theURL = top.getWebappPath() +'ResGrpDeleteCmd?resGrpId=' + checked + 
     '&authToken=' + encodeURI('${authToken}') +
     '&amp;viewtaskname=NewDynamicListView' +
     '&amp;ActionXMLFile=policyeditor.resourcegroupsList&amp;cmd=resourcegroupListView';
//  top.showContent(theURL);
   if (confirmDialog("<%=UIUtil.toJavaScript((String)resourcegroupListNLS.get("deleteConfirmMsg")) %>")) 
   {
    deSelectAll();
    if (top.setContent)
    {
      top.showContent(theURL); 
      top.refreshBCT(); 
    }
    else
    {
      parent.location.replace(theURL);
    }
   }
}

function doShowResources() {

  checked = parent.getChecked();
  deSelectAll();

top.setContent(getShowResourcesBCT(),
       top.getWebappPath() +'NewDynamicListView?ActionXMLFile=policyeditor.ResourcesForResourceGroupView&amp;cmd=ResourcesForResourceGroupView&amp;resourceGroupId=' + checked, true)
}

function doShowActionGroup() {
  checked = parent.getChecked();
  deSelectAll();

top.setContent(getShowActionGroupBCT(),
       top.getWebappPath() +'NewDynamicListView?ActionXMLFile=policyeditor.ActionGroupsForResourceGroupView&amp;cmd=ActionGroupsForResourceGroupView&amp;resourceGroupId=' + checked, true)
}

function doShowPolicies() {
  checked = parent.getChecked();
  deSelectAll();

top.setContent(getShowPoliciesBCT(),
       top.getWebappPath() +'NewDynamicListView?ActionXMLFile=policyeditor.PoliciesForResourceGroupView&amp;cmd=PoliciesForResourceGroupView&amp;resourceGroupId=' + checked, true)
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
          int totalsize = resourcegroupListBean.getResourceGroupBeans().length;
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

<%= comm.addControlPanel("policyeditor.resourcegroupsList",totalpage,totalsize,locale) %>
<FORM NAME="resourcegroupListForm" action="" method="GET">

<%= comm.startDlistTable(nul) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)resourcegroupListNLS.get("resourcegroupNameHeader"), ResourceGroupTable.GRPNAME, sortby.equals(ResourceGroupTable.GRPNAME)) %>
<%= comm.addDlistColumnHeading((String)resourcegroupListNLS.get("displayNameHeader"), ResourceGroupDescriptionTable.DISPLAYNAME, sortby.equals(ResourceGroupDescriptionTable.DISPLAYNAME)) %>
<%= comm.addDlistColumnHeading((String)resourcegroupListNLS.get("resourcegroupDescriptionHeader"), "none", false) %>
<%= comm.endDlistRow() %>
         
<%
  for (int i = startIndex; i < endIndex ; i++)
  {
%>

<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(aList[i].getResourceGroupId().toString(), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)aList[i].getResourceGroupBaseName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)aList[i].getResourceGroupName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)aList[i].getResourceGroupDescription()), "none") %>
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
     out.println(UIUtil.toHTML((String)resourcegroupListNLS.get("emptyresourcegroupList"))); 
   }
%>


<SCRIPT>
<!--
   parent.afterLoads();
   parent.setResultssize(getResultsSize());
<%
if(resultmsg != null && !resultmsg.equals("") && resultmsg.equals("resourceGroupDeleteNotAllowed"))
{
resGrpsNotDeleted = (String) request.getParameter("resGrpsNotDeleted");
int countNotdeleted = Integer.parseInt((String)request.getParameter("countNotDeleted"));
if (countNotdeleted < 5) 
{
	resultmsg = resGrpsNotDeleted + " " + UIUtil.toHTML((String)resourcegroupListNLS.get(resultmsg));
}
else
{
	resultmsg = resGrpsNotDeleted + " " + UIUtil.toHTML((String)resourcegroupListNLS.get("deleteFirstFive")) 
				+ " " +  countNotdeleted + " " + UIUtil.toHTML((String)resourcegroupListNLS.get("resourceGroupNotDeleted"))
				+ " " + UIUtil.toHTML((String)resourcegroupListNLS.get(resultmsg));	
}
%>
   alertDialog('<%= UIUtil.toJavaScript(resultmsg)%>');
   parent.generalForm.resultmsg.value = "";
   parent.generalForm.resGrpsNotDeleted.value="";
<%
}
else
{
if(resultmsg != null && !resultmsg.equals(""))
{
%>
   alertDialog('<%= UIUtil.toJavaScript((String)resourcegroupListNLS.get(resultmsg))%>');
   parent.generalForm.resultmsg.value = "";
<%
}
}
%>
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

