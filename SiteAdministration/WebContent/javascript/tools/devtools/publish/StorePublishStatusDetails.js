/****************************************************************************
 *
 * Licensed Materials - Property of IBM
 *
 * WebSphere Commerce
 *
 * (c) Copyright IBM Corp. 2000, 2002
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 * 
 ***************************************************************************/

function submitErrorHandler (errMessage)
{
}

function submitFinishHandler (finishMessage)
{
	top.goBack();
}

function submitCancelHandler()
{
	top.goBack();	
}

/******************************************************************************
*
*	Refresh
*
******************************************************************************/

function refreshButtonAction()
{
	location.reload();
	//document.frames.CONTENTS.location.reload();
}
