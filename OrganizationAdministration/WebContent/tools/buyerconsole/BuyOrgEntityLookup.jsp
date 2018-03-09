<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ page language="java" %>

<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.base.objects.*"   %>
<%@ page import="com.ibm.commerce.base.helpers.*"   %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.base.objects.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>
<%@ page import="com.ibm.commerce.member.search.WhereClauseSearchCondition" %>
<%@ page import="com.ibm.commerce.user.beans.CustomerSearchDataBean" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="../common/List.jsp" %>

<!-- Resource: tools/buyerconsole/BuyOrgEntityLookup.jsp -->

<%
	// Set Command Context
	CommandContext cmdContext = 
		(CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();
	JSPHelper jspHelper1 = new JSPHelper(request);
	String webalias = UIUtil.getWebPrefix(request);

	// Constants
	int MAX_NUMBER_OF_ORGS = 24;

	// obtain the resource bundle for display
	Hashtable orgEntityNLS = 
		(Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup(
			"buyerconsole.BuyOrgEntityNLS", locale);
	Hashtable userAdminListNLS = 
		(Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup(
			"buyerconsole.BuyAdminConsoleNLS", locale);

	// Retrieve the name parameter, if set
	int lastPos = 0;
	String name = jspHelper1.getParameter("name");
	if (name != null) {
		while (name.indexOf('\'', lastPos) != - 1) {
			lastPos = name.indexOf('\'', lastPos);
			name = name.substring(0,lastPos) + '\'' + name.substring(lastPos);
			lastPos += 2;
		}
	}

	// Local variables
	boolean tooMany = false;
	Vector orgs = null;
	int numberOfOrgs = 0;
	String start = request.getParameter("startindex");
	String listSz = request.getParameter("listsize");

	CustomerSearchDataBean dbCustomerSearch = new CustomerSearchDataBean();
	dbCustomerSearch.setCommandContext(cmdContext);
	orgs = dbCustomerSearch.findOrganizationsICanAdminister(
		"ManageExcludingAD",
		name,
		new Integer(
			WhereClauseSearchCondition.SEARCHTYPE_CASEINSENSITIVE_STARTSWITH).toString(),
		null,
		null,
		"0",
		new Integer(MAX_NUMBER_OF_ORGS + 1).toString());
		
	// ---
	// This logic will remove the default org from the resultset, we do not
	// want the default org to show up in the parent org list
	// ---
	boolean isFoundDefaultOrg = false;
	for (int i=0; i<orgs.size(); i++) {
		if ("-2000".equals(((Vector)orgs.get(i)).get(0).toString())) {
			orgs.removeElementAt(i);
			break;
		}
	} 
		
	numberOfOrgs = orgs.size();
	if (numberOfOrgs > MAX_NUMBER_OF_ORGS) { 
		// There are too many orgs to display!
		tooMany = true; 
		numberOfOrgs = 0;
	}
	else {
		tooMany = false;
	}
%>

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


	function showParent() {
		alertDialog("show parent");
	}

	function showChildren() {
		alertDialog("show children");
	}

	function selectOrgEntity() {
		var checked = parent.getChecked();
		if (checked.length > 0) {
			var temp = checked[0];
        	var index = temp.indexOf('_',0);
        	var orgEntityId = temp.substring(0,index);
        	var subrow = new Number(temp.substring(index+1, temp.length));
        	var list = new Number("<%=UIUtil.toJavaScript(listSz)%>");
        	var row = subrow % list;
        	if (row == 0) row = list;
        	var cell = getCell("orgTableId",row,1);
      		parent.parent.setLookupValue(cell.innerHTML, orgEntityId);
    	}
	}

	function onLoad() {
		parent.loadFrames();
		parent.top.showProgressIndicator(false);
	}

	function getRefNum() {
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
	if (endIndex > numberOfOrgs) {
		endIndex = numberOfOrgs;
	}
	int totalsize = numberOfOrgs;
	int totalpage = totalsize/listSize;
%>

<SCRIPT LANGUAGE="JavaScript">
	parent.set_t_item_page(<%=numberOfOrgs%>, <%=listSize%>);
</SCRIPT>

<FORM NAME="orgEntityForm" ACTION="OrgEntityListView" METHOD="POST">
<%=addHiddenVars()%>

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistTable("orgTableId") %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRowHeading() %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheckHeading(false) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading(
	(String)orgEntityNLS.get("orgEntityNameColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading(
	(String)orgEntityNLS.get("orgEntityParentColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading(
	(String)orgEntityNLS.get("orgEntityBusCatColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading(
	(String)orgEntityNLS.get("orgEntityOrgTypeColumn"), null, false )%>
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
		parent.top.showProgressIndicator(false);
		parent.parent.setLookupValue(null, null);
		</SCRIPT>
	<%}

	for (int i=getStartIndex(); i < endIndex; i++) {

		OrganizationAccessBean oedb = new OrganizationAccessBean();
		try {
	        Vector orgVec = (Vector) orgs.elementAt(i);
	        oedb.setInitKey_memberId(
	        	(orgVec.elementAt(0)).toString());
	   		memberId = oedb.getParentMemberId();
	   		parentName = UIUtil.toHTML(
	   			(String)orgEntityNLS.get("OrgEntityGeneralNone"));	
	   		BusCat = oedb.getBusinessCategory();
	   		if (BusCat == null) {
	      		BusCat = "";
	   		}
	
	   		OrgType = oedb.getOrgEntityType();
	   		if (OrgType.equals("O")) {
	      		OrgType = UIUtil.toHTML(
	      			(String)orgEntityNLS.get("OrgEntityGeneralSelectOrg"));
	   		}
	   		else {
	      		OrgType = UIUtil.toHTML(
	      			(String)orgEntityNLS.get("OrgEntityGeneralSelectOrgUnit"));
	   		}
	   		
	   		if (memberId != null && !memberId.equals("")) {
	      		OrganizationAccessBean oedb2 = new OrganizationAccessBean();
	         	oedb2.setInitKey_memberId(memberId);
	         	parentName = oedb2.getOrganizationName();
	        }
		} 
		catch (Exception e) {}
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