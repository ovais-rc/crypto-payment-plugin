<!--==========================================================================
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2005
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//------------------------------------------------------------------------------
//
////////////////////////////////////////////////////////////////////////////////
===========================================================================-->
<%@page import="com.ibm.commerce.tools.util.*" %>
<script>

   function saveFormData()
   {
	with (document.entryForm) {
		if (getData("logonId")) {
			//Create user scenario
			profileType.value = 'B';
			passwordExpired.value = 1;
		}
	}
   }

   function finishHandler(finishMessage)
   {
         
     if (getData("logonId")) {
     	// Create user scenario
     	<%
		   com.ibm.commerce.server.JSPHelper jspHelper = new com.ibm.commerce.server.JSPHelper(request);
		%>
		var logonId = "<%= UIUtil.toJavaScript(jspHelper.getParameter("logonId")) %>";
        top.setContent(top.mccbanner.getbcttxt(top.mccbanner.counter), "NewDynamicListView?ActionXMLFile=buyerconsole.BuyUserAdminList&cmd=BuyAdminConUserAdminView&userLogonId=" + logonId + "&userLogonIdSearchType=1", false);
     } else {
     	//Update user scenario
        top.goBack();
     }
   }
   
</script>
