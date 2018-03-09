<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@page language="java"
	import="com.ibm.commerce.tools.util.UIUtil,
		com.ibm.commerce.beans.DataBeanManager,
		com.ibm.commerce.datatype.TypedProperty,
		com.ibm.commerce.server.JSPHelper" %>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<%
        JSPHelper jspHelper = new JSPHelper(request);	
        String fromAccelerator = jspHelper.getParameter("fromAccelerator");
   		String storeViewName = jspHelper.getParameter("storeViewName");
%>

<html lang="en">

<head>
 <%= fHeader %>
 <style type='text/css'>
 .selectWidth {width: 200px;}
 
</style>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

 <title><%= contractsRB.get("accountRepresentativePanelTitle") %></title>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/SwapList.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/ConvertToXML.js">
</script>
</script>
<script LANGUAGE="JavaScript">
 

 function childOrgListChange() {
    var orgId = mainBody.document.SWCGeneralForm.storeOrganization.value;
      if(orgId == "" || orgId == "specifyStoreOrg" || !mainBody.document.SWCGeneralForm.storeOrganizationSharedOwnerChecked.checked){
	      if (mainBody.document.SWCGeneralForm.storeOrganizationSharedOwnerChecked.checked)	      
	      	childOrgSelectionBody.showLoadingMsg("details");
	      else 
	      	childOrgSelectionBody.showLoadingMsg("blank");

	      return;
      } 
      else {
	      childOrgSelectionBody.showLoadingMsg("load");
      }
    if (parent.setContentFrameLoaded) {
      	parent.setContentFrameLoaded(false);
    }    
    childOrgSelectionBody.location.replace("SCWGeneralChildOrgSelectionBodyView?OrgId=" + orgId);
    
  }
  
 function hiddenChildOrgSelectionBody(){
   		childOrgSelectionBody.showLoadingMsg("blank");
  
  }

  function showChildOrgSelectionBody(){
   		childOrgSelectionBody.showLoadingMsg("details");
  
  } 
  
  function  validatePanelData(){
  	return mainBody.validatePanelData() && childOrgSelectionBody.validatePanelData();
  }

  function savePanelData() {
  	mainBody.savePanelData();
  	childOrgSelectionBody.savePanelData();
   }
 
</script>

</head>

<frameset  rows="600, 200" frameborder="no" border="0" framespacing="0" onload="childOrgListChange();">
	<frame src="SCWGeneralMainBodyView?fromAccelerator=<%=fromAccelerator %>&storeViewName=<%=storeViewName %>" name="mainBody" title="mainBody"  scrolling="yes" noresize>
	<frame src="SCWGeneralChildOrgSelectionBodyView" name="childOrgSelectionBody" title="childOrgSelectionBody" scrolling="yes" noresize>
</frameset>
</html>
