<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//* 
//* (c) Copyright IBM Corp. 2004, 2016
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
<%@ page import="com.ibm.commerce.tools.segmentation.SegmentCustomerListDataBean"   %>
<%@ page import="com.ibm.commerce.ras.ECTrace" %>
<%@ page import="com.ibm.commerce.ras.ECTraceIdentifiers" %>


<%@ include file="../common/common.jsp" %>


<%
   CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   String webalias = UIUtil.getWebPrefix(request);   
   Locale locale = cmdContext.getLocale();
    
   Hashtable userNLS = (Hashtable)ResourceDirectory.lookup("csr.userNLS", locale);
   Hashtable assignCustomersRB = (Hashtable)ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", locale );
	
    
   Hashtable userWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
   if (userWizardNLS == null) System.out.println("!!!! RS is null");
            
%>

<%

   // Parameters may be encrypted. Use JSPHelper to get URL parameter
   // instead of request.getParameter().
   JSPHelper jhelper = new JSPHelper(request);
   String mbrGrpId = jhelper.getParameter("segmentId");
   SegmentCustomerListDataBean.Customer[] includedCustomers = null;
   SegmentCustomerListDataBean.Customer[] excludedCustomers = null;
   
   if (mbrGrpId != null && !mbrGrpId.equals("")) {
   	SegmentCustomerListDataBean includedCustomerList = new SegmentCustomerListDataBean();
   	includedCustomerList.setView("explicitlyIncluded");
   	includedCustomerList.setCheckStore("false");
   	DataBeanManager.activate(includedCustomerList, request);
   	includedCustomers = includedCustomerList.getCustomerList();

   	SegmentCustomerListDataBean excludedCustomerList = new SegmentCustomerListDataBean();
   	excludedCustomerList.setView("explicitlyExcluded");
   	excludedCustomerList.setCheckStore("false");
   	DataBeanManager.activate(excludedCustomerList, request);
   	excludedCustomers = excludedCustomerList.getCustomerList();
   }

%>
   

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<%= fHeader%>

<style type='text/css'>
.selectWidth {width: 350px;}
</style>

<!-------------------------------------------->
<!-- Define the CSS for the LUS's GUI parts -->
<!-------------------------------------------->
<style type='text/css'>
.LUS_CSS_QuickTextEntryWidth {width: 501px;}
.LUS_CSS_ResultListBoxWidth  {width: 500px;}
.LUS_CSS_KeywordEntryWidth   {width: 200px;}
.LUS_CSS_CriteriaListWidth   {width: auto; }
</style>

<!-------------------------------------------->
<!-- Import the LUS Widget Model javascript -->
<!-------------------------------------------->
<script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/common/LUSWidgetModel.js"></script>
<SCRIPT SRC="<%=webalias%>javascript/tools/segmentation/SegmentNotebook.js"></SCRIPT>
<script language="JavaScript" src="/wcs/javascript/tools/common/Vector.js"></script>

<%        
   String userId = null;    
   String lang = null;
   String viewtaskname = null;
   String ActionXMLFile = null;
   String cmd = null;
   String memberGroupType = null;
   String returningUserCriteria = "1";
        
   if( cmdContext!= null )
   {
      locale = cmdContext.getLocale();
      lang = cmdContext.getLanguageId().toString();
      userId = cmdContext.getUserId().toString();
   }

     
   viewtaskname = (String) request.getParameter("viewname");
   ActionXMLFile = (String) request.getParameter("ActionXMLFile");
   cmd = (String) request.getParameter("cmd");
   memberGroupType = (String) request.getParameter("memberGroupType");
   if (memberGroupType.equals("AccessGroup")) {
      returningUserCriteria = "3";
   } else if (memberGroupType.equals("PriceOverrideGroup") || memberGroupType.equals("ServiceRepGroup")) {
      returningUserCriteria = "2";
   }
 
   // obtain the resource bundle for display
   Hashtable resourcegroupListNLS = (Hashtable)ResourceDirectory.lookup("policyeditor.policyeditorNLS", locale);      
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupSelectMembersTitle"))%></TITLE>



<script LANGUAGE="JavaScript1.2" SRC="/wcs/javascript/tools/common/SwapList.js"></script>
<SCRIPT LANGUAGE="JavaScript1.2" SRC="/wcs/javascript/tools/common/ExitValidate.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT Language="JavaScript">

function initializeState()
{
	
	LUS_Setup(); 
	loadUsers();
    parent.setContentFrameLoaded(true);
 
}

function savePanelData()
{
	saveUsers();
}

function doPrompt (field,msg)
{
    alertDialog(msg);
    field.focus();
}


function addToSelectedResources(allst, selectionObject, otherSelectionObject) {
	var addId = allst;
	var usersSelectedArray = getStringOptionValues(selectionObject);
	var notAdded = true;
	for (var i=0; i<usersSelectedArray.length; i++) {	
		if (allst==usersSelectedArray[i]) {
			notAdded = false;
		}
	}
	var anotherArray = getStringOptionValues(otherSelectionObject);
	var notAddedInOther = true;
	for (var i=0; i<anotherArray.length; i++) {	
		if (allst==anotherArray[i]) {
			notAddedInOther = false;
		}
	} 
	if (notAdded && notAddedInOther) {
		var fromList = document.selectUsersForm.LUS_SearchResultListBox;
		var toList = selectionObject;
		
	 	for(var i=0; i<fromList.options.length; i++) {
    		if(fromList.options[i].selected && fromList.options[i].value != "") {
       			var no = new Option();
       			no.value = fromList.options[i].value;
       			no.text = fromList.options[i].text;
       			toList.options[toList.options.length] = no;
    		}
		}
	
    }
}

function removeFromSelectedResources(selectionObject) {   

    	for(var i=selectionObject.options.length-1; i>=0; i--) {
    		if(selectionObject.options[i].selected) selectionObject.options[i] = null;
  	} 
  
}
</SCRIPT>
 
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
                     ('selectUsersForm',
                      'LUS_SearchTextField',
                      'LUS_CriteriaDropDown',
                      'LUS_QuickTextEntry',
                      'LUS_SearchResultListBox',
                      'LUS_NumOfCurrentlyShowing',
                      '<%=UIUtil.toJavaScript((String)assignCustomersRB.get("LUS_Label_statusLineACOrg")) %> ');
 
   LUS_DataFrameInitialization();
   
}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: LUS_DataFrameInitialization
// Desc.   : Initialize the data frame for performing search action
/////////////////////////////////////////////////////////////////////////////
function LUS_DataFrameInitialization()
{  <% //System.out.println("Enter LUS_DataFrameInitialization"); %>
   var searchType   = 0;  // default to search all
   var searchString = ""; // default to wildcard search
   var returningUserCriteria = "<%= returningUserCriteria %>";

   // Building the search parameter as a query string
   var queryString = "searchType="    + searchType
                   + "&adminId=" + <%= cmdContext.getUserId() %>
                   + "&searchString=" + searchString
                   + "&returningUserCriteria=" + returningUserCriteria
                   + "&maxThreshold=" + "<%= UIUtil.toJavaScript((String)assignCustomersRB.get("LUS_MaxNumOfResultForACSearch")) %>"
                   + "&firstLoad=1";
 
   // Construct the IFRAME as the data frame for getting the search result
   
   var webAppPath = "<%= UIUtil.getWebappPath(request) %>";

<% if (memberGroupType.equals("RegisteredCustomersGroup")) { %>

 	  	var iframeElement = document.createElement('IFRAME');
 	  	iframeElement.name = 'ACSearchForOrgsICanAdmin_dataFrame';
 	  	iframeElement.id = 'ACSearchForOrgsICanAdmin_dataFrame';
 	        iframeElement.width = '0';
 	        iframeElement.height = '0';
 	        iframeElement.src = "ACSearchForOrgsICanAdminView?"+ queryString + "'";
 	        iframeElement.title = '';
 	        document.body.appendChild(iframeElement);       
                   
<% } else { %>
 	  	var iframeElement = document.createElement('IFRAME');
 	  	iframeElement.name = 'ACSearchForUsersICanAdmin_dataFrame';
 	  	iframeElement.id = 'ACSearchForUsersICanAdmin_dataFrame';
 	        iframeElement.width = '0';
 	        iframeElement.height = '0';
 	        iframeElement.src = "ACSearchForUsersICanAdminView?"+ queryString + "'";
 	        iframeElement.title = '';
 	    	document.body.appendChild(iframeElement);

<% } %>
   
}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: LUS_ProcessDataFrameSearchResults
// Desc.   : Process the search results from the data frame. This is a
//           call-back method invoking from the data frame after the frame
//           is loaded
/////////////////////////////////////////////////////////////////////////////
<% if (memberGroupType.equals("RegisteredCustomersGroup")) { %>
var LUS_isOrgsDataFrameInitialized=false;
<% } else { %>
var LUS_isUsersDataFrameInitialized=false;
<% } %>

function LUS_ProcessDataFrameSearchResults()
{

  top.showProgressIndicator(false);
	
   //-------------------------------------------------
   // Handle the first time of this page being loaded
   //-------------------------------------------------
<% if (memberGroupType.equals("RegisteredCustomersGroup")) { %>
  
  //the selected view is organizations
   var resultCondition = ACSearchForOrgsICanAdmin_dataFrame.getSearchResultCondition();
  
       // Possible search result conditions:
       //    '0' - no match found
       //    '1' - match found within max. threshold
       //    '2' - match found exceeding max. threshold
   
   if (LUS_isOrgsDataFrameInitialized==false)
      {
         // Toggle ON to skip this block for all subsequent calls
         LUS_isOrgsDataFrameInitialized=true;
   
         if (resultCondition=='1')
         {
            // Re-wiring the data frame's result to LUS widget
            // and display the results in the resulting list box
            // and update the currently showing status line.      
            lusWidget.LUS_setResultingList(ACSearchForOrgsICanAdmin_dataFrame.getOrgNameList(),
                                           ACSearchForOrgsICanAdmin_dataFrame.getOrgIdList());
         }
         else if (resultCondition=='2')
         {
            // Too many entries, show msg in widget to let user type account name to search
            lusWidget.LUS_setSearchKeyword('<%=UIUtil.toJavaScript((String)assignCustomersRB.get("LUS_Label_keywordDefaultTextOrgs")) %> ', true);
        }
         else if (resultCondition=='0')
         {
            // No entries avaliable in system, disable the widget
            lusWidget.LUS_disableAll();
         }
   
        return;
   
   }//end-if (LUS_isOrgsDataFrameInitialized==false)

<% } else { %>

   var resultCondition = ACSearchForUsersICanAdmin_dataFrame.getSearchResultCondition();
      
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
            lusWidget.LUS_setResultingList(ACSearchForUsersICanAdmin_dataFrame.getUserNameList(),
                                           ACSearchForUsersICanAdmin_dataFrame.getUserIdList());
         }
         else if (resultCondition=='2')
         {
            // Too many entries, show msg in widget to let user type account name to search
            lusWidget.LUS_setSearchKeyword('<%=UIUtil.toJavaScript((String)assignCustomersRB.get("LUS_Label_keywordDefaultTextUsers")) %> ', true);
         }
         else if (resultCondition=='0')
         {
            // No entries avaliable in system, disable the widget
            lusWidget.LUS_disableAll();
         }
   
        return;
   
   }//end-if (LUS_isUsersDataFrameInitialized==false)

<% } %> 

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
      var thresholdValue = new Number('<%= (String)assignCustomersRB.get("LUS_MaxNumOfResultForACSearch") %>');
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
<% if (memberGroupType.equals("RegisteredCustomersGroup")) { %>
        
      	lusWidget.LUS_setResultingList(ACSearchForOrgsICanAdmin_dataFrame.getOrgNameList(),
                                           ACSearchForOrgsICanAdmin_dataFrame.getOrgIdList());

<% } else { %>

     	lusWidget.LUS_setResultingList(ACSearchForUsersICanAdmin_dataFrame.getUserNameList(),
                                           ACSearchForUsersICanAdmin_dataFrame.getUserIdList());          	
<% } %>

   }

 
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
   var returningUserCriteria = "<%= returningUserCriteria %>";

   // Building the search parameter as a query string
   var queryString = "searchType="    + searchType
   		   + "&adminId=" + <%= cmdContext.getUserId() %>
                   + "&searchString=" + searchString
                   + "&returningUserCriteria=" + returningUserCriteria
                   + "&maxThreshold=" + "<%= (String)assignCustomersRB.get("LUS_MaxNumOfResultForACSearch") %>";
                   
  
   var webAppPath = "<%= UIUtil.getWebappPath(request) %>";
   
<% if (memberGroupType.equals("RegisteredCustomersGroup")) { %>
  	  var newURL = webAppPath + 'ACSearchForOrgsICanAdminView?' + queryString;
	  top.showProgressIndicator(true);
 	  ACSearchForOrgsICanAdmin_dataFrame.location.replace(newURL);
 	  
<% } else { %>     
 	  var newURL = webAppPath + 'ACSearchForUsersICanAdminView?' + queryString;
	  top.showProgressIndicator(true);
 	  ACSearchForUsersICanAdmin_dataFrame.location.replace(newURL);
 	  
<% } %>

}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: LUS_SelectResultItem
// Desc.   : Rewire the user selected item from the resuling list box to
//           the expected form's field.
/////////////////////////////////////////////////////////////////////////////
function LUS_SelectResultItem()
{
   var text = lusWidget.LUS_getSelectedResultNames();
   document.selectUsersForm.LUS_QuickTextEntry.value = text[0];
   
   // Need to enable the Add button to allow user to add.
   this.document.selectUsersForm.addButtonInclude.disabled = false;
   this.document.selectUsersForm.addButtonInclude.className='enabled';
   this.document.selectUsersForm.addButtonInclude.id='enabled';

   // Need to enable the Add button to allow user to add.
   this.document.selectUsersForm.addButtonExclude.disabled = false;
   this.document.selectUsersForm.addButtonExclude.className='enabled';
   this.document.selectUsersForm.addButtonExclude.id='enabled';
   
   //disable the Remove button
   this.document.selectUsersForm.removeButtonInclude.disabled = true;
   this.document.selectUsersForm.removeButtonInclude.className='disabled';
   this.document.selectUsersForm.removeButtonInclude.id='disabled';

   //disable the Remove button
   this.document.selectUsersForm.removeButtonExclude.disabled = true;
   this.document.selectUsersForm.removeButtonExclude.className='disabled';
   this.document.selectUsersForm.removeButtonExclude.id='disabled';
    
   removeFocus(this.document.selectUsersForm.usersSelectedToInclude);
   removeFocus(this.document.selectUsersForm.usersSelectedToExclude); 
    
}
//-->
</script>

<!-- ******************************************************************** -->
<!-- *   END HERE --- Javascript Functions for Wiring the LUS Widget    * -->
<!-- ******************************************************************** -->







<script type="text/javascript" >
<!---- hide script from old browsers 
 
 function loadUsers () {
	with (document.selectUsersForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {		
				loadStringOptionValuesForIncludedMembers ();
				loadStringOptionValuesForExcludedMembers ();	
			}
		}	
	}
}

function loadStringOptionValuesForIncludedMembers () {
		var select = document.selectUsersForm.usersSelectedToInclude;			
		var userArray = new Array();		
		userArray = parent.get("selectedObjectsToInclude", null);		
		if (userArray != null){
			for (var i=0; i<userArray.length; i++) {			
				var id = userArray[i][1];
				var loginName = userArray[i][2];
				select.options[i] = new Option(loginName,id);							
			}
		} else {
			<%	
			if (includedCustomers != null) {
				SegmentCustomerListDataBean.Customer includedCustomer;
				for (int i=0; i<includedCustomers.length; i++) {
					includedCustomer = includedCustomers[i]; 			
			%>		
					select.options[<%= i %>] = new Option('<%= UIUtil.toJavaScript(includedCustomer.getLogonId()) %>','<%= includedCustomer.getId() %>');					
			<% 
				}
			}
			%>
		}
}

function loadStringOptionValuesForExcludedMembers () {
		var select = document.selectUsersForm.usersSelectedToExclude;			
		var userArray = new Array();		
		userArray = parent.get("selectedObjectsToExclude", null);		
		if (userArray != null){
			for (var i=0; i<userArray.length; i++) {			
				var id = userArray[i][1];
				var loginName = userArray[i][2];
				select.options[i] = new Option(loginName,id);							
			}
		} else {
			<%
			if (excludedCustomers != null) {
				SegmentCustomerListDataBean.Customer exludedCustomer;
				for (int i=0; i<excludedCustomers.length; i++) {
					exludedCustomer = excludedCustomers[i]; 			
			%>		
					select.options[<%= i %>] = new Option('<%= UIUtil.toJavaScript(exludedCustomer.getLogonId()) %>','<%= exludedCustomer.getId() %>');					
			<% 
				}
			}
			%>   
		}
}


function getStringOptionValues (select) {
	var values = new Array();
	for (var i=0; i<select.length; i++) {
		values[i] = select.options[i].value;		
	}
	return values;
}

function removeFocus(select) {		
	for (var i=0; i<select.options.length; i++){
     	select.options[i].selected = false;     	     	
	}		
}

function removeAvailableUsersFocus(select) {		
    select.selected = false;   	     	
	select.selectedIndex = -1;			
}


function getSelectedObjects (select) {		
	var myArray = new Array(select.length);	
	for (var i=0; i<select.length; i++) {	
		myArray[i] = new Array(2);		
		myArray[i][1] = select.options[i].value;
		myArray[i][2] = select.options[i].text;		
	}	
	return myArray;
}

function saveUsers () { 

  	var o = parent.get("<%=SegmentConstants.ELEMENT_SEGMENT_DETAILS%>", null);
  	o.<%= SegmentConstants.ELEMENT_INCLUDE_MEMBERS_LIST %> = getStringOptionValues(document.selectUsersForm.usersSelectedToInclude);
  	o.<%= SegmentConstants.ELEMENT_EXCLUDE_MEMBERS_LIST %> = getStringOptionValues(document.selectUsersForm.usersSelectedToExclude);
	o.<%= SegmentConstants.PARAMETER_PERFORM_DELETE %> = "true";
	
	var segmentId = o.<%= SegmentConstants.ELEMENT_ID %>;
	//var selectedArray = getStringOptionValues(document.selectUsersForm.usersSelected);
	parent.put("selectedObjectsToInclude", getSelectedObjects(document.selectUsersForm.usersSelectedToInclude));
	parent.put("selectedObjectsToExclude", getSelectedObjects(document.selectUsersForm.usersSelectedToExclude));
	
	//if( segmentId != "" & selectedArray.length == 0)
        //{  		 		
 		
 	//	var urlRemove = "<%= SegmentConstants.URL_SEGMENT_REMOVE_USER %>"+segmentId+"&<%= SegmentConstants.PARAMETER_EXCLUDED_USERS + "=false&" + SegmentConstants.PARAMETER_ALL_USERS + "=true" %>";
	//	top.setReturningPanel("GeneralInfo");
	//	top.setContent("", urlRemove, false);
	//}	
	 
	
}
//-->
</script> 
 
 
 
 
</HEAD>

<BODY ONLOAD="initializeState();" class="content">
<H1><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupSelectMembersTitle"))%></H1>
 
<form name="selectUsersForm" METHOD="POST" >

     <INPUT TYPE="HIDDEN" NAME="explicit" VALUE="yes"> 
    
    
    
<!-- ******************************************************************** -->
<!-- *****        LUS Widget GUI Component Scope START HERE         ***** -->
<!-- ******************************************************************** -->

<table>
   <tbody>
      
      <tr> <!-- Building GUI Body Parts BEGIN ------------------------------>

         <!----------------------------------------------------------->
         <!-- Quick search text entry field with resulting list box -->
         <!----------------------------------------------------------->
         <td valign="top" id="LUS_TableCell_SelectAccount"><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupAvailableMembers"))%><br />
            <table border="0">
               <tbody>
                  <tr>
                     <td id="LUS_TableCell_QuickNavigation">
                     <label for="LUS_FormInput_QuickTextEntry"></label>
                        <input  name="LUS_QuickTextEntry"
                                type="text"
                                size="20"
                                class="LUS_CSS_QuickTextEntryWidth"
                                onkeyup="javascript:lusWidget.LUS_autoNavigate();"
                                id="LUS_FormInput_QuickTextEntry" /><br />
                        <label for="LUS_SearchResultListBox1"></label>
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
         <td valign="top" id="LUS_TableCell_SearchAccount"><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupSearch"))%><br />
            <table border="0">
               <tbody>
                  <tr>
                     <td id="LUS_TableCell_KeywordSearch">
                     <label for="LUS_SearchTextField1"></label>  
                        <input  name="LUS_SearchTextField"
                                type="text"
                                size="20"
                                class="LUS_CSS_KeywordEntryWidth" 
                                id='LUS_SearchTextField1' /><br /> 
                        <label for="LUS_CriteriaDropDown1"></label>                                      
                        <select name="LUS_CriteriaDropDown"
                                class="LUS_CSS_CriteriaListWidth" 
                                id='LUS_CriteriaDropDown1'>
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
                        <button name="LUS_ActionButton" class="general" onclick="javascript:LUS_FindAction();"><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupFind"))%></button><br />
                     </td>
                  </tr>
               </tbody>
            </table>
         </td>


      </tr> <!-- Building GUI Body Parts End ------------------------------->
  </tbody>
</table>

<!-- ******************************************************************** -->
<!-- *****        Explicitly included members                       ***** -->
<!-- ******************************************************************** -->
<table>
   <tbody>
      
     
	<TR>
       	<TD ALIGN="LEFT"><LABEL for="usersSelectedToInclude"><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupSelectedMembersToInclude"))%></LABEL></TD>
    </TR>
    <TR>
    	<TD VALIGN="BOTTOM" CLASS="selectWidth">
         
    		<SELECT NAME="usersSelectedToInclude" SIZE='5' class="LUS_CSS_QuickTextEntryWidth" MULTIPLE  onChange="removeAvailableUsersFocus(this.document.selectUsersForm.LUS_SearchResultListBox);updateSloshBuckets(document.selectUsersForm.usersSelectedToInclude, document.selectUsersForm.removeButtonInclude, this.document.selectUsersForm.LUS_SearchResultListBox, document.selectUsersForm.addButtonInclude)"  id="usersSelectedToInclude">
			</SELECT>
		</TD>
		<TD align="left" CLASS="selectWidth" id="FormInput_AddAndRemoveAction">
		    <button name="addButtonInclude" onclick="addToSelectedResources(document.selectUsersForm.LUS_SearchResultListBox.value, document.selectUsersForm.usersSelectedToInclude, document.selectUsersForm.usersSelectedToExclude)"><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupAdd"))%></button><br /><br />
		    <button name="removeButtonInclude" onclick="removeFromSelectedResources(document.selectUsersForm.usersSelectedToInclude)"><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupRemove"))%></button>
		    
		</TD>
	</TR>
</tbody>
</table>

<!-- ******************************************************************** -->
<!-- *****        Explicitly excluded members                       ***** -->
<!-- ******************************************************************** -->
<table>
   <tbody>
      
     
	<TR>
       	<TD ALIGN="LEFT"><LABEL for="usersSelectedToExclude"><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupSelectedMembersToExclude"))%></LABEL></TD>
    </TR>
    <TR>
    	<TD VALIGN="BOTTOM" CLASS="selectWidth">
         
    		<SELECT NAME="usersSelectedToExclude" SIZE='5' class="LUS_CSS_QuickTextEntryWidth" MULTIPLE  onChange="removeAvailableUsersFocus(this.document.selectUsersForm.LUS_SearchResultListBox);updateSloshBuckets(document.selectUsersForm.usersSelectedToExclude, document.selectUsersForm.removeButtonExclude, this.document.selectUsersForm.LUS_SearchResultListBox, document.selectUsersForm.addButtonExclude)"  id="usersSelectedToExclude">
			</SELECT>
		</TD>
		<TD align="left" CLASS="selectWidth" id="FormInput_AddAndRemoveAction">
		    <button name="addButtonExclude" onclick="addToSelectedResources(document.selectUsersForm.LUS_SearchResultListBox.value, document.selectUsersForm.usersSelectedToExclude, document.selectUsersForm.usersSelectedToInclude)"><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupAdd"))%></button><br /><br />
		    <button name="removeButtonExclude" onclick="removeFromSelectedResources(document.selectUsersForm.usersSelectedToExclude)"><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupRemove"))%></button>
		    
		</TD>
	</TR>
</tbody>
</table>





 

<!-- ******************************************************************** -->
<!-- *****        LUS Widget GUI Component Scope END HERE           ***** -->
<!-- ******************************************************************** -->
    
    
    
    
    
    
</FORM>
</BODY>
</HTML>

