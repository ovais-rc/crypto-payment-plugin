//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*

function okAction () {
	// check if document and function exist
	if (self.CONTENTS.basefrm != null) {
		if (self.CONTENTS.basefrm.returnToInitiatives != undefined) {
			self.CONTENTS.basefrm.returnToInitiatives();
		}
	}
	if (self.CONTENTS != null) {
		if (self.CONTENTS.returnToInitiatives != undefined) {
			self.CONTENTS.returnToInitiatives();
		}
	}
	return;
}
