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
	com.ibm.commerce.pa.tools.guidedsell.beans.GuidedSellAnswerListDataBean,
      com.ibm.commerce.tools.util.*,
	com.ibm.commerce.tools.xml.XMLUtil,
	com.ibm.commerce.tools.common.ui.taglibs.*,
	com.ibm.commerce.tools.common.ui.UIProperties,
	java.util.Hashtable,
	java.util.Vector" %>

<%@include file="/tools/guidedsell/GuidedSellCommon.jsp" %>
<%
	String parentConceptId = request.getParameter(GuidedSellUIConstants.GS_CONCEPT_ID);
//	String gsLanguageId = (String)request.getParameter(GuidedSellUIConstants.GS_LANGUAGE_ID);
	String categoryId = request.getParameter(GuidedSellUIConstants.GS_CATEGORY_ID);
	String treeId = request.getParameter(GuidedSellUIConstants.GS_TREE_ID);
	String metaphorId = request.getParameter(GuidedSellUIConstants.GS_METAPHOR_ID);

	GuidedSellAnswerListDataBean gsalDataBean = new GuidedSellAnswerListDataBean();
	gsalDataBean.setConceptId(parentConceptId);
	DataBeanManager.activate(gsalDataBean,request);
	Vector answerListVector = gsalDataBean.getGuidedSellAnswerData();
%>

<HTML>
<HEAD>
<%= fHeader%>
<TITLE><%= guidedSellRB.get(GuidedSellUIConstants.GSAL_TITLE) %></TITLE>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/guidedsell/gscommon.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/guidedsell/gsanswerlist.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript" >
<!-- hide script from old browsers -->
<%= UIUtil.toJSVector("gsAnswerVect",answerListVector)%>
var anslist = getVectorOfAnswers();
if(size(anslist) != 0)
{
	for(var i=0; i<size(gsAnswerVect) ; i++)
	{
		var obj = elementAt(i,gsAnswerVect);
		updateAnswerList(obj);
	}
} else {
	setVectorOfAnswers(gsAnswerVect);
}



function myRefreshButtons()
{
	parent.refreshButtons();
	var checked = parent.getChecked();
	if(checked.length == 1)
	{
		var gsAnswerList = getVectorOfAnswers();
		var index = checked[0];
		if(index==0) {
			disableButton(parent.buttons.buttonForm.moveUpButtonButton);
		}
		if(index==(size(gsAnswerList)-1)) {
			disableButton(parent.buttons.buttonForm.moveDownButtonButton);
		}

	}
}

function onLoad(){
	parent.loadFrames();

}

function getUserNLSTitle()
{
	return '';
}

function newGSAnswer()
{
	//var gsAnswerList = top.get("gsAnswerList");
	//top.saveData(gsAnswerList,"gsAnswerList");

	if((parent.parent.getChanged() && confirmDialog("<%= getNLString(guidedSellRB,GuidedSellUIConstants.GSAL_MSG_CONFIRMATION_CHANGESLOST) %>")) || !parent.parent.getChanged())
	{
		removeTopContents();
		var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=guidedSell.GuidedSellAnswerDialog";
		var selected = parent.parent.language.listForm.listSelect.options[parent.parent.language.listForm.listSelect.options.selectedIndex].value;
		url += "&<%=GuidedSellUIConstants.GS_LANGUAGE_ID%>="+selected;
		url += "&<%=GuidedSellUIConstants.GSA_CREATE_NEW%>=true";
		url += "&<%=GuidedSellUIConstants.GS_CATEGORY_ID%>=<%=UIUtil.toJavaScript(categoryId)%>";
		url += "&<%=GuidedSellUIConstants.GS_TREE_ID%>=<%=UIUtil.toJavaScript(treeId)%>";
		url += "&<%=GuidedSellUIConstants.GS_CONCEPT_ID%>=<%=UIUtil.toJavaScript(parentConceptId)%>";
		if (top.setContent) {
			top.setContent("<%= UIUtil.toJavaScript((String)guidedSellRB.get(GuidedSellUIConstants.GSA_NAME)) %>", url, true);
		} else {
			parent.location.replace(url);
		}
	}
}

function changeGSAnswer()
{
	var checked = parent.getChecked();
	var index = checked[0];
	var gsAnswerList = getVectorOfAnswers();
	var object = elementAt(index,gsAnswerList);
	var conceptId = object.conceptId;

	if((parent.parent.getChanged() && confirmDialog("<%= getNLString(guidedSellRB,GuidedSellUIConstants.GSAL_MSG_CONFIRMATION_CHANGESLOST) %>")) || !parent.parent.getChanged())
	{
		removeTopContents();	
		var url = "/webapp/wcs/tools/servlet/NotebookView?XMLFile=guidedSell.GuidedSellAnswerNotebook";
		var selected = parent.parent.language.listForm.listSelect.options[parent.parent.language.listForm.listSelect.options.selectedIndex].value;
		url += "&<%=GuidedSellUIConstants.GS_LANGUAGE_ID%>="+selected;
		url += "&<%=GuidedSellUIConstants.GSA_CREATE_NEW%>=false";
		url += "&<%=GuidedSellUIConstants.GSMLL_FROM_PAGE%>=<%=GuidedSellUIConstants.GSMLL_FROM_NEW_CHANGE_ANSWER%>";
		url += "&<%=GuidedSellUIConstants.GSMLL_FOR_CHANGE%>=true";
		url += "&<%=GuidedSellUIConstants.GS_CATEGORY_ID%>=<%=UIUtil.toJavaScript(categoryId)%>";
		url += "&<%=GuidedSellUIConstants.GS_METAPHOR_ID%>=<%=UIUtil.toJavaScript(metaphorId)%>";
		url += "&<%=GuidedSellUIConstants.GS_TREE_ID%>=<%=UIUtil.toJavaScript(treeId)%>";
		url += "&<%=GuidedSellUIConstants.GS_CONCEPT_ID%>="+conceptId;
		url += "&<%=GuidedSellUIConstants.GS_PARENT_CONCEPT_ID%>=<%=UIUtil.toJavaScript(parentConceptId)%>";
		if (top.setContent) {
			top.setContent("<%= UIUtil.toJavaScript((String)guidedSellRB.get(GuidedSellUIConstants.GSA_CHANGE_NAME)) %>", url, true);
		} else {
			parent.location.replace(url);
		}
	}
}



function savePanelData()
{
	//parent.parent.parent.put("gsAnswerList",getVectorsOfAnswers());
	//parent.parent.parent.put("gsAnswerRemoveList",getVectorsOfRemovedAnswers());
}


function removeGSAnswer()
{
	var checked = parent.getChecked();
	if (checked.length > 0)
	{
		if(confirmDialog("<%= getNLString(guidedSellRB,GuidedSellUIConstants.GSAL_MSG_REMOVE_ANSWER_CONFIRMATION) %>"))
		{
			removeSelectedAnswers();
			refreshTable();
		}
	}
}

var rowselect = 1;
var gsAnswerList = getVectorOfAnswers();
</SCRIPT>
</HEAD>
<BODY ONLOAD="onLoad()" class="content">
	<FORM NAME="GSAnswerListForm" >
	<%= comm.startDlistTable("guidedSellAnswerList") %>
	<%= comm.startDlistRowHeading() %>
	<%= comm.addDlistCheckHeading(true,"parent.selectDeselectAll();myRefreshButtons()") %>
	<%= comm.addDlistColumnHeading((String)guidedSellRB.get(GuidedSellUIConstants.GSAL_ANSWERS),null,false) %>
	<%= comm.endDlistRow() %>

<script language="javascript">
	for(var i = 0;i<size(gsAnswerList);i++) {
		var gsAnswer =  new Object();
		gsAnswer = elementAt(i,gsAnswerList);
		startDlistRow(rowselect);
		addDlistCheck(i,"parent.setChecked();myRefreshButtons()");
		addDlistColumn(gsAnswer.conceptName, "none");
		endDlistRow();
		if(rowselect == 1){
			rowselect = 2;
		} else {
			rowselect = 1;
		}
	}
</script>

<%= comm.endDlistTable() %>

<script language="javascript">
	 if (size(gsAnswerList) == 0)
	   {
		document.writeln("<P><%= getNLString(guidedSellRB,GuidedSellUIConstants.GSAL_EMPTY) %>");
	   } 	
</script>
	
</FORM>
<SCRIPT LANGUAGE="JavaScript" >
<!--
parent.afterLoads();
//-->
</SCRIPT>
</BODY>
</HTML>
