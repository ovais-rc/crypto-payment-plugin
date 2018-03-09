<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//* 
//* (c) Copyright IBM Corp. 2000, 2016
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
<%@ page import="com.ibm.commerce.user.helpers.*" %>
<%@ page import="com.ibm.commerce.member.constants.ECMemberConstants" %>
<%@ page import="com.ibm.commerce.tools.segmentation.SegmentConstants"   %>

<%@ include file="../common/common.jsp" %>

<%
    CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cmdContext.getLocale();
    String webalias = UIUtil.getWebPrefix(request);
%>
<%
    Hashtable userWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
   if (userWizardNLS == null) System.out.println("!!!! RS is null");
   int numberOfRoles = 0;
   Integer[] rootRoles = null;
   Integer[] orgRoles = null;
   String[][] roleNames = null;
   
   String mbrGrpId = request.getParameter("segmentId");
   String orgId = request.getParameter("orgId");
   String orgId2 = "";
   if (orgId == null || orgId.equals("") || orgId.equals("all") || orgId.equals("?")) orgId2 = ECMemberConstants.EC_DB_ROOT_ORGANIZATION_ID;
   else orgId2 = orgId;
   
   OrgEntityDataBean oedb = new OrgEntityDataBean();
   oedb.setDataBeanKeyMemberId(orgId2);
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
   numberOfRoles = rootRoles.length;
   
   OrgEntityManageDataBean bnOrgEntityManage = new OrgEntityManageDataBean();
   com.ibm.commerce.beans.DataBeanManager.activate (bnOrgEntityManage, request);
   String[][] OrgIdOpt = bnOrgEntityManage.getOrgEntityList();
   
   int numberOfOrgs = OrgIdOpt.length;
   
            
%>

   

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<html>
<head><title><%=UIUtil.toHTML((String)userWizardNLS.get("Criteria"))%></title>
<%= fHeader%>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">
<style type='text/css'>
.selectWidth {width: 300px;}
</style>

<script LANGUAGE="JavaScript1.2" SRC="<%=webalias%>javascript/tools/common/SwapList.js"></script>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>

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

   var OrgArray = new Array();
<%
   for (int j = 0; j < OrgIdOpt.length; j++) {
      	out.println("OrgArray[" + j + "] = new Array();");
       	out.println("OrgArray[" + j + "].orgId ='" + OrgIdOpt[j][0] + "';");
	out.println("OrgArray[" + j + "].name ='" + UIUtil.toJavaScript(OrgIdOpt[j][1]) + "';");
   }

%>
   var o = parent.get("<%=SegmentConstants.ELEMENT_SEGMENT_DETAILS%>", null);
   var rolArray = o.<%=SegmentConstants.ELEMENT_ROLE%>;
   var orgArray = o.<%=SegmentConstants.VARIABLE_ORG%>;
   var regArray = o.<%=SegmentConstants.ELEMENT_REGISTRATION_STATUS_OP%>;
   var criteria = false;
   var setAd2 = parent.get("setAdmin2");
   if (setAd2 == null)  setAd2 = false;
   var setAd3 = parent.get("setAdmin3");
   if (setAd3 == null)  setAd3 = false;
   
   
   if (setAd2 || rolArray.length != 0 || orgArray.length != 0) {
        document.f1.setAdmin2.checked = true;
	basedOnRoleOrg();
	if ( rolArray.length != 0) {
		for (var i=0; i < o.<%=SegmentConstants.ELEMENT_ROLE%>.length; i++) {
			var roleName = 	o.<%=SegmentConstants.ELEMENT_ROLE%>[i].role;
			var orgId = o.<%=SegmentConstants.ELEMENT_ROLE%>[i].org;
			var orgName = '';
			if (roleName == null || roleName == '') roleName = '<%=UIUtil.toJavaScript((String) userWizardNLS.get("allRoles"))%>';
			if (orgId == null || orgId == '') {
				orgName = '<%=UIUtil.toJavaScript((String) userWizardNLS.get("allOrgs"))%>';
				orgId = 'all';
			}
			else if (orgId == '?') orgName = '<%=UIUtil.toJavaScript((String) userWizardNLS.get("forOrg"))%>';
			else {
				for (var k=0; k < OrgArray.length; k++) {
					if (orgId == OrgArray[k].orgId) orgName = OrgArray[k].name;
				}
			}
		
			var displayName = roleName + " - " + orgName;
			document.f1.definedRoles.options[i] = new Option(displayName, displayName, false, false);
			document.f1.definedRoles.options[i].value=roleName + ',' + orgId;
		}
	}
	
	if (orgArray.length != 0) {
		for (var m=0; m < o.<%=SegmentConstants.VARIABLE_ORG%>.length; m++) {
			var orgName = '';
			var roleName = '<%=UIUtil.toJavaScript((String) userWizardNLS.get("allRoles"))%>';
			var orgId = o.<%=SegmentConstants.VARIABLE_ORG%>[m];
			if (orgId == null || orgId == '') {
				orgName = '<%=UIUtil.toJavaScript((String) userWizardNLS.get("allOrgs"))%>';
				orgId = 'all';
			}
			else if (orgId == '?') orgName = '<%=UIUtil.toJavaScript((String) userWizardNLS.get("forOrg"))%>';
			else {
				for (var n=0; n < OrgArray.length; n++) {
					if (orgId == OrgArray[n].orgId) orgName = OrgArray[n].name;
				}
			}
		
			var displayName = roleName + " - " + orgName;
			var index = document.f1.definedRoles.options.length;
			document.f1.definedRoles.options[index] = new Option(displayName, displayName, false, false);
			document.f1.definedRoles.options[index].value=roleName + ',' + orgId;
		}
	}
	criteria = true;
   
   } 
   
   if (setAd3 || regArray != '<%=SegmentConstants.VALUE_DO_NOT_USE%>') {
   	document.f1.setAdmin3.checked = true;
   	basedOnReg();
   	var reg = o.<%=SegmentConstants.ELEMENT_REGISTRATION_STATUS_OP%>;
   	for (var i=0; i < document.f1.regList.length; i++) {
   		if (reg == document.f1.regList[i].value) document.f1.regList[i].selected = true;
   	}
   	criteria = true;
   }
   
   if (!criteria) {
   	noCriteria();
   	document.f1.setAdmin1.checked = true;
   } 
   
   if ("<%=UIUtil.toJavaScript(orgId)%>" != null || "<%=UIUtil.toJavaScript(orgId)%>" != "") {
   	for (var j=0; j < document.f1.SelectOrg.length; j++) {
	 	if ("<%=UIUtil.toJavaScript(orgId)%>" == document.f1.SelectOrg[j].value) {
	 		document.f1.SelectOrg[j].selected = true;
	 	}
	}
   }
   
   
 
   var admin2 = parent.get("setAdmin2");
   if (admin2) {
   	document.f1.setAdmin2.checked = true;
   	basedOnRoleOrg();
   }
   var admin3 = parent.get("setAdmin3");
   if (admin3) {
   	document.f1.setAdmin3.checked = true;
   	basedOnReg();
   }
   
   

if (parent.setContentFrameLoaded) {
   parent.setContentFrameLoaded(true);
}

}



function savePanelData()
{  

        var o = parent.get("<%=SegmentConstants.ELEMENT_SEGMENT_DETAILS%>", null);
        var org = new Array();
        var orgCount = 0;
        var role = new Array();
        var roleCount = 0;
        
	if (document.f1.setAdmin2.checked) {
		for (var i=0; i < document.f1.definedRoles.options.length; i++) {
    			var x = document.f1.definedRoles.options[i].value;
		    	var index = x.indexOf(',');
		    	var rolId = x.substring(0,index)
    			var orgId = x.substring(index + 1, x.length);
    			
    			if (rolId == '<%=UIUtil.toJavaScript((String) userWizardNLS.get("allRoles"))%>') {
    				if (orgCount == 0) o.<%=SegmentConstants.VARIABLE_ORG%> = new Array();
    				o.<%=SegmentConstants.VARIABLE_ORG%>[orgCount] = new Object();
    				o.<%=SegmentConstants.VARIABLE_ORG%>[orgCount] = orgId;
    				orgCount++;
    				continue;
    			}
    			
    			if (roleCount == 0) o.<%=SegmentConstants.ELEMENT_ROLE%> = new Array();
    			o.<%=SegmentConstants.ELEMENT_ROLE%>[roleCount] = new Object();
    			o.<%=SegmentConstants.ELEMENT_ROLE%>[roleCount].role = rolId;
    			if (orgId != 'all') o.<%=SegmentConstants.ELEMENT_ROLE%>[roleCount].org = orgId;
    			roleCount++;
    		}
	}
	
	if (document.f1.setAdmin3.checked) {
		var regIndex = document.f1.regList.selectedIndex;
		o.<%=SegmentConstants.ELEMENT_REGISTRATION_STATUS_OP%> = document.f1.regList[regIndex].value;
	
	}
	
	if (document.f1.setAdmin1.checked) {
		o.<%=SegmentConstants.ELEMENT_ROLE%> = new Array();
		o.<%=SegmentConstants.VARIABLE_ORG%> = new Array();
		o.<%=SegmentConstants.ELEMENT_REGISTRATION_STATUS_OP%> = '<%=SegmentConstants.VALUE_DO_NOT_USE%>';
	}
  
}  


function saveData()
{
  
}

function noCriteria()
{
	document.all["setAdminArea2"].style.display = "none";	
	document.all["setAdminArea3"].style.display = "none";
	document.f1.setAdmin2.checked = false;
	document.f1.setAdmin3.checked = false;
	parent.put("setAdmin2", false);
	parent.put("setAdmin3", false);
}

function basedOnRoleOrg()
{
	document.f1.setAdmin1.checked = false;
	if (document.f1.setAdmin2.checked) {
		document.all["setAdminArea2"].style.display = "block";	
		parent.put("setAdmin2", true);
	} else {
		document.all["setAdminArea2"].style.display = "none";	
    		parent.put("setAdmin2", false);
    	}
}    	
	


function basedOnReg()
{
	document.f1.setAdmin1.checked = false;
	if (document.f1.setAdmin3.checked) {
		document.all["setAdminArea3"].style.display = "block";	
		parent.put("setAdmin3", true);
	} else {
		document.all["setAdminArea3"].style.display = "none";	
    		parent.put("setAdmin3", false);
    	}
}

////////////////////////////////////////////////////////////////
// Change Organization
////////////////////////////////////////////////////////////////

function changeOrg()
{
	index = document.f1.SelectOrg.selectedIndex;
	orgId = document.f1.SelectOrg[index].value;
	url = top.getWebappPath() + "AdminConMemberGroupCriteria";
 	var param = new Object();
     	param.XMLFile = "adminconsole.UserRoles";
     	param.orgId = orgId;
     	
     	savePanelData();
     	parent.setContentFrameLoaded(false);
     	top.mccmain.submitForm(url,param,"CONTENTS");
}

////////////////////////////////////////////////////////////////
// Add Role
////////////////////////////////////////////////////////////////
function addRole() 
{

var o = parent.get("<%=SegmentConstants.ELEMENT_SEGMENT_DETAILS%>", null);

var roleSize;
if (o.<%=SegmentConstants.ELEMENT_ROLE%> == null) roleSize = 0;
else roleSize = o.<%=SegmentConstants.ELEMENT_ROLE%>.length;

var orgSize;
if (o.<%=SegmentConstants.QUALIFIER_ORG%> == null) orgSize = 0;
else orgSize = o.<%=SegmentConstants.QUALIFIER_ORG%>.length;

var RoleArray = new Array();
var OrgArray = new Array();

<%	for (int i = 0; i < roleNames.length; i++) {
            	out.println("RoleArray[" + i + "] = new Array();");
            	out.println("RoleArray[" + i + "].roleId ='" + roleNames[i][0] + "';");
		out.println("RoleArray[" + i + "].name ='" + UIUtil.toJavaScript(roleNames[i][1]) + "';");
	}
	
	for (int j = 0; j < OrgIdOpt.length; j++) {
            	out.println("OrgArray[" + j + "] = new Array();");
            	out.println("OrgArray[" + j + "].orgId ='" + OrgIdOpt[j][0] + "';");
		out.println("OrgArray[" + j + "].name ='" + UIUtil.toJavaScript(OrgIdOpt[j][1]) + "';");
	}

%>
	rolSelIndex = document.f1.SelectRole.selectedIndex;
	var rId = document.f1.SelectRole[rolSelIndex].value;
	var rolName = '';
	if (rId == 'all') rolName = '<%=UIUtil.toJavaScript((String) userWizardNLS.get("allRoles"))%>';
	else {
		for (var i=0; i < RoleArray.length; i++) {
			if (RoleArray[i].roleId == rId) rolName = RoleArray[i].name; 
		}
	}
	
	var oId = '';
	var orgName = '';

	if (document.f1.dynOrgs.checked) {
		oId = '?'
		orgName = '<%=UIUtil.toJavaScript((String) userWizardNLS.get("forOrg"))%>';
	} else {
		orgSelIndex = document.f1.SelectOrg.selectedIndex;
		var oId = document.f1.SelectOrg[orgSelIndex].value;
		var orgName = '';
		if (oId == "all") orgName = '<%=UIUtil.toJavaScript((String) userWizardNLS.get("allOrgs"))%>';
		//else if (oId == "?") orgName = '<%=UIUtil.toJavaScript((String) userWizardNLS.get("forOrg"))%>';
		else {
			for (var j=0; j < OrgArray.length; j++) {
				if (OrgArray[j].orgId == oId) orgName = OrgArray[j].name; 
			}
		}
	}
	
	
	
	var displayName = rolName + ' - ' + orgName; 
        	        
	newIndex = document.f1.definedRoles.length;        	        
        document.f1.definedRoles.options[newIndex] = new Option(displayName, displayName, false, false);
        document.f1.definedRoles.options[newIndex].selected=false;
        document.f1.definedRoles.options[newIndex].value=rolName + ',' + oId;

}

////////////////////////////////////////////////////////////////
// Remove Role
////////////////////////////////////////////////////////////////
function removeRole() 
{
	var selectionMade = false;
	
	for(var i = document.f1.definedRoles.length-1; i >= 0; i--) {
      		if(document.f1.definedRoles[i].selected == true) {
        	         document.f1.definedRoles.options[i] = null;
        	         selectionMade = true;
      		}
	}


    <%-- If nothing was selected, prompt the user to select something. --%>
    if (!selectionMade) {
      alertDialog("<%=UIUtil.toJavaScript((String)userWizardNLS.get("noRoleOrgSelected")) %>");
      return;
    }


}

</SCRIPT>

</head>
<BODY ONLOAD="initializeState();">

<H1><%=UIUtil.toHTML((String)userWizardNLS.get("Criteria"))%></H1>





   <FORM NAME='f1'>

   
   
       
       <TABLE BORDER='0' summary="<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralRoles"))%>">
       
       <TR><TD>
       <LABEL><INPUT name="setAdmin1" type="CheckBox" CHECKED onClick="noCriteria()" ><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupNoCriteria"))%></LABEL>
       </TD></TR>
       <TR><TD>
       </TD></TR>

<!------------------------------------------------------------------------------------>       
       <TR><TD>
       <LABEL><INPUT name="setAdmin2" type="CheckBox" onClick="basedOnRoleOrg()"><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupBasedOnOrgRole"))%></LABEL>
       </TD></TR>
       <TR><TD>
       <DIV ID="setAdminArea2" STYLE="display:none;">
           <TABLE BORDER='0' summary="Div Block 1">
          	
          	<TR><TD WIDTH=10></TD> <TD VALIGN=TOP>
       		<TABLE>
       		<TR><TD><LABEL for="SelectOrg1"><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupTopOrg"))%></LABEL><BR>
                 <SELECT NAME="SelectOrg" id="SelectOrg1" onChange="changeOrg()" >
                 	<OPTION VALUE="all"><%=UIUtil.toHTML((String) userWizardNLS.get("allOrgs"))%></OPTION>
			<%for (int j=0; j < OrgIdOpt.length; j++) { 	%>
			<OPTION  VALUE="<%=OrgIdOpt[j][0]%>"><%=OrgIdOpt[j][1]%></OPTION>
			<%}%>
		</SELECT>   
		</TD></TR>      
		<TR><TD><BR></TD></TR>
		<TR><TD><LABEL for="SelectRole1"><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupRole"))%></LABEL><BR>
   	    	<SELECT NAME="SelectRole" id="SelectRole1">
   	    		<OPTION VALUE="all"><%=UIUtil.toHTML((String) userWizardNLS.get("allRoles"))%></OPTION>
			<%for (int i=0; i < roleNames.length; i++) {%>
			<OPTION  VALUE="<%=roleNames[i][0]%>"><%=roleNames[i][1]%></OPTION>
			<%}%>
	    	</SELECT>
		</TD></TR>      
		<TR><TD>
			<LABEL><INPUT TYPE="CheckBox" NAME="dynOrgs" SIZE="1"><%=UIUtil.toHTML((String)userWizardNLS.get("forOrg"))%></LABEL>
		</TD></TR>
	
		</TABLE>
      		</TD>
      		<TD VALIGN=BOTTOM>
	    	<INPUT TYPE='button' id='content' WIDTH=20 VALUE='<%=UIUtil.toHTML((String)userWizardNLS.get("addRole"))%>' onClick="addRole()">
		</TD></TR>
	
	
		<TR><TD><BR></TD></TR>	
		
		<TR><TD WIDTH=10></TD> <TD VALIGN=TOP>
		<TABLE>
		<TR><TD><LABEL for="definedRoles1"><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupSelRoleOrg"))%></LABEL><BR>
	    	<SELECT NAME='definedRoles' id="definedRoles1" SIZE='5' MULTIPLE class="selectWidth"></SELECT>
		</TD></TR>
		</TABLE>
		</TD>
		<TD VALIGN=MIDDLE>
	    	<INPUT type="button" id='content' WIDTH=20 value="<%=UIUtil.toHTML((String)userWizardNLS.get("removeRole"))%>" onClick="removeRole()">
        	</TD></TR>
        	
        	

      	</TABLE>
             
          
           <TR><TD>
           <LABEL><INPUT TYPE="CheckBox" NAME="setAdmin3" SIZE="1" onClick="basedOnReg()"><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupBasedOnReg"))%></LABEL>
           </TR></TR>
           <TR><TD>
           <DIV ID="setAdminArea3" STYLE="display:none;">
              <TABLE BORDER='0' summary="<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralRoles"))%>">
       
		<TR><TD><LABEL for="regList1"><%=UIUtil.toHTML((String)userWizardNLS.get("registrationStatus"))%></LABEL><BR>
		<SELECT NAME="regList" id="regList1">
			<OPTION  VALUE="G"><%=UIUtil.toHTML((String)userWizardNLS.get("guest"))%></OPTION>
			<OPTION  VALUE="R"><%=UIUtil.toHTML((String)userWizardNLS.get("registered"))%></OPTION>
			<OPTION  VALUE="A"><%=UIUtil.toHTML((String)userWizardNLS.get("admin"))%></OPTION>
			<OPTION  VALUE="S"><%=UIUtil.toHTML((String)userWizardNLS.get("siteAdmin"))%></OPTION>
	      	</SELECT>   
		</TD></TR>	
	      </TABLE>       
           </DIV>   
           </TD></TR>
           </TABLE>
       </DIV>  
       </TD></TR>
       </TABLE>
   
  
  </FORM>

</body>
</html>
