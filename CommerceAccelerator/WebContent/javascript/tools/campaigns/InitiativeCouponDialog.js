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

function chooseCoupon () {
	// check if document and function exist
	if (self.CONTENTS.basefrm == null) return;
	if (self.CONTENTS.basefrm.chooseCoupon == undefined) return;

	self.CONTENTS.basefrm.chooseCoupon();
}

function cancelCoupon () {
	// check if document and function exist
	if (self.CONTENTS.basefrm == null) return;
	if (self.CONTENTS.basefrm.cancelCoupon == undefined) return;

	self.CONTENTS.basefrm.cancelCoupon();
}
