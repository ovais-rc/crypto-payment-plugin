<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!--
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
-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
--%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.tools.optools.user.beans.*" %>
<%@ page import="com.ibm.commerce.tools.optools.user.helpers.*" %>
<%@ page import="com.ibm.commerce.tools.optools.common.helpers.*" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>
<%@ page import="com.ibm.commerce.tools.optools.user.beans.UserSearchDataBean" %>
<%@include file="../common/common.jsp" %>

<%--
//---------------------------------------------------------------------
//- Method Declarion
//---------------------------------------------------------------------
--%>

<%--
//---------------------------------------------------------------------
//- Logic Section
//---------------------------------------------------------------------
--%>
<%
try {
	Hashtable userNLS = null;
	Hashtable returnsNLS = null;
	Hashtable formats = null;
	Hashtable format  = null;

	CommandContext cmdContext = (CommandContext)request.getAttribute("CommandContext");
	Integer storeID = cmdContext.getStoreId();
	JSPHelper jspHelper 	= new JSPHelper(request);

	userNLS 		= (Hashtable)ResourceDirectory.lookup("csr.userNLS", cmdContext.getLocale());
	returnsNLS 	= (Hashtable)ResourceDirectory.lookup("returns.ReturnsNLS", cmdContext.getLocale());

	formats = (Hashtable)ResourceDirectory.lookup("csr.nlsFormats");
	format = (Hashtable)XMLUtil.get(formats, "nlsFormats."+ cmdContext.getLocale().toString());
	if (format == null) {
		format = (Hashtable)XMLUtil.get(formats, "nlsFormats.default");
	} 
	String nameOrder = (String)XMLUtil.get(format, "name.order");


	// get standard list parameters
	String xmlFile 		= jspHelper.getParameter("ActionXMLFile");
	Integer startIndex 	= new Integer(jspHelper.getParameter("startindex"));
	Integer listSize 		= new Integer(jspHelper.getParameter("listsize"));
	int endIndex	= startIndex.intValue() + listSize.intValue();
	int rowselect 	= 1;

	// get input parameters    
	String logonid		= UIUtil.toHTML(jspHelper.getParameter("logonid"));
	String firstName	= UIUtil.toHTML(jspHelper.getParameter("firstName"));
	String lastName	= UIUtil.toHTML(jspHelper.getParameter("lastName"));
	String phone		= UIUtil.toHTML(jspHelper.getParameter("phone"));	
	String email		= UIUtil.toHTML(jspHelper.getParameter("email"));
	String city			= UIUtil.toHTML(jspHelper.getParameter("city"));
	String zip			= UIUtil.toHTML(jspHelper.getParameter("zip"));

	String orderByParam = UIUtil.toHTML(jspHelper.getParameter("orderby"));
	String passwordReset = UIUtil.toHTML(jspHelper.getParameter("passwordReset"));
	String logonidST 	= UIUtil.toHTML(jspHelper.getParameter("logonidSearchType"));
	String firstNameST 	= UIUtil.toHTML(jspHelper.getParameter("firstNameSearchType"));
	String lastNameST 	= UIUtil.toHTML(jspHelper.getParameter("lastNameSearchType"));
	String phoneST 		= UIUtil.toHTML(jspHelper.getParameter("phoneSearchType"));
	String emailST 		= UIUtil.toHTML(jspHelper.getParameter("emailSearchType"));
	String cityST 		= UIUtil.toHTML(jspHelper.getParameter("citySearchType"));
	String zipST 		= UIUtil.toHTML(jspHelper.getParameter("zipSearchType"));

	Vector userIds = null;

	UserSearchDataBean userSearchDB = new UserSearchDataBean();
	userSearchDB.setLogonId(logonid);
	userSearchDB.setFirstName(firstName);
	userSearchDB.setLastName(lastName);
	userSearchDB.setPhone(phone);
	userSearchDB.setEmail(email);
	userSearchDB.setCity(city);
	userSearchDB.setZip(zip);
	userSearchDB.setOrderBy(orderByParam);
	userSearchDB.setStartIndex(startIndex.toString());
	userSearchDB.setListSize(listSize.toString());
	userSearchDB.setLogonIdSearchType(logonidST);
	userSearchDB.setFirstNameSearchType(firstNameST);
	userSearchDB.setLastNameSearchType(lastNameST);
	userSearchDB.setPhoneSearchType(phoneST);
	userSearchDB.setEmailSearchType(emailST);
	userSearchDB.setCitySearchType(cityST);
	userSearchDB.setZipSearchType(zipST);
	DataBeanManager.activate(userSearchDB, request);
	userIds = userSearchDB.getUserIds();
	int totalsize = Integer.parseInt(userSearchDB.getResultSize());
	int totalpage	= totalsize / listSize.intValue();
	int userNum = userIds.size();
	// Create 2-D arrays for all users information
	String[][] userInfo = new String[userNum][6];

	// Call UserRegistryDataBean to get LogonId
	// Call AddressAccessBean to get Address-related info

	UserRegistryDataBean aUserRegistry;
	AddressAccessBean aUserAddress;
	for (int i = 0; i < userNum; i++) {

		try {
			aUserRegistry = new UserRegistryDataBean();
			aUserRegistry.setInitKey_userId((String)userIds.get(i));
			DataBeanManager.activate(aUserRegistry, request);
			userInfo[i][0] = aUserRegistry.getLogonId();

			AddressAccessBean oneAddress = new AddressAccessBean();
			aUserAddress = oneAddress.findSelfAddressByMember(ECStringConverter.StringToLong((String)userIds.get(i)));

			userInfo[i][1] = aUserAddress.getFirstName();
			userInfo[i][2] = aUserAddress.getLastName();
			userInfo[i][3] = aUserAddress.getPhone1();
			userInfo[i][4] = aUserAddress.getCity();
			userInfo[i][5] = aUserAddress.getZipCode();

		} catch (Exception e) {

		}

	}


%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css" />
<title><%= userNLS.get("listTableSummary") %></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js">
</script>
<script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js">
</script>
<script type="text/javascript" src="/wcs/javascript/tools/csr/user.js">
</script>
<script type="text/javascript" language="JavaScript">
<!--
//---------------------------------------------------------------------
//  Initialize the list data (Global)
//---------------------------------------------------------------------
var users = new Object();
var aUser;

<% for (int i=0; i<userNum; i++) { %>
aUser = new Object();
aUser["logonId"] = "<%=userInfo[i][0]%>";
users["<%=(String)userIds.get(i)%>"] = aUser;
<% } %>

function getLogonId(userId) {
	tmpUser = users[userId];
	if (tmpUser != null) {
		return tmpUser["logonId"];
	} else {
		return "";
	}
}

//---------------------------------------------------------------------
//  Required javascript function for dynamic list
//---------------------------------------------------------------------
function onLoad() {
	parent.loadFrames();
	var resetPwdOk = "<%=passwordReset%>";
	if (resetPwdOk == "true") {
		alertDialog("<%= UIUtil.toJavaScript( (String)userNLS.get("passwdReset")) %>");
		redirectPage = "/webapp/wcs/tools/servlet/NewDynamicListView?"
			    + "ActionXMLFile=csr.shopperListB2C&cmd=ShopperListB2C"
			    + "&listsize=22&startindex=0"
			 + "&logonid=" + "<%=UIUtil.toJavaScript(logonid)%>"
			 + "&firstName=" + "<%=UIUtil.toJavaScript(firstName)%>"
			 + "&lastName=" + "<%=UIUtil.toJavaScript(lastName)%>"
			 + "&phone=" + "<%=UIUtil.toJavaScript(phone)%>"
			 + "&email=" + "<%=UIUtil.toJavaScript(email)%>"
			 + "&city=" + "<%=UIUtil.toJavaScript(city)%>"
			 + "&zip=" + "<%=UIUtil.toJavaScript(zip)%>"
			 + "&orderby=" + "<%=orderByParam%>"
			 + "&logonidSearchType=" + "<%=logonidST%>"
			 + "&firstNameSearchType=" + "<%=firstNameST%>"
			 + "&lastNameSearchType=" + "<%=lastNameST%>"
			 + "&phoneSearchType=" + "<%=phoneST%>"
			 + "&emailSearchType=" + "<%=emailST%>"
			 + "&citySearchType=" + "<%=cityST%>"
			 + "&zipSearchType=" + "<%=zipST%>"
			 + "&passwordReset=false";
		top.showContent(redirectPage);
	}
}

function getResultsSize() {
	return <%=userSearchDB.getResultSize() %>;
}

//---------------------------------------------------------------------
//  user defined javascript functions 
//---------------------------------------------------------------------
function debugAlert(msg) {
//	alert("DEBUG: " + msg);
}

function getLocale() {
	return <%=cmdContext.getLocale().toString()%>;
}	

//---------------------------------------------------------------------
//  GUI functions - Button labels
//---------------------------------------------------------------------
function getNotebookTitle() {
	return "<%= UIUtil.toJavaScript((String)userNLS.get("shopperPropertyNotebookTitle")) %>";
}
function getWizardTitle() {
	return "<%= UIUtil.toJavaScript((String)userNLS.get("shopperPropertyWizardTitle")) %>";
}
function getOrdersTitle() {
	return "<%= UIUtil.toJavaScript((String)userNLS.get("orderHistory")) %>";
}
function getPlaceOrderTitle() {
	return "<%= UIUtil.toJavaScript((String)userNLS.get("custPlaceOrder")) %>";
}
function getReturnListTitle() {
	return "<%= UIUtil.toJavaScript((String)returnsNLS.get("returnListTitle")) %>";
}
function getNewReturnTitle() {
	return "<%= UIUtil.toJavaScript((String)userNLS.get("custNewReturn")) %>";	
}
function getResetPasswordTitle() {
	return "<%= UIUtil.toJavaScript((String)userNLS.get("resetPassword")) %>";
}
function getContractsTitle() {
	return "<%= UIUtil.toJavaScript((String)userNLS.get("contracts")) %>";
}

//---------------------------------------------------------------------
//  GUI functions - Button actions
//---------------------------------------------------------------------
// Reset Password button action
function resetPassword(pMsg) {
	debugAlert(parent.getSelected());
	debugAlert(getLogonId(parent.getSelected()));
	if (pMsg == null || pMsg == "") {
		pMsg = "<%= UIUtil.toJavaScript((String)userNLS.get("passwdPrompt"))%>";
	}
	var password = parent.promptDialog(pMsg, "", 80, true);
   
	// ResetPassword is cancel
	if (password == null) {
		debugAlert("password is null");
		return;
	}
	// administrator's password is not entered
	if (password == "") {
		debugAlert("password is empty");
		resetPassword("<%= UIUtil.toJavaScript((String)userNLS.get("passwdFailure"))%>");
		return;
	}
	
	redirectPage = "/webapp/wcs/tools/servlet/NewDynamicListView?"
			    + "ActionXMLFile=csr.shopperListB2C&cmd=ShopperListB2C"
			    + "&listsize=22&startindex=0"
				 + "&logonid=" + "<%=UIUtil.toJavaScript(logonid)%>"
				 + "&firstName=" + "<%=UIUtil.toJavaScript(firstName)%>"
				 + "&lastName=" + "<%=UIUtil.toJavaScript(lastName)%>"
				 + "&phone=" + "<%=UIUtil.toJavaScript(phone)%>"
				 + "&email=" + "<%=UIUtil.toJavaScript(email)%>"
				 + "&city=" + "<%=UIUtil.toJavaScript(city)%>"
				 + "&zip=" + "<%=UIUtil.toJavaScript(zip)%>"
				 + "&orderby=" + "<%=orderByParam%>"
				 + "&logonidSearchType=" + "<%=logonidST%>"
				 + "&firstNameSearchType=" + "<%=firstNameST%>"
				 + "&lastNameSearchType=" + "<%=lastNameST%>"
				 + "&phoneSearchType=" + "<%=phoneST%>"
				 + "&emailSearchType=" + "<%=emailST%>"
				 + "&citySearchType=" + "<%=cityST%>"
				 + "&zipSearchType=" + "<%=zipST%>"
				 + "&passwordReset=true";
						
	var url = "/webapp/wcs/tools/servlet/AdminResetPassword";
	var urlPara = new Object();
	urlPara.logonId=getLogonId(parent.getSelected());
	urlPara.administratorPassword=password;
	urlPara.URL=redirectPage;
			
	top.showContent(url, urlPara);
}

function createCustomerInfo() {
	top.setContent(getWizardTitle(), '/webapp/wcs/tools/servlet/WizardView?XMLFile=csr.shopperWizard',true);
	return;
	
}
// Change button action
function changeCustomerInfo(id) {
	if (id == null && parent.buttons.buttonForm.changeButton.className=='disabled') {
		return;
	}
	if (id == null) {
			id = parent.getSelected();
	}
	
	debugAlert(id);
	
	// The following url will not contains NLS data
	top.setContent(getNotebookTitle(), '/webapp/wcs/tools/servlet/NotebookView?XMLFile=csr.shopperNotebook&amp;shrfnbr='+id+'&amp;locale=<%=cmdContext.getLocale().toString()%>',true);
	return;
}

//-->

</script>
</head>
<body class="content">
<script type="text/javascript">
<!--
//for IE
if (document.all) {
	onLoad();
}
//-->

</script>

<%= comm.addControlPanel(xmlFile, totalpage, totalsize, cmdContext.getLocale()) %>

<form name='ShopperListForm' id='ShopperListForm'>
	<%= comm.startDlistTable((String)userNLS.get("listTableSummary")) %>
	<%= comm.startDlistRowHeading() %>
		<%= comm.addDlistCheckHeading() %>
		<%= comm.addDlistColumnHeading((String)userNLS.get("custLogon"), "LOGONID", orderByParam.equals("LOGONID")) %>
		<% if (nameOrder.indexOf("first") < nameOrder.indexOf("last")) { %>
			<%= comm.addDlistColumnHeading((String)userNLS.get("firstNameHeadline"), "FIRSTNAME", orderByParam.equals("FIRSTNAME")) %>
			<%= comm.addDlistColumnHeading((String)userNLS.get("lastNameHeadline"), "LASTNAME", orderByParam.equals("LASTNAME")) %>
		<%} else {%>	
			<%= comm.addDlistColumnHeading((String)userNLS.get("lastNameHeadline"), "LASTNAME", orderByParam.equals("LASTNAME")) %>
			<%= comm.addDlistColumnHeading((String)userNLS.get("firstNameHeadline"), "FIRSTNAME", orderByParam.equals("FIRSTNAME")) %>
		<%}%>	
		<%= comm.addDlistColumnHeading((String)userNLS.get("phoneNumberHeadline"), "PHONE1", orderByParam.equals("PHONE1")) %>
		<%= comm.addDlistColumnHeading((String)userNLS.get("city"), "CITY", orderByParam.equals("CITY")) %>
		<%= comm.addDlistColumnHeading((String)userNLS.get("zipHeadline"), "ZIPCODE", orderByParam.equals("ZIPCODE")) %>
	<%= comm.endDlistRow() %>

	<%
	if (endIndex > totalsize) {
		endIndex = totalsize;
	}


	// TABLE CONTENT
	for (int i=0; i<userNum; i++) {
	%>

		<%= comm.startDlistRow(rowselect) %>
			<%= comm.addDlistCheck((String)userIds.get(i), "none") %>
			<%= comm.addDlistColumn(UIUtil.toHTML(userInfo[i][0]), "none") %>
			<% if (nameOrder.indexOf("first") < nameOrder.indexOf("last")) { %>
				<%= comm.addDlistColumn(UIUtil.toHTML(userInfo[i][1]), "none") %>
				<%= comm.addDlistColumn(UIUtil.toHTML(userInfo[i][2]), "none") %>
			<%} else {%>
				<%= comm.addDlistColumn(UIUtil.toHTML(userInfo[i][2]), "none") %>
				<%= comm.addDlistColumn(UIUtil.toHTML(userInfo[i][1]), "none") %>				
			<%}%>
			<%= comm.addDlistColumn(UIUtil.toHTML(userInfo[i][3]), "none") %>
			<%= comm.addDlistColumn(UIUtil.toHTML(userInfo[i][4]), "none") %>
			<%= comm.addDlistColumn(UIUtil.toHTML(userInfo[i][5]), "none") %>


		<%= comm.endDlistRow() %>

	<%
		if (rowselect == 1) {
			rowselect = 2;
		} else {
			rowselect = 1;
		}
	} 

	%>	
	<%= comm.endDlistTable() %>


<%
	if (totalsize == 0) {
%>

<p></p>
<table cellspacing="0" cellpadding="3" border="0" id="ShopperListB2C_Table_1">
<tr>
	<td colspan="7" id="ShopperListB2C_TableCell_1">
		<%=userNLS.get("noCustomersToList")%>
	</td>
</tr>
</table>
<% }
%>

</form>

<script type="text/javascript">
<!--
   parent.afterLoads();
   parent.setResultssize(<%=totalsize%>);
//-->

</script>
<%
} catch(Exception e) {
	e.printStackTrace();
}
%>
</body>
</html>
