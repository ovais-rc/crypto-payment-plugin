//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*

function getRadioValue (radio) {
	for (var i=0; i<radio.length; i++) {
		if (radio[i].checked) {
			return radio[i].value;
		}
	}
	return "";
}

function getSelectValue (select) {
	return select.options[select.selectedIndex].value;
}

function loadRadioValue (radio, value) {
	for (var i=0; i<radio.length; i++) {
		if (radio[i].value == value) {
			radio[i].checked = true;
			return;
		}
	}
}

function loadSelectValue (select, value) {
	for (var i=0; i<select.length; i++) {
		if (select.options[i].value == value) {
			select.options[i].selected = true;
			return;
		}
	}
}

function loadValue (entryField, value) {
	if (value != top.undefined) {
		entryField.value = value;
	}
}
