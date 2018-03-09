 <!-- 
  //*----
  //* @deprecated The Product Advisor feature has been deprecated. For more information, see <a href="../../../../../../com.ibm.commerce.productadvisor.doc/concepts/cpaintro.htm">Product Advisor</a>.
  //*----
-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>


    <%@ page language="java"
    	import="javax.servlet.*, 
    	com.ibm.commerce.pa.stats.*,
    	com.ibm.commerce.tools.campaigns.CampaignConstants,
	com.ibm.commerce.tools.campaigns.CampaignUtil,
	com.ibm.commerce.utils.TimestampHelper,
        com.ibm.commerce.tools.util.*,
	com.ibm.commerce.tools.xml.XMLUtil,
	com.ibm.commerce.server.*,
    	com.ibm.commerce.datatype.*,
    	com.ibm.commerce.pa.stats.*,
    	com.ibm.commerce.command.*,
      	com.ibm.commerce.beans.DataBeanManager,
    	java.util.Hashtable,
	org.w3c.dom.Node" %>
   <%@page import="com.ibm.commerce.tools.util.UIUtil" %> 
    
    <%@include file="../common/common.jsp" %> 

<%

  // obtain the common campaign resource bundle for NLS properties
  CommandContext campaignCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
  if (campaignCommandContext == null) {
	  System.out.println("commandContext is null");
	  return;
  }
  java.util.Locale locale = campaignCommandContext.getLocale ();
  if ( locale == null ) {
	locale = java.util.Locale.getDefault ();
  }
  Integer storeId = campaignCommandContext.getStoreId();
  
  Hashtable campaignsRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("campaigns.campaignsRB",
                                                                                   campaignCommandContext.getLocale());
  if (campaignsRB == null) {
  
    System.out.println("!!!! Campaigns resouces bundle is null");
  }
  
  TypedProperty  queryHash = ServletHelper.extractRequestParameters(request);

  
  String redirected	= request.getParameter ( PAStatsConstants.STATS_REDIRECTED );
  if (( redirected == null ) || ( redirected.length () == 0 )) {
  	redirected = "false" ;
  	
  }
  
  ResourceBundle nls = ResourceBundle.getBundle("com.ibm.commerce.tools.pa.properties.paStats", locale);
   

 ConfigProperties 	configProperties 	= ConfigProperties.singleton();
 String 		hostname 		= configProperties.getValue("WebServer/HostName");
 Node 			node  			= ServerConfiguration.singleton().getConfigCache("CommerceAccelerator"); 
 //Node 		node  			= ServerConfiguration.singleton().getConfigCache("MerchantCenter");
 Hashtable 		configNode 		= (Hashtable)XMLUtil.processNode(node);
 String 		statisticsSource	= (String) ((Hashtable)configNode.get("BusinessIntelligence")).get("StatisticsSource");
 
 boolean bRedirected = redirected.equalsIgnoreCase ( "true" );
 boolean bRemoteStatistics = ! hostname.equalsIgnoreCase ( statisticsSource );

%>

<html>
<head>

<%= fHeader%>

   <link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"> 

   <TITLE><%= nls.getString(PAStatsConstants.PA_BROWSER_TITLE)%></TITLE>
   
<SCRIPT LANGUAGE="JavaScript">
<!-- hide script from old browsers

function getHelp () {

	return "MC.productAdvisor.pastatistics.Help";
}   

<%
	if (( ! bRedirected ) && ( bRemoteStatistics )) {
	
%>

function redirect() {

  var css = top.getCSSFile();
  document.writeln("<link rel=stylesheet href='" + css + "' type='text/css'>");

  var redirected = <%=(redirected == null ? null : UIUtil.toJavaScript(redirected))%>;
  var hostname = "<%= hostname %>";
  var statisticsSource = "<%= statisticsSource %>";
  var statsURL = "<%= PAStatsConstants.URL_PASTATS_VIEW %>";
  var storeId = "<%= storeId %>";
	  
  //top.setContentRemoteAccess(true);
	      
  url = "https://" + statisticsSource + "<%= PAStatsConstants.URL_PASTATS_CHECK_USER %>"+ "&" 
	        +"<%= CampaignConstants.PARAMETER_PRODUCTION_SERVER %>" + "=" + statisticsSource + "&"
	        + "<%= CampaignConstants.PARAMETER_REMOTE_URL %>" + "=" + statsURL + "&" 
	        + "<%= PAStatsConstants.STATS_REDIRECTED %>=true" + "&" 
	        + "<%= com.ibm.commerce.server.ECConstants.EC_STORE_ID %>" + "=" + storeId;
	        	         
  if (top.setContent)      {
  
     top.setContent("<%= UIUtil.toJavaScript((String) nls.getString(PAStatsConstants.PA_BROWSER_TITLE) + " @ " + statisticsSource )%>", url, true);
  }    else     {
  
     parent.location.replace(url);
  }
}
--> 
</script>

</head>

<BODY ONLOAD="redirect()" class="content_list" >
<%
	} else { // if ( ! bRedirected 
	
%>
--> 
</script>
</head>

<BODY>

<%
	} // if ( ! bRedirected 
%>


<jsp:useBean id="paStatsListBean" beanName="com.ibm.commerce.pa.stats.ProductAdvisorStatisticsListDataBean" type="com.ibm.commerce.pa.stats.ProductAdvisorStatisticsListDataBean" >
   <jsp:setProperty name="paStatsListBean" property="*"/>
   <% com.ibm.commerce.beans.DataBeanManager.activate( paStatsListBean, request); %>
</jsp:useBean>

<br>
<br>
<br>



<%

if ( ( bRedirected ) ||
	((! bRedirected ) && ( ! bRemoteStatistics )) ) {

	try {
	
	
	  com.ibm.commerce.pa.stats.ProductAdvisorStatisticsBean paStatsBean;
	  com.ibm.commerce.pa.stats.ProductAdvisorStatisticsBean[] paArray;
	
	
	  paArray = ( com.ibm.commerce.pa.stats.ProductAdvisorStatisticsBean[]) 
			paStatsListBean.getStatsDataBeanList();
	
	
			
	  
			
			
	  if ( paArray.length > 0 ) { 
	  
	
	%>
	<TABLE CLASS=dtable align=center width='95%' cellpadding=0 cellspacing=0 border=0 width=100% bgcolor=#6D6D7C style="table-layout:fixed; border-bottom: 1px solid #6D6D7C; border-top: 0px solid #6D6D7C;border-right: 1px solid #6D6D7C;border-left: 1px solid #6D6D7C;">
	
	
	  <CAPTION><h1>  <%= CampaignUtil.substitute((String) nls.getString ("paStatsTableCaption"), paStatsListBean.getStoreName ()) %></h1></CAPTION>
	  <TR class="dtableHeading">
		    <TD class="COLHEADNORMAL" align='left' nowrap><%= nls.getString(PAStatsConstants.MSG_CATEGORY_ID_HEADING)%></TD>
	    	<TD class="COLHEADNORMAL" align='left' nowrap><%= nls.getString(PAStatsConstants.MSG_CATEGORY_NAME_HEADING)%></TD>
			<TD class="COLHEADNORMAL" align='left' nowrap><%= nls.getString(PAStatsConstants.MSG_METAPHOR_NAME_HEADING)%></TD>
	    	<TD class="COLHEADNORMAL" align='left' nowrap><%= nls.getString( PAStatsConstants.MSG_COUNT_HEADING ) %></TD>	    	
	  </TR>
	
	<%
	  String classId="list_row1";
	  int countTotal=0;
	  
	  
	  
	  for (int j=0; j < paArray.length; j++) {
	  
	     paStatsBean = 
	           (com.ibm.commerce.pa.stats.ProductAdvisorStatisticsBean) paArray [j];
	 
	     countTotal += paStatsBean.getPaCountAsInteger().intValue();
	     
	%>
	
	  <TR CLASS=<%=classId%>>
	    <TD class="list_info1" ALIGN='left'> <%= paStatsBean.getCatGroupId ()%> 	</TD>
	    <TD class="list_info1" ALIGN='left'> <%= paStatsBean.getCatGroupName ()%> 	</TD>
	    <TD class="list_info1" ALIGN='left'> <%= paStatsBean.getMetaphorName ()%> 	</TD>
	    <TD class="list_info1" ALIGN='left'> <%= paStatsBean.getPaCount ()%> 	</TD>
	  </TR>
	
	<%
	
	
		if ( classId.equals("list_row1") ) {
			classId="list_row2";
		} else  {
			classId="list_row1";
		}
					
	  } //end for
	
	 
	  
	%>
	
	  <TR class="list_row2">
	    <TD class="list_info1" ALIGN='right' COLSPAN='3'><%= nls.getString(PAStatsConstants.MSG_TOTAL_HEADING)%></TD>
	    <TD class="list_info1" ALIGN='left'><%= countTotal %></TD>
	  </TR>
	 </TABLE>
	
	<%
	     } else {
	     %>
	  
	  <h1> <%= nls.getString(PAStatsConstants.MSG_NO_DATA)%> </h1>
	  
	     
	     
	     <%
	     }
	  } catch (Exception e)  {
	        System.out.println (" PAstatistics: Exception :" + e.getMessage() );
	        e.printStackTrace();
	  }
} else {
%>

<h1> <%= nls.getString(PAStatsConstants.MSG_REMOTE_STATISTICS) + "&nbsp;" +  statisticsSource%> </h1>

<%
} // if ( ( ! bRedirected ) && ! hostname.equalsIgnoreCase ( statisticsSource )  ) ...
%>

<br><br>


 
 
</BODY>
</HTML>

