/********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* WebSphere Commerce
*
* (c) Copyright IBM Corp. 2002, 2003
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------*/

function printAction()
{
    self.CONTENTS.window.focus();
    self.CONTENTS.printAction();
}

function submitErrorHandler (errMessage){
	alertDialog(errMessage);
}

function submitFinishHandler (finishMessage) {
	top.goBack();

}

function preSubmitHandler () {
      //alert("in preSubmitHandler");
	top.goBack();

}

