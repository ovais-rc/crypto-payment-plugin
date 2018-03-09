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


  function openDynamicList()
  {
  	CONTENTS.openDynamicList();	
  
  }
 
  function closeDialog()
  {
  	//window.close();
  	top.goBack();
  	//top.mccbanner.openLink(top.mccbanner.counter);
  }
  
  function addToOrder()
  {
  	CONTENTS.basefrm.addItem();
  	//window.close();
  }
  