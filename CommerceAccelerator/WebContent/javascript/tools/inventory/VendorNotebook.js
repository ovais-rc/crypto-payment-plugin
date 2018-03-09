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

 

 
    function submitErrorHandler (errMessage)
    {
      
      alertDialog(convertFromTextToHTML(errMessage));
    }
 
    function submitFinishHandler (finishMessage)
    {
        alertDialog(convertFromTextToHTML(finishMessage));
 	submitCancelHandler();
    }
 
    function submitCancelHandler()
    {

      if (top.goBack) {
        top.goBack();
      } 
      else {
        parent.location.replace("/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=inventory.VendorPurchase&amp;cmd=VendorPurchaseView");
      }
    }
 
    function preSubmitHandler()
    {

    }


function validateAllPanels()
{

  var validateVendorDetailList = get("vendorDetailList");
  if ( validateVendorDetailList != null) {
    if ( validateVendorDetailList.length < 1 ){
      put("validNumberRows", "false");
      gotoPanel("vendorPurchaseOrderDetailListChange");
      return false;
    }
  }

  
  var validOrderYear = top.getData("orderYear");
  var validOrderMonth = top.getData("orderMonth");
  var validOrderDay = top.getData("orderDay");
  if (!isValidPositiveInteger(validOrderYear)){
    put("validOrderDate", "false");
    gotoPanel("vendorPurchaseOrderHeaderChange");
    return false;
  }  
  
  if (!validDate(validOrderYear , validOrderMonth, validOrderDay)){
    put("validOrderDate", "false");
    gotoPanel("vendorPurchaseOrderHeaderChange");
    return false;
  }


  var externalId = top.getData("externalId")
  if (externalId.length > 20) {
    put("validExternalId", "false");
    gotoPanel("vendorPurchaseOrderHeaderChange");
    return false;
  }

 return true;

}