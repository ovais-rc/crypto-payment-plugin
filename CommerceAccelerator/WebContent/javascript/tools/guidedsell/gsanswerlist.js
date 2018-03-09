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

//get the vector of answers.
function getVectorOfAnswers(){
	var vector = parent.parent.parent.get("gsAnswerList",null);

	if(vector == null){
		vector = new Vector() ;
	} 

	return vector;
}


//get the vector of removed answers.
function getVectorOfRemovedAnswers(){
	var vector = parent.parent.parent.get("gsAnswerRemoveList",null);

	if(vector == null){
		vector = new Vector() ;
	} 

	return vector;
}


//set the vector of answers
function setVectorOfAnswers(vector){
		parent.parent.parent.put("gsAnswerList",vector);
}

//set the vector of removed answers
function setVectorOfRemovedAnswers(vector){
		parent.parent.parent.put("gsAnswerRemoveList",vector);
}

function isRemoved(tempConId)
{
	var vector = getVectorOfRemovedAnswers();
	var length = size(vector);
	for(var i=0;i<length; i++)
	{
		var conId = elementAt(i,vector);
		if(conId == tempConId)
		{
			return true;
		}
	}	
	return false; 
}

function updateAnswerList(object)
{
	var vector = getVectorOfAnswers();
	var ansVector = new Vector(); 
	var length = size(vector);
	var updated = false;
	if(!isRemoved(object.conceptId))
	{
		for(var i=0;i<length; i++ )
		{
			var obj = elementAt(i,vector);
			if(obj.conceptId == object.conceptId) {
				obj.conceptName = object.conceptName;
				addElement(obj,ansVector);
				updated = true;
			} else {
				addElement(obj,ansVector);
			}
		}
		if(!updated){
			addElement(object,ansVector);
		}
		setVectorOfAnswers(ansVector);
	}
}


function moveAnswerUp()
{
	if(isButtonDisabled(parent.buttons.buttonForm.moveUpButtonButton)){
		return;
	}

	var checked = parent.getChecked();
	if (checked.length == 1)
	{
		var moved_index = checked[0];

		var gsAnswerList = getVectorOfAnswers();

		var shifted_index = moved_index-1;

		var moved_object = elementAt(moved_index,gsAnswerList);
		var shifted_object = elementAt(shifted_index,gsAnswerList);

		var moved_sequence = moved_object.orderSequence;
		var shifted_sequence = shifted_object.orderSequence;

		moved_object.orderSequence = shifted_sequence;
		shifted_object.orderSequence = moved_sequence;

		var gsAnswerListTemp = new Vector();

		for(var i=0;i<size(gsAnswerList);i++){
			var tempObj = elementAt(i,gsAnswerList);
			if(i == moved_index){
				tempObj = shifted_object;
			}
			if(i == shifted_index){
				tempObj = moved_object;
			}
			addElement(tempObj,gsAnswerListTemp);
		}
		
		setVectorOfAnswers(gsAnswerListTemp);

		//Rewriting the table
		moved_index = moved_index-(-1);
		shifted_index = moved_index-1;
		var tableId = 'guidedSellAnswerList';
		var table = getTable(tableId);
		gsAnswerList = getVectorOfAnswers();

		var tlen = table.rows.length;
		for(var i=1;i<tlen;i++){
			var gsAnswer = elementAt(i-1,gsAnswerList);
			insCheckBox(tableId,i,0,i-1,"parent.setChecked();myRefreshButtons()");
			insCell(tableId,i,1,gsAnswer.conceptName);
		}

		var checkLength = document.GSAnswerListForm.elements.length;
		for (var i=0; i<checkLength; i++) {
			var e = document.GSAnswerListForm.elements[i];
			if (e.type == 'checkbox') {
     				if (e.name != 'select_deselect' && !e.checked && e.name == (shifted_index-1).toString()) {
					document.GSAnswerListForm.elements[i].click();
				}
     		}
    	}
    	
    	parent.parent.setChanged(true);
	}
}

function moveAnswerDown()
{
	if(isButtonDisabled(parent.buttons.buttonForm.moveDownButtonButton)){
		return;
	}

	var checked = parent.getChecked();
	if (checked.length == 1)
	{
		var moved_index = checked[0];

		var gsAnswerList = getVectorOfAnswers();

		var shifted_index = moved_index-(-1);
		var moved_object = elementAt(moved_index,gsAnswerList);
		var shifted_object = elementAt(shifted_index,gsAnswerList);

		var moved_sequence = moved_object.orderSequence;
		var shifted_sequence = shifted_object.orderSequence;

		moved_object.orderSequence = shifted_sequence;
		shifted_object.orderSequence = moved_sequence;

		var gsAnswerListTemp = new Vector();

		for(var i=0;i<size(gsAnswerList);i++){
			var tempObj = elementAt(i,gsAnswerList);
			if(i == moved_index){
				tempObj = shifted_object;
			}
			if(i == shifted_index){
				tempObj = moved_object;
			}
			addElement(tempObj,gsAnswerListTemp);
		}

		setVectorOfAnswers(gsAnswerListTemp);
		
		//Rewriting the table
		moved_index = moved_index-(-1);
		shifted_index = moved_index-(-1);
		gsAnswerList = getVectorOfAnswers();

		var tableId = 'guidedSellAnswerList';
		var table = getTable(tableId);

		var tlen = table.rows.length;
		for(var i=1;i<tlen;i++){
			var gsAnswer = elementAt(i-1,gsAnswerList);
			insCheckBox(tableId,i,0,i-1,"parent.setChecked();myRefreshButtons()");
			insCell(tableId,i,1,gsAnswer.conceptName);
		}

		var checkLength = document.GSAnswerListForm.elements.length;
		for (var i=0; i<checkLength; i++) {
			var e = document.GSAnswerListForm.elements[i];
			if (e.type == 'checkbox') {
     				if (e.name != 'select_deselect' && !e.checked && e.name == (shifted_index-1).toString()) {
					document.GSAnswerListForm.elements[i].click();
				}
   			}
   	   	}
   	   	
    	parent.parent.setChanged(true);
	}	
}



function compareStrings(a,b){
	var a1 = parseInt(a);
	var b1 = parseInt(b);
	if(a1<b1) return -1;
	if(a1>b1) return 1;
	return 0;
}


function removeSelectedAnswers()
{

	var checked = parent.getChecked();
	var gsAnswerList = getVectorOfAnswers();

	var gsAnswerRemoveList = getVectorOfRemovedAnswers();


	var objArray = new Array();
	for(var i=0;i<checked.length;i++){
		var obj = elementAt((checked[i]-(-0)),gsAnswerList);
		objArray[i] = obj;
		addElement(obj.conceptId,gsAnswerRemoveList);
	}
	for(var i=0;i<objArray.length;i++){
		gsRemoveElement(objArray[i],gsAnswerList);
	}

	setVectorOfRemovedAnswers(gsAnswerRemoveList);
	setVectorOfAnswers(gsAnswerList);

}


function refreshTable()
{
	var checked = parent.getChecked();
	var tableId = 'guidedSellAnswerList';
	var table = getTable(tableId);

	if((checked.length > 0) && (checked.length <= (table.rows.length-1))){
		var checkLength = document.GSAnswerListForm.elements.length;
		for (var i=0; i<checkLength; i++) {
		    var e = document.GSAnswerListForm.elements[i];
		    if (e.type == 'checkbox') {
      		if (e.name != 'select_deselect' && e.checked) {
				document.GSAnswerListForm.elements[i].click();
      		}
	    	   }
		}

		checked.sort(compareStrings);
		for(var i=checked.length-1;i>=0;i--){
			var rowNo = checked[i]-(-1);
			delRow(tableId,rowNo);
		}
		
		var tlen = getTable(tableId).rows.length;
		var gsAnswerList = getVectorOfAnswers();
		for(var i=1;i<tlen;i++){
			var obj = elementAt(i-1,gsAnswerList);
			insCheckBox(tableId,i,0,i-1,"parent.setChecked();myRefreshButtons()");
			insCell(tableId,i,1,obj.conceptName);
		}
		parent.setChecked();
		myRefreshButtons();
	}
}