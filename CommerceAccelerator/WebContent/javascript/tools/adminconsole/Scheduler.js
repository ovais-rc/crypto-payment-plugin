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


// handle the cancel command
function submitCancelHandler()
 {
  if( top.goBack ) {
        top.goBack();
  }
  else {
        location.href = CONTENTS.cancel_url;
  }
 }

function displayResults() {
        CONTENTS.displayResults();
}


