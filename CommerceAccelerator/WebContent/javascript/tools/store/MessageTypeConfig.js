//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*

// handle the cancel command
function submitCancelHandler()
{
	top.goBack();
}



function submitFinishHandler(submitFinishMessage)
{
	alertDialog(submitFinishMessage);
	top.goBack();
}


function submitErrorHandler(submitErrorMessage, submitErrorStatus)
{

}


function validateAllPanels()
{
	return CONTENTS.convertParametersToXML();
}

