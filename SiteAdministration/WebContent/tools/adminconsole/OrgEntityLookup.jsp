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

<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.base.objects.*"   %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.base.objects.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="../common/List.jsp" %>

<%

// Set Command Context
CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale locale = cmdContext.getLocale();
String webalias = UIUtil.getWebPrefix(request);
JSPHelper jspHelper1       = new JSPHelper(request);


String name          		= jspHelper1.getParameter("name");

// obtain the resource bundle for display
Hashtable orgEntityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.OrgEntityNLS", locale);
Hashtable userAdminListNLS = (Hashtable) com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);

boolean tooMany = false;

Vector orgs = new Vector();

String theSql = "SELECT ORGENTITY_ID FROM ORGENTITY WHERE ORGENTITY.ORGENTITYNAME LIKE '%" + name + "%'";
ServerJDBCHelperBean helper = com.ibm.commerce.ejb.helpers.SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);
orgs = helper.executeQuery(theSql);

int numberOfOrgs = orgs.size();
if (numberOfOrgs > 14) {
	tooMany = true;
} else {
	for (int  i=orgs.size() - 1; i >-1; i--) {
		Vector orgVec = (Vector) orgs.elementAt(i);
		OrganizationAccessBean oab = new OrganizationAccessBean();
		oab.setInitKey_memberId((orgVec.elementAt(0)).toString());

		boolean allowed = WcsApp.accManager.isActionAllowed(cmdContext, "OrganizationManage", oab);
		if (!allowed) orgs.removeElementAt(i);
		
	}
}

numberOfOrgs = orgs.size();

if (tooMany) numberOfOrgs = 0;


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




function showParent()
{
	alertDialog("show parent");
}

function showChildren()
{
	alertDialog("show children");
}

function selectOrgEntity() 
{
    var checked = parent.getChecked();
    if (checked.length > 0) {
      	var temp = checked[0];
        var index = temp.indexOf('_',0);
        var orgEntityId = temp.substring(0,index);
        var row = temp.substring(index+1, temp.length);
        var cell = getCell("orgTableId",row,1);
    	parent.parent.setLookupValue(cell.innerHTML, orgEntityId);
    }
    
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

<BODY ONLOAD="onLoad();" class="content">
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

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistTable("orgTableId") %>
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
    
    if (tooMany) {%>
<SCRIPT LANGUAGE="JavaScript">    
    	parent.parent.setLookupValue(null, null);
</SCRIPT>    	
    <%}

    for (int i=getStartIndex(); i < endIndex; i++) {    
    
    	OrgEntityDataBean oedb = new OrgEntityDataBean();	
    	try {
    	
    	Vector orgVec = (Vector) orgs.elementAt(i);
    	
        oedb.setDataBeanKeyMemberId((orgVec.elementAt(0)).toString());
        
        
        com.ibm.commerce.beans.DataBeanManager.activate (oedb, request);
        
	memberId = oedb.getAttribute(ECUserConstants.EC_PARENTMEMBERID);
	parentName = UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralNone"));
	
	OrgEntityDataBean oedb2 = new OrgEntityDataBean();	
    	oedb2.setDataBeanKeyMemberId(memberId);
        com.ibm.commerce.beans.DataBeanManager.activate (oedb2, request);
        parentName = oedb2.getOrganizationName();
	
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
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheck(oedb.getOrganizationId() + "_" + String.valueOf(i + 1), "none" ) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(oedb.getOrganizationName()), null ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(parentName), null ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(BusCat), null ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(OrgType), null ) %> 

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>

<%
}
%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistTable() %>
<% if (!tooMany && numberOfOrgs == 0) {%>
    	<%=UIUtil.toHTML((String)orgEntityNLS.get("noOrgEntityToList"))%>

<%}%>
</FORM>
<SCRIPT LANGUAGE="JavaScript">
<!--
          parent.afterLoads();
          parent.setResultssize(getResultsSize());

// -->
</SCRIPT>
</BODY>
</HTML>