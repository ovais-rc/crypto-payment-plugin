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

function ContractShippingModeModel() {
  var availableModes = new Array();
  this.availableModes = availableModes;
  var selectedModes = new Array();
  this.selectedModes = selectedModes;
  var initialModes = new Array();
  this.initialModes = initialModes;
  var initialRefNum = new Array();
  this.initialRefNum = initialRefNum;
  this.policyType = "";
  this.storeId = "";
  this.policyList = new Array();
}

function ContractShippingChargeModel() {
  var availableCharges = new Array();
  this.availableCharges = availableCharges;
  var selectedCharges = new Array();
  this.selectedCharges = selectedCharges;
  var initialCharges = new Array();
  this.initialCharges = initialCharges;
  var initialRefNum = new Array();
  this.initialRefNum = initialRefNum;
  this.policyType = "";
  this.storeId = "";
  this.policyList = new Array();
}

function ContractShippingAddressModel() {
  var availableAddresses = new Array();
  this.availableAddresses = availableAddresses;
  var selectedAddresses = new Array();
  this.selectedAddresses = selectedAddresses;
  var initialAddresses = new Array();
  this.initialAddresses = initialAddresses;
  var initialRefNum = new Array();
  this.initialRefNum = initialRefNum;
  this.memberId = "";
  this.memberDN = "";
  this.hasAddressBookTC = false;
  this.usePersonal = false;
  this.useParent = false;
  this.useAccount = false;
}


function createXMLShippingModeModel(csm, contract) {

     if (csm != null) {
      //var ccdm = get("ContractCommonDataModel", null);
   // load data to dynamic list
   var selectedList = csm.selectedModes;
   var initialList = csm.initialModes;
   var initialRefNum = csm.initialRefNum;
   var policyType = csm.policyType;
   var storeId = csm.storeId;
        var policyList = csm.policyList;
   var TC = new Array();
   var isThere = false;
   var count = 0;

   // check for new modes - compare each selectedModes with initialModes
   for (var i=0; i<selectedList.length; i++) {
     isThere = false;
     for (var j=0; j<initialList.length; j++) {
      if (selectedList[i].value == initialList[j].value) {
         isThere = true;
         break;
      }
     }
     // add new mode if it does not appear in the initialModes
     if (isThere == false) {
      TC[count] = new Object();
      TC[count].action = "new";
      TC[count].ShippingModePolicyRef = new Object();
      TC[count].ShippingModePolicyRef.policyName = selectedList[i].value;
      var policyIndex = findIndexInPolicyList(policyList, selectedList[i].value);
      TC[count].ShippingModePolicyRef.StoreRef = new Object();
      TC[count].ShippingModePolicyRef.StoreRef.name = policyList[policyIndex].storeIdentity;
      TC[count].ShippingModePolicyRef.StoreRef.Owner = new Object();
      TC[count].ShippingModePolicyRef.StoreRef.Owner = policyList[policyIndex].member;
      count++;
     }
   }

   // check for delete modes - compare each initialModes with selectedModes
   for (var k=0; k<initialList.length; k++) {
     isThere = false;
     for (var l=0; l<selectedList.length; l++) {
      if (initialList[k].value == selectedList[l].value) {
         isThere = true;
         break;
      }
     }
     // add delete mode if it does not appear in the selectedModes
     if (isThere == false) {
      TC[count] = new Object();
      TC[count].action = "delete";
      TC[count].referenceNumber = initialRefNum[k];
      TC[count].ShippingModePolicyRef = new Object();
      TC[count].ShippingModePolicyRef.policyName = initialList[k].value;
      var policyIndex = findIndexInPolicyList(policyList, initialList[k].value);
      TC[count].ShippingModePolicyRef.StoreRef = new Object();
      TC[count].ShippingModePolicyRef.StoreRef.name = policyList[policyIndex].storeIdentity;
      TC[count].ShippingModePolicyRef.StoreRef.Owner = new Object();
      TC[count].ShippingModePolicyRef.StoreRef.Owner = policyList[policyIndex].member;
      count++;
     }
   }
   //alert(convertToXML(TC));
   if (TC.length > 0) {
      contract.ShippingTCShippingMode = new Array();
      contract.ShippingTCShippingMode = TC;
      return TC;
   }
     }
     return null;
}

function createXMLShippingChargeModel(csm, contract) {

     if (csm != null) {
      //var ccdm = get("ContractCommonDataModel", null);
   // load data to dynamic list
   var selectedList = csm.selectedCharges;
   var initialList = csm.initialCharges;
   var initialRefNum = csm.initialRefNum;
   var policyType = csm.policyType;
   var storeId = csm.storeId;
        var policyList = csm.policyList;
   var TC = new Array();
   var count = 0;
   var isThere = false;

   // check for new charge types - compare each selectedCharges with initialCharges
   for (var i=0; i<selectedList.length; i++) {
     isThere = false;
     for (var j=0; j<initialList.length; j++) {
      if (selectedList[i].value == initialList[j].value) {
         isThere = true;
         break;
      }
     }
     // add new charge type if it does not appear in the initialCharges
     if (isThere == false) {
      TC[count] = new Object();
      TC[count].action = "new";
      TC[count].ShippingChargePolicyRef = new Object();
      TC[count].ShippingChargePolicyRef.policyName = selectedList[i].value;
      var policyIndex = findIndexInPolicyList(policyList, selectedList[i].value);
      TC[count].ShippingChargePolicyRef.StoreRef = new Object();
      TC[count].ShippingChargePolicyRef.StoreRef.name = policyList[policyIndex].storeIdentity;
      TC[count].ShippingChargePolicyRef.StoreRef.Owner = new Object();
      TC[count].ShippingChargePolicyRef.StoreRef.Owner = policyList[policyIndex].member;
      count++;
     }
   }
   // check for delete charge types - compare each initialCharges with selectedCharges
   for (var k=0; k<initialList.length; k++) {
     isThere = false;
     for (var l=0; l<selectedList.length; l++) {
      if (initialList[k].value == selectedList[l].value) {
         isThere = true;
         break;
      }
     }
     // add delete charge type if it does not appear in the selectedCharges
     if (isThere == false) {
      TC[count] = new Object();
      TC[count].action = "delete";
      TC[count].referenceNumber = initialRefNum[k];
      TC[count].ShippingChargePolicyRef = new Object();
      TC[count].ShippingChargePolicyRef.policyName = initialList[k].value;
      var policyIndex = findIndexInPolicyList(policyList, initialList[k].value);
      TC[count].ShippingChargePolicyRef.StoreRef = new Object();
      TC[count].ShippingChargePolicyRef.StoreRef.name = policyList[policyIndex].storeIdentity;
      TC[count].ShippingChargePolicyRef.StoreRef.Owner = new Object();
      TC[count].ShippingChargePolicyRef.StoreRef.Owner = policyList[policyIndex].member;
      count++;
     }
   }
   //alert(convertToXML(TC));
   if (TC.length > 0) {
      contract.ShippingTCShippingCharge = new Array();
      contract.ShippingTCShippingCharge = TC;
      return TC;
   }
     }
     return null;
}

function createXMLShippingAddressModel(csm, contract) {

     if (csm != null) {
   // load data to dynamic list
   var selectedList = csm.selectedAddresses;
   var initialList = csm.initialAddresses;
   var initialRefNum = csm.initialRefNum;
   var memberId = csm.memberId;
   var memberDN = csm.memberDN;
   var TC = new Array();
   var isThere;
   var count = 0;

   // check for new Addressess - compare each selectedAddress with initialAddress
   for (var i=0; i<selectedList.length; i++) {
     isThere = false;
     for (var j=0; j<initialList.length; j++) {
      if (selectedList[i].value == initialList[j].value) {
         isThere = true;
         break;
      }
     }
     // add new address if it does not appear in the initialAddress
     if (isThere == false) {
      if (count == 0) {
         contract.ShippingTCShipToAddress = new Array();
      }
      contract.ShippingTCShipToAddress[count] = new Object();
      contract.ShippingTCShipToAddress[count].action = "new";
      contract.ShippingTCShipToAddress[count].AddressReference = new Object();
      contract.ShippingTCShipToAddress[count].AddressReference.nickName = selectedList[i].text;
      contract.ShippingTCShipToAddress[count].AddressReference.Owner = new Object();
      contract.ShippingTCShipToAddress[count].AddressReference.Owner.OrganizationRef = new Object();
      contract.ShippingTCShipToAddress[count].AddressReference.Owner.OrganizationRef.distinguishName = memberDN;
      count++;
     }
   }

   // check for delete Addressess - compare each initialAddress with selectedAddress
   for (var k=0; k<initialList.length; k++) {
     isThere = false;
     for (var l=0; l<selectedList.length; l++) {
      if (initialList[k].value == selectedList[l].value) {
         isThere = true;
         break;
      }
     }
     // add delete address if it does not appear in the selectedAddress
     if (isThere == false) {
      if (count == 0) {
         contract.ShippingTCShipToAddress = new Array();
      }
      contract.ShippingTCShipToAddress[count] = new Object();
      contract.ShippingTCShipToAddress[count].action = "delete";
      contract.ShippingTCShipToAddress[count].referenceNumber = initialRefNum[k];
      contract.ShippingTCShipToAddress[count].AddressReference = new Object();
      contract.ShippingTCShipToAddress[count].AddressReference.nickName = initialList[k].text;
      contract.ShippingTCShipToAddress[count].AddressReference.Owner = new Object();
      contract.ShippingTCShipToAddress[count].AddressReference.Owner.OrganizationRef = new Object();
      contract.ShippingTCShipToAddress[count].AddressReference.Owner.OrganizationRef.distinguishName = memberDN;
      count++;
     }
   }

   // AddressBookTC
   var allUnchecked = true;
   if (csm.usePersonal == true) { allUnchecked = false; }
   if (csm.useParent == true)   { allUnchecked = false; }
   if (csm.useAccount == true)  { allUnchecked = false; }
   if (csm.hasAddressBookTC == true && allUnchecked == true) {
      // contract has address book tc, but none of the options are selected
      // this is a delete
      contract.AddressBookTC = new Array();
      contract.AddressBookTC[0] = new Object();
      contract.AddressBookTC[0].usage = "shipping";
      contract.AddressBookTC[0].usePersonal = csm.usePersonal;
      contract.AddressBookTC[0].useParentOrganization = csm.useParent;
      contract.AddressBookTC[0].useAccountHolderOrganization = csm.useAccount;
      contract.AddressBookTC[0].action = "delete";
      contract.AddressBookTC[0].referenceNumber = csm.addressBookReferenceNumber;
   }
   else if (csm.hasAddressBookTC == true) {
      // contract has address book tc, need to update
      // this is a change
      contract.AddressBookTC = new Array();
      contract.AddressBookTC[0] = new Object();
      contract.AddressBookTC[0].usage = "shipping";
      contract.AddressBookTC[0].usePersonal = csm.usePersonal;
      contract.AddressBookTC[0].useParentOrganization = csm.useParent;
      contract.AddressBookTC[0].useAccountHolderOrganization = csm.useAccount;
      contract.AddressBookTC[0].action = "update";
      contract.AddressBookTC[0].referenceNumber = csm.addressBookReferenceNumber;
   }
   else if (csm.hasAddressBookTC == false && allUnchecked == false) {
      // contract does not have address book tc, need to create
      // this is new
      contract.AddressBookTC = new Array();
      contract.AddressBookTC[0] = new Object();
      contract.AddressBookTC[0].usage = "shipping";
      contract.AddressBookTC[0].usePersonal = csm.usePersonal;
      contract.AddressBookTC[0].useParentOrganization = csm.useParent;
      contract.AddressBookTC[0].useAccountHolderOrganization = csm.useAccount;
      contract.AddressBookTC[0].action = "new";
   }

   //alert(convertToXML(TC));
   if (TC.length > 0) {
      return TC;
   }
     }
     return null;
}

function validateShippingMode() {
  return true;
}

function validateShippingCharge() {
  return true;
}

function validateShippingAddress() {
  return true;
}

function validateShipping() {
     if ((validateShippingMode() == false) || (validateShippingCharge() == false) || (validateShippingAddress() == false)) {
   return false;
     }
}

function submitShipping(contract) {

   /*90288*/
   var ccdm = get("ContractCommonDataModel");
   if (ccdm)
   {
      if (ccdm.tcLockInfo["ShippingTC"]!=null)
      {
         if (ccdm.tcLockInfo["ShippingTC"].shouldTCbeSaved==false)
         {
            // Skip saving the terms and conditions
            return;
         }
      }
   }

  var modeM = get("ContractShippingModeModel", null);
  var chargeM = get("ContractShippingChargeModel", null);
  var addressM = get("ContractShippingAddressModel", null);

  var modeTC = createXMLShippingModeModel(modeM, contract);
  var chargeTC = createXMLShippingChargeModel(chargeM, contract);
  var addressTC = createXMLShippingAddressModel(addressM, contract);

  return true;
}

