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
// set this flag to false if you do not want the account to be submitted
// (created/udpated) after the XML popup appears
var submitWhileDebugging=true;

function AccountCommonDataModel()
{
  this.storeId = "";
  this.flanguageId = "";
  this.fLocale = "";
  this.storeMemberId = "";
  this.storeMemberDN = "";
  this.storeIdentity = "";
}

function AccountCustomerModel ()
{
  this.org = "";
  this.orgDN = "";
  this.initialOrg = "";
  this.initialOrgDN = "";
  this.contact = "";
  this.contactDN = "";
  this.initialContact = "";
  this.initialContactDN = "";
  this.info = "";
  this.allowPurchase = false;
  this.forBaseContracts = false;
  this.priceListType = "";
  this.mustUsePriceListPreference = false;

  this.referenceNumber = "";
  this.lastUpdateTime = "";
  this.accountName = "";

  this.remarks = "";
}

function AccountRepresentativeModel ()
{
  this.org = "";
  this.orgDN = "";
  this.initialOrg = "";
  this.initialOrgDN = "";
  this.contact = "";
  this.contactDN = "";
  this.initialContact = "";
  this.initialContactDN = "";
}

function submitCustomerPanel(account, participants) {
  var o = get("AccountCustomerModel");
  if (o != null) {

   var acm = get("AccountCommonDataModel")

   if (o.lastUpdateTime != "") {
      addURLParameter("lastUpdatedTime", o.lastUpdateTime);
   }

   if (o.referenceNumber != "") {
      // update
      account.referenceNumber = o.referenceNumber;
   } else {
      // new
      if (acm.storeMemberId.length > 0) {
         var seller = new Object();
         seller.role = "Seller";
         seller.action = "new";
         seller.ParticipantMember = new Object();
         seller.ParticipantMember.OrganizationRef = new Object();
         seller.ParticipantMember.OrganizationRef.distinguishName = acm.storeMemberDN;
         participants[participants.length] = seller;
      }
   }
   var org = o.org;
   var orgDN = o.orgDN;
   var initialOrg = o.initialOrg;
   var initialOrgDN = o.initialOrgDN;
   var contact = o.contact;
   var contactDN = o.contactDN;
   var initialContact = o.initialContact;
   var initialContactDN = o.initialContactDN;

   if (org != initialOrg) {
      // add new org to the account as it is not currently in the account
      if (org != "") {
         var ahNew = new Object();
         ahNew.role = "AccountHolder";
         ahNew.action = "new";
         ahNew.ParticipantMember = new Object();
         ahNew.ParticipantMember.OrganizationRef = new Object();
         ahNew.ParticipantMember.OrganizationRef.distinguishName = orgDN;
         participants[participants.length] = ahNew;
      }
      // delete old org from the account as it is currently in the account
      if (initialOrg != "") {
         var ahDel = new Object();
         ahDel.role = "AccountHolder";
         ahDel.action = "delete";
         ahDel.ParticipantMember = new Object();
         ahDel.ParticipantMember.OrganizationRef = new Object();
         ahDel.ParticipantMember.OrganizationRef.distinguishName = initialOrgDN;
         participants[participants.length] = ahDel;
      }
   }
   if (contact != initialContact) {
      // add new contact to the account as it is not currently in the account
      if (contact != "") {
         var bcNew = new Object();
         bcNew.role = "BuyerContact";
         bcNew.action = "new";
         bcNew.ParticipantMember = new Object();
         bcNew.ParticipantMember.UserRef = new Object();
         bcNew.ParticipantMember.UserRef.distinguishName = contactDN;
         participants[participants.length] = bcNew;
      }
      // delete old contact from the account as it is currently in the account
      if (initialContact != "") {
         var bcDel = new Object();
         bcDel.role = "BuyerContact";
         bcDel.action = "delete";
         bcDel.ParticipantMember = new Object();
         bcDel.ParticipantMember.UserRef = new Object();
         bcDel.ParticipantMember.UserRef.distinguishName = initialContactDN;
         participants[participants.length] = bcDel;
      }
   }

   if (participants.length > 0)
      account.Participant = participants;

   account.state = "active";

   account.AccountUniqueKey = new Object();
   account.AccountUniqueKey.name = o.accountName;

   if (o.referenceNumber == "") {
   	if (o.forBaseContracts) {
		// this is a new account - modify name if it is for base contracts
		account.AccountUniqueKey.name += "-BaseContracts";
	}
	// make account name unique by store
	account.AccountUniqueKey.name += "-";
	account.AccountUniqueKey.name += acm.storeId;
	
   }
	
   account.AccountUniqueKey.AccountOwner = new Object();
   account.AccountUniqueKey.AccountOwner.OrganizationRef = new Object();
   account.AccountUniqueKey.AccountOwner.OrganizationRef.distinguishName = acm.storeMemberDN;

   // Description
   var desc = new Object();
   // the contact information field is not multiple language enabled
   // however, it is stored in a multiple language table (TRDDESC)
   // always save and load from the en_US data
   desc.locale = "en_US";
   if (o.info.length > 0) {
     desc.longDescription = encodeNewLines(o.info);
   }

   account.AccountDescription = desc;

   account.CreatedInStore = new Object();
   account.CreatedInStore.StoreRef = new Object();
   account.CreatedInStore.StoreRef.name = acm.storeIdentity;
   account.CreatedInStore.StoreRef.Owner = new Object();
   account.CreatedInStore.StoreRef.Owner.OrganizationRef = new Object();
   account.CreatedInStore.StoreRef.Owner.OrganizationRef.distinguishName = acm.storeMemberDN;

   if (o.allowPurchase) {
      account.allowStoreDefaultContract = "true";
   } else {
      account.allowStoreDefaultContract = "false";
   }
   
   account.priceListPreference = o.priceListType;
   if (o.mustUsePriceListPreference) {
      account.mustUsePriceListPreference = "true";
   } else {
      account.mustUsePriceListPreference = "false";
   }   

  }
  return true;
}

function submitRepresentativePanel(account, participants) {
  var o = get("AccountRepresentativeModel");
  if (o != null) {
   var org = o.org;
   var orgDN = o.orgDN;
   var initialOrg = o.initialOrg;
   var initialOrgDN = o.initialOrgDN;
   var contact = o.contact;
   var contactDN = o.contactDN;
   var initialContact = o.initialContact;
   var initialContactDN = o.initialContactDN;

   if (org != initialOrg) {
      // add new org to the account as it is not currently in the account
      if (org != "") {
         var scOrgNew = new Object();
         scOrgNew.role = "SellerContact";
         scOrgNew.action = "new";
         scOrgNew.ParticipantMember = new Object();
         scOrgNew.ParticipantMember.OrganizationRef = new Object();
         scOrgNew.ParticipantMember.OrganizationRef.distinguishName = orgDN;
         participants[participants.length] = scOrgNew;
      }
      // delete old org from the account as it is currently in the account
      if (initialOrg != "") {
         var scOrgDel = new Object();
         scOrgDel.role = "SellerContact";
         scOrgDel.action = "delete";
         scOrgDel.ParticipantMember = new Object();
         scOrgDel.ParticipantMember.OrganizationRef = new Object();
         scOrgDel.ParticipantMember.OrganizationRef.distinguishName = initialOrgDN;
         participants[participants.length] = scOrgDel;
      }
   }
   if (contact != initialContact) {
      // add new contact to the account as it is not currently in the account
      if (contact != "") {
         var scConNew = new Object();
         scConNew.role = "SellerContact";
         scConNew.action = "new";
         scConNew.ParticipantMember = new Object();
         scConNew.ParticipantMember.UserRef = new Object();
         scConNew.ParticipantMember.UserRef.distinguishName = contactDN;
         participants[participants.length] = scConNew;
      }
      // delete old contact from the account as it is currently in the account
      if (initialContact != "") {
         var scConDel = new Object();
         scConDel.role = "SellerContact";
         scConDel.action = "delete";
         scConDel.ParticipantMember = new Object();
         scConDel.ParticipantMember.UserRef = new Object();
         scConDel.ParticipantMember.UserRef.distinguishName = initialContactDN;
         participants[participants.length] = scConDel;
      }
   }
  }
  return true;
}

function validateCustomerPanel() {

  var o = get("AccountCustomerModel");

  // ORGANIZATION
  if (o.org == "") {
    put("accountCustomerOrgRequired", true);
    gotoPanel("notebookCustomer");
    return false;
  }

  // CONTACT
  /* only if contact is a required field
  if (o.contact == "") {
    put("accountCustomerContactRequired", true);
    gotoPanel("notebookCustomer");
    return false;
  }
  */

  // CONTACT INFO
  if (!isValidUTF8length(o.info, 4000)) {
    put("accountCustomerContactInfoTooLong", true);
    gotoPanel("notebookCustomer");
    return false;
  }

  return true;
}

function validateRepresentativePanel() {

  var o = get("AccountRepresentativeModel");

  // ORGANIZATION
  if (o.org == "") {
    put("accountRepresentativeOrgRequired", true);
    gotoPanel("notebookRepresentative");
    return false;
  }

  return true;
}

function validateAllPanels()
 {
   if (this.validateCustomerPanel) {
     if (validateCustomerPanel() == false) {
   return false;
     }
   }
   if (this.validateRepresentativePanel) {
     if (validateRepresentativePanel() == false) {
   return false;
     }
   }
   if (this.validatePurchaseOrder) {
     if (validatePurchaseOrder() == false) {
   return false;
     }
   }
   if (this.validateFinancialPanel) {
     if (validateFinancialPanel() == false) {
   return false;
     }
   }
   if (this.validateRemarksPanel) {
     if (validateRemarksPanel() == false) {
   return false;
     }
   }
   if (this.validateShipping) {
     if (validateShipping() == false) {
   return false;
     }
   }
   if (this.validateShippingChargeAdjustment) {
     if (validateShippingChargeAdjustment() == false) {
	 return false;
     } 
   }   
   if (this.validatePayment) {
     if (validatePayment() == false) {
   return false;
     }
   }
   if (this.validateAccountExtensions) {
     if (validateAccountExtensions() == false) {
   return false;
     }
   }

   // Validate fields on Display Customization Panel
   if (this.validateDisplayCustomizationPanel)
   {
      if (validateDisplayCustomizationPanel() == false)
      {
         return false;
      }
   }
   //LI 2261: validate extended tc panel
   
   if (this.validateExtendedTC) {
     if (validateExtendedTC() == false) {
   return false;
     }
   }
   


  if (debug) {
      preSubmitHandler();
      if (submitWhileDebugging == false) {
          return false;
      }
  }

  return true;
 }

function preSubmitHandler()
 {

   addURLParameter("XMLFile", "contract.AccountNotebook");
   addURLParameter("xsd", "true");

   var tradingAgreement = new Object();
   var account = new Object();
   tradingAgreement.Account = account;
   Xput("Package", tradingAgreement);
   putXSDnames("Package", "Package.xsd");

   var participants = new Array();

   if (this.submitRepresentativePanel) {
     if (submitRepresentativePanel(account, participants) == false) {
   return false;
     }
   }
   if (this.submitCustomerPanel) {
     if (submitCustomerPanel(account, participants) == false) {
   return false;
     }
   }

   if (this.submitRemarksPanel) {
     if (submitRemarksPanel(account) == false) {
   return false;
     }
   }

   if (this.submitFinancialPanel) {
     if (submitFinancialPanel(account) == false) {
   return false;
     }
   }
   if (this.submitPurchaseOrder) {
     if (submitPurchaseOrder(account) == false) {
   return false;
     }
   }
   if (this.submitInvoicing) {
     if (submitInvoicing(account) == false) {
   return false;
     }
   }

   if (this.submitShipping) {
     if (submitShipping(account) == false) {
   return false;
     }
   }
   if (this.submitShippingChargeAdjustment) {
     if (submitShippingChargeAdjustment(account) == false) {
	return false;
     } 
   }
   if (this.submitPayment) {
     if (submitPayment(account) == false) {
   return false;
     }
   }

   if (this.submitAccountExtensions) {
     if (submitAccountExtensions(account) == false) {
   return false;
     }
   }

   // Invoke DisplayCustomizationTC pre-submit handler
   if (this.submitDisplayCustomizationTC)
   {
      if (submitDisplayCustomizationTC(account) == false)
      {
         return false;
      }
   }

   if(this.submitCustomerTCPanel){
   		if(submitCustomerTCPanel(account) == false){
   			return false;
   		}
   	}


   if (debug) {
       popupXMLwindow(tradingAgreement, "Trading")
       //alert(convert2XML(tradingAgreement, "Trading", "B2BTrading.dtd"));
   }

   return true;
 }

function submitErrorHandler(submitErrorMessage, submitErrorStatus)
 {
  if (submitErrorStatus == "DuplicatedAccountName")
   {
    put("accountExists", true);
    gotoPanel("notebookCustomer");
   }
  else if (submitErrorStatus == "AccountMarkForDelete")
   {
    put("accountMarkForDelete", true);
    gotoPanel("notebookCustomer");
   }
  else if (submitErrorStatus == "AccountHasBeenChanged")
   {
    put("accountHasBeenChanged", true);
    gotoPanel("notebookCustomer");
   }
  else
   {
    put("accountGenericError", true);
    gotoPanel("notebookCustomer");
   }
 }

function submitFinishHandler(submitFinishMessage)
 {
  if (submitFinishMessage != null && submitFinishMessage != "") {
   var o = get("AccountCustomerModel");
   if (o.referenceNumber == "") {
      // new account
      alertDialog(submitFinishMessage);
   }
  }
  submitCancelHandler();
 }

function submitCancelHandler()
 {
  if (top.goBack)
   {
    top.goBack();
   }
  else
   {
    window.location.replace("NewDynamicListView?ActionXMLFile=contract.AccountList&cmd=AccountListView");
   }
 }


// begin - Remarks

function validateRemarksPanel()
{
  var o = get("AccountRemarksModel");
  var acm = get("AccountCustomerModel");
  if (o != null)
  {
     if (!isValidUTF8length(o.remarks, 4000))
     {
       put("remarksTooLong", true);
       gotoPanel("notebookRemarks");
       return false;
     }
  }
  else if (acm != null)
  {
     if (!isValidUTF8length(acm.remarks, 4000))
     {
       put("remarksTooLong", true);
       gotoPanel("notebookRemarks");
       return false;
     }
  }
  return true;
}

function submitRemarksPanel(account)
{
  var o = get("AccountRemarksModel");
  var acm = get("AccountCustomerModel");
  if (o != null)
  {
     if (o.remarks.length > 0) {
      account.comment = encodeNewLines(o.remarks);
     }
  }
  else if (acm != null)
  {
    account.comment = acm.remarks;
  }
  return true;
}

// end - remarks
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
