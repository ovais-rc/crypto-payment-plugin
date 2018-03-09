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

<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.RoleAssignmentPermissionsUpdateCmd" %>
<%@ page import="com.ibm.commerce.user.beans.OrgEntityDataBean" %>
<%@ page import="com.ibm.commerce.user.beans.RoleDataBean" %>
<%@ page import="com.ibm.commerce.user.beans.RoleAssignmentPermissionDataBean" %>

<%@ include file="../common/common.jsp" %>

<%
    CommandContext cmdContext = (CommandContext)request.getAttribute(
    	ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cmdContext.getLocale();
    String webalias = UIUtil.getWebPrefix(request);

	// obtain the resource bundle for display
	Hashtable orgEntityNLS = 
		(Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup(
			"buyerconsole.BuyOrgEntityNLS", 
			locale);
	if (orgEntityNLS == null) System.out.println("!!!! RS is null");
      
	String orgId = request.getParameter("memberId");
	if (orgId == null || orgId.length() == 0) {
		// Default to Root organization if organizationId is not passed in
		orgId = "-2001";
	}
	
	// Get the list of roles for this organization
	OrgEntityDataBean oedb = new OrgEntityDataBean();
	oedb.setDataBeanKeyMemberId(orgId);
	com.ibm.commerce.beans.DataBeanManager.activate(oedb, request);
	Integer[] orgRoles = oedb.getRoles();

	// Populate the display list of roles
	String[][] roleNames = new String[orgRoles.length][2];	
	for (int i =0; i < orgRoles.length; i++) {
		RoleDataBean rdb = new RoleDataBean();
		rdb.setDataBeanKeyRoleId(orgRoles[i].toString());
		com.ibm.commerce.beans.DataBeanManager.activate(rdb, request);
		
		roleNames[i][0] = orgRoles[i].toString();
		roleNames[i][1] = rdb.getDisplayName();
	}  
	
	// Populate the existing configuration for this databean
	Long[] orgRoleAssignmentPermissions = 
		oedb.getRoleAssignmentPermissions();
		
	String[][] storedRoleAssignmentPermissions = 
		new String[orgRoleAssignmentPermissions.length][2];
	
	for (int i=0; i<orgRoleAssignmentPermissions.length; i++) {
		
		RoleAssignmentPermissionDataBean dbRoleAssignmentPermissions =
			new RoleAssignmentPermissionDataBean();
		dbRoleAssignmentPermissions.
			setDataBeanKeyRoleAssignmentPermissionId(
				orgRoleAssignmentPermissions[i].toString());
		dbRoleAssignmentPermissions.populate();

		storedRoleAssignmentPermissions[i][0] = 
			dbRoleAssignmentPermissions.getAssigningRoleId().toString();
		storedRoleAssignmentPermissions[i][1] = 
			(dbRoleAssignmentPermissions.getAssignableRoleId() == null) ?
				null
				: dbRoleAssignmentPermissions.getAssignableRoleId().toString();
	}  
%>


<html>
<head>
<LINK 
	rel=stylesheet 
	href="<%= UIUtil.getCSSFile(cmdContext.getLocale())%>" 
	type="text/css">

<style type='text/css'>
	.selectWidth {width: 330px;}
	.summaryWidth {width: 800px;}
</style>

<script src="/wcs/javascript/tools/common/SwapList.js"></script>

<script>
	// String to hold the organization Id for which this configuration applies
    var iOrganizationId = <%=(orgId == null ? null : UIUtil.toJavaScript(orgId))%>;
    
    // The current assigning role
    var GENERIC_ASSIGNING_ROLE = "0";
    var CAN_ASSIGN_ALL_ROLES = 
    	"<%=UIUtil.toHTML((String)orgEntityNLS.get("summaryCanAssignAllRoles"))%>";
    var ROLE_SEPARATOR = " -- ";
    
    var iAssigningRoleId = GENERIC_ASSIGNING_ROLE;
    
    // Hashtable storing the role configuration data; keys are the assigning roleIds, 
    // values are arrays of assignable roleIds (or a string representing all roles)
  	var ihshRolesConfig = new Object();
  	
	// Populate local data structures based on the roles passed in
	var tmphshRoleIds = new Object();
	var tmparrSortedRoleNames = new Array();
	<%
		for (int i=0; i<roleNames.length; i++) {
			out.print(
				"tmphshRoleIds['" 
				+ UIUtil.toJavaScript(roleNames[i][1]) 
				+ "'] = '" 
				+ UIUtil.toJavaScript(roleNames[i][0]) 
				+ "';");
			out.print(
				"tmparrSortedRoleNames[" 
				+ i 
				+ "] = '" 
				+ UIUtil.toJavaScript(UIUtil.toHTML(roleNames[i][1])) 
				+ "';");
		}
	%>

  	// Hashtable storing role names; keys are roleIds, values are the role names
	var ihshRoleNames = new Object();
	tmparrSortedRoleNames.sort();
	for (i = 0; i<tmparrSortedRoleNames.length; i++) {
		ihshRoleNames[tmphshRoleIds[tmparrSortedRoleNames[i]]] = tmparrSortedRoleNames[i];
	}

	// Hashtable holding the inclusion assigning roles
	// TODO
	var ihshInclusionAssigningRoles = new Object();
	<%
		Object[] arr1 = 
			RoleAssignmentPermissionDataBean.getAssigningRoleInclusionList().toArray();
		for (int i=0; i<arr1.length; i++) {
			out.print(
				"ihshInclusionAssigningRoles[" 
				+ UIUtil.toJavaScript(arr1[i].toString()) 
				+ "] = 'INCLUDED';");
		}
	%>
	
	// Hashtable holding the exempted assignable roles
	var ihshExemptedAssignableRoles = new Object();
	<%
		Object[] arr2 = 
			RoleAssignmentPermissionDataBean.getAssignableRoleExemptionList().toArray();
		for (int i=0; i<arr2.length; i++) {
			out.print(
				"ihshExemptedAssignableRoles[" 
				+ UIUtil.toJavaScript(arr2[i].toString()) 
				+ "] = 'EXEMPTED';");
		}
	%>

	/**
	 * Load the model based on the role assignment permissions management configuration for the 
	 * specified organization. 
	 **/
	function initializeState() {

		// Populate the model based on the configuration information read from the database
		
		<%
		// First pass sets up the assignable roles where they are defined
		for (int i=0; i<storedRoleAssignmentPermissions.length; i++) {
			if (storedRoleAssignmentPermissions[i][1] != null) {
		%>
		if (ihshRolesConfig["<%=UIUtil.toJavaScript(storedRoleAssignmentPermissions[i][0])%>"] == null
			|| ihshRolesConfig["<%=UIUtil.toJavaScript(storedRoleAssignmentPermissions[i][0])%>"] == "") {

			// Make sure that the array is initialized						
			ihshRolesConfig["<%=UIUtil.toJavaScript(storedRoleAssignmentPermissions[i][0])%>"] = new Array();
		}
		ihshRolesConfig["<%=UIUtil.toJavaScript(storedRoleAssignmentPermissions[i][0])%>"]
			.push("<%=UIUtil.toJavaScript(storedRoleAssignmentPermissions[i][1])%>");

		<%
			}
		}	
		%>
		
		<%	
		// Second pass sets up the assigning roles that can assign all roles
		for (int i=0; i<storedRoleAssignmentPermissions.length; i++) {
			if (storedRoleAssignmentPermissions[i][1] == null) {
		%>

		ihshRolesConfig["<%=UIUtil.toJavaScript(storedRoleAssignmentPermissions[i][0])%>"] = 
			"<%=RoleAssignmentPermissionsUpdateCmd.REQUEST_PARAM_VALUE_CANASSIGNALLROLES%>";

		<%
			}
		}
		%>
	

		// Populate the model for the currently active assigning role
		loadCurrentAssigningRole();
		
		// Populate the summary
		populateSummary();
		
		// Mark the page as loaded
		parent.setContentFrameLoaded(true);
	}

	/**
	 * Save the data from the page to the model, then push it to the top frame
	 * for delivery to the backend command.
	 **/
	function savePanelData() {
		parent.addURLParameter("authToken", "${authToken}");
		// Push the changes up to the top frame so that they will be fed to the command
		parent.put(
			"<%=RoleAssignmentPermissionsUpdateCmd.REQUEST_PARAM_ORGANIZATIONID%>", 
			iOrganizationId);

		for (i in ihshRolesConfig) {
			parent.put(
				"<%=RoleAssignmentPermissionsUpdateCmd.REQUEST_PARAM_ASSIGNINGROLEID%>" + i, 
				ihshRolesConfig[i]);		
		}
	}  

	/**
	 * Validate the model.
	 **/
	function validatePanelData() {
		// No validation required. Invalid selections will not be displayed.
	}

	/**
	 * Change the assigning role. Invoked on every change to the assigning role
	 * drop-down. This action will trigger a save to the model, and a refresh of the
	 * other widgets on the page.
	 **/
	function changeAssigningRole() {
	
		// Update the currently active assigning role
		iAssigningRoleId = document.f1.selectAssigningRole.value;

		// Refresh the page for the new assigning role
		loadCurrentAssigningRole();

		// Populate the summary list
		populateSummary();
	}

	/**
	 * Save the changes made for a specified assigning role to the underlying 
	 * model.
	 **/
	function updateModelFromUI() {
		
		if (document.f1.canAssignAllRoles[0].checked) {
			// Update the model to reflect that this assigning role can assign all roles
			ihshRolesConfig[iAssigningRoleId] = 
				"<%=RoleAssignmentPermissionsUpdateCmd.REQUEST_PARAM_VALUE_CANASSIGNALLROLES%>";			
		}
		else {
			// Go through the selected side of the slosh bucket and update the model
			// to reflect that this assigning role can assign the selected roles
			var selectedRoles = new Array();
			for (i=0; i<document.f1.assignableRolesSelected.options.length; i++) {
				selectedRoles.push(document.f1.assignableRolesSelected.options[i].value);
			}
			ihshRolesConfig[iAssigningRoleId] = selectedRoles;
		}
		
		// Update the summary to reflect the changes
		populateSummary();
	}

	/**
	 * Load the current assigning role.
	 **/
	function loadCurrentAssigningRole() {
		
		// Reset the slosh bucket
		resetSloshBucket();
	
		if (iAssigningRoleId == GENERIC_ASSIGNING_ROLE) {
			
			// This is the generic role, leave panel cleared and disabled
			setCanAssignAllRoles();
			disableAll();
		}
		else {

			// In case we are switching from the GENERIC role, enable all widgets
			enableAll();

			// Populate the slosh bucket with the user's settings
			if (ihshRolesConfig[iAssigningRoleId] == null 
				|| ihshRolesConfig[iAssigningRoleId] == "") {
				
				// By default, set the UI so that the user will be allowed to select roles
				setCanAssignSelectedRoles();
			}
			else if (ihshRolesConfig[iAssigningRoleId] == 
				"<%=RoleAssignmentPermissionsUpdateCmd.REQUEST_PARAM_VALUE_CANASSIGNALLROLES%>") {
				
				// Set the UI so that the user will NOT be allowed to select roles
				setCanAssignAllRoles();
			}
			else {
				// Update the sloshbucket based on the existing configuration
				for (i=0; i<ihshRolesConfig[iAssigningRoleId].length; i++) {
					setAnItemSelected(
						document.f1.assignableRolesAvailable, 
						ihshRolesConfig[iAssigningRoleId][i]);
				}

				// Move these roles to the selected side of the slosh bucket
				move(
					document.f1.assignableRolesAvailable,
					document.f1.assignableRolesSelected);

				// Set the UI so that the user will be allowed to select roles
				setCanAssignSelectedRoles();
			}
		}
	}

	/**
	 * Set all items on the selected side of the slosh bucket to selected, then move
	 * them to the available side (resets the slosh bucket).	
	 */
	function resetSloshBucket() {
		setItemsSelected(document.f1.assignableRolesSelected);
		move(
			document.f1.assignableRolesSelected, 
			document.f1.assignableRolesAvailable);
	}

	/**
	 * Update the UI to indicate that this assigning role can assign all roles.
	 **/
	function setCanAssignAllRoles() {
		document.f1.canAssignAllRoles[0].checked = "true";
		disableSloshBucket();
	}
	
	/**
	 * Update the UI to indicate that this assigning role can assign only the selected roles.
	 **/	
	function setCanAssignSelectedRoles() {
		document.f1.canAssignAllRoles[1].checked = "true";
		enableSloshBucket();
	}	

	/**
	 * Disable the slosh bucket.
	 **/
	function disableSloshBucket() {
		document.f1.assignableRolesSelected.disabled = true;
		document.f1.assignableRolesAvailable.disabled = true;
		document.f1.addAssignableRoles.disabled = true;
		document.f1.removeAssignableRoles.disabled = true;
	}

	/**
	 * Enable the slosh bucket.
	 **/	
	function enableSloshBucket() {
		document.f1.assignableRolesSelected.disabled = false;	
		document.f1.assignableRolesAvailable.disabled = false;		
		document.f1.addAssignableRoles.disabled = false;
		document.f1.removeAssignableRoles.disabled = false;
	}

	/**
	 * Function will disable all widgets on the GUI. This method should be
	 * called whenever the assigning role is switched to the GENERIC role, 
	 * because it doesn't make sense to create a configuration for the 
	 * generic role.
	 **/
	function disableAll() {
		// disable the slosh bucket
		disableSloshBucket();
		
		// disable the radio buttons
		document.f1.canAssignAllRoles[0].disabled = true;
		document.f1.canAssignAllRoles[1].disabled = true;
		
		// disable the apply button
		document.f1.applyChanges.disabled = true;
	}
	
	/**
	 * Function will enable all widgets on the GUI.
	 **/	
	function enableAll() {
		// enable the slosh bucket
		enableSloshBucket();
		
		// enable the radio buttons
		document.f1.canAssignAllRoles[0].disabled = false;
		document.f1.canAssignAllRoles[1].disabled = false;
		
		// enable the apply button
		document.f1.applyChanges.disabled = false;
	}

	/**
	 * Populate the summary view.
	 **/
	function populateSummary() {

		// Delete the existing entries in the select box
		for (i=document.f1.summaryRoleConfigList.options.length-1; i>=0; i--) {
			document.f1.summaryRoleConfigList.options[i] = null;
		}
		
		// Build up the list of entries for the summary list
		var arrOptions = new Array();
		for (i in ihshRolesConfig) {
		
			if (ihshRolesConfig[i] == 
				"<%=RoleAssignmentPermissionsUpdateCmd.REQUEST_PARAM_VALUE_CANASSIGNALLROLES%>") {
			
				arrOptions.push(
					ihshRoleNames[i] + ROLE_SEPARATOR + CAN_ASSIGN_ALL_ROLES);
			}
			else {
				var arr = ihshRolesConfig[i];
				for (j=0; j<arr.length; j++) {
					arrOptions.push(
						ihshRoleNames[i] + ROLE_SEPARATOR + ihshRoleNames[arr[j]]);
				}
			}
		}
		
		// Sort the options and write them out to the list box
		arrOptions.sort();
		for (i=0; i<arrOptions.length; i++) {
			document.f1.summaryRoleConfigList.options[i] = new Option(arrOptions[i], i);
		}
	}

</script>

</head>

<body onload="initializeState();" class="content">

<h1><%=UIUtil.toHTML((String)orgEntityNLS.get("titleRoleAssignmentPermissions"))%></h1>

<%=UIUtil.toHTML((String)orgEntityNLS.get("para1RoleAssignmentPermissions"))%>

<form name='f1'>

	<!-- User must first choose an assigning role -->
	<b><%=UIUtil.toHTML((String)orgEntityNLS.get("subtitleAssigningRole"))%></b>
	<br/>	
	
	<label class='hidden-label' for='selectAssigningRole1'>
		<%=UIUtil.toHTML((String)orgEntityNLS.get("subtitleAssigningRole"))%>
	</label>	
	<select 
		name='selectAssigningRole' 
		id='selectAssigningRole1'
		onchange='changeAssigningRole();'>
	
		<option value='0' selected>
			<%=UIUtil.toHTML((String)orgEntityNLS.get("genericRoleName"))%>
		</option>

		<script>
		for (i in ihshRoleNames) {
			// Create the options for all the included assigning roles
			if (ihshInclusionAssigningRoles[i] != null) {
				document.write("<option value='" + i + "'>" + ihshRoleNames[i] + "</option>");
			}
		}
		</script>
	</select>


	<!-- User must choose whether to allow the assigning role to assign all roles, or only selected roles -->
	<br/><br/>
	<label class='hidden-label' for='canAssignAllRoles0'>
		<%=UIUtil.toHTML((String)orgEntityNLS.get("radioAllAssignableRoles"))%>
	</label>	
	<input 
		type='radio'
		name='canAssignAllRoles' 
		id='canAssignAllRoles0'
		onclick='disableSloshBucket();'/>
			<%=UIUtil.toHTML((String)orgEntityNLS.get("radioAllAssignableRoles"))%>
	<br/>
	<label class='hidden-label' for='canAssignAllRoles1'>
		<%=UIUtil.toHTML((String)orgEntityNLS.get("radioSelectedAssignableRoles"))%>
	</label>			
	<INPUT 
		TYPE='radio'
		name='canAssignAllRoles' 
		id='canAssignAllRoles1'
		onclick='enableSloshBucket();' 
		checked='checked'/>
			<%=UIUtil.toHTML((String)orgEntityNLS.get("radioSelectedAssignableRoles"))%>

	<!-- Slosh bucket used to select assignable roles for the current assigning role -->
	<br/><br/>
	<table>
	<tr>
		<td align='center' valign='bottom' class='selectWidth'> 
			<b><%=UIUtil.toHTML((String)orgEntityNLS.get("subtitleSelectedAssignableRoles"))%></b>
			<br/>
			<label class='hidden-label' for='assignableRolesSelected1'>
				<%=UIUtil.toHTML((String)orgEntityNLS.get("subtitleAvailableAssignableRoles"))%>
			</label>			
			<select 
				name='assignableRolesSelected' 
				class='selectWidth' 
				id='assignableRolesSelected1'
				size='8' 
				multiple>
			</select>
		</td>
		<td width='150px' align='center'>
			<br/> 
			<label class='hidden-label' for='addAssignableRoles1'>
				<%=UIUtil.toHTML((String)orgEntityNLS.get("buttonAddAssignableRoles"))%>
			</label>
			<button 
				name='addAssignableRoles'
				class='general'
				id='addAssignableRoles1'
				onclick='move(document.f1.assignableRolesAvailable,document.f1.assignableRolesSelected);'>
				<%=UIUtil.toHTML((String)orgEntityNLS.get("buttonAddAssignableRoles"))%>
			</button>
			<br/><br/>

			<label class='hidden-label' for='removeAssignableRoles1'>
				<%=UIUtil.toHTML((String)orgEntityNLS.get("buttonRemoveAssignableRoles"))%>
			</label>
			<button 
				name='removeAssignableRoles'
				class='general'
				id='removeAssignableRoles1';
				onclick='move(document.f1.assignableRolesSelected,document.f1.assignableRolesAvailable);'>
				<%=UIUtil.toHTML((String)orgEntityNLS.get("buttonRemoveAssignableRoles"))%>
			</button>			
			<br/>
		</td>
		<td align='center' valign='bottom' class='selectWidth'>
			<b><%=UIUtil.toHTML((String)orgEntityNLS.get("subtitleAvailableAssignableRoles"))%></b>
			<br/>
			<label class='hidden-label' for='assignableRolesAvailable1'>
				<%=UIUtil.toHTML((String)orgEntityNLS.get("subtitleAvailableAssignableRoles"))%>
			</label>			
			<select 
				name='assignableRolesAvailable' 
				class='selectWidth' 
				id='assignableRolesAvailable1'
				size='8' 
				multiple>

				<!-- Populate the available list with the role definitions -->
				<script>
				for (i in ihshRoleNames) {
					// Create the options for all roles except Site Admin
					if (ihshExemptedAssignableRoles[i] == null) {
						document.write("<option value='" + i + "'>" + ihshRoleNames[i] + "</option>");
					}
				}
				</script>
			</select>
		</td>
	</tr>
	</table>
	
	<!-- User clicks this button to apply the selected changes -->
	<label class='hidden-label' for='applyChanges1'>
		<%=UIUtil.toHTML((String)orgEntityNLS.get("buttonApplyChanges"))%>
	</label>			
	<button 
		name='applyChanges' 
		class='general'
		id='applyChanges1'
		onclick='updateModelFromUI();'>
		<%=UIUtil.toHTML((String)orgEntityNLS.get("buttonApplyChanges"))%>
	</button>			
		
	<!-- List box displays the selected configurations for all roles except the currently active role -->
	<!-- This list is populated by the populateSummary() function -->
	<br/><br/><br/>
	<b><%=UIUtil.toHTML((String)orgEntityNLS.get("subtitleDefinedAssignmentPermissions"))%></b>
	<br/>
	<label class='hidden-label' for='summaryRoleConfigList1'>
		<%=UIUtil.toHTML((String)orgEntityNLS.get("subtitleDefinedAssignmentPermissions"))%>
	</label>			
	<select 
		name='summaryRoleConfigList'
		class='summaryWidth' 
		id='summaryRoleConfigList1'
		size='12'>	
	</select>
	  
</FORM>

</BODY>
</html>
