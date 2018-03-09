<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------->

<%@include file="../../common/common.jsp" %>

<%@page import="java.util.*" %>
<%@page import="java.io.File" %>
<%@page import="javax.servlet.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.base.objects.*" %>
<%@page import="com.ibm.commerce.datatype.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.*" %>
<%@page import="com.ibm.commerce.tools.devtools.*" %>
<%@page import="com.ibm.commerce.tools.devtools.publish.tasks.*" %>
<%@page import="com.ibm.commerce.tools.devtools.publish.xml.*" %>
<%@page import="com.ibm.commerce.tools.devtools.publish.datadeploy.*" %>
<%@page import="com.ibm.commerce.common.beans.StoreDataBean" %>
<%@page import="com.ibm.commerce.tools.devtools.publish.databeans.PublishRecord" %>
<%@page import="com.ibm.commerce.tools.devtools.publish.StorePublishConfig" %>
<%@page import="java.util.HashMap" %>
<%@page import="com.ibm.commerce.tools.devtools.publish.util.StorePublishUtil" %>
<%@page import="com.ibm.commerce.tools.devtools.publish.StorePublishConstants" %>
<%@page import="java.util.regex.Pattern" %>


<%
	CommandContext commandContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = commandContext.getLocale();
	ResourceBundleProperties resource = (ResourceBundleProperties)ResourceDirectory.lookup("publish.storePublishNLS", locale);
	ResourceBundleProperties legacyResource = (ResourceBundleProperties)ResourceDirectory.lookup("publish.userNLS2", locale);
	String instanceWorkspace = WcsApp.configProperties.getValue("Instance/WorkspacePath");	

	String storesWebAppPath = "";
	WebModuleConfig webApp = (WebModuleConfig) com.ibm.commerce.server.WebApp.retrieveObject("Stores");
	if (webApp != null) {
		storesWebAppPath = webApp.getContextPath();
	}


%>

<HTML>
<HEAD>
	<LINK REL=stylesheet HREF="<%= UIUtil.getCSSFile(locale) %>" TYPE="text/css">
	<SCRIPT LANGUAGE="JavaScript" SRC="/wcadmin/javascript/tools/common/Util.js"></SCRIPT>

<jsp:useBean class="com.ibm.commerce.tools.devtools.publish.databeans.StorePublishJobBean" id="statusBean" scope="request">
<% String[] jobId = (String[])request.getAttribute("jobId");
if ((jobId != null)&&(jobId[0] != null)) statusBean.setJobReferenceNumber(jobId[0]);
com.ibm.commerce.beans.DataBeanManager.activate(statusBean, request); %></jsp:useBean>
<%
	// get the publish record
	Vector publishRecords = statusBean.getPublishRecords();
	PublishRecord pubRec;
	if (publishRecords == null) {
		pubRec = new PublishRecord();  // blank
	} else {
		pubRec = (PublishRecord) publishRecords.elementAt(0);	// should only have 1
	}
	
	
	// if the status is complete then try to get the information to launch the store
	String indexJspPath = "";
	TargetModel targetModel = null;
	String storeType = null;
	String[] storeTypeExclusionList = null;
	boolean launchStore = true;
	if (pubRec.getStatus().equals("C")){
		String deployXMLFilename = pubRec.getDeployXMLFilename();
		
		// parse the XML to get the model
		try {
			DataDeployHandler deployHandler = new DataDeployHandler();
			DataDeployControlModel deployModel = new DataDeployControlModel();
			deployXMLFilename =DevToolsConfiguration.getAbsolutePath(DevToolsConfiguration.STORES_WAR,deployXMLFilename);			
			File deployXmlFile = new File(deployXMLFilename);
			//System.out.println("Deploy XML File exists ?:"+deployXmlFile.exists());
			
			if (!deployXmlFile.exists()){
				// migrated instance? -- try to take the segment relative to StoresWeb path
				String storesWebPath = DevToolsConfiguration.getConfigurationVariable("StoresWebPath");
				
				String resolvedPath = null;
				if ((storesWebPath != null) && (storesWebPath.length() > 0)){
					int pos = deployXMLFilename.lastIndexOf(storesWebPath);
					if (pos > 0){
						String affix = deployXMLFilename.substring(pos+1 + storesWebPath.length());
						//String storesDocRoot =   DevToolsConfiguration.getConfigurationVariable("StoresDocRoot");
						//resolvedPath = storesDocRoot + File.separator + storesWebPath + File.separator + affix;
						resolvedPath = DevToolsConfiguration.getAbsolutePath(DevToolsConfiguration.STORES_WAR,affix);
						deployXmlFile = new File(resolvedPath);
					}
				}

			}
			
			if (deployXmlFile.exists()) {
				// the default base dir is the location of the control XML file
				deployModel.setBaseDir(deployXmlFile.getParent());
				
				deployHandler.setModel(deployModel);
				Reader deployXmlReader = new Reader();
				deployXmlReader.parse(deployXmlFile, deployHandler);
					
			        targetModel = (TargetModel) deployModel.getTargets().get("launch-store");
				if (targetModel != null) {
					TaskModel tm = (TaskModel) targetModel.getTaskList().get(0);
					
					TypedProperty prop = tm.getParameters();
					StoreIdBaseDeployTaskCmd cmd = new StoreIdBaseDeployTaskCmdImpl();
					String theStoreId = null;
					String orgDN = prop.getString("organizationDN");
					HashMap dnMappings = StorePublishUtil.getMappingsForNodeName(StorePublishConstants.INSTANCE_DNMAPPINGS);
					if(dnMappings != null){
						java.util.Iterator dnMappingsKeysIterator = dnMappings.keySet().iterator();
						while(dnMappingsKeysIterator.hasNext()){
							String dnMappingsKey = (String)dnMappingsKeysIterator.next();
							String dnMappingsValue = (String)dnMappings.get(dnMappingsKey);
							if(orgDN != null){
								if(Pattern.compile(".*"+dnMappingsKey+".*", Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE).matcher(orgDN).matches()){
									orgDN = Pattern.compile(dnMappingsKey,Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE).matcher(orgDN).replaceAll(dnMappingsValue);
									orgDN = Pattern.compile(dnMappingsKey,Pattern.CASE_INSENSITIVE).matcher(orgDN).replaceAll(dnMappingsValue);					
								}
							}
						}
					}
					cmd.setStoreIdentifier(prop.getString("storeIdentifier"));
					cmd.setMemberIdentifier(orgDN);
					String exclusionList = null;
					exclusionList = (String)prop.getUrlParam("storeTypesToExclude");
					if(exclusionList != null){
						java.util.StringTokenizer t = new java.util.StringTokenizer(exclusionList,",");
						int num_tokens = t.countTokens();
						storeTypeExclusionList = new String[num_tokens];
						for (int i=0; i<num_tokens; i++)
								storeTypeExclusionList[i] = t.nextToken();
					}
					try {
						cmd.performExecute();
						theStoreId = cmd.getStoreEntityId();
					}
					catch(Exception onfe){
						onfe.printStackTrace();
					}
					StoreDataBean sdb = new StoreDataBean();
					sdb.setStoreId(theStoreId);
					sdb.setCommandContext(commandContext);
					sdb.populate();
					storeType = sdb.getStoreType();
					if(storeTypeExclusionList != null){
						for(int i=0; i<storeTypeExclusionList.length; i++){
							if(storeType.equals(storeTypeExclusionList[i])){
								launchStore = false;
							}
						}
					}
					indexJspPath = sdb.getJspPath("index.jsp");
					//System.out.println("Index JSP Path: " + indexJspPath);
			}
		}

		// response

		} catch (Exception e) {
			System.err.println("Failed to determine the URL to launch the store");
			System.err.println(e);
			e.printStackTrace();
			
		}
		
	}
	
	
%>
<jsp:useBean class="com.ibm.commerce.tools.devtools.databeans.ErrorDocBean" id="errBean" scope="request">
<% errBean.setInstanceRefNum(pubRec.getInstanceRefNum());
com.ibm.commerce.beans.DataBeanManager.activate(errBean, request); %></jsp:useBean>
	
	
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>
<SCRIPT>
/******************************************************************************
*
*	Initialization
*
******************************************************************************/
//document.writeln("<XMP>" + parent.modelToXML() + "</XMP>");
<%= UIUtil.toJS("statusBean",pubRec) %>
<%= UIUtil.toJS("errBean",errBean) %>

function refresh()
{
       parent.refreshButtonAction();
}

function initializeState()
{
	var status = statusBean.status;
	
	if (status == null || status == "")
		status = "<%= UIUtil.toJavaScript((String) resource.getJSProperty("statusUnknown")) %>";
	else if (status == "I") {
		status = "<%= UIUtil.toJavaScript((String) resource.getJSProperty("statusIdle")) %>";
        	setTimeout("refresh()",20000);
	}else if (status == "R") {
		status = "<%= UIUtil.toJavaScript((String) resource.getJSProperty("statusRun")) %>";
        	setTimeout("refresh()",20000);		
	}else if (status == "C"){
		status = "<%= UIUtil.toJavaScript((String) resource.getJSProperty("statusComplete")) %>";
	}else if (status == "IF" || status == "RF" || status == "CF"){
		status = "<%= UIUtil.toJavaScript((String) resource.getJSProperty("statusFail")) %>";
	}
	
	document.all.statusDescription.innerText = status;
	parent.setContentFrameLoaded(true);
	
}


function savePanelData()
{
}

function validWebApp()
{
	str = document.Data.webapp.value;

	document.Data.webapp.value = trim(str);

	if (document.Data.webapp.value.length > 255)
		alertDialog("<%= UIUtil.toJavaScript((String) resource.getJSProperty("alertWebAppDirectoryLength"))%>");
	else if (document.Data.webapp.value == "")
		alertDialog("<%= UIUtil.toJavaScript((String) resource.getJSProperty("alertWebAppDirectoryEmpty"))%>");
	else if ((pos = validateDirectory(str)) > -1)
		alertDialog("<%= UIUtil.toJavaScript((String) resource.getJSProperty("alertWebAppDirectoryInvalidChar"))%>");
	else
		return true;

	return false;
}

/******************************************************************************
*
*	Launch Store
*
******************************************************************************/

function launchStore()
{
	var indexJsp = "<%= indexJspPath %>";
	if (statusBean.status != "C")
	{
		alertDialog("<%= UIUtil.toJavaScript((String) legacyResource.getJSProperty("alertStoreNotPublished")) %>");
		return;
	}
	
	if (indexJsp == null || indexJsp == "")
	{
		alertDialog("<%= UIUtil.toJavaScript((String) legacyResource.getJSProperty("alertStoreURIUnavailable")) %>");
		return;
	}
	
	modalDialogArgs = new Array();
	modalDialogArgs.inputTextTitle = "<%= UIUtil.toJavaScript((String) legacyResource.getJSProperty("DeploySummaryWebAppPrompt")) %>";
	//modalDialogArgs.inputTextTitle = "Stores Web Application context";
//	modalDialogArgs.inputTextValue = "<%= (String) UIUtil.toJavaScript(DevToolsConfiguration.getConfigURLVariable(DevToolsConfiguration.WEB_APP_PATH)) %>";
	modalDialogArgs.inputTextValue = "<%= (String) UIUtil.toJavaScript(storesWebAppPath) %>";

	
	var webapp = promptDialog(modalDialogArgs.inputTextTitle, modalDialogArgs.inputTextValue);

	if (webapp == null)
		return;
	
	loc = "http://";
	loc += top.location.hostname;

	if (webapp.charAt(0) != "/")
		loc += "/";
	
	loc += webapp;
	
	var endsWith = webapp.slice(-1);
	
	if (endsWith != "/")
		loc += "/";

	loc += "servlet";
	loc += encodeURI(indexJsp);
	
	window.open(loc,'');
	
}



function showPublishSummary() {
	if(document.all["publishSummary"].style.display == "none"){
		document.all["publishSummary"].style.display = "block";
	}else{
		document.all["publishSummary"].style.display = "none";
	}
}
</SCRIPT>

<STYLE>
	.launchButton { position:relative; top:25px; left:0px} //width:100px; 
</STYLE>

<BODY ONLOAD="initializeState();" class=content>


<BR>
<H1><%= (String)resource.getProperty("StorePublishStatusDetailsTitle") %></H1>

<%= (String)resource.getProperty("archive.storeArchive") %>:&nbsp;<I><SCRIPT> document.writeln(statusBean.SARFilename);</SCRIPT></I><BR><BR>
<%= (String)resource.getProperty("details.jobNum") %>:&nbsp;<I><SCRIPT> document.writeln(statusBean.job);</SCRIPT></I><BR><BR>
<%= (String)resource.getProperty("details.start") %>:&nbsp;<I><SCRIPT> document.writeln(statusBean.startTime);</SCRIPT></I><BR><BR>
<%= (String)resource.getProperty("details.end") %>:&nbsp;<I><SCRIPT> document.writeln(statusBean.endTime);</SCRIPT></I><BR><BR>
<%= (String)resource.getProperty("details.currentTask") %>:&nbsp;<I><SCRIPT> document.writeln(statusBean.currentTaskString);</SCRIPT></I><BR><BR>

<%= (String)resource.getProperty("details.status") %>:&nbsp;<I id="statusDescription"></I><BR><BR>

<SCRIPT>
	var status = statusBean.status;
	 
	if (status == "C") {
		<% if (targetModel != null && launchStore) { %>
			document.writeln('<FORM name="Data" action="" method="POST">');
			document.writeln('<INPUT');
			document.writeln('TYPE="BUTTON"');
			document.writeln('VALUE="<%= (String)resource.getJSProperty("DeploySummaryLaunch") %>"');
			document.writeln('ONCLICK="launchStore();"');
			document.writeln('ID="dialog"');
			document.writeln('CLASS="button"');
			document.writeln('>');
			document.writeln('<BR>');
			document.writeln('</FORM>');

		<% } else { %>
			document.writeln('<%= UIUtil.toJavaScript((String)resource.getProperty("details.noURLSetup")) %>');
			document.writeln('<BR>');
		<% 
		}
		if (instanceWorkspace == null || instanceWorkspace.equals("")) {
		%>
			document.writeln('<BR>');
			document.writeln('<%= UIUtil.toJavaScript((String)resource.getProperty("details.nextstep")) %>');
			document.writeln('<BR>');
			document.writeln("<%= UIUtil.toJavaScript((String)resource.getProperty("details.publishWarning")) %>");
			document.writeln('<BR>');

		<%
		}
		%>
	//This will display the store publish executed tasks details and error details.
	}
	if (status == "CF"){
	  	if (errBean.errorMsg != "") {
				document.writeln('<p>');
				document.writeln('<label for="detailsText"><H5>'+'<%= UIUtil.toJavaScript((String)resource.getProperty("DeploySummaryReason")) %>'+'</H5></label>');
				//document.writeln('<BR><BR>');
		}
	
		if (errBean.errorMsg != "" ) {
				//document.writeln('<%= (String)resource.getProperty("DeploySummaryDetails") %>');
				document.writeln('<TEXTAREA id="detailsText" READONLY="true" WRAP="soft" ROWS=12 COLS=120>');
				document.writeln(errBean.errorDetails);
				document.writeln('</TEXTAREA>');
		}
	//If the status is not failed this text area will display the store publish job tasks execution details.
	}else {
		document.writeln('<BR>');
		document.writeln('<a onClick="showPublishSummary()"><u><%=UIUtil.toJavaScript((String)resource.getProperty("publish.summary"))%></u></a>');
		document.writeln('<Div id="publishSummary" style="display:none;">');
		document.writeln('<TEXTAREA id="sucessDetailsText" READONLY="true" WRAP="soft" ROWS=10 COLS=130>');
		document.writeln(errBean.errorDetails);
		document.writeln('</TEXTAREA>');
		document.writeln('<BR><BR>');
		document.writeln('</div>');
	}
	 
</script>
</BODY>
</HTML>
