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
////////////////////////////////////////////////////////////////////////////////
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" %>
<%@ page import="javax.persistence.NoResultException"%>
<%@ page import="com.ibm.commerce.command.CommandContext"%>
<%@ page import="com.ibm.commerce.tools.util.UIUtil"%>
<%@ page import="com.ibm.commerce.attachment.objects.*"%>
<%@ page import="com.ibm.commerce.attachment.content.resources.*"%>
<%@ page import="com.ibm.commerce.server.JSPHelper"%>
<%@ page import="com.ibm.commerce.beans.DataBeanManager"%>
<%@ page import="com.ibm.commerce.common.beans.LanguageDescriptionDataBean" %>
<%@ page import="com.ibm.commerce.user.helpers.UserJDBCHelperBean" %>
<%@ page import="com.ibm.commerce.context.globalization.GlobalizationContext" %>

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbAttachment = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("attachment.AttachmentNLS", ((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale());

	// get all available languages and put it into an array
	Integer [] iLanguages = cmdContext.getStore().getSupportedLanguageIds();
	Integer storeDefLangId = cmdContext.getStore().getLanguageIdInEntityType();

	JSPHelper jspHelper		= new JSPHelper(request);
	String atchTargetId		= jspHelper.getParameter("atchTargetId");
	String atchAssetId		= jspHelper.getParameter("atchAssetId");
	String atchAssetLang	= jspHelper.getParameter("atchAssetLang");
	String saveChanges	= jspHelper.getParameter("saveChanges");
	String atchAssetIdTemp	= null;

	Vector vLanguages = new Vector();

	for (int i=0; i<iLanguages.length; i++)	{
	
		if (iLanguages[i].intValue() == storeDefLangId.intValue()) {
		
			iLanguages[i] = iLanguages[0];
			iLanguages[0] = storeDefLangId;
			
		} // if
	} // for
%>

<html>
<head>

	<title><%=UIUtil.toHTML((String)rbAttachment.get("AttachmentPopup_Title"))%></title>
	<link rel=stylesheet href="<%=UIUtil.getCSSFile(((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale())%>" type="text/css" />
	
	<script>

	var aLanguages = new Array();
	var hLanguages = new Array();
	var atchastId = '<%=atchAssetId%>';
	var atchtgtId = '<%=atchTargetId%>';
	var pageUpdated = false;
<%
	LanguageDescriptionDataBean bnLanguage = null;

	for (int i = 0; i < iLanguages.length; i++) {
	
		bnLanguage = new LanguageDescriptionDataBean();
		try {
			bnLanguage.setDataBeanKeyDescriptionLanguageId(iLanguages[i].toString());
			bnLanguage.setDataBeanKeyLanguageId(((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLanguageId().toString());
		
			DataBeanManager.activate(bnLanguage, cmdContext);
		} catch (Exception ex) {
			bnLanguage.setDataBeanKeyDescriptionLanguageId(iLanguages[i].toString());
			bnLanguage.setDataBeanKeyLanguageId(storeDefLangId.toString());
			
			DataBeanManager.activate(bnLanguage, cmdContext);		
		}
		vLanguages.addElement(bnLanguage.getDescription());
		
	} // for
%>

	/**
	*	startup function
	*/
	function onLoad() {
	
<%	if (saveChanges.equals("false")) { %>
		
		loadSelectedLanguages();
<%	} else {%>

		if (getSelectedLanguages().length == 0) {
			allLang.checked = true;
			checkAll();
		}
<%	} %>
		return;
	}

	/**
	*	load selected languages from parent
	*/
	function loadSelectedLanguages() 
	{
		for (var i = 0; i < aLanguages.length; i++) {
			eval("lang_" + i + ".disabled=false;");
			eval("lang_" + i + ".readonly=false;");
			eval("lang_" + i + "_label.style.color='';");
			if (aLanguages[i].checked) {
				eval("lang_" + i + ".checked = true;");
			} else {
				eval("lang_" + i + ".checked = false;");
			}
		}

		var existingLanguages = parent.parent.getExistingLanguages();
		for (var i=0; i<existingLanguages.length; i++)
		{
			for (var j=0; j<aLanguages.length; j++)
			{
				if (aLanguages[j].id == existingLanguages[i])
				{
					eval("lang_" + j + ".disabled=true;");
					eval("lang_" + j + ".readonly=true;");
					eval("lang_" + j + "_label.style.color='#DFDFDF';");
				}
			}
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

	/**
	*	set the language checkboxes based on an array
	**/
	function setSelectedLanguages(selectedLanguages) 
	{
		for (var i = 0; i < aLanguages.length; i++) 
		{
			aLanguages[i].checked = false;
			for (var j=0; j<selectedLanguages.length; j++)
			{
				if (selectedLanguages[j] == aLanguages[i].id)
				{
					aLanguages[i].checked = true;
				}
			}
		}
		loadSelectedLanguages();
	}
	
	/**
	*	set the language checkboxes based on an array
	**/
	function hasAtLeastOneLanguageChecked() 
	{
		return (getSelectedLanguages().length > 0);
	}

	/**
	*	return an array of languages that stores the state of the languages checkbox
	**/
	function getSelectedLanguages() {
	
		var selectedLanguages = new Array();
		
		for (var i = 0; i < aLanguages.length; i++) {
		
			if (aLanguages[i].checked) {
				selectedLanguages[selectedLanguages.length] = aLanguages[i].id;
			}
		}
		
		return selectedLanguages;
	}
	
	/**
	*	check and uncheck all languages
	**/
	function checkAll() {

		var readonly = true;

		for (var i = 0; i < aLanguages.length; i++) {
			eval("readonly = lang_" + i + ".readonly;");
			if (!readonly) {
				eval("lang_" + i + ".checked = allLang.checked;");
				eval("lang_" + i + ".disabled = allLang.checked;");
				aLanguages[i].checked = allLang.checked;
			}
		}

		return;
	}
	
	/**
	*	a language is being check or uncheck
	*
	*	@param obj - caller
	**/
	function onClick(obj) {

		eval("aLanguages[" + obj.name + "].checked = obj.checked;");
		return;
	}
	
	/**
	*	return true if the langId are already selected by other asset, false otherwise
	*
	*	@param langId - language id
	**/
	function checkLanguage(langId) {
	
		for (var i = 0; i < parent.parent.selectedAssetLanguages.length; i++) {
			if (langId == parent.parent.selectedAssetLanguages[i]) return true;
		}
		
		return false;
	}
	


	</script>
	
</head>

<body class=content onload="onLoad();" oncontextmenu="return false;">

	<table border=0 cellspacing=0 cellpadding=0>

		<table>
		<tr valign=top><td><input type="checkbox" onchange="setPageUpdate(true);" onclick="checkAll(this)" id="allLang" name="allLang" />&nbsp;
		<label for="allLang"><%=UIUtil.toHTML((String)rbAttachment.get("Attachment_AllLanguages"))%></label>
		</td></tr>

<%
	// load language data from server
	if (saveChanges.equals("true")) {

		AttachmentAssetLanguageAccessBean abAttachmentAssetLanguage = null;
		AttachmentAssetAccessBean abAttachmentAsset = null;
		Enumeration enAttachmentAsset = null;
		Enumeration enAttachmentAssetLanguage = null;
		String checked = null;
		String langId = null;
		
		abAttachmentAsset = new AttachmentAssetAccessBean();
		abAttachmentAsset.setInitKey_attachmentAssetId(new Long(atchAssetId));
	
		if (atchAssetLang.equals("false")) {
	
			for (int i = 0; i < iLanguages.length; i++) { 
	
				// attachment asset language
				abAttachmentAssetLanguage = new AttachmentAssetLanguageAccessBean();
				
				try {
					abAttachmentAssetLanguage = abAttachmentAssetLanguage.findByAssetIdAndLanguageId(new Long(atchAssetId), iLanguages[i]);
					checked = "checked";
				} catch (javax.persistence.NoResultException e) {
					checked = "";
				} 
			
%>
		<tr valign=top><td><input <%=checked%> onchange="setPageUpdate(true);" onclick="onClick(this)" type="checkbox" id="lang_<%=i%>" name="<%=i%>" />&nbsp;
		<label id="lang_<%=i%>_label" for="lang_<%=i%>"><%=UIUtil.toHTML((String)vLanguages.elementAt(i))%></label>
		<script>
			hLanguages["<%=iLanguages[i]%>"] = <%=i%>;
			aLanguages[<%=i%>] = new Object();
			aLanguages[<%=i%>].id = "<%=iLanguages[i]%>";
			
<%				if (checked.equals("")) { %>

			aLanguages[<%=i%>].checked = false;
			
<%				} else { %>

			aLanguages[<%=i%>].checked = true;
			
<%				} %>

		</script>
		</td></tr>
<%
				} 
%>
				</table>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		
	</table>
	<script>
		var fontStyle = "";
<%
		abAttachmentAsset = new AttachmentAssetAccessBean();
		enAttachmentAsset = abAttachmentAsset.findByTargetId(new Long(atchTargetId));
	
		// loop through other assets and determine which languages checkbox should be disabled
		while (enAttachmentAsset.hasMoreElements()) {
			
			abAttachmentAsset = (AttachmentAssetAccessBean) enAttachmentAsset.nextElement();
			atchAssetIdTemp = abAttachmentAsset.getAttachmentAssetId();
	
			if (!atchAssetIdTemp.equals(atchAssetId)) {
	
				// attachment asset language
				abAttachmentAssetLanguage = new AttachmentAssetLanguageAccessBean();
				enAttachmentAssetLanguage = abAttachmentAssetLanguage.findByAssetId(new Long(atchAssetIdTemp));
				
				// loop through languages and disabled the ones that are used by other asset within the same target
				while (enAttachmentAssetLanguage.hasMoreElements()) {
				
					abAttachmentAssetLanguage = (AttachmentAssetLanguageAccessBean) enAttachmentAssetLanguage.nextElement();
					langId = abAttachmentAssetLanguage.getLanguageIdInEntityType().toString();
%>
				eval("lang_" + hLanguages["<%=langId%>"] + ".disabled = true;");
				eval("lang_" + hLanguages["<%=langId%>"] + ".readonly = true;");
				eval("fontStyle = '<font color=#DFDFDF>' + " + "lang_" + hLanguages["<%=langId%>"] + "_label.innerHTML + '</font>';");
				eval("lang_" + hLanguages["<%=langId%>"] + "_label.innerHTML = fontStyle;");
<%
			} // while
		} // if
	} // while
%>
	</script>
<%
		} else {
	
			for (int i = 0; i < iLanguages.length; i++) { 
%>
		<tr valign=top><td><input type="checkbox" onclick="onClick(this)" id="lang_<%=i%>" name="<%=i%>" />&nbsp;
		<label id="lang_<%=i%>_label" for="lang_<%=i%>"><%=UIUtil.toHTML((String) vLanguages.elementAt(i))%></label>
		</td></tr>
		<script>
		
			hLanguages["<%=iLanguages[i]%>"] = <%=i%>;
			aLanguages[<%=i%>] = new Object();
			aLanguages[<%=i%>].id = "<%=iLanguages[i]%>";
			aLanguages[<%=i%>].checked = false;
			
		</script>
<%			} // for %>
				</table>
			</td>
		</tr>
		
	</table>
<%
		} // if
	
	// load languages data from previous page
	} else {

		for (int i = 0; i < iLanguages.length; i++) { 
%>
		<tr valign=top><td><input type="checkbox" onclick="onClick(this)" id="lang_<%=i%>" name="<%=i%>" />&nbsp;
		<label id="lang_<%=i%>_label" for="lang_<%=i%>"><%=UIUtil.toHTML((String)vLanguages.elementAt(i))%></label>
		</td></tr>
		<script>
		
			hLanguages["<%=iLanguages[i]%>"] = new Object();
			hLanguages["<%=iLanguages[i]%>"] = <%=i%>;
			aLanguages[<%=i%>] = new Object();
			aLanguages[<%=i%>].id = "<%=iLanguages[i]%>";
			aLanguages[<%=i%>].checked = checkLanguage("<%=iLanguages[i]%>");
			
		</script>
<%		} // for %>
				</table>
			</td>
		</tr>
	</table>
<%
	} // if
%>
</body>

</html>
