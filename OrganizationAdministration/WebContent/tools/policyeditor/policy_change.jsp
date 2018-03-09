<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2017 All Rights Reserved.

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
<%@ page import="com.ibm.commerce.accesscontrol.policyeditor.helpers.*" %>
<%@ page import="com.ibm.commerce.ejb.helpers.SessionBeanHelper" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.accesscontrol.policyeditor.dbutil.*" %>
<%@ page import="com.ibm.commerce.accesscontrol.policyeditor.objimpl.*" %>

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
   String policyId = null;
   String ownerId = null;
   Integer thePolicyId = null;
   String resourceGroupId = null;
   String viewname = null;
   String ActionXMLFile = null;
   String cmd = null;
   boolean fromFind = false;
   Integer resGrpId = null;
   Integer actGrpId = null;
   Integer relId = null;
   String usrGrpId = "";
   String usrGrp = "";
   String polName = "";
   String polDesc = "";
   String polDisplayName = "";
   Integer language = null;
   String policyType = "";
   String origPolicyName = null;
   String origPolicyDisplayName = null;
                       
   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext"); 
         
   if( aCommandContext!= null )
   {
      locale = aCommandContext.getLocale();
      language = aCommandContext.getLanguageId();
      lang = aCommandContext.getLanguageId().toString();
      userId = aCommandContext.getUserId().toString();
   }

   resourceGroupId = (String) request.getParameter("resourceGroupId");
   policyId = (String) request.getParameter("policyId");
   thePolicyId = Integer.valueOf(policyId);
   ownerId = (String) request.getParameter("ownerId");
   viewname = (String) request.getParameter("viewname");
   ActionXMLFile = (String) request.getParameter("ActionXMLFile");
   cmd = (String) request.getParameter("cmd");
   String cameFromFind = (String) request.getParameter("fromFind");
   origPolicyName = (String) request.getParameter("origPolicyName");
   origPolicyDisplayName = (String) request.getParameter("origPolicyDisplayName");
   policyType = (String) request.getParameter("policyType");
   
   // See if we came from find or repopulate (both will pass fromFind=1).  If we did, we won't bother
   // to retrieve the data because it may have already been modified by the user and is being stored.
   if(cameFromFind != null && !cameFromFind.equals(""))
   {
     if(cameFromFind.equals("1"))
       { 
         fromFind = true;
       }
   }
   if(resourceGroupId != null && !resourceGroupId.equals(""))
   {
     resGrpId = Integer.valueOf(resourceGroupId);
   }
   
   // obtain the resource bundle for display
   Hashtable policyNLS = (Hashtable)ResourceDirectory.lookup("policyeditor.policyeditorNLS", locale);      

   // We didn't come from find or repopulate so we need to retrieve the data
   if(!fromFind)
   {
      AccessControlJDBCHelperBean helper = SessionBeanHelper.lookupSessionBean(AccessControlJDBCHelperBean.class);
      PolicyLightDataBean policyBean = new PolicyLightDataBean(helper.getPolicy(thePolicyId, language));
      resGrpId = policyBean.getResourceGroupId();
      resourceGroupId = resGrpId.toString();
      actGrpId = policyBean.getActionGroupId();
      relId = policyBean.getRelationshipId();
      usrGrpId = policyBean.getUserGroupId().toString();
      polName = policyBean.getPolicyDefaultName();
      polDisplayName = policyBean.getPolicyName();
      polDesc = policyBean.getPolicyDescription();
      usrGrp = policyBean.getUserGroupName();
      if(policyBean.getPolicyType() != null)
      {
        policyType = policyBean.getPolicyType().toString().trim();
      }
      origPolicyName = policyBean.getPolicyDefaultName();
      origPolicyDisplayName = policyBean.getPolicyName();
   }

   PolicySortingAttribute sort = new PolicySortingAttribute();
   sort.setTableAlias("T1");
   sort.addSorting(ResourceGroupTable.GRPNAME, true);
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%= UIUtil.toHTML((String)policyNLS.get("changePolicy")) %></TITLE>

<jsp:useBean id="resourceGroupListBean" class="com.ibm.commerce.accesscontrol.policyeditor.beans.ResourceGroupLightListBean" >
<jsp:setProperty property="*" name="resourceGroupListBean" />
<jsp:setProperty property="languageId" name="resourceGroupListBean" value="<%= lang %>" />
<jsp:setProperty property="filterForActionGroups" name="resourceGroupListBean" value="Y" />
<jsp:setProperty property="policyId" name="resourceGroupListBean" value="<%= policyId %>" />
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
templateChangeError = "<%= UIUtil.toJavaScript((String)policyNLS.get("templateChangeError")) %>";

function initializeState()
{
  parent.setContentFrameLoaded(true);
}

// Go back to the JSP to repopulate the action group and relation drop downs if the resource group changes.
function rePopulateActionGroups()
{
  top.saveData(document.changeForm.policyName.value, "POLICY_policyName");
  top.saveData(document.changeForm.policyDisplayName.value, "POLICY_policyDisplayName");
  top.saveData(document.changeForm.policyDescription.value, "POLICY_policyDescription");
  top.saveData(document.changeForm.userGroupId.value, "POLICY_userGroupId");
  top.saveData(document.changeForm.userGroup.value, "POLICY_userGroup");
  top.saveData(document.changeForm.policyId.value, "POLICY_policyId");
  top.saveData(document.changeForm.ownerId.value, "POLICY_ownerId");
  top.saveData(document.changeForm.viewname.value, "POLICY_viewname");
  top.saveData(document.changeForm.ActionXMLFile.value, "POLICY_ActionXMLFile");
  top.saveData(document.changeForm.cmd.value, "POLICY_cmd");
  top.saveData(document.changeForm.policyType.value, "POLICY_type");
  top.saveData(document.changeForm.origPolicyName.value, "POLICY_origName");
  top.saveData("1","POLICY_fromRepopulate");
  var i = document.changeForm.resourceGroup.selectedIndex; 
  document.changeForm.resourceGroupId.value = document.changeForm.resourceGroup.options[i].value;
  parent.setContentFrameLoaded(false);
  document.changeForm.submit();
}

function getUserGroupSearchBCT() {
  return "<%= policyNLS.get("userGroupSearchBCT") %>";
}

function getConfirmationMessage() {
  return "<%= policyNLS.get("policyCancelConfirmation") %>";
}

function goFind()
{
  var i;
  top.saveData(document.changeForm.policyName.value, "POLICY_policyName");
  top.saveData(document.changeForm.policyDisplayName.value, "POLICY_policyDisplayName");
  top.saveData(document.changeForm.policyDescription.value, "POLICY_policyDescription");
  top.saveData(document.changeForm.userGroupId.value, "POLICY_userGroupId");
  top.saveData(document.changeForm.userGroup.value, "POLICY_userGroup");
  i = document.changeForm.actionGroup.selectedIndex;
  if(i == -1)
  {
    top.saveData("", "POLICY_actionGroup");
  }
  else
  {
    top.saveData(document.changeForm.actionGroup.options[i].value, "POLICY_actionGroup");
  }
  i = document.changeForm.relation.selectedIndex;
  top.saveData(document.changeForm.relation.options[i].value, "POLICY_relation");
  top.saveData(document.changeForm.policyId.value, "POLICY_policyId");
  top.saveData(document.changeForm.ownerId.value, "POLICY_ownerId");
  top.saveData(document.changeForm.viewname.value, "POLICY_viewname");
  top.saveData(document.changeForm.ActionXMLFile.value, "POLICY_ActionXMLFile");
  top.saveData(document.changeForm.cmd.value, "POLICY_cmd");
  top.saveData(document.changeForm.policyType.value, "POLICY_type");
  top.saveData(document.changeForm.origPolicyName.value, "POLICY_origName");
  top.saveData("1","POLICY_fromFind");
  top.setContent(getUserGroupSearchBCT(),
       top.getWebappPath() +'NewDynamicListView?ActionXMLFile=policyeditor.userGroupFind' +
       '&amp;cmd=FindUserGroupView&amp;XMLFile=policyeditor.policyChange&amp;resourceGroupId=' + 
       document.changeForm.resourceGroupId.value + '&amp;policyId=' + document.changeForm.policyId.value, true);
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
   if (pattern.test(document.changeForm.policyName.value))
   {
     doPrompt(document.changeForm.policyName, policyNameMissing);
     return false;
   }

  // Policy display name is required
   if (pattern.test(document.changeForm.policyDisplayName.value))
   {
     doPrompt(document.changeForm.policyDisplayName, displayNameMissing);
     return false;
   }

  
  // Resource group is required
  i = document.changeForm.resourceGroup.selectedIndex;
  if(i == -1)
  {
     doPrompt(document.changeForm.resourceGroup, resourceGroupMissing);
     return false;
  }
  if (pattern.test(document.changeForm.resourceGroup.options[i].value))
  {
     doPrompt(document.changeForm.resourceGroup, resourceGroupMissing);
     return false;
   }
   // Action group is required
  i = document.changeForm.actionGroup.selectedIndex;
  if(i == -1)
  {
     doPrompt(document.changeForm.actionGroup, actionGroupMissing);
     return false;
  }
  if (pattern.test(document.changeForm.actionGroup.options[i].value))
  {
     doPrompt(document.changeForm.actionGroup, actionGroupMissing);
     return false;
   }
   // User group is required
   if (pattern.test(document.changeForm.userGroupId.value))
   {
      doPrompt(document.changeForm.userGroup, userGroupMissing);
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
   if (!isValidLength(document.changeForm.policyName, 128))
     return false;
   if (!isValidLength(document.changeForm.policyDisplayName, 128))
     return false;
   if (!isValidLength(document.changeForm.policyDescription, 254))
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
<H1><%= UIUtil.toHTML((String)policyNLS.get("changePolicy")) %></H1>
 
<form name="changeForm" METHOD="POST" ACTION="ChangePolicyView">
<input type="hidden" name="authToken" value="${authToken}" id="WC_policy_change_form_inputs_authToken_1"/>
<TABLE>
  <TR>
    <TD ALIGN="LEFT"><STRONG><Label for="policyNameHeader"><%= UIUtil.toHTML((String)policyNLS.get("policyNameHeader")) %></Label></STRONG></TR>
  <TR>
    <TD><INPUT size="70" maxlength="128" name="policyName" value="<%= UIUtil.toHTML(polName) %>" id="policyNameHeader"></TD></TR>
  <TR>
    <TD ALIGN="LEFT"><STRONG><Label for="displayNameHeader"><%= UIUtil.toHTML((String)policyNLS.get("displayNameHeader")) %></Label></STRONG></TR>
  <TR>
    <TD><INPUT size="70" maxlength="128" name="policyDisplayName" value="<%= UIUtil.toHTML(polDisplayName) %>" id="displayNameHeader"></TD></TR>
  <TR>
    <TD ALIGN="LEFT"><STRONG><Label for="policyDescriptionHeader"><%= UIUtil.toHTML((String)policyNLS.get("policyDescriptionHeader")) %></Label></STRONG></TR>
  <TR>
    <TD><INPUT size=70 maxlength="254" name="policyDescription" value="<%= UIUtil.toHTML(polDesc) %>" id="policyDescriptionHeader"></TD></TR>
  <TR>
    <TD ALIGN="LEFT"><STRONG><Label for="policyUserGroupHeader"><%= UIUtil.toHTML((String)policyNLS.get("policyUserGroupHeader")) %></Label></STRONG></TR>
  <TR>
    <TD><INPUT size=70 name="userGroup" value="<%= UIUtil.toHTML(usrGrp) %>" onFocus="document.changeForm.find1.focus()" id="policyUserGroupHeader">
        <input type="button" value="<%= UIUtil.toHTML((String)policyNLS.get("userGroupFindButton")) %>" name="find1" onClick="goFind()"></TD></TR>
  <TR>
    <TD ALIGN="LEFT"><STRONG><LABEL for="resourceGroup1"><%= UIUtil.toHTML((String)policyNLS.get("policyResourceGroupHeader")) %></LABEL></STRONG></TR>
  <TR>
    <TD>
       <SELECT name="resourceGroup" onChange="rePopulateActionGroups()" id="resourceGroup1">
<%
     boolean foundResourceGroup = false;
     for (int i = 0; i < aList.length; i++)
     {
%>
       
        <OPTION value="<%= UIUtil.toHTML( aList[i].getResourceGroupId().toString() ) %>"
<%
           if(aList[i].getResourceGroupId().equals(resGrpId))
           {
            foundResourceGroup = true;
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
    <TD ALIGN="LEFT"><STRONG><LABEL for="actionGroup1"><%= UIUtil.toHTML( (String)policyNLS.get("policyActionGroupHeader") ) %></LABEL></STRONG></TR>
  <TR>
    <TD>
                <SELECT name="actionGroup" id="actionGroup1">
<%        
        PolicySortingAttribute sort2 = new PolicySortingAttribute();
        sort2.setTableAlias("T5");	
        sort2.addSorting(ActionGroupTable.GROUPNAME, true);
%>
<jsp:useBean id="actionGroupListBean" class="com.ibm.commerce.accesscontrol.policyeditor.beans.ActionGroupLightListBean" >
<jsp:setProperty property="*" name="actionGroupListBean" />
<jsp:setProperty property="languageId" name="actionGroupListBean" value="<%= lang %>" />
<jsp:setProperty property="resourceGroupId" name="actionGroupListBean" value="<%= resourceGroupId %>" />
<jsp:setProperty property="policyId" name="actionGroupListBean" value="<%= policyId %>" />
</jsp:useBean>
<%
          actionGroupListBean.setSortAtt( sort2 );
          com.ibm.commerce.beans.DataBeanManager.activate(actionGroupListBean, request);
          ActionGroupLightDataBean[] bList = actionGroupListBean.getActionGroupBeans();
          boolean foundActionGroup = false;
          for (int i = 0; i < bList.length; i++)
          {
%>
        <OPTION value="<%= bList[i].getActionGroupId().toString() %>"
<%
         if( (!fromFind) && actGrpId.equals(bList[i].getActionGroupId()))
         {
           foundActionGroup = true;
%>
         selected
<% 
         }
%>         
        > <%= UIUtil.toHTML(bList[i].getActionGroupBaseName()) %></OPTION>
<%
        }
%>
      </SELECT>
    </TD>
  </TR>
  <TR>
    <TD ALIGN="LEFT"><STRONG><LABEL for="relation1"><%= UIUtil.toHTML( (String)policyNLS.get("policyRelationshipHeader") ) %></LABEL></STRONG></TR>
  <TR>
    <TD><SELECT name="relation" id="relation1"> 
        <OPTION  value=""
<%
        if(fromFind || relId == null )
        {
%> 
        selected
<%
        }
%>
        ><%= UIUtil.toHTML( (String)policyNLS.get("noneRelation") ) %></OPTION> 
<%        
         PolicySortingAttribute sort3 = new PolicySortingAttribute();
         sort3.setTableAlias("T4");	
         sort3.addSorting(RelationshipTable.RELNAME, true);

%>
<jsp:useBean id="relationListBean" class="com.ibm.commerce.accesscontrol.policyeditor.beans.RelationLightListBean" >
<jsp:setProperty property="*" name="relationListBean" />
<jsp:setProperty property="languageId" name="relationListBean" value="<%= lang %>" />
<jsp:setProperty property="resourceGroupId" name="relationListBean" value="<%= resourceGroupId %>" />
<jsp:setProperty property="policyId" name="relationListBean" value="<%= policyId %>" />
</jsp:useBean>
<%
          relationListBean.setSortAtt( sort3 );
          com.ibm.commerce.beans.DataBeanManager.activate(relationListBean, request);
          RelationLightDataBean[] cList = relationListBean.getRelationBeans();
          for (int i = 0; i < cList.length; i++)
          {
%>
        <OPTION value="<%= cList[i].getRelationId().toString() %>"
<%
          if((!fromFind) && relId.equals(cList[i].getRelationId()))
          {
%>        
            selected
<%
          }
%>
        > <%= UIUtil.toHTML(cList[i].getRelationDefaultName()) %></OPTION>
<%
           }
%> 
       </SELECT>
    </TD>
 </TR>
</TABLE>
    <INPUT TYPE="HIDDEN" NAME="userGroupId" value="<%= usrGrpId %>">
    <INPUT TYPE="HIDDEN" NAME="resourceGroupId" value="<%= UIUtil.toHTML(resourceGroupId) %>">
    <INPUT TYPE="HIDDEN" NAME="policyId" VALUE="<%= UIUtil.toHTML(policyId) %>">
    <INPUT TYPE="HIDDEN" NAME="ownerId" VALUE="<%= UIUtil.toHTML(ownerId) %>">
    <INPUT TYPE="HIDDEN" NAME="viewname" VALUE="<%= UIUtil.toHTML(viewname) %>">
    <INPUT TYPE="HIDDEN" NAME="fromFind" VALUE="1">
    <INPUT TYPE="HIDDEN" NAME="ActionXMLFile" VALUE="<%= UIUtil.toHTML(ActionXMLFile) %>">
    <INPUT TYPE="HIDDEN" NAME="cmd" VALUE="<%= UIUtil.toHTML(cmd) %>">
    <INPUT TYPE="HIDDEN" NAME="policyType" VALUE="<%= UIUtil.toHTML(policyType) %>">
    <INPUT TYPE="HIDDEN" NAME="origPolicyName" VALUE="<%= UIUtil.toHTML( origPolicyName ) %>">
    <INPUT TYPE="HIDDEN" NAME="origPolicyDisplayName" VALUE="<%= UIUtil.toHTML( origPolicyDisplayName ) %>">
</FORM>

<SCRIPT LANGUAGE="JavaScript">
// Check if we are returning from repopulating the action group and relation drop downs
// because the resource group was changed
if(top.getData("POLICY_fromRepopulate") != undefined && top.getData("POLICY_fromRepopulate") != null)
{
  var fromRepopulate = null;
  // Reset indicator
  top.saveData(fromFind,"POLICY_fromRepopulate");
  document.changeForm.policyName.value = top.getData("POLICY_policyName");
  document.changeForm.policyDisplayName.value = top.getData("POLICY_policyDisplayName");
  document.changeForm.policyDescription.value = top.getData("POLICY_policyDescription");
  document.changeForm.viewname.value = top.getData("POLICY_viewname");
  document.changeForm.ActionXMLFile.value = top.getData("POLICY_ActionXMLFile");
  document.changeForm.cmd.value = top.getData("POLICY_cmd");
  document.changeForm.policyId.value = top.getData("POLICY_policyId");
  document.changeForm.ownerId.value = top.getData("POLICY_ownerId");
  document.changeForm.userGroupId.value = top.getData("POLICY_userGroupId");
  document.changeForm.userGroup.value = top.getData("POLICY_userGroup");
  document.changeForm.policyType.value = top.getData("POLICY_type");
  document.changeForm.origPolicyName.value = top.getData("POLICY_origName");
  document.changeForm.origPolicyDisplayName.value = top.getData("POLICY_origDisplayName");
}

// Check if we are returning from the user group find panel
if(top.getData("POLICY_fromFind") != undefined && top.getData("POLICY_fromFind") != null)
{
  var fromFind = null;
  var val;
  var i;
  // Reset indicator
  top.saveData(fromFind,"POLICY_fromFind");
  document.changeForm.policyName.value = top.getData("POLICY_policyName");
  document.changeForm.policyDisplayName.value = top.getData("POLICY_policyDisplayName");
  document.changeForm.policyDescription.value = top.getData("POLICY_policyDescription");
  document.changeForm.viewname.value = top.getData("POLICY_viewname");
  document.changeForm.ActionXMLFile.value = top.getData("POLICY_ActionXMLFile");
  document.changeForm.cmd.value = top.getData("POLICY_cmd");
  document.changeForm.policyId.value = top.getData("POLICY_policyId");
  document.changeForm.ownerId.value = top.getData("POLICY_ownerId");
  document.changeForm.userGroupId.value = top.getData("POLICY_userGroupId");
  document.changeForm.userGroup.value = top.getData("POLICY_userGroup");
  document.changeForm.policyType.value = top.getData("POLICY_type");
  document.changeForm.origPolicyName.value = top.getData("POLICY_origName");
  document.changeForm.origPolicyDisplayName.value = top.getData("POLICY_origDisplayName");
  val = top.getData("POLICY_actionGroup");
  document.changeForm.actionGroup.selectedIndex = -1;
  for (i = 0; i < document.changeForm.actionGroup.options.length; i++)
  {
   if(document.changeForm.actionGroup.options[i].value == val)
   {
      document.changeForm.actionGroup.selectedIndex = i;
      document.changeForm.actionGroup.options[i].selected = true;
      break;
   }
  }
  val = top.getData("POLICY_relation");
  for (i = 0; i < document.changeForm.relation.options.length; i++)
  {
   if(document.changeForm.relation.options[i].value == val)
   {
      document.changeForm.relation.selectedIndex = i;
      document.changeForm.relation.options[i].selected = true;
      break;
   }
  }
}
// initial display - not return from find user group or resource group change
else
{
 <%
 if(!foundActionGroup)
 {
 %>
 document.changeForm.actionGroup.selectedIndex = -1;
 <%
 }
 %>
}

 <%
 if(!foundResourceGroup)
 {
 %>
 document.changeForm.resourceGroup.selectedIndex = -1;
 <%
 }
 %>

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

