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

// @deprecated The Product Advisor feature has been deprecated. For more information, see <a href="../../../../../../com.ibm.commerce.productadvisor.doc/concepts/cpaintro.htm">Product Advisor</a>.

//the language id of the constraints page
var gsConstraintLanguageId='';
function setConstraintLanguageId(langId){
	gsConstraintLanguageId = langId;
}

function getConstraintLanguageId(){
	return gsConstraintLanguageId;
}

var selectOneText = '';
function setSelectOneText(sOneText){
	selectOneText = sOneText;
}

function disableAllButtons(){
	disableButton(parent.buttons.buttonForm.newConstraintButtonButton);
	disableButton(parent.buttons.buttonForm.changeConstraintButtonButton);
	disableButton(parent.buttons.buttonForm.deleteConstraintButtonButton);
}

function enableAllButtons(){
	enableButton(parent.buttons.buttonForm.newConstraintButtonButton);
	enableButton(parent.buttons.buttonForm.changeConstraintButtonButton);
	enableButton(parent.buttons.buttonForm.deleteConstraintButtonButton);
}

function displayTheAddFields(){
	this.addConstraintTable.rows[1].cells[0].innerHTML = getFeatureNames();
	this.addConstraintTable.rows[1].cells[1].innerHTML = getOperatorSelect(0);
	generateAddButtons();
	this.addConstraintSpan.style.display = 'inline';
}

function hideTheAddFields(){
	this.addConstraintTable.rows[1].cells[0].innerHTML = '';
	this.addConstraintTable.rows[1].cells[1].innerHTML = '';
	this.addConstraintTable.rows[1].cells[2].innerHTML = '';
	this.addConstraintSpan.style.display = 'none';
	destoryAddButtons();
}

function getTheDataForDefaultSelect(featureId,rowId,languageId){
	var constraint = parent.parent.getConstraint(featureId,rowId);
	if(constraint.values['languageId_'+languageId] != null){
		if(constraint.values['languageId_'+languageId].featureValue != null && (rtrim(ltrim(constraint.values['languageId_'+languageId].featureValue))).length != 0){
			return constraint.values['languageId_'+languageId].featureValue;
		}
	}
	return null;
}

function displayTheChangeFields(){
	var checked = parent.getChecked();
	var params = checked[0].split(';');
	var rowId = params[0];
	var featureId = params[1];
	var data = parent.parent.getTheConstraintData(featureId);
	updateFeatureValues(this.changeConstraintTable,1,0,data,getTheDataForDefaultSelect(featureId,rowId,getConstraintLanguageId()));
	generateChangeButtons();
	this.changeConstraintSpan.style.display = 'inline';
}

function hideTheChangeFields(){
	this.changeConstraintTable.rows[1].cells[0].innerHTML = '';
	this.changeConstraintSpan.style.display = 'none';
	destoryChangeButtons();
}

function getFeatureNames(){
	var features = parent.parent.getTableOfFeatures();
	var flength = features.length;
	var featSelect = "<SELECT NAME='featureNames' onChange='featureNameSelect(this);'>\n";
	for(var i=0;i<flength;i++){
		var data = features[i];
		if(i==0){
			featSelect += "<OPTION VALUE=\""+data.featureId+";"+data.featureColumnName+";"+data.featureDisplayName+"\" SELECTED>"+data.featureDisplayName+"</OPTION>\n";
			updateFeatureValues(this.addConstraintTable,1,2,data,null);
		} else {
			featSelect += "<OPTION VALUE=\""+data.featureId+";"+data.featureColumnName+";"+data.featureDisplayName+"\">"+data.featureDisplayName+"</OPTION>\n";
		}
	}
	featSelect += "</SELECT>";
	return featSelect;
}

function updateFeatureValues(tableName,rowNo,cellNo,data,defaultSelect){
	var values = null;
	var ufvalues = null;
	if(data != null){
		values = data.featureValues;
		ufvalues = data.unformattedFeatureValues;
	} else {
		values = new Array();
		ufvalues = new Array();
	}
	var vlength = values.length;
	var valSelect = "<SELECT NAME='featureValues'>\n";
	if(defaultSelect == null){
		valSelect += "<OPTION VALUE='NOTHING_SELECTED' SELECTED>"+selectOneText+"</OPTION>\n";
	} else {
		valSelect += "<OPTION VALUE='NOTHING_SELECTED'>"+selectOneText+"</OPTION>\n";
	}
	for(var i=0;i<vlength;i++){
		if(defaultSelect != null && defaultSelect == ufvalues[i]){
			valSelect += "<OPTION VALUE=\""+ufvalues[i]+"\" SELECTED>"+values[i]+"</OPTION>\n";
		} else {
			valSelect += "<OPTION VALUE=\""+ufvalues[i]+"\">"+values[i]+"</OPTION>\n";
		}
	}
	valSelect += "</SELECT>";
	tableName.rows[rowNo].cells[cellNo].innerHTML = valSelect;
}

function featureNameSelect(fNameSelect){
	var fSelValue = fNameSelect.options[fNameSelect.options.selectedIndex].value;
	if(fSelValue != null){
		var params = fSelValue.split(';');
		var featureId = params[0];
		var data = parent.parent.getTheConstraintData(featureId);
		updateFeatureValues(this.addConstraintTable,1,2,data,null);
	}
}

function getSelectedFeatureValue(){
	return this.guidedSellConstraintForm.featureValues.options[this.guidedSellConstraintForm.featureValues.options.selectedIndex].value;
}

function getSelectedDisplayFeatureValue(){
	return this.guidedSellConstraintForm.featureValues.options[this.guidedSellConstraintForm.featureValues.options.selectedIndex].text;
}

function getSelectedFeatureName(){
	return this.guidedSellConstraintForm.featureNames.options[this.guidedSellConstraintForm.featureNames.options.selectedIndex].value;
}

function getSelectedOperator(){
	return this.guidedSellConstraintForm.operator.options[this.guidedSellConstraintForm.operator.options.selectedIndex].value;
}

function addNewConstraint(){
	var featureValue = getSelectedFeatureValue();
	var displayFeatureValue = getSelectedDisplayFeatureValue();
	var featureNameParam = getSelectedFeatureName();
	var operatorParam = getSelectedOperator();
	var fvalues = featureNameParam.split(';');
	var featureId = fvalues[0];
	var featureColumn = fvalues[1];
	var featureName = fvalues[2];
	var languageId = getConstraintLanguageId();
	var ovalues = operatorParam.split(';');
	var operator = ovalues[0];
	var operatorName = ovalues[1];
	parent.parent.addNewConstraint(featureId,featureColumn,operator,languageId,featureName,operatorName,featureValue,displayFeatureValue);
}

function modifyConstraint(){
	var featureValue = getSelectedFeatureValue();
	var displayFeatureValue = getSelectedDisplayFeatureValue();
	var checked = parent.getChecked();
	var params = checked[0].split(';');
	var rowId = params[0];
	var featureId = params[1];
	parent.parent.modifyConstraint(featureId,rowId,getConstraintLanguageId(),'','',featureValue,displayFeatureValue);
}

//clears the dlist
function clearConstraintList(tableid){
	while(eval(tableid).rows.length>1){
		delRow(tableid,1);
	}
}

//added for defect 56194
function getNLConstraintName(featureId, nonNLFeatureName){
	var nlFeatures = parent.parent.getTableOfFeatures();
	var flength = nlFeatures.length;
	for(var i=0;i<flength;i++){
		var data = nlFeatures[i];
		if(data.featureId == featureId)
		{
		  return data.featureDisplayName;
		}
	}
	return nonNLFeatureName;	
}		

function getNLOperatorName(index)
{

	var opValArray = getOpValArray();
	return opValArray[index];
}
    //end of add 	


//creates or updates the dlist table
function updateConstraintList(tableid){
	var languageId = getConstraintLanguageId();
	var vector = parent.parent.getVectorOfConstraints();
	var length = size(vector);

	if(length >= 0){
		resetTheCheckedValue();
	}
	
	clearConstraintList(tableid);
	
	var dlistRowIndex = 1;
	for(var i=0;i<length;i++){
		var obj = elementAt(i,vector);
		var checkName = i+";"+obj.featureId;
		insRow(tableid,dlistRowIndex);
		insCheckBox(tableid,dlistRowIndex,0,checkName,"parent.setChecked();myRefreshButtons()",i);
		//Commented for defect 56194
		//insCell(tableid,dlistRowIndex,1,obj.featureName);
		insCell(tableid,dlistRowIndex,1,getNLConstraintName(obj.featureId,obj.featureName));
		//insCell(tableid,dlistRowIndex,2,obj.operatorName);
		insCell(tableid,dlistRowIndex,2,getNLOperatorName(parseInt(obj.operator)));
		insCell(tableid,dlistRowIndex,3,obj.referenceValue);
		var dfeatValue = '';
		if(obj.values['languageId_'+languageId] != null && obj.values['languageId_'+languageId].featureValue != null){
			dfeatValue= obj.values['languageId_'+languageId].displayFeatureValue;
		}
		insCell(tableid,dlistRowIndex,4,dfeatValue);
		dlistRowIndex++;
	}
}

function checkSort(a,b){
	var a1 = parseInt((a.split(';'))[0]);
	var b1 = parseInt((b.split(';'))[0]);
	if(a1<b1) return -1;
	if(a1>b1) return 1;
	return 0;
}

function deleteTheConstraints(){
	var checked = parent.getChecked();
	var length = checked.length;
	if(length == 0){
		return;
	}

	checked.sort(checkSort);

	var constraints = parent.parent.getVectorOfConstraints();
	for(var i=length-1;i>=0;i--){
		var params = checked[i].split(';');
		var rowId = params[0];
		removeElementAt(parseInt(rowId),constraints);
	}

	parent.parent.setVectorOfConstraints(constraints);
}

var oldCheckedValues = null;
function setOldCheckedValues(checked){
	oldCheckedValues = checked;
}

function getOldCheckedValues(){
	return oldCheckedValues;
}

function resetTheCheckedValue(){
	var elength = document.guidedSellConstraintForm.elements.length;
	var ocvals = getOldCheckedValues();
	if(ocvals == null){
		return;
	}
	var oclength = ocvals.length;
	for(var i=0;i<oclength;i++){
		var oname = ocvals[i];
		for(var j=0;j<elength;j++){
			var e = document.guidedSellConstraintForm.elements[j];
			if(e.type == 'checkbox' && e.name != 'select_deselect'){
				if(e.name == oname && e.checked){
					e.click();
				}
			}
		}
	}
}

function disableCheckBoxes(form){
	var length = form.elements.length;
	for(var i=0;i<length;i++){
		var e = form.elements[i];
		if(e.type == 'checkbox'){
			e.disabled=true;
		}
	}
}

function enableCheckBoxes(form){
	var length = form.elements.length;
	for(var i=0;i<length;i++){
		var e = form.elements[i];
		if(e.type == 'checkbox'){
			e.disabled=false;
		}
	}
} 

function disableFrames(){
	disableAllButtons();
	disableCheckBoxes(this.guidedSellConstraintForm);
	disableElements(parent.parent.answerdetailfrm.answerForm);
}

function enableFrames(){
	enableElements(parent.parent.answerdetailfrm.answerForm);
	enableCheckBoxes(this.guidedSellConstraintForm);
	enableAllButtons();
	myRefreshButtons();
}

function cancelAddButtonAction(){
	hideTheAddFields();
	enableFrames();
}

function cancelChangeButtonAction(){
	hideTheChangeFields();
	enableFrames();
}

function uncheckConstraintList(){
	var length = this.guidedSellConstraintForm.elements.length;
	for(var i=0;i<length;i++){
		var e = this.guidedSellConstraintForm.elements[i];
		if(e.type == 'checkbox' && e.name != 'select_deselect'){
			if(e.checked){
				e.click();
			}
		}
	}
}

function checkConstraintList(checked){
	if(checked != null && checked.length != 0){
		var length = this.guidedSellConstraintForm.elements.length;
		for(var i=0;i<length;i++){
			var e = this.guidedSellConstraintForm.elements[i];
			for(var j=0;j<checked.length;j++){		
				if(e.type == 'checkbox' && e.name != 'select_deselect' && e.name == checked[j]){
					if(!e.checked){
						e.click();
					}
				}
			}
		}
	}
}
