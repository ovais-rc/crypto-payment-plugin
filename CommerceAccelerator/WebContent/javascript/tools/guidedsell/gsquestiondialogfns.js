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

//get the vector of questions
function getVectorOfQuestions(){
	var vector = top.get("questionsVector",null);

	if(vector == null){
		vector = new Vector() ;
	} 

	return vector;
}

//set the vector of questions
function setVectorOfQuestions(vector){
	top.put("questionsVector",sortVector(vector));
	if(vector == null){
		top.remove("questionsVector");
	}
}

//check if there is an object present for the language id
function doesLanguageIdExistInList(langId){
	var vector = getVectorOfQuestions();
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
	var vector = getVectorOfQuestions();
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
	var vector = getVectorOfQuestions();
	var length = size(vector);
	var added = false;
	for(var i=0;i<length;i++){
		var obj = elementAt(i,vector);
		if(obj.languageId == object.languageId) {
			added = true;
			removeElementAt(i,vector);
			if(i != length-1){
				insertElementAt(object,i,vector);
			} else {
				addElement(object,vector);
			}
			break;
		}
	}
	
	if(!added){
		addElement(object,vector);
	}

	setVectorOfQuestions(vector);
}


//populate the fields of the dialog
function populateTheFields(langId){
	var object = getObjectForTheLanguage(langId);
	if(object != null && !object.removed) {
		this.questionForm.question.value = object.conceptName;
		this.questionForm.description.value = object.elaboration;
	} else {
		clearAllFields();
	}
}

//clears all fields of the dialog
function clearAllFields(){
	this.questionForm.question.value = "";
	this.questionForm.description.value = "";
}

//modifies the object for the language
function modifyTheObject(langId){
	var object = getObjectForTheLanguage(langId);
	if(object != null && !object.removed) {
		object.conceptName = rtrim(ltrim(this.questionForm.question.value));
		object.elaboration = rtrim(ltrim(this.questionForm.description.value));
		setObjectForTheLanguage(object);
	}
}

//creates the object for that language id 
function createNewObject(langId,langDescription){
	var object = new Object();
	object.languageId = langId;
	object.removed = false;
	object.conceptName = rtrim(ltrim(this.questionForm.question.value));
	object.elaboration = rtrim(ltrim(this.questionForm.description.value));

	setObjectForTheLanguage(object);
}

//removes the object from the vector
function removeTheObject(langId){
	var object = getObjectForTheLanguage(langId);
	if(object != null){
		object.removed = true;
		setObjectForTheLanguage(object);
	}
}

//compares the language ids
function compareLanguageIds(a,b){
	var a1 = parseInt(a);
	var b1 = parseInt(b);
	if(a1>b1) return -1;
	if(a1<b1) return 1;
	return 0;
}

//function to sort a vector
function sortVector(object){
	if(object == null) {
		return null;
	}
	var length = size(object);
	var array = new Array();
	var arrayIndex = 0;
	for(var i=0;i<length;i++){
		var obj = elementAt(i,object);
		array[arrayIndex++] = obj.languageId;
	}

	array.sort(compareLanguageIds);

	var vector = new Vector();

	for(var i=0 ; i<array.length ;i++){
		for(var j=0;j<length;j++){
			var obj = elementAt(j,object);
			if(array[i] == obj.languageId){
				addElement(obj,vector);
				break;
			}
		}
	}

	return vector;
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
	var olength = this.questionForm.listSelect.options.length;
	for(var i=0;i<olength;i++){
		var value = this.questionForm.listSelect.options[i].value;
		if(value == langId){
			this.questionForm.listSelect.options[i].selected = true;
		}
	}
}	

//fucntion that checks if qustion is defined for default language
function isQuestionDefinedForDefaultLanguage(){
	var selected = this.questionForm.listSelect.options[this.questionForm.listSelect.options.selectedIndex].value;
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

var languageIdBeforeSelection=""
function setLanguageIdBeforeSelection(langId){
	languageIdBeforeSelection = langId;
}

function getLanguageIdBeforeSelection(){
	return languageIdBeforeSelection;
}

function displayTheReference(selected){
	if(selected != null){
		if(selected != getDefaultLanguageId()){
			var questionObject = getObjectForTheLanguage(getDefaultLanguageId());
			if(questionObject != null){
				var question = questionObject.conceptName;
				referenceQuestionNameTable.rows[0].cells[1].innerHTML = question;
				referenceQuestionNameSpan.style.display = "inline";
			}
		} else {
			referenceQuestionNameSpan.style.display = "none";
		}
	}
}
