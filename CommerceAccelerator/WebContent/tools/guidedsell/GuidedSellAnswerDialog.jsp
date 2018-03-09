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
			com.ibm.commerce.pa.tools.guidedsell.utils.GuidedSellHelper,
			com.ibm.commerce.pa.tools.guidedsell.beans.GuidedSellAnswerLoaderBean,
			com.ibm.commerce.pa.tools.guidedsell.containers.GuidedSellAnswerData,
			com.ibm.commerce.pa.tools.guidedsell.containers.GuidedSellConstraintData,
			java.util.Hashtable,java.util.Enumeration,
			java.util.Vector" %>

<%@include file="/tools/guidedsell/GuidedSellCommon.jsp" %>
<%
	String gsLanguageId = UIUtil.toHTML(request.getParameter(GuidedSellUIConstants.GS_LANGUAGE_ID));
	String categoryId = UIUtil.toHTML(request.getParameter(GuidedSellUIConstants.GS_CATEGORY_ID));
	String treeId = UIUtil.toHTML(request.getParameter(GuidedSellUIConstants.GS_TREE_ID));
	String conceptId = UIUtil.toHTML(request.getParameter(GuidedSellUIConstants.GS_CONCEPT_ID));
	String parentConceptId = UIUtil.toHTML(request.getParameter(GuidedSellUIConstants.GS_PARENT_CONCEPT_ID));
	String createNew = UIUtil.toHTML(request.getParameter(GuidedSellUIConstants.GSA_CREATE_NEW));
	String defaultLanguageId = gsCommandContext.getStore().getLanguageId();

	if(createNew == null || createNew.trim().length() == 0){
		createNew = "true";
	}

	if(createNew != null && createNew.trim().length() != 0 && createNew.trim().equals("true")){
		parentConceptId = conceptId;
	}

	boolean searchSpaceExists = (new GuidedSellHelper()).isSearchSpaceDefined(categoryId);

	String urlAnswerPrefix = "/webapp/wcs/tools/servlet/GSAnswerDetailView?";
	urlAnswerPrefix += GuidedSellUIConstants.GS_CONCEPT_ID+"="+conceptId;
	urlAnswerPrefix += "&"+GuidedSellUIConstants.GS_PARENT_CONCEPT_ID+"="+parentConceptId;
	urlAnswerPrefix += "&"+GuidedSellUIConstants.GSA_CREATE_NEW+"="+createNew;
	String urlAnswer = urlAnswerPrefix + "&" + GuidedSellUIConstants.GSA_LANGUAGE_ID+"="+defaultLanguageId;

	String urlConstraintPrefix = "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=guidedSell.GuidedSellConstraintList";
	urlConstraintPrefix += "&cmd=GSConstraintListView";
	urlConstraintPrefix += "&"+GuidedSellUIConstants.GS_CATEGORY_ID+"="+categoryId;
	String urlConstraint = urlConstraintPrefix + "&"+GuidedSellUIConstants.GSA_LANGUAGE_ID+"="+defaultLanguageId;
%>
<HTML>
<HEAD>
 <%= fHeader %>
<TITLE><%=guidedSellRB.get(GuidedSellUIConstants.GSQD_NAME)%></TITLE>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/ConvertToXML.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/guidedsell/gscommon.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/guidedsell/gsconstraintfns.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/guidedsell/gsanswerdetailfns.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">

<%
	if(createNew.trim().equals("false")){
%>
	top.put("submitFinishMessageAnswer","<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSCA_SUCCESSFUL_MSG)%>");
	top.put("submitErrorMessageAnswer","<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSCA_FAILED_MSG)%>");
	var answerDataVector = getVectorOfAnswers();
	if(size(answerDataVector) == 0){
<%
		GuidedSellAnswerLoaderBean gsalb = new GuidedSellAnswerLoaderBean();
		DataBeanManager.activate(gsalb,request);
		Vector answerData = gsalb.getAnswerData();
		Hashtable constraints = gsalb.getConstraints();
		GuidedSellAnswerData ansData = null;
		if(answerData != null && !answerData.isEmpty()){
			int length = answerData.size();
			for(int i=0;i<length;i++){
				ansData = (GuidedSellAnswerData)answerData.elementAt(i);
%>
				createAnswerObject('<%=UIUtil.toJavaScript(ansData.getLanguageId())%>','<%=UIUtil.toJavaScript(ansData.getConceptName())%>','<%=UIUtil.toJavaScript(ansData.getElaboration())%>');
<%
			}
		}
%>
		setForChange(true);
<%
		if(constraints != null && !constraints.isEmpty()){
			int rowId = 0;
			Enumeration enum1 = constraints.keys();
			while(enum1.hasMoreElements()){
				Hashtable cnsHash = (Hashtable)constraints.get((String)enum1.nextElement());
				if(cnsHash != null && !cnsHash.isEmpty()){
					GuidedSellConstraintData cnsData = (GuidedSellConstraintData)cnsHash.get(defaultLanguageId);
%>
					addNewConstraint('<%=cnsData.getFeatureId()%>','<%=UIUtil.toJavaScript(cnsData.getFeatureColumn())%>','<%=cnsData.getOperator()%>','<%=cnsData.getLanguageId()%>','<%=UIUtil.toJavaScript(cnsData.getFeatureName())%>','<%=UIUtil.toJavaScript(cnsData.getOperatorName())%>','<%=UIUtil.toJavaScript(cnsData.getUnformattedFeatureValue())%>','<%=UIUtil.toJavaScript(cnsData.getFeatureValue())%>');
<%
				}

				Enumeration enu = cnsHash.keys();
				while(enu.hasMoreElements()){
					String key = (String)enu.nextElement();
					if(!key.trim().equals(defaultLanguageId)){
					GuidedSellConstraintData cnsData = (GuidedSellConstraintData)cnsHash.get(key);
%>
					modifyConstraint('<%=cnsData.getFeatureId()%>','<%=rowId%>','<%=cnsData.getLanguageId()%>','<%=UIUtil.toJavaScript(cnsData.getFeatureName())%>','<%=UIUtil.toJavaScript(cnsData.getOperatorName())%>','<%=UIUtil.toJavaScript(cnsData.getUnformattedFeatureValue())%>','<%=UIUtil.toJavaScript(cnsData.getFeatureValue())%>');
<%
					}
				}
				rowId++;
			}
		}
%>
		setForChange(false);
	}//script if ends
<%
	}
%>
function visibleList(s){
   if (this.answerdetailfrm.visibleList){
      this.answerdetailfrm.visibleList(s);
   }
   if (this.gsframe.basefrm.visibleList){
      this.gsframe.basefrm.visibleList(s);
   }
}

function loadPanelData(){
	gsModifyBCT(<%=(gsLanguageId == null ? null : UIUtil.toJavaScript(gsLanguageId))%>);
	parent.setContentFrameLoaded(true);
	if(!isSearchSpaceDefined()){
		disableButton(gsframe.buttons.buttonForm.newConstraintButtonButton);
	} else {
		enableButton(gsframe.buttons.buttonForm.newConstraintButtonButton);
	}
}

function unloadPanelData(){
	top.remove("questionArray");
	setTableOfFeatures(null);
}

function isSearchSpaceDefined(){
	return <%=searchSpaceExists%>;
}

var saved = false;
function savePanelData(){
	if(answerdetailfrm.createUpdateTheData()){
		var xml = '<Answer>\n';
		xml += "<treeId><%=UIUtil.toJavaScript(treeId)%></treeId>\n";
		xml += "<createNew><%=UIUtil.toJavaScript(createNew)%></createNew>\n";
		<%
			if(createNew.equals("true")){
		%>
		xml += '<parentConceptId><%=UIUtil.toJavaScript(parentConceptId)%></parentConceptId>\n';
		<%
			} else {
		%>
		xml += '<conceptId><%=UIUtil.toJavaScript(conceptId)%></conceptId>\n';
		<%
			}
		%>
		var answers = getVectorOfAnswers();
		xml += generateXML(answers,"answerData",null);
		var constraints = getVectorOfConstraints();
		xml += generateXML(constraints,"constraintData",null);
		xml += '</Answer>\n';
		parent.put('<%=GuidedSellUIConstants.GSA_XML_FILE_OBJECT%>',xml);
		saved = true;
	}	
}

function validateNoteBookPanel(){
	return validatePanelData();
}

function validatePanelData(){
    if(!saved){
	return false;
    }	 
    var answer = this.answerdetailfrm.answerForm.answer.value; 
    var description = this.answerdetailfrm.answerForm.description.value;
    var length = this.answerdetailfrm.answerForm.description.value.length;
    top.remove("pathId");
        
    if (this.answerdetailfrm.answerForm.description.value.length > 512){
		    reprompt(this.answerdetailfrm.answerForm.description, "<%= getNLString(guidedSellRB,GuidedSellUIConstants.GSA_LONG_ANSWER_DESC_MSG)%>");
		    return false;
	}
    
    
    return true;
}

function getDefaultLanguageId(){
	var dLangId = '<%= gsCommandContext.getStore().getLanguageId()%>';
	return dLangId;
}

function reloadConstraint(langId){
	if(langId != null){
		var url = '<%=UIUtil.toJavaScript(urlConstraintPrefix)%>';
		url += "&<%=GuidedSellUIConstants.GSA_LANGUAGE_ID%>="+langId;
		top.showProgressIndicator(true);
		gsframe.basefrm.location.replace(url);
	}
}

setLanguageBeforeSelection(getDefaultLanguageId());

</SCRIPT>
</HEAD>
<frameset framespacing="0" border="0" frameborder="0" rows="45%,45,*" onLoad="loadPanelData();" onUnload="unloadPanelData();">
	<frame src="<%=urlAnswer%>" name="answerdetailfrm" title="<%=guidedSellRB.get(GuidedSellUIConstants.GS_ANSWER_DETAIL_FRAME)%>"/>
    <frame src="/webapp/wcs/tools/servlet/tools/guidedsell/GuidedSellConstraintTitle.jsp" name="GuidedSellConstraintTitle" frameborder ="0" title="none"  scrolling="no"  noresize/>
	<frame src="<%=urlConstraint%>" name="gsframe" title="<%=guidedSellRB.get(GuidedSellUIConstants.GS_CONSTRAINT_FRAME)%>"/>
</frameset>
</HTML>
