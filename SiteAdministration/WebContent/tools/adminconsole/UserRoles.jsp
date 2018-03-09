<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//* 
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<%@ page language="java" %>

<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.base.objects.*" %>
<%@ page import="com.ibm.commerce.beans.*" %> 
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.*" %>
<%@ page import="com.ibm.commerce.tools.common.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %> 
<%@ page import="com.ibm.commerce.tools.xml.*" %> 
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.server.*" %> 
<%@ page import="com.ibm.commerce.usermanagement.commands.*" %>


<%@ include file="../common/common.jsp" %>

<%
    CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cmdContext.getLocale();
%>
<%
    Hashtable userWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
   if (userWizardNLS == null) System.out.println("!!!! RS is null");
   
   String userId = request.getParameter("memberId");
   int numberOfRoles = 0;
   String orgId = request.getParameter("orgId");
   Integer[] rootRoles = null;
   Integer[] rootRolesToJS = null;
   Vector roleNamesToJS = new Vector();
   Vector userRoles = new Vector();
   boolean first = true;
   
  
   String[][] roleNames = null;
   
   OrgEntityManageDataBean bnOrgEntityManage = new OrgEntityManageDataBean();
   com.ibm.commerce.beans.DataBeanManager.activate (bnOrgEntityManage, request);
   String[][] OrgIdOpt = bnOrgEntityManage.getOrgEntityList();
   
   MemberRoleDataBean mrdb = new MemberRoleDataBean();
   
   Enumeration enum1 = mrdb.findByMemberId(new Long(userId));   	
   while (enum1.hasMoreElements()) {
   	Vector temp = new Vector();
   	MemberRoleAccessBean mrab = (MemberRoleAccessBean) enum1.nextElement();
   	temp.addElement(mrab.getRoleId());
   	temp.addElement(mrab.getOrgEntityId());
   	
   	userRoles.addElement(temp);
   }
   if (orgId == null) {
   	first = false;
   	orgId = OrgIdOpt[0][0];
      	   	
   	OrgEntityDataBean oedb = new OrgEntityDataBean();
   	oedb.setDataBeanKeyMemberId(orgId);
   	com.ibm.commerce.beans.DataBeanManager.activate(oedb, request);
   	
   	rootRoles = oedb.getRoles();
       	roleNames = new String[rootRoles.length][3];
   
       	for (int i =0; i < rootRoles.length; i++) {
       		RoleDataBean rdb = new RoleDataBean();
       		rdb.setDataBeanKeyRoleId(rootRoles[i].toString());
       		com.ibm.commerce.beans.DataBeanManager.activate(rdb, request);
      
       		roleNames[i][0] = rootRoles[i].toString();
       		roleNames[i][1] = rdb.getName();
          
       	}
   } else {
   	OrgEntityDataBean oedb = new OrgEntityDataBean();
   	oedb.setDataBeanKeyMemberId(orgId);
   	com.ibm.commerce.beans.DataBeanManager.activate(oedb, request);
   	
   	rootRoles = oedb.getRoles();
   	roleNames = new String[rootRoles.length][3];
   
   	for (int i =0; i < rootRoles.length; i++) {
   		RoleDataBean rdb = new RoleDataBean();
       		rdb.setDataBeanKeyRoleId(rootRoles[i].toString());
       		com.ibm.commerce.beans.DataBeanManager.activate(rdb, request);
      
       		roleNames[i][0] = rootRoles[i].toString();
       		roleNames[i][1] = rdb.getName();
       	}
   } 
   
   	java.text.Collator collator = java.text.Collator.getInstance(locale);
	String tmpStr[][] = new String[1][2];
	for (int i = 0; i < roleNames.length; i++) {
		for (int j = i + 1; j < roleNames.length; j++) {
			if (collator.compare(roleNames[i][1], roleNames[j][1]) > 0) {
				tmpStr[0][0] = roleNames[i][0];
				tmpStr[0][1] = roleNames[i][1];
				roleNames[i][0] = roleNames[j][0];
				roleNames[i][1] = roleNames[j][1];
				roleNames[j][0] = tmpStr[0][0];
				roleNames[j][1] = tmpStr[0][1];
			}
		}
   	}	
   
   int limit = 0;
   if (OrgIdOpt.length > 20)
   	limit = 20;
   else 
   	limit = OrgIdOpt.length;
   	
   for (int i=0; i < limit; i++) {
   	String oId = OrgIdOpt[i][0];
        OrgEntityDataBean oedb2 = new OrgEntityDataBean();
   	oedb2.setDataBeanKeyMemberId(oId);
   	com.ibm.commerce.beans.DataBeanManager.activate(oedb2, request);
   	
   	rootRolesToJS = oedb2.getRoles();
   	Vector roleVec = new Vector();
   
   	for (int j =0; j < rootRolesToJS.length; j++) {
   
		RoleDataBean rdb = new RoleDataBean();
        	rdb.setDataBeanKeyRoleId(rootRolesToJS[j].toString());
      
        	com.ibm.commerce.beans.DataBeanManager.activate(rdb, request);
        	Vector tmp = new Vector();
      		tmp.addElement(rootRolesToJS[j].toString());
      		tmp.addElement(rdb.getName());
        	roleVec.addElement(tmp);
        }   
       	java.text.Collator collate = java.text.Collator.getInstance(locale);
       	for (int m = 0; m < roleVec.size(); m++) {
       		for (int n = m + 1; n < roleVec.size(); n++) {
       			Vector vec1 = (Vector) roleVec.elementAt(m);
       			Vector vec2 = (Vector) roleVec.elementAt(n);
       			if (collator.compare((String) vec1.elementAt(1),(String) vec2.elementAt(1) ) > 0) {
       				roleVec.setElementAt(vec2, m);
       				roleVec.setElementAt(vec1, n);
      			}
       		}
        }	
        roleNamesToJS.addElement(roleVec);
   }
        
        numberOfRoles = rootRoles.length;
   
   
%>

   

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<html>
<head>
<%= fHeader%>
<LINK rel=stylesheet href="<%=UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">
<style type='text/css'>
.selectWidth {width: 400px;}
</style>
<TITLE><%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralRoles"))%></TITLE>
<script LANGUAGE="JavaScript1.2" SRC="/wcs/javascript/tools/common/SwapList.js"></script>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

<SCRIPT>
 var allgrpList = null; 
 var originalList = null;
 var assignedList = null;
 var deletedList = null;
 var addedList = null;

////////////////////////////////////////////////
// Load data from state of info for this page
// add them to the GUI
///////////////////////////////////////////////
function initializeState()
{
        
  var RoleArray = new Array();
  var UserRoleArray = new Array();
  
  for (var j=0; j < document.f1.SelectOrg.length; j++) {
 	if ("<%=UIUtil.toJavaScript(orgId)%>" == document.f1.SelectOrg[j].value) {
 		document.f1.SelectOrg[j].selected = true;
    	}
  }
  
  var x = parent.get("count");
  if (x != null) {
  	for (var i=0; i <= x ; i++) {
 		var tmpRoleId = parent.get("tempRoleId" + i);
 		if (tmpRoleId == null) continue;
 		var tmpRoleName = parent.get("tempRoleName" + i);
 		var tmpOrgId = parent.get("tempOrgId" + i);
 		var tmpOrgName = parent.get("tempOrgName" + i);
 		
 		var tmpName = tmpRoleName + ' - ' + tmpOrgName; 
		var currIndex = document.f1.definedRoles.length;        	        
       		document.f1.definedRoles.options[currIndex] = new Option(tmpName, tmpName, false, false);
       		document.f1.definedRoles.options[currIndex].selected=false;
       		document.f1.definedRoles.options[currIndex].value=tmpRoleId + ',' + tmpOrgId;
  	}
  	if (parent.setContentFrameLoaded) {
 		parent.setContentFrameLoaded(true);
	}
	return;
  }
  
  <%for(int i=0; i < userRoles.size(); i++) {
        
        Vector tmp = (Vector) userRoles.elementAt(i);
        String rId = (String) tmp.elementAt(0);
        String oId = (String) tmp.elementAt(1);
        
        RoleDataBean rdb2 = new RoleDataBean();
        rdb2.setDataBeanKeyRoleId(rId);
        com.ibm.commerce.beans.DataBeanManager.activate(rdb2, request);
        
        String roleNm = rdb2.getName();
        String orgNm = "";
        
        for (int j=0; j < OrgIdOpt.length; j++) {
            if (oId.equals(OrgIdOpt[j][0])) orgNm = OrgIdOpt[j][1];
        }
  %>      
        
        
        var displayName = '<%=UIUtil.toJavaScript(roleNm)%>' + ' - ' + '<%=UIUtil.toJavaScript(orgNm)%>'; 
        parent.put("tempRoleId" + <%=i%>, '<%=rId%>');
        parent.put("tempRoleName" + <%=i%>, '<%=roleNm%>');
        parent.put("tempOrgId" + <%=i%>, '<%=oId%>');
        parent.put("tempOrgName" + <%=i%>, '<%=orgNm%>');
        parent.put("count", <%=i%>);
        document.f1.definedRoles.options[<%=i%>] = new Option(displayName, displayName, false, false);
        document.f1.definedRoles.options[<%=i%>].selected=false;
        document.f1.definedRoles.options[<%=i%>].value='<%=rId%>' + ',' + '<%=oId%>';
        
        
<%    }
    
 %>

 
if (parent.setContentFrameLoaded) {
   parent.setContentFrameLoaded(true);
}

}

////////////////////////////////////////////////////////////////
// Add Role
////////////////////////////////////////////////////////////////
function addRole() 
{

var RoleArray = new Array();
var OrgArray = new Array();

<%	for (int i = 0; i < roleNames.length; i++) {
            	out.println("RoleArray[" + i + "] = new Array();");
            	out.println("RoleArray[" + i + "].roleId ='" + roleNames[i][0] + "';");
		out.println("RoleArray[" + i + "].name ='" + UIUtil.toJavaScript(roleNames[i][1]) + "';");
	}
	
%>
	var roleSelIndex = document.f1.SelectRole.selectedIndex;
	var rId = document.f1.SelectRole[roleSelIndex].value;
	
	if (rId == 'noroles') {
		alertDialog ("<%=UIUtil.toJavaScript((String)userWizardNLS.get("noRolesAvailableMsg")) %>");	
		return;
	}
	
	var roleName = document.f1.SelectRole[roleSelIndex].innerText;;
		
	orgSelIndex = document.f1.SelectOrg.selectedIndex;
	var oId = document.f1.SelectOrg[orgSelIndex].value;
	
	var orgName = document.f1.SelectOrg[orgSelIndex].innerText;
		
	var displayName = roleName + ' - ' + orgName; 
	
        var count = parent.get("count");
        if (count == null) count = 0;
        else count = count + 1;
        parent.put("tempRoleId"+count,rId);
        parent.put("tempRoleName"+count,roleName);
        parent.put("tempOrgId"+count,oId);
        parent.put("tempOrgName"+count,orgName);
        parent.put("count", count);

   	   	
	newIndex = document.f1.definedRoles.length;        	        
        document.f1.definedRoles.options[newIndex] = new Option(displayName, displayName, false, false);
        document.f1.definedRoles.options[newIndex].selected=false;
        document.f1.definedRoles.options[newIndex].value=rId + ',' + oId;

}

////////////////////////////////////////////////////////////////
// Remove Role
////////////////////////////////////////////////////////////////
function removeRole() 
{
	var selectionMade = false;
	
	for(var i = document.f1.definedRoles.length-1; i >= 0; i--) {
      		if(document.f1.definedRoles[i].selected == true) {
      			 var count = parent.get("count");
      			 for (var j=0; j <= count; j++) {
      			 	var tmpRoleId = parent.get("tempRoleId" + j);
      			 	var tmpOrgId = parent.get("tempOrgId" + j);
      			 	var x = tmpRoleId + ',' + tmpOrgId;
      			 	if (tmpRoleId == null) continue;
 				if (x == document.f1.definedRoles.options[i].value) {
 					parent.put("tempRoleId"+ j,null);
 				}
      			 	
      			 }
      			 if ('<%=UIUtil.toJavaScript(userId)%>' == '<%=cmdContext.getUserId().toString()%>'){
      			 	alertDialog ("<%=UIUtil.toJavaScript((String)userWizardNLS.get("siteAdminUnassign")) %>");
      			 }
        	         document.f1.definedRoles.options[i] = null;
        	         selectionMade = true;
      		}
	}


    <%-- If nothing was selected, prompt the user to select something. --%>
    if (!selectionMade) {
      alertDialog ("<%=UIUtil.toJavaScript((String)userWizardNLS.get("noRoleSelected")) %>");
      return;
    }


}


////////////////////////////////////////////////////////////////
// Change Organization
////////////////////////////////////////////////////////////////

function changeOrg()
{
	index = document.f1.SelectOrg.selectedIndex;
	orgId = document.f1.SelectOrg[index].value;
	selectObj = document.all['SelectRole'];
	if (index > 19) {
		url = top.getWebappPath() + "UserRolesView";
 		var param = new Object();
     		param.XMLFile = "adminconsole.UserRoles";
     		param.memberId = "<%=UIUtil.toJavaScript(userId)%>";
     		param.orgId = orgId;
     		
     		document.f1.addButton.disabled=true;    
     		parent.setContentFrameLoaded(false);
     		top.mccmain.submitForm(url,param,"CONTENTS");
     		return;
     	}
     	
     	
	var OrgRoleArray = new Array();
	
<%	for (int i = 0; i < roleNamesToJS.size(); i++) {
		Vector tmp = (Vector) roleNamesToJS.elementAt(i);
		out.println("OrgRoleArray[" + i + "] = new Array();");
		for (int j=0; j < tmp.size(); j++) {
			Vector tmp2 = (Vector) tmp.elementAt(j);
			String roleId = (String) tmp2.elementAt(0);
			String name = (String) tmp2.elementAt(1);
	            	
	            	out.println("OrgRoleArray[" + i + "]["+j+"] = new Array();");
	            	
	            	out.println("OrgRoleArray[" + i + "]["+j+"].roleId ='" + roleId + "';");
	            	out.println("OrgRoleArray[" + i + "]["+j+"].name ='" + UIUtil.toJavaScript(name) + "';");
        	    	
		}
	}
%>	
	document.f1.SelectRole.innerHTML = '';
	
	for (var i=0; i < OrgRoleArray[index].length; i++) {
		
			var opt = document.createElement('OPTION');
			opt.value = OrgRoleArray[index][i].roleId;
			opt.innerText = OrgRoleArray[index][i].name;
			selectObj.appendChild(opt);
	}
	if (OrgRoleArray[index].length == 0) {
		var opt = document.createElement('OPTION');
		opt.value = "noroles";
		opt.innerText = "<%=UIUtil.toJavaScript((String)userWizardNLS.get("noRolesAvailable")) %>";
		selectObj.appendChild(opt);
	}
	     	
}

////////////////////////////////////////////////////////////////
// Save Panel Data
////////////////////////////////////////////////////////////////
function savePanelData()
{  
    parent.addURLParameter("authToken", "${authToken}");
    for (var i=0; i < document.f1.definedRoles.options.length; i++) {
    	var x = document.f1.definedRoles.options[i].value;
    	var index = x.indexOf(',');
    	var rolId = x.substring(0,index)
    	var orgId = x.substring(index + 1, x.length);
    	
	var y = i + 1;    	
    	parent.put("<%=ECUserConstants.EC_ROLE_ROLEID%>"+y, rolId);
    	parent.put("<%=ECUserConstants.EC_ROLE_ORGENTITYID%>"+y,orgId);
    }
        
    
    parent.put("redirecturl","DialogNavigation");
    return true;
  
}  

function saveData()
{
  
}


////////////////////////////////////////////////////////////////
// Validate Panel Data
////////////////////////////////////////////////////////////////
function validatePanelData() {
//for (var i=0; i < document.f1.definedRoles.options.length; i++) {
//    	var x = document.f1.definedRoles.options[i].value;
//    	var index = x.indexOf(',');
//    	var rolId = x.substring(0,index)
//    	var orId = x.substring(index + 1, x.length);
//    	alert (rolId + " " + orId);
//    }
    return true;
}



</SCRIPT>

</head> 
<BODY ONLOAD="initializeState();" class="content">

<H1><%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralRoles"))%></H1>
<%=UIUtil.toHTML((String)userWizardNLS.get("addRoleText"))%><BR><BR>
   <FORM NAME='f1'>
   

       <TABLE summary="<%=UIUtil.toHTML((String)userWizardNLS.get("userAdminFindOrg"))%>">
       <TR><TD VALIGN=TOP>
       <TABLE>
       <TR><TD><LABEL for="SelectOrg1"><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupTopOrg"))%></LABEL><BR>
                 <SELECT NAME="SelectOrg" id="SelectOrg1" onChange="changeOrg()">

		<%for (int j=0; j < OrgIdOpt.length; j++) {
		    
		    %>

		<OPTION  VALUE="<%=OrgIdOpt[j][0]%>"><%=OrgIdOpt[j][1]%></OPTION>
		<%}%>
		

	      </SELECT>   
	</TD>
	
	</TR>      
	
	<TR><TD><LABEL for="SelectRole1"><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupRole"))%></LABEL><BR>
   	    <SELECT NAME="SelectRole" id="SelectRole1" >
		<%for (int i=0; i < roleNames.length; i++) {%>
		<OPTION  VALUE="<%=roleNames[i][0]%>"><%=roleNames[i][1]%></OPTION>
		<%}
		if (roleNames.length == 0) {%>
		<OPTION  VALUE="noroles"><%=UIUtil.toHTML((String)userWizardNLS.get("noRolesAvailable"))%></OPTION>
		<%}%>
	    </SELECT>
	</TD></TR>      
	
	</TABLE>
      	</TD>
      	<TD WIDTH=20 VALIGN=MIDDLE>
	    <INPUT TYPE='button' id='content' NAME='addButton' VALUE='<%=UIUtil.toHTML((String)userWizardNLS.get("addRole"))%>' onClick="addRole()">
	</TD>
	</TR>
	
	
	<TR><TD><BR><BR></TD></TR>	
	<TR><TD><LABEL for="definedRoles1"><%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralAssignedRoles"))%></LABEL><BR>
	    <SELECT NAME='definedRoles' id="definedRoles1"SIZE='10' MULTIPLE class="selectWidth"></SELECT>
	</TD>
	<TD WIDTH=20 VALIGN=MIDDLE>
	    <INPUT type="button" id='content' value="<%=UIUtil.toHTML((String)userWizardNLS.get("removeRole"))%>" onClick="removeRole()">
        </TD>
	</TR>
	

      </TABLE>
   
  
  </FORM>

</body>
</html>
