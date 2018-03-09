//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2008
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*

function generateFlashObject (flashObjectInStr) {
	document.write(flashObjectInStr);
}

function removeInvalidChar (inputStr) {
	return inputStr.replace(new RegExp(/\W/g), "_");
}

function trim (inputStr) {
	word = inputStr.toString();
	var i = 0;
	var j = word.length - 1;
	while (word.charAt(i) == " ") {
		i++;
	}
	while (word.charAt(j) == " ") {
		j--;
	}
	return i > j ? "" : word.substring(i, j + 1);
}
