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

  (C) Copyright IBM Corp. 2002, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page language="java" 
	  import="	com.ibm.commerce.beans.DataBeanManager,
			com.ibm.commerce.tools.util.*,
			com.ibm.commerce.tools.common.ui.taglibs.*,
			com.ibm.commerce.tools.common.ui.taglibs.*,
			com.ibm.commerce.pa.tools.guidedsell.utils.GuidedSellUIConstants,
			com.ibm.commerce.pa.tools.guidedsell.beans.GuidedSellLinkLoaderBean,
			com.ibm.commerce.pa.tools.guidedsell.containers.GuidedSellLinkData,
			java.util.Vector" %>

<%@include file="/tools/guidedsell/GuidedSellCommon.jsp" %>

<%
	String categoryId = UIUtil.toHTML(request.getParameter(GuidedSellUIConstants.GS_CATEGORY_ID));
	String metaphorId = UIUtil.toHTML(request.getParameter(GuidedSellUIConstants.GS_METAPHOR_ID));
	String gsLanguageId = UIUtil.toHTML(request.getParameter(GuidedSellUIConstants.GS_LANGUAGE_ID));
	String treeId = UIUtil.toHTML(request.getParameter(GuidedSellUIConstants.GS_TREE_ID));
	String conceptId = UIUtil.toHTML(request.getParameter(GuidedSellUIConstants.GS_CONCEPT_ID));
	String fromPage = UIUtil.toHTML(request.getParameter(GuidedSellUIConstants.GSMLL_FROM_PAGE));
	String forChange = UIUtil.toHTML(request.getParameter(GuidedSellUIConstants.GSMLL_FOR_CHANGE));
	String metaphorLinkName = "";

	if(forChange == null || forChange.trim().length() == 0){
		forChange = "false";
	}
	
	if(fromPage.equals(GuidedSellUIConstants.GSMLL_FROM_NEW_CHANGE_CATEGORY)) {
		metaphorLinkName = GuidedSellUIConstants.PRODUCT_COMPARER_METAPHOR_CLASSNAME;
	}

	if(fromPage.equals(GuidedSellUIConstants.GSMLL_FROM_NEW_CHANGE_ANSWER) && forChange.equals("false")) {
		metaphorLinkName = GuidedSellUIConstants.QUESTION_CLASSNAME;
	} 
	if(fromPage.equals(GuidedSellUIConstants.GSMLL_FROM_NEW_CHANGE_ANSWER) && forChange.equals("true")) {
		metaphorLinkName = GuidedSellUIConstants.GSMLL_NO_LINK;
	}

	GuidedSellLinkData data = null;
	if(forChange.trim().equals("true")){
		GuidedSellLinkLoaderBean loader = new GuidedSellLinkLoaderBean();
		DataBeanManager.activate(loader,request);
		data = loader.getOldLinkData();
		if(loader.getLinkName() != null) {
			metaphorLinkName = loader.getLinkName();
		}
	}

	String urlSelectPrefix = "/webapp/wcs/tools/servlet/GSLinkSelectView";
	urlSelectPrefix = urlSelectPrefix+"?categoryId="+categoryId;
	urlSelectPrefix = urlSelectPrefix+"&metaphorId="+metaphorId;
	urlSelectPrefix = urlSelectPrefix+"&treeId="+treeId;
	urlSelectPrefix = urlSelectPrefix+"&"+GuidedSellUIConstants.GSMLL_FROM_PAGE+"="+fromPage;
	urlSelectPrefix = urlSelectPrefix+"&"+GuidedSellUIConstants.GSMLL_FOR_CHANGE+"="+forChange;
	String urlSelect = urlSelectPrefix + "&"+GuidedSellUIConstants.GSMLL_METAPHOR_LINK_NAME+"="+metaphorLinkName;

	String urlListPrefix = "/webapp/wcs/tools/servlet/GSLinkListView";
	urlListPrefix = urlListPrefix+"?categoryId="+categoryId;
	urlListPrefix = urlListPrefix+"&metaphorId="+metaphorId;
	urlListPrefix = urlListPrefix+"&treeId="+treeId;
	urlListPrefix = urlListPrefix+"&"+GuidedSellUIConstants.GSMLL_FROM_PAGE+"="+fromPage;
	urlListPrefix = urlListPrefix+"&"+GuidedSellUIConstants.GSMLL_FOR_CHANGE+"="+forChange;
	String urlList = urlListPrefix + "&"+GuidedSellUIConstants.GSMLL_METAPHOR_LINK_NAME+"="+metaphorLinkName;
%>

<HTML>
<HEAD>
<%= fHeader %>
<TITLE><%=guidedSellRB.get(GuidedSellUIConstants.GSMLL_NAME)%></TITLE>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/ConvertToXML.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/guidedsell/gscommon.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/guidedsell/gslinkdialogfns.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">
<!--
function visibleList(s){
   if (this.linkTypeSelect.visibleList){
      this.linkTypeSelect.visibleList(s);
   }
   if (this.gsframe.visibleList){
      this.gsframe.visibleList(s);
   }
}

function getUserNLSTitle(){	
<%
	if(forChange.trim().equals("true")){
		if(fromPage.equals(GuidedSellUIConstants.GSMLL_FROM_NEW_CHANGE_ANSWER)){
%>
		return "<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSMLL_CHANGE_NAME)%>";
<%
		} else {
%>
		return "<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSL_CHANGE_GUIDED_SELL)%>";
<%
		}
	} else {
%>	
	return "<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSMLL_NAME)%>";
<%
	}
%>
}

function getLinkSelectText(){
<%
	if(fromPage.equals(GuidedSellUIConstants.GSMLL_FROM_NEW_CHANGE_CATEGORY) && forChange.trim().equals("true")){
%>
	return "<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSMLL_CHANGE_LINK_TO_TEXT)%>";
<%
	} else {
%>
	return "<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSMLL_LINK_TO_TEXT)%>";
<%
	}
%>
}

function loadPanelData(){
<%
	if(forChange.trim().equals("true") && !fromPage.equals(GuidedSellUIConstants.GSMLL_FROM_NEW_CHANGE_ANSWER)) {
%>
	parent.pageArray["gsmllName"].helpKey = "MC.guidedsell.gschange.Help";

<%
	}
%>
<%
	if(forChange.trim().equals("false") && fromPage.equals(GuidedSellUIConstants.GSMLL_FROM_NEW_CHANGE_ANSWER)){
%>
	parent.pageArray["gsmllName"].helpKey = "MC.guidedsell.gsnewlink.Help";
<%
	}
%>
	gsModifyBCT(<%=(gsLanguageId == null ? null : UIUtil.toJavaScript(gsLanguageId))%>);
	parent.setContentFrameLoaded(true);
}

function unloadPanelData(){
	setChecked(null);
	setObjectArray(null);
}
<%
	if((forChange != null && forChange.trim().length() != 0 && forChange.trim().equals("true") && fromPage.trim().equals(GuidedSellUIConstants.GSMLL_FROM_NEW_CHANGE_ANSWER)) || 
		(fromPage.trim().equals(GuidedSellUIConstants.GSMLL_FROM_NEW_CHANGE_CATEGORY))) {
%>
function getChangedLinkData(){
	<%=UIUtil.toJS("changedLinkData",new GuidedSellLinkData())%>
	return changedLinkData;
}
<%
}
%>
<%
	if(forChange.trim().equals("true") && data != null){
%>
function getOldLinkData(){
	<%=UIUtil.toJS("oldLinkData",data)%>
	return oldLinkData;
}
<%
	}
%>

function savePanelData(){
	var checked = getChecked();
	var length = size(checked);
	var name = gsframe.getLinkName();
	if(name != '<%=GuidedSellUIConstants.GSMLL_URL%>' && name != '<%=GuidedSellUIConstants.GSMLL_NO_LINK%>' && name != '<%=GuidedSellUIConstants.GSMLL_PRODUCT_PAGE%>' && (length == 0 || length > 1)){
		return;
	}
	var xml = '<LINKDATA>\n';
	xml = xml + getDefaultXMLData('<%=UIUtil.toJavaScript(categoryId)%>','<%=UIUtil.toJavaScript(metaphorId)%>','<%=UIUtil.toJavaScript(gsLanguageId)%>','<%=UIUtil.toJavaScript(treeId)%>','<%=UIUtil.toJavaScript(conceptId)%>','<%=UIUtil.toJavaScript(fromPage)%>','<%=UIUtil.toJavaScript(forChange)%>');

	<%
		if(forChange != null && forChange.trim().length() != 0 && forChange.trim().equals("true")) {
	%>
			if(this.getOldLinkData){
				xml = xml + generateXML(getOldLinkData(),'oldLink',null);
			} 
	<%
		}
	%>

	if(name == '<%=GuidedSellUIConstants.QUESTION_CLASSNAME%>'){
		xml = xml + getQuestionXMLData(name,checked);
	} else if(name == '<%=GuidedSellUIConstants.PRODUCT_EXPLORER_METAPHOR_CLASSNAME%>' || 
			name == '<%=GuidedSellUIConstants.PRODUCT_COMPARER_METAPHOR_CLASSNAME%>' || 
			name == '<%=GuidedSellUIConstants.SALES_ASSISTANT_METAPHOR_CLASSNAME%>') {
		xml = xml + getMetaphorXMLData(name,checked);
	} else if(name == '<%=GuidedSellUIConstants.GSMLL_URL%>'){
		xml = xml + getURLXMLData(name);
	} else if(name == '<%=GuidedSellUIConstants.GSMLL_NO_LINK%>'){
		xml = xml + getNoLinkData(name);
	} else if(name == '<%=GuidedSellUIConstants.GSMLL_PRODUCT_PAGE%>'){
		xml = xml + getProductXMLData(name);
	}
	xml = xml + '</LINKDATA>\n';
<%
	if(fromPage != null && fromPage.trim().length() != 0 && fromPage.equals(GuidedSellUIConstants.GSMLL_FROM_NEW_CHANGE_ANSWER)){
%>
	top.put("fromRemove","true");	
<%
	}
%>
	parent.put("EC_XMLFileObject", xml);
	parent.put("linkVisited","true");
}

function validateNoteBookPanel(){
	return validatePanelData();
}

function validatePanelData(){
	var checked = getChecked();
	var length = size(checked);
	var name = gsframe.getLinkName();
	if(name != '<%=GuidedSellUIConstants.GSMLL_URL%>' && length == 0 && name != '<%=GuidedSellUIConstants.GSMLL_NO_LINK%>' && name != '<%=GuidedSellUIConstants.GSMLL_PRODUCT_PAGE%>'){
		alertDialog("<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSMLL_LINK_NOT_SELECTED_MSG)%>");
		return false;
	}
	
	if(name == '<%=GuidedSellUIConstants.GSMLL_URL%>' && (rtrim(ltrim(gsframe.linkListForm.urlName.value))).length == 0) { 
		alertDialog("<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSMLL_LINK_NO_URL_MSG)%>");
		return false;
	}
	
	if(name == '<%=GuidedSellUIConstants.GSMLL_PRODUCT_PAGE%>' && (rtrim(ltrim(gsframe.linkListForm.urlName.value))).length == 0) {
		alertDialog("<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSMLL_LINK_NO_URL_MSG)%>");
		return false;
	}
	
	if(name == '<%=GuidedSellUIConstants.GSMLL_PRODUCT_PAGE%>' && (rtrim(ltrim(gsframe.linkListForm.productSKU.value))).length == 0) {
		alertDialog("<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSMLL_LINK_NO_SKU_MSG)%>");
		return false;
	}

	if(length > 1 && name != '<%=GuidedSellUIConstants.GSMLL_URL%>' && name != '<%=GuidedSellUIConstants.GSMLL_NO_LINK%>' && name != '<%=GuidedSellUIConstants.GSMLL_PRODUCT_PAGE%>'){
		alertDialog("<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSMLL_MULTIPLE_LINK_SELECTED_MSG)%>");
		return false;
	}

	return true;
}

function linkListSelect(selSelectedObject){
	var selected = selSelectedObject.options[selSelectedObject.selectedIndex].value;
	if(selected != null){
		top.showProgressIndicator(true);
		gsframe.location.replace(selected);
	}
}

//-->
</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>
<%
	if((forChange != null && forChange.trim().length() != 0 && forChange.trim().equals("true") && fromPage.trim().equals(GuidedSellUIConstants.GSMLL_FROM_NEW_CHANGE_ANSWER)) || 
		(fromPage.trim().equals(GuidedSellUIConstants.GSMLL_FROM_NEW_CHANGE_CATEGORY))) {
%>
<SCRIPT LANGUAGE="JavaScript">
	var changedObject = top.get("changedLinkData",null);
	document.writeln("<FRAMESET FRAMESPACING='0' BORDER='0' FRAMEBORDER='0' ROWS='20%,80%' ONLOAD='loadPanelData();' ONUNLOAD='unloadPanelData();'>\n");
	if(changedObject != null){
		var linkName = changedObject.linkType;
		var linkURL = "<%=UIUtil.toJavaScript(urlSelectPrefix)%>&<%=GuidedSellUIConstants.GSMLL_METAPHOR_LINK_NAME%>="+linkName;
		var selectURL = "<%=UIUtil.toJavaScript(urlListPrefix)%>&<%=GuidedSellUIConstants.GSMLL_METAPHOR_LINK_NAME%>="+linkName;
		document.writeln("<FRAME SRC='"+linkURL+"' name='linkTypeSelect' scrolling='no' title=\"<%=getNLString(guidedSellRB,GuidedSellUIConstants.GS_LINK_SELECT_FRAME)%>\"/> \n");
		document.writeln("<FRAME SRC='"+selectURL+"' name='gsframe' title=\"<%=getNLString(guidedSellRB,GuidedSellUIConstants.GS_LINK_FRAME)%>\"/> \n");
	} else {
		document.writeln("<FRAME SRC='<%=urlSelect%>' name='linkTypeSelect' scrolling='no' title=\"<%=getNLString(guidedSellRB,GuidedSellUIConstants.GS_LINK_SELECT_FRAME)%>\"/> \n");
		document.writeln("<FRAME SRC='<%=urlList%>' name='gsframe' title=\"<%=getNLString(guidedSellRB,GuidedSellUIConstants.GS_LINK_FRAME)%>\"/> \n");
	}
	document.writeln("</FRAMESET>\n");
</SCRIPT>
<%
	} else {
%>
<FRAMESET FRAMESPACING="0" BORDER="0" FRAMEBORDER="0" ROWS="20%,80%" ONLOAD="loadPanelData();" ONUNLOAD="unloadPanelData();">
    <FRAME SRC="<%=urlSelect%>" name="linkTypeSelect" scrolling="no" title="<%=guidedSellRB.get(GuidedSellUIConstants.GS_LINK_SELECT_FRAME)%>"/>
    <FRAME SRC="<%=urlList%>" name="gsframe" title="<%=guidedSellRB.get(GuidedSellUIConstants.GS_LINK_FRAME)%>"/>
</FRAMESET>
<%
	}
%>
</HTML>
