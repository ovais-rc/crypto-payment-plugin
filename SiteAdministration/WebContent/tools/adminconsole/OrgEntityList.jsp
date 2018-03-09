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

<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.base.objects.*"   %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>

<%@ include file="../common/common.jsp" %>
<%@include file="../common/List.jsp" %>

<%

// Set Command Context
CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale locale = cmdContext.getLocale();
String webalias = UIUtil.getWebPrefix(request);

// obtain the resource bundle for display
Hashtable orgEntityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.OrgEntityNLS", locale);
Hashtable userAdminListNLS = (Hashtable) com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
   if (orgEntityNLS == null) System.out.println("!!!! RS is null");

String strMessage = "";
String strMessageKey = "";
Object[] strMessageParams = null;
String strFieldName = "";

// OrgEntityManageDataBean provides a list of all organizations and a list of all organizatoinal units.
OrgEntityManageDataBean bnOrgEntityManage = new OrgEntityManageDataBean();
com.ibm.commerce.beans.DataBeanManager.activate (bnOrgEntityManage, request);
String[][] OrgIdOpt = bnOrgEntityManage.getOrgEntityList();
//String[][] OrganizationUnitIdOptions = bnOrgEntityManage.getOrganizationUnitList();
//OrganizationAccessBean[] OrgAB = bnOrgEntityManage.getOrgEntityAccessBeanList();

int numberOfOrgs = OrgIdOpt.length;

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<%= fHeader%>
<LINK rel=stylesheet href="<%=UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">

<TITLE><%= UIUtil.toHTML((String)orgEntityNLS.get("organization")) %></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

    function getResultsSize() { 
     return <%= numberOfOrgs  %>; 
    }


    function newOrgEntity()
    {
	
      var url = top.getWebappPath() + "WizardView?XMLFile=adminconsole.OrgEntityWizard";
      if (top.setContent)
      {
        top.setContent("<%= UIUtil.toJavaScript((String)userAdminListNLS.get("newOrgBCT")) %>",
                       url,
                       true);
      }
      else
      {
        parent.location.replace(url);
      }
    }

    function changeOrgEntity()
    {
      var changed = 0;
      var orgEntityId = 0;

      if (arguments.length > 0)
      {
        orgEntityId = arguments[0];
        changed = 1;
      }
      else
      {
        var checked = parent.getChecked();
        if (checked.length > 0)
        {
          orgEntityId = checked[0];
          changed = 1;
        }
      }
      if (changed != 0)
      {
        var url = top.getWebappPath() + "NotebookView?XMLFile=adminconsole.OrgEntityNotebook";
        url += "&orgEntityId=" + orgEntityId;
        if (top.setContent)
        {
          top.setContent("<%= UIUtil.toJavaScript((String)userAdminListNLS.get("chgOrgBCT")) %>",
                         url,
                         true);
        }
        else
        {
          parent.location.replace(url);
        }
      } 
    }
    
    function changeApprovalOrgEntity()
    {
      var changed = 0;
      var orgEntityId = 0;

      if (arguments.length > 0)
      {
        orgEntityId = arguments[0];
        changed = 1;
      }
      else
      {
        var checked = parent.getChecked();
        if (checked.length > 0)
        {
          orgEntityId = checked[0];
          changed = 1;
        }
      }
      if (changed != 0)
      {
        var url = top.getWebappPath() + "DialogView?XMLFile=adminconsole.OrgEntityApprovals";
        url += "&orgEntityId=" + orgEntityId;
        if (top.setContent)
        {
          top.setContent("<%= UIUtil.toJavaScript((String)orgEntityNLS.get("OrgEntityApproval")) %>",
                         url,
                         true);
        }
        else
        {
          parent.location.replace(url);
        }
      } 
    }
    
    function changeRoleOrgEntity()
    {
      var changed = 0;
      var orgEntityId = 0;

      if (arguments.length > 0)
      {
        orgEntityId = arguments[0];
        changed = 1;
      }
      else
      {
        var checked = parent.getChecked();
        if (checked.length > 0)
        {
          orgEntityId = checked[0];
          changed = 1;
        }
      }
      if (changed != 0)
      {
        var url = top.getWebappPath() + "DialogView?XMLFile=adminconsole.OrgEntityRoles";
        url += "&memberId=" + orgEntityId;
        if (top.setContent)
        {
          top.setContent("<%= UIUtil.toJavaScript((String)orgEntityNLS.get("OrgEntityRoles")) %>",
                         url,
                         true);
        }
        else
        {
          parent.location.replace(url);
        }
      } 
    }

function deleteOrgEntity()
{
	alertDialog("delete org entity");
}


function showParent()
{
	alertDialog("show parent");
}

function showChildren()
{
	alertDialog("show children");
}

    function onLoad() 
    {
      parent.loadFrames();
    }

    function getRefNum() 
    {
      return <%= getRefNum() %>;
    }
// -->
</script>

<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/dynamiclist.js"></SCRIPT>

</HEAD>

<BODY ONLOAD="onLoad()" class="content">
<%
          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));          
	  int endIndex = getStartIndex() + getListSize();
    	  if (endIndex > numberOfOrgs)
      		endIndex = numberOfOrgs;
          int totalsize = numberOfOrgs;
          int totalpage = totalsize/listSize;          
	
%>
<%=com.ibm.commerce.tools.common.ui.taglibs.comm.addControlPanel("adminconsole.OrgEntityList", totalpage, totalsize, cmdContext.getLocale() )%>

<FORM NAME="orgEntityForm" ACTION="OrgEntityListView" METHOD="POST">
<%=addHiddenVars()%>

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistTable((String)orgEntityNLS.get("OrgEntityListTitle")) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRowHeading() %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheckHeading() %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)orgEntityNLS.get("orgEntityNameColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)orgEntityNLS.get("orgEntityParentColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)orgEntityNLS.get("orgEntityBusCatColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)orgEntityNLS.get("orgEntityOrgTypeColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>



<!-- Need to have a for loop to lookfor all the member groups -->
<%
    String classId = "list_row1";
    String memberId = new String();
    String parentName = new String();
    String BusCat = new String();
    String OrgType = new String();
    int rowselect=1;
    

    for (int i=getStartIndex(); i < endIndex; i++) {    
    
    	OrgEntityDataBean oedb = new OrgEntityDataBean();	
    	try {
        oedb.setDataBeanKeyMemberId(OrgIdOpt[i][0]);
        com.ibm.commerce.beans.DataBeanManager.activate (oedb, request);
        
	memberId = oedb.getAttribute(ECUserConstants.EC_PARENTMEMBERID);
	parentName = UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralNone"));
	for (int j = 0; j < OrgIdOpt.length; j++) {
		if (memberId != null && OrgIdOpt[j][0].equals(memberId)) {
			parentName = OrgIdOpt[j][1];
			break;
		}
	}	
	
	BusCat = oedb.getBusinessCategory(); 
	if (BusCat == null) {
		BusCat = "";
	}
	
	OrgType = oedb.getOrgEntityType();
	if (OrgType.equals("O")) {
		OrgType = UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralSelectOrg"));
	}
	else {
		OrgType = UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralSelectOrgUnit"));
	}
        
        } catch (Exception e) {}
%>

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRow(rowselect) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheck(oedb.getOrganizationId(), "none" ) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(oedb.getOrganizationName()), "javascript:changeOrgEntity('"+ oedb.getOrganizationId() +"');" ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(parentName), null ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(BusCat), null ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(OrgType), null ) %> 

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>

<%
}
%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistTable() %>

</FORM>
<SCRIPT LANGUAGE="JavaScript">
<!--
          parent.afterLoads();
          parent.setResultssize(getResultsSize());

// -->
</SCRIPT>
</BODY>
</HTML>