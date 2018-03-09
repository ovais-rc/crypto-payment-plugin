<!--
//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002, 2003
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
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page language="java" 
	  import="	com.ibm.commerce.beans.DataBeanManager,
			com.ibm.commerce.tools.util.*,
			com.ibm.commerce.tools.common.ui.taglibs.*,
			com.ibm.commerce.tools.common.ui.taglibs.*,
			com.ibm.commerce.pa.tools.guidedsell.utils.GuidedSellUIConstants,
			com.ibm.commerce.pa.tools.guidedsell.beans.GuidedSellAllLanguageLoaderBean,
			com.ibm.commerce.pa.tools.guidedsell.utils.GuidedSellHelper,
			java.util.Vector" %>

<%@include file="/tools/guidedsell/GuidedSellCommon.jsp" %>
<%
	String gsAnswerLanguageId = request.getParameter(GuidedSellUIConstants.GSA_LANGUAGE_ID);
	String conceptId = request.getParameter(GuidedSellUIConstants.GS_CONCEPT_ID);
	String parentConceptId = request.getParameter(GuidedSellUIConstants.GS_PARENT_CONCEPT_ID);
	String createNew = request.getParameter(GuidedSellUIConstants.GSA_CREATE_NEW);

	if(createNew != null && createNew.trim().length() != 0 && createNew.trim().equals("true")){
		parentConceptId = conceptId;
	}	

	GuidedSellAllLanguageLoaderBean gsallb = new GuidedSellAllLanguageLoaderBean();
	DataBeanManager.activate(gsallb,request);
	Vector vectIds =  gsallb.getAllLanguageIds();
	Vector vectDescs =  gsallb.getAllLanguageDescriptions();
%>
<HTML>
<HEAD>
 <%= fHeader %>
<%
	if(createNew.trim().equals("false")){
%>
<TITLE><%= guidedSellRB.get(GuidedSellUIConstants.GSA_CHANGE_NAME)%></TITLE>
<%
	} else {
%>
<TITLE><%= guidedSellRB.get(GuidedSellUIConstants.GSA_NAME)%></TITLE>
<%
	}
%>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/guidedsell/gscommon.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<%
	if(vectIds != null){
		int vlength = vectIds.size();
		GuidedSellHelper helper = new GuidedSellHelper();
		for(int i=0;i<vlength;i++){
			String langID = (String)vectIds.elementAt(i);
			String question = null;
			try{
				question = helper.getConceptDescription(new Integer(parentConceptId),new Integer(langID));
			}catch(Exception e){
				question = (String)guidedSellRB.get(GuidedSellUIConstants.GS_UNDEFINED);
			}
%>
		parent.setQuestionForLanguage("<%=UIUtil.toJavaScript(question)%>","<%=UIUtil.toJavaScript(langID)%>");
<%
		}
	}
%>
function visibleList(s){
   if (this.answerForm.listSelect)
   {
      this.answerForm.listSelect.style.visibility = s;
   }
}

function createUpdateTheData(){
	var answer = this.answerForm.answer.value;
	var returnValue = false;
	if(answer != null && (answer = rtrim(ltrim(answer))).length != 0){
		var object = parent.getObjectForTheLanguage(parent.getLanguageBeforeSelection());
		if(object == null){
			parent.createNewObject(parent.getLanguageBeforeSelection());
		} else {
			parent.modifyTheObject(parent.getLanguageBeforeSelection());
		}
		returnValue = true;
	} else {
		if(parent.getLanguageBeforeSelection() == parent.getDefaultLanguageId()){
			parent.resetTheLanguageSelect(parent.getDefaultLanguageId());
			alertDialog("<%= getNLString(guidedSellRB,GuidedSellUIConstants.GSA_DEFAULT_LANGUAGE_REQUIRED_MSG)%>");
			returnValue = false;
		} else {
			if(parent.checkIfConstraintsDefinedLanguage()){
				parent.resetTheLanguageSelect(parent.getLanguageBeforeSelection());
				alertDialog("<%= getNLString(guidedSellRB,GuidedSellUIConstants.GSA_REQUIRED_FOR_CONSTRAINT_MSG)%>");
				returnValue = false;
			} else {
				parent.removeTheObject(parent.getLanguageBeforeSelection());
				returnValue = true;
			}
		}
	}

	return returnValue;
}

function languageListSelect(selSelectedObject){
	var selValue = selSelectedObject.options[selSelectedObject.selectedIndex].value;
	if(selValue != null){
		if(createUpdateTheData()){
			if(parent.isAnswerDefinedForDefaultLanguage()){
				if(parent.doesLanguageIdExistInList(selValue)){
					parent.populateTheFields(selValue);
				} else {
					parent.clearAllFields();
				}
				parent.setTheQuestionText(selValue);
				parent.displayTheReference();
				parent.refreshTheConstraintButtons(selValue);
				parent.reloadConstraint(selValue);
				parent.setLanguageBeforeSelection(selValue);
			}
		}
	}
}

function initForm(){
	parent.setTheQuestionText(parent.getDefaultLanguageId());
	parent.resetTheLanguageSelect(parent.getDefaultLanguageId());
	parent.populateTheFields(parent.getDefaultLanguageId());
}

function unLoadForm(){
//	parent.setVectorOfAnswers(null);
	top.remove("questionArray");
}
</SCRIPT>
</HEAD>
<BODY class="content" onLoad="initForm();" onUnload="unLoadForm();">
<SPAN style="font-family: Verdana,Arial,Helvetica; font-size: 16pt; color: #565665; font-weight: normal; word-wrap: break-word;">
<%
	if(createNew.trim().equals("false")){
%>
<%= guidedSellRB.get(GuidedSellUIConstants.GSA_CHANGE_NAME)%>
<%
	} else {
%>
<%= guidedSellRB.get(GuidedSellUIConstants.GSA_NAME)%>
<%
	}
%>
</SPAN>
<FORM NAME="answerForm" OnSubmit="return false;">
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
				if(langID.equals(gsAnswerLanguageId)) {
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
	<TD ALIGN="LEFT" VALIGN="TOP">
	      <SPAN ID="questionNameSpan">
      	  <TABLE ID="questionNameTable" CELLPADDING=0 CELLSPACING=0 BORDER=0>
	          <TR>
      	      <TD>
	            </TD>
	         </TR>
      	 </TABLE>
  	     </SPAN>
	</TD>
</TR>
<TR>
	<TD ALIGN="LEFT" VALIGN="TOP">
		<label for="answer_input"><%=guidedSellRB.get(GuidedSellUIConstants.GSA_REQUIRED_LABEL)%></label>
	</TD>
</TR>
<TR>
	<TD ALIGN="LEFT" VALIGN="TOP">
		<INPUT TYPE="TEXT" id="answer_input" NAME="answer" VALUE="" SIZE="60" MAXLENGTH="512"><BR>
	</TD>
	<TD ALIGN="LEFT" VALIGN="TOP">
	      <SPAN ID="referenceAnswerNameSpan" STYLE="display=none">
      	  <TABLE ID="referenceAnswerNameTable" CELLPADDING=0 CELLSPACING=0 BORDER=0>
	          <TR>
      	      <TD>
				<%= guidedSellRB.get(GuidedSellUIConstants.GSA_REFERENCE)%> : 
	            </TD>
      	      <TD>
	            </TD>
	         </TR>
      	 </TABLE>
  	     </SPAN>
	</TD>
</TR>

<TR>
	<TD ALIGN="LEFT" VALIGN="TOP">
		<label for="description_input"><%= guidedSellRB.get(GuidedSellUIConstants.GSA_DESCRIPTION_LABEL)%></label>
	</TD>
</TR>
<TR>
	<TD ALIGN="LEFT" VALIGN="TOP">
		<TEXTAREA id="description_input" NAME="description" COLS="50" ROWS="3" WRAP="HARD"></TEXTAREA><BR>
	</TD>
</TR>
</TABLE>
</FORM>
</BODY>
</HTML>
