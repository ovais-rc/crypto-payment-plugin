<%--
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
--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ page
    import="java.util.*,
            com.ibm.commerce.tools.util.*,
            com.ibm.commerce.tools.common.*,
            com.ibm.commerce.server.*,
            com.ibm.commerce.common.objects.*,
            com.ibm.commerce.common.beans.*,
            com.ibm.commerce.user.beans.*,
            com.ibm.commerce.user.objects.*,
            com.ibm.commerce.usermanagement.commands.ECUserConstants,
            com.ibm.commerce.tools.optools.user.beans.*,
            com.ibm.commerce.beans.*,
            com.ibm.commerce.utils.*,
	    com.ibm.commerce.command.*,
	    com.ibm.commerce.tools.contract.beans.AccountDataBean,
	    com.ibm.commerce.ras.*,
            com.ibm.commerce.tools.xml.*"

%>

<%@include file="../common/common.jsp" %>
<%@include file="../common/NumberFormat.jsp" %>

<%
try
{
	JSPHelper jspHelper = new JSPHelper(request);

	String userId = jspHelper.getParameter("shrfnbr");
	String locale = jspHelper.getParameter("locale");
	String account = jspHelper.getParameter("account");
	String cmdStatus = jspHelper.getParameter("cmdStatus");	

	CommandContext cmdContext = (CommandContext)request.getAttribute("CommandContext");

	Hashtable formats = (Hashtable)ResourceDirectory.lookup("csr.nlsFormats");
	Hashtable format = (Hashtable)XMLUtil.get(formats, "nlsFormats."+ locale);

	if (format == null) 
	{
	   format = (Hashtable)XMLUtil.get(formats, "nlsFormats.default");
	} 

	Hashtable userNLS = (Hashtable)ResourceDirectory.lookup("csr.userNLS", cmdContext.getLocale());	
	Hashtable orgEntityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.OrgEntityNLS", cmdContext.getLocale());


	// Assume one to one relationship between a user and X509 certificate
	String certStatus = "";
	CertificateX509ByUserIdListDataBean certificateX509DataBeanList = new CertificateX509ByUserIdListDataBean();
	certificateX509DataBeanList.setDataBeanKeyUserId(userId);
	DataBeanManager.activate(certificateX509DataBeanList, request);

	CertificateX509DataBean certificateList[] = null;
	certificateList = certificateX509DataBeanList.getCertificateX509ByUserIdList();

	int numCertificates = 0;
	numCertificates = certificateList.length;

	for (int i=0; i<numCertificates; i++)
	{
			CertificateX509DataBean certx509 = certificateList[i];
			certStatus = certx509.getStatus();
	}

	OptoolsRegisterDataBean registerDataBean = new OptoolsRegisterDataBean();
	registerDataBean.setUserId(userId); 
	DataBeanManager.activate(registerDataBean, request);

	ResourceBundleDataBean bnResourceBundle = new ResourceBundleDataBean();
	bnResourceBundle.setPropertyFileName("UserRegistration_" + locale);
	DataBeanManager.activate(bnResourceBundle, request);

	AddressDataBean address = null;
	AccountDataBean accountDBean = null;
	UserRegistryDataBean userRegistry = null;
	OrgEntityDataBean orgEntity = null;

	try
	{
		address = new AddressDataBean();
		address.setAddressId(registerDataBean.getAddressId());
		DataBeanManager.activate(address, request);
	}
	catch (Exception ex)
	{
		//Exception
		ex.printStackTrace();		
	}

	try
	{
		accountDBean = new AccountDataBean(new Long(account), cmdContext.getLanguageId());
    		DataBeanManager.activate(accountDBean, request);
    	}
	catch (Exception e)
	{
		accountDBean = null;
	}	

	try
	{
		userRegistry = new UserRegistryDataBean();
		userRegistry.setDataBeanKeyUserId(userId);
		DataBeanManager.activate(userRegistry, request);

		String status = userRegistry.getStatus();	
	}
	catch (Exception e)
	{
		userRegistry = null;
	}	


	Hashtable hshRegister = bnResourceBundle.getPropertyHashtable();
	UserRegistrationDataBean bnRegister = new UserRegistrationDataBean();
	bnRegister.setUserId(userId);
	com.ibm.commerce.beans.DataBeanManager.activate (bnRegister, request);

	Long parentOrgMemberId = new Long(0);
	Long ancestorList[] = bnRegister.getAncestors();
	int numAncestors = ancestorList.length;
	if (ancestorList != null) {
		parentOrgMemberId = ancestorList[numAncestors-1];
		if ( (parentOrgMemberId.toString().equals("-2001")) &&
			numAncestors > 1) {
			parentOrgMemberId = ancestorList[numAncestors-2];
		}
   	}

	try
	{
		orgEntity = new OrgEntityDataBean();
		orgEntity.setOrgEntityId(parentOrgMemberId.toString());
		DataBeanManager.activate(orgEntity, request);
	}
	catch (Exception e)
	{
		orgEntity = null;
	}

	UIUtil convert = null;

%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css" />
<title><%= userNLS.get("customerSummaryTitle") %></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js">
</script>

<script type="text/javascript">
<%@ include file = "SummaryDisplay.jspf" %>

function getUserId() {
   var rc = "<%=userId%>";
   if (rc == "null") rc = "";
	return rc;
}
function getLocale() {
   var rc = "<%=locale%>";
   if (rc == "null") rc = "";
	return rc;
}
function getAccount() {
	var rc = "<%=account%>";
   if (rc == "null") rc = "";
	return rc;
}
function getCmdStatus() {
	var rc = "<%=cmdStatus%>";
   if (rc == "null") rc = "";
	return rc;
}
function printAction() {
	window.focus();
	window.print();
}

function enableAccount() {

    var profileInfo = new Object();

    profileInfo.logonId = document.profile.logonId.value;
    parent.put("profileInfo", profileInfo);

<% if (userRegistry.getStatus().equals("1")) {%>
    alertDialog("<%= UIUtil.toHTML((String)userNLS.get("accountReset")) %>");
<% } else { %>
    var xmlObject = parent.modelToXML("XML");

    document.profile.action="CSRCustomerEnableAccount";
    document.profile.XML.value=xmlObject;
    document.profile.URL.value="ShopperSummaryB2BDialog?shrfnbr="+getUserId()+"&locale="+getLocale()+"&account="+getLocale()+"&cmdStatus=0";
    document.profile.submit();
<% } %>
}

function okAction() {
	top.goBack();
}

function savePanelData()
{
    var profileInfo = new Object();
    profileInfo.logonId = document.profile.logonId.value;
    parent.put("profileInfo", profileInfo); 
}  

function displayCmdStatus(cmdStatus)
{
   if (cmdStatus != null)
   {
	if (cmdStatus == 1)
	{
		alertDialog("<%= UIUtil.toHTML((String)userNLS.get("accountReset")) %>");
	}
	else if (cmdStatus == 2)
	{
		alertDialog("<%= UIUtil.toHTML((String)userNLS.get("accountNotReset")) %>");
	}
   }
}

function initializeState()
{

   var profileInfo = parent.get("profileInfo");
   var cmdStatus;
   
   if (profileInfo != null)
   {
	document.profile.logonId.value = profileInfo.logonId;
	cmdStatus = getCmdStatus();
   }
   else
   {	// First time visit the page
   	document.profile.logonId.value = "<%=UIUtil.toJavaScript(registerDataBean.getLogonId())%>";
   	cmdStatus = 0;
   }

   if (parent.setContentFrameLoaded) {
      parent.setContentFrameLoaded(true);
   }

   displayCmdStatus(cmdStatus);
}

function onSubmit()
{
	document.profile.submit();
}


</script>

</head>
<body class="content" onload="initializeState();">
<p>
</p>
<form name="profile" action="" method="POST" id="profile">

	<input type="hidden" name="logonId" value="" id="ShopperSummaryB2BDialog_FormInput_logonId_In_profile_1" />
	<input type="hidden" name="XML" value="" id="ShopperSummaryB2BDialog_FormInput_XML_In_profile_1" />
	<input type="hidden" name="URL" value="" id="ShopperSummaryB2BDialog_FormInput_URL_In_profile_1" />

<h1><%= userNLS.get("customerSummaryTitle") %></h1>
<p><b><%=userNLS.get("generalHeader")%></b>
<br />
	<%=userNLS.get("logonid")%>&nbsp;
	<i><%=UIUtil.toHTML(registerDataBean.getLogonId()) %></i>
<br />
	<%=userNLS.get("custName")%>:&nbsp;
	<i><script type="text/javascript">displayNameSummary()
</script></i>
<br />
	<%=userNLS.get("orgAccount")%>:&nbsp;
<% if (accountDBean != null) { %>
	<i><%=UIUtil.toHTML(accountDBean.getAccountName()) %></i>
<% } %>
<br />
	<%=userNLS.get("challengeQuestion")%>:&nbsp;
	<i><%=UIUtil.toHTML(registerDataBean.getChallengeQuestion())%></i>
<br />
	<%=userNLS.get("challengeAnswer")%>:&nbsp;
	<i><%=UIUtil.toJavaScript(registerDataBean.getChallengeAnswer())%></i>
<br />
	<%=userNLS.get("clientCertificate")%>:&nbsp;
	<i>
<% if (certStatus != "") { %>
  	<% if (certStatus == "V") {%><%=userNLS.get("valid")%><%}%>
  	<% if (certStatus == "E") {%><%=userNLS.get("expired")%><%}%>
	<% if (certStatus == "R") {%><%=userNLS.get("revoked")%><%}%>
<% } else { %>
	<%=userNLS.get("noCertificate")%>
<% } %>
	</i>
<br />
	<%=userNLS.get("status")%>:&nbsp;
	<i>
<% if (userRegistry.getStatus().equals("1")) {%>
	<%=userNLS.get("accountStatusEnabled")%>
<% } else { %>
  	<%=userNLS.get("accountStatusDisabled")%>
<% } %>
	</i>
<br /></p>
<p><b><%=userNLS.get("contactHeader")%></b>
<table border="0" cellpadding="0" cellspacing="0" id="ShopperSummaryB2BDialog_Table_1">
    <tr valign="top">
	<td id="ShopperSummaryB2BDialog_TableCell_1">
	<%=userNLS.get("address")%>:&nbsp;
	</td>
	<td id="ShopperSummaryB2BDialog_TableCell_2">
	<i><script type="text/javascript">displayAddrSummary(0)
	</script></i>
	</td>
    </tr>
    <tr valign="top">
	<td id="ShopperSummaryB2BDialog_TableCell_3"></td>
	<td id="ShopperSummaryB2BDialog_TableCell_4">
	<i><script type="text/javascript">displayAddrSummary(1)
	</script></i>
	</td>
    </tr>
    <tr valign="top">
	<td id="ShopperSummaryB2BDialog_TableCell_5"></td>
	<td id="ShopperSummaryB2BDialog_TableCell_6">
	<i><script type="text/javascript">displayAddrSummary(2)
	</script></i>
	</td>
    </tr>
    <tr valign="top">
	<td id="ShopperSummaryB2BDialog_TableCell_7"></td>
	<td id="ShopperSummaryB2BDialog_TableCell_8">
	<i><script type="text/javascript">displayAddrSummary(3)
	</script></i>
	</td>
    </tr>
    <tr valign="top">
	<td id="ShopperSummaryB2BDialog_TableCell_9"></td>
	<td id="ShopperSummaryB2BDialog_TableCell_10">
	<i><script type="text/javascript">displayAddrSummary(4)
	</script></i>
	</td>
    </tr>
</table>
	<%=userNLS.get("phone")%>:&nbsp;
	<i><%=UIUtil.toHTML(address.getPhone1())%></i>
<br />
	<%=userNLS.get("fax")%>:&nbsp;
	<i><%=UIUtil.toHTML(address.getFax1())%></i>
<br />
	<%=userNLS.get("email")%>:&nbsp;
        <i><%=UIUtil.toHTML(address.getEmail1())%></i>
<br /></b>
<p><b><%=userNLS.get("orgHeader")%></b>
<br />
<table border="0" cellpadding="0" cellspacing="0" id="ShopperSummaryB2BDialog_Table_2">
    <tr valign="top">
	<td id="ShopperSummaryB2BDialog_TableCell_11">
	<%=orgEntityNLS.get("OrgEntityDeliveryDescription")%>:&nbsp;
	</td>
	<td id="ShopperSummaryB2BDialog_TableCell_12">
<% if (orgEntity != null) { %>
	<i><%=UIUtil.toHTML(orgEntity.getDescription())%></i>
<% } %>
	</td>
    </tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" id="ShopperSummaryB2BDialog_Table_3">
    <tr valign="top">
	<td id="ShopperSummaryB2BDialog_TableCell_13">
	<%=orgEntityNLS.get("OrgEntityGeneralBusCat")%>:&nbsp;
	</td>
	<td id="ShopperSummaryB2BDialog_TableCell_14">
<% if (orgEntity != null) { %>
	<i><%=UIUtil.toHTML(orgEntity.getBusinessCategory())%></i></p>
<% } %>
	</td>
    </tr>
</table>

</form>
<%
}
catch (Exception e)
{
	e.printStackTrace();
}

%>

</body>
</html>



