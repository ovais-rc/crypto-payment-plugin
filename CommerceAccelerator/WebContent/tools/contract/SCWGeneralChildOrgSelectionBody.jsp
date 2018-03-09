<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2007, 2008
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %> 
<%@page import="com.ibm.commerce.tools.util.*" %> 
<%@page import="com.ibm.commerce.tools.common.*" %>                          
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.*" %> 
<%@page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.StoreCreationWizardDataBean" %>
<%@ page import="com.ibm.commerce.tools.util.StringPair" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>

<%@include file="../common/common.jsp" %>
<%@include file="SCWCommon.jsp" %>
<%@include file="ContractCommon.jsp" %>
<%
try{
	
       	String storeTypeString = ""; 
        JSPHelper jspHelper = new JSPHelper(request);	
      	String orgId = jspHelper.getParameter("OrgId");
   	
%>

<html>
<head>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js">
</script>
<script language="JavaScript" src="/wcs/javascript/tools/common/URLParser.js">
</script>
<script language="JavaScript">
var storeCatDescArray = new Array();
var orgChildArray = new Array();

var generalData = null;

function initStoreCatDescriptionArray(){
		orgChildArray["<%=orgId%>"] = new Object();															
		orgChildArray["<%=orgId%>"].names = new Array();
	<%
						
		if (orgId != null) {								
				OrgEntityDataBean oedb = new OrgEntityDataBean(orgId);
				oedb.populate();
				Long [] childList = oedb.getDescendantOrgEntities();
				for (int j = 0; j < childList.length; j++) {
					OrganizationDataBean child = new OrganizationDataBean();
					child.setDataBeanKeyMemberId(childList[j].toString());
					child.populate();
	%>
				orgChildArray["<%=orgId%>"].names[orgChildArray["<%=orgId%>"].names.length] = "<%= UIUtil.toJavaScript(child.getOrganizationName()) %>";
	<%
				
			}
		}
	%>	
	showDivisions();
}

function initForm(){
  if(parent.parent.get("SWCGeneral") != null){	
		generalData = parent.parent.get("SWCGeneral");
		if (generalData.storeOrganizationSharedOwner != null && generalData.storeOrganizationSharedOwner!='' && generalData.storeOrganizationSharedOwner != 'specifyStoreOrg')
		document.orgListForm.storeOrganizationSharedOwner.value =generalData.storeOrganizationSharedOwner;
	}	
}


function showDivisions() {

   var orgSelection = document.orgListForm.storeOrganizationSharedOwner;
   var newOption;
   orgSelection.options.length = 0;
   newOption = new Option("<%=UIUtil.toHTML((String)resourceBundle.get("GeneralPleaseSpecify"))%>", "specifyStoreOrg",true,true);
   orgSelection.options[orgSelection.options.length] = newOption;
   for (var x=0; x<orgChildArray["<%=orgId%>"].names.length; x++) {
		newOption = new Option(orgChildArray["<%=orgId%>"].names[x], orgChildArray["<%=orgId%>"].names[x]);
		orgSelection.options[orgSelection.options.length] = newOption;
		if (orgChildArray["<%=orgId%>"].names[x] == document.orgListForm.storeOrganizationSharedOwner.value) {
			orgSelection.options[x+1].selected = true;
		}
	}
   }

function savePanelData() {
     var o = parent.parent.get("SWCGeneral", null); 
	 if (o==null) o= new Object(); 	  
    if ( parent.mainBody.document.SWCGeneralForm.storeOrganizationSharedOwnerChecked.checked == true) {
	  o.storeOrganizationSharedOwner = document.orgListForm.storeOrganizationSharedOwner.value;
    }else{
       o.storeOrganizationSharedOwner ='';
    }
    parent.parent.put("SWCGeneral", o);
}

function validatePanelData() {

 if(parent.mainBody.document.SWCGeneralForm.storeOrganizationSharedOwnerChecked.checked == true &&
     		document.orgListForm.storeOrganizationSharedOwner.value == 'specifyStoreOrg'){     
     		alertDialog("<%=UIUtil.toJavaScript((String)resourceBundle.get("storeOrgSharedRequired"))%>");
     		document.SWCGeneralForm.storeOrganizationSharedOwner.focus();
     		return false;
     		}
     return true;
}     		

function showLoadingMsg(message) {
    if (message == "load") {
      if (parent.parent.setContentFrameLoaded) {
        parent.parent.setContentFrameLoaded(false);
      }
      top.showProgressIndicator(true);
      FinishDiv.style.display = "none";
      BlankMsgDiv.style.display = "none";
      LoadingMsgDiv.style.display = "block";
    }
    else if (message == "blank") {
      FinishDiv.style.display = "none";
      LoadingMsgDiv.style.display = "none";
      BlankMsgDiv.style.display = "block";
    }
    else if(message == "details"){
      if (parent.parent.setContentFrameLoaded) {
        parent.parent.setContentFrameLoaded(true);
      }
      top.showProgressIndicator(false);
      LoadingMsgDiv.style.display = "none";
      BlankMsgDiv.style.display = "none";
      FinishDiv.style.display = "block";
    }
  }
</script>

</head>

<body onload="initStoreCatDescriptionArray();showLoadingMsg('details');initForm();"  class="content">
<div id="LoadingMsgDiv" style="display: none">
  &nbsp;<%= contractsRB.get("generalLoadingMessage") %>
</div>

<div id="BlankMsgDiv" style="display: none">
</div>
<div id="FinishDiv" style="display: none">
<form name="orgListForm" id="orgListForm">
	<label for="storeOrganizationSharedOwner">
	<%= UIUtil.toHTML((String)resourceBundle.get("storeOrganizationSharedOwnerLabel")) %>
	</label><br>
	<select name="storeOrganizationSharedOwner" id="storeOrganizationSharedOwner" size=1 width=100%>
	
	<!--<input type=text name=storeOrganizationSharedOwner value="" size=30  id="SWCGeneralForm_FormInput_storeOrganizationSharedOwner">-->

	</select>
</form>
</div>
</body>
</html>
<%
	}catch(Exception e){ %>
	<script language="JavaScript">
		document.URL="/webapp/wcs/tools/servlet/SCWErrorView";
	
</script>
	<% }
%>

