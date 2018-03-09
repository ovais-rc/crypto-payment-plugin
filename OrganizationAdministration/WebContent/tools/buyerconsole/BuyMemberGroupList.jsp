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

<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.user.beans.OrgEntityDataBean" %>
<%@ page import="com.ibm.commerce.user.beans.MemberGroupDataBean" %>
<%@ page import="com.ibm.commerce.accesscontrol.objects.*" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.ibm.commerce.tools.segmentation.SegmentConstants" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="../common/List.jsp" %>

<% 	 
   // Get the memberGroupType parameter:
   //   - CustomerTerritoryGroup - Customer Territory Group Type (hasSpecialNotebook)
   //   - CustomerPriceGroup - Customer Price Group Type
   //	- PriceOverrideGroup - Price Override Group Type
   //	- RegisteredCustomersGroup - Registered Customers Group Type (hasSpecialList)
   //	- ServiceRepGroup - Service Representative Group Type (hasSpecialList)
   // 	- AccessGroup - Access Group Type (hasSpecialNotebook, hasSpecialList)
   String  memberGroupType =  request.getParameter("memberGroupType");
      
   //Find the member group type id for the memberGroupType
   com.ibm.commerce.user.objects.MemberGroupTypeAccessBean mgtAB =  new com.ibm.commerce.user.objects.MemberGroupTypeAccessBean();
   com.ibm.commerce.user.objects.MemberGroupTypeAccessBean mg = mgtAB.findByName(memberGroupType);
   String memberGroupTypeId = "";
   try{
   	memberGroupTypeId = mg.getMbrGrpTypeId(); 
   } catch (Exception e){
   	System.out.println("Group type does not exist");
   }	
	 
%>
  
<jsp:useBean id="memberGroupList" scope="request" class="com.ibm.commerce.user.beans.MemberGroupDataBean">
	<jsp:setProperty name="memberGroupList" property="memberGroupUsageId" value="<%= memberGroupTypeId %>" />
	<jsp:setProperty name="memberGroupList" property="multipleMemberGroupsSearch" value="true" />
</jsp:useBean>

<%
   Hashtable memberGroupListNLS = null; 
   int numberOfMemberGroups = 0;
   
   CommandContext cmdContext 	= getCommandContext();

   // obtain the resource bundle for display
   memberGroupListNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", getLocale());
   DataBeanManager.activate(memberGroupList, request);

   if (memberGroupList != null)
   {
     numberOfMemberGroups = memberGroupList.getSize();
   }

   com.ibm.commerce.user.objects.UserAccessBean uAB = new com.ibm.commerce.user.objects.UserAccessBean();
   uAB.setInitKey_memberId(getCommandContext().getUserId().toString());
              
   boolean isSiteAdmin = uAB.isSiteAdministrator();

   // get the correct member group list XML to return to if actions
   // are executed on this page.
   String returnXML = "";

   if (memberGroupType.equals("AccessGroup")) {
   	returnXML = "buyerconsole.BuyMemberGroupList_AccessGroups";
   } else if (memberGroupType.equals("ServiceRepGroup")) {
   	returnXML = "buyerconsole.BuyMemberGroupList_ServiceRepGroups";
   } else if (memberGroupType.equals("RegisteredCustomersGroup")) {
   	returnXML = "buyerconsole.BuyMemberGroupList_RegisteredCustomersGroups";
   } else {
   	returnXML = "buyerconsole.BuyMemberGroupList";
   }
   
   String changeNLSKey = "";
   changeNLSKey = "chg" + memberGroupType + "BCT";
   
   String newNLSKey = "";
   newNLSKey = "new" + memberGroupType + "BCT";
%>


<HTML>
<HEAD>
<%= fHeader%>
<LINK rel=stylesheet href="<%=UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">

<TITLE><%= UIUtil.toHTML((String)memberGroupListNLS.get("groups")) %></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
function checkAccess() {
       <% if (isSiteAdmin) { %>
              top.setContent(getUserNLSTitle(), top.getWebappPath() + 'NewDynamicListView?state=selectAccessGroups&amp;ActionXMLFile=buyerconsole.BuyMemberGroupList_AccessGroups&amp;cmd=BuyMemberGroupListView&amp;memberGroupType=AccessGroup', false);
       <% } else { %>
              alertDialog('<%= UIUtil.toJavaScript((String)memberGroupListNLS.get("memberGroupListNoAccessToAccessGroups")) %>');
       <% } %>
}

function checkRCGroupAccess() {
       <% if (isSiteAdmin) { %>
              top.setContent(getUserNLSTitle(), top.getWebappPath() + 'NewDynamicListView?state=selectRegisteredCustomersGroups&amp;ActionXMLFile=buyerconsole.BuyMemberGroupList_RegisteredCustomersGroups&amp;cmd=BuyMemberGroupListView&amp;memberGroupType=RegisteredCustomersGroup', false);
       <% } else { %>
              alertDialog('<%= UIUtil.toJavaScript((String)memberGroupListNLS.get("memberGroupListNoAccessToRCGroups")) %>');
       <% } %>
}

function getResultsSize() { 
     return <%= numberOfMemberGroups  %>; 
}


    function newMemberGroup()
    {
	
      var url = top.getWebappPath() + "WizardView?XMLFile=buyerconsole.BuyMemberGroupWizard";
      url += "&memberGroupType=<%= UIUtil.toJavaScript(memberGroupType) %>";
      if (top.setContent)
      {
        top.setContent("<%= UIUtil.toJavaScript((String)memberGroupListNLS.get(newNLSKey)) %>",
                       url,
                       true);
      }
      else
      {
        parent.location.replace(url);
      }
    }

    function changeMemberGroup()
    {
      var changed = 0;
      var memberGroupId = 0;

      if (arguments.length > 0)
      {
        memberGroupId = arguments[0];
        changed = 1;
      }
      else
      {
        var checked = parent.getChecked();
        if (checked.length > 0)
        {
          memberGroupId = checked[0];
          changed = 1;
        }
      }
      if (changed != 0)
      {
        <%  if (memberGroupType.equals("AccessGroup")) { %>
             var url = top.getWebappPath() + "NotebookView?XMLFile=buyerconsole.BuyMemberGroupNotebookAccessGroup";                
        <% } else if (memberGroupType.equals("CustomerTerritoryGroup")) { %>
             var url = top.getWebappPath() + "NotebookView?XMLFile=buyerconsole.BuyMemberGroupNotebookCustomerTerritoryGroup";
        <% } else { %>
             var url = top.getWebappPath() + "NotebookView?XMLFile=buyerconsole.BuyMemberGroupNotebook";                
        <% } %>        
        url += "&segmentId=" + memberGroupId + "&memberGroupType=<%= UIUtil.toJavaScript(memberGroupType) %>";
        if (top.setContent)
        {
          top.setContent("<%= UIUtil.toJavaScript((String)memberGroupListNLS.get(changeNLSKey)) %>",
                         url,
                         true);
        }
        else
        {
          parent.location.replace(url);
        }
      } 
    }

    function deleteMemberGroup() 
    {
      var checked = parent.getChecked();
      var candelete = new Array();
      var x =0;
      if (checked.length > 0)
      {
        // check for default member groups and set up the delete list
        var memberGroupList = "";
        var errorFound = 0;
        for (var i = 0; (i<checked.length && errorFound==0); i++)
        {
            if (x ==0) memberGroupList = "&" + "<%=SegmentConstants.PARAMETER_SEGMENT_IDS%>" + "=" + checked[i]
            else memberGroupList = memberGroupList + "," + checked[i]; 
            x++;

        }
        if ( (errorFound == 0) &&
             confirmDialog("<%=UIUtil.toJavaScript((String)memberGroupListNLS.get("memberGroupListDeleteConfirmation")) %>") ) 
        {
          // delete the member groups
          var redirectURL = "NewDynamicListView";

          var url = top.getWebappPath() + "SegmentDelete?"
                    + memberGroupList
                    + "&size=" + checked.length
                    + "&authToken=" + encodeURI("${authToken}")
	            + "&URL=" + redirectURL
	            + "&amp;ActionXMLFile=<%= UIUtil.toJavaScript(returnXML) %>&amp;cmd=BuyMemberGroupListView&amp;memberGroupType=<%= UIUtil.toJavaScript(memberGroupType) %>" ;
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
      }
    } 

    function previewMemberGroup() {
      var changed = 0;
      var memberGroupId = 0;

      if (arguments.length > 0)
      {
        memberGroupId = arguments[0];
        changed = 1;
      }
      else
      {
        var checked = parent.getChecked();
        if (checked.length > 0)
        {
          memberGroupId = checked[0];
          changed = 1;
        }
      }
      if (changed != 0)
      {
	var url = top.getWebappPath() + "DialogView?XMLFile=buyerconsole.BuyMemberGroupPreviewMembersListDialog&amp;segmentId=" + memberGroupId;
        if (top.setContent)
        {
          top.setContent("<%= UIUtil.toJavaScript((String)memberGroupListNLS.get("previewAccGroupBCT")) %>",
                         url,
                         true);
        }
        else
        {
          parent.location.replace(url);
        }
      } 
    }

    function assignCust() {
    
         var usersId = -1;
		if (arguments.length > 0) {
			usersId = arguments[0];
		}
		else {
			var checked = parent.getChecked();
			if (checked.length > 0) {
				usersId = checked[0];
			}
	}
	
	var url = top.getWebappPath() + "DialogView?XMLFile=buyerconsole.AssignCustomersDialog"
	            + "&usersId=" 
	            + usersId;
	            
	if (top.setContent) {
		top.setContent(
        	"<%=UIUtil.toJavaScript((String)memberGroupListNLS.get("userAdminAssignCustomers")) %>",
			url,
			true);
	}
	else {
		parent.location.replace(url);
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
function getShowResourcesBCT(){
  return "<%= UIUtil.toJavaScript((String)memberGroupListNLS.get("ResourcesBCT")) %>";
}

function getShowActionsBCT() {
  return "<%= UIUtil.toJavaScript((String)memberGroupListNLS.get("ActionsBCT")) %>";
}

function getShowPoliciesBCT() {
  return "<%= UIUtil.toJavaScript((String)memberGroupListNLS.get("PoliciesBCT")) %>";
}


function doShowActions() {
  checked = parent.getChecked();
//  deSelectAll();

top.setContent(getShowActionsBCT(),
       top.getWebappPath() + 'NewDynamicListView?ActionXMLFile=policyeditor.ActionsForMemberGroupView&amp;cmd=ActionsForMemberGroupView&amp;memberGroupId=' + checked, true)
}
function doShowResources() {
  checked = parent.getChecked();
//  deSelectAll();

top.setContent(getShowResourcesBCT(),
       top.getWebappPath() + 'NewDynamicListView?ActionXMLFile=policyeditor.ResourcesForMemberGroupView&amp;cmd=ResourcesForMemberGroupView&amp;memberGroupId=' + checked, true)
}

function doShowPolicies() {
  checked = parent.getChecked();
//  deSelectAll();

top.setContent(getShowPoliciesBCT(),
       top.getWebappPath() + 'NewDynamicListView?ActionXMLFile=policyeditor.PoliciesForMemberGroupView&amp;cmd=PoliciesForMemberGroupView&amp;memberGroupId=' + checked, true)
}

//function to overwrite the scroll control 
function getUserNLSTitle() {
       return "<%= UIUtil.toHTML((String)memberGroupListNLS.get("groups")) %>"
}

// -->
</script>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

</HEAD>
<BODY ONLOAD="onLoad()" class="content">
<%
          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));          
	  int endIndex = getStartIndex() + getListSize();
    	  if (endIndex > numberOfMemberGroups)
      		endIndex = numberOfMemberGroups;
          int totalsize = numberOfMemberGroups;
          int totalpage = totalsize/listSize;          
	
%>
<%=com.ibm.commerce.tools.common.ui.taglibs.comm.addControlPanel("adminconsole.MemberGroupList", totalpage, totalsize, cmdContext.getLocale() )%>

<FORM NAME="memberGroupForm" ACTION="AdminConMemberGroupView" METHOD="POST">

<%=addHiddenVars()%>

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistTable((String)memberGroupListNLS.get("AdminConsoleTableSumMemberGroupList")) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRowHeading() %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheckHeading() %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)memberGroupListNLS.get("memberGroupListNameColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)memberGroupListNLS.get("memberGroupListOwnerColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)memberGroupListNLS.get("memberGroupListDescriptionColumn"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>



<!-- Need to have a for loop to lookfor all the member groups -->
<%
    int rowselect=1;
    for (int i=startIndex; i<endIndex ; i++) 
    {
      String desc_str = memberGroupList.getDescription(i);
      String id = memberGroupList.getMemberGroupId(i);
      
      if (desc_str == null)
        desc_str = "";
        
      String orgname = null;
      OrgEntityDataBean oedb = new OrgEntityDataBean();
      oedb.setDataBeanKeyMemberId(memberGroupList.getOwnerId(i));
      DataBeanManager.activate(oedb, request);
             
      orgname = oedb.getOrgEntityName();
      if (orgname == null)
        orgname = "";
      
%>
<A href="javascript:changeMemberGroup('<%=memberGroupList.getMemberGroupId(i)%>')">

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRow(rowselect) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheck(id, "none" ) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(memberGroupList.getName(i)), "javascript:changeMemberGroup('"+ id +"');" ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(orgname), "none" ) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(desc_str), "none" ) %> 
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
<SCRIPT>
<!--
  
<%

String mbrGrpsNotDeleted = (String) request.getParameter(SegmentConstants.PARAMETER_SEGMENTS_NOT_DELETED);

if (!(mbrGrpsNotDeleted == null || mbrGrpsNotDeleted.equals("[]"))) {
    
%>
        alertDialog('<%=UIUtil.toHTML((String)memberGroupListNLS.get("memberGroupListInUse"))%>'.replace(/%1/, '<%=UIUtil.toJavaScript(mbrGrpsNotDeleted)%>'));
        parent.removeListParameter("<%= SegmentConstants.PARAMETER_SEGMENTS_NOT_DELETED %>");         
<%
}

%>
//-->
</SCRIPT>
</BODY>
</HTML>
