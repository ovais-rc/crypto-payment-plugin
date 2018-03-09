<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %> 
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.ras.ECTrace" %>
<%@ page import="com.ibm.commerce.ras.ECTraceIdentifiers" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.user.utils.ServiceRepresentativeUtil" %>
<%@ page import="com.ibm.commerce.member.constants.ECMemberCommandParameterConstants" %>

<%@include file="../common/common.jsp" %>

<%
    CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale jLocale = cmdContext.getLocale();
    Hashtable assignCustomersRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", jLocale );
	
    String webalias = UIUtil.getWebPrefix(request);
    String jHeader = "<meta http-equiv='Cache-Control' content='no-cache'>" + "<link rel='stylesheet' href='" + UIUtil.getCSSFile(jLocale) + "'>";	
%>
<%= jHeader %>

<%  JSPHelper jhelper= new JSPHelper(request);
    String usersId = jhelper.getParameter("usersId");
   
     Long [] customerIds = null;
     
     try{
     	customerIds = ServiceRepresentativeUtil.getAllAssignedCustomers(new Long(usersId));
     }catch(Exception e){
        ECTrace.trace(ECTraceIdentifiers.COMPONENT_USER,
	                    "tools/buyerconsole/AssignCustomersDialog.jsp",
	                    "getAllAssignedCustomers","Exception on getting all assigned customers");
     }
  
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!-------------------------------------------->
<!-- Import the LUS Widget Model javascript -->  
<!-------------------------------------------->
<script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/common/LUSWidgetModel.js"></script>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!---- hide script from old browsers
function loadPanelData()
{   
   if (parent.setContentFrameLoaded){
        parent.setContentFrameLoaded(true);
   }
  
   <% for (int i= 0; i<customerIds.length; i++){
          String memberName = ServiceRepresentativeUtil.getMemberNameByMemberIdWithParentOrgName(customerIds[i]);
    %>
 	document.assignCustForm.AssignedCustomerBox.options[<%= i %>] = 
   		new Option("<%= UIUtil.toJavaScript(memberName)%>","<%= customerIds[i] %>", false, false);       
   <%                               
   } %>
      
   LUS_Setup();    
}

function changeView(){
     with (document.assignCustForm) {
  		var selectValue = SelectView.options[SelectView.selectedIndex].value;
  			if(selectValue == 1){
          			document.all["LUS_TableCell_SelectText_Label"].innerText  = "<%= UIUtil.toJavaScript( assignCustomersRB.get("assignCustSelectCustomerGroups") ) %>";
          			document.all["LUS_TableCell_SearchText_Label"].innerText  = "<%= UIUtil.toJavaScript( assignCustomersRB.get("assignCustSearchCustomerGroups") ) %>";
          			
          			LUS_isCustGrpsDataFrameInitialized=false;
				LUS_isOrgsDataFrameInitialized=false;
				LUS_isUsersDataFrameInitialized=false;
				lusWidget.LUS_enableAll();
          			lusWidget.LUS_clearComboBoxAllWithOutStatusLine();
          			LUS_Setup();
          		}else if (selectValue == 2){
          			document.all["LUS_TableCell_SelectText_Label"].innerText = "<%= UIUtil.toJavaScript( assignCustomersRB.get("assignCustSelectOrganizations") ) %>";
          			document.all["LUS_TableCell_SearchText_Label"].innerText = "<%= UIUtil.toJavaScript( assignCustomersRB.get("assignCustSearchOrganizations") ) %>";
				LUS_isCustGrpsDataFrameInitialized=false;
				LUS_isOrgsDataFrameInitialized=false;
				LUS_isUsersDataFrameInitialized=false;
				lusWidget.LUS_enableAll();
         			lusWidget.LUS_clearComboBoxAllWithOutStatusLine();
         			LUS_Setup();
               		}else if (selectValue == 3){
          		        document.all["LUS_TableCell_SelectText_Label"].innerText = "<%= UIUtil.toJavaScript( assignCustomersRB.get("assignCustSelectUsers") ) %>";
          				document.all["LUS_TableCell_SearchText_Label"].innerText = "<%= UIUtil.toJavaScript( assignCustomersRB.get("assignCustSearchUsers") ) %>";
         			LUS_isCustGrpsDataFrameInitialized=false;
				LUS_isOrgsDataFrameInitialized=false;
				LUS_isUsersDataFrameInitialized=false;
				lusWidget.LUS_enableAll();
         			lusWidget.LUS_clearComboBoxAllWithOutStatusLine();
          			LUS_Setup();	
     			}
     		
	}

}

function shouldGoBack()
{ 
   if(! confirmDialog("<%= UIUtil.toJavaScript((String)assignCustomersRB.get("assignCustCancelConfirmation")) %>")){
         return false;
   }
   return true;
}


function showSuccessMessage(){
	alertDialog("<%= UIUtil.toJavaScript((String)assignCustomersRB.get("assignCustSuccessConfirmation")) %>"); 
}

function showAssignCustErrorMessage(){
	alertDialog("<%= UIUtil.toJavaScript((String)assignCustomersRB.get("assignCustError")) %>"); 
}

function passParameters()
{ 
	parent.put("<%= ECMemberCommandParameterConstants.EC_REPRESENTATIVE_ID%>", "<%= usersId %>");
	
	var customerId=null;
	if(document.assignCustForm.AssignedCustomerBox.options.length > 0 ){
		customerId = document.assignCustForm.AssignedCustomerBox.options[0].value;
	}
	for(var j=1; j< document.assignCustForm.AssignedCustomerBox.options.length; j++){
	  	 customerId += "," + document.assignCustForm.AssignedCustomerBox.options[j].value;
	}
	parent.put("<%= ECMemberCommandParameterConstants.EC_CUSTOMER_ID%>", customerId);
	
	
}

function addCustomers(){

   var selectedChoices = new Array();
       var count = 0;  
        for (var i=0; i < document.assignCustForm.LUS_SearchResultListBox.options.length; i++)
        {
               if (document.assignCustForm.LUS_SearchResultListBox.options[i].selected)
                {   
		      if(document.assignCustForm.AssignedCustomerBox.options.length != null){
		                var index = document.assignCustForm.AssignedCustomerBox.options.length;   
		                var exist= false;
		                for (var j = 0; j<index && (!exist); j++){
		                    if (document.assignCustForm.AssignedCustomerBox.options[j].value == document.assignCustForm.LUS_SearchResultListBox.options[i].value){
		                         exist = true;
		                    }
		                }
		                if(!exist){
					document.assignCustForm.AssignedCustomerBox.options[index] = 
					   		     	   new Option(document.assignCustForm.LUS_SearchResultListBox.options[i].text, document.assignCustForm.LUS_SearchResultListBox.options[i].value, false, false);    
		     		}	
		      }
                }
       }
      
}

function enableRemoveButton(){
     document.assignCustForm.removeButton.disabled = false;
}

function removeCustomers(){
     for (var i=0; i < document.assignCustForm.AssignedCustomerBox.options.length; i++)
     {
         if (document.assignCustForm.AssignedCustomerBox.options[i].selected)
         {  
            document.assignCustForm.AssignedCustomerBox.options[i]=null;
	 }
     }
}

//-->
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
                     ('assignCustForm',
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
{  
   var searchType   = 0;  // default to search all
   var searchString = ""; // default to wildcard search

   // Building the search parameter as a query string
   var queryString = "searchType="    + searchType
                   + "&adminId=" + <%= cmdContext.getUserId() %>
                   + "&searchString=" + searchString
                   + "&returningUserCriteria=1"
                   + "&maxThreshold=" + "<%= UIUtil.toJavaScript((String)assignCustomersRB.get("LUS_MaxNumOfResultForACSearch")) %>"
                   + "&firstLoad=1";
 
   // Construct the IFRAME as the data frame for getting the search result
   
   var webAppPath = "<%= UIUtil.getWebappPath(request) %>";
   with (document.assignCustForm) {
     	var selectedView = SelectView.options[SelectView.selectedIndex].value;
    
  	 if(selectedView == 1){	 
  	  	var iframeElement = document.createElement('IFRAME');
	  	iframeElement.name = 'ACSearchForCustGrpsICanAdmin_dataFrame';
	  	iframeElement.id = 'ACSearchForCustGrpsICanAdmin_dataFrame';
	  	iframeElement.width = '0';
	  	iframeElement.height = '0';
	  	iframeElement.src = "ACSearchForCustGrpsICanAdminView?"+ queryString + "'";
	  	iframeElement.title = '';
 	        document.body.appendChild(iframeElement);         
                   
 	  }else  if(selectedView == 2){	  
 	  	var iframeElement = document.createElement('IFRAME');
 	  	iframeElement.name = 'ACSearchForOrgsICanAdmin_dataFrame';
 	  	iframeElement.id = 'ACSearchForOrgsICanAdmin_dataFrame';
 	        iframeElement.width = '0';
 	        iframeElement.height = '0';
 	        iframeElement.src = "ACSearchForOrgsICanAdminView?"+ queryString + "'";
 	        iframeElement.title = '';
 	        document.body.appendChild(iframeElement);
 	        
 	  }else  if(selectedView == 3){	  
 	  	var iframeElement = document.createElement('IFRAME');
 	  	iframeElement.name = 'ACSearchForUsersICanAdmin_dataFrame';
 	  	iframeElement.id = 'ACSearchForUsersICanAdmin_dataFrame';
 	        iframeElement.width = '0';
 	        iframeElement.height = '0';
 	        iframeElement.src = "ACSearchForUsersICanAdminView?"+ queryString + "'";
 	        iframeElement.title = '';
 	    	document.body.appendChild(iframeElement);
 	 }
 	  
  }//end of with 
}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: LUS_ProcessDataFrameSearchResults
// Desc.   : Process the search results from the data frame. This is a
//           call-back method invoking from the data frame after the frame
//           is loaded
/////////////////////////////////////////////////////////////////////////////
var LUS_isCustGrpsDataFrameInitialized=false;
var LUS_isOrgsDataFrameInitialized=false;
var LUS_isUsersDataFrameInitialized=false;

function LUS_ProcessDataFrameSearchResults()
{
  top.showProgressIndicator(false);

  with (document.assignCustForm) {  
     	var selectedView = SelectView.options[SelectView.selectedIndex].value;
   
   //-------------------------------------------------
   // Handle the first time of this page being loaded
   //-------------------------------------------------
  if(selectedView == 1){         
  
    //the selected view is customer groups
    var resultCondition = ACSearchForCustGrpsICanAdmin_dataFrame.getSearchResultCondition();

    // Possible search result conditions:
    //    '0' - no match found
    //    '1' - match found within max. threshold
    //    '2' - match found exceeding max. threshold	 
    if (LUS_isCustGrpsDataFrameInitialized==false)
    {
      // Toggle ON to skip this block for all subsequent calls
      LUS_isCustGrpsDataFrameInitialized=true;
      if (resultCondition=='1')
      {
         // Re-wiring the data frame's result to LUS widget
         // and display the results in the resulting list box
         // and update the currently showing status line.      
         lusWidget.LUS_setResultingList(ACSearchForCustGrpsICanAdmin_dataFrame.getCustGrpNameList(),
                                        ACSearchForCustGrpsICanAdmin_dataFrame.getCustGrpIdList());
      }
      else if (resultCondition=='2')
      {
         // Too many entries, show msg in widget to let user type account name to search
         lusWidget.LUS_setSearchKeyword('<%=UIUtil.toJavaScript((String)assignCustomersRB.get("LUS_Label_keywordDefaultTextCustGrps")) %> ', true);
      }  
      else if (resultCondition=='0')
      {
         // No entries avaliable in system, disable the widget
         lusWidget.LUS_disableAll();
      }

      return;

    }//end-if (LUS_isCustGrpsDataFrameInitialized==false)

  } else if (selectedView == 2){
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
  
  
  }else if (selectedView == 3){
  
   //the selected view is users
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
  
  }//end if selected view


   //----------------------------------------------------------
   // Process the search resulting data for various conditions
   //----------------------------------------------------------
   var msg = "";
   if (resultCondition=='0')
   {
      // No entries avaliable in system, disable the widget
      msg = "<%= UIUtil.toJavaScript((String)assignCustomersRB.get("LUS_ACMsg_NotFound")) %>";
      alertDialog(msg);
      return;
   }
   else if (resultCondition=='2')
   {
      // Too many entries
      msg = "<%= UIUtil.toJavaScript((String)assignCustomersRB.get("LUS_ACMsg_TooManyFound")) %>";
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
      if( selectedView == 1){
        
      	lusWidget.LUS_setResultingList(ACSearchForCustGrpsICanAdmin_dataFrame.getCustGrpNameList(),
                                     ACSearchForCustGrpsICanAdmin_dataFrame.getCustGrpIdList());
      	
      }else if( selectedView == 2){
     	lusWidget.LUS_setResultingList(ACSearchForOrgsICanAdmin_dataFrame.getOrgNameList(),
                                           ACSearchForOrgsICanAdmin_dataFrame.getOrgIdList());
                 	
      }else if( selectedView == 3){
     	lusWidget.LUS_setResultingList(ACSearchForUsersICanAdmin_dataFrame.getUserNameList(),
                                           ACSearchForUsersICanAdmin_dataFrame.getUserIdList());
             
      }
  
   }

  }//end with
}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: LUS_FindAction
// Desc.   : This triggers the search action in the data frame
/////////////////////////////////////////////////////////////////////////////
function LUS_FindAction()
{
   lusWidget.LUS_clearComboBoxWithOutStatusLine();
   
   var searchType   = lusWidget.LUS_getSelectedCriteria();
   var searchString = lusWidget.LUS_getSearchKeyword();

   // Building the search parameter as a query string
   var queryString = "searchType="    + searchType
   		   + "&adminId=" + <%= cmdContext.getUserId() %>
                   + "&searchString=" + searchString
                   + "&returningUserCriteria=1"
                   + "&maxThreshold=" + "<%= (String)assignCustomersRB.get("LUS_MaxNumOfResultForACSearch") %>";
                   
   var webAppPath = "<%= UIUtil.getWebappPath(request) %>";
   
   with (document.assignCustForm) {
        var selectedView = SelectView.options[SelectView.selectedIndex].value;
      
        if(selectedView == 1){         
  	  var newURL = webAppPath + 'ACSearchForCustGrpsICanAdminView?' + queryString;
 	  top.showProgressIndicator(true);
 	  ACSearchForCustGrpsICanAdmin_dataFrame.location.replace(newURL);
 	  
 	}else if (selectedView == 2){        
 	  var newURL = webAppPath + 'ACSearchForOrgsICanAdminView?' + queryString;
	  top.showProgressIndicator(true);
 	  ACSearchForOrgsICanAdmin_dataFrame.location.replace(newURL);
 	  
 	}else if (selectedView == 3){        
 	  var newURL = webAppPath + 'ACSearchForUsersICanAdminView?' + queryString;
	  top.showProgressIndicator(true);
 	  ACSearchForUsersICanAdmin_dataFrame.location.replace(newURL);
 	}

   }//end with(document.assignCustForm) 
}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: LUS_SelectResultItem
// Desc.   : Rewire the user selected item from the resuling list box to
//           the expected form's field.
/////////////////////////////////////////////////////////////////////////////
function LUS_SelectResultItem()
{
   var text = lusWidget.LUS_getSelectedResultNames();
   document.assignCustForm.LUS_QuickTextEntry.value = text[0];

   // Need to enable the Add button to allow user to add.
   document.assignCustForm.addButton.disabled = false;
}
//-->
</script>

<!-- ******************************************************************** -->
<!-- *   END HERE --- Javascript Functions for Wiring the LUS Widget    * -->
<!-- ******************************************************************** -->

<style type='text/css'>
.selectWidth {
	width: 600px;
}
<!-------------------------------------------->
<!-- Define the CSS for the LUS's GUI parts -->
<!-------------------------------------------->
.LUS_CSS_QuickTextEntryWidth {width: 600px;}
.LUS_CSS_ResultListBoxWidth  {width: 600px;}
.LUS_CSS_KeywordEntryWidth   {width: 200px;}
.LUS_CSS_CriteriaListWidth   {width: auto; }
</style>

<title><%= UIUtil.toHTML((String)assignCustomersRB.get("emailActivityDialogTitle")) %></title>
</head>

<body onload="loadPanelData()" class="content">

<h1><%= UIUtil.toHTML((String)assignCustomersRB.get("assignCustTitle")) %> </h1>

<form name="assignCustForm">

<p><label for="SelectViewID"><%= UIUtil.toHTML((String)assignCustomersRB.get("assignCustSelectView")) %></label><br />
<select name="SelectView" id="SelectViewID" single ="SINGLE" onChange="changeView()">
       <option value="1" selected><%= UIUtil.toHTML((String)assignCustomersRB.get("assignCustCustomerGroups")) %></option>
       <option value="2"><%= UIUtil.toHTML((String)assignCustomersRB.get("assignCustOrganizations")) %></option>
       <option value="3"><%= UIUtil.toHTML((String)assignCustomersRB.get("assignCustUsers")) %></option>
</select><br />
<br />


<!-- ******************************************************************** -->
<!-- *****        LUS Widget GUI Component Scope START HERE         ***** -->
<!-- ******************************************************************** -->

<table id='LUS_table'>
   <tbody>    
     <tr> <!-- Building GUI Body Parts BEGIN ------------------------------>
     	 <td valign="top" id="LUS_TableCell_SelectText"><label id="LUS_TableCell_SelectText_Label" for="LUS_FormInput_QuickTextEntry"><%= assignCustomersRB.get("assignCustSelectCustomerGroups") %></label></td>
         <td valign="top" id="LUS_TableCell_SearchText"><label id="LUS_TableCell_SearchText_Label" for="LUS_SearchTextField1"><%= assignCustomersRB.get("assignCustSearchCustomerGroups") %></label></td>
      </tr>
      <tr>
         <!----------------------------------------------------------->
         <!-- Quick search text entry field with resulting list box -->
         <!----------------------------------------------------------->
         <td valign="top" id="LUS_TableCell_Select">
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
                        <label for="LUS_SearchResultListBox1" class="hidden-label"><%= assignCustomersRB.get("SelectSearchResult") %></label>
                        <select name="LUS_SearchResultListBox" size="4"
                                onchange="javascript:LUS_SelectResultItem();"
                                class="LUS_CSS_ResultListBoxWidth"
                                single id="LUS_SearchResultListBox1">
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
         <td valign="top" id="LUS_TableCell_Search">
            <table border="0">
               <tbody>
                  <tr>
                     <td id="LUS_TableCell_KeywordSearch">
                        <input  name="LUS_SearchTextField"
                                type="text"
                                size="20"
                                class="LUS_CSS_KeywordEntryWidth" 
                                id="LUS_SearchTextField1" /><br /> 
                        <label for="LUS_CriteriaDropDown1" class="hidden-label"><%= assignCustomersRB.get("SearchOptions") %></label>                                  
                        <select name="LUS_CriteriaDropDown"
                                class="LUS_CSS_CriteriaListWidth" 
                                id="LUS_CriteriaDropDown1">
                           <option value="1"><%= assignCustomersRB.get("LUS_ACSearchType1") %></option>
                           <option value="2"><%= assignCustomersRB.get("LUS_ACSearchType2") %></option>
                           <option value="3"><%= assignCustomersRB.get("LUS_ACSearchType3") %></option>
                           <option value="4"><%= assignCustomersRB.get("LUS_ACSearchType4") %></option>
                           <option value="5"><%= assignCustomersRB.get("LUS_ACSearchType5") %></option>
                        </select><br /><br />
                     </td>
                  </tr>
                  <tr>
                     <td align="right" id="LUS_FormInput_FindAction">
                        <button name="LUS_ActionButton" class="general" onclick="javascript:LUS_FindAction();"><%= assignCustomersRB.get("assignCustButFind") %></button><br />
                     </td>
                  </tr>
               </tbody>
            </table>
         </td>


      </tr> <!-- Building GUI Body Parts End ------------------------------->

   </tbody>
</table>

<!-- ******************************************************************** -->
<!-- *****        LUS Widget GUI Component Scope FINISH HERE         ***** -->
<!-- ******************************************************************** -->


<p><label for="assignedCustID"><%= UIUtil.toHTML((String)assignCustomersRB.get("assignCustAssignedCust")) %></label><br />
<table border="0" width="100%" height="48">
    <tr>
      <td width="26%" height="19"><select name="AssignedCustomerBox" size=8 id="assignedCustID" class="selectWidth" onchange="javascript:enableRemoveButton()"></select>
      	<p>&nbsp;
      </td>
      <td width="74%" height="19">&nbsp;&nbsp;&nbsp;&nbsp;<button class="general" name="addButton" onclick="javascript:addCustomers()" disabled="true" ><%=UIUtil.toHTML((String)assignCustomersRB.get("assignCustButAdd"))%> </button>
         <BR></BR>&nbsp;&nbsp;&nbsp;&nbsp;<button class="general" name="removeButton" onclick="javascript:removeCustomers()" disabled="true" ><%=UIUtil.toHTML((String)assignCustomersRB.get("assignCustButRemove"))%> </button>
         <BR></BR><BR></BR><BR></BR><BR></BR></td>
    </tr>
</table>

</form>

</body>
</html>
