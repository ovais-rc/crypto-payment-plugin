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
			com.ibm.commerce.common.objects.*,
			com.ibm.commerce.pa.tools.guidedsell.utils.GuidedSellUIConstants,
			com.ibm.commerce.pa.tools.guidedsell.beans.GuidedSellConstraintListDataBean,
			com.ibm.commerce.pa.tools.guidedsell.containers.GuidedSellConstraintListData,
			java.util.Vector" %>

<%@include file="/tools/guidedsell/GuidedSellCommon.jsp" %>
<%
	String gsAnswerLanguageId = request.getParameter(GuidedSellUIConstants.GSA_LANGUAGE_ID);
	GuidedSellConstraintListDataBean gscldb = new GuidedSellConstraintListDataBean();
	DataBeanManager.activate(gscldb,request);
	Vector v = gscldb.getConstraintListData();
%>
<HTML>
<HEAD>
 <%= fHeader %>
<TITLE><%= guidedSellRB.get(GuidedSellUIConstants.GSA_CONSTRAINT_NAME)%></TITLE>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/guidedsell/gscommon.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/guidedsell/gsconstraintlistfns.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
setConstraintLanguageId('<%=UIUtil.toJavaScript(gsAnswerLanguageId)%>');
setSelectOneText("<%= getNLString(guidedSellRB,GuidedSellUIConstants.GSA_CONSTRAINT_SELECT_ONE)%>");
<%
	if(v != null && !v.isEmpty()){
		GuidedSellConstraintListData data = null;
		for(int i=0;i<v.size();i++){
			data = (GuidedSellConstraintListData)v.elementAt(i);
%>
			<%=UIUtil.toJS("data_"+i,data)%>
			parent.parent.setTheConstraintData(<%="data_"+i%>);
<%
		}
	}
%>
function visibleList(s){
   if (this.guidedSellConstraintForm.featureNames)
   {
      this.guidedSellConstraintForm.featureNames.style.visibility = s;
   }
   if (this.guidedSellConstraintForm.featureValues)
   {
      this.guidedSellConstraintForm.featureValues.style.visibility = s;
   }
   if (this.guidedSellConstraintForm.operator)
   {
      this.guidedSellConstraintForm.operator.style.visibility = s;
   }
}

function onLoad(){
	parent.loadFrames();
	updateConstraintList('constraintValueList');
	top.showProgressIndicator(false);
}

function unLoad(){
	parent.parent.setTableOfFeatures(null);
	uncheckConstraintList();
}

function myRefreshButtons(){
	var checked = parent.getChecked();
    var len = checked.length;
	if(!parent.parent.isSearchSpaceDefined()){
		disableAllButtons();
	} else {
		if(len > 0){
			if(getConstraintLanguageId() != parent.parent.getDefaultLanguageId()){
				disableAllButtons();
				if(len == 1){
					enableButton(parent.buttons.buttonForm.changeConstraintButtonButton);
				}
			} else {
				if(len == 1){
					enableButton(parent.buttons.buttonForm.changeConstraintButtonButton);
				} else {
					disableButton(parent.buttons.buttonForm.changeConstraintButtonButton);
				}
			}
			setOldCheckedValues(checked);
		} else {
			if(getConstraintLanguageId() != parent.parent.getDefaultLanguageId()){
				disableAllButtons();
			} else {
				disableAllButtons();
				enableButton(parent.buttons.buttonForm.newConstraintButtonButton);
			}
		}
	}
}

function getOperatorSelect(defaultSelect){
	var value = "<SELECT NAME='operator' > \n";
	var valArray = getOpValArray();
	for(var i=1;i<=4;i++){
		if(i == defaultSelect || i == parseInt(defaultSelect)){
			value += "<OPTION VALUE=\""+i+";"+valArray[i]+"\" SELECTED>"+valArray[i]+"</OPTION>\n";
		} else {
			value += "<OPTION VALUE=\""+i+";"+valArray[i]+"\" >"+valArray[i]+"</OPTION>\n";
		}
	}
	value += "</SELECT>";
	return value;
}

//added for defect 56194
function getOpValArray(){
	var valArray = new Array();
	<%
 		Hashtable gsRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("guidedSell.guidedSellRB", gsCommandContext.getLocale(new Integer(gsAnswerLanguageId)));	
		for(int i=1;i<=4;i++){
	%>
	valArray[<%=i%>] = "<%= getNLString(gsRB,"gsclOperator"+i)%>";
	<%
		}
	%>
	return valArray;
}
//function loadFeatures(){
//}
//add ends

function newConstraint(){
	if(isButtonDisabled(parent.buttons.buttonForm.newConstraintButtonButton)){
		return;
	}
	if(getConstraintLanguageId() != parent.parent.getDefaultLanguageId()){
		disableButton(parent.buttons.buttonForm.newConstraintButtonButton);
		return;
	}
	disableFrames();
	displayTheAddFields();
}

function changeConstraint(){
	if(isButtonDisabled(parent.buttons.buttonForm.changeConstraintButtonButton)){
		return;
	}
	disableFrames();
	displayTheChangeFields();
}

function deleteConstraint(){
	if(isButtonDisabled(parent.buttons.buttonForm.deleteConstraintButtonButton)){
		return;
	}
	if(confirmDialog("<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSA_CONSTRAINT_DELETE_CONFIRM_MSG)%>")){
		deleteTheConstraints();
	}
}

function addButtonAction(){
	var featureValue = getSelectedFeatureValue();
	if(featureValue == 'NOTHING_SELECTED'){
		alertDialog("<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSA_CONSTRAINT_NO_VALUE_SELECTED_MSG)%>");
		return;
	}
	addNewConstraint();
	hideTheAddFields();
	enableFrames();
	if(parent.getChecked() != null && parent.getChecked().length != 0) {
		checkConstraintList(parent.getChecked());
	}
}

function changeButtonAction(){
	var featureValue = getSelectedFeatureValue();
	if(featureValue == 'NOTHING_SELECTED'){
		alertDialog("<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSA_CONSTRAINT_NO_VALUE_SELECTED_MSG)%>");
		return;
	}
	modifyConstraint();
	hideTheChangeFields();
	enableFrames();
	if(parent.getChecked() != null && parent.getChecked().length != 0) {
		checkConstraintList(parent.getChecked());
	}
}

function initializeDynamicList(tableName) {
	startDlistTable(tableName,'100%');
	startDlistRowHeading();
	addDlistCheckHeading(true,'parent.selectDeselectAll();myRefreshButtons();');
	addDlistColumnHeading("<%= getNLString(guidedSellRB,GuidedSellUIConstants.GSA_CONSTRAINT_FEATURE)%>",true,null,null,null);
	addDlistColumnHeading("<%= getNLString(guidedSellRB,GuidedSellUIConstants.GSA_CONSTRAINT_OPERATOR)%>",true,null,null,null);
	addDlistColumnHeading("<%= getNLString(guidedSellRB,GuidedSellUIConstants.GSA_CONSTRAINT_REFERENCE_VALUE)%>",true,null,null,null);
	addDlistColumnHeading("<%= getNLString(guidedSellRB,GuidedSellUIConstants.GSA_CONSTRAINT_VALUE)%>",true,null,null,null);
	endDlistRowHeading();
	endDlistTable();
}

function generateAddButtons()
{
	idTDButtonAdd.innerHTML=" <BUTTON type='BUTTON' value='Add' name='addButton' CLASS='enabled' STYLE='width:auto;text-align:center' onClick=\"if(this.className=='enabled') addButtonAction();\" ><%= guidedSellRB.get(GuidedSellUIConstants.GSA_CONSTRAINT_ADD)%></BUTTON>";
	idTDButtonCancelAdd.innerHTML=" <BUTTON type='BUTTON' value='CancelAdd' name='cancelAddButton' CLASS='enabled' STYLE='width:auto;text-align:center' onClick=\"if(this.className=='enabled') cancelAddButtonAction();\"><%= guidedSellRB.get(GuidedSellUIConstants.GSA_CONSTRAINT_CANCEL_ADD)%></BUTTON> ";
}

function destoryAddButtons()
{
	idTDButtonAdd.innerHTML="";
	idTDButtonCancelAdd.innerHTML="";
}

function generateChangeButtons()
{
	idTDButtonChange.innerHTML=" <BUTTON type='BUTTON' value='Change' name='changeButton' CLASS='enabled' STYLE='width:auto;text-align:center' onClick=\"if(this.className=='enabled') changeButtonAction();\"><%= guidedSellRB.get(GuidedSellUIConstants.GSA_CONSTRAINT_CHANGE)%></BUTTON>";
	idTDButtonCancelChange.innerHTML=" <BUTTON type='BUTTON' value='CancelChange' name='cancelChangeButton' CLASS='enabled' STYLE='width:auto;text-align:center' onClick=\"if(this.className=='enabled') cancelChangeButtonAction();\"><%= guidedSellRB.get(GuidedSellUIConstants.GSA_CONSTRAINT_CANCEL_CHANGE)%></BUTTON>";
}

function destoryChangeButtons()
{
	idTDButtonChange.innerHTML="";
	idTDButtonCancelChange.innerHTML="";
}

</SCRIPT>
</HEAD>
<BODY ONLOAD="onLoad();" class="content" onUnload="unLoad();">
<FORM NAME="guidedSellConstraintForm" OnSubmit="return false;">
<TABLE width="95%" CELLPADDING=0 CELLSPACING=5 BORDER=0>
	<TR>
	<TD ALIGN="LEFT" VALIGN="TOP" >
		<SPAN ID="addConstraintSpan" STYLE="display=none">
      		<TABLE width="95%" ID="addConstraintTable" CELLPADDING=0 CELLSPACING=3 BORDER=0>
				<TR>
					<TD>
						<label for="feature_name"><%= guidedSellRB.get(GuidedSellUIConstants.GSA_CONSTRAINT_FEATURE)%></label>
					</TD>
					<TD>
						<label for="operator_name"><%= guidedSellRB.get(GuidedSellUIConstants.GSA_CONSTRAINT_OPERATOR)%></label>
					</TD>
					<TD>
						<label for="feature_value"><%= guidedSellRB.get(GuidedSellUIConstants.GSA_CONSTRAINT_VALUE)%></label>
					</TD>
				</TR>
				<TR>
					<TD>
					</TD>
					<TD>
					</TD>
					<TD>
					</TD>
					<TD>
					</TD>
					<TD>
						<TABLE CELLPADDING=0 CELLSPACING=0 BORDER=0>
	 						<TR>
								<TD ID="idTDButtonAdd">
									
								</TD>
							</TR>
						</TABLE>
					</TD>
					<TD>
						<TABLE CELLPADDING=0 CELLSPACING=0 BORDER=0>
	 						<TR>
								<TD ID="idTDButtonCancelAdd">
									
								</TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
			</TABLE>
		</SPAN>
	</TD>
	</TR>
	<TR>
	<TD ALIGN="LEFT" VALIGN="TOP" >
		<SPAN ID="changeConstraintSpan" STYLE="display=none">
      		<TABLE width="95%" ID="changeConstraintTable" CELLPADDING=0 CELLSPACING=0 BORDER=0>
				<TR>
					<TD>
						<label for="feature_value"><%= guidedSellRB.get(GuidedSellUIConstants.GSA_CONSTRAINT_VALUE)%></label>
					</TD>
				</TR>
				<TR>
					<TD>
					</TD>
					<TD>
						<TABLE CELLPADDING=0 CELLSPACING=0 BORDER=0>
	 						<TR>
								<TD ID="idTDButtonChange">
									
								</TD> 
							</TR>
						</TABLE>
					</TD>
					<TD>
						<TABLE CELLPADDING=0 CELLSPACING=0 BORDER=0>
	 						<TR>
								<TD ID="idTDButtonCancelChange">
									
								</TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
			</TABLE>
		</SPAN>
	</TD>
	</TR>
	<TR>
		<TD ALIGN="center" colspan="3">
			<SCRIPT>
		  	    initializeDynamicList('constraintValueList');
			</SCRIPT>
		</TD>
	</TR>
</TABLE>
</FORM>
<script language="JavaScript">
<!--
parent.afterLoads();
if(parent.buttons.buttonForm != null)
{
parent.selectDeselectAll();
myRefreshButtons();
//parent.parent.refreshTheConstraintButtons(getConstraintLanguageId());
}
//-->
</script>
</BODY>
</HTML>

