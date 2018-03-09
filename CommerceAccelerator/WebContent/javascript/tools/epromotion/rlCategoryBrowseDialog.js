//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*

//Performs add action
function performAdd () {
	// check if document and function exist
	if (self.CONTENTS.treeContent == null) return;
	if (self.CONTENTS.treeContent.performAdd == undefined) return;

	self.CONTENTS.treeContent.performAdd();
}

//Performs finish action
function performFinish () {
	// check if document and function exist
	if (self.CONTENTS.treeContent == null) return;
	if (self.CONTENTS.treeContent.performFinish == undefined) return;

	self.CONTENTS.treeContent.performFinish();
}

//Performs cancel action
function performCancel () {
	// check if document and function exist
	if (self.CONTENTS.treeContent == null) return;
	if (self.CONTENTS.treeContent.performCancel == undefined) return;

	self.CONTENTS.treeContent.performCancel();
}
