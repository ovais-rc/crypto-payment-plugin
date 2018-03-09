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

//returns object array
function getObjectArray(){
	var array = top.get("linkArray",null);
	if(array == null){
		array = new Array();
	}
	return array;
}

//sets an object array
function setObjectArray(array){
	top.put("linkArray",array);
	if(array == null){
		top.remove("linkArray");
	}
}

//function sets the onject to the array
function setObject(object){
	var array = getObjectArray();
	var rowID = parseInt(object.rowId);
	array[rowID] = object;
	setObjectArray(array);
}

//function gets the object form the array
function getObject(rowId){
	var array = getObjectArray();
	var object = array[parseInt(rowId)];
	if(object == null){
		object = new Object();
	} 
	return object;
}

//sets the template name
function setTemplateName(rowId,templateName){
	var object = getObject(rowId);
	object.templateName = templateName;
	setObject(object);
}

//sets the template usage
function setTemplateUsage(rowId,templateUsage){
	var object = getObject(rowId);
	object.templateUsage = templateUsage;
	setObject(object);
}

//sets the pass constraint
function setPassConstraint(rowId,passConstraint){
	var object = getObject(rowId);
	object.passConstraint = passConstraint;
	setObject(object);
}

//adds a metaphor object
function addMetaphorObject(rowId){
	var object = getObject(rowId);
	object.rowId = rowId;
	setObject(object);
}

//changes the template name
function changeTemplateName(textObject){
	var textValue = textObject.value;
	var textName = textObject.name
	if(textValue != null){
		var param = textName.split(';');
		var rowId = param[1];
		setTemplateName(rowId,textValue);
	}
}
//changes the template usage
function changeTemplateUsage(selectedObject){
	var selected = selectedObject.options[selectedObject.options.selectedIndex].value;
	if(selected != null){
		var param = selected.split(';');
		var rowId = param[0];
		setTemplateUsage(rowId,param[1]);
	}
}

//changes the template usage
function changePassConstraint(selectedObject){
	var selected = selectedObject.options[selectedObject.options.selectedIndex].value;
	if(selected != null){
		var param = selected.split(';');
		var rowId = param[0];
		setPassConstraint(rowId,param[1]);
	}
}

//returns a vector of checkeds
function getChecked(){
	var checked = top.get("checkedVals",null);

	if(checked == null){
		checked = new Vector();
	}
	
	return checked;
}

//sets a vector of checkeds
function setChecked(checked){
	top.put("checkedVals",checked);
	if(checked == null){
		top.remove("checkedVals");
	}
}
//sets the selected objects
function setSelected(){
	var checked = getChecked();

	var length = gsframe.document.linkListForm.elements.length;
	for(var i=0;i<length;i++){
		var e = gsframe.document.linkListForm.elements[i];
		if(e.type == 'checkbox'){
			if(e.name != 'select_deselect' && e.checked && !checked.contains(e.name)){
				checked.addElement(e.name);
			}
			if(e.name != 'select_deselect' && !e.checked && checked.contains(e.name)){
				checked.removeElement(e.name);
			}
		}
	}

	setChecked(checked);
}

//gets the default data required
function getDefaultXMLData(categoryId,metaphorId,gsLanguageId,treeId,conceptId,fromPage,forChange){
	var xml = '';
	xml += '<categoryId>'+categoryId+'</categoryId>\n';
	xml += '<metaphorId>'+metaphorId+'</metaphorId>\n';
	xml += '<gsLanguageId>'+gsLanguageId+'</gsLanguageId>\n';
	xml += '<treeId>'+treeId+'</treeId>\n';
	xml += '<conceptId>'+conceptId+'</conceptId>\n';
	xml += '<fromPage>'+fromPage+'</fromPage>\n';
	xml += '<forChange>'+forChange+'</forChange>\n';
	return xml;
}

//gets the data for question link
function getQuestionXMLData(name,checked){
	var data = elementAt(0,checked);
	var param = data.split(';');
	var treeId = param[0];
	var conceptId = param[1];
//	var displayName = param[2];
	var xml = '';
	xml += '<Link>\n';
	xml += '<linkTo>'+name+'</linkTo>\n';
	xml += '<treeId>'+treeId+'</treeId>\n';
	xml += '<conceptId>'+conceptId+'</conceptId>\n';
	xml += '</Link>\n';
	if(this.getChangedLinkData){
		var cobject = getChangedLinkData();
		cobject.linkType = name;
		cobject.treeId = treeId;
		cobject.conceptId = conceptId;
		top.put("changedLinkData",cobject);
	}
	return xml;
}

//gets the data for question link
function getMetaphorXMLData(name,checked){
	var data = elementAt(0,checked);
	var param = data.split(';');
	var categoryId = param[0];
	var metaphorId = param[1];
	var rowId = param[2];
	var object = getObject(rowId);
	var xml = '';
	xml += '<Link>\n';
	xml += '<linkTo>'+name+'</linkTo>\n';
	xml += '<categoryId>'+categoryId+'</categoryId>\n';
	xml += '<metaphorId>'+metaphorId+'</metaphorId>\n';
	xml += '<templateName>'+object.templateName+'</templateName>\n';
	xml += '<templateUsage>'+object.templateUsage+'</templateUsage>\n';
	xml += '<passConstraint>'+object.passConstraint+'</passConstraint>\n';
	xml += '</Link>\n';
	if(this.getChangedLinkData){
		var cobject = getChangedLinkData();
		cobject.linkType = name;
		cobject.categoryId = categoryId;
		cobject.metaphorId = metaphorId;
		cobject.templateName = object.templateName;
		cobject.templateUsage = object.templateUsage;
		cobject.passConstraint = object.passConstraint;
		top.put("changedLinkData",cobject);
	}
	return xml;
}

//gets the data for question link
function getURLXMLData(name){
	var tempName=gsframe.linkListForm.urlName.value;
	var templateName=convertFromTextToXML(tempName);

	var xml = '';
	xml += '<Link>\n';
	xml += '<linkTo>'+name+'</linkTo>\n';
	xml += '<templateName>'+templateName+'</templateName>\n';
	xml += '<templateUsage>'+gsframe.linkListForm.templateUsage.value+'</templateUsage>\n';
	xml += '<passConstraint>'+gsframe.linkListForm.passConstraint.value+'</passConstraint>\n';
	xml += '</Link>\n';
	if(this.getChangedLinkData){
		var cobject = getChangedLinkData();	
		cobject.linkType = name;
		cobject.templateName = gsframe.linkListForm.urlName.value;
		cobject.templateUsage = gsframe.linkListForm.templateUsage.value;
		cobject.passConstraint = gsframe.linkListForm.passConstraint.value;
		top.put("changedLinkData",cobject);
	}
	return xml;
}

//gets the data for product link
function getProductXMLData(name){

	var tempSKU=gsframe.linkListForm.productSKU.value;
	var validSKU=convertFromTextToXML(tempSKU);

	//added
	var tempName=gsframe.linkListForm.urlName.value;
	var templateName=convertFromTextToXML(tempName);
	//add ends
	var xml = '';
	xml += '<Link>\n';
	xml += '<linkTo>'+name+'</linkTo>\n';
	//added
	xml += '<templateName>'+templateName+'</templateName>\n';
	//add ends
	xml += '<templateUsage>'+gsframe.linkListForm.templateUsage.value+'</templateUsage>\n';
	xml += '<passConstraint>'+gsframe.linkListForm.passConstraint.value+'</passConstraint>\n';
	xml += '<productSKU>'+validSKU+'</productSKU>\n';
	xml += '</Link>\n';
	if(this.getChangedLinkData){
		var cobject = getChangedLinkData();	
		cobject.linkType = name;
		//added
		cobject.templateName = gsframe.linkListForm.urlName.value;
		//add ends
		cobject.templateUsage = gsframe.linkListForm.templateUsage.value;
		cobject.passConstraint = gsframe.linkListForm.passConstraint.value;
		cobject.productSKU = gsframe.linkListForm.productSKU.value;
		top.put("changedLinkData",cobject);
	}
	return xml;
}

//gets the data for question link
function getNoLinkData(name){
	var xml = '';
	xml += '<Link>\n';
	xml += '<linkTo>'+name+'</linkTo>\n';
	xml += '</Link>\n';
	if(this.getChangedLinkData){
		var cobject = getChangedLinkData();	
		cobject.linkType = name;
		top.put("changedLinkData",cobject);
	}
	return xml;
}

// converts the text data to xml parasable text
function convertFromTextToXML(obj)
{
   var string = new String(obj);
   var result = "";

   for (var i=0; i < string.length; i++ ) {
      if (string.charAt(i) == "<")       result += "&lt;";
      else if (string.charAt(i) == ">")  result += "&gt;";
      else if (string.charAt(i) == "&")  result += "&amp;";
      else if (string.charAt(i) == "'")  result += "&apos;";
      else if (string.charAt(i) == '"')  result += "&quot;";
      else result += string.charAt(i);
   }
   return result;
}


// converts the text data to HTML format
function convertFromTextToHTML(obj)
{
   var string = new String(obj);
   var result = "";

   for (var i=0; i < string.length; i++ ) {
      if (string.charAt(i) == "<")       result += "&lt;";
      else if (string.charAt(i) == ">")  result += "&gt;";
      else if (string.charAt(i) == "&")  result += "&amp;";
      else if (string.charAt(i) == '"')  result += "&quot;";
      else result += string.charAt(i);
   }
   return result;
}
