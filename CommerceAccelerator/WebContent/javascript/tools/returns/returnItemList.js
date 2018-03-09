//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
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
 
  function cancelButtonHandler()
  {
  	top.goBack();
  }
  
  function okButtonHandler()
  {
  	CONTENTS.basefrm.createReturnItems();
  }
  
  function returnToSearchDialog()
  {
        var returnWizardModel = top.getModel(1);
        var customerId = returnWizardModel.customerId;
        if (!defined(customerId))
           customerId = "";
  	top.showContent("/webapp/wcs/tools/servlet/DialogView?XMLFile=returns.returnItemSearchDialog&memberId="+customerId);
  }
