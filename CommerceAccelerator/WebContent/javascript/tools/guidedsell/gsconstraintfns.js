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

function getTableOfFeatures(){
	var features = top.get("featureArray",null);
	if(features == null){
		features = new Array();
	}
	return features;
}

function setTableOfFeatures(features){
	top.put("featureArray",features);
	if(features == null){
		top.remove("featureArray");
	}
}

function setTheConstraintData(data){
	var object = getTableOfFeatures();
	object[(object.length)++] = data;
	setTableOfFeatures(object);
}

function getTheConstraintData(featureId){
	var object = getTableOfFeatures();
	var olength = object.length;
	for(var i=0;i<olength;i++){
		var obj = object[i];
		if(obj.featureId == featureId){
			return obj;			
		} 
	}
	return null;
}

function getVectorOfConstraints(){
	var constraints = top.get("constraintData",null);
	if(constraints == null){
		constraints = new Vector();
	}
	return constraints;
}

var forChange=false;
function setForChange(value){
	forChange = value;
}

function setVectorOfConstraints(constraints){
	top.put("constraintData",constraints);
	if(!forChange) {
		gsframe.basefrm.updateConstraintList('constraintValueList');
	}
	if(constraints == null){
		top.remove("constraintData");
	}
}

function setConstraint(object,rowId){
	var constraints = getVectorOfConstraints();
	var length = size(constraints);
	var added = false;
	for(var i=0;i<length;i++){
		var obj = elementAt(i,constraints);
		if(i == parseInt(rowId) && obj.featureId == object.featureId){
			added = true;
			removeElementAt(i,constraints);
			if(i != length-1){
				insertElementAt(object,i,constraints);
			} else {
				addElement(object,constraints);
			}
			break;
		}
	}

	if(!added){
		addElement(object,constraints);
	}

	setVectorOfConstraints(constraints);
}

function getConstraint(featureId,rowId){
	var constraints = getVectorOfConstraints();
	var length = size(constraints);
	for(var i=0;i<length;i++){
		var obj = elementAt(i,constraints);
		if(i == parseInt(rowId) && obj.featureId == featureId){
			return obj;
		}
	}
	return null;
}

function addNewConstraint(featureId,featureColumn,operator,languageId,featureName,operatorName,featureValue,displayFeatureValue){
	var constraint = new Object();

	constraint.featureId = featureId;
	constraint.featureColumn = featureColumn;
	constraint.operator = operator;
	constraint.referenceValue = displayFeatureValue;
	constraint.featureName = featureName;
	constraint.operatorName = operatorName;

	constraint.values = new Object();
	constraint.values['languageId_'+languageId] = new Object();
	constraint.values['languageId_'+languageId].valueLanguageId = languageId;
	constraint.values['languageId_'+languageId].featureValue = featureValue;
	constraint.values['languageId_'+languageId].displayFeatureValue = displayFeatureValue;

	setConstraint(constraint,'-1');
}

function modifyConstraint(featureId,rowId,languageId,featureName,operatorName,featureValue,displayFeatureValue){
	var constraint = getConstraint(featureId,rowId);

	if(languageId == getDefaultLanguageId()){
		constraint.referenceValue = displayFeatureValue;
	}
	if(constraint.values['languageId_'+languageId] == null){
		constraint.values['languageId_'+languageId] = new Object();
		constraint.values['languageId_'+languageId].valueLanguageId = languageId;
	}
	constraint.values['languageId_'+languageId].featureValue = featureValue;
	constraint.values['languageId_'+languageId].displayFeatureValue = displayFeatureValue;

	setConstraint(constraint,rowId);
}

function removeTheConstraint(featureId,rowId){
	var constraints = getVectorOfConstraints();
	var length = size(constraints);
	for(var i=0;i<length;i++){
		var obj = elementAt(i,constraints);
		if(i==parseInt(rowId) && obj.featureId == featureId){
			removeElementAt(i,constraints);
			break;
		}
	}
	setVectorOfConstraints(constraints);
}