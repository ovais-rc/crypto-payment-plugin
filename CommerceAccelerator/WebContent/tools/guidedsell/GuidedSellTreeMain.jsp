<!--
//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------
-->

<!-- 
  //*----
  //* @deprecated The Product Advisor feature has been deprecated. For more information, see <a href="../../../../../../com.ibm.commerce.productadvisor.doc/concepts/cpaintro.htm">Product Advisor</a>.
  //*----
-->
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.pa.tools.guidedsell.utils.GuidedSellUIConstants" %>
<%@ page import="com.ibm.commerce.pa.tools.guidedsell.utils.GuidedSellHelper" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>

<%@ include file="/tools/guidedsell/GuidedSellCommon.jsp" %>

<%
	JSPHelper helper = new JSPHelper(request);
	String categoryId = helper.getParameter(GuidedSellUIConstants.GS_CATEGORY_ID);
	String metaphorId = helper.getParameter(GuidedSellUIConstants.GS_METAPHOR_ID);
	String treeLangId = helper.getParameter(GuidedSellUIConstants.GS_LANGUAGE_ID);
	String treeId = helper.getParameter(GuidedSellUIConstants.GS_TREE_ID);
	String storeId = helper.getParameter(ECConstants.EC_STORE_ID);

	boolean hasRootQuestion = (new GuidedSellHelper()).hasRootQuestion(new Integer(treeId));

	String urlLanguage = "/webapp/wcs/tools/servlet/GSLanguageView";
	urlLanguage += "?"+GuidedSellUIConstants.GS_LANGUAGE_ID+"="+treeLangId;

	String urlTreePrefix= "/webapp/wcs/tools/servlet/GSTreeView?XMLFile=guidedSell.GuidedSellTree";
	urlTreePrefix += "&"+GuidedSellUIConstants.GS_CATEGORY_ID+"="+categoryId;
	urlTreePrefix += "&"+GuidedSellUIConstants.GS_METAPHOR_ID+"="+metaphorId;
	urlTreePrefix += "&"+GuidedSellUIConstants.GS_TREE_ID+"="+treeId;
	String urlTree = urlTreePrefix+"&"+GuidedSellUIConstants.GSQAT_TREE_LANGUAGE_ID+"="+treeLangId;
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META name="GENERATOR" content="IBM WebSphere Studio">
<TITLE><%=guidedSellRB.get(GuidedSellUIConstants.GSQAT_MAIN_TITLE)%></TITLE>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/guidedsell/gscommon.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/guidedsell/gstree.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!--
function visibleList(s){
   if (this.language.visibleList){
      language.visibleList(s);
   }
}

function getHelp(){
	return "MC.guidedsell.gsqatree.Help";
}

function getUserNLSTitle(){
	var title = top.get("categoryName")+" - <%= getNLString(guidedSellRB,GuidedSellUIConstants.GSQAT_TITLE)%>";
	title += "<BR><I><%= getNLString(guidedSellRB,GuidedSellUIConstants.GSQAT_INSTRUCTIONAL_TEXT)%></I>";
	return title;
}

function getLanguageSelectText(){
	return "<%=getNLString(guidedSellRB,GuidedSellUIConstants.GS_LANGUAGE)%>";
}

function getNLSInstruction(){
	return "<I><%= getNLString(guidedSellRB,GuidedSellUIConstants.GSQAT_LANGUAGE_TEXT)%></I>";
}

function languageListSelect(selSelectedObject){
	var selValue = selSelectedObject.options[selSelectedObject.selectedIndex].value;
	if(selValue != null){
		var url = "<%= urlTreePrefix%>";
		url = url+"&treeLangId="+selValue;
		top.showProgressIndicator(true);
		gsframe.location.replace(url);
	}
}

function myRefreshButtons(){
	var param = getNodeParameterNew();
	if(param != null && rtrim(ltrim(param)).length != 0){
		if(isLink(param)){
			disableButton(buttons.buttonForm.newButton);
			enableButton(buttons.buttonForm.removeButton);
			disableButton(buttons.buttonForm.removeAllButton);
			disableButton(buttons.buttonForm.changeButton);
			disableButton(buttons.buttonForm.answersButton);
			return;
		} else {
			enableButton(buttons.buttonForm.newButton);
			enableButton(buttons.buttonForm.answersButton);
		}

		enableButton(buttons.buttonForm.removeButton);
		enableButton(buttons.buttonForm.removeAllButton);
		enableButton(buttons.buttonForm.changeButton);

		if(isQuestion(param)){
			enableButton(buttons.buttonForm.answersButton);
		} else {
			disableButton(buttons.buttonForm.answersButton);
		}

		if(isAnswer(param)){
			if(isLinked(param)){
				disableButton(buttons.buttonForm.newButton);
			} else {
				enableButton(buttons.buttonForm.newButton);
			}
		}
	} else {
		disableButton(buttons.buttonForm.removeButton);
		disableButton(buttons.buttonForm.removeAllButton);
		disableButton(buttons.buttonForm.changeButton);
		disableButton(buttons.buttonForm.answersButton);
	}
}

function afterExpandRow(){
	if(gsframe.setProgress) {
		gsframe.setProgress(false);
	}
	if(gsframe.showRefreshing) {
		gsframe.showRefreshing(false);
	}
}

function newFunction(){
	var param = getNodeParameterNew();
	if(isQuestion(param) == true) {
		removeTopContents();
		var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=guidedSell.GuidedSellAnswerDialog&"+param;
		var selected = this.language.listForm.listSelect.options[this.language.listForm.listSelect.options.selectedIndex].value;
		url += "&<%=GuidedSellUIConstants.GS_LANGUAGE_ID%>="+selected;
		url += "&<%=GuidedSellUIConstants.GSA_CREATE_NEW%>=true";
		if (top.setContent) {
			top.setContent("<%= UIUtil.toJavaScript((String)guidedSellRB.get(GuidedSellUIConstants.GSA_NAME)) %>", url, true);
		} else {
			parent.location.replace(url);
		}
	} else if(isAnswer(param) == true) {
		var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=guidedSell.GuidedSellLinkDialog&"+param;
		var selected = this.language.listForm.listSelect.options[this.language.listForm.listSelect.options.selectedIndex].value;
		url += "&<%=GuidedSellUIConstants.GS_LANGUAGE_ID%>="+selected;
		url += "&<%=GuidedSellUIConstants.GSMLL_FROM_PAGE%>=<%=GuidedSellUIConstants.GSMLL_FROM_NEW_CHANGE_ANSWER%>";
		url += "&<%=GuidedSellUIConstants.GSMLL_FOR_CHANGE%>=false";
		if (top.setContent) {
			top.setContent("<%= UIUtil.toJavaScript((String)guidedSellRB.get(GuidedSellUIConstants.GSMLL_NAME)) %>", url, true);
		} else {
			parent.location.replace(url);
		}
	} else {
		var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=guidedSell.GuidedSellQuestionDialog";
		url += "&<%=GuidedSellUIConstants.GS_CATEGORY_ID%>="+<%=categoryId%>;
		url += "&<%=GuidedSellUIConstants.GS_METAPHOR_ID%>="+<%=metaphorId%>;
		var selected = this.language.listForm.listSelect.options[this.language.listForm.listSelect.options.selectedIndex].value;
		url += "&<%=GuidedSellUIConstants.GS_LANGUAGE_ID%>="+selected;
   		url += "&<%=GuidedSellUIConstants.GS_TREE_ID%>="+<%=treeId%>;
		url += "&<%=GuidedSellUIConstants.GSQD_CREATE_NEW%>=true"
		url += "&<%=GuidedSellUIConstants.GS_HAS_ROOT_QUESTION%>="+<%=hasRootQuestion%>;
		if (top.setContent) {
			top.setContent("<%= UIUtil.toJavaScript((String)guidedSellRB.get(GuidedSellUIConstants.GSQD_NAME)) %>", url, true);
		} else {
			parent.location.replace(url);
		}
	}
}

function changeFunction(){
	if(isButtonDisabled(buttons.buttonForm.changeButton)){
		return;
	}
	var param = getNodeParameterNew();
	if(isQuestion(param) == true) {
		var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=guidedSell.GuidedSellQuestionDialog&"+param;
		var selected = this.language.listForm.listSelect.options[this.language.listForm.listSelect.options.selectedIndex].value;
		url += "&<%=GuidedSellUIConstants.GS_LANGUAGE_ID%>="+selected;
		url += "&<%=GuidedSellUIConstants.GSQD_CREATE_NEW%>=false"
		url += "&<%=GuidedSellUIConstants.GS_HAS_ROOT_QUESTION%>="+<%=hasRootQuestion%>;
		if (top.setContent) {
			top.setContent("<%= UIUtil.toJavaScript((String)guidedSellRB.get(GuidedSellUIConstants.GSQD_CHANGE_NAME)) %>", url, true);
		} else {
			parent.location.replace(url);
		}
	} else if(isAnswer(param) == true) {
		removeTopContents();	
		var url = "/webapp/wcs/tools/servlet/NotebookView?XMLFile=guidedSell.GuidedSellAnswerNotebook&"+param;
		var selected = this.language.listForm.listSelect.options[this.language.listForm.listSelect.options.selectedIndex].value;
		url += "&<%=GuidedSellUIConstants.GS_LANGUAGE_ID%>="+selected;
		url += "&<%=GuidedSellUIConstants.GSA_CREATE_NEW%>=false";
		url += "&<%=GuidedSellUIConstants.GSMLL_FROM_PAGE%>=<%=GuidedSellUIConstants.GSMLL_FROM_NEW_CHANGE_ANSWER%>";
		url += "&<%=GuidedSellUIConstants.GSMLL_FOR_CHANGE%>=true";
		if (top.setContent) {
			top.setContent("<%= UIUtil.toJavaScript((String)guidedSellRB.get(GuidedSellUIConstants.GSA_CHANGE_NAME)) %>", url, true);
		} else {
			parent.location.replace(url);
		}
	}
}

function questions(){
	var url = "/webapp/wcs/tools/servlet/GSQuestionListMainView?treeId="+<%=treeId%>+"&<%=GuidedSellUIConstants.GS_LANGUAGE_ID%>="+<%=treeLangId%>;
	url += "&categoryId="+<%=categoryId%>+"&metaphorId="+<%=metaphorId%>+"&storeId="+<%=storeId%>;

	if (top.setContent) {
		top.setContent("<%= UIUtil.toJavaScript((String)guidedSellRB.get(GuidedSellUIConstants.GSQL_QUESTIONS_NAME)) %>", url, true);
	} else {
		parent.location.replace(url);
	}
}

function answers(){
	if(isButtonDisabled(buttons.buttonForm.answersButton)){
		return;
	}
	top.remove("gsAnswerRemoveList");
	top.remove("gsAnswerList");
	var param = getNodeParameterNew();
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=guidedSell.GuidedSellAnswerListDialog&"+param;
	var selected = this.language.listForm.listSelect.options[this.language.listForm.listSelect.options.selectedIndex].value;
	url += "&<%=GuidedSellUIConstants.GS_LANGUAGE_ID%>="+selected;
	if (top.setContent) {
		top.setContent("<%= UIUtil.toJavaScript((String)guidedSellRB.get(GuidedSellUIConstants.GSAL_NAME)) %>", url, true);
	} else {
		parent.location.replace(url);
	}
}

function preview(){
<%
	if(hasRootQuestion) {
%>
		var storeId = "<%= storeId%>";
		var categoryId = "<%= categoryId %>";
		var languageId = "<%= treeLangId %>";
		var fix = "storeId="+storeId+"&categoryId="+categoryId+"&langId="+languageId+"&preview=true";
		var catalogId = top.get("catalogId",null);
		if(catalogId != null){
			fix = fix+"&catalogId="+catalogId;
		}
		//changed for preview fix
		//var url = "/webapp/wcs/tools/servlet/GSPreviewView?";
		//url = url+fix;
		var date= new Date();
		var time = date.getTime();
		var title ="GS" + time;
		//added 
		var hostname = window.location.hostname;
		var url = "http://"+hostname+"/webapp/wcs/stores/servlet/sa51.jsp?";
		url = url+fix;
		//add ends
      	//window.open(url,title, "resizable=yes,scrollbars=yes,status=no,width=800,height=600");
		var changed = promptDialog("<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSQAT_PREVIEW_TEXT)%>",url);
		if(changed != null && rtrim(ltrim(changed)).length != 0 ){
	      	window.open(changed,title, "resizable=yes,scrollbars=yes,status=no,width=800,height=600");
		}
		//change ends
<%
	} else {
%>
		alertDialog("<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSQAT_PREVIEW_MESSAGE)%>");
<%
	}
%>
}

function removeFunction(){
	if(isButtonDisabled(buttons.buttonForm.removeButton)){
		return;
	}
	var param = getNodeParameterNew();

	if(param == null || rtrim(ltrim(param)).length == 0){
		myRefreshButtons();
		return;
	}
	var selected = confirmDialog("<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSQAT_REMOVE_MESSAGE)%>");
	if(selected){
		top.put("fromRemove","true");
		var p = new Object();
		p['removeAll'] = 'false';
		p['<%=GuidedSellUIConstants.GS_LANGUAGE_ID%>'] = language.listForm.listSelect.options[language.listForm.listSelect.selectedIndex].value;
		top.showContent('/webapp/wcs/tools/servlet/GSRemoveQAndACmd?'+param,p);
	}
}

function removeAllFunction(){
	if(isButtonDisabled(buttons.buttonForm.removeAllButton)){
		return;
	}
	var param = getNodeParameterNew();

	if(param == null || rtrim(ltrim(param)).length == 0){
		myRefreshButtons();
		return;
	}
	var selected = confirmDialog("<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSQAT_REMOVE_ALL_MESSAGE)%>");
	if(selected){
		top.put("fromRemove","true");
		var p = new Object();
		p['removeAll'] = 'true';
		p['<%=GuidedSellUIConstants.GS_LANGUAGE_ID%>'] = language.listForm.listSelect.options[language.listForm.listSelect.selectedIndex].value;
		top.showContent('/webapp/wcs/tools/servlet/GSRemoveQAndACmd?'+param,p);
	}
}

function initForm(){
	var title = '';
	if(this.getUserNLSTitle){
		title = getUserNLSTitle();
	}
	blankpage.document.writeln("<html><head>");
	blankpage.document.writeln("<%=fHeader%>");
	blankpage.document.writeln("</head>");
	blankpage.document.writeln("<body class='content'>");
	blankpage.document.writeln("<span id='select_title' style='position: absolute; height: 30px; font-size: 16pt; font-family : Times New Roman, Times, serif;'>");
	blankpage.document.writeln(title);
	blankpage.document.writeln("</span>");
	blankpage.document.writeln("</body></html>");
	myRefreshButtons();
}

function unloadForm(){
	top.remove("pathId");
}

// -->
</SCRIPT>
</HEAD>
<FRAMESET framespacing="0" border="0" frameborder="0" rows="10%,15%,*" onunload="unloadForm();" onload="initForm()">
	<FRAME src="/wcs/tools/common/blank.html" name="blankpage" title="<%=guidedSellRB.get(GuidedSellUIConstants.GS_TREE_TITLE_FRAME)%>" noresize="true" scrolling="no"/>
	<FRAME src="<%=urlLanguage%>" name="language" title="<%=guidedSellRB.get(GuidedSellUIConstants.GS_LANGUAGE_FRAME)%>" noresize="true" scrolling="auto"/>
	<FRAMESET framespacing="0" border="0" frameborder="0" cols="*,20%" >
		<FRAME src="<%=urlTree%>" name="gsframe" title="<%=guidedSellRB.get(GuidedSellUIConstants.GS_TREE_FRAME)%>" noresize="false" scrolling="auto"/>
		<FRAME src="/webapp/wcs/tools/servlet/GSTreeButtonsView" name="buttons" title="<%=guidedSellRB.get(GuidedSellUIConstants.GS_TREE_BUTTONS_FRAME)%>" noresize="true" scrolling="no"/>
	</FRAMESET>
</FRAMESET>
</HTML>
