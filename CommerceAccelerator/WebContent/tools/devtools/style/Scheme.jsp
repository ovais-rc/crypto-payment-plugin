<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2003
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>

<%@ page import="java.util.Locale" %>
<%@ page import="java.text.MessageFormat" %>
<%@ page import="com.ibm.commerce.ras.ECMessage" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.ras.ECMessageHelper" %>
<%@ page import="com.ibm.commerce.exception.ECException" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.exception.ECSystemException" %>
<%@ page import="com.ibm.commerce.tools.resourcebundle.ResourceBundleProperties" %>
<%@ page import="com.ibm.commerce.tools.devtools.store.databeans.StoreImageDataBean" %>

<%@include file="../../common/common.jsp" %>

	<%
	/* Scheme.jsp displays a banner used in the storefront.  Also allows the user to upload or select an
 	* alternative banner.  There are several combinations of actions the user can perform on this page.
 	* When a setting is applied, the scf.xml store configuration file is refreshed concurrently with this
 	* page.  The following is a breakdown of the state variables used:
 	*
	* To display the stores Current banner, the following variables are needed.
	* parent.get("currentBannerCustom"); 	    // Specifies if the current banner is a Custom or Selected banner.
	* parent.get("currentSelectedBannerName");  // File name banner was selected from the given list.
	* parent.get("currentCustomBannerName");    // Specifies the stores uploaded current banner name.
	*
	* To display a banner that was uploaded using the tools, the following variables are needed.
	* parent.get("uploadedBannerName");   	// File name of uploaded banner.
	* parent.get("uploadedBanner");		// Specifies if a custom banner was uploaded this session or last.
	*
	* Needed to know what the user has selected.  Either the Upload banner, or Select banner option.
	* selections["CustomBannerPanelOptions"] == "CustomBanner | SelectBanner";  
	*
	* This variable is set when a file was uploaded and is about to be applied.
	* parent.get("newBanner");  	
 	*/

	//Parameters may be encrypted. Use JSPHelper to get URL parameters instead of request.getParameter().
	JSPHelper jhelper = new JSPHelper(request);	
	
	CommandContext cmdContext  = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();
	ResourceBundleProperties wizardRB = (ResourceBundleProperties)com.ibm.commerce.tools.util.ResourceDirectory.lookup("devtools.StoreStyleRB", locale);
	ResourceBundleProperties storeLogoRB = (ResourceBundleProperties)com.ibm.commerce.tools.util.ResourceDirectory.lookup("devtools.StoreLogoRB", locale);


	/* Check if the banner was uploaded successfully
	 * success can have 3 values:  	n = file failed to upload 
	 *				y = file was successful in uploading
	 *				na = file was not uploaded
	 */				
	String uploadedSuccess = jhelper.getParameter("success");
	String uploadFileName = jhelper.getParameter("uploadFileName");

	if (uploadedSuccess == null) {
		uploadedSuccess = "na";  // Set upload not attempted              
	}else if (uploadFileName != null) {
		uploadFileName = uploadFileName.toLowerCase().trim();
	}else {
		uploadFileName = "";
	}

	// Check to is if a height and width for the banners are specified in the storefront.xml file
	String imgHeight = "75";
	String imgWidth = "600";
	%>

	<jsp:useBean id="sidb" class="com.ibm.commerce.tools.devtools.store.databeans.StoreImageDataBean" scope="request">
	<% sidb.setImageId("banner"); %>
	<% com.ibm.commerce.beans.DataBeanManager.activate(sidb, request); %>
	</jsp:useBean>	
	<%
	if (sidb !=null) {
		imgHeight = sidb.getMaxHeight();
		imgWidth = sidb.getMaxWidth();
	}


	%>	
		
<html>
<head>
	<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/>
	
	<script language="JavaScript1.2" src="/wcs/javascript/tools/common/Vector.js" type="text/javascript"></script>
	<script src="/wcs/javascript/tools/common/Util.js"></script>

<script>
	// Global Variables
	var selections = null;
	var optionGroups = null;
	var SSLPort = parent.get("SSLPort");
		if(SSLPort != 'null'){
			SSLPort = ":" + SSLPort;
		}
		else{
			SSLPort = '';
		}
	// Build store image directory paths
	var StoreImgPath = self.location.protocol + '//' + self.location.hostname + SSLPort + parent.get("StoresWebPath") + '/' + parent.get("StoreDir") + '/';
	var jspStoreImgPath = self.location.protocol + '//' + self.location.hostname + SSLPort + parent.get("StoresWebPath") + '/' + parent.get("jspStoreDir") + '/';
			
	// To avoid image browser caching, append the time and date to images.
	var today=new Date();
	var time=today.getMonth() +''+ today.getDay() +''+ today.getMinutes() +''+ today.getSeconds() + '=';	

	
	/******************************************************************************
	*
	*	Framework hooks.
	*
	******************************************************************************/
	function initializeState()
	{
		var elements = document.bannerForm.elements;

		for (var i = 0; i < elements.length; i++)
		{
			if (elements[i].type == 'radio' && elements[i].value == selections["BannerPanelOptions"]) {
				elements[i].checked = true;
			}
		}

		drawRadioSection();

		<%
		/* Known exceptions that can be thrown from a file upload:
		*
		* JSP developer errors:
		* ECMessage._ERR_UPLOAD_MISSING_REFCMD
		* ECMessage._ERR_UPLOAD_REFCMD_MISSING_CONFIG_PARAMS
		* ECMessage._ERR_CMD_INVALID_PARAM
		*
		* User errors (should be handled)
		* ECMessage._ERR_UPLOAD_FILECONTENTTYPE_NOTALLOWED
		* ECMessage._ERR_UPLOAD_FILETYPE_NOTALLOWED
		* ECMessage._ERR_UPLOAD_FILESIZE_TOOBIG
		*
		* System erros:
		* ECMessage._ERR_UPLOAD_FILESAVE_EXCEPTION
		* ECMessage._ERR_REMOTE_EXCEPTION
		*
		* Should never happen:
		* ECMessage._ERR_UPLOAD_JAR_CONTAINS_FILETYPE_NOTALLOWED
		*/
					
		if (uploadedSuccess.equals("n")) {
			String msgKey = jhelper.getParameter("key");
			String displayMsg = null;

			if (msgKey == null) {
				displayMsg = wizardRB.getProperty("banner.systemError");
			}else if (msgKey.equals(ECMessage._ERR_UPLOAD_FILECONTENTTYPE_NOTALLOWED.getKey())) {
				displayMsg = storeLogoRB.getProperty("Logo.fileNotFoundError");
			}else if (msgKey.equals(ECMessage._ERR_UPLOAD_FILETYPE_NOTALLOWED.getKey())) {
				displayMsg = wizardRB.getProperty("banner.fileExtensionError");
			}else if (msgKey.equals(ECMessage._ERR_UPLOAD_FILESIZE_TOOBIG.getKey())) {
				displayMsg = wizardRB.getProperty("banner.fileSizeError");
			}else {
				displayMsg = wizardRB.getProperty("banner.systemError");	
			}
			
			%>
			alertDialog('<%=UIUtil.toJavaScript(displayMsg) %>');
			<%			
		}
		%>
						
		parent.setContentFrameLoaded(true);
	}	

	/* swapSection() called when a user toggles between CustomBanner and SelectBanner.  One need to be displayed
	 * and the other is hidden.  We save the selection to the parent frame.
	 */
	function swapSection()
	{
		if (document.bannerForm.customBannerRadio[0].checked) {
			document.getElementById("div1").style.display = "none";
			document.getElementById("div0").style.display = "inline";
			selections["CustomBannerPanelOptions"] = "CustomBanner";
		} else {
			document.getElementById("div1").style.display = "inline";
			document.getElementById("div0").style.display = "none";
			selections["CustomBannerPanelOptions"] = "SelectBanner";
		}
	}
	
	
	/*  When we visit this page, one of the Radio boxes must be selected.  Either the SelectBanner or CustomBanner section
	 */
	function drawRadioSection()
	{

		if (selections["CustomBannerPanelOptions"] == "CustomBanner") {
			document.getElementById("div0").style.display = "inline";
			document.bannerForm.customBannerRadio[0].checked=true;
		}else {
			document.getElementById("div1").style.display = "inline";
			document.bannerForm.customBannerRadio[1].checked=true;
		}
	}

	
	/* UploadBannerButton() called when the user clicks Upload.  We pass the uploaded file extension into the URL
	 * so when the page is redisplayed, we can display the uploaded banner.
	 */
	function UploadBannerButton()
	{
		if (document.bannerForm.filename.value=="") {
			alertDialog('<%=UIUtil.toJavaScript(wizardRB.getProperty("banner.AlertMinLength"))%>');
			return;
		}

		// Lets check the upload file extension.  We want to rename any file uploaded to banner.gif or banner.jpg
		uploadFileName = document.bannerForm.filename.value;
		var pathstart = /^[a-zA-Z]:\\/;
		if ( ! uploadFileName.match( pathstart )) {
			alertDialog( '<%=UIUtil.toJavaScript(storeLogoRB.getProperty("Logo.fileNotFoundError"))%>' );
			return;
		}
		document.bannerForm.URL.value='StoreStyleWizardSchemePanelView?success=y&uploadFileName='+uploadFileName;


		top.showProgressIndicator(true);
		
		document.bannerForm.action="StoreBannerUpdate";
		document.bannerForm.submit();
	}


	/* showCurrentBanner() displays the stores current banner at the top of the page
	 */
	function showCurrentBanner()
	{
		if (parent.get("currentBannerCustom") == null)
		{  
			// If the current banner is not a custom uploaded banner
			document.write('<td width="<%=imgWidth%>" height="<%=imgHeight%>" background="' + jspStoreImgPath + parent.get("currentSelectedBannerName")+'?'+time.valueOf()+'"><br></td>');
		}else 
		{
			// If the current banner is a custom uploaded banner
			document.write('<td width="<%=imgWidth%>" height="<%=imgHeight%>" background="' + StoreImgPath + parent.get("currentCustomBannerName")+'?'+time.valueOf()+'"><br></td>');
		}
	}
	
		
	/* showUploadedBanner() displays the users uploaded banner.  
	 * Check if a banner has been uploaded this or a previous session and display it.
	 */
	function showUploadedBanner() 
	{
		var UploadBannerPanelOptions = new Object(parent.get("flexflowInfo")["selections"]);
		
		<%
		if (uploadedSuccess.equals("y")) {
			int fnLength = uploadFileName != null ? uploadFileName.length() : 0;
			String extension = "gif";

			if (fnLength > 2) {
				extension = uploadFileName.substring(fnLength-3,fnLength);
				%>
				UploadBannerPanelOptions["UploadBannerPanelOptions"] = "Banner.upload.<%=extension%>";
				<%
			}
			%>
			
			parent.put("uploadedBannerName","images/tmp.banner.<%=extension%>"); 
			parent.put("uploadedBanner", "true");
		<%
		}
		%>
		var bannerFile = parent.get("uploadedBannerName"); 
		
		if (bannerFile != null)
		{	
			var uploadedFileLocation = StoreImgPath + bannerFile + '?' +time.valueOf();

			document.write('<%=UIUtil.toJavaScript(wizardRB.get("banner.upload"))%><br />');				
			document.write('<table cellpadding="0" cellspacing="0"  border="1"><tr>');
			document.write('<td width="<%=imgWidth%>" height="<%=imgHeight%>" background="'+uploadedFileLocation+'" name="upLoadedBanner" border="0" >');
			document.write('<br></td></tr></table>');
		}
	}


	/* showBanners() writes out all the supported banners for a particular style + color combination
	 */
	function showBanners()
	{
		selections = parent.get("flexflowInfo")["selections"];
		optionGroups = parent.get("optionGroups");

		var enabledOptions = optionGroups.ColorPanelOptions.options[selections["ColorPanelOptions"]].enablesOptions;
		var templateLabel = '<%=UIUtil.toJavaScript(wizardRB.get("banner.label"))%>';
		var label = '';
		for (var i = 0; i < enabledOptions.length; i++)
		{
			option = optionGroups["BannerPanelOptions"].options[enabledOptions[i]];
			
			document.write('<tr>');
			document.write('<td width="50"></td>');	
			document.write('<td valign="top"><br>');
			document.write('<input type="radio" value="' + option.id + '" id="banner' + option.id + '"name="optionRadio" onClick="SaveToTopFrame(' + i + ');">');
			document.write('</td>');
			document.write('<td><br><table cellpadding="0" cellspacing="0" border="1"><tr><td>');
			label = templateLabel.replace('{0}', i+1);
			document.write('<label for="banner' + option.id + '"><img src="' + jspStoreImgPath + option.src + '" height="<%=imgHeight%>" onClick="SaveToTopFrame(' + i + ');" alt="' + label + '"></label>');
			document.write('<br></td></tr></table></td>');
			document.write('</tr>');
		}
	}
	
		
	/* When a banner is selected, we save this selection to the top frame. 
	 */
	function SaveToTopFrame(bannerNumber)
	{	
		document.bannerForm.optionRadio[bannerNumber].checked = true;
		selections["BannerPanelOptions"] = document.bannerForm.optionRadio[bannerNumber].value;

	}
	
	
	/* submitApplyHandler() is Called when the Apply button is pressed.
	 */
	function submitApplyHandler(finishMessage)
	{	
		location.href="StoreStyleWizardSchemePanelView";	// Refresh the screen
	}	
</script>
</head>

<body class="content" onload="initializeState()">
<H1><%=wizardRB.get("banner.title")%></H1>
<%=wizardRB.get("banner.blurb")%>

<br>
<br>

<form enctype="multipart/form-data" method="post" name="bannerForm" action="#">
<input type="hidden" name="errorURL" value="StoreStyleWizardSchemePanelView?success=n" />
<input type="hidden" name="URL" value="" />
<input type="hidden" name="filepath" value="images" />
<input type="hidden" name="refcmd" value="StoreFrontAssetsUploadCmd" />
<input type="hidden" name="rename" value="banner.gif" />

<table>
<tr>
	<td width="75"></td>
	<td valign="top">
		<%=wizardRB.get("banner.current")%><br>
		<table cellpadding="0" cellspacing="0"  border="1" width="<%=imgWidth%>" height="<%=imgHeight%>">
		<tr>
			<script>
				showCurrentBanner();
			</script>
		</tr>
		</table>
	</td>
</tr>
</table>

<br>
<!--  Begin upload banner section -->
<input type="radio" value="no" name="customBannerRadio" id="ownBannerRadio" onclick="swapSection()" checked><label for="ownBannerRadio"><%=wizardRB.get("banner.own")%></label>
<div id="div0" style="display: none;">
	<br>
	<table>
	<tr>
		<td width="75"></td>
		<td valign="top">
			<br>
			<label for="filename"><%=wizardRB.getProperty("banner.instructions")%></label><br>
			<%
			if (uploadedSuccess.equals("y")) {
			%>
				<br><b><%=wizardRB.getProperty("banner.success")%></b>
				<br>
				<%
			}

			Object[] arguments = {imgWidth,imgHeight};
			%>	
			<br><%=MessageFormat.format(ECMessageHelper.doubleTheApostrophy(wizardRB.getProperty("banner.note")),arguments)%>
			<br>
			<input type="file" style="width: 300px;" name="filename" value="" id="filename" />
			<br />
			<input type="button" class="button" name="UploadButton" id='nbp' value="<%=wizardRB.getProperty("banner.uploadButton")%>" onClick="UploadBannerButton();return false;" />
			<br>
		</td>
	</tr>
	<tr>
		<td width="75"></td>
		<td valign="top">
			<script>
				showUploadedBanner();
			</script>	
		<br><br>
		</td>
	</tr>
	</table>
</div>
<br>
<!--  End upload banner section -->

<!--  Begin select banner section -->
<input type="radio" value="yes" name="customBannerRadio" id="selectBannerRadio" onclick="swapSection()"><label for="selectBannerRadio"><%=wizardRB.get("banner.banner")%></label>
<div id="div1" style="display: none;">
	<table width="<%=imgWidth%>" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<br>
			<script>
				showBanners();
			</script>
		</td>
	</tr>
	</table>
</div>
<!--  End select banner section -->



</form>
</body>
