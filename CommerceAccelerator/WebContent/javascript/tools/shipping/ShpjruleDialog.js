//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*

function okAction () {

	// check if document and function exist
	if (self.CONTENTS == null) return;
	if (self.CONTENTS.addAction == undefined) return;
	if (self.CONTENTS.cancelAction == undefined) return;

	// execute the add when condition of the baseframe
	if (self.CONTENTS.addAction()) {
		// if this is true we validated ok so close the window
		cancelAction();
	}
}

function cancelAction () {
	// check if document and function exist
	if (self.CONTENTS == null) return;
	if (self.CONTENTS.cancelAction == undefined) return;

	self.CONTENTS.cancelAction();
}