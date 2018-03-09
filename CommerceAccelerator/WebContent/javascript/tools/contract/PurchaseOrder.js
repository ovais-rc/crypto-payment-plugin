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

function ContractPurchaseOrderModel ()
{
	var purchaseOrder = new Array();
	this.purchaseOrder = purchaseOrder;
	this.If_Specified = false;
	this.checkUniqueness = false;
	this.ifUpdateContract = false;
	this.old_If_Specified = false;
	this.old_checkUniqueness = false;
}

function validatePurchaseOrder ()
{
	return true;
}

function submitPurchaseOrder (account) {
	var cpm = get("ContractPurchaseOrderModel", null);
	var acdm = get("AccountCommonDataModel",null);
	var flanguageId=acdm.flanguageId;

	var o = convertLocalModelToPurchaseOrder(cpm, flanguageId, account);
	return true;
}


function convertLocalModelToPurchaseOrder(o, flanguageId, account)
{
  var cpm = new Object();
  cpm=o;
  var i=0;
  var purchaseOrderBlanketList = new Array();
  var purchaseOrderLimitedList = new Array();  

	if (cpm != null)
	{
		// load data to list from parent javascript object

		myPurchaseOrderList = cpm.purchaseOrder;

		if (myPurchaseOrderList!=null)
		{
			for (i=0; i < myPurchaseOrderList.length; i++)
			{
				var tc = new Object();
				tc.action=myPurchaseOrderList[i].action;
				if(myPurchaseOrderList[i].referenceNumber!=null && myPurchaseOrderList[i].referenceNumber!="")
			        {
		        	  tc.referenceNumber=myPurchaseOrderList[i].referenceNumber;
			        }

				if (myPurchaseOrderList[i].limit == "-1")
				{
				      //Blanket
				      tc.PONumber = myPurchaseOrderList[i].po;
				      purchaseOrderBlanketList[purchaseOrderBlanketList.length] = tc;
				}
				else
				{
				      //limited
				      tc.PONumber = myPurchaseOrderList[i].po;
				      tc.SpendingLimit = new Object();
				      tc.SpendingLimit.MonetaryAmount = new Object();
				      tc.SpendingLimit.MonetaryAmount.value = currencyToNumber(myPurchaseOrderList[i].limit, myPurchaseOrderList[i].currency, flanguageId);
				      tc.SpendingLimit.MonetaryAmount.currency = myPurchaseOrderList[i].currency;
				      purchaseOrderLimitedList[purchaseOrderLimitedList.length] = tc;
				}
			}
		}
    
		//POindividual
		if (cpm.If_Specified != null)
		{
		  if (cpm.ifUpdateContract)
		  {
		    //update contract
		    if ((cpm.If_Specified != cpm.old_If_Specified) || (cpm.old_checkUniqueness != cpm.checkUniqueness))
		    {
		      if (cpm.old_If_Specified && cpm.If_Specified && (cpm.old_checkUniqueness != cpm.checkUniqueness))
		      {
		        account.POTCIndividual=new Object();
		        account.POTCIndividual.checkUniqueness=cpm.checkUniqueness;
		        account.POTCIndividual.referenceNumber=cpm.individualReferenceNumber;
		        account.POTCIndividual.action="update";
		      }
		      else if (cpm.If_Specified && !cpm.old_If_Specified)
		      {
		        account.POTCIndividual=new Object();
		        account.POTCIndividual.checkUniqueness=cpm.checkUniqueness;
		        account.POTCIndividual.action="new";
		      }
		      else
		      {
		        //delete POTCIndividual
 		        account.POTCIndividual=new Object();
		        account.POTCIndividual.checkUniqueness=cpm.checkUniqueness;
		        account.POTCIndividual.referenceNumber=cpm.individualReferenceNumber;
		        account.POTCIndividual.action="delete";
		      }
		    }
		    else
		    {
		      //no changes for POTCIndividual
		      //so do nothing
		    }
		  }
		  else
		  {
		    //new contract
		    if (cpm.If_Specified)
		    {
  		      account.POTCIndividual=new Object();
	  	      account.POTCIndividual.checkUniqueness=cpm.checkUniqueness;
  		      account.POTCIndividual.action="new";
	            }
		  }
		}

		if (purchaseOrderBlanketList.length > 0)
		{
 		     	account.POTCBlanket = purchaseOrderBlanketList;
		}
		if (purchaseOrderLimitedList.length > 0)
		{
 		     	account.POTCLimited = purchaseOrderLimitedList;
		}
	}
	else
	{
	  //no model
	  //alertDialog("where is your model?");
	  return null;
	}
}

function savePanelData()
{
  self.basefrm.savePanelData();
}
