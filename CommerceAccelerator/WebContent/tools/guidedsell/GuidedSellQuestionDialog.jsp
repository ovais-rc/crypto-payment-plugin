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
			com.ibm.commerce.pa.tools.guidedsell.beans.GuidedSellAllLanguageLoaderBean,
			com.ibm.commerce.pa.tools.guidedsell.beans.GuidedSellQuestionLoaderBean,
			com.ibm.commerce.pa.tools.guidedsell.containers.GuidedSellQuestionData,
			com.ibm.commerce.server.ECConstants,
			java.util.Vector" %>

<%@include file="/tools/guidedsell/GuidedSellCommon.jsp" %>

<%
	String gsLanguageId = request.getParameter(GuidedSellUIConstants.GS_LANGUAGE_ID);
	String categoryId = request.getParameter(GuidedSellUIConstants.GS_CATEGORY_ID);
	String metaphorId = request.getParameter(GuidedSellUIConstants.GS_METAPHOR_ID);
	String treeId = request.getParameter(GuidedSellUIConstants.GS_TREE_ID);
	String createNew = request.getParameter(GuidedSellUIConstants.GSQD_CREATE_NEW);
	String conceptId = request.getParameter(GuidedSellUIConstants.GS_CONCEPT_ID);
	String rootQuestion = request.getParameter(GuidedSellUIConstants.GSQD_ROOT_QUESTION);
	String hasRootQuestion = request.getParameter(GuidedSellUIConstants.GS_HAS_ROOT_QUESTION);

	if(rootQuestion == null || rootQuestion.trim().length() == 0){
		rootQuestion = "false";
	}

	GuidedSellAllLanguageLoaderBean gsallb = new GuidedSellAllLanguageLoaderBean();
	DataBeanManager.activate(gsallb,request);
	Vector vectIds =  gsallb.getAllLanguageIds();
	Vector vectDescs =  gsallb.getAllLanguageDescriptions();

	Vector questionVect = null;

	if(!createNew.equalsIgnoreCase("true")){
		GuidedSellQuestionLoaderBean gsqlb = new GuidedSellQuestionLoaderBean();
		gsqlb.setAllLanguageIds(vectIds);
		gsqlb.setAllLanguageDescriptions(vectDescs);
		DataBeanManager.activate(gsqlb,request);
		questionVect = gsqlb.getQuestionData();
	}
%>
<HTML>
<HEAD>
 <%= fHeader %>
<TITLE><%=guidedSellRB.get(GuidedSellUIConstants.GSQD_NAME)%></TITLE>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/ConvertToXML.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/guidedsell/gscommon.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/guidedsell/gsquestiondialogfns.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
setLanguageIdBeforeSelection('<%= gsCommandContext.getStore().getLanguageId()%>');

function loadPanelData(){
<%
	if(createNew.equalsIgnoreCase("true")){
%>
	parent.pageArray["gsQuestionDialogName"].helpKey = "MC.guidedsell.gsnewquestion.Help";
<%
	} else {
%>
	parent.pageArray["gsQuestionDialogName"].helpKey = "MC.guidedsell.gschangequestion.Help";
<%
	}
%>
	gsModifyBCT(<%=(gsLanguageId == null ? null : UIUtil.toJavaScript(gsLanguageId))%>);
	resetTheLanguageSelect(getDefaultLanguageId());
	parent.setContentFrameLoaded(true);
}

function unloadPanelData(){
	setVectorOfQuestions(null);
}
var saved = false;
function savePanelData(){
	if(createUpdateTheData()){
		var vector = getVectorOfQuestions();
		var xml = generateXML(vector,"questionData",null);
		xml += "<categoryId><%=UIUtil.toJavaScript(categoryId)%></categoryId>\n";
		xml += "<metaphorId><%=UIUtil.toJavaScript(metaphorId)%></metaphorId>\n";
		xml += "<gsLanguageId><%=UIUtil.toJavaScript(gsLanguageId)%></gsLanguageId>\n";
		xml += "<treeId><%=UIUtil.toJavaScript(treeId)%></treeId>\n";
		xml += "<createNew><%=UIUtil.toJavaScript(createNew)%></createNew>\n";
		xml += "<conceptId><%=UIUtil.toJavaScript(conceptId)%></conceptId>\n";
		xml += "<hasRootQuestion><%=UIUtil.toJavaScript(hasRootQuestion)%></hasRootQuestion>\n";
		xml += "<wasRootQuestion><%=UIUtil.toJavaScript(rootQuestion)%></wasRootQuestion>\n";
		xml += "<rootQuestion>"+this.questionForm.rootQuestion.checked+"</rootQuestion>\n";
		xml = "<GuidedSellQuestion>\n" + xml + "</GuidedSellQuestion>";
		parent.put("EC_XMLFileObject", xml);
		saved = true
	}
}

function validatePanelData(){
	if(!saved){
		return false;
	}
	if(!isQuestionDefinedForDefaultLanguage()){
		alertDialog("<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSQD_DEFAULT_LANGUAGE_QUESTION_REQUIRED_MSG)%>");
		return false;
	}
	var vector = getVectorOfQuestions();
	var length = getFinalVectorSize(vector);
	if(length == 0){
		alertDialog("<%=(createNew.equalsIgnoreCase("true") ? getNLString(guidedSellRB,GuidedSellUIConstants.GSQD_ALERT_MESSAGE): getNLString(guidedSellRB,GuidedSellUIConstants.GSQD_CHANGE_ALERT_MESSAGE))%>" ); 
		return false;
	}
	var hasRootQuestion = '<%=UIUtil.toJavaScript(hasRootQuestion)%>';
	var wasRootQuestion = '<%=UIUtil.toJavaScript(rootQuestion)%>';
	var rootQuestion = this.questionForm.rootQuestion.checked;
	if(hasRootQuestion == 'true' && wasRootQuestion == 'true' && !rootQuestion){
		if(confirmDialog("<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSQD_ROOT_QUESTION_REMOVED_MSG)%>")){
			top.remove("pathId");
			return true;
		} else {
			return false;
		}
	}

	if (this.questionForm.description.value.length > 512)
		{
		    reprompt(this.questionForm.description, "<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSQD_LONG_QUESTION_DESC_MSG)%>");
		    return false;
		}
	return true;
}

function getDefaultLanguageId(){
	var dLangId = '<%= gsCommandContext.getStore().getLanguageId()%>';
	return dLangId;
}

function createUpdateTheData(){
	var question = this.questionForm.question.value;
	var returnValue = false;
	if(question != null && (question = rtrim(ltrim(question))).length != 0){
		var object = getObjectForTheLanguage(getLanguageIdBeforeSelection());
		if(object == null){
			createNewObject(getLanguageIdBeforeSelection());
		} else {
			modifyTheObject(getLanguageIdBeforeSelection());
		}
		returnValue = true;
	} else {
		if(getLanguageIdBeforeSelection() == getDefaultLanguageId()){
			resetTheLanguageSelect(getDefaultLanguageId());
			alertDialog("<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSQD_DEFAULT_LANGUAGE_QUESTION_REQUIRED_MSG)%>");
			returnValue = false;
		} else {
			removeTheObject(getLanguageIdBeforeSelection());
			returnValue = true;
		}
	}

	return returnValue;
}

function languageListSelect(selSelectedObject){
	var selValue = selSelectedObject.options[selSelectedObject.selectedIndex].value;
	if(selValue != null){
		if(createUpdateTheData()){
			if(isQuestionDefinedForDefaultLanguage()){
				if(doesLanguageIdExistInList(selValue)){
					populateTheFields(selValue);
				} else {
					clearAllFields();
				}
				displayTheReference(selValue);
				setLanguageIdBeforeSelection(selValue);
			}
		}
	}
}

</SCRIPT>

</HEAD>

<BODY ONLOAD="loadPanelData();" class="content" ONUNLOAD="unloadPanelData();">

<SPAN style="font-family: Verdana,Arial,Helvetica; font-size: 16pt; color: #565665; font-weight: normal; word-wrap: break-word;">
<%
	if(createNew.equalsIgnoreCase("true")){
%>
	<%=guidedSellRB.get(GuidedSellUIConstants.GSQD_NAME)%>
<%
	} else {
%>
	<%=guidedSellRB.get(GuidedSellUIConstants.GSQD_CHANGE_NAME)%>
<%
	}
%>
</SPAN>

<FORM NAME="questionForm" OnSubmit="return false;" >

<TABLE CELLPADDING=1 CELLSPACING=5 BORDER=0>
<TR>
	<TD>
		<label for="listSelect"><%= guidedSellRB.get(GuidedSellUIConstants.GS_LANGUAGE)%></label>
		<SELECT id="listSelect" name="listSelect" onChange="languageListSelect(this)">

		<%
			int length = vectIds.size();
			for(int i=0;i<length;i++){
				String langID =  (String)vectIds.elementAt(i);
				String description =  (String)vectDescs.elementAt(i);
				if(langID.equals(gsLanguageId)) {
		%>
				<OPTION value="<%=langID%>" SELECTED><%=description%></OPTION>
		<%
				} else {
		%>
				<OPTION value="<%=langID%>" ><%=description%></OPTION>
		<%
				}
			}
		%>
		</SELECT>
	</TD>
</TR>

<TR>
	<TD>
		<label for="question_input"><%= guidedSellRB.get(GuidedSellUIConstants.GSQD_QUESTION_TITLE)%></label>
	</TD>
</TR>
<TR>
	<TD>
		<INPUT TYPE="TEXT" id="question_input" NAME="question" VALUE="" SIZE="50" MAXLENGTH="512"><BR>
	</TD>
	<TD>
	      <SPAN ID="referenceQuestionNameSpan" STYLE="display=none">
      	  <TABLE ID="referenceQuestionNameTable" CELLPADDING=0 CELLSPACING=0 BORDER=0>
	          <TR>
      	      <TD>
				<%= guidedSellRB.get(GuidedSellUIConstants.GSQD_REFERENCE)%>
	            </TD>
      	      <TD>
	            </TD>
	         </TR>
      	 </TABLE>
  	     </SPAN>
	</TD>
</TR>

<TR>
	<TD>
		<label for="description_input"><%= guidedSellRB.get(GuidedSellUIConstants.GSQD_DESCRIPTION_TITLE)%></label>
	</TD>
</TR>

<TR>
	<TD>
		<TEXTAREA id="description_input" NAME="description" COLS="50" ROWS="5" WRAP="HARD"></TEXTAREA><BR>
	</TD>
<TR>
	<TD>
		<%
			String disabled = "";
			String checked = "";
			if(hasRootQuestion.equalsIgnoreCase("true") && !rootQuestion.equalsIgnoreCase("true")){
				disabled = "DISABLED=\"true\"";
			}
			if(hasRootQuestion.equalsIgnoreCase("true") && rootQuestion.equalsIgnoreCase("true")){
				checked = "CHECKED=\"true\"";
			}
		%>
		<INPUT TYPE="CHECKBOX" id="rootQuestionCheckBox" NAME="rootQuestion" <%=checked%> <%=disabled%> > <label for="rootQuestionCheckBox"><%= guidedSellRB.get(GuidedSellUIConstants.GSQD_ROOT_QUESTION_TITLE)%> </label>
	</TD>
</TR>
</TABLE>

</FORM>
<SCRIPT LANGUAGE="JavaScript">
<%
	if(!createNew.equalsIgnoreCase("true")){
		int qlength = questionVect.size();
		GuidedSellQuestionData qdata = null;
		for(int i=0;i<qlength;i++){
			qdata = (GuidedSellQuestionData)questionVect.elementAt(i);
%>
			var object = new Object();
			object.languageId = "<%=qdata.getLanguageId().toString()%>";
			object.removed = false;
			object.conceptName = "<%=UIUtil.toJavaScript(qdata.getConceptName())%>";
			object.elaboration = "<%=(qdata.getElaboration() == null ? "":UIUtil.toJavaScript(qdata.getElaboration()))%>";
		
			setObjectForTheLanguage(object); 
<%
		}
%>
		resetTheLanguageSelect(getDefaultLanguageId());
		populateTheFields(getDefaultLanguageId());
<%
	}
%>
</SCRIPT>
</BODY>
</HTML>
