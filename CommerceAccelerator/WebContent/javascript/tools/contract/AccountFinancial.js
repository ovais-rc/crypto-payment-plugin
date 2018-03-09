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

function AccountFinancialModel ()
{
  var addrMemberObj = new Object();
  var policyMemberObj = new Object();
  this.addrMemberObj = addrMemberObj;
  this.policyMemberObj = policyMemberObj;
  this.storeMemberType="";
  this.memberID="";
  this.memberDN="";
  this.storeID="";
	this.referenceNumber="";
	this.policyName="";
	this.allowCredit=false;
	this.action = "";
	this.displayName = "";
	this.addressName = "";
	this.pPStoreMemberId = "";
	this.pPStoreMemberDN = "";
	this.pPStoreIdentity = "";
	var atts = new Array();
	this.atts = atts;
}

function validateFinancialPanel ()
{
  var o = get("AccountFinancialModel", null);
  var acm = get("AccountCustomerModel", null);
  if (o != null && acm != null)
  {
	  if (o.allowCredit && o.displayName=="")
	  {
	    put("displayNameIsNull", true);
	    gotoPanel("notebookFinancial");
	    return false;
	  }
    
	  if (!isValidUTF8length(o.displayName, 254))
	  {
	    put("displayNameTooLong", true);
	    gotoPanel("notebookFinancial");
	    return false;
	  }
	  
	  if (o.allowCredit && (acm.org != o.memberID) && o.addressName!="")
	  {
	    put("customerOrgChanged", true);
	    gotoPanel("notebookFinancial");
	    return false;
	  }
	  
	  if (o.allowCredit && o.atts != null) {
		for (var j=0; j<o.atts.length; j++) {
			if (o.atts[j].name != "" && o.atts[j].value == "") {
				put("accountFinancialFormMissValue", true);
				gotoPanel("notebookFinancial");
				return false;
			}
		}
	}
	  
  }
  return true;
}

function submitFinancialPanel (account)
{
	var afm = get("AccountFinancialModel", null);
  var financial = new Object();
  if (afm!=null)
  { 
    if (afm.allowCredit && (afm.action=="noaction"))
    {
      financial.action="update";
    }
    else if (!afm.allowCredit && (afm.action=="noaction"))
    {
      financial.action="delete";
    }
    else if (!afm.allowCredit && (afm.action=="new"))
    {
      return;
    }
    else
    {
      financial.action=afm.action;
    }
    if (afm.referenceNumber!=null && afm.referenceNumber!="")
      financial.referenceNumber=afm.referenceNumber;
  
    financial.PaymentMethod=new Object();
    
    financial.PaymentMethod.PaymentPolicyRef=new Object();
    financial.PaymentMethod.PaymentPolicyRef.policyName = afm.policyName;
    financial.PaymentMethod.PaymentPolicyRef.StoreRef = new Object();
    financial.PaymentMethod.PaymentPolicyRef.StoreRef.name = afm.pPStoreIdentity;
    financial.PaymentMethod.PaymentPolicyRef.StoreRef.Owner=new Object();
    financial.PaymentMethod.PaymentPolicyRef.StoreRef.Owner=afm.policyMemberObj;
    
    financial.PaymentMethod.BillToAddress = new Object();
    financial.PaymentMethod.BillToAddress.AddressReference = new Object();
    financial.PaymentMethod.BillToAddress.AddressReference.Owner = afm.addrMemberObj;
    financial.PaymentMethod.BillToAddress.AddressReference.nickName = afm.addressName;
    
    financial.PaymentMethod.PaymentMethodDisplayString = new Object();
    financial.PaymentMethod.PaymentMethodDisplayString.name = afm.displayName;
    
    if (afm.atts != null)
    {
      atts = new Array();
      for (var j=0; j<afm.atts.length; j++)
      {
        //if (afm.atts[j].name != "" && afm.atts[j].value != "")
        // even user didn't input anything to the dynamic form, we still need to send name back to the server
        if (afm.atts[j].name != "")
        {
          atts[j] = new Object();
          atts[j].AttributeValue=new Object();
          atts[j].attributeName = afm.atts[j].name;
          atts[j].AttributeValue.value = afm.atts[j].value;
          atts[j].AttributeValue.operator = "="; //for payment TC, operator is always '='
        }
      }
      if (atts.length != 0)
      {
        financial.PaymentMethod.AttributeDetail = atts;
      }
    }
  
    if(afm.displayName!="")
      account.PaymentTC=financial;
    
  }
	return true;
}


