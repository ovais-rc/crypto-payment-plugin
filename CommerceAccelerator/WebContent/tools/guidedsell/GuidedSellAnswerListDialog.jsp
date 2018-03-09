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

  (C) Copyright IBM Corp. 2002, 2013 All Rights Reserved.

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
			com.ibm.commerce.server.ECConstants,
			java.util.Vector" %>

<%@include file="/tools/guidedsell/GuidedSellCommon.jsp" %>

<%
	String categoryId = request.getParameter(GuidedSellUIConstants.GS_CATEGORY_ID);
	String metaphorId = request.getParameter(GuidedSellUIConstants.GS_METAPHOR_ID);
	String treeId = request.getParameter(GuidedSellUIConstants.GS_TREE_ID);
//	String storeId = request.getParameter(ECConstants.EC_STORE_ID);
	String gsLanguageId = request.getParameter(GuidedSellUIConstants.GS_LANGUAGE_ID);
	String conceptId = request.getParameter(GuidedSellUIConstants.GS_CONCEPT_ID);
	String urlLanguage = "/webapp/wcs/tools/servlet/GSLanguageView";
	urlLanguage = urlLanguage+"?"+GuidedSellUIConstants.GS_LANGUAGE_ID+"="+gsLanguageId;
	String urlList = "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=guidedSell.GuidedSellAnswerList&cmd=GuidedSellAnswerListView&"+GuidedSellUIConstants.GS_CONCEPT_ID+"="+conceptId+"&"+GuidedSellUIConstants.GS_LANGUAGE_ID+"="+gsLanguageId+"&"+GuidedSellUIConstants.GS_CATEGORY_ID+"="+categoryId+"&"+GuidedSellUIConstants.GS_TREE_ID+"="+treeId+"&"+GuidedSellUIConstants.GS_METAPHOR_ID+"="+metaphorId;
%>

<HTML>
<HEAD>
 <%= fHeader %>
<TITLE><%=guidedSellRB.get(GuidedSellUIConstants.GSAL_TITLE)%></TITLE>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/guidedsell/gscommon.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!--
function visibleList(s){
   if (this.language.visibleList){
      language.visibleList(s);
   }
}

function getLanguageSelectText(){
	return "<%= getNLString(guidedSellRB,GuidedSellUIConstants.GS_LANGUAGE)%>";
}

function getNLSLanguageTitle()
{
	return "<%= getNLString(guidedSellRB,GuidedSellUIConstants.GSAL_TITLE)%>";
}

function getNLSInstruction(){
	return "<i><%=getNLString(guidedSellRB,GuidedSellUIConstants.GSAL_LANGUAGE_TEXT)%></i>";
}

function getNLSTitle(){
	return "<%= getNLString(guidedSellRB,GuidedSellUIConstants.GS_LANGUAGE)%>";
}

function languageListSelect(selSelectedObject){
	var selValue = selSelectedObject.options[selSelectedObject.selectedIndex].value;
	if(selValue != null){
	var urlList = "/webapp/wcs/tools/servlet/GuidedSellAnswerListView?ActionXMLFile=guidedSell.GuidedSellAnswerList";
		urlList =urlList+"&<%=GuidedSellUIConstants.GS_CONCEPT_ID%>=<%=UIUtil.toJavaScript(conceptId)%>";
		urlList =urlList+"&<%=GuidedSellUIConstants.GS_LANGUAGE_ID%>="+selValue;
		urlList =urlList+"&<%=GuidedSellUIConstants.GS_CATEGORY_ID%>=<%=UIUtil.toJavaScript(categoryId)%>";
		urlList =urlList+"&<%=GuidedSellUIConstants.GS_METAPHOR_ID%>=<%=UIUtil.toJavaScript(metaphorId)%>";
		urlList =urlList+"&<%=GuidedSellUIConstants.GS_TREE_ID%>=<%=UIUtil.toJavaScript(treeId)%>";
	    gsframe.basefrm.location.replace(urlList);
	}
}

function loadPanelData(){
	gsModifyBCT(<%=(gsLanguageId == null ? null : UIUtil.toJavaScript(gsLanguageId))%>);
	parent.setContentFrameLoaded(true);
}

function savePanelData(){
gsframe.basefrm.savePanelData();
}

function validatePanelData(){
	top.remove("pathId");
	return true;
}

var changed = false;
function setChanged(chnged){
	changed = chnged;
}

function getChanged(){
	return changed;
}
// -->
</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>
<FRAMESET FRAMESPACING="0" BORDER="0" FRAMEBORDER="0" ROWS="20%,80%" ONLOAD="loadPanelData();">
	<FRAME SRC="<%=UIUtil.toHTML(urlLanguage)%>" name="language" scrolling="no" title="<%=guidedSellRB.get(GuidedSellUIConstants.GS_LANGUAGE_FRAME)%>"/>
	<FRAME SRC="<%=UIUtil.toHTML(urlList)%>" name="gsframe" title="<%=guidedSellRB.get(GuidedSellUIConstants.GS_ANSWER_LIST_FRAME)%>"/>
</FRAMESET>
</HTML>
