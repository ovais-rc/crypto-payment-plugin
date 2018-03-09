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

<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.user.beans.UserAdminDataBean" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="com.ibm.commerce.tools.optools.user.beans.*" %>
<%@ page import="com.ibm.commerce.tools.optools.user.helpers.*" %>
<%@ page import="com.ibm.commerce.tools.optools.common.helpers.*" %>
<%@ page import="com.ibm.commerce.collaboration.livehelp.beans.LiveHelpConfiguration" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="com.ibm.commerce.user.beans.CustomerSearchDataBean" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="../common/List.jsp" %>

<jsp:useBean id="userAdminList" scope="request" class="com.ibm.commerce.user.beans.UserAdminListDataBean">
</jsp:useBean>

<!-- RESOURCE: /tools/buyerconsole/BuyUserAdminList.jsp -->
<!-- Dependencies: BuyUserFind.jsp, BuyUserFindData,jsp -->
<!-- Property files: com\ibm\commerce\tools\buyerconsole\properties\BuyAdminConsoleNLS.properties -->
<!-- -->


<%
	String webalias = UIUtil.getWebPrefix(request);
	Hashtable userAdminListNLS = null;
	Hashtable userAdminListNLS2 = null;
	UserAdminDataBean userAdmins[] = null; 
	int numberOfOrgUsers = 0;

	// obtain the resource bundle for display
	userAdminListNLS = (Hashtable)ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", getLocale());
	userAdminListNLS2 = (Hashtable)ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", getLocale());
	String adminTypeSstr = UIUtil.toHTML((String)userAdminListNLS.get("userAdminTypeS"));
	String adminTypeAstr = UIUtil.toHTML((String)userAdminListNLS.get("userAdminTypeA"));

	CommandContext cmdContext = getCommandContext();
	Long userId = cmdContext.getUserId();
	String localeUsed = cmdContext.getLocale().toString();
	JSPHelper jspHelper1 = new JSPHelper(request);

   	String userLogonId 				= jspHelper1.getParameter("userLogonId");
	String userLogonIdSearchType 	= jspHelper1.getParameter("userLogonIdSearchType");
	String userFirstName 			= jspHelper1.getParameter("userFirstName");
	String userFirstNameSearchType 	= jspHelper1.getParameter("userFirstNameSearchType");
	String userLastName 			= jspHelper1.getParameter("userLastName");
	String userLastNameSearchType 	= jspHelper1.getParameter("userLastNameSearchType");
	String roleId 					= jspHelper1.getParameter("roleId");
	String parentOrgName			= jspHelper1.getParameter("parentOrgName");
	String parentOrgNameSearchType 	= jspHelper1.getParameter("parentOrgNameSearchType");

    int maxDisplay = 500; // The MAX number of results that the query can find
   	
	// Returns a Vector of Vectors, one outer Vector per user, each inner Vector contains
	// the userId in the first position. Returns entries from position startIndex to position endIndex
	CustomerSearchDataBean dbCustomerSearch = new CustomerSearchDataBean();
	dbCustomerSearch.setCommandContext(cmdContext);
	Vector vecUsers = dbCustomerSearch.findUsersInOrganizationsICanAdminister(
		userLogonId,
		userLogonIdSearchType,
		userFirstName,
		userFirstNameSearchType,
		userLastName,
		userLastNameSearchType,
		parentOrgName,
		parentOrgNameSearchType,
		roleId,
		"USERREG", // order by logonId, can be customized -- just type in table and field name
		"LOGONID",
		new Integer(getStartIndex()).toString(),
		new Integer(maxDisplay+1).toString());
   
	numberOfOrgUsers = vecUsers.size();     

	int endIndex;
	if (numberOfOrgUsers <= getListSize()) {
		endIndex = getStartIndex() + numberOfOrgUsers;		
	}	
	else {
		endIndex = getStartIndex() + getListSize();
	}
	
	int totalsize = getStartIndex() + numberOfOrgUsers;
	int totalpage = totalsize/getListSize();  // The total number of pages, (rounds up)

	if (totalsize % getListSize() > 0) {
		totalpage++;
	}

    boolean resultTooLarge = false;
	if (numberOfOrgUsers > maxDisplay) {
		resultTooLarge = true;  // If a query is executed that returns too many
								// results, then throw exception and display nothing
		totalsize = 0;	
		totalpage = 0;					
	}

	//out.print("Page inputs: userLastName=" + userLastName);
	//out.print(", userLastNameSearchType=" + userLastNameSearchType);
   	//out.print(", roleId=" + roleId);
	//out.print(", parentOrgName=" + parentOrgName);    
    //out.print(", parentOrgNameSearchType=" + parentOrgNameSearchType);
	//out.print(", getStartIndex()=" + getStartIndex());   	
   	//out.print(", maxDisplay=" + maxDisplay);	
	//out.print(", getListSize()=" + getListSize());
	//out.print("<BR>");
	//out.print("Computed values: endIndex=" + endIndex);
	//out.print(", numberOfOrgUsers=" + numberOfOrgUsers);
	//out.print(", resultTooLarge=" + resultTooLarge);
	//out.print(", totalsize=" + totalsize);
	//out.print(", totalpage=" + totalpage);
	
	String xmlFileParm = jspHelper1.getParameter("ActionXMLFile");
	Hashtable xmlTree = (Hashtable)ResourceDirectory.lookup(xmlFileParm);

	Hashtable localeNameFormat = 
		(Hashtable)XMLUtil.get(xmlTree, "action.nlsNameFormats."+ localeUsed);
	if (localeNameFormat == null) {
    	localeNameFormat = (Hashtable)XMLUtil.get(xmlTree, "action.nlsNameFormats.default");
	}

	boolean displayLastNameFirst = false;
   
	int displayLastNamePos = 0;
	int displayFirstNamePos = 0;

	String nameFormatStr = (String)XMLUtil.get(localeNameFormat,"name.fields");
	if (nameFormatStr != null) {
		String[] nameFormatFields = Util.tokenize(nameFormatStr, ",");

		for (int i=0; i < nameFormatFields.length; i++)  {
			if (nameFormatFields[i].equals("lastName")) {
				displayLastNamePos = i;
         	}
       		else if (nameFormatFields[i].equals("firstName")) {
				displayFirstNamePos = i;
			}
		}

		if (displayLastNamePos < displayFirstNamePos) {
			displayLastNameFirst = true;
		}
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%= fHeader%>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css" />
<title><%=UIUtil.toHTML((String)userAdminListNLS.get("administrators")) %></title>

<script type="text/javascript" language="JavaScript">
<!---- hide script from old browsers
    
	function getResultsSize() { 
		return <%= totalsize  %>; 
	}

	function findUserAdmin() {

		var url = top.getWebappPath() + "DialogView?XMLFile=buyerconsole.BuyUserFind";

		if (top.setContent) {
			top.setContent(
        		"<%=UIUtil.toJavaScript((String)userAdminListNLS.get("find")) %>",
				url,
				true);
		}
		else {
			parent.location.replace(url);
		}
	}

	function newUserAdmin() {
                //Uncomment the next line to use the Wizard for creating users
                //var url = top.getWebappPath() + "WizardView?XMLFile=buyerconsole.BuyUserWizard";
      
                //Comment out the next line to use the Wizard for creating users
                var url = top.getWebappPath() + "BuyCreateUserView?XMLFile=buyerconsole.BuyCreateUserDialog";

		if (top.setContent) {
			top.setContent(
        		"<%=UIUtil.toJavaScript((String)userAdminListNLS2.get("newUser")) %>",
				url,
				true);
		}
		else {
			parent.location.replace(url);
		}
	}

	function changeUserAdmin() {
		var changed = 0;
		var userAdminId = 0;

		if (arguments.length > 0) {
			userAdminId = arguments[0];
			changed = 1;
		}
		else {
			var checked = parent.getChecked();
			if (checked.length > 0) {
			        var parms = checked[0].split('_');
				userAdminId = parms[0];
				changed = 1;
			}
		}
      
      	if (changed != 0) {
                //Uncomment the next line to use the Notebook for updating users
                //var url = top.getWebappPath() + "NotebookView?XMLFile=buyerconsole.BuyUserNotebook" + "&memberId=" + userAdminId;
         
                //Comment out the next line to use the Notebook for updating users
                var url = top.getWebappPath() + "BuyCreateUserView?XMLFile=buyerconsole.BuyUpdateUserDialog" + "&memberId=" + userAdminId;
        
        	if (top.setContent) {
				top.setContent(
					"<%=UIUtil.toJavaScript((String)userAdminListNLS2.get("changeUser")) %>",
					url,
					true);
			}
        	else {
				parent.location.replace(url);
			}
		} 
    }
   
	function rolesUserAdmin() {

		var changed = 0;
		var userAdminId = 0;

		if (arguments.length > 0) {

			userAdminId = arguments[0];
			changed = 1;
		}
		else {
			var checked = parent.getChecked();

			if (checked.length > 0) {
			        var parms = checked[0].split('_');
				userAdminId = parms[0];
				changed = 1;
			}
		}
      
		if (changed != 0) {
			var url = 
				top.getWebappPath() 
				+ "DialogView?XMLFile=buyerconsole.BuyUserRoles"
				+ "&memberId=" 
				+ userAdminId;
        
			if (top.setContent) {
				top.setContent(
					"<%=UIUtil.toJavaScript((String)userAdminListNLS.get("roles")) %>",
					url,
					true);
			}
	        else {
				parent.location.replace(url);
			}
		} else {
			var url = 
				top.getWebappPath() 
				+ "DialogView?XMLFile=buyerconsole.BuyUserRoles";
				
			top.setContent(
				"<%=UIUtil.toJavaScript((String)userAdminListNLS.get("roles")) %>",
				url,
				true);
		}
	}
    
    function mbrgrpUserAdmin() {

		var changed = 0;
		var userAdminId = 0;

		if (arguments.length > 0) {
	        userAdminId = arguments[0];
    	    changed = 1;
      	}
      	else {
	        var checked = parent.getChecked();
    	    if (checked.length > 0) {
    	    			var parms = checked[0].split('_');
				userAdminId = parms[0];
				changed = 1;
			}
      	}
      	if (changed != 0) {
	        var url = 
	        	top.getWebappPath() 
	        	+ "NotebookView?XMLFile=buyerconsole.BuyUserMbrGrpNotebook"
        		+ "&memberId=" 
        		+ userAdminId;

    	    if (top.setContent) {
				top.setContent(
					"<%=UIUtil.toJavaScript((String)userAdminListNLS.get("userGeneralMbrGrp")) %>",
					url,
					true);
			}
			else {
				parent.location.replace(url);
			}
		} 
    }
    
    function listDist() { 
      	var changed = 0;
      	var userAdminId = 0;

      	if (arguments.length > 0) {
        	userAdminId = arguments[0];
        	changed = 1;
      	} else {
        	var checked = parent.getChecked();
        	if (checked.length > 0) {
			var parms = checked[0].split('_');
			userAdminId = parms[0];
          		changed = 1;
        	}
        }
        if (changed != 0) {
      		var url = top.getWebappPath() + "NewDynamicListView?ActionXMLFile=buyerconsole.BuyUserDistList&cmd=BuyUserDistListView";
        	url += "&memberId=" + userAdminId;
        	if (top.setContent) {
          		top.setContent("<%= UIUtil.toJavaScript((String)userAdminListNLS.get("userAdminListDistButton")) %>",
                         		url,
                         		true);
        	} else {
          		parent.location.replace(url);
        	}
      	} 
    }    
    
    // -- \/ \/ \/ --- LiveHelp
    function regCustCare(){
      
      if (parent.buttons.buttonForm.regCustCareButton.className =='disabled')
        return;   //df33144
        
      var changed = 0;
      var userAdminId = 0;

      if (arguments.length > 0)
      {
        userAdminId = arguments[0];
        changed = 1;
      }
      else
      {
        var checked = parent.getChecked();
        if (checked.length > 0)
        {
	  var parms = checked[0].split('_');
	  userAdminId = parms[0];
          changed = 1;
        }
      }
      if (changed != 0)
      {
        var url = top.getWebappPath() + "DialogView?XMLFile=livehelp.liveHelpRegistration";
        url += "&memberId=" + userAdminId;
        if (top.setContent)
        {
          top.setContent("<%=UIUtil.toJavaScript((String)userAdminListNLS2.get("regCustCare")) %>",
                         url,
                         true);
        }
        else
        {
          parent.location.replace(url);
        }
      }
    }
    // -- /\ /\ /\ --- LiveHelp
    // -- \/ \/ \/ --- LiveHelp
    function myRefreshButtons()
    {

      parent.refreshButtons();

      if(typeof parent.checkValueHashtable == "undefined")
        parent.checkValueHashtable = new Object();

      var theArray = new Array;
      var temp;

      for (var i=0; i<document.userAdminForm.elements.length; i++)
      {
          if (document.userAdminForm.elements[i].type == 'checkbox'){
            if (document.userAdminForm.elements[i].checked) {
               parent.checkValueHashtable[document.userAdminForm.elements[i].name] = document.userAdminForm.elements[i].value;
            }             
       	  }      	  
      } 

      var temp2;
      var checked = new String(parent.getChecked());
      if(checked == "") return;

      temp2 = checked.split(",");
      for (var j = 0; j < temp2.length; j++)
      {
        var parms = temp2[j].split('_');
        theArray[j] = parent.checkValueHashtable[parms[0]];
      }


      if (theArray.length == 1 )
      {
        temp_role = theArray[0];
        <% if (LiveHelpConfiguration.isEnabled()) { %>
		bCCDisabled=false;
        <%  } else { %>
		bCCDisabled=true;
        <% } %>
        
          // --------------------------------------------------------
          // Only the following roles allow to Register Customer Care
          //  -1 = Site Admin
          //  -3 = Customer Service Representative
          //  -4 = Seller
          // -12 = Operations Manager
          // -14 = Customer Service Supervisor
          // -18 = Sales Manager
          // --------------------------------------------------------
          if (bCCDisabled || "<%=LiveHelpConfiguration.getLdapType()%>"=="1" || !((temp_role.indexOf("[-1]") != -1) ||(temp_role.indexOf("[-3]") != -1) || (temp_role.indexOf("[-4]") != -1) ||
              (temp_role.indexOf("[-12]") != -1) || (temp_role.indexOf("[-14]") != -1) || (temp_role.indexOf("[-18]") != -1)))
          {
            if (defined(parent.buttons.buttonForm.regCustCareButton))
            {
              parent.buttons.buttonForm.regCustCareButton.disabled=false;
              parent.buttons.buttonForm.regCustCareButton.className='disabled';
              parent.buttons.buttonForm.regCustCareButton.id='disabled';
            }
          }
      }

      // check whether there is multiple selection in the table,  if there is, disable the roles button.
      var userChecked = parent.getChecked();
      if (userChecked.length > 1) {
         parent.buttons.buttonForm.userGeneralRolesButton.disabled=true;
         parent.buttons.buttonForm.userGeneralRolesButton.className="disabled";
      }
      else {
         parent.buttons.buttonForm.userGeneralRolesButton.disabled=false;
         parent.buttons.buttonForm.userGeneralRolesButton.className="enabled";
       }
    }
    // -- /\ /\ /\ --- LiveHelp


    function assignCust() {
    
         var usersId = -1;
         var isCSR = 'n';
		if (arguments.length > 0) {
			usersId = arguments[0];
		}
		else {
			var checked = parent.getChecked();
			if (checked.length > 0) {
				var parms = checked[0].split('_');
				usersId = parms[0];
				isCSR = parms[1];
			}
	}
	
	if (isCSR == 'y' || isCSR == 'Y') {
		var url = top.getWebappPath() + "DialogView?XMLFile=buyerconsole.AssignCustomersDialog"
	            	+ "&usersId=" 
	            	+ usersId;
	            
		if (top.setContent) {
			top.setContent(
        		"<%=UIUtil.toJavaScript((String)userAdminListNLS.get("assignCustLink")) %>",
				url,
				true);
		}
		else {
			parent.location.replace(url);
		}
	} else {
		alertDialog('<%=UIUtil.toJavaScript((String)userAdminListNLS.get("userAdminListCannotAssignCustomers")) %>');
	}
    }

    function onLoad() 
    {
      parent.loadFrames();
      <% if (!LiveHelpConfiguration.isEnabled()) { %>
	parent.hideButton('regCustCare');
      <% } %>
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

<%=com.ibm.commerce.tools.common.ui.taglibs.comm.addControlPanel("buyerconsole.BuyUserAdminList", totalpage, totalsize, cmdContext.getLocale() )%>

<form name="userAdminForm" action="BuyAdminConUserAdminView" method="POST">
<%=addHiddenVars()%>

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistTable((String)userAdminListNLS.get("AdminConsoleTableSumUserAdminList")) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRowHeading() %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheckHeading(false,null) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)userAdminListNLS.get("userAdminListLogonIdColumn"), null, false )%>

<%
    if (displayLastNameFirst)
    {
%>
	<%=com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)userAdminListNLS.get("userAdminListLastNameColumn"), null, false )%>
	<%=com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)userAdminListNLS.get("userAdminListFirstNameColumn"), null, false )%>
<%
    }

    if (!displayLastNameFirst)
    {
%>
	 <%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)userAdminListNLS.get("userAdminListLastNameColumn"), null, false )%>
<%	
    }
%>


<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)userAdminListNLS.get("userAdminFindOrg"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)userAdminListNLS.get("memberGroupRole"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>



<!-- Need to have a for loop to lookfor all the member groups -->
<%
    int rowselect=1;
    
    if (!resultTooLarge) {
    
    //for (int i=getStartIndex(); i < endIndex; i++) {
    for (int i=0; (i + getStartIndex()) < endIndex; i++) {
    
    	 String lastNameStr = "";
    	 String firstNameStr = "";
    	 String orgName = "";
    	 String id = "";
    	 String isCSR = "n";
    	 String roleNames = "";
    	 String roleIDs = "";
 		 UserDataBean dbUser = new UserDataBean();
    	 
    	 try {
      
      		// User Ids are in the first position of the nested Vector
	 	 	id = (((Vector)(vecUsers.elementAt(i))).elementAt(0)).toString();  
			
			// d79228 Replace the UserRegistrationDataBean with UserDataBean to bypass the synchronization with WMM
			dbUser.setDataBeanKeyMemberId(id);
			dbUser.setCommandContext(cmdContext);
			dbUser.populate();
			
	        if (!(dbUser.getProfileType()).equals("B")) continue;
	         
	        lastNameStr = dbUser.getLastName();
	        if (lastNameStr == null)
	        	lastNameStr = "";
	
	        firstNameStr = dbUser.getFirstName();
	        if (firstNameStr == null)
	        	firstNameStr = "";
	
	        Integer[] rootRoles = dbUser.getRoles();

		//RM:d70408 Ensure that the role list does not have repetitions
		Set setRoles = new HashSet();         
                  
		for (int j =0; j < rootRoles.length; j++) {
			//if the role is Seller/CSR/CSS then can assign customers to them
   			if (rootRoles[j].toString().trim().equals("-3") || rootRoles[j].toString().trim().equals("-4") || rootRoles[j].toString().trim().equals("-14")) {
   				isCSR = "y";
   			}
   			
			// RM: d70408 Keep a set of all roleIds encountered so far. If the next roleId is not 
			// in the set then we add it to the display.
			if (!setRoles.contains(rootRoles[j].toString().trim())) {
				
				// Add the roleId to the set
				setRoles.add(rootRoles[j].toString().trim());
	   
				// Resolve the role name from the roleId
				RoleDataBean rdb = new RoleDataBean();
				rdb.setDataBeanKeyRoleId(rootRoles[j].toString());
				rdb.setCommandContext(cmdContext);
				rdb.populate();
	                 
				if (setRoles.size() > 1) {
					roleNames = roleNames + ",";
					roleIDs = roleIDs + ",";
				}
                          
				roleNames = roleNames + rdb.getDisplayName();
				roleIDs = roleIDs + "[" + rootRoles[j].toString() + "]";
			}
		}

         String parentId = dbUser.getParentMemberId();
         OrganizationDataBean oedb2 = new OrganizationDataBean();
         oedb2.setDataBeanKeyMemberId(parentId);
         oedb2.setCommandContext(cmdContext);
         oedb2.populate();
         
         orgName = oedb2.getOrganizationName();
                 
         }catch (Exception e) {
         	e.printStackTrace();
         }
         
%>

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRow(Math.abs(i % 2) + 1) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheck(id + "_" + isCSR, "parent.setChecked();myRefreshButtons()", roleIDs.trim()) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(dbUser.getLogonId()), "javascript:changeUserAdmin('"+ id +"');" ) %> 
<%
    if (displayLastNameFirst)
    {
%>
	<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(lastNameStr), null ) %> 
	<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(firstNameStr), null ) %> 
<%
    }

    if (!displayLastNameFirst)
    {
%>
	<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(lastNameStr), null ) %> 
<%	
    }
%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(orgName), null ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(roleNames), null ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>

<%
}
}
%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistTable() %>
<%
    if (resultTooLarge) {
    	out.println(UIUtil.toHTML((String)userAdminListNLS.get("userAdminListTooMany")));	
    }
%>

</form>
<script type="text/javascript" language="JavaScript">
          parent.afterLoads();
          parent.setResultssize(getResultsSize());
</script>
</body>
</html>
