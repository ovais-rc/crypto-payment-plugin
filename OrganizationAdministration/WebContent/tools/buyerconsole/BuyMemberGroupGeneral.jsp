<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002, 2005
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<%@ page language="java" %>

<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.math.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.base.objects.*"   %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.tools.segmentation.SegmentConstants"   %>


<%@ include file="../common/common.jsp" %>

<%
    CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cmdContext.getLocale();

    // obtain the resource bundle for display
    Hashtable memberGroupWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
    Hashtable orgEntityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.OrgEntityNLS", locale);
     if (memberGroupWizardNLS == null) System.out.println("!!!! RS is null");
     String memberGroupGeneralNameEmpty = UIUtil.toJavaScript((String)memberGroupWizardNLS.get("memberGroupGeneralNameEmpty"));
     String AdminConsoleExceedMaxLength = UIUtil.toJavaScript((String)memberGroupWizardNLS.get("AdminConsoleExceedMaxLength"));
     
     String mbrGrpId = cmdContext.getRequestProperties().getString("nestMbrGrpId");
     String memberGroupType = cmdContext.getRequestProperties().getString("memberGroupType");     
     
     //Find the member group type id for the memberGroupType
   	com.ibm.commerce.user.objects.MemberGroupTypeAccessBean mgtAB =  new com.ibm.commerce.user.objects.MemberGroupTypeAccessBean();
   	com.ibm.commerce.user.objects.MemberGroupTypeAccessBean mg = mgtAB.findByName(memberGroupType);
   	String memberGroupTypeId = "";
   	try{
   		memberGroupTypeId = mg.getMbrGrpTypeId(); 
   	} catch (Exception e){
   		System.out.println("Group type does not exist");
   	}	
     
     MemberGroupDataBean mgdb = new MemberGroupDataBean();
     mgdb.setMemberGroupUsageId(memberGroupTypeId);
     DataBeanManager.activate(mgdb, cmdContext);
     String ownerId = "";
     String name = "";
     String mgrpname = "";
     
     for (int i=0; i < mgdb.getSize(); i++) {
     
         String id = mgdb.getMemberGroupId(i);
         if (id.equals(mbrGrpId)) {
             mgrpname = mgdb.getName(i);
             OrgEntityDataBean oedb = new OrgEntityDataBean();
             oedb.setDataBeanKeyMemberId(mgdb.getOwnerId(i));
             DataBeanManager.activate(oedb, cmdContext);
             
             name = oedb.getOrgEntityName();
             break;
         }
     }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<html>
<head><TITLE><%=UIUtil.toHTML((String)memberGroupWizardNLS.get("memberGroupGeneralIndex"))%></TITLE>
<%= fHeader%>
<LINK rel=stylesheet href="<%=UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">

<script LANGUAGE="JavaScript1.2" SRC="/wcs/javascript/tools/common/SwapList.js"></script>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>

////////////////////////////////////////////////
// Load data from state of info for this page
// add them to the GUI
///////////////////////////////////////////////

function initializeState()
{
   
   parent.setContentFrameLoaded(true);

}


/////////////////////////////////////////////////////////////////////////////
// This function will validate the entry fields for this page before wizard
// goes to the next or previous page. This function will also be used to
// restore the user changes to the state of info
/////////////////////////////////////////////////////////////////////////////
function savePanelData()
{
   
}

function validatePanelData()
{
    
   return true;
}

function changeView(selectedValue) {
		
	var url = "";
	
	if(selectedValue=='CustomerTerritoryGroup'){				
		url = top.getWebappPath() + "NotebookView?XMLFile=buyerconsole.BuyMemberGroupNotebookCustomerTerritoryGroup";  										
		url += "&segmentId=<%= UIUtil.toHTML(mbrGrpId) %>&memberGroupType=<%= memberGroupType %>";
	} else if(selectedValue=='AccessGroup'){					
		url = top.getWebappPath() + "NotebookView?XMLFile=buyerconsole.BuyMemberGroupNotebookAccessGroup"; 								
		url += "&segmentId=<%= UIUtil.toHTML(mbrGrpId) %>&memberGroupType=<%= memberGroupType %>";
	} else {
		url = top.getWebappPath() + "NotebookView?XMLFile=buyerconsole.BuyMemberGroupNotebook";
		url += "&segmentId=<%= UIUtil.toHTML(mbrGrpId) %>&memberGroupType=<%= memberGroupType %>";
	}	
 	
    if (top.setContent)
    {
        top.showContent(url); 
        top.refreshBCT(); 
    }
    else
    {
       parent.location.replace(url);
    }

}

</SCRIPT>
<!-- ============================================================================
The sample Templates, HTML and Macros are furnished by IBM as simple
examples to provide an illustration. These examples have not been
thoroughly tested under all conditions.  IBM, therefore, cannot guarantee reliability, 
serviceability or function of these programs. All programs contained herein are provided 
to you "AS IS".

The sample Templates, HTML and Macros may include the names of individuals,
companies, brands and products in order to illustrate them as completely as
possible.  All of these are names are ficticious and any similarity to the names
and addresses used by actual persons or business enterprises is entirely coincidental.

Licensed Materials - Property of IBM

WebSphere Commerce

(c)  Copyright  IBM Corp.  1997, 1999, 2004, 2005.      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or 
disclosure restricted by GSA ADP Schedule Contract with IBM Corp

=============================================================================== -->

</head>
<BODY ONLOAD="parent.initializeState();" class="content">
   <H1><%=UIUtil.toHTML((String)memberGroupWizardNLS.get("memberGroupGeneralIndex"))%></H1>
   <LINE3><%=UIUtil.toHTML((String)memberGroupWizardNLS.get("memberGroupGeneralMsg"))%></LINE3>

<form name="wizard1">
<table border="0">
<tr>
	<td>
      <%-- 
      /**
      * Comment out this code to allow user selection of usage types
      */
      --%>
      <LABEL for="usageType"><%=UIUtil.toHTML((String)memberGroupWizardNLS.get("userAdminUsageTypeReq"))%><BR></LABEL>
      <I>
      <%=UIUtil.toHTML((String)memberGroupWizardNLS.get(memberGroupType))%>
      </I>
      <INPUT id="usageType" TYPE="HIDDEN" NAME="usageType" VALUE="<%= memberGroupType %>">
      <%-- End comment out text --%>
      
      <%-- 
      /**
      * Uncomment this code to allow user selection of usage types
      */
      <% if ((mbrGrpId == null || mbrGrpId.equals(""))) {  %> 
      <LABEL for="usageType"><%=UIUtil.toHTML((String)memberGroupWizardNLS.get("userAdminUsageTypeReq"))%><BR></LABEL>
      <SELECT name="usageType" id="usageType">
      <% } else { %>
      <LABEL for="usageType"><%=UIUtil.toHTML((String)memberGroupWizardNLS.get("userAdminUsageTypeReq"))%><BR></LABEL>
      <SELECT name="usageType" id="usageType" onChange="javascript:changeView(this.options[this.selectedIndex].value);">      
      <% } %>
		<OPTION  value="CustomerTerritoryGroup"  <% if (memberGroupType.equals("CustomerGroup")) { %> SELECTED <% } %>  ><%=UIUtil.toHTML((String)memberGroupWizardNLS.get(memberGroupType))%></OPTION>
		<OPTION  value="ServiceRepGroup" <% if (memberGroupType.equals("ServiceRepGroup")) { %> SELECTED <% } %> ><%=UIUtil.toHTML((String)memberGroupWizardNLS.get(memberGroupType))%></OPTION>
		<OPTION  value="PriceOverrideGroup" <% if (memberGroupType.equals("PriceOverrideGroup")) { %> SELECTED <% } %> ><%=UIUtil.toHTML((String)memberGroupWizardNLS.get(memberGroupType))%></OPTION>
		<OPTION  value="AccessGroup" <% if (memberGroupType.equals("AccessGroup")) { %> SELECTED <% } %> ><%=UIUtil.toHTML((String)memberGroupWizardNLS.get(memberGroupType))%></OPTION>	 	
	   </SELECT>	   
	   --%>
	</td>
</tr>

<%	if (!(mbrGrpId == null || mbrGrpId.equals(""))) { %>
<tr>
	<td>
		<%= UIUtil.toHTML((String)memberGroupWizardNLS.get("memberGroupGeneralName")) %><br/>
		<i><%= UIUtil.toHTML(mgrpname) %></i>
	</td>
</tr>
<tr>
	<td>
		<label for="description">
		<%= UIUtil.toHTML((String)memberGroupWizardNLS.get("memberGroupGeneralDesc")) %><br/>
		<input size="35" type="input" name="desc" id="description" onkeydown="if (window.event.keyCode == 13) return false;" /><br/>
		</label>
	</td>
</tr>
<tr>
	<td>
		<%= UIUtil.toHTML((String)memberGroupWizardNLS.get("memberGroupGeneralOwner")) %><br/>
		<i><%= UIUtil.toHTML(name) %></i>
	</td>
</tr>
<%	} else { %>
<tr>
	<td>
		<label for="nameRequired">
		<%= UIUtil.toHTML((String)memberGroupWizardNLS.get("memberGroupGeneralNameReq")) %><br/>
		<input size="35" type="input" name="name" id="nameRequired" /><br/><br/>
		</label>
	</td>
</tr>
<tr>
	<td>
		<label for="description">
		<%= UIUtil.toHTML((String)memberGroupWizardNLS.get("memberGroupGeneralDesc")) %><br/>
		<input size="35" type="input" name="desc" id="description"/><br/>
		</label>
	</td>
</tr>
<tr>
	<td>
		<label for="owner">
		<%= UIUtil.toHTML((String)memberGroupWizardNLS.get("memberGroupGeneralOwnerReq")) %><br/>
		<input size="32" type="input" name="orgname" id="owner"/>
		</label>
	</td>
	<td width="20" valign="bottom">
		<button type="button" name="findButton" id="content" onClick="parent.findOrg()"><%= UIUtil.toHTML((String)memberGroupWizardNLS.get("find")) %></button>
	</td>
</tr>
<%	} %>

<%	if (((mbrGrpId == null) || (mbrGrpId.equals(""))) && (memberGroupType.equals("CustomerTerritoryGroup") || memberGroupType.equals("AccessGroup"))) { %>
<tr>
	<td>
		<input type="checkbox" name="selectMembers" checked="checked" value="1" id="memberGroupGeneralCustomerGroupSelectMembers" />
		<label for="memberGroupGeneralCustomerGroupSelectMembers">
		<%= UIUtil.toHTML((String)memberGroupWizardNLS.get("memberGroupGeneralCustomerGroupSelectMembers")) %>
		</label>
	</td>
</tr>
<% } %>

</table>
</form>

</body>
</html>
