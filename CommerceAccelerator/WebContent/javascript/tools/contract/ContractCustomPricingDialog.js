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

function changeAction () {
	// check if document and function exist
	if (self.CONTENTS == null) return;
	if (self.CONTENTS.changeAction == undefined) return;

	self.CONTENTS.changeAction();
}

function cancelAction () {
	// check if document and function exist
	if (self.CONTENTS == null) return;
	if (self.CONTENTS.cancelAction == undefined) return;

	self.CONTENTS.cancelAction();
}
