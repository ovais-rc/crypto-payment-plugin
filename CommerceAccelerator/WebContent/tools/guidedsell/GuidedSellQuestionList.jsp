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
<%@page language="java" import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.pa.tools.guidedsell.utils.GuidedSellUIConstants,
      com.ibm.commerce.pa.tools.guidedsell.containers.GuidedSellQuestionData,
 	com.ibm.commerce.pa.tools.guidedsell.beans.GuidedSellQuestionListDataBean,
      com.ibm.commerce.pa.tools.guidedsell.utils.GuidedSellHelper,
	com.ibm.commerce.server.ECConstants,
      com.ibm.commerce.tools.util.*,
	com.ibm.commerce.tools.xml.XMLUtil,
	com.ibm.commerce.tools.common.ui.taglibs.*,
	com.ibm.commerce.tools.common.ui.UIProperties,
	java.util.Hashtable,
	java.util.Vector" %>

<%@include file="/tools/guidedsell/GuidedSellCommon.jsp" %>

<%
	String categoryId = request.getParameter(GuidedSellUIConstants.GS_CATEGORY_ID);
	String metaphorId = request.getParameter(GuidedSellUIConstants.GS_METAPHOR_ID);
	String treeId = request.getParameter(GuidedSellUIConstants.GS_TREE_ID);
	//String viewLanguageId = request.getParameter(GuidedSellUIConstants.GSQL_VIEW_LANGUAGE_ID);
	boolean hasRootQuestion = (new GuidedSellHelper()).hasRootQuestion(new Integer(treeId));

	GuidedSellQuestionListDataBean gsqldb = new GuidedSellQuestionListDataBean();
	DataBeanManager.activate(gsqldb,request);
	int numberOfQuestions = 0;
	Vector questionVector = gsqldb.getGuidedSellQuestionData();
	if(questionVector != null && !questionVector.isEmpty()){
		numberOfQuestions = questionVector.size();
	}
%>

<HTML>
<HEAD>
<%= fHeader%>
<TITLE><%= guidedSellRB.get(GuidedSellUIConstants.GSQL_TITLE)%></TITLE>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/guidedsell/gscommon.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" >
<!-- hide script from old browsers -->

function getUserNLSTitle(){
	return '';
}

function getAnswers() {
	top.remove("gsAnswerRemoveList");
	top.remove("gsAnswerList");
     	var checked = parent.getChecked().toString();
	var params = checked.split(';');
      var conceptId = params[1];
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=guidedSell.GuidedSellAnswerListDialog";
	var selected = parent.parent.language.listForm.listSelect.options[parent.parent.language.listForm.listSelect.options.selectedIndex].value;
	url += "&<%=GuidedSellUIConstants.GS_LANGUAGE_ID%>="+selected;
	url += "&<%=GuidedSellUIConstants.GS_CATEGORY_ID%>=<%=UIUtil.toJavaScript(categoryId)%>";
	url += "&<%=GuidedSellUIConstants.GS_METAPHOR_ID%>=<%=UIUtil.toJavaScript(metaphorId)%>";
	url += "&<%=GuidedSellUIConstants.GS_TREE_ID%>=<%=UIUtil.toJavaScript(treeId)%>";
      url += "&<%=GuidedSellUIConstants.GS_CONCEPT_ID%>="+conceptId; 

	if (top.setContent) {
		top.setContent("<%= UIUtil.toJavaScript((String)guidedSellRB.get(GuidedSellUIConstants.GSAL_NAME)) %>", url, true);
	} else {
		parent.location.replace(url);
	}
}

function newQuestion() {
   
     	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=guidedSell.GuidedSellQuestionDialog&";
	url += "<%=GuidedSellUIConstants.GS_CATEGORY_ID%>=<%=UIUtil.toJavaScript(categoryId)%>";
	url += "&<%=GuidedSellUIConstants.GS_METAPHOR_ID%>=<%=UIUtil.toJavaScript(metaphorId)%>";
	var selected = parent.parent.language.listForm.listSelect.options[parent.parent.language.listForm.listSelect.options.selectedIndex].value;
	url += "&<%=GuidedSellUIConstants.GS_LANGUAGE_ID%>="+selected;
	url += "&<%=GuidedSellUIConstants.GS_TREE_ID%>=<%=UIUtil.toJavaScript(treeId)%>";
	url += "&<%=GuidedSellUIConstants.GSQD_CREATE_NEW%>=true";
	url += "&<%=GuidedSellUIConstants.GS_HAS_ROOT_QUESTION%>="+<%=hasRootQuestion%>;
   
	if (top.setContent) {
		top.setContent("<%= UIUtil.toJavaScript((String)guidedSellRB.get(GuidedSellUIConstants.GSQD_NAME)) %>", url, true);
	} else {
		parent.location.replace(url);
	}
}

function changeQuestion() {
     	var checked = parent.getChecked().toString();
	var params = checked.split(';');
	var treeId = params[0];
      var conceptId = params[1];
	var viewLanguageId = params[2];
	var rootQuestion = params[3];

	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=guidedSell.GuidedSellQuestionDialog";
	url += "&<%=GuidedSellUIConstants.GS_LANGUAGE_ID%>="+viewLanguageId;
	url += "&<%=GuidedSellUIConstants.GS_CATEGORY_ID%>=<%=UIUtil.toJavaScript(categoryId)%>";
	url += "&<%=GuidedSellUIConstants.GS_METAPHOR_ID%>=<%=UIUtil.toJavaScript(metaphorId)%>";
	url += "&<%=GuidedSellUIConstants.GSQD_CREATE_NEW%>=false";
	url += "&<%=GuidedSellUIConstants.GS_TREE_ID%>="+treeId;
	url += "&<%=GuidedSellUIConstants.GS_HAS_ROOT_QUESTION%>="+<%=hasRootQuestion%>;
      url += "&<%=GuidedSellUIConstants.GS_CONCEPT_ID%>="+conceptId ;
	url += "&<%=GuidedSellUIConstants.GSQD_ROOT_QUESTION%>="+rootQuestion; 

	if (top.setContent) {
		top.setContent("<%= UIUtil.toJavaScript((String)guidedSellRB.get(GuidedSellUIConstants.GSQD_CHANGE_NAME)) %>", url, true);
	} else {
		parent.location.replace(url);
	}
}

function removeQuestion() {
	var selected = confirmDialog("<%= getNLString(guidedSellRB,GuidedSellUIConstants.GSQL_DELETE_CONFIRM)%>");
	if(!selected){
		return;
	}
	var checked = parent.getChecked();
	var p = new Object();
	var clength = checked.length;
	p['fromQATPage'] = 'false';
	p['<%=GuidedSellUIConstants.GS_CATEGORY_ID%>']='<%=UIUtil.toJavaScript(categoryId)%>';
	p['<%=GuidedSellUIConstants.GS_METAPHOR_ID%>']='<%=UIUtil.toJavaScript(metaphorId)%>';
	p['removeAll'] = 'false';
	p['URL']='GSQuestionListMainView';
	p['<%=GuidedSellUIConstants.GS_LANGUAGE_ID%>'] = parent.parent.language.listForm.listSelect.options[parent.parent.language.listForm.listSelect.selectedIndex].value;
	p['numberOfConcepts']=clength;
	var treeId = '';
	for(var i=0;i<clength;i++){
		var parValues = checked[i].split(';');		
		treeId = parValues[0];
      	var conceptId = parValues[1];
		p['conceptId_'+i] = conceptId;
	}
	p['treeId'] = treeId;
	top.showContent('/webapp/wcs/tools/servlet/GSRemoveQAndACmd?',p);
}

function qnaTree(){
      top.goBack();
}

function onLoad(){
	parent.loadFrames();
}

// -->
</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>
<BODY ONLOAD="onLoad()" class="content">
<FORM NAME="guidedSellQuestionForm" >

<%
	String orderByParm = request.getParameter("orderby");
	int rowselect = 1;
%>
      <%= comm.startDlistTable("guidedSellQuestionListSummary") %>
	<%= comm.startDlistRowHeading() %>
	<%= comm.addDlistCheckHeading(true,"parent.selectDeselectAll();") %>
	<%= comm.addDlistColumnHeading((String)guidedSellRB.get(GuidedSellUIConstants.GSQL_QUESTIONS_NAME),GuidedSellUIConstants.GSQL_ORDER_BY_QUESTIONS,GuidedSellUIConstants.GSQL_ORDER_BY_QUESTIONS.equals(orderByParm),null,false) %>
	<%= comm.addDlistColumnHeading((String)guidedSellRB.get(GuidedSellUIConstants.GSQL_LINK),GuidedSellUIConstants.GSQL_ORDER_BY_LINK,GuidedSellUIConstants.GSQL_ORDER_BY_LINK.equals(orderByParm),null,false) %>
	<%= comm.endDlistRow() %>

	<%
		GuidedSellQuestionData data = null;
		for (int i=0; i<numberOfQuestions; i++) {
		data = (GuidedSellQuestionData)questionVector.elementAt(i);
      %>
		<%= comm.startDlistRow(rowselect) %>
		<%= comm.addDlistCheck(data.getTreeId()+";"+data.getConceptId()+";"+data.getLanguageId()+";"+data.isRootQuestion()+";"+data.isLinked(),"parent.setChecked();") %>
		<% String conceptName = data.getConceptName();
			conceptName = UIUtil.toHTML(conceptName);
		   if(data.isRootQuestion()){
			conceptName = "<img src=\'/wcs/images/tools/guidedsell/rootQ.gif\' border=\'0\' alt=\'"+getNLString(guidedSellRB,GuidedSellUIConstants.GSQL_ROOT_QUESTION)+"\'>"+conceptName;
			}	
		%>
		<%= comm.addDlistColumn(conceptName, "none") %>
		<%= comm.addDlistColumn(UIUtil.toHTML(data.getLinkStatus()), "none") %>
		<%= comm.endDlistRow() %>
		<%
			if (rowselect == 1) {
				rowselect = 2;
			}
			else {
				rowselect = 1;
			}
		}
	%>
	<%= comm.endDlistTable() %>
<%
	if(numberOfQuestions == 0 ){
%>
	<P><P>
	<%= guidedSellRB.get(GuidedSellUIConstants.GSQL_EMPTY) %>		
<%
	}
%>

</FORM>
<SCRIPT LANGUAGE="JavaScript" >
<!--
parent.afterLoads();
//-->
</SCRIPT>
</BODY>
</HTML>
