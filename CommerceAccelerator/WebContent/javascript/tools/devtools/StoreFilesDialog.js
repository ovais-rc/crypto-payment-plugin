/****************************************************************************
 *
 * Licensed Materials - Property of IBM
 *
 * WebSphere Commerce
 *
 * (c) Copyright IBM Corp. 2003
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 * 
 ***************************************************************************/

function submitErrorHandler(errorMessage)
{
	alertDialog(errorMessage);
}

function submitFinishHandler(finishMessage)
{
	top.setHome();
}

function submitCancelHandler()
{
	top.setHome();
}

function okButton()
{
	self.submitCancelHandler();
}
