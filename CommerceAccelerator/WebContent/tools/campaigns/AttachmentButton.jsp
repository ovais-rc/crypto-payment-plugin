<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2004, 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ page import="com.ibm.commerce.tools.campaigns.CampaignConstants" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.*" %>
<%@ page import="com.ibm.commerce.attachment.common.ECAttachmentConstants" %>

<%@ include file="common.jsp" %>

<%String resultCollateralId = "";
String resultCollateralName = "";

com.ibm.commerce.server.JSPHelper jspHelper =
	new com.ibm.commerce.server.JSPHelper(request);
CommandContext commandContext =
	(CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale locale =
	(commandContext == null ? Locale.getDefault() : commandContext.getLocale());

ResourceBundleProperties globalNLS =
	(ResourceBundleProperties) ResourceDirectory.lookup(
		"campaigns.campaignsRB",
		locale);
ResourceBundleProperties rbAttachment =
	(ResourceBundleProperties) ResourceDirectory.lookup(
		"attachment.AttachmentNLS",
		locale);

if (jspHelper.getParameter(CampaignConstants.ELEMENT_COLLATERAL_ID) != null) {
	resultCollateralId =
		jspHelper.getParameter(CampaignConstants.ELEMENT_COLLATERAL_ID);
}

if (jspHelper.getParameter(CampaignConstants.ELEMENT_COLLATERAL_NAME)
	!= null) {
	resultCollateralName =
		jspHelper.getParameter(CampaignConstants.ELEMENT_COLLATERAL_NAME);
}




%>

<script language="JavaScript">
<!-- hide script from old browsers

		
	//////////////////////////////////////////////////////////////////////////////////////
	// Create attachment buttons
	//////////////////////////////////////////////////////////////////////////////////////		
	document.writeln('<td class="ud">');
    	document.writeln('<input type="button" class="button" id="browseButton" name="browseButton" value="<%=globalNLS.getJSProperty("browseEllipsis", "")%>" onClick="browseBtn();"></button>');
	document.writeln('</td>');

	document.writeln('<td class="ud">');
		document.writeln('<input type="button" class="button" id="removeButton" name="removeButton" value="<%=globalNLS.getJSProperty("remove", "")%>" onClick="removeBtn();"></button>');	
		document.writeln('<input type="button" class="button" id="replaceButton" name="replaceButton" value="<%=globalNLS.getJSProperty("replaceEllipsis", "")%>" onClick="replaceBtn();"></button>');			
		document.writeln('<input type="button" class="button" id="modifyButton" name="modifyButton" value="<%=globalNLS.getJSProperty("modifyEllipsis", "")%>" onClick="modifyBtn();"></button>');					
	document.writeln('</td>');

	if(top.getData("<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS%>", null)!=null){
		saveData("locations", constructLocationString(top.getData("<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS%>", null)));
	}

	if(top.getData("globalLocations", null)==""){
		saveData("locations", "");
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Check which attachment buttons must be displayed and display appropriate buttons
	//////////////////////////////////////////////////////////////////////////////////////	
	if ((constructLocationString(top.getData("<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS%>", null))=="") && 
		(getData("locations", "<%=UIUtil.toJavaScript(request.getAttribute(CampaignConstants.REQ_ATTRIBUTE_COLL_FILE_PATH))%>")  == "")) {
			document.collateralForm.modifyButton.style.display = "none";
			document.collateralForm.replaceButton.style.display = "none";
			document.collateralForm.removeButton.style.display = "none";
			document.collateralForm.browseButton.style.display = "inline";		
		}
	else {
			document.collateralForm.browseButton.style.display = "none";
			document.collateralForm.modifyButton.style.display = "inline";
			document.collateralForm.replaceButton.style.display = "inline";
			document.collateralForm.removeButton.style.display = "inline";	
			top.put(document.collateralForm.locations.value, "globalLocations");	
		}

	//////////////////////////////////////////////////////////////////////////////////////
	// Click action for remove button
	//////////////////////////////////////////////////////////////////////////////////////	
	function removeBtn(){
		document.collateralForm.modifyButton.style.display = "none";
		document.collateralForm.replaceButton.value = "<%=globalNLS.getJSProperty("browseEllipsis", "")%>";
		top.saveData(null, "<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS%>")	;
		top.saveData("", "globalLocations");
		document.collateralForm.locations.value ="";
		top.saveData("true", "<%=CampaignConstants.ELEMENT_ATCH_REL_DELETED%>");	
		document.collateralForm.removeButton.style.display = "none";
		saveData("targetId","");
		
	}	

	//////////////////////////////////////////////////////////////////////////////////////
	// Click action for browse button
	//////////////////////////////////////////////////////////////////////////////////////	
	function browseBtn(){
		browseCommon("browse");
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// Click action for replace button
	//////////////////////////////////////////////////////////////////////////////////////	
	function replaceBtn(){
		removeBtn();
		browseCommon("browse");
	}	

	//////////////////////////////////////////////////////////////////////////////////////
	// Common click action for borwse and replace
	// @param type Type of action 'browse' or 'replace'
	//////////////////////////////////////////////////////////////////////////////////////	
	function browseCommon(type){
		saveData("collateralName", document.collateralForm.collateralName.value);	
		saveData("collateralType", document.collateralForm.collateralType.value);
		saveData("locations", document.collateralForm.locations.value);
		saveData("url",document.collateralForm.url.value);
		saveData("urlType",document.collateralForm.urlType.value);
		saveData("urlCommand",document.collateralForm.urlCommand.value);
		saveData("urlCustom",document.collateralForm.urlCustom.value);
		saveData("urlCommandType",document.collateralForm.urlCommandType.value);
		saveData("marketingText",document.collateralForm.marketingText.value);			
		saveData("staticText",document.collateralForm.staticText.value);	
		if(document.collateralForm.urlCommandType.value == "<%= CampaignConstants.URL_PRODUCT_DISPLAY %>"){
			saveData("urlCommandParameter",document.collateralForm.urlCommandProduct.value);
		}
		if(document.collateralForm.urlCommandType.value == "<%= CampaignConstants.URL_ACCEPT_COUPON %>"){
			saveData("urlCommandParameter",document.collateralForm.urlCommandCoupon.value);
		}
		if((document.collateralForm.urlCommandType.value == "<%= CampaignConstants.URL_ORDER_ITEM_ADD %>") ||
		(document.collateralForm.urlCommandType.value =="<%= CampaignConstants.URL_INTEREST_ITEM_ADD %>") || 
		(document.collateralForm.urlCommandType.value =="<%= CampaignConstants.URL_ADD_ITEM_WITH_PROMOTION %>")){
				saveData("urlCommandParameter",document.collateralForm.urlCommandItem.value);
		}
		if(document.collateralForm.urlCommandType.value == "<%= CampaignConstants.URL_CATEGORY_DISPLAY %>"){
			saveData("urlCommandParameter",document.collateralForm.urlCommandCategory.value);
		}
				
		top.saveData("true", "newAttachment");
	
		var url=top.getWebPath()+ "PickAttachmentAssetsTool";
		var urlPara = new Object();
		
		if(type=="browse"){
			urlPara.objectId="*";
		} 
	
		if(type=="replace"){
			urlPara.objectId="<%=resultCollateralId%>";		
		}

		urlPara.objectType="<%=ECAttachmentConstants.EC_ATCH_OBJECT_TYPE_COLLATERAL%>";
		urlPara.usageId="0";
		urlPara.saveChanges=false;
		urlPara.selectMultiple = "false";	
		top.setContent("<%=UIUtil.toJavaScript(
		(String) rbAttachment.get("Attachment_Assets_Browser_Title"))%>",url,true,urlPara);
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////
	// Click action for modify button
	//////////////////////////////////////////////////////////////////////////////////////		
	function modifyBtn(){
		saveData("collateralName", document.collateralForm.collateralName.value);	
		saveData("collateralType", document.collateralForm.collateralType.value);
		saveData("locations", document.collateralForm.locations.value);
		saveData("url",document.collateralForm.url.value);
		saveData("urlType",document.collateralForm.urlType.value);
		saveData("urlCommand",document.collateralForm.urlCommand.value);
		saveData("urlCustom",document.collateralForm.urlCustom.value);
		saveData("urlCommandType",document.collateralForm.urlCommandType.value);
		saveData("marketingText",document.collateralForm.marketingText.value);			
		saveData("staticText",document.collateralForm.staticText.value);		
		if(document.collateralForm.urlCommandType.value == "<%= CampaignConstants.URL_PRODUCT_DISPLAY %>"){
			saveData("urlCommandParameter",document.collateralForm.urlCommandProduct.value);
		}
		if(document.collateralForm.urlCommandType.value == "<%= CampaignConstants.URL_ACCEPT_COUPON %>"){
			saveData("urlCommandParameter",document.collateralForm.urlCommandCoupon.value);
		}
		if((document.collateralForm.urlCommandType.value == "<%= CampaignConstants.URL_ORDER_ITEM_ADD %>") ||
		(document.collateralForm.urlCommandType.value =="<%= CampaignConstants.URL_INTEREST_ITEM_ADD %>") || 
		(document.collateralForm.urlCommandType.value =="<%= CampaignConstants.URL_ADD_ITEM_WITH_PROMOTION %>")){
			saveData("urlCommandParameter",document.collateralForm.urlCommandItem.value);
		}
		if(document.collateralForm.urlCommandType.value == "<%= CampaignConstants.URL_CATEGORY_DISPLAY %>"){
			saveData("urlCommandParameter",document.collateralForm.urlCommandCategory.value);
		}

		top.saveData("true", "newAttachment");
	
		var url=top.getWebPath()+ "AttachmentUpdateDialogView";
		var urlPara = new Object();
		var targetId = getData("targetId", "");
		if (targetId==""){

			////////////////////////////////////////////////////////////////////////////////
			//Added By Bosco
			////////////////////////////////////////////////////////////////////////////////
			var selectedAttachmentFileSet = top.getData("<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS%>", null);
			if (selectedAttachmentFileSet != null) {
				if ((isArray(selectedAttachmentFileSet)) && (selectedAttachmentFileSet.length > 0)) {
					urlPara.sentBack="true";
					if (typeof(selectedAttachmentFileSet[0].remove) != "undefined") {
						top.put("<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_SAVED_ASSETS%>", selectedAttachmentFileSet);
					} else {
						top.put("<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS%>", selectedAttachmentFileSet);
					}
				}
			}
			/////////////////////////////////////////////////////////////////////////
			//Relies on the assumption that AttachmentAssets and selectedFileSet both 
			//have same target id variable. And there can be only one target id.
			/////////////////////////////////////////////////////////////////////////
			if(selectedAttachmentFileSet[0].atchtgtId==null || selectedAttachmentFileSet[0].atchtgtId=="null"){
				urlPara.atchTargetId="";
			} else{
				if (checkUpdate(selectedAttachmentFileSet)){
					urlPara.sentBack = "true";
				}
				else{ 
					urlPara.atchTargetId = selectedAttachmentFileSet[0].atchtgtId;
				}
			}
			////////////////////////////////////////////////////////////////////////////////
		} else {
			var selectedAttachmentFileSet = top.getData("<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS%>", null);
			if (selectedAttachmentFileSet != null) {
				if ((isArray(selectedAttachmentFileSet)) && (selectedAttachmentFileSet.length > 0)) {
					if (typeof(selectedAttachmentFileSet[0].remove) != "undefined") {
						if (checkUpdate(selectedAttachmentFileSet)){
							urlPara.sentBack="true";
						}
						top.put("<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_SAVED_ASSETS%>", selectedAttachmentFileSet);
					} else {
						top.put("<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS%>", selectedAttachmentFileSet);
					}
				}
			}
			urlPara.atchTargetId = targetId;
		}

		urlPara.objectType="<%=ECAttachmentConstants.EC_ATCH_OBJECT_TYPE_COLLATERAL%>";
		urlPara.tool = "asset";
		urlPara.saveChanges="false";
		top.setContent("<%=UIUtil.toJavaScript(
		(String) rbAttachment.get("AttachmentSpecifyLanguages_Title"))%>",url,true,urlPara);
	}	


//////////////////////////////////////////////////////////////////////////////////////////
//Get first target id in the object. Relies on the assumption that all the target Id in 
//the object are same.
//@param File asset array
//@return The first asset id
//////////////////////////////////////////////////////////////////////////////////////////
function checkUpdate(assets){	
		var isUpdate=false;
		if(assets!=null){
			for(var i=0; i<assets.length; i++){
				if(assets[i].remove==true){
					continue;
				} else{		
					if (typeof(assets[i].action) != "undefined") {						
				 		if(assets[i].action != null){
							if(assets[i].action=="update"){
								isUpdate = true
								break;
							}
						}
					}
				}
			}
		return isUpdate;
	}
}
//-->
</script>