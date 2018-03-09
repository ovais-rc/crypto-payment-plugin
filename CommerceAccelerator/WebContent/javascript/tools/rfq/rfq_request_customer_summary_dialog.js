/********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* WebSphere Commerce
*
* (c) Copyright IBM Corp. 2003, 2004
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------*/

function printAction() {
    window.focus();    
	window.print();
}
function submitErrorHandler (errMessage) {
	alertDialog(errMessage);
}
function submitFinishHandler (finishMessage) {
	top.goBack();
}
function preSubmitHandler() {
	top.goBack();
}