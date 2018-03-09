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

// set this flag to true if you want to display the debugging XML popup window
var debug=false;
// set this flag to false if you do not want the contract to be submitted
// (created/udpated) after the XML popup appears
var submitWhileDebugging=true;

var priceListConfirmCalled = false;

function padZero (entry) {
  if (entry.length == 1)
   return '0' + entry;
  return entry;
}

function ContractGeneralModel()
{
  this.name = "";
  this.title = "";
  this.description = "";
  this.StartImmediateChecked = false;
  this.startYear = "";
  this.startMonth = "";
  this.startDay = "";
  this.startTime = "";
  this.endNeverExpires = false;
  this.endYear = "";
  this.endMonth = "";
  this.endDay = "";
  this.endTime = "";
  this.BaseDelegationGridChecked = false;

  this.state = "Draft";
  this.origin = "Manual";
  this.usage = "OrganizationBuyer";
  this.majorVersionNumber = "1";
  this.minorVersionNumber = "0";
  this.referenceNumber = "";
  this.lastUpdateTime = "";

  this.creditLineAllowed = false;

  this.accountName = "";
  this.accountOwnerReferenceNumber = "";
  this.accountOwnerReferenceDN = "";

  var contractReferenceList = new Array();
  this.contractReferenceList = contractReferenceList;
  this.contractReferenceSelected = "0";
  this.priceListType = "";

  this.remarks = "";
}

function ContractCommonDataModel()
{
  this.storeId = "";
  this.accountHasCredit = true;
  this.accountHolderOrganization = "";
  this.flanguageId = "";
  this.fLocale = "";
  var storeCurrArray = new Array();
  this.storeCurrArray = storeCurrArray;
  this.storeDefaultCurr = "";
  this.contractHasInclusionExclusionTCs = false;
  this.catalogId = "";
  this.catalogIdentifier = "";
  this.catalogMemberId = "";
  this.catalogMemberDN = "";
  this.storeMemberId = "";
  this.storeMemberDN = "";
  this.storeIdentity = "";
  this.referenceNumber = "";

  /*90288*/
  var tcLockInfo  = new Array();
  this.tcLockInfo = tcLockInfo;

  this.unlockWarningMsgMap = new Array();
}

function ContractBuyerModel()
{
  var availableBuyers = new Array();
  this.availableBuyers = availableBuyers;
  var selectedBuyers = new Array();
  this.selectedBuyers = selectedBuyers;
  var contractBuyers = new Array();
  this.contractBuyers = contractBuyers;
  var availableMemberGroups = new Array();
  this.availableMemberGroups = availableMemberGroups;
  var selectedMemberGroups = new Array();
  this.selectedMemberGroups = selectedMemberGroups;
  var contractMemberGroups = new Array();
  this.contractMemberGroups = contractMemberGroups;
  var MemberGroupOwners = new Array();
  this.MemberGroupOwners = MemberGroupOwners;
}

function ContractDocumentationModel()
{
  var contractDocumentation = new Array();
  this.contractDocumentation = contractDocumentation;
  var deletedDocumentation = new Array();
  this.deletedDocumentation = deletedDocumentation;
  var selectedDocumentation = new Array();
  this.selectedDocumentation = selectedDocumentation;
}

function GMTTimeStamp()
{
    this.year = "";
    this.month = "";
    this.date = "";
    this.hour = "";
    this.minute = "";
    this.second = "00";
}

function checkProductConstraintsData() {

  var lastPageWasPricing = false;
  var lastPage = get("ContractPricingPageVisited", null);
  if (lastPage != null) {
     if (lastPage == "PRICING") {
   lastPageWasPricing = true;
     }
  }
  if (lastPageWasPricing) {
        var ccdm = get("ContractCommonDataModel");
   if (ccdm.contractHasInclusionExclusionTCs || get("ContractProductConstraintsModel") != null)
    {
     put("contractVerifyProductConstraints", true);
     gotoPanel("notebookProductConstraints");
     return false;
    }
  }

  return true;
}

function validateGeneralPanel () {

  //alert('In Validate General');

  var o = get("ContractGeneralModel");

  // NAME
  if (!o.name)
   {
    put("contractNameRequired", true);
    gotoPanel("notebookGeneral");
    return false;
   }

  if (!isValidUTF8length(o.name, 200))
   {
    put("contractNameTooLong", true);
    gotoPanel("notebookGeneral");
    return false;
   }

  // TITLE
  if (!o.title)
   {
    put("contractTitleRequired", true);
    gotoPanel("notebookGeneral");
    return false;
   }

  if (!isValidUTF8length(o.title, 254))
   {
    put("contractTitleTooLong", true);
    gotoPanel("notebookGeneral");
    return false;
   }

 if (o.usage == "DelegationGrid") {
   if (o.BaseDelegationGridChecked == false) {
      var o2 = get("ContractBuyerModel");
      if (o2.selectedMemberGroups.length == 0) {
           put("memberGroupRequired", true);
           gotoPanel("notebookGeneral");
           return false;
         }
   }
 }

 if (o.usage != "DelegationGrid") {
  // DESCRIPTION
  if (!isValidUTF8length(o.description, 4000))
   {
    put("contractDescriptionTooLong", true);
    gotoPanel("notebookGeneral");
    return false;
   }

  // START DATE
  if (o.StartImmediateChecked == false && !validDate(o.startYear, o.startMonth, o.startDay))
   {
    put("invalidStartDate", true);
    gotoPanel("notebookGeneral");
    return false;
   }

  if (o.StartImmediateChecked == false && !validTime(o.startTime))
   {
    put("invalidStartTime", true);
    gotoPanel("notebookGeneral");
    return false;
   }

  // END DATE
  if (o.endNeverExpires == false && !validDate(o.endYear, o.endMonth, o.endDay))
   {
    put("invalidEndDate", true);
    gotoPanel("notebookGeneral");
    return false;
   }

  if (o.endNeverExpires == false && !validTime(o.endTime))
   {
    put("invalidEndTime", true);
    gotoPanel("notebookGeneral");
    return false;
   }

  // if start and end dates are specified, validate range
  if (o.endNeverExpires == false && ! validateStartEndDateTime(o.startYear, o.startMonth, o.startDay,
                                 o.endYear, o.endMonth, o.endDay,
                                 o.startTime,
                                 o.endTime))
   {
    put("invalidEndAfterStartDate", true);
    gotoPanel("notebookGeneral");
    return false;
   }

  // check the base contract price list matches the catalog filter price list
  if (priceListConfirmCalled == false && o.contractReferenceSelected != "0") {
   // there is a base contract, check the saved data first, then the catalog filter page
   var type = o.contractReferenceList[o.contractReferenceSelected - 1].priceListType;
   if (type != null && type != "null" && type != "") {
      // base contract has a price list type
      // check if it matches saved data
      if (o.priceListType != null && o.priceListType != "null" && o.priceListType != "") {
               if (o.priceListType != type) {
                  if(!confirmDialog(o.priceListMismatchMessageText)){
                     gotoPanel("notebookGeneral");
                     return false;
                  } else {
                     priceListConfirmCalled = true;
                  }
               }
      } else {
         // check if it matches catalog filter
         var getCFM = get("ContractFilterModel");
         if (getCFM != null) {
            for (var i=0; i<getCFM.JROM.priceListPolicyArray.length; i++) {
               if (getCFM.JROM.priceListPolicyArray[i].type != type) {
                  if(!confirmDialog(o.priceListMismatchMessageText)){
                     gotoPanel("notebookGeneral");
                     return false;
                  } else {
                     priceListConfirmCalled = true;
                  }
                  break;
               }
            }
            }
         }
      }
   }
  } // end if not delegation grid

  if (debug) {
      preSubmitHandler();
      if (submitWhileDebugging == false) {
          return false;
      }
  }

  return true;
}

function validateBuyerPanel() {
  return true;
}

function validateDocumentationPanel() {
  return true;
}

function validateRemarksPanel() {
  var o = get("ContractRemarksModel");
  var cgm = get("ContractGeneralModel");
  // REMARKS
  if (o != null) {
     if (!isValidUTF8length(o.remarks, 4000))
      {
       put("remarksTooLong", true);
       gotoPanel("notebookRemarks");
       return false;
      }
  }
  else if (cgm != null) {
     if (!isValidUTF8length(cgm.remarks, 4000))
      {
       put("remarksTooLong", true);
       gotoPanel("notebookRemarks");
       return false;
      }
  }

  return true;
}

function submitGeneralPanel(contract) {

  var o = get("ContractGeneralModel");
  var ccdm = get("ContractCommonDataModel");

  if (o.lastUpdateTime != "") {
     addURLParameter("lastUpdatedTime", o.lastUpdateTime);
  }

  contract.ContractUniqueKey = new Object();
  contract.ContractUniqueKey.name = o.name;
  contract.ContractUniqueKey.majorVersionNumber = o.majorVersionNumber;
  contract.ContractUniqueKey.minorVersionNumber = o.minorVersionNumber;
  // no validation for base contracts
  if (o.accountName != "" && o.accountName.indexOf("BaseContracts") >= 0) {
     contract.ContractUniqueKey.origin = "Deployment";
  } else {
     contract.ContractUniqueKey.origin = o.origin;
  }

  contract.ContractUniqueKey.ContractOwner = new Object();
  contract.ContractUniqueKey.ContractOwner.OrganizationRef = new Object();
  contract.ContractUniqueKey.ContractOwner.OrganizationRef.distinguishName = ccdm.storeMemberDN;

  var desc = new Object();
  desc.shortDescription = o.title;

  desc.locale = ccdm.fLocale;
  if (o.description.length > 0) {
     desc.longDescription = encodeNewLines(o.description);
  }

  contract.ContractDescription = desc;

  contract.creditAllowed = o.creditLineAllowed;
  contract.state = o.state;
  contract.contractUsage = o.usage;

  if (o.accountName != "") {
   contract.AccountReference = new Object();
   contract.AccountReference.AccountRef = new Object();
   contract.AccountReference.AccountRef.name = o.accountName;
   contract.AccountReference.AccountRef.AccountOwner = new Object();
   contract.AccountReference.AccountRef.AccountOwner.OrganizationRef = new Object();
   contract.AccountReference.AccountRef.AccountOwner.OrganizationRef.distinguishName = o.accountOwnerReferenceDN;
  }

  if (o.referenceNumber != "") {
   // update
   contract.referenceNumber = o.referenceNumber;
  }

  if (o.contractReferenceSelected != "0") {
   if ((o.usage != "DelegationGrid") ||
       (o.usage == "DelegationGrid" && o.BaseDelegationGridChecked == false)) {
    // no contract reference for base delegation grids
   contract.ContractReference = new Object();
   contract.ContractReference.ContractRef = new Object();
   contract.ContractReference.ContractRef.name = o.contractReferenceList[o.contractReferenceSelected - 1].name;
   contract.ContractReference.ContractRef.origin = o.contractReferenceList[o.contractReferenceSelected - 1].origin;
   contract.ContractReference.ContractRef.majorVersionNumber = o.contractReferenceList[o.contractReferenceSelected - 1].majorVersionNumber;
   contract.ContractReference.ContractRef.minorVersionNumber = o.contractReferenceList[o.contractReferenceSelected - 1].minorVersionNumber;
   contract.ContractReference.ContractRef.ContractOwner = new Object();
   contract.ContractReference.ContractRef.ContractOwner = o.contractReferenceList[o.contractReferenceSelected - 1].ContractOwner;
   }
  }
  return true;
}

function submitContractDates(contract) {

  var o = get("ContractGeneralModel");

  // Start Date
  if (o.StartImmediateChecked == false) {
  var startDate = new GMTTimeStamp();
  startDate.year =  o.startYear;
  startDate.month = padZero(o.startMonth);
  startDate.date =  padZero(o.startDay);

  var startTime = o.startTime.split(":");
  startDate.hour = padZero(startTime[0]);
  startDate.minute = padZero(startTime[1]);

  contract.startTime = startDate.year + "-" + startDate.month + "-" + startDate.date + "T" + startDate.hour + ":" + startDate.minute + ":00";

  }

  // End Date
  if (o.endNeverExpires == false) {

    var endDate = new GMTTimeStamp();

    endDate.year = o.endYear;
    endDate.month = padZero(o.endMonth);
    endDate.date = padZero(o.endDay);

    var endTime = o.endTime.split(":");
    endDate.hour = padZero(endTime[0]);
    endDate.minute = padZero(endTime[1]);

    contract.endTime = endDate.year + "-" + endDate.month + "-" + endDate.date + "T" + endDate.hour + ":" + endDate.minute + ":00";
  }

  return true;
}

function submitBuyerPanel(contract, participants) {
  var o = get("ContractBuyerModel");
  if (o != null) {

   var cgm = get("ContractGeneralModel");
   // add the new ones
   // only add new ones that are not currently in the contract
   for (i = 0; i < o.selectedBuyers.length; i++) {
      var name = o.selectedBuyers[i].value;
      if (isNameInArray(name, o.contractBuyers) == false) {
         // this is a new one to add to the contract
         var buyer = new Object();
         if (cgm.usage == "DelegationGrid") {
            buyer.role = "ServiceRepresentative";
         } else {
            buyer.role = "Buyer";
         }
         buyer.action = "new";
         buyer.ParticipantMember = new Object();
         buyer.ParticipantMember.OrganizationRef = new Object();
         buyer.ParticipantMember.OrganizationRef.distinguishName = name;
         participants[participants.length] = buyer;
      }
   }
   // delete the removed ones
   // only delete ones that are currently in the contract
   for (i = 0; i < o.contractBuyers.length; i++) {
      var name = o.contractBuyers[i];
      if (isNameInTextValueArray(name, o.selectedBuyers) == false) {
         // this is a new one to add to the contract
         var buyer = new Object();
         if (cgm.usage == "DelegationGrid") {
            buyer.role = "ServiceRepresentative";
         } else {
            buyer.role = "Buyer";
         }
         buyer.action = "delete";
         buyer.ParticipantMember = new Object();
         buyer.ParticipantMember.OrganizationRef = new Object();
         buyer.ParticipantMember.OrganizationRef.distinguishName = name;
         participants[participants.length] = buyer;
      }
   }

   // add the new ones
   if ((cgm.usage != "DelegationGrid") ||
       (cgm.usage == "DelegationGrid" && cgm.BaseDelegationGridChecked == false)) {
    // no participants for base delegation grids
    // only add new ones that are not currently in the contract
    for (i = 0; i < o.selectedMemberGroups.length; i++) {
      var id = o.selectedMemberGroups[i].value;
      if (isNameInTextValueArray(id, o.contractMemberGroups) == false) {
         // this is a new one to add to the contract
         var buyer = new Object();
         if (cgm.usage == "DelegationGrid") {
            buyer.role = "ServiceRepresentative";
         } else {
            buyer.role = "Buyer";
         }
         buyer.action = "new";
         buyer.ParticipantMember = new Object();
         buyer.ParticipantMember.MemberGroupRef = new Object();
         buyer.ParticipantMember.MemberGroupRef = o.MemberGroupOwners[id];
         buyer.ParticipantMember.MemberGroupRef.memberGroupName = o.selectedMemberGroups[i].text;
         participants[participants.length] = buyer;
      }
    }
    // delete the removed ones
    // only delete ones that are currently in the contract
    for (i = 0; i < o.contractMemberGroups.length; i++) {
      var id = o.contractMemberGroups[i].value;
      if (isNameInTextValueArray(id, o.selectedMemberGroups) == false) {
         // this is a new one to add to the contract
         var buyer = new Object();
         if (cgm.usage == "DelegationGrid") {
            buyer.role = "ServiceRepresentative";
         } else {
            buyer.role = "Buyer";
         }
         buyer.action = "delete";
         buyer.ParticipantMember = new Object();
         buyer.ParticipantMember.MemberGroupRef = new Object();
         buyer.ParticipantMember.MemberGroupRef = o.MemberGroupOwners[id];
         buyer.ParticipantMember.MemberGroupRef.memberGroupName = o.contractMemberGroups[i].text;
         participants[participants.length] = buyer;
      }
    }
   } // end delegation check
  }
  return true;
}

function submitDocumentationPanel(contract) {

  var o = get("ContractDocumentationModel");
  if (o != null) {
   var documents = new Array();

   // add the new ones
   // only add new ones that are not currently in the contract
   for (i = 0; i < o.selectedDocumentation.length; i++) {
      var name = o.selectedDocumentation[i];
      if (isNameInArray(name, o.contractDocumentation) == false) {
         // this is a new one to add to the contract
         var doc = new Object();
         doc.URL = name;
         doc.action = "new";
         documents[documents.length] = doc;
      }
   }
   // delete the removed ones
   // only delete ones that are currently in the contract
   // and that are not going to be added
   for (i = 0; i < o.deletedDocumentation.length; i++) {
      var name = o.deletedDocumentation[i];
      if (isNameInArray(name, o.contractDocumentation) == true &&
          isNameInArray(name, o.selectedDocumentation) == false) {
         // this is to delete from the contract
         var doc = new Object();
         doc.URL = name;
         doc.action = "delete";
         documents[documents.length] = doc;
      }
   }

   if (documents.length > 0)
      contract.Attachment = documents;
  }
  return true;
}

function submitRemarksPanel(contract) {

  var o = get("ContractRemarksModel");
  var cgm = get("ContractGeneralModel");
  if (o != null) {
   if (o.remarks.length > 0) {
      contract.comment = encodeNewLines(o.remarks);
   }
  }
  else if (cgm != null)
  {
    contract.comment = cgm.remarks;
  }
  return true;
}

function validateAllPanels()
 {
   if (this.validateGeneralPanel) {
     if (validateGeneralPanel() == false) {
   return false;
     }
   }
   if (this.validateBuyerPanel) {
     if (validateBuyerPanel() == false) {
   return false;
     }
   }
   if (this.validateDocumentationPanel) {
     if (validateDocumentationPanel() == false) {
   return false;
     }
   }
   if (this.validateRemarksPanel) {
     if (validateRemarksPanel() == false) {
   return false;
     }
   }
//alert("Before Validate Category Pricing");
   if (this.validateCategoryPricing) {
     if (validateCategoryPricing() == false) {
   return false;
     }
   }
//alert("Before Validate Custom Pricing");
   if (this.validateCustomPricing) {
     if (validateCustomPricing() == false) {
   return false;
     }
   }
   if (this.validateKitPricing)
   {
     if (validateKitPricing() == false)
     {
        return false;
     }
   }
//alert("Before Validate Shipping");
   if (this.validateShipping) {
     if (validateShipping() == false) {
   return false;
     }
   }
//alert("Before Validate Shipping Charge Adjustment");
   if (this.validateShippingChargeAdjustment) {
     if (validateShippingChargeAdjustment() == false) {
    return false;
     }
   }
//alert("Before Validate Payment");
   if (this.validatePayment) {
     if (validatePayment() == false) {
   return false;
     }
   }
//alert("Before Validate Purchase Order");
/* Po is in Account now
   if (this.validatePurchaseOrder) {
     if (validatePurchaseOrder() == false) {
   return false;
     }
   }
*/
//alert("Before Validate Invoicing");
   if (this.validateInvoicing) {
     if (validateInvoicing() == false) {
   return false;
     }
   }
//alert("Before Validate Returns");
   if (this.validateReturns) {
     if (validateReturns() == false) {
   return false;
     }
   }
//alert("Before Validate Order Approval");
   if (this.validateOrderApproval) {
     if (validateOrderApproval() == false) {
   return false;
     }
   }
//alert("Before Validate Product Constraints");
   if (this.validateProductConstraints) {
     if (validateProductConstraints() == false) {
   return false;
     }
   }
   // check that the Product Constraints data is valid
   if (checkProductConstraintsData() == false)
   return false;
//alert("Before Validate Handling Charges");
   if (this.validateHandlingCharges) {
     if (validateHandlingCharges() == false) {
   return false;
     }
   }
   if (this.validateContractExtensions) {
     if (validateContractExtensions() == false) {
   return false;
     }
   }
   //LI 2261: validate extended tc panel
   
   if (this.validateExtendedTC) {
     if (validateExtendedTC() == false) {
   return false;
     }
   }
   /*90288*/
   var o = get("ContractGeneralModel");
   if (o && o.referenceNumber == "")
   {
      // new contract, no need to unlock
   }
   else
   {
      // contract update, need to release holding locks
      if (!validateContractTCLocks())
      {
         return false;
      }
   }


  return true;
 }

function preSubmitHandler()
 {
   addURLParameter("XMLFile", "contract.ContractNotebook");
   addURLParameter("xsd", "true");

   var tradingAgreement = new Object();
   var contract = new Object();
   tradingAgreement.BuyerContract = contract;
   Xput("Package", tradingAgreement);
   putXSDnames("Package", "Package.xsd");
//   putDTDname("B2BTrading.dtd");

   var participants = new Array();
   if (this.submitBuyerPanel) {
     if (submitBuyerPanel(contract, participants) == false) {
   return false;
     }
   }

   if (participants.length > 0)
      contract.Participant = participants;

   if (this.submitDocumentationPanel) {
     if (submitDocumentationPanel(contract) == false) {
   return false;
     }
   }

   if (this.submitGeneralPanel) {
     if (submitGeneralPanel(contract) == false) {
   return false;
     }
   }

   if (this.submitRemarksPanel) {
     if (submitRemarksPanel(contract) == false) {
   return false;
     }
   }

//alert("Before Submit Category Pricing");
   if (this.submitCategoryPricing) {
     if (submitCategoryPricing(contract) == false) {
   return false;
     }
   }
//alert("Before Submit Custom Pricing");
   if (this.submitCustomPricing) {
     if (submitCustomPricing(contract) == false) {
   return false;
     }
   }
   if (this.submitKitPricing)
   {
      if (submitKitPricing(contract) == false)
      {
         return false;
      }
   }
//alert("Before Submit Shipping");
   if (this.submitShipping) {
     if (submitShipping(contract) == false) {
   return false;
     }
   }
//alert("Before Submit Shipping Charge Adjustment");
   if (this.submitShippingChargeAdjustment) {
     if (submitShippingChargeAdjustment(contract) == false) {
   return false;
     }
   }
//alert("Before Submit Payment");
   if (this.submitPayment) {
     if (submitPayment(contract) == false) {
   return false;
     }
   }
//alert("Before Submit Purchase Order");
/* PO is in Account now
   if (this.submitPurchaseOrder) {
     if (submitPurchaseOrder(contract) == false) {
   return false;
     }
   }
*/
//alert("Before Submit Invoicing");
   if (this.submitInvoicing) {
     if (submitInvoicing(contract) == false) {
   return false;
     }
   }
//alert("Before Submit Returns");
   if (this.submitReturns) {
     if (submitReturns(contract) == false) {
   return false;
     }
   }
//alert("Before Submit Order Approval");
   if (this.submitOrderApproval) {
     if (submitOrderApproval(contract) == false) {
   return false;
     }
   }
//alert("Before Submit Product Constraints");
   if (this.submitProductConstraints) {
     if (submitProductConstraints(contract) == false) {
   return false;
     }
   }
//alert("Before Submit Handling Charges");
   if (this.submitHandlingCharges) {
     if (submitHandlingCharges(contract) == false) {
   return false;
     }
   }
   if (this.submitContractExtensions) {
     if (submitContractExtensions(contract) == false) {
   return false;
     }
   }

   if (this.submitContractDates) {
     if (submitContractDates(contract) == false) {
   return false;
     }
   }
   
   
   if(this.submitCustomerTCPanel){
   		if(submitCustomerTCPanel(contract) == false){
   			return false;
   		}
   	}
   

   if (debug) {
       popupXMLwindow(tradingAgreement, "Package");
       //alert(convert2XML(tradingAgreement, "Package", "B2BTrading.dtd"));
   }

   return true;
 }

function submitErrorHandler(submitErrorMessage, submitErrorStatus)
 {
  if (submitErrorStatus == "DuplicatedContractName")
   {
    put("contractExists", true);
    gotoPanel("notebookGeneral");
   }
  else if (submitErrorStatus == "ContractMarkForDelete")
   {
    put("contractMarkForDelete", true);
    gotoPanel("notebookGeneral");
   }
  else if (submitErrorStatus == "ContractHasBeenChanged")
   {
    put("contractHasBeenChanged", true);
    gotoPanel("notebookGeneral");
   }
  else
   {
    put("contractGenericError", true);
    gotoPanel("notebookGeneral");
   }

 }

function submitFinishHandler(submitFinishMessage)
 {
  if (submitFinishMessage != null && submitFinishMessage != "") {
   var o = get("ContractGeneralModel");
   if (o.referenceNumber == "") {
      // new contract
      alertDialog(submitFinishMessage);
   }
  }

/*90288*/
//  submitCancelHandler();
   if (top.goBack)
   {
      top.goBack();
   }
   else
   {
      window.location.replace("NewDynamicListView?ActionXMLFile=contract.ContractList&cmd=ContractListView");
   }

 }

function submitCancelHandler()
{
   /*90288*/
   var o = get("ContractGeneralModel");
   if (o && o.referenceNumber == "")
   {
      // new contract, no need to unlock
      if (top.goBack)
      {
         top.goBack();
      }
      else
      {
         window.location.replace("NewDynamicListView?ActionXMLFile=contract.ContractList&cmd=ContractListView");
      }
   }
   else
   {
      // contract update, need to release holding locks
      waitForAllTCsUnlock = true;
      unlockContractTCs("submitCancelHandler");
      window.setTimeout("waitForAllTCsUnlockBack()", 500);
      return;
   }
}



/*90288*/
//-----------------------------------------------------------
// Function: wait before doing goBack until the 'waitForAllTCsUnlock'
//           is set to false by user's page. (no pause/sleep functions
//           available in javascript)
//-----------------------------------------------------------
var waitForAllTCsUnlock;
function waitForAllTCsUnlockBack()
{
   //alert("waitForAllTCsUnlockBack");
   if (waitForAllTCsUnlock)
   {
      window.setTimeout("waitForAllTCsUnlockBack()", 500);
      return;
   }

   //alert("Do the rest of original submitCancelHandler does");

   // Do the rest of original submitCancelHandler does
   if (top.goBack)
   {
      top.goBack();
   }
   else
   {
      window.location.replace("NewDynamicListView?ActionXMLFile=contract.ContractList&cmd=ContractListView");
   }
}


/*90288*/
//-----------------------------------------------------------
// This is a callback function from the bread crumb container,
// it allows the notebook to perform clean up job when user
// click a bread crumb link from a notebook.
// For contract notebook, it will perform the contract terms
// and conditions unlock operations.
//-----------------------------------------------------------
function cancelOnBCT()
{
   /*d94070*/
   if (parent.confirmDialog(top.confirm_message)==false)
   {
      // User chooses to stay and edit more
      return false;
   }


   var o = get("ContractGeneralModel");
   if (o && o.referenceNumber == "")
   {
      // new contract, no need to unlock
      top.mccbanner.waitForCancel = false;
   }
   else
   {
      // contract update, need to release holding locks
      unlockContractTCs("cancelOnBCT");
   }

   return true;
}


/*90288*/
//----------------------------------------------------------------
// This is a callback function from the ContractTCLockHelperFrame
//----------------------------------------------------------------
function contractTCLockHelperFrameDone(callbackID, overallResultCode, resultCodes)
{
   //alert("callbackID = " + callbackID);

   if (callbackID=="cancelOnBCT")
   {
      top.mccbanner.waitForCancel = false;
      return;
   }
   else if (callbackID=="submitCancelHandler")
   {
      waitForAllTCsUnlock = false;
   }
   else if (callbackID=="unlockAndLockContractTC")
   {
      return;
   }
   else if (callbackID=="validateContractTCLocks")
   {
      checkAllTCUnlockResult(overallResultCode, resultCodes);
   }
}


/*90288*/
//--------------------------------------------------------------
// This function dynamically creates an invisible iframe as the
// channel to invoke backend services to unlock and relock the
// specific terms and conditions for the contract.
//
//       contractID - specify the contract ID
//
//       tctype - specify the terms and condition type, valid
//                options are listed below:
//                      1 - Pricing TC
//                      2 - Shipping TC
//                      3 - Payment TC
//                      4 - Returns TC
//                      5 - Order Approval TC
//                      6 - General, Participants, Attachment,
//                          and Remarks Pages
//
//--------------------------------------------------------------
function unlockAndLockContractTC(contractID, tctype)
{
   //alert("unlockAndLockContractTC(" + contractID + "," + tctype + ") entry");

   var callbackID = "unlockAndLockContractTC";
   var lockHelperIFrame = document.createElement("IFRAME");
   lockHelperIFrame.id="LockHelperIFrame_1";
   lockHelperIFrame.src="/webapp/wcs/tools/servlet/ContractTCLockHelperFrameView";
   lockHelperIFrame.style.position = "absolute";
   lockHelperIFrame.style.visibility = "hidden";
   lockHelperIFrame.style.height="0";
   lockHelperIFrame.style.width="0";
   lockHelperIFrame.frameborder="0";
   lockHelperIFrame.MARGINHEIGHT="0";
   lockHelperIFrame.MARGINWIDTH="0";


   // Require to remove the existing LockHelperIFrame_1 iframe if it
   // is existed, and replace a new one. Otherwise, after the first time
   // of this function is being called, all the subsequence calls to
   // this function will not take effect invoking the URL in the iframe.
   var oldElem = document.getElementById("LockHelperIFrame_1");
   if (oldElem)
   {
      //alert("oldElem is found");
      var removedNode = oldElem.parentNode.replaceChild(lockHelperIFrame, oldElem);
   }
   else
   {
      //alert("oldElem is not found");
      document.body.appendChild(lockHelperIFrame);
   }


   // Prepare the proper URL to invoke the helper
   var webAppPath = "/webapp/wcs/tools/servlet/ContractTCLockHelperFrameView";
   var queryString = "?contractid=" + contractID
                     + "&tctype=" + tctype
                     + "&service=1"
                     + "&callbackid=" + callbackID;

   document.all[lockHelperIFrame.id].src=webAppPath + queryString;

   //alert("unlockAndLockContractTC(" + contractID + "," + tctype + ") exit");
}


/*90288*/
//--------------------------------------------------------------
// This function dynamically creates an invisible iframe as the
// channel to invoke backend services to unlock the necessary
// terms and conditions for the contract.
//--------------------------------------------------------------
function unlockContractTCs(callbackID)
{
   if (callbackID==null) { callbackID = "normal"; }

   var ccmd = get("ContractCommonDataModel", null);
   if (ccmd==null)
   {
      contractTCLockHelperFrameDone(callbackID, null, null);
      return;
   }

   //-----------------------------------------------------------------
   // Construct the IFRAME as the action frame for doing the unlocking
   //-----------------------------------------------------------------
   var lockHelperIFrame = document.createElement("IFRAME");
   lockHelperIFrame.id="LockHelperIFrame";
   lockHelperIFrame.src="/webapp/wcs/tools/servlet/ContractTCLockHelperFrameView";
   lockHelperIFrame.style.position = "absolute";
   lockHelperIFrame.style.visibility = "hidden";
   lockHelperIFrame.style.height="0";
   lockHelperIFrame.style.width="0";
   lockHelperIFrame.frameborder="0";
   lockHelperIFrame.MARGINHEIGHT="0";
   lockHelperIFrame.MARGINWIDTH="0";


   // Require to remove the existing LockHelperIFrame iframe if it
   // is existed, and replace a new one. Otherwise, after the first time
   // of this function is being called, all the subsequence calls to
   // this function will not take effect invoking the URL in the iframe.
   var oldElem = document.getElementById("LockHelperIFrame");
   if (oldElem)
   {
      //alert("oldElem is found");
      var removedNode = oldElem.parentNode.replaceChild(lockHelperIFrame, oldElem);
   }
   else
   {
      //alert("oldElem is not found");
      document.body.appendChild(lockHelperIFrame);
   }


   var queryString = "?tctype=0&service=2";
   var webAppPath = "/webapp/wcs/tools/servlet/ContractTCLockHelperFrameView";
   var traceLog = "";
   var contractID = "";

   //----------------------------
   // Unlock Pricing TC
   //----------------------------
   if (ccmd.tcLockInfo["PricingTC"]!=null)
   {
      if (ccmd.tcLockInfo["PricingTC"].shouldTCbeSaved==true)
      {
         traceLog += "PricingTC,";
         contractID = ccmd.tcLockInfo["PricingTC"].contractID;
         queryString += "&pricingtc=1";
      }
   }

   //-----------------------------
   // Unlock Shipping TC
   //-----------------------------
   if (ccmd.tcLockInfo["ShippingTC"]!=null)
   {
      if (ccmd.tcLockInfo["ShippingTC"].shouldTCbeSaved==true)
      {
         traceLog += "ShippingTC,";
         contractID = ccmd.tcLockInfo["ShippingTC"].contractID;
         queryString += "&shippingtc=1";
      }
   }

   //----------------------------
   // Unlock Payment TC
   //----------------------------
   if (ccmd.tcLockInfo["PaymentTC"]!=null)
   {
      if (ccmd.tcLockInfo["PaymentTC"].shouldTCbeSaved==true)
      {
         traceLog += "PaymentTC,";
         contractID = ccmd.tcLockInfo["PaymentTC"].contractID;
         queryString += "&paymenttc=1";
      }
   }

   //----------------------------
   // Unlock Returns TC
   //----------------------------
   if (ccmd.tcLockInfo["ReturnsTC"]!=null)
   {
      if (ccmd.tcLockInfo["ReturnsTC"].shouldTCbeSaved==true)
      {
         traceLog += "ReturnsTC,";
         contractID = ccmd.tcLockInfo["ReturnsTC"].contractID;
         queryString += "&returnstc=1";
      }
   }

   //-----------------------------------
   // Unlock Order Approval TC
   //-----------------------------------
   if (ccmd.tcLockInfo["OrderApprovalTC"]!=null)
   {
      if (ccmd.tcLockInfo["OrderApprovalTC"].shouldTCbeSaved==true)
      {
         traceLog += "OrderApprovalTC,";
         contractID = ccmd.tcLockInfo["OrderApprovalTC"].contractID;
         queryString += "&orderapprovaltc=1";
      }
   }

   //--------------------------------------------------------------------
   // Unlock General, Participants, Remarks, & Attachment Pages
   //--------------------------------------------------------------------
   if (ccmd.tcLockInfo["GeneralOthersPages"]!=null)
   {
      if (ccmd.tcLockInfo["GeneralOthersPages"].shouldTCbeSaved==true)
      {
         traceLog += "GeneralOthersPages";
         contractID = ccmd.tcLockInfo["GeneralOthersPages"].contractID;
         queryString += "&otherpages=1";
      }
   }

   // If no unlock operation is needed, invoke the unlockDone() to close the job.
   //alert("traceLog=" + traceLog);
   if (traceLog=="")
   {
      contractTCLockHelperFrameDone(callbackID, null, null);
   }
   else
   {
      queryString += "&contractid=" + contractID + "&callbackid=" + callbackID;
      document.all[lockHelperIFrame.id].src = webAppPath + queryString;
   }
}


/*90288*/
//------------------------------------------------------------------------
// Store the warning message chuncks. The valid keyName is listed below:
//      "tcNamePricing"
//      "tcNameShipping"
//      "tcNamePayment"
//      "tcNameReturns"
//      "tcNameOrderApproval"
//      "tcNameGeneralPages"
//      "msgInvalidLockForTC"
//      "msgInvalidLockForPages"
//------------------------------------------------------------------------
function setUnlockWarningMsgMap(keyName, content)
{
   var ccmd = get("ContractCommonDataModel", null);
   if (ccmd==null) { return; } //skip if data model not found

   ccmd.unlockWarningMsgMap[keyName] = content;
}


/*90288*/
// The 'hasCalled' flag helps avoiding endless loop to be
// happended when the tools framework's finish() is invoked.
var hasCalled_validateContractTCLocks=false;


/*90288*/
//------------------------------------------------
// This function use the lock helper to validate
// the exisiting TC locks for the contract
//------------------------------------------------
function validateContractTCLocks()
{
   if (!hasCalled_validateContractTCLocks)
   {
      //alert("unlock all TCs");

      unlockContractTCs("validateContractTCLocks");

      // Returning false will stop the tools framework submitting
      // the data to the backend. And it will wait for the lock
      // helper frame to callback with the result.
      return false;
   }
   else
   {
      //alert("unlock all TCs no need");
      hasCalled_validateContractTCLocks = false;
      return true;
   }
}


/*90288*/
//--------------------------------------------------------------
// This is a callback's callback function. When the lock helper
// frame is done, it callbacks the contractTCLockHelperFrameDone()
// which will call this function iff the lock helper invocation
// is originated from validateContractTCLocks() calling.
// This function will examine the return code from the unlock
// operation and prompt a warning message to user if appropiate.
//--------------------------------------------------------------
function checkAllTCUnlockResult(overallRC, rcList)
{
   var msg="";
   //alert("checkAllTCUnlockResult(), overallRC=" + overallRC + "\n" + msg);

   if (overallRC!=null)
   {
      if (rcList[1]!=0) {  msg += "pricing RC=" + rcList[1] + "\n"; }
      if (rcList[2]!=0) {  msg += "shipping RC=" + rcList[2] + "\n"; }
      if (rcList[3]!=0) {  msg += "payment RC=" + rcList[3] + "\n"; }
      if (rcList[4]!=0) {  msg += "returns RC=" + rcList[4] + "\n"; }
      if (rcList[5]!=0) {  msg += "order approval RC=" + rcList[5] + "\n"; }
      if (rcList[6]!=0) {  msg += "others RC=" + rcList[6] + "\n"; }
   }
   else
   {
      // The 'overallRC' may be set to NULL if user doesn't make changes on the
      // contract but clicking OK button. Thus, reset the value to 1 so that
      // the logic flow can continue.
      submitCancelHandler();
      return;
   }

   if (overallRC=="1")
   {
      // Unlock is executed perfectly, reset the 'hasCalled'
      // flag and continue the data submission works to backend.

      hasCalled_validateContractTCLocks = true;
      this.finish();
   }
   else
   {
      // Fail to unlock, display warning message to the user
      hasCalled_validateContractTCLocks = false;
      var hasDisplayedWarning = false;
      var ccmd = get("ContractCommonDataModel", null);

      if ((rcList[1]!=0) && (rcList[1]!=8))
      {
         var warningMsg = ccmd.unlockWarningMsgMap["msgInvalidLockForTC"];
         warningMsg = warningMsg.replace(/%3/, ccmd.unlockWarningMsgMap["tcNamePricing"]);
         alertDialog(warningMsg);
         hasDisplayedWarning = true;
      }

      if ((rcList[2]!=0) && (rcList[2]!=8))
      {
         var warningMsg = ccmd.unlockWarningMsgMap["msgInvalidLockForTC"];
         warningMsg = warningMsg.replace(/%3/, ccmd.unlockWarningMsgMap["tcNameShipping"]);
         alertDialog(warningMsg);
         hasDisplayedWarning = true;
      }

      if ((rcList[3]!=0) && (rcList[3]!=8))
      {
         var warningMsg = ccmd.unlockWarningMsgMap["msgInvalidLockForTC"];
         warningMsg = warningMsg.replace(/%3/, ccmd.unlockWarningMsgMap["tcNamePayment"]);
         alertDialog(warningMsg);
         hasDisplayedWarning = true;
      }

      if ((rcList[4]!=0) && (rcList[4]!=8))
      {
         var warningMsg = ccmd.unlockWarningMsgMap["msgInvalidLockForTC"];
         warningMsg = warningMsg.replace(/%3/, ccmd.unlockWarningMsgMap["tcNameReturns"]);
         alertDialog(warningMsg);
         hasDisplayedWarning = true;
      }

      if ((rcList[5]!=0) && (rcList[5]!=8))
      {
         var warningMsg = ccmd.unlockWarningMsgMap["msgInvalidLockForTC"];
         warningMsg = warningMsg.replace(/%3/, ccmd.unlockWarningMsgMap["tcNameOrderApproval"]);
         alertDialog(warningMsg);
         hasDisplayedWarning = true;
      }

      if ((rcList[6]!=0) && (rcList[6]!=8))
      {
         var warningMsg = ccmd.unlockWarningMsgMap["msgInvalidLockForPages"];
         warningMsg = warningMsg.replace(/%3/, ccmd.unlockWarningMsgMap["tcNameGeneralPages"]);
         alertDialog(warningMsg);
         hasDisplayedWarning = true;
      }

      if (hasDisplayedWarning)
      {
         // Cancel the contract changes
         submitCancelHandler();
         return;
      }
      else
      {
         // Disable the 'OK' or 'Save' button to prevent user save the inconsist data
         NAVIGATION.document.getElementsByName("OKButton")[0].disabled = true;
      }

   }

}

//LI 2261
function submitCustomerTCPanel(contract){
	var o=get("ContractCustomerTCModel");
	if(o!=null){
		var tcs=o.tcs;
		var propertiesLength = 0;
		var customerTCArray=new Array();
		var count=0;
		for(var i=0;i<tcs.length;i++){
			if(tcs[i].save){
				var ExtendTC=new Object();
				ExtendTC.type=tcs[i].type;
				ExtendTC.Property=new Array();
				var propertyArray=new Array();
				var properties=tcs[i].properties;
				var action=tcs[i].action;
				var referenceNum=tcs[i].referenceNumber;
				if(action=='update' && referenceNum!=null && referenceNum!=""){
					ExtendTC.action=action;
					ExtendTC.referenceNumber=referenceNum;
				}
				else{
					ExtendTC.action='new';
				}
				for(var j=0;j<properties.length;j++){
					propertiesLength++;
					Property=new Object();
					Property.name=properties[j].name;
					Property.value=properties[j].value;
					ExtendTC.Property[j]=Property;
				}
				customerTCArray[count++]=ExtendTC;
			}
		}
		if(propertiesLength>0){
			contract.TermCondition=customerTCArray;
		}
	}
	return true;
	
}

function validateExtendedTC(){
	var o=get("ContractCustomerTCModel");
	if(o!=null){
		var tcs=o.tcs;
		for(var i=0;i<tcs.length;i++){
			if(tcs[i].save){
				var properties=tcs[i].properties;
				for(var j=0;j<properties.length;j++){
					if(properties[j].required=='true' && (properties[j].value==null || properties[j].value=="null" || properties[j].value=="")){
						put("requiredProperyEmpty",true);
						put("errorTCName",tcs[i].displayName);
						put("errorPropertyName",properties[j].displayName);
						gotoPanel("notebookExtendedTC");
						return false;
					}
				}
			}
		}
	}
	return true;
}
