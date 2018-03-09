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

<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.math.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.base.objects.*"   %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>
<%@ page import="com.ibm.commerce.approval.util.*" %>
<%@ page import="com.ibm.commerce.approval.beans.*" %>
<%@ page import="com.ibm.commerce.tools.segmentation.*" %>

<%@ include file="../common/common.jsp" %>

<jsp:useBean id="approvalBean" class="com.ibm.commerce.approval.beans.ApprovalGroupTypeListBean" >
<jsp:setProperty property="*" name="approvalBean" />
</jsp:useBean>

<%

   // Set Command Context
   CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale locale = cmdContext.getLocale();
   String webalias = UIUtil.getWebPrefix(request);

   // obtain the resource bundle for display
   Hashtable orgEntityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyOrgEntityNLS", locale);
   Hashtable userEntityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);

   if (orgEntityNLS == null) System.out.println("!!!! RS is null");


   String strMessage = "";
   String strMessageKey = "";
   Object[] strMessageParams = null;
   String strFieldName = "";
   boolean bOrgEntityFound = false;

   String strOrgEntityId = request.getParameter("orgEntityId");
   //String strOrgEntityId = request.getParameter(ECUserConstants.EC_ORG_ORGENTITYID);
   
   // OrgEntityDataBean provides information of a organization or organizational unit.
   OrgEntityDataBean bnOrgEntity = new OrgEntityDataBean();
   bnOrgEntity.setOrgEntityId(strOrgEntityId);
   com.ibm.commerce.beans.DataBeanManager.activate(bnOrgEntity, request);
   bOrgEntityFound = bnOrgEntity.findOrgEntity();
   
   // All the approval (member group) types
   MemberGroupTypeDataBean[] arrAllMbrGrpTypes = null;
   
   // The approval (member group) types subscribed by the current organization
   MemberGroupTypeDataBean[] arrMbrGrpTypesForOrg = null;

   approvalBean.setPropertiesFilter(ApprovalConstants.EC_APPROVAL_FILTER_MEMBER_GROUP_TYPES_ALL);
   try {
       approvalBean.populate();
       //com.ibm.commerce.beans.DataBeanManager.activate(approvalBean, request);
       arrAllMbrGrpTypes = approvalBean.getMemberGroupTypeDataBeans();
   } catch (Exception e) {
       	    e.printStackTrace();
   }

   java.text.Collator collator = java.text.Collator.getInstance(locale);
   MemberGroupTypeDataBean tmp = null;
   for (int i = 0; i < arrAllMbrGrpTypes.length; i++) {
         for (int j = i + 1; j < arrAllMbrGrpTypes.length; j++) {
            if (collator.compare(arrAllMbrGrpTypes[i].getDescription(), arrAllMbrGrpTypes[j].getDescription()) > 0) {
               tmp = arrAllMbrGrpTypes[i];
               arrAllMbrGrpTypes[i] = arrAllMbrGrpTypes[j];
               arrAllMbrGrpTypes[j] = tmp;
            }
         }
   }
   
   // Temporary vector to store member group types subscribed by the org
   Vector vecMbrGrpTypesForOrg = new Vector();

   int index =0;
   for (int j=0; j < arrAllMbrGrpTypes.length; j++) {
      try{
      	MemberGroupAccessBean mgab = new MemberGroupAccessBean();
	// Check to see if organization owns this approval (member group) type
	mgab.findByOwnerName(new Long (strOrgEntityId), arrAllMbrGrpTypes[j].getName());
	vecMbrGrpTypesForOrg.addElement(arrAllMbrGrpTypes[j]);
	index++;
      } catch (javax.persistence.NoResultException e) {
   	/* Some objectNotFound exceptions are expected. This means that the organization does not 
   	 * subscribe to the current approval type.
   	 */
      } catch (Exception e) {
         e.printStackTrace();
      }
   }
   
   // Copy vector into array
   arrMbrGrpTypesForOrg = new MemberGroupTypeDataBean[vecMbrGrpTypesForOrg.size()];
   vecMbrGrpTypesForOrg.copyInto(arrMbrGrpTypesForOrg);

%>

<%!
private String getImplicitRoles(String nvPairs) {

   try {
      Hashtable map = new Hashtable();

      StringTokenizer stk1 = new StringTokenizer(nvPairs, "&");
      while (stk1.hasMoreElements()) {
            String paramValue = stk1.nextToken();
            StringTokenizer stk2 = new StringTokenizer(paramValue, "=");
            map.put(stk2.nextToken(), stk2.nextToken());
      }

      String roles = (String) map.get(new String("implicitRole"));
      return roles;
   } catch (Exception e) {
      e.printStackTrace();
      return "";
   }
}
%>


<html>
<head><title><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityDialogApproval")) %></title>
<%= fHeader%>
<LINK rel=stylesheet href="<%=webalias%>tools/common/centre.css" type="text/css">
<style type='text/css'>
.selectWidth {width: auto}
</style>

<script LANGUAGE="JavaScript1.2" SRC="<%=webalias%>javascript/tools/common/SwapList.js"></script>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>

////////////////////////////////////////////////
// Load data from state of info for this page
// add them to the GUI
///////////////////////////////////////////////

function initializeState()
{
   var OrgAppArray = new Array();
   var AppArray = new Array();

   <%
  int offset = 0;

  for (int i =0; i < arrAllMbrGrpTypes.length; i++) {

       boolean check = true;

       for (int k = 0; k < arrMbrGrpTypesForOrg.length; k++) {
            try{
	            String impRoles = getImplicitRoles(arrAllMbrGrpTypes[i].getProperties());
	            if (impRoles == null) {
	               impRoles = "";
	            }
	            if ((arrMbrGrpTypesForOrg[k].getName()).equals(arrAllMbrGrpTypes[i].getName())) {
	            	out.println("OrgAppArray[" + k + "] = new Array();");
	            	out.println("OrgAppArray[" + k + "].id ='" + arrAllMbrGrpTypes[i].getMbrGrpTypeId() + "';");
	            	out.println("OrgAppArray[" + k + "].name ='" + arrAllMbrGrpTypes[i].getName() + "';");
	            	out.println("OrgAppArray[" + k + "].description ='" + arrAllMbrGrpTypes[i].getDescription() + "';");
	            	out.println("OrgAppArray[" + k + "].role ='" + impRoles + "';");
		      	check = false;
		      	offset++;
		      	break;
	       	    }
       	     } catch (Exception e) {
       	     	e.printStackTrace();
       	     }
       }


       if (check) {
       		String impRoles2 = getImplicitRoles(arrAllMbrGrpTypes[i].getProperties());
		if (impRoles2 == null) {
			impRoles2 = "";
		}
	    	out.println("AppArray[" + (i - offset) + "] = new Array();");
	       	out.println("AppArray[" + (i - offset)+ "].name ='" + arrAllMbrGrpTypes[i].getName() + "';");
	       	out.println("AppArray[" + (i - offset)+ "].description ='" + arrAllMbrGrpTypes[i].getDescription() + "';");
	       	out.println("AppArray[" + (i - offset)+ "].id ='" + arrAllMbrGrpTypes[i].getMbrGrpTypeId() + "';");
	       	out.println("AppArray[" + (i - offset)+ "].role ='" + impRoles2 + "';");
       }

   } %>

   parent.put("OrgAppArray", OrgAppArray);
   
   for (var m=0; m < OrgAppArray.length; m++ ) {
      if (OrgAppArray[m].role == "") {
          var displayname = OrgAppArray[m].description;
      }
      else {
         var displayname = OrgAppArray[m].description + " - " + OrgAppArray[m].role;
      }
      //var displayname = OrgAppArray[m].description + " - " + OrgAppArray[m].role;
      document.f1.selrolesList.options[m] = new Option(displayname,displayname, false, false);
      document.f1.selrolesList[m].value = OrgAppArray[m].id;
  }

   parent.put("AppArray", AppArray);
   
   for (var j=0; j < AppArray.length; j++ ) {
     	if (AppArray[j].role == "" ) {
        	var displayname = AppArray[j].description;
     	}
        else {
         	var displayname = AppArray[j].description + " - " + AppArray[j].role;
     	}
     	//var displayname = AppArray[j].description + " - " + AppArray[j].role
     	document.f1.avrolesList.options[j] = new Option(displayname,displayname, false, false);
     	document.f1.avrolesList[j].value = AppArray[j].id;
   }

   initializeSloshBuckets(document.f1.avrolesList, document.f1.addButton, document.f1.selrolesList, document.f1.removeButton);

   updateAllButtons();

   parent.setContentFrameLoaded(true);

}


/////////////////////////////////////////////////////////////////////////////
// This function will validate the entry fields for this page before wizard
// goes to the next or previous page. This function will also be used to
// restore the user changes to the state of info
/////////////////////////////////////////////////////////////////////////////
function savePanelData()
{
    parent.addURLParameter("authToken", "${authToken}");
    var rarray = new Array();
    var oarray = new Array();
    oarray = parent.get("OrgAppArray");
    rarray = parent.get("AppArray");
    var id = '';


    for (var i=0; i < document.f1.selrolesList.length; i++) {

      if (id == '' ) id = document.f1.selrolesList[i].value;
      else id = id + "," + document.f1.selrolesList[i].value;

    }

    parent.put("<%=SegmentConstants.PARAMETER_SEGMENT_ID%>", id);
    parent.put("<%=ECUserConstants.EC_ROLE_ORGENTITYID%>","<%=UIUtil.toJavaScript(strOrgEntityId)%>");

    parent.put("redirecturl","DialogNavigation");
    return true;

}

function validatePanelData()
{


   return true;
}

////////////////////////////////////////////////////////////////
// Enable/Disable the Add All and Remove All Buttons
////////////////////////////////////////////////////////////////
function updateAllButtons() {
   // if excludedApps list is empty, disable the "Add All" Button

   if (isListBoxEmpty(document.f1.avrolesList)) {

         document.f1.addAllButton.disabled=true;
            document.f1.addAllButton.className='disabled';
         document.f1.addAllButton.id='disabled';
   }
   else {
      document.f1.addAllButton.disabled=false;
      document.f1.addAllButton.className='enabled';
      document.f1.addAllButton.id='enabled';
   }
   // if includedApps list is empty, disable the "Remove All" Button
   if (isListBoxEmpty(document.f1.selrolesList)) {

      document.f1.removeAllButton.disabled=true;
      document.f1.removeAllButton.className='disabled';
      document.f1.removeAllButton.id='disabled';
   }
   else {
      document.f1.removeAllButton.disabled=false;
      document.f1.removeAllButton.className='enabled';
      document.f1.removeAllButton.id='enabled';
   }


}


////////////////////////////////////////////////////////////////
// This function is used to add one or more member groups to
// defined member group list
////////////////////////////////////////////////////////////////
function addToStoreOwners() {

// If "All" is originally in the selrolesList list, then move it to avrolesList if
   // a separate storeOwner is selected
   if (hasItem(document.f1.selrolesList, "0")) {
   setAnItemSelected(document.f1.selrolesList, "0");
   move(document.f1.selrolesList, document.f1.avrolesList);
   }

   // If "All" is to be moved to the selrolesList list, move all other individual
   // selrolesList to the avrolesList
   if (isItemSelected(document.f1.avrolesList, "0")) {
   setItemsSelected(document.f1.selrolesList);
   move(document.f1.selrolesList, document.f1.avrolesList);
   }

   move(document.f1.avrolesList, document.f1.selrolesList);

   updateAllButtons();

   //alertDialog("updateSloshBuckets");
   updateSloshBuckets(document.f1.avrolesList, document.f1.addButton, document.f1.selrolesList, document.f1.removeButton);


}

function addAllToStoreOwners() {

   setItemsSelected(document.f1.avrolesList);
   move(document.f1.avrolesList, document.f1.selrolesList);
   updateSloshBuckets(document.f1.avrolesList, document.f1.addButton, document.f1.selrolesList, document.f1.removeButton);

      updateAllButtons();

}

///////////////////////////////////////////////////////////////
// This function is used to remove one or more defined member
// groups from defined member group list
///////////////////////////////////////////////////////////////
function removeFromStoreOwners() {

//alertDialog("removeFromStoreOwners");
   move(document.f1.selrolesList, document.f1.avrolesList);
   //alertDialog("updateSloshBuckets");

   updateAllButtons();

   updateSloshBuckets(document.f1.avrolesList, document.f1.addButton, document.f1.selrolesList, document.f1.removeButton);

}

function removeAllFromStoreOwners() {

   setItemsSelected(document.f1.selrolesList);
   move(document.f1.selrolesList, document.f1.avrolesList);
   updateSloshBuckets(document.f1.avrolesList, document.f1.addButton, document.f1.selrolesList, document.f1.removeButton);

   updateAllButtons();

}

</SCRIPT>
<!-- ============================================================================
The sample Templates, HTML and Macros are furnished by IBM as simple
examples to provide an illustration. These examples have not been
thoroughly tested under all conditions.  IBM, therefore, cannot guarantee reliability,
serviceability or function of these programs. All programs contained herein are provided
to you "AS IS".

The sample Templates, HTML and Macros may include the names of individuals,
companies, brands and products in order to illustrate them as completely as
possible.  All of these are names are ficticious and any similarity to the names
and addresses used by actual persons or business enterprises is entirely coincidental.

Licensed Materials - Property of IBM

5697-D24

(c)  Copyright  IBM Corp.  1997, 1999.      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp

=============================================================================== -->

</head>
<BODY ONLOAD="initializeState();" CLASS="content">
   <H1><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityApproval")) %></H1>

<FORM NAME="f1">

<TABLE BORDER='0' summary="<%=UIUtil.toHTML((String)orgEntityNLS.get("userGeneralRoles"))%>">

    <TR><TD>
        <LABEL for="selrolesList"><%=UIUtil.toHTML((String)userEntityNLS.get("orgGeneralAssignedApp"))%></LABEL>
    </TD>
    <TD WIDTH='20'>&nbsp;</TD>
    <TD>
   <LABEL for="avrolesList"><%=UIUtil.toHTML((String)userEntityNLS.get("orgGeneralAvailableApp"))%></LABEL>
    </TD>
    </TR>

    <TR>
      <TD>
      <!-- Selected Stores -->
         <SELECT NAME='selrolesList' id="selrolesList" CLASS='selectWidth' MULTIPLE SIZE='15' onChange="javascript:updateSloshBuckets(this, document.f1.removeButton, document.f1.avrolesList, document.f1.addButton);"></SELECT>
      </TD>

      <TD WIDTH='20' VALIGN='TOP'><BR><BR>
             <INPUT TYPE='button' NAME='addButton' VALUE="<%=UIUtil.toHTML((String)orgEntityNLS.get("rolesButtonAdd"))%>" onClick="addToStoreOwners();"><BR><BR>
             <INPUT TYPE='button' NAME='removeButton' VALUE="<%=UIUtil.toHTML((String)orgEntityNLS.get("rolesButtonRemove"))%>" onClick="removeFromStoreOwners();"><BR><BR>
             <INPUT TYPE='button' NAME='addAllButton' VALUE="<%=UIUtil.toHTML((String)orgEntityNLS.get("rolesButtonAddAll"))%>" onClick="addAllToStoreOwners();"><BR><BR>
         <INPUT TYPE='button' NAME='removeAllButton' VALUE="<%=UIUtil.toHTML((String)orgEntityNLS.get("rolesButtonRemoveAll"))%>" onClick="removeAllFromStoreOwners();"><BR><BR>
      </TD>
      <TD>
         <!-- all available store list -->
         <SELECT NAME='avrolesList' ID="avrolesList" CLASS='selectWidth' MULTIPLE SIZE='15' onChange="javascript:updateSloshBuckets(this, document.f1.addButton, document.f1.selrolesList, document.f1.removeButton);"></SELECT>
      </TD>
    </TR>
</TABLE>





</FORM>
</body>
</html>
