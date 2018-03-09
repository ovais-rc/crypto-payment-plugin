<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN">
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


<%@include file="/tools/guidedsell/GuidedSellCommon.jsp" %>

<%
	JSPHelper helper = new JSPHelper(request);

	String categoryId = helper.getParameter(GuidedSellUIConstants.GS_CATEGORY_ID);
	String metaphorId = helper.getParameter(GuidedSellUIConstants.GS_METAPHOR_ID);
	String treeId = helper.getParameter(GuidedSellUIConstants.GS_TREE_ID);
	String gsLanguageId = helper.getParameter(GuidedSellUIConstants.GS_LANGUAGE_ID);

	String urlLanguage = "/webapp/wcs/tools/servlet/GSLanguageView";
	urlLanguage = urlLanguage +"?"+GuidedSellUIConstants.GS_LANGUAGE_ID+"="+gsLanguageId;

	String urlQuestionListPrefix= "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=guidedSell.GuidedSellQuestionList&cmd=GSQuestionListView&" + GuidedSellUIConstants.GS_TREE_ID+ "="+treeId;
	urlQuestionListPrefix =urlQuestionListPrefix +"&"+GuidedSellUIConstants.GS_ORDER_BY+"="+GuidedSellUIConstants.GSQL_ORDER_BY_QUESTIONS;
	urlQuestionListPrefix =urlQuestionListPrefix +"&"+GuidedSellUIConstants.GS_CATEGORY_ID+"="+categoryId+"&"+GuidedSellUIConstants.GS_METAPHOR_ID+"="+metaphorId;
	String urlQuestionList = urlQuestionListPrefix +"&"+GuidedSellUIConstants.GSQL_VIEW_LANGUAGE_ID+"="+gsLanguageId;
%>

<HTML>
<HEAD>
<%= fHeader%>
<TITLE><%= guidedSellRB.get(GuidedSellUIConstants.GSQL_QUESTIONS_NAME) %></TITLE>
<SCRIPT LANGUAGE="JavaScript">
<!-- 

   	function visibleList(s){
   		if (this.language.visibleList)
   		{
      		language.visibleList(s);
   		}
	}

	function getHelp(){
		return "MC.guidedsell.gsquestions.Help";
	}

	function getNLSLanguageTitle() {
		return "<%= getNLString(guidedSellRB,GuidedSellUIConstants.GSQL_TITLE)%>";	
	}
	
	function getNLSInstruction(){
		return "<I><%= getNLString(guidedSellRB,GuidedSellUIConstants.GSQL_LANGUAGE_TEXT)%></I>";
	}
	
	function getLanguageSelectText(){
		var viewLabel = "<%= getNLString(guidedSellRB,GuidedSellUIConstants.GSQL_QUESTIONS_VIEW_NAME)%>";
		viewLabel = viewLabel + " : " ;
		return viewLabel;
	}


	function languageListSelect(selSelectedObject){
		var selValue = selSelectedObject.options[selSelectedObject.selectedIndex].value;

		if(selValue != null){
			var url = "/webapp/wcs/tools/servlet/GSQuestionListView?ActionXMLFile=guidedSell.GuidedSellQuestionList";
			url = url + "&<%=GuidedSellUIConstants.GS_TREE_ID%>="+<%=treeId%>;
			url = url + "&<%=GuidedSellUIConstants.GS_ORDER_BY%>=<%=GuidedSellUIConstants.GSQL_ORDER_BY_QUESTIONS%>";
			url = url + "&<%=GuidedSellUIConstants.GS_CATEGORY_ID%>="+<%=categoryId%>;
			url = url + "&<%=GuidedSellUIConstants.GS_METAPHOR_ID%>="+<%=metaphorId%>;
			url = url + "&<%=GuidedSellUIConstants.GSQL_VIEW_LANGUAGE_ID%>="+selValue;
			gsframe.generalForm.viewLanguageId.value=selValue;
			gsframe.selectDeselectAll();
		      gsframe.basefrm.location.replace(url);
			top.showProgressIndicator(true);
		}
	}

// -->
</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>
<FRAMESET framespacing="0" border="0" frameborder="0" rows="20%,80%">
		<frame src="<%=urlLanguage%>" name="language" scrolling=auto title="<%=guidedSellRB.get(GuidedSellUIConstants.GS_LANGUAGE_FRAME)%>"/>
		<frame src="<%=urlQuestionList%>" name="gsframe" title="<%=guidedSellRB.get(GuidedSellUIConstants.GS_QUESTION_LIST_FRAME)%>"/>
</FRAMESET>
</HTML>
