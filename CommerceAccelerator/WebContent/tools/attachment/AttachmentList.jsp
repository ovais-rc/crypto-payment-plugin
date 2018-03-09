<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2005, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<% 
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//------------------------------------------------------------------------------
// 040515           BLI       Creation Date
// 041206    96655  BLI       Made changes to preview path
// 041206    96308  BLI       Fix checkbox attachment list problem
// 041222    97465  WYA	      Change table layout to wrap long attachment names
// 040105    97731  BLI       Added port in the url to preview attachment file
////////////////////////////////////////////////////////////////////////////////
%>


<%@ page language="java" %>

<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.attachment.objects.*" %>
<%@ page import="com.ibm.commerce.attachment.content.resources.*" %>
<%@ page import="com.ibm.commerce.attachment.util.AttachmentRelationUsageHelper" %>
<%@ page import="com.ibm.commerce.attachment.common.ECAttachmentConstants" %>
<%@ page import="com.ibm.commerce.common.beans.LanguageDescriptionDataBean" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.context.globalization.GlobalizationContext" %>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.server.WcsApp" %>
<%@ page import="com.ibm.commerce.content.preview.command.CMWSPreviewConstants" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Vector" %>


<%@include file="../common/common.jsp" %>
<%@include file="../attachment/Worksheet.jspf" %>

<%
	CommandContext cmdContext 				= (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbAttachment 					= (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("attachment.AttachmentNLS", ((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale());
    StoreAccessBean storeAB 				= cmdContext.getStore();
    String myStorePath 						= storeAB.getDirectory();
    
	// databeans
	LanguageDescriptionDataBean languageDB 	= null;

	Integer storeDefLangId 		= cmdContext.getStore().getLanguageIdInEntityType();

	// parameters to find usage and target
	JSPHelper jspHelper			= new JSPHelper(request);
	String objectType			= jspHelper.getParameter("objectType");
	String objectId				= jspHelper.getParameter("objectId");
	String readOnly				= jspHelper.getParameter("readOnly");
	String port                 = WcsApp.configProperties.getWebModule(CMWSPreviewConstants.PREVIEW_WEBAPP_NAME).getSSLPort().toString();
	String url                  = request.getRequestURL().toString();
	String urlForPreview        = getPreviewPath(url , port);
	String disabledString		= "";
		
	boolean ATCHREL_DESCRIPTION_FOUND = true;
	boolean SINGLELANGSTORE = false;
	
	// get all available languages and put it into an array
	Integer [] iLanguages = cmdContext.getStore().getSupportedLanguageIds();

	for (int i=0; i<iLanguages.length; i++)	{
	
		if (iLanguages[i].intValue() == storeDefLangId.intValue()) {
		
			iLanguages[i] = iLanguages[0];
			iLanguages[0] = storeDefLangId;
			
		} // if
	} // for
	
	// determine if this is a single langal store
	if (iLanguages.length == 1) {
		SINGLELANGSTORE = true;
	}
	
	if (readOnly == null) {
		readOnly = "false";
	} // if
	
	if (readOnly.equals("true")) {
		disabledString = "disabled";
	}

	Hashtable hAttachmentPropertiesXML = (Hashtable)ResourceDirectory.lookup("attachment.AttachmentProperties");
	Hashtable hAttachmentProperties = (Hashtable) hAttachmentPropertiesXML.get("attachmentProperties");
	Hashtable hAttachmentMimeTypes = (Hashtable) hAttachmentProperties.get("previewMimeType");
	Vector vAttachmentMimeTypes = (Vector) hAttachmentMimeTypes.get("mimeType");
	Vector attachmentMimeTypes = new Vector();
	Hashtable hMimeType;
	
	for (int i = 0; i < vAttachmentMimeTypes.size(); i++) {
		hMimeType = (Hashtable) vAttachmentMimeTypes.elementAt(i);
		attachmentMimeTypes.addElement(hMimeType.get("value"));
	}
	
%>

<html>
<head>

	<title><%=(String) rbAttachment.get("AttachmentList_Title_List")%></title>
	<link rel=stylesheet href="<%=UIUtil.getCSSFile(((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale())%>" type="text/css">

	<script SRC="/wcs/javascript/tools/attachment/AttachmentCommonFunctions.js"></script>
	<script src="/wcs/javascript/tools/attachment/Constants.js"></script>
	<script SRC="/wcs/javascript/tools/common/Util.js"></script>
	<script SRC="/wcs/javascript/tools/catalog/button.js"></script>

<script>

	var selectedAtchRelId 			= new Array();
	var selectedNoUsageAtchRelId 	= new Array();
	var selectedAtchTgtId 			= "0";
	var selectedAtchAstLang 		= "false";
	var atchAssetId 				= "0";
	var usageCount					= new Array();
	var defaultUsageIdIndex			= 0;
	var noAttachments				= true;
	
	/**
	*	refresh current page
	*/
	function refresh() {
		top.goBack(0);
	}

	/**
	*	this function enables/disables the buttons based on the number of checkboxes
	*
	*	@param count - the number of checkboxs currently checked
	*/
	function setButtons(count) {
	
		// no entry selected
		if (count == 0) {
		
			enableButton(btnAssignUsage, false);
					
		// >1 attachments relations selected
		} else {
			
			enableButton(btnAssignUsage, true);
		}
	}

	/**
	*	show language popup dialog
	*
	*	@param atchAssetId - attachment asset id
	*	@param atchTgtId - attachment target id
	*/
	function popupLanguage(atchAssetId, atchTgtId)	{

		selectedAtchTgtId = atchTgtId;
		selectedAtchAstId = atchAssetId;
		eval("selectedAtchAstLang = lang_" + atchTgtId + "_" + atchAssetId + ".value;"); 
		
		document.all.languageIframe.style.posTop = document.body.scrollTop + 50;

		if (document.all.languageIframe.src == "/wcs/tools/common/blank.html") {
			document.all.languageIframe.src = top.getWebPath() + 'AttachmentLanguagePopupDialogView?saveChanges=true&atchAssetLang=' + selectedAtchAstLang + '&atchAssetId=' + atchAssetId + '&atchTargetId=' + selectedAtchTgtId;
		}

		document.all.languageIframe.style.display = "block";
		return;
	}

	/**
	*	assign usage
	*/
	function assignUsage() {
	
		var usageId = assignUsageSelection.value;

		// Construct output object
		var atchObj = new AttachmentRelationObj(selectedNoUsageAtchRelId, parent.objectId, '', usageId, '', parent.objectType);
		
		atchObj.action 	= "update";
		atchObj.type 	= "atchrel";
		atchObj.url		= "AttachmentListDialogView";

        // reset the NoUsage list
        selectedNoUsageAtchRelId 	= new Array();
		
		parent.assignUsage(atchObj);
	}
	
	/**
	*	hide language popup dialog
	*/
	function closePopupLanguage()	{

		document.all.languageIframe.style.display = "none";
		document.all.languageIframe.src = "/wcs/tools/common/blank.html";
	}

	/**
	*	add a new language file with different language to the selected attachment
	*/
	function replace(assetId, targetId) {
	
		var url 		= top.getWebPath() + "PickAttachmentAssetsTool";
		var urlPara  	= new Object();

		urlPara.objectId		= <%=UIUtil.toJavaScript(objectId)%>;
		urlPara.objectType		= "<%=UIUtil.toJavaScript(objectType)%>";
		urlPara.returnPage		= CONSTANT_TOOL_DEFAULT;
		urlPara.atchTargetId	= targetId;
		urlPara.atchAstId		= assetId;
		urlPara.saveChanges 	= true;
		urlPara.selectMultiple	= false;
		
		top.setContent("<%=UIUtil.toJavaScript((String)rbAttachment.get("AttachmentList_String_ReplaceFile"))%>", url, true, urlPara);
	} 

	/**
	*	add a new language file with different language to the selected attachment
	*/
	function addLanguageFile(targetId) {
	
		var url 		= top.getWebPath() + "PickAttachmentAssetsTool";
		var urlPara  	= new Object();

		urlPara.objectId		= <%=UIUtil.toJavaScript(objectId)%>;
		urlPara.objectType		= "<%=UIUtil.toJavaScript(objectType)%>";
		urlPara.returnPage		= CONSTANT_TOOL_LANGUAGE;
		urlPara.atchTargetId	= targetId;
		urlPara.saveChanges 	= false;
		urlPara.objectName 		= parent.AttachmentListTitle.objectName;
		
		top.setContent("<%=UIUtil.toJavaScript((String)rbAttachment.get("AttachmentList_Title_AddLanguageFile"))%>", url, true, urlPara);
	} 
	
	/**
	*	load the state of the page
	*/
	function loadState() {
		
		var attachmentListState = new Object();
		var tempSelectedAtchRelId = new Array();
		var tempSelectedNoUsageAtchRelId = new Array();
		
		<%
		List tempList = new ArrayList();
		Vector usagesTemp = AttachmentRelationUsageHelper.getAllAttachmentRelationUsages(cmdContext.getLanguageId());
		if((usagesTemp != null) && (usagesTemp.size() >0))
		{
			AttachmentRelationAccessBean abAttachmentRelationTemp = new AttachmentRelationAccessBean();
			Vector usageTemp = null;
			Enumeration enAttachmentRelationTemp = null;
			
			for (int i = 0; i < usagesTemp.size(); i++) {
				// extract the usage out
				usageTemp = (Vector) usagesTemp.elementAt(i);
				if((usageTemp != null) && (ECAttachmentConstants.EC_ATCH_USAGE_DEFAULT_ID.equals(usageTemp.elementAt(0).toString()))){
					enAttachmentRelationTemp = abAttachmentRelationTemp.findByAttachmentObjectTypeIdentifierAndObjectIdAndRelationUsageIdentifier(objectType, objectId, (String) usageTemp.elementAt(1));
					while (enAttachmentRelationTemp.hasMoreElements()) {
						abAttachmentRelationTemp = (AttachmentRelationAccessBean) enAttachmentRelationTemp.nextElement();
						tempList.add(abAttachmentRelationTemp.getAttachmentRelationIdInEntityType());
					}
				}
			}
		}
		%>
		attachmentListState = top.getData("attachmentListState", null);

		if ((typeof(attachmentListState) != "undefined") && (attachmentListState != null)) {
		
			tempSelectedAtchRelId = cloneArray(attachmentListState.selectedAtchRelId);
			tempSelectedNoUsageAtchRelId = cloneArray(attachmentListState.selectedNoUsageAtchRelId);
			selectedAtchTgtId = attachmentListState.selectedAtchTgtId;
		
			for (var i = 0; i < tempSelectedAtchRelId.length; i++) {
				var relId = document.getElementById(tempSelectedAtchRelId[i]);
				if (relId != null) {
					<% 
							for(int j = 0; j < tempList.size(); j++){
					%>
								if(relId.id == "<%=tempList.get(j)%>"){
									selectedNoUsageAtchRelId[selectedNoUsageAtchRelId.length] = tempSelectedAtchRelId[i];
								}
					<%		}
					%>
					selectedAtchRelId[selectedAtchRelId.length] = tempSelectedAtchRelId[i];
					relId.checked = true;
				}
			}
			
			for (var i = 0; i < tempSelectedNoUsageAtchRelId.length; i++) {
				var relId = document.getElementById(tempSelectedNoUsageAtchRelId[i]);
				if (relId != null) {
					selectedNoUsageAtchRelId[selectedNoUsageAtchRelId.length] = tempSelectedNoUsageAtchRelId[i];
					relId.checked = true;
				}
			}	

			parent.AttachmentListButtons.setButtons(selectedAtchRelId.length);
			setButtons(selectedNoUsageAtchRelId.length);
		}

		top.saveData(null, "attachmentListState");
	}
	
	/**
	*	save the state of the page
	*/
	function saveState() {
	
		var attachmentListState = new Object();

		attachmentListState.selectedAtchRelId = cloneArray(selectedAtchRelId); 
		attachmentListState.selectedNoUsageAtchRelId = cloneArray(selectedNoUsageAtchRelId);
		attachmentListState.selectedAtchTgtId = selectedAtchTgtId;
	
		top.saveData(attachmentListState, "attachmentListState");
		top.sendBackData(attachmentListState, "attachmentListState");
	}
	
	/**
	*	unload function
	*/
	function onUnload() {
		saveState();
	}
	
	/**
	*	startup function
	*/
	function onLoad() {
	
		top.showProgressIndicator(false);

		// loop through usage, hide the ones that has no attachments (except the default usage), expand the ones that has attachments in it
		for (var i = 0; i < usageCount.length; i++) {
		
			eval("usage_" + i + ".innerHTML +=" + usageCount[i] + " + ')';");
			
			// hide usages with 0 attachments
			if (usageCount[i] > 0) {
			
				eval("SPAN_TITLE_" + i + ".style.display = 'block'");
				eval("SPAN_" + i + ".style.display = 'block'");
				noAttachments = false;
				
			} else {
			
				openClose(i);
				eval("SPAN_" + i + ".style.display = 'none'");

				if (i == defaultUsageIdIndex) {
					eval("SPANIMG_" + i + ".style.display = 'none'");
				}
			}
			
		}
		eval("SPAN_TITLE_" + defaultUsageIdIndex + ".style.display = 'block'");
		if (noAttachments) {
			noAttachmentText.style.display = 'block';
		}
		
		enableButton(btnAssignUsage, false);
	}

	/**
	*	this function is called when a usage is expanded or collapsed
	*
	*	@param usageId - the usage Id of the span
	*/
	function openClose(usageId) {
	
		var spanElement = eval("SPAN_" + usageId);
		var imgElement  = eval("SPANIMG_" + usageId);
		
		if (spanElement.style.display == "none") {

			spanElement.style.display = "block";
			imgElement.src = '/wcs/images/tools/attachment/collapse.gif';
			imgElement.alt = '<%=UIUtil.toJavaScript((String) rbAttachment.get("Collapse"))%>';
			
		} else {

			spanElement.style.display = "none";
			imgElement.src = '/wcs/images/tools/attachment/expand.gif';
			imgElement.alt = '<%=UIUtil.toJavaScript((String) rbAttachment.get("Expand"))%>';
		}
	}

	/**
	*	this function is called when a usage is expanded or collapsed
	*
	*	@param usageId - the usage Id of the span
	*	@param nousage - indicate whether this element belongs to the default usage
	*/
	function checkBoxEvent(event, nousage) {

		if (event.srcElement.checked == true) {
		
			if (nousage) {
				addNoUsageElement(event.srcElement.id);
			}
			
			addElement(event.srcElement.id);
			eval("selectedAtchTgtId = targetId_" + event.srcElement.id + ".value;");
			
		} else {
		
			if (nousage) {
				removeNoUsageElement(event.srcElement.id);
			}
			
			removeElement(event.srcElement.id);
		}
		
		parent.AttachmentListButtons.setButtons(selectedAtchRelId.length);
		setButtons(selectedNoUsageAtchRelId.length);
	}
	
	/**
	*	Add an relation to the list of selected relations
	*
	* 	@param atchRelId - attachment relation id
	*/
	function addElement(atchRelId) {

		for (i = 0; i < selectedAtchRelId.length; i++) {
			if (selectedAtchRelId[i] == atchRelId) {
				return;
			}
		}
		selectedAtchRelId[selectedAtchRelId.length] = atchRelId;
	}

	/**
	*	Remove an relation from the list of selected relations
	*
	* 	@param atchRelId - attachment relation id
	*/
	function removeElement(atchRelId) {
	
		var i = 0;
		var j = -1;
		
		for (i = 0; i < selectedAtchRelId.length; i++) {
			if (selectedAtchRelId[i] == atchRelId) {
				j = i;
				break;
			}
		}

		if (j != -1) {
			selectedAtchRelId.splice(j, 1); 
		}
	}
	
	/**
	*	Remove an relation from a list of selected default usage relations
	*
	* 	@param atchRelId - attachment relation id
	*/
	function removeNoUsageElement(atchRelId) {
	
		var i = 0;
		var j = -1;
		
		for (i = 0; i < selectedNoUsageAtchRelId.length; i++) {
			if (selectedNoUsageAtchRelId[i] == atchRelId) {
				j = i;
				break;
			}
		}

		if (j != -1) {
			selectedNoUsageAtchRelId.splice(j, 1); 
		}
	}

	/**
	*	Remove an relation to a list of selected default usage relations
	*
	* 	@param atchRelId - attachment relation id
	*/
	function addNoUsageElement(atchRelId) {
	
		for (i = 0; i < selectedNoUsageAtchRelId.length; i++) {
			if (selectedNoUsageAtchRelId[i] == atchRelId) {
				return;
			}
		}

		selectedNoUsageAtchRelId[selectedNoUsageAtchRelId.length] = atchRelId;
	}
	/**
	*	retun the selected usage type
	*/
	function getSelectedUsage() {
	
		for (var i = 0; i < usageNames.length; i++) {
			if (usageNames[i].checked) {
				return usageNames[i].value;
			}
		}
		
		return false;
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




</script>

</head>

<body class=content onload="onLoad();" onunload="onUnload();" oncontextmenu="return false;">

<%
			AttachmentRelationAccessBean abAttachmentRelation = null;
			AttachmentAssetAccessBean abAttachmentAsset = null;
			AttachmentAssetLanguageAccessBean abAttachmentAssetLanguage = null;
			AttachmentTargetAccessBean abAttachmentTarget = null;
			AttachmentRelationDescriptionAccessBean abAttachmentRelationDescription = null;
			languageDB = null;

			String atchTargetId = null;
			String atchRelId = null;
			String imagePath = null;
			String path = null;
			String atchAssetId = null;			
			String strLanguages = null;
			String checked = "";
			String usageId = "0";
			String langToken = UIUtil.toHTML((String) rbAttachment.get("Attachment_Language_Token"));
			String fileTitle = null;
			int atchRelCount = 0;

			Enumeration enAttachmentRelation = null;
			Enumeration enAttachmentAsset = null;
			Enumeration enAttachmentAssetLanguage = null;

			boolean languageIndependent = false;
			boolean nousage = false;
			Vector usage = null;
			Vector usages = AttachmentRelationUsageHelper.getAllAttachmentRelationUsages(cmdContext.getLanguageId());
			
		
			abAttachmentRelation = new AttachmentRelationAccessBean();
			
			// loop through all usages
			for (int i = 0; i < usages.size(); i++) {
						
				// extract the usage out
				nousage = false;
				usage = (Vector) usages.elementAt(i);
				usageId = usage.elementAt(0).toString();
				enAttachmentRelation = abAttachmentRelation.findByAttachmentObjectTypeIdentifierAndObjectIdAndRelationUsageIdentifier(objectType, objectId, (String) usage.elementAt(1));
				
				if (usageId.equals(ECAttachmentConstants.EC_ATCH_USAGE_DEFAULT_ID)) {
					checked = "checked";
				} else {
					checked = "";
				}
%>
		<script>usageCount[<%=i%>] = 0;</script>
		
		<span id=SPAN_TITLE_<%=i%> style="display=none;">

<% 			if (i != 0) { %>
		<br/>
<% 			}  // for %>

		<table class=attachmentUsageTitle style="width:98%">

			<tr class=attachmentUsageTitle>
				<td width=5><input <%=checked%> <%=disabledString%> id="<%=usageId%>" type=radio name=usageNames value="<%=usageId%>"></td>
				<td id=usage_<%=i%> align=left><label for="<%=usageId%>"><%=usage.elementAt(4)%></label> (</td>
				<td align=right><img id='SPANIMG_<%=i%>' onclick=openClose("<%=i%>") SRC='/wcs/images/tools/attachment/collapse.gif'>&nbsp;</td>
			</tr>
		</table>
		</span>

		<span id="SPAN_<%=i%>" style="display:none;">

					<table class=attachmentPreviewTable4 cellpadding=1 cellspacing=1 border=0 style="width:98%">
<%
					// show usage selection dropdown if this is a default usage span
					if (usageId.equals(ECAttachmentConstants.EC_ATCH_USAGE_DEFAULT_ID)) { 

							nousage = true;
%>
							<script>defaultUsageIdIndex = <%=i%>;</script>
							<tr>
								<td width=17px>&nbsp;</td>
								<td valign=center align=left><label for="assignUsageSelection"><%=UIUtil.toHTML((String) rbAttachment.get("Attachment_Usage"))%>:</label>
								<select <%=disabledString%> id="assignUsageSelection">
<%
									for (int j = 0; j < usages.size(); j++) {

										// extract the usage out
										Vector usage2 = (Vector) usages.elementAt(j);
										String usageId2 = usage2.elementAt(0).toString();
										if (usageId2.equals(ECAttachmentConstants.EC_ATCH_USAGE_DEFAULT_ID)) { 
%>
											<option selected value="<%=usage2.elementAt(0)%>"><%=UIUtil.toHTML((String)usage2.elementAt(4).toString())%>
<%
										} else {
%>
											<option value="<%=usage2.elementAt(0)%>"><%=UIUtil.toHTML((String)usage2.elementAt(4).toString())%>
<%
										}
									} // for
%>
								</select>
								&nbsp;
								<button id=btnAssignUsage onclick="assignUsage()"><%=UIUtil.toHTML((String) rbAttachment.get("Assign"))%></button>
							</td></tr>
<%					} // if %>
					</table>

<%

				// loop through all attachmetns belongs to this usage
				while (enAttachmentRelation.hasMoreElements()) {
				
					ATCHREL_DESCRIPTION_FOUND = true;
					atchRelCount++;

					abAttachmentRelation = (AttachmentRelationAccessBean) enAttachmentRelation.nextElement();
					atchTargetId = abAttachmentRelation.getAttachmentTargetId();
					atchRelId = abAttachmentRelation.getAttachmentRelationId();

					abAttachmentRelationDescription = new AttachmentRelationDescriptionAccessBean();
					
					try {
					
						abAttachmentRelationDescription = abAttachmentRelationDescription.findByAttachmentRelationIdAndLanguageId(abAttachmentRelation.getAttachmentRelationIdInEntityType(), storeDefLangId);
						
					} catch (javax.persistence.NoResultException e) {
						ATCHREL_DESCRIPTION_FOUND = false;						
					}  // for

					// attachment target
					abAttachmentTarget = new AttachmentTargetAccessBean();
					abAttachmentTarget.setInitKey_attachmentTargetId(new Long(atchTargetId));

%>
			<script>usageCount[<%=i%>]++;</script>

					<table class=attachmentPreviewTable<%=(atchRelCount%2)+1%> cellpadding=0 cellspacing=0 border=0 style="width:98%">
						<tr>
							<td rowspan=99 align=center bgcolor=#D3D4DB width=25>
                               <input <%=disabledString%> id="<%=abAttachmentRelation.getAttachmentRelationIdInEntityType() %>" type=checkbox onclick="checkBoxEvent(event, <%=nousage%>)"/>
								<input id=targetId_<%=abAttachmentRelation.getAttachmentRelationIdInEntityType()%> type=hidden value="<%=atchTargetId%>">
							</td>
						</tr>


					
<% 					if (ATCHREL_DESCRIPTION_FOUND) 
					{ %>
							<tr><td colspan=3 align=left style="word-break:break-all;width:100%;"><font size=1><b>&nbsp;<label for="<%=abAttachmentRelation.getAttachmentRelationIdInEntityType()%>"><%=UIUtil.toHTML((String) abAttachmentRelationDescription.getName())%></label><br/></b></font></td></tr>	
<%		}			else 
					{%>
							<tr><td colspan=3></br><label for="<%=abAttachmentRelation.getAttachmentRelationIdInEntityType() %>" class="hidden-label"><%=UIUtil.toHTML((String) rbAttachment.get("AttachmentList_Label_NoRelationshipName"))%></label></td></tr>
<%					}%>

<%
					imagePath = "";
					
					// attachment asset 
					abAttachmentAsset = new AttachmentAssetAccessBean();
					enAttachmentAsset = abAttachmentAsset.findByTargetId(new Long(atchTargetId));
					atchAssetId = null;
					languageIndependent = false;
					int atchAssetCount = 0;
					int numOfSupportedLanguages = 0;
					
					// loop through all files for different languages and gather information about it
					while (enAttachmentAsset.hasMoreElements()) {
						
						atchAssetCount++;
						abAttachmentAsset = (AttachmentAssetAccessBean) enAttachmentAsset.nextElement();
						atchAssetId = abAttachmentAsset.getAttachmentAssetId();
						numOfSupportedLanguages = 0;

						if (!SINGLELANGSTORE) {

							// attachment asset language
							abAttachmentAssetLanguage = new AttachmentAssetLanguageAccessBean();
							enAttachmentAssetLanguage = abAttachmentAssetLanguage.findByAssetId(new Long(atchAssetId));
							strLanguages = "";
	
							// loop through languages
							while (enAttachmentAssetLanguage.hasMoreElements()) {
							
								abAttachmentAssetLanguage = (AttachmentAssetLanguageAccessBean) enAttachmentAssetLanguage.nextElement();
								
								languageDB = new LanguageDescriptionDataBean();
								try {
									languageDB.setDataBeanKeyDescriptionLanguageId(abAttachmentAssetLanguage.getLanguageIdInEntityType().toString());
									languageDB.setDataBeanKeyLanguageId(((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLanguageId().toString());
								
									DataBeanManager.activate(languageDB, cmdContext);
								} catch (Exception ex) {
									languageDB.setDataBeanKeyDescriptionLanguageId(abAttachmentAssetLanguage.getLanguageIdInEntityType().toString());
									languageDB.setDataBeanKeyLanguageId(storeDefLangId.toString());
									
									DataBeanManager.activate(languageDB, cmdContext);
								}
								strLanguages += languageDB.getDescription() + langToken + " ";
								
								numOfSupportedLanguages++;
								
							} // while
							
							// this is a language independent file
							if (strLanguages.equals("")) {
							
								strLanguages = UIUtil.toHTML((String) rbAttachment.get("AttachmentList_String_LanguageIndependent"));
								languageIndependent = true;
								
							} // if
							
							// trim languages string
							if (!languageIndependent) {
							
								if (numOfSupportedLanguages == iLanguages.length) {
								
									strLanguages = UIUtil.toHTML((String) rbAttachment.get("Attachment_AllLanguages"));
									
								} else {
								
									strLanguages = strLanguages.trim();
									strLanguages = strLanguages.substring(0, strLanguages.length() - 1);
									
								} // if
							} // if
							
						}
						fileTitle = (String) rbAttachment.get("Attachment_Path");
						
						// display preview if it's an image
						if (isPreviewMimeType(abAttachmentAsset.getMimeType(), attachmentMimeTypes)) {
							
							imagePath = urlForPreview + "/" + myStorePath + "/" + abAttachmentAsset.getAttachmentAssetPath();
							path = urlForPreview + "/" + myStorePath + "/" + abAttachmentAsset.getAttachmentAssetPath();
							
						} else if (abAttachmentAsset.getMimeType() == null || abAttachmentAsset.getMimeType().length() == 0 ) {
						
							imagePath = "/wcs/images/tools/attachment/generic_file.jpg";
							path = abAttachmentAsset.getAttachmentAssetPath();
							if(path.indexOf("://") == -1){
								path = "http://" + path;
							}
							fileTitle = (String) rbAttachment.get("Attachment_URL");

						// display no preview available
						} else {
						
							imagePath = "/wcs/images/tools/attachment/generic_file.jpg";
							path = urlForPreview + "/" + myStorePath + "/" + abAttachmentAsset.getAttachmentAssetPath();
						}

%>
						<tr><td colspan=2>&nbsp;</td></tr>
						<tr>
							<td align=center width=15%>
								<input id=assetId_<%=atchTargetId%>_<%=atchAssetCount%> type=hidden value="<%=atchAssetId%>">
								<input id=lang_<%=atchTargetId%>_<%=atchAssetId%> type=hidden value="<%=languageIndependent%>">
								<a href="<%=path%>" onmouseover="toolTipOn('<%=UIUtil.toJavaScript((String)rbAttachment.get("Preview"))%>');" onmouseout="toolTipOff();" target="_blank"><img border=1 height=75 width=100 src="<%=imagePath%>"></a>
							</td>
							<td valign=top width=85%>
								<table cellpadding=1 cellspacing=1 border=0 style="width:100%">
								<tr>
									<td width=80 class=attachmentTargetTable align=left>
										<%=UIUtil.toHTML(fileTitle)%>:
									</td>
									<td class=attachmentTargetTableText align=left><a href="<%=path%>" onmouseover="toolTipOn('<%=UIUtil.toJavaScript((String)rbAttachment.get("Preview"))%>');" onmouseout="toolTipOff();" target="_blank"><%=abAttachmentAsset.getAttachmentAssetPath()%><a></td>
								</tr>
<%						if (abAttachmentAsset.getMimeType()!=null && abAttachmentAsset.getMimeType().length() != 0) { %>
								<tr>
									<td width=80 class=attachmentTargetTable align=left><%=UIUtil.toHTML((String) rbAttachment.get("Attachment_MimeType"))%>:</td>
									<td class=attachmentTargetTableText align=left><%=UIUtil.toHTML((String) abAttachmentAsset.getMimeType())%></td>
								</tr>
<%						} %>
<%						if (!SINGLELANGSTORE) { %>
								<tr>
									<td width=80 class=attachmentTargetTable align=left>
<%						if (readOnly.equals("true")) { %>
										<%=UIUtil.toHTML((String) rbAttachment.get("Language"))%>:
<%						} else { %>
										<a href="javascript:void(0);" onclick="popupLanguage('<%=atchAssetId%>', '<%=atchTargetId%>')" onmouseover="toolTipOn('<%=UIUtil.toJavaScript((String)rbAttachment.get("AttachmentList_String_SpecifyLanguage"))%>');" onmouseout="toolTipOff();">
										<%=UIUtil.toHTML((String) rbAttachment.get("Language"))%>:
										</a>
<%						} %>
									</td>
									<td class=attachmentTargetTableText align=left><%=UIUtil.toHTML((String) strLanguages)%></td>
								</tr>
<%						} // if %>
<%						if (readOnly.equals("false")) { %>
									<tr><td colspan=2 align=right><a href="javascript:void(0);" onclick="replace('<%=atchAssetId%>', '<%=atchTargetId%>')" ><font size=1><%=UIUtil.toHTML((String) rbAttachment.get("Attachment_Replace"))%></font></a></td></tr>
<%						} %>									
								</table>
							</td>
						</tr>
<%
					}
					
					if (!languageIndependent && !SINGLELANGSTORE && !readOnly.equals("true")) {
%>
						<tr><td colspan=2 align=right><a href="javascript:addLanguageFile('<%=atchTargetId%>');"><font size=1><%=UIUtil.toHTML((String) rbAttachment.get("AttachmentList_String_AddLanguageFile"))%>&nbsp;</font></a></td></tr>
<%
					} else {
%>
						<tr><td colspan=2>&nbsp;</td></tr>
<%
					}
%>
					</table>
					
<%
			}
%>
					
		<table class=attachmentPreviewTable3 cellpadding=0 cellspacing=0 border=0 style="width:98%;"><tr><td></td></tr></table>
		</span>

<%
		checked = "";
	}
%>
		<br/></br>

<script>
		document.writeln("<span id=noAttachmentText style='display:none;'><%=UIUtil.toJavaScript((String)rbAttachment.get("AttachmentList_String_No_Attachment"))%></span>");
</script>

		<iframe name="languageIframe"
		   MARGINHEIGHT=3 MARGINWIDTH=3 NORESIZE SCROLLING=NO FRAMEBORDER=NO
		   src="/wcs/tools/common/blank.html" 
		   style="border:1px solid gray;display:none;position:absolute;top:100;left:100;width:300;height:332;z-index=100;filter: progid:DXImageTransform.Microsoft.Shadow(color=#777777, Direction=135, Strength=4);">
		</iframe>
		
		<div id=tooltipDiv class=attachmentToolTipDiv></div>

<script>
		document.onmousemove = setMousePosition;
</script>

</body>
</html>


