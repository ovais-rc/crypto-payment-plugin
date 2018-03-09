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

function submitErrorHandler (errMessage) {
     alertDialogv(errMessage);
}

function submitFinishHandler (finishMessage) {
     alertDialog(finishMessage);
}

function preSubmitHandler()
{
     top.goBack();
}
