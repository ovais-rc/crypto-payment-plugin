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

//get the vector of answers
function getVectorOfAnswers(){
	var vector = top.get("answersVector",null);

	if(vector == null){
		vector = new Vector() ;
	} 

	return vector;
}

//set the vector of answers
function setVectorOfAnswers(vector){
	top.put("answersVector",vector);
	if(vector == null){
		top.remove("answersVector");
	}
}

//check if there is an object present for the language id
function doesLanguageIdExistInList(langId){
	var vector = getVectorOfAnswers();
	var length = size(vector);
	if(length == 0){
		return false;
	} else {
		for(var i=0;i<length;i++){
			var obj = elementAt(i,vector);
			if(obj.languageId == langId && !obj.removed) {
				return true;
			}
		}
		return false;
	}
}

//returns the object for the language id
function getObjectForTheLanguage(langId){
	var vector = getVectorOfAnswers();
	var length = size(vector);
	for(var i=0;i<length;i++){
		var obj = elementAt(i,vector);
		if(obj.languageId == langId && !obj.removed) {
			return obj;
		}
	}
	return null;
}

//adds the object to the vector
function setObjectForTheLanguage(object){
	var vector = getVectorOfAnswers();
	var length = size(vector);
	var added = false;
	for(var i=0;i<length;i++){
		var obj = elementAt(i,vector);
		if(obj.languageId == object.languageId) {
			added = true;
			removeElementAt(i,vector);
			addElement(object,vector);
			break;
		}
	}
	
	if(!added){
		addElement(object,vector);
	}

	setVectorOfAnswers(vector);
}


//populate the fields of the dialog
function populateTheFields(langId){
	var object = getObjectForTheLanguage(langId);
	if(object != null && !object.removed) {
		answerdetailfrm.answerForm.answer.value = object.conceptName;
		answerdetailfrm.answerForm.description.value = object.elaboration;
	} else {
		clearAllFields();
	}
}

//clears all fields of the dialog
function clearAllFields(){
	answerdetailfrm.answerForm.answer.value = "";
	answerdetailfrm.answerForm.description.value = "";
}

//modifies the object for the language
function modifyTheObject(langId){
	var object = getObjectForTheLanguage(langId);
	if(object != null && !object.removed) {
		object.conceptName = rtrim(ltrim(answerdetailfrm.answerForm.answer.value));
		object.elaboration = rtrim(ltrim(answerdetailfrm.answerForm.description.value));
		setObjectForTheLanguage(object);
	}
}

//creates the object for that language id 
function createNewObject(langId){
	var object = new Object();
	object.languageId = langId;
	object.removed = false;
	object.conceptName = rtrim(ltrim(answerdetailfrm.answerForm.answer.value));
	object.elaboration = rtrim(ltrim(answerdetailfrm.answerForm.description.value));

	setObjectForTheLanguage(object);
}

//removes the object from the vector
function removeTheObject(langId){
	var object = getObjectForTheLanguage(langId);
	if(object != null){
		object.conceptName = null;
		object.elaboration = null;
		object.removed = true;
		setObjectForTheLanguage(object);
	}
}

//returns the correct size of the vector
function getFinalVectorSize(object){
	var length = size(object);
	var originalLength = 0;
	for(var i=0;i<length;i++){
		var obj = elementAt(i,object);
		if(!obj.removed){
			originalLength++;
		}
	}

	return originalLength;
}

//function to reset the select box
function resetTheLanguageSelect(langId){
	var olength = answerdetailfrm.answerForm.listSelect.options.length;
	for(var i=0;i<olength;i++){
		var value = answerdetailfrm.answerForm.listSelect.options[i].value;
		if(value == langId){
			answerdetailfrm.answerForm.listSelect.options[i].selected = true;
		}
	}
}	

//fucntion that checks if qustion is defined for default language
function isAnswerDefinedForDefaultLanguage(){
	var selected = answerdetailfrm.answerForm.listSelect.options[answerdetailfrm.answerForm.listSelect.options.selectedIndex].value;
	if(selected != null){
		if(selected == getDefaultLanguageId()){
			return true;
		} else {
			var object = getObjectForTheLanguage(getDefaultLanguageId());
			return (object != null);
		}
	} else {
		return false;
	}
}

//sets the question for the language
function setQuestionForLanguage(question,langId){
	var questionObject = top.get("questionObject",null);
	if(questionObject == null){
		questionObject = new Object();
	}
	questionObject[langId] = question;
	top.put("questionObject",questionObject);
}

//gets the question for the language
function getQuestionForLanguage(langId){
	var questionObject = top.get("questionObject",null);
	if(questionObject == null){
		return "";
	}
	var question = questionObject[langId];
	if(question != null){
		return question;
	} else {
		return "";
	}
}

//sets the text for question
function setTheQuestionText(langID){
	var question = getQuestionForLanguage(langID);
	answerdetailfrm.questionNameTable.rows[0].cells[0].innerHTML = "<i>"+question+"</i>";
}

//displays the reference
function displayTheReference(){
	var selected = answerdetailfrm.answerForm.listSelect.options[answerdetailfrm.answerForm.listSelect.options.selectedIndex].value;
	if(selected != null){
		if(selected != getDefaultLanguageId()){
			var answerObject = getObjectForTheLanguage(getDefaultLanguageId());
			if(answerObject != null){
				var answer = answerObject.conceptName;
				answerdetailfrm.referenceAnswerNameTable.rows[0].cells[1].innerHTML = answer;	
				answerdetailfrm.referenceAnswerNameSpan.style.display = "inline";
			}
		} else {
			answerdetailfrm.referenceAnswerNameSpan.style.display = "none";
		}
	}
}

//gets ans sets the value of select before selection
var languageBeforeSelection="";

function setLanguageBeforeSelection(langId){
	languageBeforeSelection = langId;
}

function getLanguageBeforeSelection(){
	return languageBeforeSelection;
}

//refreshes the constraint list button
function refreshTheConstraintButtons(langId){
	if(isSearchSpaceDefined()){
		if(langId != getDefaultLanguageId()){
			disableButton(gsframe.buttons.buttonForm.newConstraintButtonButton);
		} else {
			enableButton(gsframe.buttons.buttonForm.newConstraintButtonButton);
		}
		disableButton(gsframe.buttons.buttonForm.changeConstraintButtonButton);
		disableButton(gsframe.buttons.buttonForm.deleteConstraintButtonButton);
	} else {
		gsframe.basefrm.disableAllButtons();
	}
}

function checkIfConstraintsDefinedLanguage(){
	var langId = getLanguageBeforeSelection();
	var constraints = getVectorOfConstraints();
	var length = size(constraints);
	if(length == 0){
		return false;
	}
	var added = false;
	for(var i=0;i<length;i++){
		var object = elementAt(i,constraints);
		if(object.values["languageId_"+langId] != null){
			if(object.values["languageId_"+langId].featureValue != null && (rtrim(ltrim(object.values["languageId_"+langId].featureValue))).length != 0){
				added = true;
				break;
			}
		}
	}

	return added;
}

//creates the answer object for change answer
function createAnswerObject(langId,conceptName,elaboration){
	var object = new Object();

	object.languageId = langId;
	object.removed = false;
	object.conceptName = conceptName;
	object.elaboration = elaboration;

	setObjectForTheLanguage(object);
}