<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2013 All Rights Reserved.

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
<%@ page import="com.ibm.commerce.user.beans.*"   %>
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
   String searchOrg = null;
   String owningOrg = null;
   Long theOrg = null;
   boolean haveOrg = false;
   String resultmsg = null;
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

    resultmsg = (String) request.getParameter("resultmsg");
    searchOrg = (String) request.getParameter("searchOrg");
    owningOrg = searchOrg;   
    sortby = request.getParameter("orderby");
    startIndex = (String) request.getParameter("startindex");
    lstSize = (String) request.getParameter("listsize");
    int listSize = Integer.parseInt(lstSize);
    numberOfHits = (String) request.getParameter("numberOfHits");

    if(numberOfHits != null && !numberOfHits.equals(""))
     haveNumberOfHits = true;
                 
   // obtain the resource bundle for display
   Hashtable policyListNLS = (Hashtable)ResourceDirectory.lookup("policyeditor.policyeditorNLS", locale);      
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%= UIUtil.toHTML((String)policyListNLS.get("policyListTitle")) %></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

no_go = 0;

function getListSize() { 
     return <%= listSize %>; 
}

function onLoad() {
  parent.loadFrames();
}

function getSortby() {
  return "<%= UIUtil.toHTML(sortby) %>";
}

function getPolicyNewBCT() {
  return "<%= UIUtil.toJavaScript((String)policyListNLS.get("policyNewBCT")) %>";
}

function getPolicyChangeBCT(){
  return "<%= UIUtil.toJavaScript((String)policyListNLS.get("policyChangeBCT")) %>";
}

function getParentPoliciesBCT(){
  return "<%= UIUtil.toJavaScript((String)policyListNLS.get("parentPoliciesBCT")) %>";
}

function getPolicyListBCT() {
  return "<%= UIUtil.toJavaScript((String)policyListNLS.get("policylistBCT")) %>";
}

function getShowResourcesBCT() {
  return "<%= UIUtil.toJavaScript((String)policyListNLS.get("ResourcesBCT")) %>";
}

function getShowActionsBCT(){
  return "<%= UIUtil.toJavaScript((String)policyListNLS.get("ActionsBCT")) %>";
}

function getShowActionGroupBCT(){
  return "<%= UIUtil.toJavaScript((String)policyListNLS.get("ActionGroupBCT")) %>";
}

function getShowResourceGroupBCT() {
  return "<%= UIUtil.toJavaScript((String)policyListNLS.get("ResourceGroupBCT")) %>";
}
function getShowMemberGroupBCT() {
  return "<%= UIUtil.toJavaScript((String)policyListNLS.get("MemberGroupBCT")) %>";
}

function getShowPolicyDetailsBCT() {
  return "<%= UIUtil.toJavaScript((String)policyListNLS.get("PolicyDetailsBCT")) %>";
}


// This function is needed because the Framework keeps selected items from previous visits
function deSelectAll() 
{
  for (var i=0; i < document.policyListForm.elements.length; i++) 
  {
     var e = document.policyListForm.elements[i];
     if (e.type == 'checkbox' && e.name != 'select_deselect') 
     {
        parent.removeEntry(e.name);
 //       e.checked = false;
     }	
  }
}

function doNew() {
  if(no_go == 1) return;
  deSelectAll();
  top.setContent(getPolicyNewBCT(),
       top.getWebappPath() +'DialogView?XMLFile=policyeditor.policyNew' +
       '&amp;ActionXMLFile=policyeditor.PoliciesForSiteAdminView&amp;cmd=PoliciesForSiteAdminView' +
       '&amp;viewname=NewDynamicListView&amp;ownerId=' + getOwnerId(), true)
}

function doChange() {
  if(no_go == 1) return;
  checked = parent.getChecked();
  deSelectAll();
  top.setContent(getPolicyChangeBCT(),
       top.getWebappPath() +'DialogView?XMLFile=policyeditor.policyChange&amp;policyId=' + checked +
       '&amp;ActionXMLFile=policyeditor.PoliciesForSiteAdminView&amp;cmd=PoliciesForSiteAdminView' +
       '&amp;viewname=NewDynamicListView&amp;ownerId=' + getOwnerId(), true)
}

function doDelete() {
  if(no_go == 1) return;
  checked = parent.getChecked();
  var theURL = top.getWebappPath() +'PolicyDeleteCmd?policyId=' + checked +
  		  '&authToken=' + encodeURI('${authToken}') +
          '&amp;ownerId=' + getOwnerId() + '&amp;searchOrg=' + getOwnerId() +
          '&amp;viewtaskname=NewDynamicListView' +
          '&amp;ActionXMLFile=policyeditor.PoliciesForSiteAdminView&amp;cmd=PoliciesForSiteAdminView';
//  top.showContent(theURL);
   if (confirmDialog("<%=UIUtil.toJavaScript((String)policyListNLS.get("deleteConfirmMsg")) %>")) 
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
  if(no_go == 1) return;

  checked = parent.getChecked();
  deSelectAll();

top.setContent(getShowResourcesBCT(),
       top.getWebappPath() +'NewDynamicListView?ActionXMLFile=policyeditor.ResourcesForPolicyView&amp;cmd=ResourcesForPolicyView&amp;policyId=' + checked + '&amp;ownerId=' + getOwnerId(), true)
}

function doShowActions() {
 if(no_go == 1) return;
  checked = parent.getChecked();
  deSelectAll();

top.setContent(getShowActionsBCT(),
       top.getWebappPath() +'NewDynamicListView?ActionXMLFile=policyeditor.ActionsForPolicyView&amp;cmd=ActionsForPolicyView&amp;policyId=' + checked + '&amp;ownerId=' + getOwnerId(), true)
}
function doShowResourceGroup() {
 if(no_go == 1) return;
  checked = parent.getChecked();
  deSelectAll();

top.setContent(getShowResourceGroupBCT(),
       top.getWebappPath() +'NewDynamicListView?ActionXMLFile=policyeditor.ResourceGroupForPolicyView&amp;cmd=ResourceGroupForPolicyView&amp;policyId=' + checked + '&amp;ownerId=' + getOwnerId(), true)
}
function doShowActionGroup() {
 if(no_go == 1) return;
  checked = parent.getChecked();
  deSelectAll();

top.setContent(getShowActionGroupBCT(),
       top.getWebappPath() +'NewDynamicListView?ActionXMLFile=policyeditor.ActionGroupForPolicyView&amp;cmd=ActionGroupForPolicyView&amp;policyId=' + checked + '&amp;ownerId=' + getOwnerId(), true)
}
function doShowPolicyDetails() {
 if(no_go == 1) return;
  checked = parent.getChecked();
  deSelectAll();

top.setContent(getShowPolicyDetailsBCT(),
       top.getWebappPath() +'DialogView?XMLFile=policyeditor.PolicyDetailsForPolicyView&amp;policyId=' + checked +
       '&amp;ActionXMLFile=policyeditor.PoliciesForSiteAdminView&amp;cmd=PoliciesForSiteAdminView' +
       '&amp;viewname=NewDynamicListView&amp;ownerId=' + getOwnerId(), true)

}
function doShowMemberGroup() {
 if(no_go == 1) return;
  checked = parent.getChecked();
  deSelectAll();

top.setContent(getShowMemberGroupBCT(),
       top.getWebappPath() +'NewDynamicListView?ActionXMLFile=policyeditor.MemberGroupsForPolicyView&amp;cmd=MemberGroupsForPolicyView&amp;policyId=' + checked + '&amp;ownerId=' + getOwnerId(), true)
}



function changeOrg() {
   no_go = 1;
   var s = document.policyListForm.searchOrg.selectedIndex;
   var o = document.policyListForm.searchOrg.options[s].value;
  deSelectAll();
  var theURL2 = top.getWebappPath() +'NewDynamicListView?ActionXMLFile=policyeditor.PoliciesForSiteAdminView&amp;cmd=PoliciesForSiteAdminView&amp;searchOrg=' + o + '&amp;orderby=' + getSortby();
  top.setContent(getPolicyListBCT(), theURL2, false);
}
// -->
</SCRIPT>

<jsp:useBean id="orgListBean" class="com.ibm.commerce.accesscontrol.policyeditor.beans.PolicyMaintenanceOrgLightListBean" >
<jsp:setProperty property="*" name="orgListBean" />
<jsp:setProperty property="orgId" name="orgListBean" value="<%= searchOrg %>" />
</jsp:useBean>

<%
orgListBean.setCommandContext(aCommandContext);
//com.ibm.commerce.beans.DataBeanManager.activate(orgListBean, request);
//PolicyMaintenanceOrgLightDataBean[] oList = orgListBean.getOrgBeans();
//owningOrg = orgListBean.getOrgId();


OrgEntityManageDataBean bnOrgEntityManage = new OrgEntityManageDataBean();
com.ibm.commerce.beans.DataBeanManager.activate (bnOrgEntityManage, request);
String[][] oList = bnOrgEntityManage.getOrgEntityList();
owningOrg = orgListBean.getOrgId();


PolicyLightDataBean[] aList = null;
if (owningOrg != null && !owningOrg.equals(""))
  {
     haveOrg = true;
     theOrg = Long.valueOf(owningOrg);
%>

<jsp:useBean id="policyListBean" class="com.ibm.commerce.accesscontrol.policyeditor.beans.PolicyLightListBean" >
<jsp:setProperty property="*" name="policyListBean" />
<jsp:setProperty property="ownerId" name="policyListBean" value="<%= owningOrg %>" />
<jsp:setProperty property="languageId" name="policyListBean" value="<%= lang %>" />
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
      aList = policyListBean.getPolicyBeans();
      if(!haveNumberOfHits)
      {
        numberOfHits = policyListBean.getNumberOfHits();
      }
   }
  else
  {
     aList = new PolicyLightDataBean[0];
  }
%>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

function getOwnerId() {
   return "<%= owningOrg %>";
}

function getResultsSize() {
<%
if(haveOrg)
{
%>

   return <%= (numberOfHits == null ? null : new Integer(numberOfHits)) %>;
<%
}
else
{
%> 
  return "0";
<%
}
%>
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
<FORM NAME="policyListForm" action="" method="POST">

<%
  int totalpage;
  int totalsize;
  int start = Integer.parseInt(startIndex);
  int rowselect = 1;
  String nul = null;
  int currentpage = (start / listSize) + 1;
  if (haveOrg)
  {
  totalsize = Integer.parseInt(numberOfHits);
  totalpage = totalsize/listSize;
  // addControlPanel adds 1 to the page count which is ok unless the division doesn't result in a remainder
  if(totalsize == totalpage * listSize)
  {
   totalpage--;
  }
%>

<%= comm.addControlPanel("policyeditor.policyList",totalpage,totalsize,locale) %>
<LABEL for="searchOrg1">
<%= UIUtil.toHTML((String)policyListNLS.get("view")) %>
</LABEL>
<BR>
<SELECT NAME="searchOrg" onChange="changeOrg()" id="searchOrg1">

<%
}
else
{
%>
<BR>
<Label for="searchOrg1">
<%= UIUtil.toHTML((String)policyListNLS.get("chooseOrg")) %>
</Label>
<BR>&nbsp;<BR>
<SELECT NAME="searchOrg" onChange="changeOrg()" SIZE="<%= oList.length %>" id="searchOrg1">

<%
}
  for (int i = 0; i < oList.length ; i++)
  {
%>
  <OPTION VALUE="<%= oList[i][0] %>"
<%
   if(oList[i][0].equals(String.valueOf(theOrg)))
   {
%>
   selected
<%
   }
%>
  ><%= UIUtil.toHTML(oList[i][1]) %>
<%
   }
%>
</SELECT>

<%
if (haveOrg)
{
%>
<%= comm.startDlistTable(nul) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
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
<%= comm.addDlistCheck(aList[i].getPolicyId().toString(), "none") %>
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
<%
if( Integer.parseInt(numberOfHits) == 0 ) 
{
%>
<P>
<P>
<% 
     out.println( UIUtil.toHTML((String)policyListNLS.get("emptyPolicyList")) ); 
   }

}
%>
   
</FORM>

<SCRIPT>
<!--
parent.afterLoads();
<%
if(haveOrg)
{
%>
parent.setResultssize(getResultsSize());

<%
}
  if((!haveOrg) || theOrg.equals(ECConstants.EC_SITE_ORGANIZATION))
  {
%>     
parent.hideButton('parentPoliciesButton');
<%
  }

  if(!haveOrg)
  {
%>
parent.hideButton('newButton');
parent.hideButton('changeButton');
parent.hideButton('deleteButton');
<%
}
if(resultmsg != null && !resultmsg.equals(""))
{
%>
   alertDialog('<%= UIUtil.toJavaScript((String)policyListNLS.get(resultmsg)) %>');
   parent.generalForm.resultmsg.value = "";
<%
}

if(!haveNumberOfHits && haveOrg)
{
%>
  parent.generalForm.numberOfHits.value = "<%= UIUtil.toJavaScript(numberOfHits) %>";
<%
}
%>


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

