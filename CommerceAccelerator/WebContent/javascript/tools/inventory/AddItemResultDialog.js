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



function closeDialog()
  {
 	//  CONTENTS.basefrm.cancelSearch();
	  // url="/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.AddItemSearchDialog" 
		//window.location.replace("/webapp/wcs/tools/servlet/WizardView?XMLFile=inventory.VendorWizard&startingPage=vendorPurchaseOrderDetailList");  
	  window.location.replace("/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.AddItemSearchDialog");
  }
  
  function passToDetail()
  {
  	CONTENTS.basefrm.passToDetail();

  }