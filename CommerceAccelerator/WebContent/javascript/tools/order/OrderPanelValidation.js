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


  
  
  /*
   *	validatePanelData, savePanelData and validateNoteBookPanel redirect for dynamic lists in notebook & wizard
   */
  function validatePanelData() 
  {
    	return basefrm.validatePanelData();
  }
  
  function savePanelData()
  {
  	basefrm.savePanelData();
  }
  
  function validateNoteBookPanel() {
  	return basefrm.validateNoteBookPanel();
  
  }
  
