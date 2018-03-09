//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*

function performFinish () {
	// check if document and function exist
	if (self.CONTENTS.basefrm == null) return;
	if (self.CONTENTS.basefrm.performFinish == undefined) return;

	self.CONTENTS.basefrm.performFinish();
}

function performCancel () {
	// check if document and function exist
	if (self.CONTENTS.basefrm == null) return;
	if (self.CONTENTS.basefrm.performCancel == undefined) return;

	self.CONTENTS.basefrm.performCancel();
}
