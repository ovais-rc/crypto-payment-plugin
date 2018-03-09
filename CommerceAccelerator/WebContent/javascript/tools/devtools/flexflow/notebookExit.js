/****************************************************************************
 *
 * Licensed Materials - Property of IBM
 *
 * WebSphere Commerce
 *
 * (c) Copyright IBM Corp. 2001, 2002
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 * 
 ***************************************************************************/

function submitErrorHandler(errorMessage)
{
	document.frames.CONTENTS.submitErrorHandler(errorMessage);
}

function submitFinishHandler(finishMessage)
{
	document.frames.CONTENTS.submitFinishHandler(finishMessage);
}

function submitCancelHandler()
{
	top.goBack();
}

function applyButton()
{
	document.frames.CONTENTS.applyButton();
}

function applyPermanentlyButton()
{
	document.frames.CONTENTS.applyPermanentlyButton();
}