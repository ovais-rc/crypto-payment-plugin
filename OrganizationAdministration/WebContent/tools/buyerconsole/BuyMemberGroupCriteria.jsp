
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
<%@ page import="com.ibm.commerce.tools.segmentation.SegmentConstants" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.tools.segmentation.SegmentNotebookDataBean" %>

<%@ include file="../common/common.jsp" %>

<%
   CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale locale = cmdContext.getLocale();

   Hashtable userNLS = (Hashtable)ResourceDirectory.lookup("csr.userNLS", locale);
   Hashtable assignCustomersRB = (Hashtable)ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", locale );
 
   Hashtable userWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
   if (userWizardNLS == null) System.out.println("!!!! RS is null");
   
   String mbrGrpId = request.getParameter("segmentId");
   String orgId = request.getParameter("orgId");
   String memberGroupType = request.getParameter("memberGroupType");
   
   String oid = request.getParameter("oid"); 
   if(oid==null){ oid=""; }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2005, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<title><%=UIUtil.toHTML((String)userWizardNLS.get("Criteria"))%></title>
<%= fHeader%>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">
<style type='text/css'>
.selectWidth {width: 350px;}
</style>
<!-------------------------------------------->
<!-- Define the CSS for the LUS's GUI parts -->
<!-------------------------------------------->
<style type='text/css'>
.LUS_CSS_QuickTextEntryWidth {width: 320px;}
.LUS_CSS_ResultListBoxWidth  {width: 320px;}
.LUS_CSS_KeywordEntryWidth   {width: 200px;}
.LUS_CSS_CriteriaListWidth   {width: auto; }
</style>

<script LANGUAGE="JavaScript1.2" SRC="/wcs/javascript/tools/common/SwapList.js"></script>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

<!-------------------------------------------->
<!-- Import the LUS Widget Model javascript -->
<!-------------------------------------------->
<script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/common/LUSWidgetModel.js"></script>
<script type="text/javascript" > 
////////////////////////////////////////////////
// Load data from state of info for this page
// add them to the GUI
///////////////////////////////////////////////
function initializeState()
{ 
     var OrgArray = new Array();
       
     for (var i=0; i < document.f1.LUS_SearchResultListBox.options.length; i++)
     {
			OrgArray[i] = new Array();
			OrgArray[i].orgId = document.f1.LUS_SearchResultListBox.options[i].value;
			OrgArray[i].name = document.f1.LUS_SearchResultListBox.options[i].text;
     }
     
     var OrgNameArray = new Array();

     if (parent.setContentFrameLoaded) {	
        var o = parent.get("<%=SegmentConstants.ELEMENT_SEGMENT_DETAILS%>", null);
        
        var rolArray = o.<%=SegmentConstants.ELEMENT_ROLE%>;
        
	
				<%
				    // additional code to get list of organization names in case too many organizations are found in database
				    Vector orgList = new Vector();
				    
				    SegmentNotebookDataBean sndb = new SegmentNotebookDataBean();
				    DataBeanManager.activate(sndb, request);
				    
				    Vector roleList = sndb.getRole(); //Vector of hashtables
				    
				    Integer arrAllRoles [] = RoleDataBean.getAllRoles();
				%>
				    var roleInternalNames = new Array();
				    var roleDisplayNames = new Array();
				    
				<%
				    for (int r=0; r < arrAllRoles.length; r++) {
				    
				       RoleDataBean dbRole = new RoleDataBean();
				       dbRole.setDataBeanKeyRoleId( arrAllRoles[r].toString() );
				       dbRole.setCommandContext( cmdContext );
				       dbRole.populate();
				%>
				       roleInternalNames[<%= r %>] = '<%=UIUtil.toJavaScript(dbRole.getName())%>' ;
				       roleDisplayNames[<%= r %>] = '<%=UIUtil.toJavaScript(dbRole.getDisplayName())%>' ;
				<%
				    }
				%>
  
  			for (var h=0; h < <%= roleList.size() %>; h++) {
					OrgNameArray[h] = new Array();
				}
			<%    
			  for (int i=0; i<roleList.size(); i++) {
				    	Hashtable tmpRole = (Hashtable)roleList.elementAt(i);
				    	String roleOrgId = (String)tmpRole.get("org");
			%>
						  OrgNameArray[<%= i %>].orgId = '<%=UIUtil.toJavaScript(roleOrgId)%>';
				
				  <%    	
							String orgNm = null;
					
							if ( "OrgAndAncestorOrgs".equalsIgnoreCase(roleOrgId) ) {
									orgNm = "forOrg";
							} else if (roleOrgId != null) {
									try {
										Long.parseLong(roleOrgId);
									} catch (NumberFormatException e) {
										//Another special string, eg. "DescendantOrgs" that is not currently handled
										break;
									}
									OrganizationDataBean tmpOdb = new OrganizationDataBean();
									tmpOdb.setDataBeanKeyMemberId(roleOrgId);
									tmpOdb.populate();
						
									orgNm = tmpOdb.getOrganizationDisplayName();
							}
					%>
					     OrgNameArray[<%= i %>].name = '<%=UIUtil.toJavaScript(orgNm)%>';
			<%    
			  }
			%>
			
        var orgArray = o.<%=SegmentConstants.VARIABLE_ORG%>;
        var regArray = o.<%=SegmentConstants.ELEMENT_REGISTRATION_STATUS_OP%>;
        var criteria = false;
        var setAd2 = parent.get("setAdmin2"); // Settings for Organization and Roles Checkbox
        if (setAd2 == null)  setAd2 = false;
     
        var setAd3 = parent.get("setAdmin3"); // Settings for Registration Checkbox
        if (setAd3 == null)  setAd3 = false;
        
        var forOrgUsed = false;
        
        if (setAd2 || rolArray.length != 0 || orgArray.length != 0) {
             document.f1.setAdmin2.checked = true;
             basedOnRoleOrg();
             if ( rolArray.length != 0) {
             	for (var i=0; i < o.<%=SegmentConstants.ELEMENT_ROLE%>.length; i++) {
             		var roleName = 	o.<%=SegmentConstants.ELEMENT_ROLE%>[i].role;
             		var roleDisplayName = new String();
             		var orgId = o.<%=SegmentConstants.ELEMENT_ROLE%>[i].org;
             		var orgName = '';
             		if (roleName == null || roleName == '') {
             			roleName = '<%=UIUtil.toJavaScript((String) userWizardNLS.get("allRoles"))%>';
             		} else {
						      for (var j=0; j < roleInternalNames.length; j++)
						      {  
						      	 if (roleName == roleInternalNames[j]) {
								        roleDisplayName = roleDisplayNames[j];
								        break;
						         }
						      }
             		}
             		
             		if (orgId == null || orgId == '') {
             			orgName = '<%=UIUtil.toJavaScript((String) userWizardNLS.get("allOrgs"))%>';
             			orgId = 'all';
             		}
             		else if (orgId == 'OrgAndAncestorOrgs') {
             			orgName = '<%=UIUtil.toJavaScript((String) userWizardNLS.get("forOrg"))%>';
             			forOrgUsed = true;
             		}
             		else if (orgArray.length == 0 || OrgArray.length == 0) {
             			for (var k=0; k < OrgNameArray.length; k++) {
             				if (orgId == OrgNameArray[k].orgId) {
             					orgName = OrgNameArray[k].name;
             				}
             			}
             		} else {			
             			for (var k=0; k < OrgArray.length; k++) {
             				if (orgId == OrgArray[k].orgId) {
             					orgName = OrgArray[k].name;
             				}
             			}
             		}
             
             		var displayName =  roleDisplayName + " - " + orgName;
             		var internalName = roleName + " - " + orgName;
             		document.f1.definedRoles.options[i] = new Option(displayName, internalName, false, false);
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
           		else if (orgId == 'OrgAndAncestorOrgs') {
           			orgName = '<%=UIUtil.toJavaScript((String) userWizardNLS.get("forOrg"))%>';
           		}
           		else {
           			for (var n=0; n < OrgArray.length; n++) {
           				if (orgId == OrgArray[n].orgId) {
           					orgName = OrgArray[n].name;
           				}
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
			     
				if (forOrgUsed) {
					if (!document.f1.setAdmin3.disabled) {
						document.f1.setAdmin3.checked = false;
						document.f1.setAdmin3.disabled = true;
					}
				}
		    else if (setAd3 || regArray != '<%=SegmentConstants.VALUE_DO_NOT_USE%>') {
		    	var reg = o.<%=SegmentConstants.ELEMENT_REGISTRATION_STATUS_OP%>;
		    	for (var i=0; i < document.f1.regList.length; i++) {
		    		if (reg == document.f1.regList[i].value) {
		    		   	document.f1.setAdmin3.checked = true;
		           	criteria = true;
		    			  document.f1.regList[i].selected = true;
		 			  }
		    	}
		    	basedOnReg();
		    }
		    
		    if ("<%=UIUtil.toJavaScript(orgId)%>" != null || "<%=UIUtil.toJavaScript(orgId)%>" != "") {
			    	//for (var j=0; j < document.f1.SelectOrg.length; j++) {
				 	// 	if ("<%=UIUtil.toJavaScript(orgId)%>" == document.f1.SelectOrg[j].value) {
				 	// 		document.f1.SelectOrg[j].selected = true;
				 	// 	}
				 	//}
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
      }

			if (parent.setContentFrameLoaded) {	
			    parent.setContentFrameLoaded(true);
			}
}
</script>

<!-- ******************************************************************** -->
<!-- *  START HERE --- Javascript Functions for Wiring the LUS Widget   * -->
<!-- ******************************************************************** -->
<script type="text/javascript" > 
<!---- hide script from old browsers
/////////////////////////////////////////////////////////////////////////////
// Function: LUS_Setup
// Desc.   : Register the GUI parts to the LUS Widget object instance
/////////////////////////////////////////////////////////////////////////////
function LUS_Setup()
{ 
   top.showProgressIndicator(true);
   lusWidget = new LUS_LookUpSelectionWidget
                     ('f1',
                      'LUS_SearchTextField',
                      'LUS_CriteriaDropDown',
                      'LUS_QuickTextEntry',
                      'LUS_SearchResultListBox',
                      'LUS_NumOfCurrentlyShowing',
                      '<%=UIUtil.toJavaScript((String)assignCustomersRB.get("LUS_Label_statusLine")) %> ');

   LUS_DataFrameInitialization();

}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: LUS_DataFrameInitialization
// Desc.   : Initialize the data frame for performing search action
/////////////////////////////////////////////////////////////////////////////
function LUS_DataFrameInitialization()
{
   var searchType   = 0;  // default to search all
   var searchString = ""; // default to wildcard search

   // Building the search parameter as a query string
   var queryString = "searchType="    + searchType
                   + "&searchString=" + searchString
                   + "&maxThreshold=" + "<%= UIUtil.toJavaScript((String)assignCustomersRB.get("LUS_MaxNumOfResultForOrgsSearch")) %>"
   
   // Construct the IFRAME as the data frame for getting the search result
    
   var webAppPath = "<%= UIUtil.getWebappPath(request) %>";

   with (document.f1) {    	  	    	  
   	var iframeElement = document.createElement('IFRAME');
   	 iframeElement.name = 'OABuyUserRoles_dataFrame';
   	 iframeElement.id = 'OABuyUserRoles_dataFrame';
         iframeElement.width = '0';
         iframeElement.height = '0';
         iframeElement.src = webAppPath + "OASearchForOrgsICanAdminView?"+ queryString + "'";
         iframeElement.title = ''; 
         iframeElement.style.display = 'none';
	 document.body.appendChild(iframeElement);

  }//end of with

}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: LUS_ProcessDataFrameSearchResults
// Desc.   : Process the search results from the data frame. This is a
//           call-back method invoking from the data frame after the frame
//           is loaded
/////////////////////////////////////////////////////////////////////////////

var LUS_isUsersDataFrameInitialized=false;

function LUS_ProcessDataFrameSearchResults()
{
 
  top.showProgressIndicator(false);
  with (document.f1) {   
   
   //-------------------------------------------------
   // Handle the first time of this page being loaded
   //-------------------------------------------------
   
   //the selected view is users

   var resultCondition = OABuyUserRoles_dataFrame.getSearchResultCondition();
  
       // Possible search result conditions:
       //    '0' - no match found
       //    '1' - match found within max. threshold
       //    '2' - match found exceeding max. threshold

   if (LUS_isUsersDataFrameInitialized==false)
      {
         // Toggle ON to skip this block for all subsequent calls
         LUS_isUsersDataFrameInitialized=true;
   
         if (resultCondition=='1')
         {
            
            // Re-wiring the data frame's result to LUS widget
            // and display the results in the resulting list box
            // and update the currently showing status line.                   
            lusWidget.LUS_setResultingList(OABuyUserRoles_dataFrame.getOrgNameList(),
                                           OABuyUserRoles_dataFrame.getOrgIdList());
	    //lusWidget.LUS_refreshCurrentlyShown();                                           
         }
         else if (resultCondition=='2')
         {
            // Too many entries, show msg in widget to let user type account name to search
            lusWidget.LUS_setSearchKeyword('<%=UIUtil.toJavaScript((String)assignCustomersRB.get("LUS_Label_keywordDefaultText")) %>', true);
            //lusWidget.LUS_refreshCurrentlyShown();
         }
         else if (resultCondition=='0')
         {
            // No entries avaliable in system, disable the widget              
            lusWidget.LUS_disableAll();
         }
   
        return;
   
   }//end-if (LUS_isUsersDataFrameInitialized==false)

   //----------------------------------------------------------
   // Process the search resulting data for various conditions
   //----------------------------------------------------------
   var msg = "";
   if (resultCondition=='0')
   {
      // No entries avaliable in system, disable the widget
      msg = "<%= UIUtil.toJavaScript((String)assignCustomersRB.get("LUS_Msg_NotFound")) %>";
      alertDialog(msg);
      return;
   }
   else if (resultCondition=='2')
   {
       // Too many entries
      msg = "<%= UIUtil.toJavaScript((String)assignCustomersRB.get("LUS_Msg_TooManyFound")) %>";
      var thresholdValue = new Number('<%= (String)assignCustomersRB.get("LUS_MaxNumOfResultForOrgsSearch") %>');
      if (isNaN(thresholdValue))
      {
         msg = msg.replace(/%1/, '100'); //default to 100 if invalid value
      }
      else
      {
         msg = msg.replace(/%1/, thresholdValue.toString());
      }
      alertDialog(msg);
      return;
   }
   else if (resultCondition=='1')
   {
      // Re-wiring the data frame's result to LUS widget
      // and display the results in the resulting list box
      // and update the currently showing status line. 	      
     lusWidget.LUS_setResultingList(OABuyUserRoles_dataFrame.getOrgNameList(),
                                     OABuyUserRoles_dataFrame.getOrgIdList());
     //lusWidget.LUS_refreshCurrentlyShown();
 
   }

  }//end with
}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: LUS_FindAction
// Desc.   : This triggers the search action in the data frame
/////////////////////////////////////////////////////////////////////////////
function LUS_FindAction()
{
   //lusWidget.LUS_clearComboBoxWithOutStatusLine();
   
   var searchType   = lusWidget.LUS_getSelectedCriteria();
   var searchString = lusWidget.LUS_getSearchKeyword();

   // Building the search parameter as a query string
   var queryString = "searchType="    + searchType
   		   + "&adminId=" + <%= cmdContext.getUserId() %>
                   + "&searchString=" + searchString
                   + "&maxThreshold=" + "<%= (String)assignCustomersRB.get("LUS_MaxNumOfResultForOrgsSearch") %>";
                   
  
   var webAppPath = "<%= UIUtil.getWebappPath(request) %>";
   
   with (document.f1) {      
            
 	  var newURL = webAppPath + 'OASearchForOrgsICanAdminView?' + queryString;
	  top.showProgressIndicator(true);
 	  OABuyUserRoles_dataFrame.location.replace(newURL);
 	
   }//end with(document.f1) 
}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: LUS_SelectResultItem
// Desc.   : Rewire the user selected item from the resuling list box to
//           trigger an action to retrieve a list of roles
/////////////////////////////////////////////////////////////////////////////
function LUS_SelectResultItem()
{
   var text = lusWidget.LUS_getSelectedResultNames();
   document.f1.LUS_QuickTextEntry.value = text[0];

   // Need to enable the Add button to allow user to add a role.
   document.f1.addButton.disabled = false;
  	document.f1.addButton.className='enabled';        
    document.f1.addButton.id='enabled';   

   var selectedItem = lusWidget.LUS_getSelectedResults();
   var webAppPath = "<%= UIUtil.getWebappPath(request) %>";
   var newURL = top.getWebappPath() + "BuyMemberGroupCriteriaView?segmentId=<%= UIUtil.toJavaScript(mbrGrpId) %>&memberGroupType=<%= UIUtil.toJavaScript(memberGroupType) %>&oid=" + selectedItem;
   top.showProgressIndicator(true);       
   OABuyUserRoles_RolesHelper_dataFrame.location.replace(newURL);
}
//-->
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
   with (document.f1) {
     	  	   
 	  	var iframeElement = document.createElement('IFRAME');
 	  	iframeElement.name = 'OABuyUserRoles_RolesHelper_dataFrame';
 	  	iframeElement.id = 'OABuyUserRoles_RolesHelper_dataFrame';
 	        iframeElement.width = '0';
 	        iframeElement.height = '0';
 	        iframeElement.src = webAppPath + "OAGetRolesForOrgView?oid=<%= UIUtil.toJavaScript(oid) %>";
 	        iframeElement.title = '';
 	        iframeElement.style.display = 'none';
 	    	document.body.appendChild(iframeElement);
 	    	  
  	}//end of with    
	
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
   var displayNames = OABuyUserRoles_RolesHelper_dataFrame.getRoleNameList();
   var internalNames = OABuyUserRoles_RolesHelper_dataFrame.getInternalRoleNameList();
   var ids = OABuyUserRoles_RolesHelper_dataFrame.getRoleIdList();
         
   if (ids.length==0)
   {
      var tmpOption = new Option('<%=UIUtil.toJavaScript((String)userWizardNLS.get("noRolesAvailable"))%>',
                                 'noroles');
      
      if (parent.document.f1 != null) {
      	// The very first time the page is loaded, we won't get here
	      parent.document.f1.DynaRolesDropDown.length = 1;     
	      parent.document.f1.DynaRolesDropDown.options[0] = tmpOption;
	    }
   }
   else
   {
      parent.document.f1.DynaRolesDropDown.length = ids.length;
      for (var i=0; i < ids.length; i++)
      {     
         var tmpOption = new Option(displayNames[i], internalNames[i]);  
         parent.document.f1.DynaRolesDropDown.options[i] = tmpOption;              
      }
   }

}//end-function

</script>
<!-- *********************************************************************** -->
<!-- *    END HERE --- Javascript Functions for Wiring the Role DropDown   * -->
<!-- *********************************************************************** -->




<SCRIPT>
 var allgrpList = null; 
 var originalList = null;
 var assignedList = null;
 var deletedList = null;
 var addedList = null;

function savePanelData()
{  
       
        var o = parent.get("<%=SegmentConstants.ELEMENT_SEGMENT_DETAILS%>", null);
        var org = new Array();
        var orgCount = 0;
        var role = new Array();
        var roleCount = 0;
        
	o.<%=SegmentConstants.ELEMENT_ROLE%> = new Array();
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
    			
    			o.<%=SegmentConstants.ELEMENT_ROLE%>[roleCount] = new Object();
    			o.<%=SegmentConstants.ELEMENT_ROLE%>[roleCount].role = rolId;
    			if (orgId != 'all') o.<%=SegmentConstants.ELEMENT_ROLE%>[roleCount].org = orgId;
    			roleCount++;
    		}
	} 
	
	if (document.f1.setAdmin3.checked) {
		var regIndex = document.f1.regList.selectedIndex;
		o.<%=SegmentConstants.ELEMENT_REGISTRATION_STATUS_OP%> = document.f1.regList[regIndex].value;
	
	} else {
		o.<%=SegmentConstants.ELEMENT_REGISTRATION_STATUS_OP%> = '<%=SegmentConstants.VALUE_DO_NOT_USE%>';
	}
  
  		<% if ((mbrGrpId == null || mbrGrpId.equals(""))) {  %>   		
  		//redirection based on Registration status 	
  		if (document.f1.setAdmin3.checked) {
  			var rIndex = document.f1.regList.selectedIndex;
			var userStatus = document.f1.regList[rIndex].value;
    			if(userStatus=='R')
  			{
    				parent.setNextBranch("Registration");    
  			}  	
  			else
  			{
    				parent.setNextBranch("Address");
  			}
  		}
  		<% } %>
  		
}  


function saveData()
{

}

////////////////////////////////////////////////////////////////
// Refresh Pages
////////////////////////////////////////////////////////////////

function refreshPage(s)
{
 	document.location.href = top.getWebappPath() + "UserRolesView";
}

function basedOnRoleOrg()
{
	
	if (document.f1.setAdmin2.checked) {
		document.all["setAdminArea2"].style.display = "block";	
		parent.put("setAdmin2", true);
	} else {
		document.all["setAdminArea2"].style.display = "none";	
    		parent.put("setAdmin2", false);
    	}
<% if ( (mbrGrpId == null || mbrGrpId.equals("")) && (!memberGroupType.equals("AccessGroup")) ) { %>
    	var thisPanelName = "CriteriaCustomerTerritoryGroups";
    	if (document.f1.setAdmin2.checked) {
    		parent.setCurrentPanelAttribute("hasNext", "NO");
    	}
    	if (document.f1.setAdmin3.checked) {
    		parent.setCurrentPanelAttribute("hasNext", "YES");
    	}
	parent.reloadFrames();
<% } %>
}    	
	


function basedOnReg()
{	
	if (document.f1.setAdmin3.checked) {
		document.all["setAdminArea3"].style.display = "block";
		parent.put("setAdmin3", true);
	} else {
		document.all["setAdminArea3"].style.display = "none";
    		parent.put("setAdmin3", false);
    		parent.setCurrentPanelAttribute("hasNext", "NO");
    	}

<% if ( (mbrGrpId == null || mbrGrpId.equals("")) && (!memberGroupType.equals("AccessGroup")) ) { %>
    	var thisPanelName = "CriteriaCustomerTerritoryGroups";
    	if (document.f1.setAdmin3.checked) {
    		parent.setCurrentPanelAttribute("hasNext", "YES");
    	} else {
    		parent.setCurrentPanelAttribute("hasNext", "NO");
    	}
	parent.reloadFrames();
<% } %>
}


////////////////////////////////////////////////////////////////
// Add Role
////////////////////////////////////////////////////////////////
function addRole()
{
	var OrgArray = new Array();
	
	var roleSelIndex = document.f1.DynaRolesDropDown.selectedIndex;
	var rId = document.f1.DynaRolesDropDown[roleSelIndex].value;
	
	   if (rId == 'noroles') {
	      alertDialog ("<%=UIUtil.toJavaScript((String)userWizardNLS.get("noRolesAvailableMsg")) %>");
	      return;
	   }
	
	var roleName = document.f1.DynaRolesDropDown[roleSelIndex].innerText;
	
	var oId = lusWidget.LUS_getSelectedResults();
	var orgName = lusWidget.LUS_getSelectedResultNames();
	
	if (document.f1.dynOrgs.checked) {
		oId = 'OrgAndAncestorOrgs'
		orgName = '<%=UIUtil.toJavaScript((String) userWizardNLS.get("forOrg"))%>';	
		
		<%-- Registration status and OrgAndAncestorOrgs attribute cannot coexist, disable the registration check box if this attribute is added --%>
		if (!document.f1.setAdmin3.disabled) {
			document.f1.setAdmin3.checked = false;
			document.f1.setAdmin3.disabled = true;
			document.all["setAdminArea3"].style.display = "none";
		}
	} 


	for (var kk=0; kk<document.f1.definedRoles.length; kk++)
	{
	     var newAdd = roleName + ' - ' + orgName;
	     if (newAdd == document.f1.definedRoles.options[kk].text)
	     { return; }
	}

   var newRole = parent.get("newRole");
    if (newRole == null) {
    	newRole = 0;
    } else {
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


}

////////////////////////////////////////////////////////////////
// Remove Role
////////////////////////////////////////////////////////////////
function removeRole()
{
   var selectionMade = false;

   for(var i = document.f1.definedRoles.length-1; i >= 0; i--) {
            if(document.f1.definedRoles[i].selected == true) {
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
               
                  document.f1.definedRoles.options[i] = null;
                  selectionMade = true;
            }
   }


    <%-- If nothing was selected, prompt the user to select something. --%>
    if (!selectionMade) {
      alertDialog ("<%=UIUtil.toJavaScript((String)userWizardNLS.get("noRoleSelected")) %>");
      return;
    } else {
	    <% if (memberGroupType.equals("AccessGroup")) { %> 
	    	<%-- Check if the rest of the defined roles has the OrgAndAncestorOrgs attribute set --%>
			var forOrgUsed = false;
			for (var i=0; i < document.f1.definedRoles.options.length; i++) {
				var x = document.f1.definedRoles.options[i].value;
				var index = x.indexOf(',');
				var orgId = x.substring(index + 1, x.length);
			
				if (orgId == 'OrgAndAncestorOrgs') {
					forOrgUsed = true;
					break;
				}
			}
			
			if (forOrgUsed) {
				if (!document.f1.setAdmin3.disabled) {
					document.f1.setAdmin3.checked = false;
					document.f1.setAdmin3.disabled = true;
				}
			}
			else {
				if (document.f1.setAdmin3.disabled) {
					document.f1.setAdmin3.disabled = false;
				}
			}
		<% } %>
	} 

    document.f1.removeButton.disabled = true;

}


</SCRIPT>

</head>
<BODY ONLOAD="initializeState();" class="content">

<H1><%=UIUtil.toHTML((String)userWizardNLS.get("Criteria"))%></H1>


   <FORM NAME='f1' >

   
       
       <TABLE BORDER='0' summary="<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralRoles"))%>">
       
<!------------------------------------------------------------------------------------>       
       <TR><TD>
       <LABEL for="setAdmin2"><INPUT id="setAdmin2" "name="setAdmin2" type="CheckBox" onClick="basedOnRoleOrg()"><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupBasedOnOrgRole"))%></LABEL>
       </TD></TR>
       <TR><TD>
       <DIV ID="setAdminArea2" STYLE="display:none;">
       
<!-- ******************************************************************** -->
<!-- *****        LUS Widget GUI Component Scope START HERE         ***** -->
<!-- ******************************************************************** -->
<table>
   <tbody>
      
      <tr> <!-- Building GUI Body Parts BEGIN ------------------------------>

         <!----------------------------------------------------------->
         <!-- Quick search text entry field with resulting list box -->
         <!----------------------------------------------------------->
         <td valign="top" id="LUS_TableCell_SelectAccount"><label for="LUS_FormInput_QuickTextEntry"><%= UIUtil.toHTML((String)assignCustomersRB.get("LUS_Label_selectOrg")) %></label><br />
            <table border="0">
               <tbody>
                  <tr>
                     <td id="LUS_TableCell_QuickNavigation">
                        <input  name="LUS_QuickTextEntry"
                                type="text"
                                size="20"
                                class="LUS_CSS_QuickTextEntryWidth"
                                onkeyup="javascript:lusWidget.LUS_autoNavigate();"
                                id="LUS_FormInput_QuickTextEntry" /><br />
                        <label for="LUS_SearchResultListBox1" class="hidden-label"><%= UIUtil.toHTML( (String)assignCustomersRB.get("SelectSearchResult") ) %></label>
                        <select name="LUS_SearchResultListBox" size="4"
                                onchange="javascript:LUS_SelectResultItem();"
                                class="LUS_CSS_ResultListBoxWidth"
                                single id='LUS_SearchResultListBox1'>
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
         <td valign="top" id="LUS_TableCell_SearchAccount"><label for="LUS_SearchTextField1"><%= UIUtil.toHTML((String)assignCustomersRB.get("LUS_Label_searchOrg")) %></label><br />
            <table border="0">
               <tbody>
                  <tr>
                     <td id="LUS_TableCell_KeywordSearch">
                     
                        <input  name="LUS_SearchTextField"
                                type="text"
                                size="20"
                                class="LUS_CSS_KeywordEntryWidth" 
                                id="LUS_SearchTextField1" /><br /> 
                        <label for="LUS_CriteriaDropDown1" class="hidden-label"><%= UIUtil.toHTML( (String)assignCustomersRB.get("SearchOptions") ) %></label>                          
                        <select name="LUS_CriteriaDropDown"
                                class="LUS_CSS_CriteriaListWidth" 
                                id="LUS_CriteriaDropDown1">
                           <option value="1"><%= UIUtil.toHTML( (String)userNLS.get("LUS_SearchType1") ) %></option>
                           <option value="2"><%= UIUtil.toHTML( (String)userNLS.get("LUS_SearchType2") ) %></option>
                           <option value="3"><%= UIUtil.toHTML( (String)userNLS.get("LUS_SearchType3") ) %></option>
                           <option value="4"><%= UIUtil.toHTML( (String)userNLS.get("LUS_SearchType4") ) %></option>
                           <option value="5"><%= UIUtil.toHTML( (String)userNLS.get("LUS_SearchType5") ) %></option>
                        </select><br /><br />
                     </td>
                  </tr>
                  <tr>
                     <td align="right" id="LUS_FormInput_FindAction">
                        <button name="LUS_ActionButton" class="general" onclick="javascript:LUS_FindAction();"><%= UIUtil.toHTML((String)assignCustomersRB.get("LUS_Label_findButton")) %></button><br />
                     </td>
                  </tr>
               </tbody>
            </table>
         </td>


      </tr> <!-- Building GUI Body Parts End ------------------------------->
  </tbody>
</table>

<!-- ******************************************** -->
<!-- **** New Dynamic Roles List Dropdown GUI *** -->
<!-- ******************************************** -->
<table>
   <tbody>
      <tr>
         <td><label for="DynaRolesDropDown1"><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupRoleSelectionName"))%></label><br />
            <select name="DynaRolesDropDown" id="DynaRolesDropDown1">
            <option value="noroles"><%=UIUtil.toHTML((String)userWizardNLS.get("noRolesAvailable"))%></option>
            </select>
         </td>
      </tr>
   </tbody>
</table>
<table>
   <tbody> 
<%
  if (memberGroupType.equals("AccessGroup")) {
%> 
   <TR><TD>
			<LABEL for="forOrg"><INPUT id="forOrg" TYPE="CheckBox" NAME="dynOrgs" SIZE="1"><%=UIUtil.toHTML((String)userWizardNLS.get("forOrg"))%></LABEL>
	</TD></TR>
<% } else { %>  
	<TR><TD>  
			<INPUT TYPE="HIDDEN" NAME="dynOrgs" VALUE="false">
	</TD></TR>				
<% } %>   
	<TR>
       	<TD ALIGN="LEFT"><LABEL for="definedRoles1"><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupSelRoleOrg"))%></LABEL></TD>
    </TR>
    <TR>
    	<TD VALIGN="BOTTOM" CLASS="selectWidth">
         
    		<SELECT NAME="definedRoles" SIZE='5' class="LUS_CSS_QuickTextEntryWidth" MULTIPLE onChange="updateSloshBuckets(this, document.f1.removeButton, document.f1.LUS_SearchResultListBox, document.f1.addButton)" id="definedRoles1">
			</SELECT>
		</TD>
		<TD align="left" CLASS="selectWidth" id="FormInput_AddAndRemoveAction">
		    <button name="addButton" onclick="addRole()"><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupAdd"))%></button><br /><br />
		    <button name="removeButton" onclick="removeRole()"><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupRemove"))%></button>
		    
		</TD>
	</TR>
</tbody>
</table>


<!-- ******************************************************************** -->
<!-- *****        LUS Widget GUI Component Scope END HERE           ***** -->
<!-- ******************************************************************** -->

<%
String basedOnRegStatusKey = "memberGroupBasedOnCustInfo";
if (memberGroupType.equals("AccessGroup")) {
	basedOnRegStatusKey = "memberGroupBasedOnReg";
}
%>    

           <TR><TD>
           <LABEL for="baseOnReg"><INPUT id="baseOnReg" TYPE="CheckBox" NAME="setAdmin3" SIZE="1" onClick="basedOnReg()"><%=UIUtil.toHTML((String)userWizardNLS.get(basedOnRegStatusKey))%></LABEL>
           </TR></TR>
           <TR><TD>
           <DIV ID="setAdminArea3" STYLE="display:none;">
              <TABLE BORDER='0' summary="<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralRoles"))%>">
       
		<TR><TD><label for="regList1"><%=UIUtil.toHTML((String)userWizardNLS.get("registrationStatus"))%></label><BR>
		<SELECT NAME="regList" id="regList1">
			<OPTION  VALUE="G">
  <%
   	if (memberGroupType.equals("AccessGroup")) {
  %> 
			<%=UIUtil.toHTML((String)userWizardNLS.get("guest"))%>
  <% 
  	} else {
  %>
  	   		<%=UIUtil.toHTML((String)userWizardNLS.get("guest2"))%>
  <% 
  	} 
  %>			
			</OPTION>
			<OPTION  VALUE="R">
  <%
   	if (memberGroupType.equals("AccessGroup")) {
  %> 
			<%=UIUtil.toHTML((String)userWizardNLS.get("registered"))%>
  <% 
  	} else {
  %>
  	   		<%=UIUtil.toHTML((String)userWizardNLS.get("registered2"))%>
  <% 
  	} 
  %>
			</OPTION>
  <%
   	if (memberGroupType.equals("AccessGroup")) {
   %> 			
			<OPTION  VALUE="A"><%=UIUtil.toHTML((String)userWizardNLS.get("admin"))%></OPTION>
			<OPTION  VALUE="S"><%=UIUtil.toHTML((String)userWizardNLS.get("siteAdmin"))%></OPTION>
  <% 
  	} 
  %>			
	      	</SELECT>   
		</TD></TR>	
		
		<INPUT TYPE="HIDDEN" NAME="memberGroupType" VALUE="<%= UIUtil.toHTML(memberGroupType) %>">	
			
		
	      </TABLE>       
           </DIV>   
           </TD></TR>
           </TABLE>
       </DIV>  
       </TD></TR>
       </TABLE>
    
          
  
  </FORM>
<!-- Initialize the LUS Widget & Roles List Data Frame -->
<script type="text/javascript">
   LUS_Setup();   
   RolesHelper_Setup();
    
   
</script>
</body>
</html>
