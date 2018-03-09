<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2017 All Rights Reserved.

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
//* (c) Copyright IBM Corp. 2001, 2002, 2006
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
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>
<%@ page import="com.ibm.commerce.tools.optools.user.beans.UserSearchDataBean" %>
<%@include file="../common/common.jsp" %>

<%--
//---------------------------------------------------------------------
//- Method Declarion
//---------------------------------------------------------------------
--%>
<%!
private AccountDataBean[] accountList = null;

private String getAccountName(String aUserId, HttpServletRequest aRequest) {
       AccountDataBean account = getUserOrgAccount(aUserId, aRequest);
       if (account == null) {
              return "";
       } else {
              return account.getAccountName();
       }
}
private String getAccountId(String aUserId, HttpServletRequest aRequest) {
       AccountDataBean account = getUserOrgAccount(aUserId, aRequest);
       if (account == null) {
              return "";
       } else {
              return account.getAccountId();
       }
}

private String getUserProfileType(String aUserId, HttpServletRequest aRequest) {
       UserDataBean aUserBean = new UserDataBean();
       String aProfileType = "";
       try {
              aUserBean.setInitKey_memberId(aUserId);
              DataBeanManager.activate(aUserBean, aRequest);
              aProfileType = aUserBean.getProfileType();
       } catch (Exception e) {
       		System.err.println("User ID: " + aUserId);
       		e.printStackTrace();
       }

       return aProfileType;


}

private AccountDataBean getUserOrgAccount(String aUserId, HttpServletRequest aRequest) {
   AccountDataBean account        = null;
       int numAccounts = 0;

   if (accountList != null) {
              numAccounts = accountList.length;
       } else {
              return account;
       }

       Long parentOrgMemberId = null;
       UserDataBean aUserBean = new UserDataBean();
       Long[] ancestorList = getAncestors(new Long(aUserId));

       if (ancestorList == null) {
              return account;
       } else {
              parentOrgMemberId = ancestorList[ancestorList.length-1];
              if ( (parentOrgMemberId.toString().equals("-2001")) &&
                              ancestorList.length > 1) {
                              parentOrgMemberId = ancestorList[ancestorList.length-2];
              }
       }

       for (int k=0; k<numAccounts; k++) {
              if (parentOrgMemberId != null && accountList[k].getCustomerId() != null &&
                            accountList[k].getCustomerId().equals(parentOrgMemberId.toString())) {
                     account = accountList[k];
                     break;
              }
       }

       return account;
} 

private Long[] getAncestors(Long aUserId) {
       Vector vecAncestor = new Vector();
       Long[] AncestorList = null;
       MemberRelationshipsAccessBean abMemberRelationships = new MemberRelationshipsAccessBean();
       try {
                     Enumeration eum = abMemberRelationships.findAncestors(aUserId);
                     if (eum.hasMoreElements()) {
                      	while (eum.hasMoreElements()) {
                                   abMemberRelationships = (MemberRelationshipsAccessBean) eum.nextElement();
                                   Long nAncester = ((MemberRelationshipsKey)abMemberRelationships.getPrimaryKey()).getAncestor();
                                   vecAncestor.addElement(nAncester);
                        }
                     } else {
                            vecAncestor.addElement(new Long("-2000"));
                            vecAncestor.addElement(new Long("-2001"));
                     }
       } catch (Exception e) {
       		System.err.println("User ID: " + aUserId);
       		e.printStackTrace();
       }
       AncestorList = new Long[vecAncestor.size()];
       vecAncestor.copyInto(AncestorList);
       return AncestorList;       
}

%>
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
       JSPHelper jspHelper        = new JSPHelper(request);

       userNLS               = (Hashtable)ResourceDirectory.lookup("csr.userNLS", cmdContext.getLocale());
       returnsNLS        = (Hashtable)ResourceDirectory.lookup("returns.ReturnsNLS", cmdContext.getLocale());

       formats = (Hashtable)ResourceDirectory.lookup("csr.nlsFormats");
       format = (Hashtable)XMLUtil.get(formats, "nlsFormats."+ cmdContext.getLocale().toString());
       if (format == null) {
              format = (Hashtable)XMLUtil.get(formats, "nlsFormats.default");
       } 
       String nameOrder = (String)XMLUtil.get(format, "name.order");


       // get standard list parameters
       String xmlFile               = jspHelper.getParameter("ActionXMLFile");
       Integer startIndex        = new Integer(jspHelper.getParameter("startindex"));
       Integer listSize               = new Integer(jspHelper.getParameter("listsize"));
       int endIndex       = startIndex.intValue() + listSize.intValue();
       int rowselect        = 1;

       // get input parameters    
       String logonid              = UIUtil.toHTML(jspHelper.getParameter("logonid"));
       String firstName       = UIUtil.toHTML(jspHelper.getParameter("firstName"));
       String lastName       = UIUtil.toHTML(jspHelper.getParameter("lastName"));
       String phone              = UIUtil.toHTML(jspHelper.getParameter("phone"));       
       String email              = UIUtil.toHTML(jspHelper.getParameter("email"));
       String city                     = UIUtil.toHTML(jspHelper.getParameter("city"));
       String zip                     = UIUtil.toHTML(jspHelper.getParameter("zip"));
       String account              = UIUtil.toHTML(jspHelper.getParameter("account"));
       String orderByParam = UIUtil.toHTML(jspHelper.getParameter("orderby"));
       String passwordReset = UIUtil.toHTML(jspHelper.getParameter("passwordReset"));
       String logonidST        = UIUtil.toHTML(jspHelper.getParameter("logonidSearchType"));
       String firstNameST        = UIUtil.toHTML(jspHelper.getParameter("firstNameSearchType"));
       String lastNameST        = UIUtil.toHTML(jspHelper.getParameter("lastNameSearchType"));
       String phoneST               = UIUtil.toHTML(jspHelper.getParameter("phoneSearchType"));
       String emailST               = UIUtil.toHTML(jspHelper.getParameter("emailSearchType"));
       String cityST               = UIUtil.toHTML(jspHelper.getParameter("citySearchType"));
       String zipST               = UIUtil.toHTML(jspHelper.getParameter("zipSearchType"));

       // get all accounts
       AccountListDataBean accountBean;

       accountBean = new AccountListDataBean();
       DataBeanManager.activate(accountBean, request);
       accountList = accountBean.getAccountList();

       Vector userIds = null;

       UserSearchDataBean userSearchDB = new UserSearchDataBean();
       userSearchDB.setLogonId(logonid);
       userSearchDB.setFirstName(firstName);
       userSearchDB.setLastName(lastName);
       userSearchDB.setPhone(phone);
       userSearchDB.setEmail(email);
       userSearchDB.setCity(city);
       userSearchDB.setZip(zip);
       userSearchDB.setAccountId(account);   
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
       int totalpage = totalsize / listSize.intValue();
       int userNum   = userIds.size();

	   // RM: d72257: The user might not have access to view all of the users who come back from
	   // this query. So we need to filter the list.
	   // Store the userInfo temporarily in a vector of 8-position string arrays
	   Vector vecUserInfo = new Vector(); 

       // Call UserRegistryDataBean to get LogonId
       // Call AddressAccessBean to get Address-related info

       UserRegistryDataBean aUserRegistry;
       AddressAccessBean aUserAddress;
       String strarrCurrUserInfo[] = null;
       
       for (int i = 0; i < userNum; i++) {

              try {
              
                     aUserRegistry = new UserRegistryDataBean();
                     aUserRegistry.setInitKey_userId((String)userIds.get(i));
                     DataBeanManager.activate(aUserRegistry, request);

                     strarrCurrUserInfo = new String[8];
                     strarrCurrUserInfo[0] = aUserRegistry.getLogonId();
                     
                     AddressAccessBean oneAddress = new AddressAccessBean();
                     aUserAddress = 
                     	oneAddress
                     	.findSelfAddressByMember(ECStringConverter.StringToLong((String)userIds.get(i)));

                   	 strarrCurrUserInfo[1] = aUserAddress.getFirstName();
                     strarrCurrUserInfo[2] = aUserAddress.getLastName();
                     strarrCurrUserInfo[3] = aUserAddress.getPhone1();
                     strarrCurrUserInfo[4] = aUserAddress.getCity();
                     strarrCurrUserInfo[5] = aUserAddress.getZipCode();
                     strarrCurrUserInfo[6] = getAccountName((String)userIds.get(i),request);
                     strarrCurrUserInfo[7] = (String)userIds.get(i);
                     vecUserInfo.addElement(strarrCurrUserInfo);
              } 
              catch (Exception e) {
                    // Not expecting any exceptions; UserSearchBean returns only authorized users
                    System.err.println("User ID: " + (String)userIds.get(i));
                    e.printStackTrace();
              }
       }

		// Bundle the records back in a 2-D array
		String userInfo[][] = new String[vecUserInfo.size()][8];
		for (int i=0; i<vecUserInfo.size(); i++) {
			userInfo[i] = (String[])vecUserInfo.get(i);
		}
		
		// update the totalsize variable, in case the totalsize is now 0
		if ((totalsize == userNum) && vecUserInfo.isEmpty()) {
			totalsize = 0;
		}
		
		// update the userNum
		userNum = vecUserInfo.size();
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
<script language="JavaScript" type="text/javascript">
<!--
//---------------------------------------------------------------------
//  Initialize the list data (Global)
//---------------------------------------------------------------------
var users = new Object();
var aUser;

<% for (int i=0; i<userNum; i++) { %>
	aUser = new Object();
	aUser["logonId"] = "<%=userInfo[i][0]%>";
	<% String strUserId = userInfo[i][7]; %>
	aUser["accountId"] = "<%=getAccountId(strUserId, request)%>";
	aUser["userType"] = "<%=getUserProfileType(strUserId, request)%>";
	users["<%=strUserId%>"] = aUser;
<% } %>

function getLogonId(userId) {
       tmpUser = users[userId];
       if (tmpUser != null) {
              return tmpUser["logonId"];
       } else {
              return "";
       }
}
function getAccountId(userId) {
       tmpUser = users[userId];
       if (tmpUser != null) {
              return tmpUser["accountId"];
       } else {
              return "";
       }
}
function getUserType(userId) {
       tmpUser = users[userId];
       if (tmpUser != null) {
              return tmpUser["userType"];
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
                         + "ActionXMLFile=csr.shopperListB2B&cmd=ShopperListB2B"
                         + "&listsize=22&startindex=0"
                         + "&logonid=" + "<%=UIUtil.toJavaScript(logonid)%>"
                         + "&firstName=" + "<%=UIUtil.toJavaScript(firstName)%>"
                         + "&lastName=" + "<%=UIUtil.toJavaScript(lastName)%>"
                         + "&phone=" + "<%=UIUtil.toJavaScript(phone)%>"
                         + "&email=" + "<%=UIUtil.toJavaScript(email)%>"
                         + "&city=" + "<%=UIUtil.toJavaScript(city)%>"
                         + "&zip=" + "<%=UIUtil.toJavaScript(zip)%>"
                         + "&account=" + "<%=account%>"
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
//       alert("DEBUG: " + msg);
}

function getLocale() {
       return <%=cmdContext.getLocale().toString()%>;
}       

function customerLink(id) {
       debugAlert(id);
       if (getUserType(id) == "B") {
              customerSummary(id);
       } else {
              changeCustomerInfo(id);
       }
}

function updateButtonState() {
       var checked = parent.getChecked();
       if (checked.length == 1) {       
              debugAlert("evaluate the button status");
              debugAlert(getAccountId(parent.getSelected()));
              if (getAccountId(parent.getSelected()) == "") {
                     parent.buttons.buttonForm.accountSummaryButton.className       = 'disabled';
              }
              if (getAccountId(parent.getSelected()) == "" || getUserType(parent.getSelected()) != "B") {
                     parent.buttons.buttonForm.contractsButton.className              = 'disabled';
              }
              if (getUserType(parent.getSelected()) == "B") {
                     parent.buttons.buttonForm.changeButton.className                     = 'disabled';
              } else {
                     parent.buttons.buttonForm.customerSummaryTitleButton.className       = 'disabled';
              }
       }
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
function getCustomerSummaryTitle() {
       return "<%= UIUtil.toJavaScript((String)userNLS.get("customerSummaryTitle")) %>";
}
function getContractsTitle() {
       return "<%= UIUtil.toJavaScript((String)userNLS.get("contracts")) %>";
}
function getAccountSummaryTitle() {
       return "<%= UIUtil.toJavaScript((String)userNLS.get("accountSummary")) %>";
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
                         + "ActionXMLFile=csr.shopperListB2B&cmd=ShopperListB2B"
                         + "&listsize=22&startindex=0"
                             + "&logonid=" + "<%=UIUtil.toJavaScript(logonid)%>"
                             + "&firstName=" + "<%=UIUtil.toJavaScript(firstName)%>"
                             + "&lastName=" + "<%=UIUtil.toJavaScript(lastName)%>"
                             + "&phone=" + "<%=UIUtil.toJavaScript(phone)%>"
                             + "&email=" + "<%=UIUtil.toJavaScript(email)%>"
                             + "&city=" + "<%=UIUtil.toJavaScript(city)%>"
                             + "&zip=" + "<%=UIUtil.toJavaScript(zip)%>"
                             + "&account=" + "<%=account%>"
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
       
       if (getUserType(id) == "B") {
              debugAlert("selected user is a business user");
              // I need a message in case this is true:
              return;
       }
              
       // The following url will not contains NLS data
       top.setContent(getNotebookTitle(), '/webapp/wcs/tools/servlet/NotebookView?XMLFile=csr.shopperNotebook&amp;shrfnbr='+id+'&amp;locale=<%=cmdContext.getLocale().toString()%>',true);
       return;
}

// Summary button action
function customerSummary(id) {
       if (id == null && parent.buttons.buttonForm.customerSummaryTitleButton.className=='disabled') {
              return;
       }
       if (id == null) {
              id = parent.getSelected();
       }

       debugAlert(id);

       if (getUserType(id) != "B") {
              debugAlert("selected user is not a business user");
              // I need a message in case this is true:
              return;
       }

       // The following url will not contains NLS data
       top.setContent(getCustomerSummaryTitle(), '/webapp/wcs/tools/servlet/DialogView?XMLFile=csr.shopperSummaryB2B&amp;shrfnbr='+id+'&amp;locale=<%=cmdContext.getLocale().toString()%>&amp;account='+getAccountId(id)+'&amp;cmdStatus=0',true);
       return;
}

//
function listContracts() {
       // !!! Notice listContracts is to list all the contracts that are belonging to the customer's 
       // !!! organization account
       if (parent.buttons.buttonForm.contractsButton.className=='disabled') {
              return;
       }
       
       
       // The following url will not contains NLS data
              top.setContent(getContractsTitle(),'/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=contract.ContractList&amp;cmd=ContractListView&amp;accountId='+getAccountId(parent.getSelected()),true);
       return;
}

// Account Summary buttona ction
function listAccountSummary() {
       if (parent.buttons.buttonForm.accountSummaryButton.className=='disabled') {
              return;
       }
       debugAlert(getLogonId(parent.getSelected()));

       if (getAccountId(parent.getSelected()) == "") {
              debugAlert("selected user does not belong to an account");
              // I need a message in case this is true:
              return;
       }
       
       // The following url will not contains NLS data
       top.setContent(getAccountSummaryTitle(),'/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.AccountSummary&amp;accountId='+getAccountId(parent.getSelected()),true);       
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

<form action='' name='ShopperListForm' id='ShopperListForm'>
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
              <%= comm.addDlistColumnHeading((String)userNLS.get("account"), null, false) %>
       <%= comm.endDlistRow() %>

       <%
       if (endIndex > totalsize) {
              endIndex = totalsize;
       }

       String strUserId = null;
       // TABLE CONTENT
       for (int i=0; i<userNum; i++) {
              strUserId = userInfo[i][7];
       %>
              <%= comm.startDlistRow(rowselect) %>
                     <%= comm.addDlistCheck(strUserId, "parent.setChecked();updateButtonState('"+strUserId+"')") %>
                     <%= comm.addDlistColumn(userInfo[i][0], "javascript:customerLink('"+strUserId+"')") %>
                     <% if (nameOrder.indexOf("first") < nameOrder.indexOf("last")) { %>
                            <%= comm.addDlistColumn(userInfo[i][1], "none") %>
                            <%= comm.addDlistColumn(userInfo[i][2], "none") %>
                     <%} else {%>
                            <%= comm.addDlistColumn(userInfo[i][2], "none") %>
                            <%= comm.addDlistColumn(userInfo[i][1], "none") %>                            
                     <%}%>
                     <%= comm.addDlistColumn(userInfo[i][3], "none") %>
                     <%= comm.addDlistColumn(userInfo[i][4], "none") %>
                     <%= comm.addDlistColumn(userInfo[i][5], "none") %>
                     <%= comm.addDlistColumn(userInfo[i][6], "none") %>
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
<table cellspacing="0" cellpadding="3" border="0" id="ShopperListB2B_Table_1">
<tr>
       <td colspan="7" id="ShopperListB2B_TableCell_1">
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
