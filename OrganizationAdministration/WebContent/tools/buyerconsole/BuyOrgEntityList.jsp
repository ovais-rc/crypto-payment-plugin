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
<%@ page import="com.ibm.commerce.base.helpers.*"   %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>
<%@ page import="com.ibm.commerce.member.constants.ECMemberConstants" %>
<%@ page import="com.ibm.commerce.member.search.WhereClauseSearchCondition" %>
<%@ page import="com.ibm.commerce.user.beans.CustomerSearchDataBean" %>
<%@ page import="com.ibm.commerce.ras.ECTrace" %>
<%@ page import="com.ibm.commerce.ras.ECTraceIdentifiers" %>
	

<%@ include file="../common/common.jsp" %>
<%@ include file="../common/List.jsp" %>

<%

final String CLASSNAME = "BuyOrgEntityList.jsp";

	// Set Command Context
	CommandContext cmdContext = 
		(CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();
	String webalias = UIUtil.getWebPrefix(request);
	String isSiteAdmin = cmdContext.getUser().isSiteAdministrator()
		? "true"
		: "false";

	// obtain the resource bundle for display
	Hashtable orgEntityNLS = 
		(Hashtable)com.ibm.commerce.tools.util.ResourceDirectory
			.lookup("buyerconsole.BuyOrgEntityNLS", locale);
	Hashtable userAdminListNLS2 = 
		(Hashtable)com.ibm.commerce.tools.util.ResourceDirectory
			.lookup("adminconsole.AdminConsoleNLS", locale);
	
	if (orgEntityNLS == null) System.out.println("!!!! RS is null");
   
	Long userId = cmdContext.getUserId();
	
	UserRegistrationDataBean urdbtemp = new UserRegistrationDataBean();
	urdbtemp.setDataBeanKeyMemberId(userId.toString());
	DataBeanManager.activate(urdbtemp, request);	
	String parentOrg = urdbtemp.getParentMemberId();

    //---
	// Determine the orgs where the user cannot modify roles. 
	// Should be able to modify roles of RC MbrGrp orgs, so don't include them 
	// in the exclusion list below.
	//---
	Vector vecTopLevelDirectOrgIDs = urdbtemp.getTopLevelOrganizationsDirectlyAdministered();
	
	JSPHelper jspHelper1 	= new JSPHelper(request);
	String name 			= jspHelper1.getParameter("name");
	String orgname 			= jspHelper1.getParameter("orgname");
   
	if (name != null) {
		int lastPos = 0;
		while (name.indexOf('\'', lastPos) != - 1) {
			lastPos = name.indexOf('\'', lastPos);
			name = name.substring(0,lastPos) + '\'' + name.substring(lastPos);
			lastPos += 2; 
		}
	}	

	if (orgname != null) {
		int lastPos = 0;
		while (orgname.indexOf('\'', lastPos) != - 1) {
			lastPos = orgname.indexOf('\'', lastPos);
			orgname = orgname.substring(0,lastPos) + '\'' + orgname.substring(lastPos);
			lastPos += 2; 
		}
	}
	
	CustomerSearchDataBean dbCustomerSearch = new CustomerSearchDataBean();
	dbCustomerSearch.setCommandContext(cmdContext);
	Vector OrgIdOpt = dbCustomerSearch.findOrganizationsICanAdminister(
		"Manage",
		name,
		new Integer(
			WhereClauseSearchCondition.SEARCHTYPE_CASEINSENSITIVE_STARTSWITH).toString(),
		orgname,
		new Integer(
			WhereClauseSearchCondition.SEARCHTYPE_CASEINSENSITIVE_STARTSWITH).toString(),			
		"0",
		null);
	
	int numberOfOrgs = 0;
	if (OrgIdOpt != null) {
		numberOfOrgs = dbCustomerSearch.getResultSize().intValue();
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%= fHeader%>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css" />

<title><%= UIUtil.toHTML((String)orgEntityNLS.get("organization")) %></title>

<script type="text/javascript" language="JavaScript">
<!---- hide script from old browsers

	function getResultsSize() { 
		return <%= numberOfOrgs  %>; 
	}
    
	function findOrgEntity() {
		var url = top.getWebappPath() + "DialogView?XMLFile=buyerconsole.BuyOrgEntityFind";

		if (top.setContent) {
			top.setContent(
				"<%=UIUtil.toJavaScript((String)orgEntityNLS.get("find")) %>",
				url,
				true);
		}
		else {
			parent.location.replace(url);
		}
	}

    function newOrgEntity() {
	//Uncomment the next line to use the Wizard for creating organizations
	//var url = top.getWebappPath() + "WizardView?XMLFile=buyerconsole.BuyOrgEntityWizard";
      	
      	//Comment out the next line to use the Wizard for creating organizations
      	var url = top.getWebappPath() + "BuyCreateOrgEntityView?XMLFile=buyerconsole.BuyCreateOrgEntityDialog";

      	if (top.setContent) {
			top.setContent(
				"<%= UIUtil.toJavaScript((String)userAdminListNLS2.get("newOrgBCT")) %>",
				url,
				true);
		} else {
			parent.location.replace(url);
      	}
    }

    function changeOrgEntity() {
      	var changed = 0;
      	var orgEntityId = 0;

      	if (arguments.length > 0) {
        	orgEntityId = arguments[0];
        	changed = 1;
      	} else {
        	var checked = parent.getChecked();
        	if (checked.length > 0) {
          		orgEntityId = checked[0];
          		changed = 1;
        	}
      	}
      	
      	if (changed != 0) {
      		//Uncomment the next line to use the Notebook for updating organizations
        	//var url = top.getWebappPath() + "NotebookView?XMLFile=buyerconsole.BuyOrgEntityNotebook";
        	
        	//Comment out the next line to use the Notebook for updating organizations
        	var url = top.getWebappPath() + "BuyCreateOrgEntityView?XMLFile=buyerconsole.BuyUpdateOrgEntityDialog";

        	url += "&orgEntityId=" + orgEntityId;
        	if (top.setContent) {
          		top.setContent("<%= UIUtil.toJavaScript((String)userAdminListNLS2.get("chgOrgBCT")) %>",
                         	url,
                         	true);
        	} else {
          		parent.location.replace(url);
        	}
      	} 
    }
    
    function changeApprovalOrgEntity() {
      	var changed = 0;
      	var orgEntityId = 0;

      	if (arguments.length > 0) {
        	orgEntityId = arguments[0];
        	changed = 1;
      	} else {
        	var checked = parent.getChecked();
        	if (checked.length > 0) {
          		orgEntityId = checked[0];
          		changed = 1;
        	}
      	}
      	
      	if (changed != 0) {
        	var url = top.getWebappPath() + "DialogView?XMLFile=buyerconsole.BuyOrgEntityApprovals";
        	url += "&orgEntityId=" + orgEntityId;
        	if (top.setContent) {
          		top.setContent("<%= UIUtil.toJavaScript((String)orgEntityNLS.get("OrgEntityApproval")) %>",
                         		url,
                         		true);
        	} else {
          		parent.location.replace(url);
        	}
      	} 
    }
    
	function changeRoleOrgEntity() {
		var changed = 0;
		var orgEntityId = 0;

		if (arguments.length > 0) {
			orgEntityId = arguments[0];
			changed = 1;
		} else {
			var checked = parent.getChecked();
			if (checked.length > 0) {
        		//Org that's selected
				orgEntityId = checked[0];
				changed = 1;
			}
		}
      	
		if (changed != 0) {
      	<% for (int i=0; i < vecTopLevelDirectOrgIDs.size(); i++) {
      			String strOrgId = (String) vecTopLevelDirectOrgIDs.elementAt(i);
				if (ECTrace.traceEnabled(ECTraceIdentifiers.COMPONENT_USER)) {
					ECTrace.trace(ECTraceIdentifiers.COMPONENT_USER, CLASSNAME, null, 
						"changeRoleOrgEntity(): Org where role is played directly: " + strOrgId);
				} %>
				if (orgEntityId == "<%=strOrgId%>"
					&& '<%=isSiteAdmin%>' != 'true') {
	      			// ---
	      			// Cannot modify role of an org where user directly plays role unless it's a Site Admin.
	      			// Seller Admin can modify role of associated RC MbrGrp orgs
	      			// ---
	   				alertDialog("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("orgEntityNoAuthAddRole"))%>");
	   				return;			
				}
		<% } %>
        	
        	var url = 
        		top.getWebappPath() 
        		+ "DialogView?XMLFile=buyerconsole.BuyOrgEntityRoles";
        	url += "&memberId=" + orgEntityId;
        	
        	if (top.setContent) {
				top.setContent(
					"<%= UIUtil.toJavaScript((String)orgEntityNLS.get("OrgEntityRoles")) %>",
					url,
					true);
        	} 
        	else {
				parent.location.replace(url);
			}
		} 
	}
    
    function changeStatusOrgEntity() {
    	var changed = 0;
      	var orgEntityId = 0;

      	if (arguments.length > 0) {
        	orgEntityId = arguments[0];
        	changed = 1;
      	} else { 
        	var checked = parent.getChecked();
        	if (checked.length > 0) {
          		orgEntityId = checked[0];
          		changed = 1;
        	}
      	}
      	
      	if (changed != 0) {
      	
      		if (orgEntityId == "<%=parentOrg%>") {
      			alertDialog("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("lockParent"))%>");
      			return;
      		}
      		
      		
      		if (orgEntityId == "<%=ECMemberConstants.EC_DB_ROOT_ORGANIZATION_ID%>") {
      			alertDialog("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("lockRoot"))%>");
      			return;
      		} 
      		 
      		     			
        	var url = top.getWebappPath() + "DialogView?XMLFile=buyerconsole.BuyOrgEntityStatus";
        	url += "&orgEntityId=" + orgEntityId;
        	if (top.setContent) {
          		top.setContent("<%= UIUtil.toJavaScript((String)orgEntityNLS.get("OrgEntityStatus")) %>",
                         		url,
                         		true);
        	} else {
          		parent.location.replace(url);
        	}
      	} 
    }
    
    function changePolSubOrgEntity() {
      var changed = 0;
      var orgEntityId = 0;

      if (arguments.length > 0) {
        	orgEntityId = arguments[0];
        	changed = 1;
      } else {
        	var checked = parent.getChecked();
        	if (checked.length > 0) {
          		orgEntityId = checked[0];
          		changed = 1;
        	}
      }
      
      if (changed != 0) {
        	var url = top.getWebappPath() + "DialogView?XMLFile=buyerconsole.BuyOrgEntityPolSub";
        	url += "&orgEntityId=" + orgEntityId;
        	if (top.setContent) {
          		top.setContent("<%= UIUtil.toJavaScript((String)orgEntityNLS.get("BuyOrgEntityPolSub")) %>",
                        		url,
                         		true);
        	} else {
          		parent.location.replace(url);
        	}
      } 
}    

    
function listPart() {
      var changed = 0;
      var orgEntityId = 0;

      if (arguments.length > 0) {
        	orgEntityId = arguments[0];
        	changed = 1;
      } else {
        	var checked = parent.getChecked();
        	if (checked.length > 0) {
          		orgEntityId = checked[0];
          		changed = 1;
        	}
      }
      
      if (changed != 0) {
        	var url = top.getWebappPath() + "NewDynamicListView?ActionXMLFile=buyerconsole.BuyOrgEntityPartnerList&cmd=BuyOrgEntityPartnerListView";
        	url += "&orgEntityId=" + orgEntityId;
        	if (top.setContent) {
          		top.setContent("<%= UIUtil.toJavaScript((String)orgEntityNLS.get("OrgEntityPartnerList")) %>",
                        		url,
                         		true);
        	} else {
          		parent.location.replace(url);
        	}
      } 
}    
    
function listDist() {
      var changed = 0;
      var orgEntityId = 0;

      if (arguments.length > 0) {
        	orgEntityId = arguments[0];
        	changed = 1;
      } else {
        	var checked = parent.getChecked();
        	if (checked.length > 0) {
          		orgEntityId = checked[0];
          		changed = 1;
        	}
      }
      
      if (changed != 0) {
        	var url = top.getWebappPath() + "NewDynamicListView?ActionXMLFile=buyerconsole.BuyOrgEntityDistList&cmd=BuyOrgEntityDistListView";
        	url += "&orgEntityId=" + orgEntityId;
        	if (top.setContent) { 
          		top.setContent("<%= UIUtil.toJavaScript((String)orgEntityNLS.get("OrgEntityDistList")) %>",
                        		url,
                         		true);
        	} else {
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

<script type="text/javascript" src="<%=webalias%>javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="<%=webalias%>javascript/tools/common/dynamiclist.js"></script>

</head>

<body onload="onLoad()" class="content">
<%
		int startIndex = Integer.parseInt(request.getParameter("startindex"));
		int listSize = Integer.parseInt(request.getParameter("listsize"));          
		int endIndex = getStartIndex() + getListSize();
		if (endIndex > numberOfOrgs) {
			endIndex = numberOfOrgs;
		}
		int totalsize = numberOfOrgs;
		int totalpage = totalsize/listSize;    
		
		//out.print("onLoad trace: startIndex=" + startIndex
		//	+ ", listSize=" + listSize + ", endIndex=" + endIndex
		//	+ ", totalsize=" + totalsize + ", totalpage=" + totalpage);
	
%>
<%=com.ibm.commerce.tools.common.ui.taglibs.comm.addControlPanel("buyerconsole.BuyOrgEntityList", totalpage, totalsize, cmdContext.getLocale() )%>

<form name="orgEntityForm" action="BuyOrgEntityListView" method="POST">
<%=addHiddenVars()%>

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistTable((String)orgEntityNLS.get("OrgEntityListTitle")) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRowHeading() %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheckHeading(false,null) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)orgEntityNLS.get("orgEntityNameColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)orgEntityNLS.get("orgEntityParentColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)orgEntityNLS.get("OrgEntityStatus"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)orgEntityNLS.get("orgEntityOrgTypeColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>


<!-- Need to have a for loop to lookfor all the member groups -->
<%
    for (int i=getStartIndex(); i < endIndex; i++) {    
    
		String memberId = new String();
    	String parentName = new String();
    	Integer status = new Integer(0);
    	String OrgType = new String();
    	String state = new String();
    	Vector temp = (Vector) OrgIdOpt.elementAt(i);
    	String oId = (temp.elementAt(0)).toString();
        OrganizationAccessBean oedb = new OrganizationAccessBean();
        oedb.setInitKey_memberId(oId);
        
		memberId = oedb.getParentMemberId();
		parentName = UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralNone"));
		try {
			if (memberId != null && !(memberId.equals(""))) { 
				OrganizationAccessBean oedb2 = new OrganizationAccessBean();
	        	oedb2.setInitKey_memberId(memberId);
        		parentName = oedb2.getOrganizationName();
        	
        		status = oedb.getStatus(); 
				if (status == null || status.intValue() == 0) {
					state = UIUtil.toHTML((String)orgEntityNLS.get("unlock"));
				} else {
					state = UIUtil.toHTML((String)orgEntityNLS.get("lock"));
				}
		
				OrgType = oedb.getOrgEntityType();
				if (OrgType.equals("O")) {
					OrgType = UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralSelectOrg"));
				}
				else if (OrgType.equals("OU")){
					OrgType = UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralSelectOrgUnit"));
				}
				else if (OrgType.equals("AD")){
					OrgType = UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralSelectAuthDomain"));
				}
			} else {
				OrgType = UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralSelectOrg"));
				state = UIUtil.toHTML((String)orgEntityNLS.get("unlock"));
			
			}
        } catch (Exception e) {
        	e.printStackTrace();
        }
%>

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRow(Math.abs(i % 2) + 1) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheck(oedb.getOrganizationId(), "none" ) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(oedb.getOrganizationName()), "javascript:changeOrgEntity('"+ oedb.getOrganizationId() +"');" ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(parentName), null ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(state), null ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(OrgType), null ) %> 

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>

<%
}
%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistTable() %>

</form>
<script type="text/javascript" language="JavaScript">
<!--
	parent.afterLoads();
	parent.setResultssize(getResultsSize());
// -->
</script>
</body>
</html>
