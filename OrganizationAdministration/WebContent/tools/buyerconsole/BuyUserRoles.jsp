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
<%@ page import="com.ibm.commerce.usermanagement.commands.MemberRoleUpdateCmd" %>
<%@ page import="com.ibm.commerce.user.beans.RoleAssignmentPermissionDataBean" %>

<%@ include file="../common/common.jsp" %>

<%
       // Command context and request properties
       CommandContext cmdContext = 
              (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
       Locale locale = cmdContext.getLocale();
       String webalias = UIUtil.getWebPrefix(request);

       // Resource bundles
       Hashtable userWizardNLS = 
              (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup(
                     "buyerconsole.BuyAdminConsoleNLS", locale);
       Hashtable userWizardNLS2 = 
              (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup(
                     "adminconsole.AdminConsoleNLS", locale);

       String userId = request.getParameter("memberId");
       String adminId = (cmdContext.getUserId()).toString();

       // The user's current roles, for which the admin has rights to unassign; 
       // contains vectors with 0 in role, 1 in org
       Vector userRoles = new Vector();
       
       // The user's current roles, for which the admin has no rights to unassigned
       // contains vectors with 0 in role, 1 in org
       Vector userHiddenRoles = new Vector();

		if (!(userId == null || userId.equals(""))) {

			// Cache the role permissions when request is made -- so that we only have to fetch 
			// once per unique org where user plays a role
			HashMap mapRolesAdminCanUnassign = new HashMap();

			Enumeration enum1 = new MemberRoleDataBean().findByMemberId(new Long(userId));
			while (enum1.hasMoreElements()) {

				Vector temp = new Vector();
				MemberRoleAccessBean mrab = (MemberRoleAccessBean) enum1.nextElement();
				temp.addElement(mrab.getRoleId());
				temp.addElement(mrab.getOrgEntityId());

				// Check if user is allowed to unassign the role
				boolean bAdminCanUnassignRole = false;

				if (cmdContext.getUser().isSiteAdministrator()) {
					// Site admin can assign all roles
					bAdminCanUnassignRole = true;
				}
				else {
					// Get the list of roles that the user is allowed to unassign from this org
					if (!mapRolesAdminCanUnassign.containsKey(mrab.getOrgEntityId())) {
						mapRolesAdminCanUnassign.put(
							mrab.getOrgEntityId(),
							RoleAssignmentPermissionDataBean.getRolesThatUserCanAssignInOrg(
								adminId,
								mrab.getOrgEntityId().toString()));
					}
					
					Integer[] nRolesUserCanAssign = 
						(Integer[])mapRolesAdminCanUnassign.get(mrab.getOrgEntityId());
					
					for (int i=0; i<nRolesUserCanAssign.length; i++) {
						if (new Integer(mrab.getRoleId()).equals(nRolesUserCanAssign[i])) {
							// admin has permission to unassign this role
							bAdminCanUnassignRole = true;
						}
					}
				}

				if (bAdminCanUnassignRole) {
					// Admin has permission; add this role to the displayed list
					userRoles.addElement(temp);
				} else {
					// Admin does not have permission; add this role to the hidden list
					userHiddenRoles.addElement(temp);                 
				}      
            }
       }
       
  
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />

       <%=fHeader%>
       <link rel="stylesheet" href="<%= UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css" />
       <style type='text/css'>
              .selectWidth {width: 720px;}
       </style>

       <title><%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralRoles"))%></title>

       <script type="text/javascript" language="JavaScript1.2" src="<%=webalias%>javascript/tools/common/SwapList.js"></script>
       <script type="text/javascript" src="<%=webalias%>javascript/tools/common/Util.js"></script>

       <!-------------------------------------------->
       <!-- Define the CSS for the LUS's GUI parts -->
       <!-------------------------------------------->
       <style type='text/css'>
              .LUS_CSS_QuickTextEntryWidth {width: 600px;}
              .LUS_CSS_ResultListBoxWidth  {width: 600px;}
              .LUS_CSS_KeywordEntryWidth   {width: 200px;}
              .LUS_CSS_CriteriaListWidth   {width: auto; }
       </style>

       <!-------------------------------------------->
       <!-- Import the LUS Widget Model javascript -->
       <!-------------------------------------------->
       <script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/common/LUSWidgetModel.js"></script>

       <script type="text/javascript">
              
              var allgrpList = null;
              var originalList = null;
              var assignedList = null;
              var deletedList = null;
              var addedList = null;
	  
              ////////////////////////////////////////////////
              // Load data from state of info for this page
              // add them to the GUI
              ///////////////////////////////////////////////
              function initializeState() {

                     var nameNotExists = parent.get("nameNotExists", null);
                     if (nameNotExists != null) {
                            document.f1.userDN.value = 
                                   parent.get("<%=MemberRoleUpdateCmd.REQUEST_PARAM_DISTINGUISHEDNAME%>");
                            alertDialog("<%=UIUtil.toJavaScript((String)userWizardNLS.get("userDoesNotExists")) %>");
                     }
                     
                     var RoleArray = new Array();
                     var UserRoleArray = new Array();

                     var x = parent.get("newRole");
                     if (x == null) {

                            <%
                            for(int i=0; i < userRoles.size(); i++) {

                                   Vector tmp = (Vector) userRoles.elementAt(i);
                                   String rId = (String) tmp.elementAt(0);
                                   String oId = (String) tmp.elementAt(1);
                                   RoleDataBean rdb2 = new RoleDataBean();
                                   rdb2.setDataBeanKeyRoleId(rId);
                                   com.ibm.commerce.beans.DataBeanManager.activate(rdb2, request);

                                   String roleNm = rdb2.getDisplayName();
                                   String orgNm = "";

                                   OrganizationDataBean oedbtemp = new OrganizationDataBean();
                                   oedbtemp.setDataBeanKeyMemberId(oId);
                                   oedbtemp.populate();
                                   //RM: orgNm = oedbtemp.getOrganizationName();
                                   orgNm = oedbtemp.getOrganizationDisplayName();
                            %>
                            
                                   var displayName = '<%=UIUtil.toJavaScript(roleNm)%>' + ' - ' + '<%=UIUtil.toJavaScript(orgNm)%>';
                                   document.f1.definedRoles.options[<%=i%>] = new Option(displayName, displayName, false, false);
                                   document.f1.definedRoles.options[<%=i%>].selected=false;
                                   document.f1.definedRoles.options[<%=i%>].value='<%=rId%>' + ',' + '<%=oId%>';
                                   var newRole = "<%=i%>";
                                   parent.put("tempRoleId"+newRole,'<%=rId%>');
                                   parent.put("tempRoleName"+newRole,'<%=UIUtil.toJavaScript(roleNm)%>');
                                   parent.put("tempOrgId"+newRole,'<%=oId%>');
                                   parent.put("tempOrgName"+newRole,'<%=UIUtil.toJavaScript(orgNm)%>');
                                   parent.put("newRole", newRole);
                            <%} %>
                     } else {

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

                     if (parent.setContentFrameLoaded) {
                            parent.setContentFrameLoaded(true);
                     }
              }

              ////////////////////////////////////////////////////////////////
              // Add Role
              ////////////////////////////////////////////////////////////////
              function addRole() {
                     
                     var RoleArray = new Array();
                     var OrgArray = new Array();

                     <%
                     if (!(userId == null || userId.equals(""))) {
                     %>

                            var roleSelIndex = document.f1.DynaRolesDropDown.selectedIndex;
                            var rId = document.f1.DynaRolesDropDown[roleSelIndex].value;
                            
                            if (rId == 'noroles') {
                                   alertDialog ("<%=UIUtil.toJavaScript((String)userWizardNLS.get("noRolesAvailableMsg")) %>");
                                   return;
                            }

                            var roleName = document.f1.DynaRolesDropDown[roleSelIndex].innerText;;
                            var oId = lusWidget.LUS_getSelectedResults();
                            var orgName = lusWidget.LUS_getSelectedResultNames();

                            var newAdd = rId + ',' + oId;
                            
                            for (var kk=0; kk<document.f1.definedRoles.length; kk++) {
                                   if (newAdd == document.f1.definedRoles.options[kk].value) {
                                   		return; 
                                   }
                            }

                            var newRole = parent.get("newRole");
                            if (newRole == null) {
                                   newRole = 0;
                            }
                            else {
                                   newRole = eval(newRole) + 1;
                            }

                            parent.put("tempRoleId"+newRole,rId);
                            parent.put("tempRoleName"+newRole,roleName);
                            parent.put("tempOrgId"+newRole,oId);
                            parent.put("tempOrgName"+newRole,orgName);
                            parent.put("newRole", newRole);

                            var displayName = roleName + ' - ' + orgName;

                            newIndex = document.f1.definedRoles.length;
                            document.f1.definedRoles.options[newIndex] = new Option(displayName, displayName, false, false);
                            document.f1.definedRoles.options[newIndex].selected=false;
                            document.f1.definedRoles.options[newIndex].value=rId + ',' + oId;
                     <%}%>
              }

              ////////////////////////////////////////////////////////////////
              // Remove Role
              ////////////////////////////////////////////////////////////////
              function removeRole() {

                     var selectionMade = false;

                     for (var i = document.f1.definedRoles.length-1; i >= 0; i--) {
                            if (document.f1.definedRoles[i].selected == true) {
                                   var newRole = parent.get("newRole");
                                   for (var j=0; j <= newRole; j++) {
                                          var tmpRoleId = parent.get("tempRoleId" + j);
                                          var tmpOrgId = parent.get("tempOrgId" + j);
                                          var x = tmpRoleId + ',' + tmpOrgId;
                                          
                                          if (tmpRoleId == null) continue;

                                          if (x == document.f1.definedRoles.options[i].value) {
                                                 parent.put("tempRoleId"+ j,null);
                                          }
                                   }

                                   if ('<%=UIUtil.toJavaScript(userId)%>' == '<%=cmdContext.getUserId().toString()%>'){
                                          alertDialog ("<%=UIUtil.toJavaScript((String)userWizardNLS2.get("siteAdminUnassign")) %>");
                                   }
                                   document.f1.definedRoles.options[i] = null;
                                   selectionMade = true;
                            }
                     }

                     <%-- If nothing was selected, prompt the user to select something. --%>
                     if (!selectionMade) {
                            alertDialog ("<%=UIUtil.toJavaScript((String)userWizardNLS2.get("noRoleSelected")) %>");
                            return;
                     }

                     document.f1.removeButton.disabled = true;
              }

              ////////////////////////////////////////////////////////////////
              // Save Panel Data
			  ////////////////////////////////////////////////////////////////
			  function savePanelData() {
				    parent.addURLParameter("authToken", "${authToken}");
                    <% if (userId != null && userId.length() > 0) { %>

						// Store the roleIds that the user cannot change
						<%
						for (int i=0; i<userHiddenRoles.size(); i++) {
							String strRoleId = ((Vector)userHiddenRoles.get(i)).get(0).toString();
							String strOrgId = ((Vector)userHiddenRoles.get(i)).get(1).toString();
						%>
							parent.put("<%=MemberRoleUpdateCmd.REQUEST_PARAM_ROLEID + (i+1)%>", "<%=strRoleId%>");
							parent.put("<%=MemberRoleUpdateCmd.REQUEST_PARAM_ORGENTITYID + (i+1)%>", "<%=strOrgId%>");
						<% } %>

						// Store the roleIds that the user has changed
						var roleCounter = <%=userHiddenRoles.size() + 1%>;
						for (var i=0; i < document.f1.definedRoles.options.length; i++) {
							var x = document.f1.definedRoles.options[i].value;
							var index = x.indexOf(',');
							var rolId = x.substring(0,index)
							var orgId = x.substring(index + 1, x.length);
	
							parent.put("<%=MemberRoleUpdateCmd.REQUEST_PARAM_ROLEID%>"+roleCounter, rolId);
							parent.put("<%=MemberRoleUpdateCmd.REQUEST_PARAM_ORGENTITYID%>"+roleCounter,orgId);
							roleCounter = roleCounter + 1;
						}

					<%} else {%>
              
						// Assigning role to a user by DN
						var roleSelIndex = document.f1.DynaRolesDropDown.selectedIndex;
						var rId = document.f1.DynaRolesDropDown[roleSelIndex].value;
       
						if (rId != 'noroles') {
							parent.put("<%=MemberRoleUpdateCmd.REQUEST_PARAM_ROLEID%>", rId);

						} else if (parent.get("<%=MemberRoleUpdateCmd.REQUEST_PARAM_ROLEID%>") != null ) {
							parent.remove("<%=MemberRoleUpdateCmd.REQUEST_PARAM_ROLEID%>");
						}

						var oId = lusWidget.LUS_getSelectedResults();
       
						if (oId != "") {
							parent.put("<%=MemberRoleUpdateCmd.REQUEST_PARAM_ORGENTITYID%>", oId);
						}
						else if (parent.get("<%=MemberRoleUpdateCmd.REQUEST_PARAM_ORGENTITYID%>") != null) {
							parent.remove("<%=MemberRoleUpdateCmd.REQUEST_PARAM_ORGENTITYID%>");
						}
       
						// Put UserDN even if blank, since error handling is done by command
						parent.put(
							"<%=MemberRoleUpdateCmd.REQUEST_PARAM_DISTINGUISHEDNAME%>", 
							document.f1.userDN.value);
       
						// Put whether the role assigned by DN should be assigned or unassigned
						if (document.f1.unassignRole[1] 
							&& document.f1.unassignRole[1].checked) {
                     
							// This role should be unassigned
							parent.put(
								"<%=MemberRoleUpdateCmd.REQUEST_PARAM_UNASSIGNROLE%>",
								"true");
						}
       
					<% } %>

					parent.put("redirecturl","DialogNavigation");
					return true;
			  }


              function saveData() {
              }


              ////////////////////////////////////////////////////////////////
              // Validate Panel Data
              ////////////////////////////////////////////////////////////////
              function validatePanelData() {
              
                     // Page validation only required for assign role by DN
                     // If DN field is defined, then we know that we are assigning the role by DN
                     if (document.f1.userDN) {

                            // Ensure that organization field is filled in
                            if (lusWidget.LUS_getSelectedResults() == null
                                   || lusWidget.LUS_getSelectedResults() == "") {
                                   alertDialog('<%=UIUtil.toJavaScript((String)userWizardNLS.get("errorMissingOrgId"))%>');
                                   return false;                                          
                            }                            
                            
                            // Ensure that DN field is filled in
                            if (document.f1.userDN.value == null
                                   || document.f1.userDN.value == '') {
                                   alertDialog('<%=UIUtil.toJavaScript((String)userWizardNLS.get("errorMissingUserDN"))%>');
                                   return false;
                            }
                     }
                     else {
                            return true;
                     }
              }


              ////////////////////////////////////////////////////////////////
              // Enable remove
              ////////////////////////////////////////////////////////////////
              function enableRemove() {
                     
                     var x = document.f1.definedRoles.selectedIndex;
                     if (x < 0) {
                            document.f1.removeButton.disabled = true;
                     } else {
                            document.f1.removeButton.disabled = false;
                     }
              }

       </script>


       <!-- ******************************************************************** -->
       <!-- *  START HERE --- Javascript Functions for Wiring the LUS Widget   * -->
       <!-- ******************************************************************** -->
       <script type="text/javascript">

              /////////////////////////////////////////////////////////////////////////////
              // Function: LUS_Setup
              // Desc.   : Register the GUI parts to the LUS Widget object instance
              /////////////////////////////////////////////////////////////////////////////
              function LUS_Setup() {
                     
                     lusWidget = new LUS_LookUpSelectionWidget
                   ('f1',
                 'LUS_SearchTextField',
                 'LUS_CriteriaDropDown',
                 'LUS_QuickTextEntry',
                 'LUS_SearchResultListBox',
                 'LUS_NumOfCurrentlyShowing',
                 '<%=UIUtil.toJavaScript((String)userWizardNLS.get("LUS_Label_statusLine")) %> ');
                     
                     LUS_DataFrameInitialization();
              }


              /////////////////////////////////////////////////////////////////////////////
              // Function: LUS_DataFrameInitialization
              // Desc.   : Initialize the data frame for performing search action
              /////////////////////////////////////////////////////////////////////////////
              function LUS_DataFrameInitialization() {

                     var searchType   = 0;  // default to search all
                     var searchString = ""; // default to wildcard search

                     // Building the search parameter as a query string
                     var queryString = "taskName=AssignRoleToUser&searchType="    + searchType
                            + "&searchString=" + searchString
                            + "&maxThreshold=" + "<%= (String)userWizardNLS.get("LUS_MaxNumOfResultForOrgsSearch") %>"

                     // Construct the IFRAME as the data frame for getting the search result
                     var webAppPath = "<%= UIUtil.getWebappPath(request) %>";
                     var dataFrame = "<iframe name='OABuyUserRoles_dataFrame' "
                            + "id='OABuyUserRoles_dataFrame' "
                            + "width='0' height='0' "
                            + "src='" + webAppPath + "OASearchForOrgsICanAdminView?"
                            + queryString
                            + "' title='<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralRoles"))%>'></iframe>";

                     // Execute the data fream to perform the search
                     document.write(dataFrame);
              }


              /////////////////////////////////////////////////////////////////////////////
              // Function: LUS_ProcessDataFrameSearchResults
              // Desc.   : Process the search results from the data frame. This is a
              //           call-back method invoking from the data frame after the frame
              //           is loaded
              /////////////////////////////////////////////////////////////////////////////
              var LUS_isDataFrameInitialized=false;

              function LUS_ProcessDataFrameSearchResults() { 
                     
                     top.showProgressIndicator(false);
                     var resultCondition = OABuyUserRoles_dataFrame.getSearchResultCondition();

                     // Possible search result conditions:
                     //    '0' - no match found
                     //    '1' - match found within max. threshold
                     //    '2' - match found exceeding max. threshold

                     //-------------------------------------------------
                     // Handle the first time of this page being loaded
                     //-------------------------------------------------
                     if (LUS_isDataFrameInitialized==false) {
                     
                            // Toggle ON to skip this block for all subsequent calls
                            LUS_isDataFrameInitialized=true;

                            if (resultCondition=='1') {

                                   // Re-wiring the data frame's result to LUS widget
                                   // and display the results in the resulting list box
                                   // and update the currently showing status line.
                                   lusWidget.LUS_setResultingList(
                                          OABuyUserRoles_dataFrame.getOrgNameList(),
                                          OABuyUserRoles_dataFrame.getOrgIdList());
                     
                                   lusWidget.LUS_refreshCurrentlyShown();
                            }
                           else if (resultCondition=='2') {
                                   // Too many entries, show msg in widget to let user type account name to search
                                   lusWidget.LUS_setSearchKeyword('<%=UIUtil.toJavaScript((String)userWizardNLS.get("LUS_Label_keywordDefaultText")) %> ', true);
                                   lusWidget.LUS_refreshCurrentlyShown();
                            } 
                            else if (resultCondition=='0') {
                                   // No entries avaliable in system, disable the widget
                                   lusWidget.LUS_disableAll();
                            }

                            return;
                     }

                     //----------------------------------------------------------
                     // Process the search resulting data for various conditions
                     //----------------------------------------------------------
                     var msg = "";
                     if (resultCondition=='0') {
                            // No entries avaliable in system, disable the widget
                            msg = "<%= UIUtil.toJavaScript((String)userWizardNLS.get("LUS_Msg_NotFound")) %>";
                            alertDialog(msg);
                            return;
                     }
                     else if (resultCondition=='2') {
                            // Too many entries
                            msg = "<%= UIUtil.toJavaScript((String)userWizardNLS.get("LUS_Msg_TooManyFound")) %>";
                            var thresholdValue = new Number('<%= (String)userWizardNLS.get("LUS_MaxNumOfResultForOrgsSearch") %>');

                            if (isNaN(thresholdValue)) {
                                   msg = msg.replace(/%1/, '100'); //default to 100 if invalid value
                            }
                            else {
                                   msg = msg.replace(/%1/, thresholdValue.toString());
                            }

                            alertDialog(msg);
                            return;
                     }
                     else if (resultCondition=='1') {
                            // Re-wiring the data frame's result to LUS widget
                            // and display the results in the resulting list box
                            // and update the currently showing status line.

                            lusWidget.LUS_setResultingList(
                                   OABuyUserRoles_dataFrame.getOrgNameList(),
                                   OABuyUserRoles_dataFrame.getOrgIdList());
                            lusWidget.LUS_refreshCurrentlyShown();
                     }

              }


              /////////////////////////////////////////////////////////////////////////////
              // Function: LUS_FindAction
              // Desc.   : This triggers the search action in the data frame
              /////////////////////////////////////////////////////////////////////////////
              function LUS_FindAction() {
                     
                     lusWidget.LUS_clearComboBox();
                     lusWidget.LUS_refreshCurrentlyShown();

                     // Need to disable the Add button for preventing user to adding invalid
                     // role value reside in the role list from the previous selected organization.
                     // This add button will be enabled back when user selects an organization
                     // from the list
   
                     if (document.f1 && document.f1.addButton) {
                            document.f1.addButton.disabled = true;
                     }

                     var searchType   = lusWidget.LUS_getSelectedCriteria();
                     var searchString = lusWidget.LUS_getSearchKeyword();

                     // Building the search parameter as a query string
                     var queryString = "taskName=AssignRoleToUser&searchType="    + searchType
                            + "&searchString=" + searchString
                            + "&maxThreshold=" + "<%= (String)userWizardNLS.get("LUS_MaxNumOfResultForOrgsSearch") %>";

                     var webAppPath = "<%= UIUtil.getWebappPath(request) %>";
                     var newURL     = webAppPath + 'OASearchForOrgsICanAdminView?' + queryString;

                     top.showProgressIndicator(true);
                     OABuyUserRoles_dataFrame.location.replace(newURL);

              }


              /////////////////////////////////////////////////////////////////////////////
              // Function: LUS_SelectResultItem
              // Desc.   : Rewire the user selected item from the resuling list box to
              //           trigger an action to retrieve a list of roles
              /////////////////////////////////////////////////////////////////////////////
              function LUS_SelectResultItem() {
                     var text = lusWidget.LUS_getSelectedResultNames();
                     document.f1.LUS_QuickTextEntry.value = text[0];
                     
                     // Need to enable the Add button to allow user to add a role.
                     if (document.f1 && document.f1.addButton) {
                            document.f1.addButton.disabled = false;
                     }
       
                     var selectedItem = lusWidget.LUS_getSelectedResults();
                     var webAppPath = "<%= UIUtil.getWebappPath(request) %>";
                     var newURL = webAppPath + 'OAGetRolesForOrgView?oid=' + selectedItem;
                     top.showProgressIndicator(true);
                     OABuyUserRoles_RolesHelper_dataFrame.location.replace(newURL);
              }

       </script>

       <!-- ******************************************************************** -->
       <!-- *   END HERE --- Javascript Functions for Wiring the LUS Widget    * -->
       <!-- ******************************************************************** -->


<!-- *********************************************************************** -->
<!-- *  START HERE --- Javascript Functions for Wiring the Role DropDown   * -->
<!-- *********************************************************************** -->
<script type="text/javascript">
/////////////////////////////////////////////////////////////////////////////
// Function: RolesHelper_Setup
// Desc.   : Initialize the data frame for performing roles search action
/////////////////////////////////////////////////////////////////////////////
function RolesHelper_Setup()
{
   // Construct the IFRAME as the data frame for getting the search result
   var webAppPath = "<%= UIUtil.getWebappPath(request) %>";
   var dataFrame = "<iframe name='OABuyUserRoles_RolesHelper_dataFrame' "
                         + "id='OABuyUserRoles_RolesHelper_dataFrame' "
                         //+ "onload='RolesHelper_ProcessDataFrameSearchResults()' "
                         + "width='0' height='0' "
                         + "src='" + webAppPath + "OAGetRolesForOrgView"
                         + "' title='<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralRoles"))%>'></iframe>";

   // Execute the data fream to perform the roles search
   document.write(dataFrame);
   //alert(dataFrame);

}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: RolesHelper_ProcessDataFrameSearchResults
// Desc.   : Process the roles search results from the data frame. This is a
//           call-back method invoking from the data frame after the frame
//           is loaded
/////////////////////////////////////////////////////////////////////////////
function RolesHelper_ProcessDataFrameSearchResults()
{
   top.showProgressIndicator(false);
   var names = OABuyUserRoles_RolesHelper_dataFrame.getRoleNameList();
   var ids   = OABuyUserRoles_RolesHelper_dataFrame.getRoleIdList();

   // Clear up
   while (document.f1.DynaRolesDropDown.length > 0 )
   {
      // Delete all item entries in the test list box
      document.f1.DynaRolesDropDown.options[0] = null;
   }

   if (ids.length==0)
   {
      var tmpOption = new Option('<%=UIUtil.toJavaScript((String)userWizardNLS2.get("noRolesAvailable"))%>',
                                 'noroles');
      document.f1.DynaRolesDropDown.options[0] = tmpOption;
   }
   else
   {
      for (var i=0; i<ids.length; i++)
      {
         var tmpOption = new Option(names[i], ids[i]);
         document.f1.DynaRolesDropDown.options[i] = tmpOption;
      }
   }

}//end-function

</script>
<!-- *********************************************************************** -->
<!-- *    END HERE --- Javascript Functions for Wiring the Role DropDown   * -->
<!-- *********************************************************************** -->

</head>
<body onload="initializeState();" class="content">

<h1><%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralRoles"))%></h1>
<% if (!(userId == null || userId.equals(""))) { %>
<%= (String)userWizardNLS.get("addRoleText") %><br /><br />
<% } else { %>
<%=UIUtil.toHTML((String)userWizardNLS.get("addRoleTextDN"))%><br /><br />
<% } %>
   <form action='' name='f1'>

<!-- /*d66903:add-begin*/ -->
<!-- ******************************************************************** -->
<!-- *****        LUS Widget GUI Component Scope START HERE         ***** -->
<!-- ******************************************************************** -->

<table>
   <tbody>

      <tr>
         <!---------------------------------------------------------------->
         <!-- Status line showing currently items in the result list box -->
         <!---------------------------------------------------------------->
         <td id="LUS_NumOfCurrentlyShowing" colspan="2"><%= userWizardNLS.get("LUS_Label_statusLine") %> 0</td>
      </tr>

      <tr> <!-- Building GUI Body Parts BEGIN ------------------------------>


         <!----------------------------------------------------------->
         <!-- Quick search text entry field with resulting list box -->
         <!----------------------------------------------------------->
         <td valign="top" id="LUS_TableCell_SelectAccount"><label for="LUS_FormInput_QuickTextEntry"><%= userWizardNLS.get("LUS_Label_selectOrg") %></label><br />
            <table border="0">
               <tbody>
                  <tr>
                     <td id="LUS_TableCell_QuickNavigation">
                        
                        <input
                               name="LUS_QuickTextEntry"
                                                 type="text"
                                                 size="20"
                                                 class="LUS_CSS_QuickTextEntryWidth"
                                                 onkeyup="javascript:lusWidget.LUS_autoNavigate();"
                                                 id="LUS_FormInput_QuickTextEntry"/>
                                          <br />
                                          
						<label for="LUS_SearchResultListBox1" class="hidden-label"><%= userWizardNLS.get("SelectSearchResult") %></label>                                          

                        <select 
                               name="LUS_SearchResultListBox" size="4"
                                                 onchange="javascript:LUS_SelectResultItem();"
                                                 class="LUS_CSS_ResultListBoxWidth"
                                                 id="LUS_SearchResultListBox1">
                        </select>
                        <br />
                     </td>
                  </tr>
                  <tr>
                     <td id="LUS_TableCell_Null"></td>
                  </tr>
               </tbody>
            </table>
         </td>

         <!--------------------------------------------------------------->
         <!-- Keyword field, criteria drop down, & search action button -->
         <!--------------------------------------------------------------->
         <td valign="top" id="LUS_TableCell_SearchAccount"><label for="LUS_SearchTextField1"><%= userWizardNLS.get("LUS_Label_searchOrg") %></label><br />
            <table border="0">
               <tbody>
                  <tr>
                     <td id="LUS_TableCell_KeywordSearch">
                        <input  name="LUS_SearchTextField"
                                type="text"
                                size="20"
                                class="LUS_CSS_KeywordEntryWidth"
                                id="LUS_SearchTextField1" /><br />
                        <label for="LUS_CriteriaDropDown1" class="hidden-label"><%= userWizardNLS.get("SearchOptions") %></label>        
                        <select name="LUS_CriteriaDropDown"
                                class="LUS_CSS_CriteriaListWidth"
                                id="LUS_CriteriaDropDown1">
                           <option value="1"><%= userWizardNLS.get("LUS_SearchType1") %></option>
                           <option value="2"><%= userWizardNLS.get("LUS_SearchType2") %></option>
                           <option value="3"><%= userWizardNLS.get("LUS_SearchType3") %></option>
                           <option value="4"><%= userWizardNLS.get("LUS_SearchType4") %></option>
                           <option value="5"><%= userWizardNLS.get("LUS_SearchType5") %></option>
                        </select><br /><br />
                     </td>
                  </tr>
                  <tr>
                     <td align="right" id="LUS_FormInput_FindAction">
                        <button name="LUS_ActionButton" class="general" onclick="javascript:LUS_FindAction();"><%= userWizardNLS.get("LUS_Label_findButton") %></button><br />
                     </td>
                  </tr>
               </tbody>
            </table>
         </td>
      </tr> <!-- Building GUI Body Parts End ------------------------------->

   </tbody>
</table>

<!-- ******************************************************************** -->
<!-- *****        LUS Widget GUI Component Scope END HERE           ***** -->
<!-- ******************************************************************** -->
<!-- /*d66903:add-end*/ -->

<!-- ******************************************** -->
<!-- **** New Dynamic Roles List Dropdown GUI *** -->
<!-- ******************************************** -->
       <table>
       <tbody>
              <tr>
              <td>
                     <label for="DynaRolesDropDown1"><%=UIUtil.toHTML((String)userWizardNLS2.get("memberGroupRole"))%></label>
                     <br />
            
            <select 
                   name="DynaRolesDropDown" 
                   id="DynaRolesDropDown1">
            
                   <option value="noroles">
                          <%=UIUtil.toHTML((String)userWizardNLS2.get("noRolesAvailable"))%>
                   </option>
                     </select>
              </td>
              </tr>
       </tbody>
       </table>

       <table summary="<%=UIUtil.toHTML((String)userWizardNLS.get("userAdminFindOrg"))%>">
       <tr><td valign="top">
       <table>

<% if (!(userId == null || userId.equals(""))) { %>

       </table>
       </td>
       <td width="20" valign="middle">
       <button 
              name="addButton" 
              class="general" 
              onclick="addRole()">
              <%=UIUtil.toHTML((String)userWizardNLS2.get("addRole"))%>
       </button>
       </td>
       </tr>

       <tr>
       <td>
       <br /><br />
       </td>
       </tr>
       
       <tr>
       <td>
              <label for='definedRoles1'><%=UIUtil.toHTML((String)userWizardNLS2.get("userGeneralAssignedRoles"))%></label>
              <br />
              
              <select 
                     name='definedRoles' 
                     size='10'
                     multiple='multiple'
                     class='selectWidth'
                     onchange='enableRemove()'
                     id='definedRoles1'></select>
       </td>
       <td width='20' valign='top'>
              <button 
                     name='removeButton'
                     class='general' 
                     onclick='removeRole()'
                     disabled="disabled">
                     <%=UIUtil.toHTML((String)userWizardNLS2.get("removeRole"))%>
              </button>
       </td>
       </tr>
       
<%} else { %>

       <tr>
       <td>
              <br />
              <label for='unassignRole0' class='hidden-label'>
                     <%=UIUtil.toHTML((String)userWizardNLS.get("assignRole"))%>
              </label>       
              <input 
                     type='radio'
                     name='unassignRole' 
                     id='unassignRole0'
                     checked='checked'/>
                     <%=UIUtil.toHTML((String)userWizardNLS.get("assignRole"))%>
              <br />
              <label for='unassignRole1' class='hidden-label' >
                     <%=UIUtil.toHTML((String)userWizardNLS.get("unassignRole"))%>
              </label>                     
              <input 
                     type='radio'
                     name='unassignRole' 
                     id='unassignRole1'/>
                     <%=UIUtil.toHTML((String)userWizardNLS.get("unassignRole"))%>
       </td>
       </tr>
       <tr>
       <td>
              <label for="userDN1">
                     <%=UIUtil.toHTML((String)userWizardNLS.get("userDN"))%>
              </label>
              <br />
              <input 
                     type='text'
                     size='32'
                     name='userDN'
                     id='userDN1' />
       </td>
       </tr>

<% } %>

       </table>
</form>

<!-- Initialize the LUS Widget & Roles List Data Frame -->
<script type="text/javascript">
   LUS_Setup();
   RolesHelper_Setup();
</script>

</body>
</html>
