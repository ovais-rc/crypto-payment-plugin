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

function ContractPaymentModel () {
   var paymentMethod = new Array();
   this.paymentMethod = paymentMethod;
   this.policyType="Payment";
   this.allowCredit=false;
   this.storeIdentity = "";
   this.storeMemberId = "";
        this.hasAddressBookTC = false;
        this.usePersonal = false;
        this.useParent = false;
        this.useAccount = false;
}

function validatePayment () {
   return true;
}

function submitPayment (contract) {

   /*90288*/
   var ccdm = get("ContractCommonDataModel");
   if (ccdm)
   {
      if (ccdm.tcLockInfo["PaymentTC"]!=null)
      {
         if (ccdm.tcLockInfo["PaymentTC"].shouldTCbeSaved==false)
         {
            // Skip saving the terms and conditions
            return;
         }
      }
   }

   var cpm = get("ContractPaymentModel", null);
   //var ccdm = get("ContractCommonDataModel",null);

   var o = convertLocalModelToPayment(cpm, contract);
  if (o!=null && o.length > 0)
  {
      // don't loose any changes made by the Credit Line page
      if (defined(contract.PaymentTC)) {
         var save = contract.PaymentTC;
         contract.PaymentTC = new Array();
         contract.PaymentTC = o;
         contract.PaymentTC[contract.PaymentTC.length] = save;
      } else {
         contract.PaymentTC = new Array();
         contract.PaymentTC = o;
      }
  }

  if (cpm != null)
  {
   // AddressBookTC
   var allUnchecked = true;
   if (cpm.usePersonal == true) { allUnchecked = false; }
   if (cpm.useParent == true)   { allUnchecked = false; }
   if (cpm.useAccount == true)  { allUnchecked = false; }
   if (cpm.hasAddressBookTC == true && allUnchecked == true) {
      // contract has address book tc, but none of the options are selected
      // this is a delete
      var index = 1;
      if (contract.AddressBookTC == null) {
         contract.AddressBookTC = new Array();
         index = 0;
      }
      contract.AddressBookTC[index] = new Object();
      contract.AddressBookTC[index].usage = "billing";
      contract.AddressBookTC[index].usePersonal = cpm.usePersonal;
      contract.AddressBookTC[index].useParentOrganization = cpm.useParent;
      contract.AddressBookTC[index].useAccountHolderOrganization = cpm.useAccount;
      contract.AddressBookTC[index].action = "delete";
      contract.AddressBookTC[index].referenceNumber = cpm.addressBookReferenceNumber;
   }
   else if (cpm.hasAddressBookTC == true) {
      // contract has address book tc, need to update
      // this is a change
      var index = 1;
      if (contract.AddressBookTC == null) {
         contract.AddressBookTC = new Array();
         index = 0;
      }
      contract.AddressBookTC[index] = new Object();
      contract.AddressBookTC[index].usage = "billing";
      contract.AddressBookTC[index].usePersonal = cpm.usePersonal;
      contract.AddressBookTC[index].useParentOrganization = cpm.useParent;
      contract.AddressBookTC[index].useAccountHolderOrganization = cpm.useAccount;
      contract.AddressBookTC[index].action = "update";
      contract.AddressBookTC[index].referenceNumber = cpm.addressBookReferenceNumber;
   }
   else if (cpm.hasAddressBookTC == false && allUnchecked == false) {
      // contract does not have address book tc, need to create
      // this is new
      var index = 1;
      if (contract.AddressBookTC == null) {
         contract.AddressBookTC = new Array();
         index = 0;
      }
      contract.AddressBookTC[index] = new Object();
      contract.AddressBookTC[index].usage = "billing";
      contract.AddressBookTC[index].usePersonal = cpm.usePersonal;
      contract.AddressBookTC[index].useParentOrganization = cpm.useParent;
      contract.AddressBookTC[index].useAccountHolderOrganization = cpm.useAccount;
      contract.AddressBookTC[index].action = "new";
   }
  }

   return true;
}



function convertLocalModelToPayment(o, contract)
{
  var cpm = new Object();
  cpm = o;
  var referenceNumber = new Array();

   if (cpm != null)
   {
      // load data to list from parent javascript object

      myPaymentList = cpm.paymentMethod;

      if (myPaymentList!=null)
      {
        paymentList = new Array();
        paymentAction = new Array();

        for (var i=0; i < myPaymentList.length; i++)
        {
          paymentList[i] = new Object();

         paymentAction[i] = myPaymentList[i].action;

        if(myPaymentList[i].referenceNumber!=null && myPaymentList[i].referenceNumber!="")
        {
          referenceNumber[i]=myPaymentList[i].referenceNumber;
        }
        else
        {
          referenceNumber[i]="";
        }

          //PaymentMethod
          paymentList[i].PaymentMethod = new Object();

          //PolicyReference

          paymentList[i].PaymentMethod.PaymentPolicyRef = new Object();
          paymentList[i].PaymentMethod.PaymentPolicyRef.policyName = myPaymentList[i].paymentPolicy;
          paymentList[i].PaymentMethod.PaymentPolicyRef.StoreRef = new Object();
          paymentList[i].PaymentMethod.PaymentPolicyRef.StoreRef.name = myPaymentList[i].storeIdentity;
          paymentList[i].PaymentMethod.PaymentPolicyRef.StoreRef.Owner=new Object();
          paymentList[i].PaymentMethod.PaymentPolicyRef.StoreRef.Owner=myPaymentList[i].storeMemberObj;

          //BillToAddress
          if (myPaymentList[i].addressName != "") {
          paymentList[i].PaymentMethod.BillToAddress = new Object();
          paymentList[i].PaymentMethod.BillToAddress.AddressReference = new Object();

          paymentList[i].PaymentMethod.BillToAddress.AddressReference.Owner = new Object();
          paymentList[i].PaymentMethod.BillToAddress.AddressReference.Owner = myPaymentList[i].member_obj;

          paymentList[i].PaymentMethod.BillToAddress.AddressReference.nickName = myPaymentList[i].addressName;
      }

          //PaymentMethodDisplayString
          paymentList[i].PaymentMethod.PaymentMethodDisplayString = new Object();
          paymentList[i].PaymentMethod.PaymentMethodDisplayString.name = myPaymentList[i].name;

          //Attribute
          if (myPaymentList[i].atts != null)
        {
          atts = new Array();
          for (var j=0; j<myPaymentList[i].atts.length; j++)
          {
            //if (myPaymentList[i].atts[j].name != "" && myPaymentList[i].atts[j].value != "")
            // even user didn't input anything to the dynamic form, we still need to send name back to the server
            if (myPaymentList[i].atts[j].name != "")
            {
              atts[j] = new Object();
              atts[j].AttributeValue=new Object();

              atts[j].attributeName = myPaymentList[i].atts[j].name;
              atts[j].AttributeValue.value = myPaymentList[i].atts[j].value;
              atts[j].AttributeValue.operator = "="; //for payment tc, operator is always '='
            }
            }
            if (atts.length != 0)
            {
              paymentList[i].PaymentMethod.AttributeDetail = atts;
            }
          }
        }
        if (paymentList.length==0)
        {
          return null;
        }
        else
        {
          var retObj = new Array();
          var k=0;
          for (var i=0; i< paymentList.length;i++)
          {
            if (paymentAction[i] != "noaction")
            {
            retObj[k]=new Object();
            retObj[k] = paymentList[i];
            retObj[k].action = paymentAction[i];
            if (referenceNumber[i]!=null && referenceNumber[i]!="")
              retObj[k].referenceNumber=referenceNumber[i];
            k++;
          }

          }
          return retObj;
        }
      }
      else
      {
      //found model but no payment tc
        return null;
      }
   }
   else
   {
     //no model
     return null;
   }
}

function savePanelData()
{
  self.basefrm.savePanelData();
}
