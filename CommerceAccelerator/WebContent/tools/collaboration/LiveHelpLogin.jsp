<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2003
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
--%>
<%@ page language="java" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.collaboration.livehelp.beans.LiveHelpConfiguration" %>

<%@ include file="LiveHelpCommon.jsp" %>

<%
    com.ibm.commerce.server.WebModuleConfig webModConfig = WcsApp.configProperties.getWebModule(WcsApp.storeWebModuleName);
    String sStoreAppPath=webModConfig.getContextPath()+webModConfig.getUrlMappingPath() + "/";
try
{
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%= fLiveHelpHeader%>
<%
   String storeId = commandContext.getStoreId().toString();
   String langId = commandContext.getLanguageId().toString();
   String locale = commandContext.getLocale().toString();
   LiveHelpConfiguration aLiveHelpConfiguration = new LiveHelpConfiguration(commandContext);

   String placeName = storeId + "_store" + "@" + LiveHelpConfiguration.getInstanceName();
   String queueName = storeId + "_store" + "_queue" + "@" + LiveHelpConfiguration.getInstanceName();
   String wcsGuestId = "-1002";

%>
<title><%=(String)liveHelpNLS.get("customerCarePageTitleAgentFrame")%></title>
<script>
// set default configuration string
var CC_DEFAULT_MONITORING_LIST="";
var CC_DEFAULT_QUEUE="";
var CC_DEFAULT_SITE_URL="";
var CC_DEFAULT_STORE_URL="";
var CC_DEFAULT_STRORE_QUESTION="";
var CC_TIMEOUT = 60000;

var isIE = false;

if (document.all)
{
  isIE = true;
}

var username;
var password;
var userId;

var bQueueCfg=false;
var bListCfg=false;
var bSiteURL=false;
var bStoreURL=false;
var bStoreQuestion=false;
var bInitialCompleted = false;
var step = 0;
var timeOutId;


var MonitoringListURL;
var QueueConfigurationURL;
var SiteURLURL;
var StoreURLURL;
var StoreQuestionURL;


/**
 * set URL to access Monitoring List configuration
 * @param newURL URL address
 */
function setMonitoringListURL (newURL)
{
  MonitoringListURL= newURL;
}
/**
 * set URL to access Queue List configuration
 * @param newURL URL address
 */
function setQueueConfigurationURL (newURL)
{
  QueueConfigurationURL= newURL;
}
/**
 * set URL to access Site URL List configuration
 * @param newURL URL address
 */
function setSiteURLURL (newURL)
{
  SiteURLURL= newURL;
}
/**
 * set URL to access Store URL List configuration
 * @param newURL URL address
 */
function setStoreURLURL (newURL)
{
  StoreURLURL= newURL;
}
/**
 * set URL to access Store topic List configuration
 * @param newURL URL address
 */
function setStoreQuestionURL (newURL)
{
  StoreQuestionURL= newURL;
}
/**
 * set User id, name and password to access Sametime
 * @param id user Id
 * @param user user name
 * @param pass password
 */
function setUserPass (id, user,pass)
{
  userId= id;
  username = user;
  password = pass;
}

/**
 * retrives Customer Care configurations
 * @param isTimeOut a flag to indicates if it is called as a result of timeout or not
 */
function initAgentApplet (isTimeOut)
{
	if (step == 0) {
		if (isTimeOut == false ) {
			timeOutId=setTimeout("initAgentApplet(true)",CC_TIMEOUT);  // wait for 60 sec to Time out
			parent.getCCInformation(MonitoringListURL);
		}
		else {
			setMonitoringConfiguration(CC_DEFAULT_MONITORING_LIST); // set default after timeout
		}
	}
	else if (step == 1) {
		if (isTimeOut == false ) {
			timeOutId=setTimeout("initAgentApplet(true)",CC_TIMEOUT);  // wait for 60 sec to Time out
			parent.getCCInformation(QueueConfigurationURL);
		}
		else {
			setQueueConfiguration(CC_DEFAULT_QUEUE); // set default after timeout
		}
	}
	else if (step == 2) {
		if (isTimeOut == false ) {
			timeOutId=setTimeout("initAgentApplet(true)",CC_TIMEOUT);  // wait for 60 sec to Time out
			parent.getCCInformation(SiteURLURL);
		}
		else {
			setSiteURLConfiguration(CC_DEFAULT_SITE_URL); // set default after timeout
		}
	}
	else if (step == 3) {
		if (isTimeOut == false ) {
			timeOutId=setTimeout("initAgentApplet(true)",CC_TIMEOUT);  // wait for 60 sec to Time out
			parent.getCCInformation(StoreURLURL);
		}
		else {
			setStoreURLConfiguration(CC_DEFAULT_STORE_URL); // set default after timeout
		}
	}
	else if (step == 4) {
		if (isTimeOut == false ) {
			timeOutId=setTimeout("initAgentApplet(true)",CC_TIMEOUT);  // wait for 60 sec to Time out
			parent.getCCInformation(StoreQuestionURL);
		}
		else {
			setStoreQuestionConfiguration(CC_DEFAULT_STRORE_QUESTION); // set default after timeout
		}
	}
	else {
		setInitialCompleted();
	}
}

/**
 * pushes Queue configuration into Applet
 * @param strCfg configuration string in XML format
 */
function setQueueConfiguration (strCfg)
{
	clearTimeout(timeOutId);
	if (bQueueCfg==false) {
		bQueueCfg = true;
		document.applets["AgentApplet"].setQueueCfg(strCfg);
		step =step +1;
		initAgentApplet(false);
		}
}

/**
 * pushes Monitoring configuration into Applet
 * @param strCfg configuration string in XML format
 */
function setMonitoringConfiguration (strCfg)
{
	clearTimeout(timeOutId);
	if (bListCfg==false) {
		bListCfg= true;
		document.applets["AgentApplet"].setMLCfg(strCfg);
		step =step +1;
		initAgentApplet(false);
		}
}

/**
 * pushes Site URL configuration into Applet
 * @param strCfg configuration string in XML format
 */
function setSiteURLConfiguration (strCfg)
{
	clearTimeout(timeOutId);
	if (bSiteURL == false) {
		bSiteURL= true;
		document.applets["AgentApplet"].setURLCfg1(strCfg);
		step =step +1;
		initAgentApplet(false);
		}
}

/**
 * pushes Store URL configuration into Applet
 * @param strCfg configuration string in XML format
 */
function setStoreURLConfiguration (strCfg)
{
	clearTimeout(timeOutId);
	if (bStoreURL == false) {
		bStoreURL=true;
		document.applets["AgentApplet"].setURLCfg2(strCfg);
		step =step +1;
		initAgentApplet(false);
		}
}

/**
 * pushes Topic configuration into Applet
 * @param strCfg configuration string in XML format
 */
function setStoreQuestionConfiguration (strCfg)
{
	clearTimeout(timeOutId);
	if (bStoreQuestion == false) {
		bStoreQuestion= true;
		document.applets["AgentApplet"].setQustCfg(strCfg);
		step =step +1;
		initAgentApplet(false);
		}
}

/**
 * informs applet that it has completed all configuration retriving
 */
function setInitialCompleted ()
{
	clearTimeout(timeOutId);
	if (bInitialCompleted == false) {
		bInitialCompleted= true;
		document.applets["AgentApplet"].setCompleted();
		}
}

/**
 * returns user Id
 */
function getUserId()
{
  return userId;
}

/**
 * returns user name
 */
function getUser()
{
  return username;
}

/**
 * returns user password
 */
function getPassword()
{
  return password;
}

var txt;
	
</script>
</head>
<body>
<%
 	String _user = JSPHelper.htmlTextEncoder(aLiveHelpConfiguration.getLogonId(commandContext));
  	String _password = aLiveHelpConfiguration.getAuthentication(commandContext);
  	String _userId = commandContext.getUserId().toString();
  	String sRequestSchema=request.getScheme(); 
   	String sServer= request.getServerName();  
   	String sMonitorCFGUrl=response.encodeURL( sRequestSchema +"://"+sServer+ sStoreAppPath + "CCMonitorListView?storeId="+storeId);
   	String sQueueCfgUrl=response.encodeURL(sRequestSchema +"://"+sServer+":"+request.getServerPort()+ sWebAppPath + "CCQueueListView?storeId="+storeId + "&langId=" + langId);
   	String sSiteUrlListUrl=response.encodeURL(sRequestSchema +"://"+sServer+":"+request.getServerPort()+ sWebAppPath + "CCSiteURLListView?storeId="+storeId);
   	String sStoreUrlListUrl=response.encodeURL(sRequestSchema +"://"+sServer+ sStoreAppPath + "CCStoreURLListView?storeId="+storeId);
   	String sStoreQuestionUrl=response.encodeURL(sRequestSchema +"://"+sServer+ sStoreAppPath + "CCStoreQuestionListView?storeId="+storeId);
   	String sReadyUrl=response.encodeURL(sRequestSchema +"://"+sServer+":"+request.getServerPort()+ sWebAppPath + "CCAgentReadyPageView?storeId="+storeId);
%>
<script language="javascript">
setUserPass ('<%= _userId %>', '<%= _user %>', '<%= _password %>');
setMonitoringListURL ('<%=sMonitorCFGUrl%>');
setQueueConfigurationURL ('<%=sQueueCfgUrl%>');
setSiteURLURL ('<%=sSiteUrlListUrl%>');
setStoreURLURL ('<%=sStoreUrlListUrl%>');
setStoreQuestionURL ('<%=sStoreQuestionUrl%>');

</script>
<applet id="WC_LiveHelpLogin_Applet_1"
	code="com.ibm.commerce.collaboration.livehelp.st.wcsagent.AgentManager.class"
	codebase="<%= LiveHelpConfiguration.getAppletCodeBaseURL() %>"
	width="100%" height="100%" name="AgentApplet"
	alt="<%=(String)liveHelpNLS.get("customerCareCSRAppletTitle")%>"
	align="middle">

	<param name="ARCHIVE" value="WCSAgent.jar,xml-apis.jar,xercesimpl.jar" />
	<param name='USER_ID' value='<%= _userId %>' />
	<param name='USER_NAME' value='<%= _user %>' />
	<param name='USER_PSWD' value='<%= _password %>' />


	<param name='LDAP_ENABLED'
		value='<%=LiveHelpConfiguration.getLdapType()%>' />
	<param name='SSO_ENABLED'
		value='<%=LiveHelpConfiguration.getSingleSignOnType(request)%>' />
	<param name='SSO_TOKEN'
		value='<%=LiveHelpConfiguration.getSingleSignOnToken(request)%>' />

	<!-- This Parameter sets what place the agent will be monitoring -->
	<param name='PLACE_NAME' value='<%= placeName%>' />

	<!-- Parameters for store and store page language the agent is --> <!-- currently in.                                             -->
	<param name='STORE_ID' value='<%= storeId %>' />
	<param name='STORE_PAGE_LANG_ID' value='<%= langId %>' />

	<!-- This parameter sets what locale the agent will be using -->
	<param name='LOCALE' value='<%= locale %>' />

	<!-- This Parameter sets what QUEUE place the agent will be monitoring -->
	<param name='QUEUE_NAME' value='<%= queueName %>' />

	<!-- This Parameter sets what the agent will be monitoring.  --> <!--  Value:
<!--   1) W = Monitor waiting queue                          --> <!--   2) A = Monitor all shopper in store                   -->
	<!--   3) B = Monitor waiting queue and all shopper in store -->
	<param name='MONITOR_TYPE'
		value='<%= LiveHelpConfiguration.getMonitorType() %>' />

	<!-- This Parameter sets who initiates the help.             --> <!--  Value:                                                 -->
	<!--   1) S = Shopper initiates help                         --> <!--   2) B = Both shopper and CSR initiates help            -->
	<param name='INITIATION_TYPE'
		value='<%= LiveHelpConfiguration.getInitiationType() %>' />

	<!-- This Parameter sets the limit of help session a CSR can start -->
	<!--   Value must be a positive integer                            -->
	<param name='HELP_SESSION_LIMIT'
		value='<%= LiveHelpConfiguration.getHelpSessionLimit() %>' />

	<!-- This parameter sets the default WCS Guest UserId -->
	<param name='WCSGUESTID' value='<%= wcsGuestId %>' />

	<!-- Need a pointer to the agents home Sametime/SCC server  -->
	<param name='SAMETIME_SERVER'
		value='<%= LiveHelpConfiguration.getHostName() %>' />


	<!-- PARAMS TO CONFIG CUSTOMER DATA RETREIVEL -->
	<param name='READY_URL' value='<%=sReadyUrl%>' />
	<param name='INFO_FRAME_NAME' value='CCINFOFRAME' />
	<!-- END PARAMS TO CONFIG CUSTOMER DATA RETREIVEL --> <!-- Param for the Customer Service Agent Workspace Help -->
	<param name='HELP_URL'
		value='<%= LiveHelpConfiguration.getAppletCodeBaseURL() %>/docs/<%=locale%>/f1/flhmain.htm' />

	<!-- Param for the Personal Page URL, it has to be an absolute link. -->
	<param name='PERSONAL_URL'
		value='<%= LiveHelpConfiguration.getAppletCodeBaseURL() %>/html/<%=locale%>/personal.html' />

	<!-- PARAMS TO INTERACT WITH CUSTOMER DATA RETREIVEL -->
	<param name='GET_PROFILE_URL'
		value='<%= request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+ sWebAppPath + "RetrieveShopperProfileCmd?storeId="+storeId+"&userId=$(ATTR_CUSTOMER_ID)" %>' />
	<param name='GET_CART_URL'
		value='<%= request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+ sWebAppPath + "RetrieveShoppingCartCmd?storeId="+storeId+"&userId=$(ATTR_CUSTOMER_ID)" %>' />

	<!-- END PARAMS TO INTERACT WITH CUSTOMER DATA RETREIVEL --> </applet>
</body>
</html>
<%
}
catch(Exception e)
{
  ExceptionHandler.displayJspException(request, response, e);
}
%>
