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
function savePanelData()
{

  //var ranges=new Array();
  //var values=new Array();
   
  //ranges=parent.get("rlRanges");
  //values=parent.get("rlValues");
  
  //parent.put("rlRanges", ranges);
  //parent.put("rlValues", values);
}

function validatePanelData()
{

	if(basefrm.validatePanelData())
	{
		return true;
	}
	else
	{
		return false;
	}
}

function loadPanelData()
 {
  if (parent.setContentFrameLoaded)
   {
    parent.setContentFrameLoaded(true);
   }
 }