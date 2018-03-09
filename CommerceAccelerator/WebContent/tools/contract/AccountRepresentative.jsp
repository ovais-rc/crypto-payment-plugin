<!--==========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
  ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@page language="java"
	import="com.ibm.commerce.tools.util.UIUtil,
		com.ibm.commerce.beans.DataBeanManager,
		com.ibm.commerce.datatype.TypedProperty,
		com.ibm.commerce.tools.contract.beans.AccountDataBean,
		com.ibm.commerce.user.beans.AddressDataBean,
		com.ibm.commerce.tools.contract.beans.AddressListDataBean" %>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<html>

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

 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Account.js">
</script>

 <script LANGUAGE="JavaScript">
 
  // This function allows the user select an organization and get it's contact list
  function contactSelectionChange() {
    var orgId, index, allOrg;

    index = organizationBody.document.orgForm.OrgName.selectedIndex;
    allOrg = organizationBody.document.orgForm.OrgName;
    orgId = allOrg.options[index].value;    

    if (defined(contactSelectionBody.showLoadingMsg)) {
	    contactSelectionBody.showLoadingMsg(true);
    }
    if (defined(contactDetailBody.showLoadingMsg)) {
	    contactDetailBody.showLoadingMsg("blank");
    }
    if (parent.setContentFrameLoaded) {
      	parent.setContentFrameLoaded(false);
    }
    contactSelectionBody.location.replace("AccountRepresentativeContactSelectionPanelView?OrgId=" + orgId + "&ContactId=");
    
  }
  
  // This function allows the user select a contact and get it's contact detail
  function contactDetailChange() {
    var contactId, index, allContact;
    
    index = contactSelectionBody.document.contactForm.ContactName.selectedIndex;
    allContact = contactSelectionBody.document.contactForm.ContactName;
    contactId = allContact.options[index].value;
    
    if (defined(contactDetailBody.showLoadingMsg)) {
      if(contactId == ""){
	      contactDetailBody.showLoadingMsg("blank");
      } 
      else {
	      contactDetailBody.showLoadingMsg("load");
      }
    }
    if (parent.setContentFrameLoaded) {
      	parent.setContentFrameLoaded(false);
    }
    contactDetailBody.location.replace("AccountRepresentativeContactDetailPanelView?ContactId=" + contactId);    
  }

  function savePanelData() {
    //alert ('Account Representative savePanelData');
    if (parent.get) {
      var o = parent.get("AccountRepresentativeModel", null);
      if (o != null) {
        var orgIndex = organizationBody.document.orgForm.OrgName.selectedIndex;
        var contactIndex = contactSelectionBody.document.contactForm.ContactName.selectedIndex;
	o.org = organizationBody.document.orgForm.OrgName.options[orgIndex].value;
	o.contact = contactSelectionBody.document.contactForm.ContactName.options[contactIndex].value;
	parent.put("AccountRepresentativeModel",o);
      }
    }
  }
  
  function visibleList (s) {
	if (defined(this.organizationBody) == false || this.organizationBody.document.readyState != "complete") {
		return;
	}

	if (defined(this.organizationBody.visibleList)) {
		this.organizationBody.visibleList(s);
		return;
	}

	if (defined(this.organizationBody.document.forms[0])) {
		for (var i = 0; i < this.organizationBody.document.forms[0].elements.length; i++) {
			if (this.organizationBody.document.forms[0].elements[i].type.substring(0,6) == "select") {
				this.organizationBody.document.forms[0].elements[i].style.visibility = s;
			}
		}
	}
	
	if (defined(this.contactSelectionBody) == false || this.contactSelectionBody.document.readyState != "complete") {
		return;
	}

	if (defined(this.contactSelectionBody.visibleList)) {
		this.contactSelectionBody.visibleList(s);
		return;
	}

	if (defined(this.contactSelectionBody.document.forms[0])) {
		for (var i = 0; i < this.contactSelectionBody.document.forms[0].elements.length; i++) {
			if (this.contactSelectionBody.document.forms[0].elements[i].type.substring(0,6) == "select") {
				this.contactSelectionBody.document.forms[0].elements[i].style.visibility = s;
			}
		}
	}
  }

 
</script>

</head>

<frameset rows="100,60,*" frameborder="no" border="0" framespacing="0">
	<frame src="AccountRepresentativeOrganizationPanelView" name="organizationBody" title="<%= contractsRB.get("accountRepresentativeBodyPanelTitle") %>" scrolling="auto" noresize>
	<frame src="/wcs/tools/common/blank.html" name="contactSelectionBody" title="<%= contractsRB.get("accountRepresentativeSelectionPanelTitle") %>" scrolling="auto" noresize>
	<frame src="/wcs/tools/common/blank.html" name="contactDetailBody" title="<%= contractsRB.get("accountRepresentativeDetailPanelTitle") %>" scrolling="auto" noresize>
</frameset>

</html>
