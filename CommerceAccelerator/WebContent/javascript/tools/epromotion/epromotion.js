//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------
function submitErrorHandler (errMessage, errStatus)
{
	alertDialog(errMessage);
	if (errStatus == "rlPromotionDuplicateName")
	{
		gotoPanel("RLPromotionProperties");
	}
	else
	if (errStatus == "rlPromotionDeletedDuplicateName")
	{
		gotoPanel("RLPromotionProperties");
	}
	else
	{
		top.goBack();
	}
}

function submitFinishHandler (finishMessage)
{
	var promotionResult = new Object();
	promotionResult.promotionId = window.NAVIGATION.requestProperties["promotionId"];
	promotionResult.promotionName = window.NAVIGATION.requestProperties["promotionName"];
	top.sendBackData(promotionResult, "promotionResult");

	top.put("<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %>",null); 
	alertDialog(finishMessage);
	top.goBack();
}

function submitCancelHandler()
{
	top.put("<%= RLConstants.RLPROMOTION_MERCHANDISE_TYPE %>",null); 
	top.goBack();
}

function preSubmitHandler()
{
}

function getCurrency()
{
	var rlpromotion = get("rlpromotion","");
	if(rlpromotion != null)
	{
		return rlpromotion.rlCurrency;
	}
}
