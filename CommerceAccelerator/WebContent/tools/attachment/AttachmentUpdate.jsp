<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2005, 2016
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->

<%
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//------------------------------------------------------------------------------
// 040515           BLI       Creation Date
// 040105   97731   BLI       Added port in the url to preview attachment file
////////////////////////////////////////////////////////////////////////////////
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 TRANSITIONAL//EN">
<%@ page language="java" %>

<%@ page import="com.ibm.commerce.command.CommandContext"%>
<%@ page import="com.ibm.commerce.tools.util.*"%>
<%@ page import="com.ibm.commerce.attachment.objects.*"%>
<%@ page import="com.ibm.commerce.attachment.content.resources.*"%>
<%@ page import="com.ibm.commerce.server.JSPHelper"%>
<%@ page import="com.ibm.commerce.beans.DataBeanManager"%>
<%@ page import="com.ibm.commerce.common.beans.LanguageDescriptionDataBean" %>
<%@ page import="com.ibm.commerce.user.helpers.UserJDBCHelperBean" %>
<%@ page import="com.ibm.commerce.attachment.util.AttachmentRelationUsageHelper" %>
<%@ page import="com.ibm.commerce.context.globalization.GlobalizationContext" %>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@ page import="com.ibm.commerce.context.base.BaseContext"%>
<%@ page import="com.ibm.commerce.attachment.common.ECAttachmentConstants" %>
<%@ page import="com.ibm.commerce.server.WcsApp" %>
<%@ page import="com.ibm.commerce.content.preview.command.CMWSPreviewConstants" %>

<%@include file="../common/common.jsp" %>
<%@include file="../attachment/Worksheet.jspf" %>

<%
	// Command Context variables
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbAttachment = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("attachment.AttachmentNLS", ((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale());
	StoreAccessBean abStore = cmdContext.getStore();
	Integer [] iLanguages  = abStore.getSupportedLanguageIds();
	Integer storeDefLangId = abStore.getLanguageIdInEntityType();
	Integer storeId = ((BaseContext) cmdContext.getContext(BaseContext.CONTEXT_NAME)).getStoreId();

	boolean SINGLELANGSTORE = false;
	if (iLanguages.length == 1) SINGLELANGSTORE = true;

	// Global variables
	String strSeparationToken = UIUtil.toJavaScript((String) rbAttachment.get("Attachment_Language_Token"));

	// Get the request parameters
	JSPHelper jspHelper = new JSPHelper(request);
	String atchRelId    = jspHelper.getParameter("atchRelId");
	String atchTargetId = jspHelper.getParameter("atchTargetId");	
	String objectType   = jspHelper.getParameter("objectType");
	String objectId     = jspHelper.getParameter("objectId");
	String sentBack     = jspHelper.getParameter("sentBack");
	String strTool      = jspHelper.getParameter("tool");   // Valid values are: usage, description, asset or all
	String port         = WcsApp.configProperties.getWebModule(CMWSPreviewConstants.PREVIEW_WEBAPP_NAME).getSSLPort().toString();
	String url          = request.getRequestURL().toString();

	String atchRelUsageId = "";
	String atchRelSeq = "";

	if ((atchTargetId != null) && (atchTargetId.length() == 0)) {
			atchTargetId = null;
	}
	
	// Usage list
	Vector vUsageList = AttachmentRelationUsageHelper.getAllAttachmentRelationUsages(cmdContext.getLanguageId());

	// Create the Attachment Relation Bean
	AttachmentRelationAccessBean abAttachmentRelation = null;
	
	if (!strTool.equals("asset")) 
	{
		abAttachmentRelation = new AttachmentRelationAccessBean();
		abAttachmentRelation.setInitKey_attachmentRelationId(new Long(atchRelId));
		
		atchRelUsageId = abAttachmentRelation.getAttachmentRelationUsageId().toString();
		atchRelSeq = abAttachmentRelation.getSequenceInEntityType().toString();
	}

%>

<html>
<head>

	<title><%=UIUtil.toHTML((String)rbAttachment.get("AttachmentChange_Title"))%></title>
	<link rel=stylesheet href="<%=UIUtil.getCSSFile(((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale())%>" type="text/css">
	
	<script src="/wcs/javascript/tools/common/URLParser.js"></script>
	<script src="/wcs/javascript/tools/attachment/AttachmentCommonFunctions.js"></script>
	<script src="/wcs/javascript/tools/attachment/Constants.js"></script>
	<script src="/wcs/javascript/tools/common/Util.js"></script>
	<script src="/wcs/javascript/tools/catalog/button.js"></script>

	<script>

	var atchTgtId     = "<%=atchTargetId%>";
	var atchObjectId  = "<%=objectId%>";
	var atchUsageId   = "<%=atchRelUsageId%>";
	var atchRelId     = "<%=atchRelId%>";
	var atchSeq       = "<%=atchRelSeq%>";
	var pageUpdated   = false;
	
	setPort("<%=port%>");
	urlParser = new URLParser("<%=url%>");

	var saveChanges        = false;
	var selectedLangFileId = "";
	var selectedAssets     = new Array();

	var selectedLang   = "";
	var numOfLanguages = <%=iLanguages.length%>;
	var strAllLang     = "<%=UIUtil.toJavaScript((String) rbAttachment.get("Attachment_AllLanguages"))%>";
	var strSpecifyLang = "<%=UIUtil.toJavaScript((String) rbAttachment.get("Attachment_SpecifyLanguages"))%>";
	var langToken      = "<%=strSeparationToken%>";
	var existingLanguages = new Array();


	var hLanguages       = new Object();
	var hLanguagesCount  = new Object();
	var previewMimeTypes = new Array();
	var aAssets          = new Array();

	var atchRelObj    = new AttachmentRelationObj(atchRelId, atchObjectId, atchTgtId, atchUsageId, atchSeq, "<%=objectType%>");


<%
	// Get the list of available languages
	for (int i=0; i<iLanguages.length; i++) 
	{
		if (iLanguages[i].intValue() == storeDefLangId.intValue()) 
		{
			iLanguages[i] = iLanguages[0];
			iLanguages[0] = storeDefLangId;
		}
	}


	// Get the language descriptions
	Hashtable hLanguages = new Hashtable();
	for (int i=0; i<iLanguages.length; i++) 
	{
		LanguageDescriptionDataBean bnLanguage = new LanguageDescriptionDataBean();
		try {
			bnLanguage.setDataBeanKeyDescriptionLanguageId(iLanguages[i].toString());
			bnLanguage.setDataBeanKeyLanguageId(((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLanguageId().toString());
			DataBeanManager.activate(bnLanguage, cmdContext);
		} catch (Exception ex) {
			bnLanguage = new LanguageDescriptionDataBean();
			bnLanguage.setDataBeanKeyDescriptionLanguageId(iLanguages[i].toString());
			bnLanguage.setDataBeanKeyLanguageId(storeDefLangId.toString());
			DataBeanManager.activate(bnLanguage, cmdContext);			
		}
		hLanguages.put(iLanguages[i].toString(), bnLanguage.getDescription());
%>
		hLanguages["<%=iLanguages[i].toString()%>"] = "<%=UIUtil.toJavaScript(bnLanguage.getDescription())%>";
		hLanguagesCount["<%=iLanguages[i].toString()%>"] = 0;
<%
	}

	// List of Mime Types
	Hashtable hAttachmentPropertiesXML = (Hashtable)ResourceDirectory.lookup("attachment.AttachmentProperties");
	Hashtable hAttachmentProperties    = (Hashtable) hAttachmentPropertiesXML.get("attachmentProperties");
	Hashtable hAttachmentMimeTypes     = (Hashtable) hAttachmentProperties.get("previewMimeType");

	Vector vAttachmentMimeTypes = (Vector) hAttachmentMimeTypes.get("mimeType");
	for (int i = 0; i < vAttachmentMimeTypes.size(); i++) 
	{
		Hashtable hMimeType = (Hashtable) vAttachmentMimeTypes.elementAt(i);
%>
		previewMimeTypes[previewMimeTypes.length] = "<%=hMimeType.get("value").toString()%>";
<%
	}


	if (sentBack.equals("true"))
	{
%>
		var atchRelObjSaved = top.get("<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_SAVED_DESCRIPTIONS%>");

		if (atchRelObjSaved != null) {
		
			atchSeq = atchRelObjSaved.seq;
			atchUsageId = atchRelObjSaved.usageId;
			atchRelObj.description = atchRelObjSaved.description;
			
			top.remove("<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_SAVED_DESCRIPTIONS%>");
		}
		
		var savedAssets = top.get("<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_SAVED_ASSETS%>");
		
		if (savedAssets != null) {

			for (var i = 0; i < savedAssets.length; i++) {
				aAssets[i] = new AttachmentAsset(savedAssets[i].atchastId, '<%=storeId%>', '<%=atchTargetId%>', savedAssets[i].assetPath, '', savedAssets[i].mimeType, '', '<%=abStore.getDirectory()%>');
				aAssets[i].setLang(savedAssets[i].language);
				aAssets[i].action = savedAssets[i].action;
				aAssets[i].remove = savedAssets[i].remove;
			}

			top.remove("<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_SAVED_ASSETS%>");
 		}
<%
	} else {

		if (abAttachmentRelation != null) 
		{
			// Create the Attachment Relation Description Bean
			AttachmentRelationDescriptionAccessBean abAttachmentRelationshipDescription =  new AttachmentRelationDescriptionAccessBean();
	
			for (int i = 0; i < iLanguages.length; i++) 
			{
				String strName = "";
				String strDesc = "";
				try 
				{
					abAttachmentRelationshipDescription = abAttachmentRelationshipDescription.findByAttachmentRelationIdAndLanguageId(new Long(atchRelId), iLanguages[i]);
					strName = UIUtil.toJavaScript(abAttachmentRelationshipDescription.getName());
					strDesc = UIUtil.toJavaScript(abAttachmentRelationshipDescription.getLongDescription());
				} catch (Exception e) {} 
%>
			atchRelObj.updateDesc("<%=iLanguages[i]%>", "<%=strName%>", "", "<%=strDesc%>");
<%
			}
		}


		if (atchTargetId != null) 
		{
	
			// Retrieve Asset List
			int iAssetCount = 0;
			AttachmentAssetAccessBean abAttachmentAsset = new AttachmentAssetAccessBean();
			Enumeration enAttachmentAssets = abAttachmentAsset.findByTargetId(new Long(atchTargetId));
			while (enAttachmentAssets.hasMoreElements()) 
			{
%>
				var aLanguages = new Array();
<%
				// attachment asset
				abAttachmentAsset = (AttachmentAssetAccessBean) enAttachmentAssets.nextElement();
				String strAtchAssetId = abAttachmentAsset.getAttachmentAssetId();
	
				// attachment asset language
				AttachmentAssetLanguageAccessBean abAttachmentAssetLanguage = new AttachmentAssetLanguageAccessBean();
				Enumeration enAttachmentAssetLanguages = abAttachmentAssetLanguage.findByAssetId(new Long(strAtchAssetId));
				String strLanguageList = null;
	
				// loop through languages
				while (enAttachmentAssetLanguages.hasMoreElements()) 
				{
					abAttachmentAssetLanguage = (AttachmentAssetLanguageAccessBean) enAttachmentAssetLanguages.nextElement();
					if (strLanguageList == null) { strLanguageList = (String) hLanguages.get(abAttachmentAssetLanguage.getLanguageId().toString()); }
					else                         { strLanguageList = strLanguageList + strSeparationToken + " " + (String) hLanguages.get(abAttachmentAssetLanguage.getLanguageId().toString()); }
%>
					aLanguages[aLanguages.length] = "<%=abAttachmentAssetLanguage.getLanguageIdInEntityType() %>";
<%
				}

%>
				aAssets[<%=iAssetCount%>] = new AttachmentAsset('<%=strAtchAssetId%>', '<%=storeId%>', '<%=atchTargetId%>', '<%=UIUtil.toJavaScript(abAttachmentAsset.getAttachmentAssetPath())%>', '', '<%=abAttachmentAsset.getMimeType()%>', '', '<%=abStore.getDirectory()%>');
				aAssets[<%=iAssetCount%>].setLang(aLanguages);
				aAssets[<%=iAssetCount%>].action = "none";
<%
				iAssetCount++;
			}
		}
	}
%>


	// append newly selected files from browser tool
	var selectedAttachmentFileSet = top.getData("<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS%>", null);
	
	if (selectedAttachmentFileSet == null) 
	{
		selectedAttachmentFileSet = top.get("<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS%>", null);
		top.remove("<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS%>");
	}
	
	if (selectedAttachmentFileSet != null) 
	{
		for (var i = 0; i < selectedAttachmentFileSet.length; i++) 
		{
			var attachmentAsset = new AttachmentAsset('new', '<%=storeId%>', '<%=atchTargetId%>', selectedAttachmentFileSet[i].assetPath, '', selectedAttachmentFileSet[i].mimeType, '', '<%=abStore.getDirectory()%>');
			
			if (isAssetExist(attachmentAsset) == false) 
			{
				aAssets[aAssets.length] = attachmentAsset;
			}
		}
		top.saveData(null, "selectedAttachmentFileSet");
	}




	/////////////////////////////////////////////////////////////////////////////////////
	// fcnOnLoad()
	//
	// - this function is called upon load of the page
	/////////////////////////////////////////////////////////////////////////////////////
	function fcnOnLoad()
	{
		// Select what we show
		switch ("<%=strTool%>") {
			case "description":
				setupDescription();
				break;
			case "asset":
				setupAsset();
				break;
			default:
				setupDescription();
<%		if  (!SINGLELANGSTORE) { %>
				setupAsset();
<%		} %>
				attachmentUsageDiv.style.display       = "block";
				break;
		}
	}
	
	/////////////////////////////////////////////////////////////////////////////////////
	// setPageUpdate(value)
	//
	// - this function set the page update value 0 == changes saved, 1 save changes require
	/////////////////////////////////////////////////////////////////////////////////////
	function setPageUpdate(value)
	{
		pageUpdated = value;
	}

	/////////////////////////////////////////////////////////////////////////////////////
	// isPageUpdated(value)
	//
	// - return true if the page is updated
	/////////////////////////////////////////////////////////////////////////////////////
	function isPageUpdated()
	{
		return pageUpdated;
	}
	
	/////////////////////////////////////////////////////////////////////////////////////
	// isAssetExist(attachmentAsset)
	//
	// - this function returns true if attachmentAsset already exist on the list, 
	//   false otherwise
	/////////////////////////////////////////////////////////////////////////////////////
	function isAssetExist(attachmentAsset)
	{
		var cmFilePath = attachmentAsset.getCMFilePath();
		
		for (var i = 0; i < aAssets.length; i++) {
			if (aAssets[i].getCMFilePath() == cmFilePath && aAssets[i].action != 'remove') return true;
		}
		
		return false;
	}

	/////////////////////////////////////////////////////////////////////////////////////
	// setupDescription()
	//
	// - this function is called to set up the description div
	/////////////////////////////////////////////////////////////////////////////////////
	function setupDescription()
	{
		for (var i=0; i<AtchUsage.options.length; i++)
		{
			if (AtchUsage.options[i].value == atchUsageId)
			{
				AtchUsage.options[i].selected = true;
				break;
			}
		}
		AtchSeq.value = top.numberToStr(atchSeq, <%=cmdContext.getLanguageId()%>);
				
		selectedLang = AtchLang.value;
		selectLanguage(false);

		attachmentDescriptionDiv.style.display = "block";
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// setupAsset()
	//
	// - this function is called to set up the asset div
	/////////////////////////////////////////////////////////////////////////////////////
	function setupAsset()
	{
		setButtons(0);
		resetDisplayColor();

		attachmentAssetDiv.style.display = "block";
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// getLanguagesString(languages)
	//
	// @param languages - array of language Ids
	//
	// - this function returns a string with a concatenated list of languages
	/////////////////////////////////////////////////////////////////////////////////////
	function getLanguagesString(languages) 
	{
		
		if (languages.length == numOfLanguages) return strAllLang;
		if (languages.length == 0) return strSpecifyLang;

		var strLanguages = "";
		var langId = "";
		
		for (var i = 0; i < languages.length; i++) 
		{
			var langIndex = "" + languages[i];
			if (i == 0) strLanguages = hLanguages[langIndex];
			else        strLanguages = strLanguages + langToken + " " + hLanguages[langIndex];
		}

		return strLanguages;
	}
	


	/////////////////////////////////////////////////////////////////////////////////////
	// popupLanguage(atchAssetId, atchTgtId, fileId)
	//
	// @param atchAssetId - attachment asset id
	// @param atchTgtId   - attachment target id
	// @param fileId      - the selected file
	//
	// Show language popup dialog
	/////////////////////////////////////////////////////////////////////////////////////
	function popupLanguage(atchAssetId, atchTgtId, fileId)
	{
		setPageUpdate(true);
		existingLanguages = new Array();
		for (var i=0; i<aAssets.length; i++)
		{
			if (aAssets[i].remove == false && i != fileId)
			{
				var iLanguages = aAssets[i].language;
				for (var j=0; j<iLanguages.length; j++)
				{ 
					existingLanguages[existingLanguages.length] = iLanguages[j];
				}
			}
		}

		var iframeReference = document.all.languageIframe;
		iframeReference.style.posTop = document.body.scrollTop + 100;

		selectedLangFileId = fileId;
		selectedAssetLanguages = aAssets[selectedLangFileId].language;
		eval("selectedAtchAstLang = lang_" + atchTgtId + "_" + atchAssetId + ".value;"); 

		if (iframeReference.src == "/wcs/tools/common/blank.html") 
		{
			iframeReference.src = top.getWebPath() + 'AttachmentLanguagePopupDialogView?saveChanges=false&atchAssetLang=' + selectedAtchAstLang + '&atchAssetId=' + atchAssetId + '&atchTargetId=' + atchTgtId;
		} else {
			languageIframe.atchLangPopupFS.setSelectedLanguages(aAssets[selectedLangFileId].language);
		}

		iframeReference.style.display = "block";
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// getExistingLanguages()
	//
	// @return - returns the existingLanguages array
	/////////////////////////////////////////////////////////////////////////////////////
	function getExistingLanguages()
	{
		return existingLanguages;
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// resizePopup()
	//
	// - resize the language popup to contain all languages
	/////////////////////////////////////////////////////////////////////////////////////
	function resizePopup()
	{
		var scrollWidth  = languageIframe.atchLangPopupFS.document.body.scrollWidth;
		var scrollHeight = languageIframe.atchLangPopupFS.document.body.scrollHeight + 50;

		if (scrollWidth < 300)  scrollWidth = 300;
		if (scrollHeight < 300) scrollHeight = 300;

		document.all.languageIframe.style.width  = scrollWidth;
		document.all.languageIframe.style.height = scrollHeight;
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// closePopupLanguage()
	//
	// - hide the language popup
	/////////////////////////////////////////////////////////////////////////////////////
	function closePopupLanguage() 
	{
		document.all.languageIframe.style.display = "none";
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// setLanguages(languages)
	//
	// @param languages - array of languageIds
	//
	// - processes a return of languages from the language popup
	/////////////////////////////////////////////////////////////////////////////////////
	function setLanguages(languages) 
	{
		eval("langFile_" + selectedLangFileId + ".innerHTML = getLanguagesString(languages);");
		aAssets[selectedLangFileId].setLang(languages);
		aAssets[selectedLangFileId].action = "update";
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// checkBoxEvent(value, event)
	//
	// @param value - id of the item
	// @param event - caller
	//
	// - checkbox event handler, will add/remove to items from checked/unchecked action respectively
	/////////////////////////////////////////////////////////////////////////////////////
	function checkBoxEvent(value, event) 
	{
		if (event.srcElement.checked == true) 
		{
			addElement(value);
		} else {
			removeElement(value);
		}
		
		setButtons(selectedAssets.length);
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// addElement(value)
	//
	// @param value - id of the item
	//
	// - adds an element to the selected list
	/////////////////////////////////////////////////////////////////////////////////////
	function addElement(value) 
	{
		selectedAssets[selectedAssets.length] = value;
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// removeElement(value)
	//
	// @param value - id of the item
	//
	// - removes an element to the selected list
	/////////////////////////////////////////////////////////////////////////////////////
	function removeElement(value) 
	{
		var index;
		
		for (index = 0; index < selectedAssets.length; index++) 
		{
			if (selectedAssets[index] == value) break;
		}
		
		selectedAssets.splice(index, 1);
	}



	/////////////////////////////////////////////////////////////////////////////////////
	// setButtons(count)
	//
	// @param count - the number of checkboxs currently checked
	//
	// - this function enables/disables the buttons based on the number of checkboxes
	/////////////////////////////////////////////////////////////////////////////////////
	function setButtons(count) 
	{
		if (count == 0) 
		{
			enableButton(btnAdd, true);
			enableButton(btnDelete, false);
		} else if (count == 1) {
			enableButton(btnAdd, true);
			enableButton(btnDelete, true);
		} else {
			enableButton(btnAdd, true);
			enableButton(btnDelete, true);
		}
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// addButton()
	//
	// - process a click of the add asset button
	/////////////////////////////////////////////////////////////////////////////////////
	function addButton() 
	{
		if (isButtonEnabled(btnAdd) == false) return;
		
		setPageUpdate(true);

		if ((parent.strTool == "description") || (parent.strTool == "all")) {
			var saveAttachmentPropertiesDescription = getAttachmentPropertiesDescription();
			if (saveAttachmentPropertiesDescription == null) return;
			top.put("<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_SAVED_DESCRIPTIONS%>", saveAttachmentPropertiesDescription);
		}

		top.put("<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_SAVED_ASSETS%>", aAssets);
		addLanguageFile();
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// deleteButton()
	//
	// - process a click of the delete asset button
	/////////////////////////////////////////////////////////////////////////////////////
	function deleteButton()
	{
		if (isButtonEnabled(btnDelete) == false) return;
		
		setPageUpdate(true);
		
		deleteSelectedAssets();
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// addLanguageFile()
	//
	// - add language file from search browser
	/////////////////////////////////////////////////////////////////////////////////////
	function addLanguageFile() 
	{
		cleanUp();
	
		var url = top.getWebPath() + "PickAttachmentAssetsTool";

		var urlPara = new Object();
		urlPara.objectId     = parent.objectId;
		urlPara.objectType   = parent.objectType;
		urlPara.usageId      = parent.usageId;
		urlPara.atchTargetId = parent.atchTargetId;
		urlPara.saveChanges  = false;
		urlPara.returnPage   = CONSTANT_TOOL_DEFAULT;

		top.setContent("<%=UIUtil.toJavaScript((String) rbAttachment.get("Attachment_Assets_Browser_Title"))%>", url, true, urlPara);
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// deleteSelectedAssets()
	//
	// - delete selected assets from the list by hiding them
	/////////////////////////////////////////////////////////////////////////////////////
	function deleteSelectedAssets() 
	{
		if (deleteAllFiles()) 
		{
			alertDialog('<%=UIUtil.toJavaScript((String) rbAttachment.get("AttachmentSpecifyLanguages_Delete"))%>');
			return;
		}

		for (var i = 0; i < selectedAssets.length; i++) 
		{
			deleteAsset(selectedAssets[i]);
		}

		selectedAssets = new Array();
		setButtons(selectedAssets.length);
		resetDisplayColor();
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// deleteAsset(value)
	//
	// @param value - id of the asset to delete
	//
	// - hide the selected asset
	/////////////////////////////////////////////////////////////////////////////////////
	function deleteAsset(value) 
	{
		var spanElement = eval("span_" + value);
		aAssets[value].remove = true;
		aAssets[value].action = "remove";
		spanElement.style.display = "none";
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// selectLanguage(updateTF)
	//
	// @param updateTF - if true then the current language will be updated
	//
	// - process a click of the language dropdown
	/////////////////////////////////////////////////////////////////////////////////////
	function selectLanguage(updateTF) 
	{
		if (updateTF == true) atchRelObj.updateDesc(selectedLang, AtchName.value , "", AtchDesc.value);

		var descObject = atchRelObj.getDesc(AtchLang.value);
		AtchName.value = descObject.name;
		AtchDesc.value = descObject.longDesc;
		selectedLang = AtchLang.value;
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// deleteAllFiles()
	//
	// @return true if all assets are deleted otherwise false
	/////////////////////////////////////////////////////////////////////////////////////
	function deleteAllFiles() 
	{
		var count = 0;
		for (var i = 0; i < aAssets.length; i++) 
		{
			if (!aAssets[i].remove) count++;
		}
		return (count == selectedAssets.length);
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// cleanUp()
	//
	// - delete removed assets from array if the asset is newly added
	/////////////////////////////////////////////////////////////////////////////////////
	function cleanUp() 
	{
		for (var i = 0; i < aAssets.length;) 
		{
			if (aAssets[i].atchastId == "new" && aAssets[i].remove == true) 
			{
				aAssets.splice(i, 1);
			} else {
				i++;
			}
		}
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// resetDisplayColor()
	//
	// - set the alternating asset row colors for visible rows
	/////////////////////////////////////////////////////////////////////////////////////
	function resetDisplayColor() 
	{
		var count = 0;

		for (var i = 0; i < aAssets.length; i++) 
		{
			var spanElement = eval("span_" + i);
			if (spanElement.style.display != "none") 
			{
				eval('table_' + i + '.className = \'attachmentAssetTable' + (((count+1) % 2) + 1) + '\';');
				count++;
			}
		}
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// checkOverlap()
	//
	// @return true if the languages overlap otherwise false
	//
	// - determine if the languages overlap between the assets
	/////////////////////////////////////////////////////////////////////////////////////
	function checkOverlap() 
	{
		if (onlyOneWithAllLanguages()) return false;
		if (!allHasLanguage()) return true;

		calculateLanguageCount();
			
		for (var i in hLanguagesCount) {
			if (hLanguagesCount[i] > 1) return true;
		}
		
		return false;
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// calculateLanguageCount()
	//
	// - calculate if there are languages overlap each other
	/////////////////////////////////////////////////////////////////////////////////////
	function calculateLanguageCount() 
	{
		resetLanguageCount();

		for (var i = 0; i < aAssets.length; i++) 
		{
			if (!aAssets[i].remove) 
			{
				var languages = aAssets[i].language;
				for (var j = 0; j < languages.length; j++) 
				{
					for (var k in hLanguagesCount) 
					{
						var langId = "" + languages[j];
						if (k == langId) hLanguagesCount[k]++;
					}
				}
			}
		}
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// resetLanguageCount()
	//
	// - reset the language count for each language
	/////////////////////////////////////////////////////////////////////////////////////
	function resetLanguageCount() 
	{
		for (var i in hLanguagesCount) 
		{
			hLanguagesCount[i] = 0;
		}
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// allHasLanguage()
	//
	// @return true if there are files with no language
	//
	// - check if there are files with no language
	/////////////////////////////////////////////////////////////////////////////////////
	function allHasLanguage() 
	{
		resetLanguageCount();

		for (var i = 0; i < aAssets.length; i++) 
		{
			if (!aAssets[i].remove) 
			{
				if (aAssets[i].language.length == 0) return false;
			}
		}
		
		return true;
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// onlyOneWithAllLanguages()
	//
	// @return true if there is only one file and it has all languages
	//
	/////////////////////////////////////////////////////////////////////////////////////
	function onlyOneWithAllLanguages() 
	{
		resetLanguageCount();

		var iCount = 0;
		for (var i = 0; i < aAssets.length; i++) 
		{
			if (!aAssets[i].remove) 
			{
				iCount++;
				if (iCount > 1 || aAssets[i].language.length != 0) return false;
			}
		}
		
		return true;
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// getAtchRelObj()
	//
	// - update and return attachment properties information
	/////////////////////////////////////////////////////////////////////////////////////
	function getAtchRelObj() 
	{
		atchRelObj.seq     = top.strToNumber(AtchSeq.value, <%=cmdContext.getLanguageId()%>);
		atchRelObj.usageId = AtchUsage.value;
		return atchRelObj;
	} 


	/////////////////////////////////////////////////////////////////////////////////////
	// getAttachmentPropertiesDescription()
	//
	// - retrieve the properties so they can be sumitted for saving
	/////////////////////////////////////////////////////////////////////////////////////
	function getAttachmentPropertiesDescription() 
	{
<%
		if (strTool.equals("asset")) 
		{
%>
			var attachmentPropertiesDescription = new Object();
			attachmentPropertiesDescription.type   = "atchrel";
			attachmentPropertiesDescription.action = "none";
			return attachmentPropertiesDescription;
<%
		}
%>

		// check for valid integer value
		
		if (!top.isValidNumber(AtchSeq.value, <%=cmdContext.getLanguageId()%>)) 
		{
			AtchSeq.select();
			alertDialog("<%=UIUtil.toJavaScript((String)rbAttachment.get("AttachmentModifyDescription_Error_Sequence"))%>");
			return null;
		}

		// ensure description will not exceed maximum length
		if ( !isValidUTF8length(AtchDesc.value, 4000)  )
		{
			AtchDesc.select();
			alertDialog("<%=UIUtil.toJavaScript((String)rbAttachment.get("AttachmentModifyDescription_Error_Description"))%>");
			return null;
		}

		// retrieve latest description value
		selectLanguage(true);

		var attachmentPropertiesDescription = getAtchRelObj();
		attachmentPropertiesDescription.type   = "atchrel";
		attachmentPropertiesDescription.action = "update";
		return attachmentPropertiesDescription;
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// getAttachmentPropertiesAssets()
	//
	// - retrieve the properties so they can be sumitted for saving
	/////////////////////////////////////////////////////////////////////////////////////
	function getAttachmentPropertiesAssets() 
	{
<%
		if (strTool.equals("description")) 
		{
%>
			var attachmentPropertiesAssetsObject = new Object();
			attachmentPropertiesAssetsObject.type   = "atchast";
			attachmentPropertiesAssetsObject.action = "none";
			return attachmentPropertiesAssetsObject;
<%
		}
%>

		cleanUp();

		if (checkOverlap())
		{
			alertDialog('<%=UIUtil.toJavaScript((String) rbAttachment.get("AttachmentSpecifyLanguages_Overlap"))%>');
			return null;
		}

		var attachmentPropertiesAssetsObject = new Object();
		attachmentPropertiesAssetsObject.action  = "update";
		attachmentPropertiesAssetsObject.type    = "atchast";
		attachmentPropertiesAssetsObject.atchast = aAssets;
		return attachmentPropertiesAssetsObject;
	}


	</script>

</head>

<body class=content onload="fcnOnLoad();" style="width:95%;" oncontextmenu="return false;">

	<div id="attachmentUsageDiv" style="display:none;">
	<div id=div1 class=attachmentH1><%=UIUtil.toHTML((String)rbAttachment.get("AttachmentUpdateDialog_String_Usage_Title"))%></div>
	<%=UIUtil.toHTML((String)rbAttachment.get("AttachmentUpdateDialog_String_Usage_Instruction"))%><br><br>

	<table style="margin-left:25px;">
		<tr>
			<td><label for="AtchUsage"><%=UIUtil.toHTML((String)rbAttachment.get("Attachment_Usage"))%></label></td>
			<td width=50>&nbsp;</td>
			<td><label for="AtchSeq"><%=UIUtil.toHTML((String)rbAttachment.get("Sequence"))%></label></td>
		</tr>
		<tr>
			<td>
				<select onchange="setPageUpdate(true);" id="AtchUsage" size=1>
<%
				for (int i = 0; i < vUsageList.size(); i++) 
				{
					Vector vUsage = (Vector) vUsageList.elementAt(i);

					String strUsageId   = vUsage.elementAt(0).toString();
					String strUsageName = (String) vUsage.elementAt(4);
%>
					<option value="<%=strUsageId%>"><%=UIUtil.toHTML(strUsageName)%>
<%
				}
%>
				</select>
		</td>
		<td></td>
		<td><input onchange="setPageUpdate(true);" size=10 maxlength=10 id="AtchSeq" name="AtchSeq" value=""></td>
		</tr>
	</table>
	</div>

	<div id="attachmentDescriptionDiv" style="display:none;">
	<div class=attachmentH1 style="margin-top:22px;"><%=UIUtil.toHTML((String)rbAttachment.get("AttachmentModifyDescription_String_Title"))%></div>
	<%=UIUtil.toHTML((String)rbAttachment.get("AttachmentModifyDescription_String_Instruction"))%><br><br>

	<table style="margin-left:25px;">
		<!-- Languages Dropdown -->
		<tr><td><label for="AtchLang"><%=UIUtil.toHTML((String)rbAttachment.get("Language"))%></label></td></tr>
		<tr valign=top>
			<td>
				<select id="AtchLang" onchange=selectLanguage(true)>
<% 				for (int i = 0; i < iLanguages.length; i++) { %>
						<option value="<%=iLanguages[i]%>"><%=(String)hLanguages.get(iLanguages[i].toString())%>
<% 				} %>
				</select>
			</td>
		</tr>
		<tr height=5><td></td></tr>
		<tr>
			<td>
				<label for="AtchName">
					<%=UIUtil.toHTML((String)rbAttachment.get("Name"))%>
				</label>
			</td>
		</tr>
		<tr valign=top>
			<td>
				<input onchange="setPageUpdate(true);" size=50 maxlength=126 id="AtchName" name="AtchName" value="">
			</td>
		</tr>
		<tr height=5><td></td></tr>
		<tr>
			<td>
				<label for="AtchDesc">
					<%=UIUtil.toHTML((String)rbAttachment.get("UsageDescription"))%>
				</label>
			</td>
		</tr>
		<tr valign=top>
			<td>
				<textarea onchange="setPageUpdate(true);" id="AtchDesc" name="AtchDesc" rows=3 cols=50 wrap="hard"></textarea>
			</td>
		</tr>
	</table>
	</div>

	<div id="attachmentAssetDiv" style="display:none;">
	<div class=attachmentH1 style="margin-top:22px;"><%=UIUtil.toHTML((String)rbAttachment.get("AttachmentChange_Asset_Title"))%></div>
	<%=UIUtil.toHTML((String)rbAttachment.get("AttachmentChange_Asset_Instruction"))%><br><br>

	<table cellpadding=0 cellspacing=0 border=0 style="width:95%;margin-left:25px;">
		<tr>
			<td>
				<table class=attachmentAssetTable0 cellpadding=0 cellspacing=0 border=0 style="width:95%;"><tr><td></td></tr></table>
			
				<script>
					var toolTipPreview = '<%=UIUtil.toJavaScript((String)rbAttachment.get("Preview"))%>';
					var toolTipSpecifyLanguage = '<%=UIUtil.toJavaScript((String)rbAttachment.get("AttachmentList_String_SpecifyLanguage"))%>';
					for (var i = 0; i < aAssets.length; i++) 
					{
						var langIndependent = false;
						var displayNone = "style='display:none'";
				
						if (aAssets[i].language.length != 0) {
							langIndependent = true;
						} // if

						if (!aAssets[i].remove) {
							displayNone = "";
						} // if
				
						document.writeln('<span id=span_' + i + ' ' + displayNone + '>');
						document.writeln('	<table id=table_' + i + ' border=0 cellpadding=0 cellspacing=0 style="width:95%;">');
						document.writeln('		<tr><td rowspan=4 align=center bgcolor=#D3D4DB width=4><input id=1 type=checkbox onclick="checkBoxEvent(' + i + ', event)"></td></tr>');
						document.writeln('		<tr><td style="height:5px;"></td></tr>');
						document.writeln('		<tr>');
						document.writeln('			<td align=center width=150>');
						document.writeln('				<input id=assetId_' + aAssets[i].atchtgtId + '_' + i + ' type=hidden value="' + aAssets[i].atchastId + '">');
						document.writeln('				<input id=lang_' + aAssets[i].atchtgtId + '_' + aAssets[i].atchastId + ' type=hidden value="' + langIndependent + '">');
						document.writeln('				<a href="' + aAssets[i].getAssetPath() + '" target="_blank" onmouseover="toolTipOn(toolTipPreview);" onmouseout="toolTipOff();"><img height=75 width=100 src="' + aAssets[i].getImagePath(previewMimeTypes) + '"></a>');
						document.writeln('			</td>');
						document.writeln('			<td valign=middle>');
						document.writeln('				<table cellpadding=1 cellspacing=1 border=0 style="width:100%">');
						if (aAssets[i].mimeType == "")
						{
							document.writeln('					<tr>');
							document.writeln('						<td width=100 class=attachmentTargetTable align=left><%=UIUtil.toJavaScript((String) rbAttachment.get("Attachment_URL"))%>:</td>');
							document.writeln('						<td class=attachmentTargetTableText align=left><a href="' + aAssets[i].getAssetPath() + '" target="_blank" onmouseover="toolTipOn(toolTipPreview);" onmouseout="toolTipOff();">' + aAssets[i].assetPath + '</a></td>');
							document.writeln('					</tr>');
						} else {
							document.writeln('					<tr>');
							document.writeln('						<td width=100 class=attachmentTargetTable align=left><%=UIUtil.toJavaScript((String) rbAttachment.get("Attachment_Path"))%>:</td>');
							document.writeln('						<td class=attachmentTargetTableText align=left><a href="' + aAssets[i].getAssetPath() + '" target="_blank" onmouseover="toolTipOn(toolTipPreview);" onmouseout="toolTipOff();">' + aAssets[i].assetPath + '</a></td>');
							document.writeln('					</tr>');
							document.writeln('					<tr>');
							document.writeln('						<td width=100 class=attachmentTargetTable align=left><%=UIUtil.toJavaScript((String) rbAttachment.get("Attachment_MimeType"))%>:</td>');
							document.writeln('						<td class=attachmentTargetTableText align=left>' + aAssets[i].mimeType + '</td>');
							document.writeln('					</tr>');
						}
						document.writeln('					<tr>');
						document.writeln('						<td width=100 class=attachmentTargetTable align=left><a href="javascript:void(0);" onclick="popupLanguage(\'' + aAssets[i].atchastId + '\', \'' + aAssets[i].atchtgtId + '\', ' + i + ')" onmouseover="toolTipOn(toolTipSpecifyLanguage);" onmouseout="toolTipOff();"><%=UIUtil.toJavaScript((String) rbAttachment.get("Language"))%>:</a></td>');
						document.writeln('						<td class=attachmentTargetTableText align=left><a id=langFile_' + i + ' href="javascript:void(0);" onclick="popupLanguage(\'' + aAssets[i].atchastId + '\', \'' + aAssets[i].atchtgtId + '\', ' + i + ')" onmouseover="toolTipOn(toolTipSpecifyLanguage);" onmouseout="toolTipOff();">' + getLanguagesString(aAssets[i].language) + '</a></td>');
						document.writeln('					</tr>');
						document.writeln('				</table>');
						document.writeln('			</td>');
						document.writeln('		</tr>');
						document.writeln('		<tr><td style="height:5px;"></td></tr>');
						document.writeln('	</table>');
						document.writeln('</span>');
					}
				</script>
				<table class=attachmentAssetTable3 cellpadding=0 cellspacing=0 border=0 style="width:95%;"><tr><td></td></tr></table>
			</td>
			<td valign=top width=125>
				<script>
				
					beginButtonTable();
					drawButton("btnAdd", "<%=UIUtil.toJavaScript((String) rbAttachment.get("AttachmentList_Title_AddLanguageFile"))%>", "addButton()", "disabled");
					drawButton("btnDelete", "<%=UIUtil.toJavaScript((String) rbAttachment.get("Delete"))%>", "deleteButton()", "disabled");		
					endButtonTable();
					AdjustRefreshButton(btnAdd);
					AdjustRefreshButton(btnDelete);
					
				</script>
			</td>
		</tr>
	</table>
	</div>

</body>

<iframe name="languageIframe"
   marginheight=3 marginwidth=3 noresize scrolling=no frameborder=no
   title="<%=UIUtil.toHTML((String)rbAttachment.get("AttachmentSpecifyLanguages_Iframe_Title"))%>"
   src="/wcs/tools/common/blank.html" allowTransparency="false"
   style="border:1px solid gray;display:none;position:absolute;top:100;left:45%;width:300;height:332;z-index=9999;filter: progid:DXImageTransform.Microsoft.Shadow(color=#777777, Direction=135, Strength=4);">
</iframe>

<div id=tooltipDiv class=attachmentToolTipDiv></div>

<script>
		document.onmousemove = setMousePosition;
</script>

</html>
