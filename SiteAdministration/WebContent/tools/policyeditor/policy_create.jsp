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

<%@page import="com.ibm.commerce.tools.util.*" %>
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
   String lang = null;
   String ownerId = null;
   String resourceGroupId = null;
   String viewname = null;
   String ActionXMLFile = null;
   String cmd = null;
   boolean haveResourceGroupId = false;
   int resGrpId = -1;
   Long theOwner = null;
                       
   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext"); 
         
   if( aCommandContext!= null )
   {
      locale = aCommandContext.getLocale();
      lang = aCommandContext.getLanguageId().toString();
      userId = aCommandContext.getUserId().toString();
   }

   resourceGroupId = (String) request.getParameter("resourceGroupId");
   ownerId = (String) request.getParameter("ownerId");
   theOwner = Long.valueOf(ownerId);
   viewname = (String) request.getParameter("viewname");
   ActionXMLFile = (String) request.getParameter("ActionXMLFile");
   cmd = (String) request.getParameter("cmd");
   if(resourceGroupId != null && !resourceGroupId.equals(""))
   {
     try
     {
       resGrpId = Integer.parseInt(resourceGroupId);
       haveResourceGroupId = true;
     }
     catch (Exception ex) { }
   }
   
   // obtain the resource bundle for display
   Hashtable policyNLS = (Hashtable)ResourceDirectory.lookup("policyeditor.policyeditorNLS", locale);      

   PolicySortingAttribute sort = new PolicySortingAttribute();
   sort.setTableAlias("T1");
   sort.addSorting(ResourceGroupTable.GRPNAME, true);
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%= UIUtil.toHTML((String)policyNLS.get("newPolicy")) %></TITLE>

<jsp:useBean id="resourceGroupListBean" class="com.ibm.commerce.accesscontrol.policyeditor.beans.ResourceGroupLightListBean" >
<jsp:setProperty property="*" name="resourceGroupListBean" />
<jsp:setProperty property="languageId" name="resourceGroupListBean" value="<%= lang %>" />
<jsp:setProperty property="filterForActionGroups" name="resourceGroupListBean" value="Y" />
</jsp:useBean>

<%
   resourceGroupListBean.setSortAtt( sort );
   com.ibm.commerce.beans.DataBeanManager.activate(resourceGroupListBean, request);
   ResourceGroupLightDataBean[] aList = resourceGroupListBean.getResourceGroupBeans();
%>



<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT Language="JavaScript">

// Change these as appropriate		
policyNameMissing = "<%= UIUtil.toJavaScript((String)policyNLS.get("policyNameMissing")) %>";
displayNameMissing = "<%= UIUtil.toJavaScript((String)policyNLS.get("displayNameMissing")) %>";
resourceGroupMissing = "<%= UIUtil.toJavaScript((String)policyNLS.get("resourceGroupMissing")) %>";
actionGroupMissing = "<%= UIUtil.toJavaScript((String)policyNLS.get("actionGroupMissing")) %>";
userGroupMissing = "<%= UIUtil.toJavaScript((String)policyNLS.get("userGroupMissing")) %>";
InputFieldMax = "<%= UIUtil.toJavaScript((String)policyNLS.get("InputFieldMax")) %>";


function initializeState()
{
  parent.setContentFrameLoaded(true);
}

// Go back to the JSP to repopulate the action group and relation drop downs if the resource group changes.
function rePopulateActionGroups()
{
  top.saveData(document.createForm.policyName.value, "POLICY_policyName");
  top.saveData(document.createForm.policyDisplayName.value,"POLICY_policyDisplayName");
  top.saveData(document.createForm.policyDescription.value, "POLICY_policyDescription");
  top.saveData(document.createForm.userGroupId.value, "POLICY_userGroupId");
  top.saveData(document.createForm.userGroup.value, "POLICY_userGroup");
  top.saveData(document.createForm.ownerId.value, "POLICY_ownerId");
  top.saveData(document.createForm.viewname.value, "POLICY_viewname");
  top.saveData(document.createForm.ActionXMLFile.value, "POLICY_ActionXMLFile");
  top.saveData(document.createForm.cmd.value, "POLICY_cmd");
  top.saveData("1","POLICY_fromRepopulate");
    top.saveData(document.createForm.policyType.checked, "POLICY_policyType");
  var i = document.createForm.resourceGroup.selectedIndex;   
  document.createForm.resourceGroupId.value = document.createForm.resourceGroup.options[i].value;
  parent.setContentFrameLoaded(false);
  document.createForm.submit();
}

function getUserGroupSearchBCT() {
  return "<%= UIUtil.toJavaScript((String)policyNLS.get("userGroupSearchBCT")) %>";
}

function getConfirmationMessage() {
  return "<%= UIUtil.toJavaScript((String)policyNLS.get("policyCancelConfirmation")) %>";
}

function goFind()
{
  var i;
  top.saveData(document.createForm.policyName.value, "POLICY_policyName");
  top.saveData(document.createForm.policyDisplayName.value, "POLICY_policyDisplayName");
  top.saveData(document.createForm.policyDescription.value, "POLICY_policyDescription");
  top.saveData(document.createForm.userGroupId.value, "POLICY_userGroupId");
  top.saveData(document.createForm.userGroup.value, "POLICY_userGroup");
  i = document.createForm.actionGroup.selectedIndex;
  top.saveData(document.createForm.actionGroup.options[i].value, "POLICY_actionGroup");
  i = document.createForm.relation.selectedIndex;
  top.saveData(document.createForm.relation.options[i].value, "POLICY_relation");
  top.saveData(document.createForm.ownerId.value, "POLICY_ownerId");
  top.saveData(document.createForm.viewname.value, "POLICY_viewname");
  top.saveData("1","POLICY_fromFind");
  top.saveData(document.createForm.ActionXMLFile.value, "POLICY_ActionXMLFile");
  top.saveData(document.createForm.cmd.value, "POLICY_cmd");
    top.saveData(document.createForm.policyType.checked, "POLICY_policyType");
  top.setContent(getUserGroupSearchBCT(),
       top.getWebappPath() +'NewDynamicListView?ActionXMLFile=policyeditor.userGroupFind' +
       '&amp;cmd=FindUserGroupView&amp;XMLFile=policyeditor.policyNew&amp;resourceGroupId=' + 
       document.createForm.resourceGroupId.value + "&amp;ownerId=" + document.createForm.ownerId.value, true);
}

function savePanelData()
{
  
}

function doPrompt (field,msg)
{
    alertDialog(msg);
    field.focus();
}

// Make sure all the required data is supplied
function validatePanelData()
{
   var i;
   var pattern = /^\s*$/;             // pattern for a string which only contains whitespace
  
  // Policy name is required
   if (pattern.test(document.createForm.policyName.value))
   {
     doPrompt(document.createForm.policyName, policyNameMissing);
     return false;
   }

   // Policy display name is required
   if (pattern.test(document.createForm.policyDisplayName.value))
   {
     doPrompt(document.createForm.policyDisplayName, displayNameMissing);
     return false;
   }
  
  // Resource group is required
  i = document.createForm.resourceGroup.selectedIndex;
  if (pattern.test(document.createForm.resourceGroup.options[i].value))
  {
     doPrompt(document.createForm.resourceGroup, resourceGroupMissing);
     return false;
   }
   // Action group is required
  i = document.createForm.actionGroup.selectedIndex;
  if (pattern.test(document.createForm.actionGroup.options[i].value))
  {
     doPrompt(document.createForm.actionGroup, actionGroupMissing);
     return false;
   }
   // User group is required
   if (pattern.test(document.createForm.userGroupId.value))
   {
      doPrompt(document.createForm.userGroup, userGroupMissing);
      return false;
   }

   if (!validateInputLength())
   {
      return false;
   }
   return true;
}

 function validateInputLength() 
 {
   if (!isValidLength(document.createForm.policyName, 128))
     return false;
   if (!isValidLength(document.createForm.policyDisplayName, 128))
     return false;
   if (!isValidLength(document.createForm.policyDescription, 254))
     return false;
   return true;
}

function isValidLength(fieldName, maxLen) 
{
 if (fieldName.value != "") 
 {
   if (!isValidUTF8length(fieldName.value, maxLen)) 
   {
     doPrompt(fieldName, InputFieldMax);
     return false;
   }
  }
 return true;
}
</SCRIPT>


</HEAD>
<BODY ONLOAD="initializeState();" class="content">
<H1><%= UIUtil.toHTML((String)policyNLS.get("newPolicy")) %></H1>
 
<form name="createForm" METHOD="POST" ACTION="CreatePolicyView">
<input type="hidden" name="authToken" value="${authToken}" id="WC_policy_create_form_inputs_authToken_1"/>
<TABLE>
  
  <TR>
    <TD ALIGN="LEFT"><STRONG><Label for="policyNameHeader"><%= UIUtil.toHTML((String)policyNLS.get("policyNameHeader")) %></Label></STRONG></TR>
  <TR>
    <TD><INPUT size="70" maxlength="128" name="policyName" value="" id="policyNameHeader"></TD></TR>
  <TR>
    <TD ALIGN="LEFT"><STRONG><Label for="displayNameHeader"><%= UIUtil.toHTML((String)policyNLS.get("displayNameHeader")) %></Label></STRONG></TR>
  <TR>
    <TD><INPUT size="70" maxlength="128" name="policyDisplayName" value="" id="displayNameHeader"></TD></TR>
  <TR>
    <TD ALIGN="LEFT"><STRONG><Label for="policyDescriptionHeader"><%= UIUtil.toHTML((String)policyNLS.get("policyDescriptionHeader")) %></Label></STRONG></TR>
  <TR>
    <TD><INPUT size=70 maxlength="254" name="policyDescription" value="" id="policyDescriptionHeader"></TD></TR>
  <TR>
    <TD ALIGN="LEFT"><STRONG><Label for="policyUserGroupHeader"><%= UIUtil.toHTML((String)policyNLS.get("policyUserGroupHeader")) %></Label></STRONG></TR>
  <TR>
    <TD><INPUT name="userGroup" size=70 value="" onFocus="document.createForm.find1.focus()" id="policyUserGroupHeader">
        <input type="button" value="<%= UIUtil.toHTML((String)policyNLS.get("userGroupFindButton")) %>" name="find1" onClick="goFind()"></TD></TR>
  <TR>
    <TD ALIGN="LEFT"><STRONG><Label for="resourceGroup1"><%= UIUtil.toHTML((String)policyNLS.get("policyResourceGroupHeader")) %></Label></STRONG></TR>
  <TR>
    <TD>
       <SELECT name="resourceGroup" onChange="rePopulateActionGroups()" id="resourceGroup1">
<%
     if(!haveResourceGroupId)
     {
%>   
       <OPTION value="" selected><%= UIUtil.toHTML( (String)policyNLS.get("noneResourceGroup") ) %></OPTION>
<%
     }
     for (int i = 0; i < aList.length; i++)
     {
%>
       
        <OPTION value="<%= aList[i].getResourceGroupId().toString() %>"
<%
           if(aList[i].getResourceGroupId().intValue() == resGrpId)
           {
%>
           SELECTED
<%
           }
%>
        > <%= UIUtil.toHTML(aList[i].getResourceGroupBaseName()) %></OPTION>
<%
     }
%>
        </SELECT>
     </TD>
  </TR>
  <TR>
    <TD ALIGN="LEFT"><STRONG><Label for="actionGroup1"><%= UIUtil.toHTML((String)policyNLS.get("policyActionGroupHeader")) %></Label></STRONG></TR>
  <TR>
    <TD>
        <SELECT name="actionGroup" id="actionGroup1">
<%        
        if(haveResourceGroupId)
        {
        PolicySortingAttribute sort2 = new PolicySortingAttribute();
        sort2.setTableAlias("T5");	
        sort2.addSorting(ActionGroupTable.GROUPNAME, true);
%>
<jsp:useBean id="actionGroupListBean" class="com.ibm.commerce.accesscontrol.policyeditor.beans.ActionGroupLightListBean" >
<jsp:setProperty property="*" name="actionGroupListBean" />
<jsp:setProperty property="languageId" name="actionGroupListBean" value="<%= lang %>" />
<jsp:setProperty property="resourceGroupId" name="actionGroupListBean" value="<%= resourceGroupId %>" />
</jsp:useBean>
<%
          actionGroupListBean.setSortAtt( sort2 );
          com.ibm.commerce.beans.DataBeanManager.activate(actionGroupListBean, request);
          ActionGroupLightDataBean[] bList = actionGroupListBean.getActionGroupBeans();
          for (int i = 0; i < bList.length; i++)
          {
%>
        <OPTION value="<%= bList[i].getActionGroupId().toString() %>"
<%
         if(i == 0)
         {
%>
         selected
<% 
         }
%>         
        > <%= UIUtil.toHTML(bList[i].getActionGroupBaseName()) %></OPTION>
<%
        }
        }
        else
        {
%>
        <OPTION  value="" selected><%= UIUtil.toHTML((String)policyNLS.get("noneActionGroup")) %></OPTION> 
<%
        }
%> 
      </SELECT>
    </TD>
  </TR>
  <TR>
    <TD ALIGN="LEFT"><STRONG><Label for="relation1"><%= UIUtil.toHTML( (String)policyNLS.get("policyRelationshipHeader") ) %></Label></STRONG></TR>
  <TR>
    <TD><SELECT name="relation" id="relation1"> 
        <OPTION  value="" selected><%= UIUtil.toHTML( (String)policyNLS.get("noneRelation") ) %></OPTION> 
<%        
        if(haveResourceGroupId)
        {
         PolicySortingAttribute sort3 = new PolicySortingAttribute();
         sort3.setTableAlias("T4");	
         sort3.addSorting(RelationshipTable.RELNAME, true);

%>
<jsp:useBean id="relationListBean" class="com.ibm.commerce.accesscontrol.policyeditor.beans.RelationLightListBean" >
<jsp:setProperty property="*" name="relationListBean" />
<jsp:setProperty property="languageId" name="relationListBean" value="<%= lang %>" />
<jsp:setProperty property="resourceGroupId" name="relationListBean" value="<%= resourceGroupId %>" />
</jsp:useBean>
<%
          relationListBean.setSortAtt( sort3 );
          com.ibm.commerce.beans.DataBeanManager.activate(relationListBean, request);
          RelationLightDataBean[] cList = relationListBean.getRelationBeans();
          for (int i = 0; i < cList.length; i++)
          {
%>
        <OPTION value="<%= cList[i].getRelationId().toString() %>"> 
        <%= UIUtil.toHTML(cList[i].getRelationDefaultName()) %></OPTION>
<%
           }
        }
%> 
       </SELECT>
    </TD>
 </TR>
<%
    String s1 = (String) policyNLS.get("policyDefaultOrg");
%>
  <TR><TD ALIGN="LEFT"><STRONG><Label for="policyTypeHeader"><%= UIUtil.toHTML((String)policyNLS.get("policyTypeHeader")) %></Label></STRONG></TR>
  <TR><TD><INPUT TYPE="checkbox" NAME="policyType" VALUE="3" id="policyTypeHeader"><%= s1 %>
    <TD>
    </TD>
  </TR>
</TABLE>
    <INPUT TYPE="HIDDEN" NAME="userGroupId" value="">
    <INPUT TYPE="HIDDEN" NAME="resourceGroupId" value="<%= UIUtil.toHTML(resourceGroupId) %>">
    <INPUT TYPE="HIDDEN" NAME="ownerId" VALUE="<%= UIUtil.toHTML(ownerId) %>">
    <INPUT TYPE="HIDDEN" NAME="viewname" VALUE="<%= UIUtil.toHTML(viewname) %>">
    <INPUT TYPE="HIDDEN" NAME="ActionXMLFile" VALUE="<%= UIUtil.toHTML(ActionXMLFile) %>">
    <INPUT TYPE="HIDDEN" NAME="cmd" VALUE="<%= UIUtil.toHTML(cmd) %>">
</FORM>
<SCRIPT LANGUAGE="JavaScript">
if(document.createForm.policyName.value == "")
{
  document.createForm.policyName.focus();
}
// Check if we are returning from repopulating the action group and relation drop downs
// because the resource group was changed
if(top.getData("POLICY_fromRepopulate") != undefined && top.getData("POLICY_fromRepopulate") != null)
{
  var fromRepopulate = null;
  // Reset indicator
  top.saveData(fromFind,"POLICY_fromRepopulate");
  document.createForm.policyName.value = top.getData("POLICY_policyName");
  document.createForm.policyDisplayName.value = top.getData("POLICY_policyDisplayName");
  document.createForm.policyDescription.value = top.getData("POLICY_policyDescription");
  document.createForm.viewname.value = top.getData("POLICY_viewname");
  document.createForm.ActionXMLFile.value = top.getData("POLICY_ActionXMLFile");
  document.createForm.cmd.value = top.getData("POLICY_cmd");
  document.createForm.ownerId.value = top.getData("POLICY_ownerId");
  document.createForm.userGroupId.value = top.getData("POLICY_userGroupId");
  document.createForm.userGroup.value = top.getData("POLICY_userGroup");
   if(top.getData("POLICY_policyType") == true)
   {
      document.createForm.policyType.checked = true;
   }
}
// Check if we are returning from the user group find panel
if(top.getData("POLICY_fromFind") != undefined && top.getData("POLICY_fromFind") != null)
{
  var fromFind = null;
  var val;
  var i;
  // Reset indicator
  top.saveData(fromFind,"POLICY_fromFind");
  document.createForm.policyName.value = top.getData("POLICY_policyName");
  document.createForm.policyDisplayName.value = top.getData("POLICY_policyDisplayName");
  document.createForm.policyDescription.value = top.getData("POLICY_policyDescription");
  document.createForm.viewname.value = top.getData("POLICY_viewname");
  document.createForm.ActionXMLFile.value = top.getData("POLICY_ActionXMLFile");
  document.createForm.cmd.value = top.getData("POLICY_cmd");
  document.createForm.ownerId.value = top.getData("POLICY_ownerId");
  document.createForm.userGroupId.value = top.getData("POLICY_userGroupId");
  document.createForm.userGroup.value = top.getData("POLICY_userGroup");
  val = top.getData("POLICY_actionGroup");
  for (i = 0; i < document.createForm.actionGroup.options.length; i++)
  {
   if(document.createForm.actionGroup.options[i].value == val)
   {
      document.createForm.actionGroup.selectIndex = i;
      document.createForm.actionGroup.options[i].selected = true;
      break;
   }
  }
  val = top.getData("POLICY_relation");
  for (i = 0; i < document.createForm.relation.options.length; i++)
  {
   if(document.createForm.relation.options[i].value == val)
   {
      document.createForm.relation.selectIndex = i;
      document.createForm.relation.options[i].selected = true;
      break;
   }
  }
    if(top.getData("POLICY_policyType") == true)
    {
       document.createForm.policyType.checked = true;
    }
}
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

