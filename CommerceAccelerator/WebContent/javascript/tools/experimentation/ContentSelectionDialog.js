//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2005
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*

function performFinish () {
	// check if document and function exist
	if (self.CONTENTS == null) {
		return;
	}
	if (self.CONTENTS.performFinish == undefined) {
		return;
	}
	self.CONTENTS.performFinish();
}

function performCancel () {
	// check if document and function exist
	if (self.CONTENTS == null) {
		return;
	}
	if (self.CONTENTS.performCancel == undefined) {
		return;
	}
	self.CONTENTS.performCancel();
}
