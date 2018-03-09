<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2013
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->


	<%@ page import="java.util.*" %>
	<%@ page import="javax.servlet.*" %>
  	<%@ page import="com.ibm.commerce.command.*" %>
	<%@ page import="com.ibm.commerce.server.*" %>
	<%@ page import="com.ibm.commerce.beans.*" %>
	<%@ page import="com.ibm.commerce.user.beans.*" %>
	<%@ page import="com.ibm.commerce.user.objects.*" %>
	<%@ page import="com.ibm.commerce.datatype.*" %>
	<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>
	<%@ page import="com.ibm.commerce.security.commands.ECSecurityConstants" %>
	<%@ page import="com.ibm.commerce.ras.*" %>
	<%@ page import="com.ibm.commerce.tools.campaigns.CampaignConstants" %>
	<%@ page import="com.ibm.commerce.tools.common.*" %>
	<%@ page import="com.ibm.commerce.tools.util.*" %>
	<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
	<%@ page import="java.lang.StringBuffer" %>

<%@include file="../common/common.jsp" %>


<%
	CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();
	Hashtable commonResource = (Hashtable)ResourceDirectory.lookup("common.logonNLS",locale);
	String titleStr = (String)commonResource.get("logonpagetitlestatistics");
	String userNameStr = (String)commonResource.get("username");
	String passwordStr = (String)commonResource.get("password");
	String changePasswordStr = (String)commonResource.get("change_password");
        String loginButtonStr = (String)commonResource.get("login");
	String helpButtonStr = (String)commonResource.get("help");
	String explanationMessageStr = (String)commonResource.get("explanation_message");



	String strErrorCode     = null;
	String strErrorMessage  = "";

%>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>

	<title> <%= titleStr%> </title>
	<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/>

<script language="JavaScript">
<!---- hide script from old browsers
function returnToInitiatives () {
	if (top.goBack) {
		top.goBack();
	}
	else {
		parent.location.replace("<%= CampaignConstants.URL_CAMPAIGN_INITIATIVES_VIEW %>" + "<%=UIUtil.toJavaScript( request.getParameter(CampaignConstants.PARAMETER_CAMPAIGN_ID) )%>");
	}
}

function onLoad () {
	if (parent.setContentFrameLoaded) {
		parent.setContentFrameLoaded(true);
	}
}
//-->
</script>
</head>

<%

try
{

   String[] strArrayAuth = (String [])request.getAttribute(ECConstants.EC_ERROR_CODE);

   if (strArrayAuth != null){
      if( ( strArrayAuth[0].equalsIgnoreCase(ECSecurityConstants.ERR_MISSING_LOGONID) == true) ||

          ( strArrayAuth[0].equalsIgnoreCase(ECSecurityConstants.ERR_INVALID_LOGONID) == true) ||
          ( strArrayAuth[0].equalsIgnoreCase(ECSecurityConstants.ERR_MISSING_PASSWORD) == true)||
	    ( strArrayAuth[0].equalsIgnoreCase(ECSecurityConstants.ERR_INVALID_PASSWORD) == true) )
	{
		strErrorMessage = ECMessageHelper.getUserMessage(ECToolsMessage._ERR_TOOLS_STORES_INCORRECT_LOGON, null, null);
      }
      else if (strArrayAuth[0].equalsIgnoreCase(ECToolsConstants.EC_TOOLS_STORES_NOT_ADMINISTRATOR) == true){
         strErrorMessage = ECMessageHelper.getUserMessage(ECToolsMessage._ERR_TOOLS_STORES_NOT_ADMINISTRATOR, null, cmdContext.getLocale() );
	}
	else if (strArrayAuth[0].equalsIgnoreCase(ECToolsConstants.EC_TOOLS_STORES_EMPTY) == true){
         strErrorMessage = ECMessageHelper.getUserMessage(ECToolsMessage._ERR_TOOLS_STORES_EMPTY, null, cmdContext.getLocale() );
	}
	else if (strArrayAuth[0].equalsIgnoreCase(ECToolsConstants.EC_TOOLS_STORES_NO_ACCESS) == true){
         strErrorMessage = ECMessageHelper.getUserMessage(ECToolsMessage._ERR_TOOLS_STORES_NO_ACCESS, null, cmdContext.getLocale() );
	}
	else if (strArrayAuth[0].equalsIgnoreCase(ECToolsConstants.EC_TOOLS_STORES_ACCESS_CONTROL_REQUIRED) == true){
         strErrorMessage = ECMessageHelper.getUserMessage(ECToolsMessage._ERR_TOOLS_STORES_ACCESS_CONTROL_REQUIRED, null, null );
	}

   }

   TypedProperty  queryHash = ServletHelper.extractRequestParameters(request);

   String strReLoginURL = null;
   StringBuffer strPostLoginURL = new StringBuffer(1024);
   StringBuffer postLoginURL = new StringBuffer(1024);
   String initiativeId = null;
   String campaignId = null;
   String productionServer = null;
   String cmd = null;
   String ActionXMLFile = null;
   String remoteURL = null;
   String redirected = null;
   String storeId  = null;


   try{
   	strReLoginURL = queryHash.getString(ECUserConstants.EC_RELOGIN_URL);
   }catch(Exception e){;}


   try{
   	productionServer = queryHash.getString(CampaignConstants.PARAMETER_PRODUCTION_SERVER);
	if (postLoginURL.length() == 0 ) {
		remoteURL = queryHash.getString(CampaignConstants.PARAMETER_REMOTE_URL);
		productionServer = queryHash.getString(CampaignConstants.PARAMETER_PRODUCTION_SERVER);
		if (remoteURL.equals(CampaignConstants.URL_CAMPAIGN_STATISTICS_REMOTE_VIEW)){
			initiativeId = queryHash.getString(CampaignConstants.PARAMETER_INTV_ID);
   			cmd = queryHash.getString(CampaignConstants.PARAMETER_CMD);
   			ActionXMLFile = queryHash.getString(CampaignConstants.PARAMETER_ACTION_XML_FILE);
   			productionServer = queryHash.getString(CampaignConstants.PARAMETER_PRODUCTION_SERVER);
   			postLoginURL.append("CampaignInitiativeStatisticsRemoteView");
   			postLoginURL.append("?");
   			postLoginURL.append(CampaignConstants.PARAMETER_CMD);
   			postLoginURL.append("=");
   			postLoginURL.append(cmd);
   			postLoginURL.append("&");
   			postLoginURL.append(CampaignConstants.PARAMETER_ACTION_XML_FILE);
   			postLoginURL.append("=");
   			postLoginURL.append(ActionXMLFile);
   			postLoginURL.append("&");
   			postLoginURL.append(CampaignConstants.PARAMETER_INTV_ID);
   			postLoginURL.append("=");
   			postLoginURL.append(initiativeId);
   			postLoginURL.append("&");
   			postLoginURL.append(CampaignConstants.PARAMETER_PRODUCTION_SERVER);
   			postLoginURL.append("=");
   			postLoginURL.append(productionServer);
   			postLoginURL.append("&");
			postLoginURL.append(CampaignConstants.PARAMETER_REMOTE_URL);
			postLoginURL.append("=");
			postLoginURL.append(CampaignConstants.URL_CAMPAIGN_STATISTICS_REMOTE_VIEW);
			postLoginURL.append("&");
			postLoginURL.append(CampaignConstants.PARAMETER_CMD);
			postLoginURL.append("=");
   			postLoginURL.append(cmd);
   			//postLoginURL = "CampaignInitiativeStatisticsRemoteView?cmd=MIstatisticsView&ActionXMLFile=campaigns.MIstatisticsXMLmap&intv_id=" + initiativeId + "&campaignId=" + campaignId;
   		}
   		if (remoteURL.equals( com.ibm.commerce.pa.stats.PAStatsConstants.URL_PASTATS_VIEW )) {
   			productionServer 	= queryHash.getString(CampaignConstants.PARAMETER_PRODUCTION_SERVER);
			redirected 	= queryHash.getString( com.ibm.commerce.pa.stats.PAStatsConstants.STATS_REDIRECTED);
			storeId  = queryHash.getString( com.ibm.commerce.server.ECConstants.EC_STORE_ID );

   			postLoginURL.append( com.ibm.commerce.pa.stats.PAStatsConstants.URL_PASTATS_VIEW );
   			postLoginURL.append( "?" );
   			postLoginURL.append( com.ibm.commerce.pa.stats.PAStatsConstants.STATS_REDIRECTED );
   			postLoginURL.append( "=" );
   			postLoginURL.append( redirected );
   			postLoginURL.append( "&" );
   			postLoginURL.append( com.ibm.commerce.server.ECConstants.EC_STORE_ID );
   			postLoginURL.append( "=" );
   			postLoginURL.append( storeId );
   			postLoginURL.append("&");
   			postLoginURL.append(CampaignConstants.PARAMETER_PRODUCTION_SERVER);
			postLoginURL.append("=");
			postLoginURL.append(productionServer);
			postLoginURL.append("&");
			postLoginURL.append(CampaignConstants.PARAMETER_REMOTE_URL);
			postLoginURL.append("=");
			postLoginURL.append(com.ibm.commerce.pa.stats.PAStatsConstants.URL_PASTATS_VIEW);
			postLoginURL.append("&");
			postLoginURL.append( com.ibm.commerce.pa.stats.PAStatsConstants.STATS_REDIRECTED );
			postLoginURL.append( "=" );
   			postLoginURL.append( redirected );
   		}


   		if (remoteURL.equals( com.ibm.commerce.pa.stats.PAStatsConstants.URL_PESTATS_VIEW )) {
   			productionServer 	= queryHash.getString(CampaignConstants.PARAMETER_PRODUCTION_SERVER);
			redirected 	= queryHash.getString( com.ibm.commerce.pa.stats.PAStatsConstants.STATS_REDIRECTED);
			storeId  = queryHash.getString( com.ibm.commerce.server.ECConstants.EC_STORE_ID );

   			postLoginURL.append( com.ibm.commerce.pa.stats.PAStatsConstants.URL_PESTATS_VIEW );
   			postLoginURL.append( "?" );
   			postLoginURL.append( com.ibm.commerce.pa.stats.PAStatsConstants.STATS_REDIRECTED );
   			postLoginURL.append( "=" );
   			postLoginURL.append( redirected );
   			postLoginURL.append( "&" );
   			postLoginURL.append( com.ibm.commerce.server.ECConstants.EC_STORE_ID );
   			postLoginURL.append( "=" );
   			postLoginURL.append( storeId );
   			postLoginURL.append("&");
   			postLoginURL.append(CampaignConstants.PARAMETER_PRODUCTION_SERVER);
			postLoginURL.append("=");
			postLoginURL.append(productionServer);
			postLoginURL.append("&");
			postLoginURL.append(CampaignConstants.PARAMETER_REMOTE_URL);
			postLoginURL.append("=");
			postLoginURL.append(com.ibm.commerce.pa.stats.PAStatsConstants.URL_PESTATS_VIEW);
			postLoginURL.append("&");
			postLoginURL.append( com.ibm.commerce.pa.stats.PAStatsConstants.STATS_REDIRECTED );
			postLoginURL.append( "=" );
   			postLoginURL.append( redirected );
   		}
   		if (remoteURL.equals( com.ibm.commerce.pa.stats.PAStatsConstants.URL_PCSTATS_VIEW )) {
   			productionServer 	= queryHash.getString(CampaignConstants.PARAMETER_PRODUCTION_SERVER);
			redirected 	= queryHash.getString( com.ibm.commerce.pa.stats.PAStatsConstants.STATS_REDIRECTED);
			storeId  = queryHash.getString( com.ibm.commerce.server.ECConstants.EC_STORE_ID );

   			postLoginURL.append( com.ibm.commerce.pa.stats.PAStatsConstants.URL_PCSTATS_VIEW );
   			postLoginURL.append( "?" );
   			postLoginURL.append( com.ibm.commerce.pa.stats.PAStatsConstants.STATS_REDIRECTED );
   			postLoginURL.append( "=" );
   			postLoginURL.append( redirected );
   			postLoginURL.append( "&" );
   			postLoginURL.append( com.ibm.commerce.server.ECConstants.EC_STORE_ID );
   			postLoginURL.append( "=" );
   			postLoginURL.append( storeId );
   			postLoginURL.append("&");
   			postLoginURL.append(CampaignConstants.PARAMETER_PRODUCTION_SERVER);
			postLoginURL.append("=");
			postLoginURL.append(productionServer);
			postLoginURL.append("&");
			postLoginURL.append(CampaignConstants.PARAMETER_REMOTE_URL);
			postLoginURL.append("=");
			postLoginURL.append(com.ibm.commerce.pa.stats.PAStatsConstants.URL_PCSTATS_VIEW);
			postLoginURL.append("&");
			postLoginURL.append( com.ibm.commerce.pa.stats.PAStatsConstants.STATS_REDIRECTED );
			postLoginURL.append( "=" );
   			postLoginURL.append( redirected );

   		}
   		if (remoteURL.equals( com.ibm.commerce.pa.stats.PAStatsConstants.URL_SASTATS_VIEW )) {
   			productionServer 	= queryHash.getString(CampaignConstants.PARAMETER_PRODUCTION_SERVER);
			redirected 	= queryHash.getString( com.ibm.commerce.pa.stats.PAStatsConstants.STATS_REDIRECTED);
			storeId  = queryHash.getString( com.ibm.commerce.server.ECConstants.EC_STORE_ID );

   			postLoginURL.append( com.ibm.commerce.pa.stats.PAStatsConstants.URL_SASTATS_VIEW );
   			postLoginURL.append( "?" );
   			postLoginURL.append( com.ibm.commerce.pa.stats.PAStatsConstants.STATS_REDIRECTED );
   			postLoginURL.append( "=" );
   			postLoginURL.append( redirected );
   			postLoginURL.append( "&" );
   			postLoginURL.append( com.ibm.commerce.server.ECConstants.EC_STORE_ID );
   			postLoginURL.append( "=" );
   			postLoginURL.append( storeId );
			postLoginURL.append("&");
   			postLoginURL.append(CampaignConstants.PARAMETER_PRODUCTION_SERVER);
			postLoginURL.append("=");
			postLoginURL.append(productionServer);
			postLoginURL.append("&");
			postLoginURL.append(CampaignConstants.PARAMETER_REMOTE_URL);
			postLoginURL.append("=");
			postLoginURL.append(com.ibm.commerce.pa.stats.PAStatsConstants.URL_SASTATS_VIEW);
			postLoginURL.append("&");
			postLoginURL.append( com.ibm.commerce.pa.stats.PAStatsConstants.STATS_REDIRECTED );
			postLoginURL.append( "=" );
   			postLoginURL.append( redirected );
   		}
   	}
   }
   catch(Exception e)
   {
	strErrorMessage = ECMessageHelper.getUserMessage(ECToolsMessage._ERR_TOOLS_STORES_MISSING_PARAMETERS, null, null );
   }


   StringBuffer strCommon = new StringBuffer(1024);


  strPostLoginURL.append(postLoginURL.toString());
  strCommon.append(ECConstants.EC_URL + "=" + postLoginURL.toString());



  if (strReLoginURL == null)
  {
      strPostLoginURL.append("&" + ECUserConstants.EC_RELOGIN_URL + "=" + "StatisticsLogon");
      strReLoginURL = "StatisticsLogon?" + strCommon;
      //strReLoginURL = "StatisticsLogon?" + strPostLoginURL;
  }
  else
  {
     strPostLoginURL.append("&" + ECUserConstants.EC_RELOGIN_URL + "=" + strReLoginURL);
  }

   String targetURL = strPostLoginURL.toString();


   String strLoginPost = response.encodeURL("Logon");




%>


<body onload="onLoad()" class="content">




<form name="Logon" method="post" action="<%= strLoginPost %>" id="Logon">
<table width="791" cellpadding="13" cellspacing="0" border="0" id="WC_StatisticsLogon_Table_1">
	<tr>
		<td class="text" id="WC_StatisticsLogon_TableCell_1"><%="  " + explanationMessageStr%></td>
	</tr>
</table>
<table width="791" cellpadding="0" cellspacing="0" border="0" id="WC_StatisticsLogon_Table_2">
    <tr>
		<td width="13" rowspan="10" id="WC_StatisticsLogon_TableCell_2"></td>
		<td class="h1" id="WC_StatisticsLogon_TableCell_3"><%=titleStr%><%=" " + productionServer%></td>
    </tr>

    <tr>
	<td class="text" id="WC_StatisticsLogon_TableCell_4">	<%= strErrorMessage %></td>
    </tr>
    <tr>
     <td class="text" id="WC_StatisticsLogon_TableCell_5"><label for="<%= ECUserConstants.EC_UREG_LOGONID %>"><%=userNameStr%></label></td>
    </tr>
    <tr>
     <td id="WC_StatisticsLogon_TableCell_6"><input type="text" name="<%= ECUserConstants.EC_UREG_LOGONID %>" size="16" maxlength="254" id="<%= ECUserConstants.EC_UREG_LOGONID %>" /></td>
    </tr>
    <tr>
     <td class="text" id="WC_StatisticsLogon_TableCell_7"><label for="<%= ECUserConstants.EC_UREG_LOGONPASSWORD %>"><%=passwordStr%></label></td>
    </tr>
    <tr>
     <td id="WC_StatisticsLogon_TableCell_8"><input type="password" autocomplete="off" name="<%= ECUserConstants.EC_UREG_LOGONPASSWORD %>" size="16" maxlength="254" id="<%= ECUserConstants.EC_UREG_LOGONPASSWORD %>" /></td>
    </tr>
    <tr>
     <td id="WC_StatisticsLogon_TableCell_9"><input type="hidden" name="<%= ECUserConstants.EC_RELOGIN_URL %>" value="<%= strReLoginURL %>" id="WC_StatisticsLogon_FormInput_<%= ECUserConstants.EC_RELOGIN_URL %>_In_Logon_1"/> </td>
     <td id="WC_StatisticsLogon_TableCell_10"><input type="hidden" name="<%= ECUserConstants.EC_POSTLOGIN_URL %>" value="<%= targetURL %>" id="WC_StatisticsLogon_FormInput_<%= ECUserConstants.EC_POSTLOGIN_URL %>_In_Logon_1"/> </td>
    </tr>

    <tr>
                <td class="text" id="WC_StatisticsLogon_TableCell_11">
                        <table cellpadding="0" cellspacing="0" border="0" height="26" id="WC_StatisticsLogon_Table_3">
                                <tr>
                                        <td id="WC_StatisticsLogon_TableCell_12">

                                        <input type="submit" value="<%=loginButtonStr%>" id="WC_StatisticsLogon_FormInput__In_Logon_1"/>


                                        </td>
						    <td id="WC_StatisticsLogon_TableCell_13">&nbsp;</td>
						    <td id="WC_StatisticsLogon_TableCell_14">

						    </td>


                                </tr>
                        </table>
                </td>
        </tr>

</table>



  </form>





<script language="JavaScript">
 document.Logon.logonId.focus();
</script>

<%
}
catch (Exception e)
{
	out.println(e);
	e.printStackTrace();
}

%>

</body>
</html>



