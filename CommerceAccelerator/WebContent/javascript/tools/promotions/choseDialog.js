//
//-------------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (c) Copyright IBM Corp. 2006
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//-------------------------------------------------------------------
//

function savePanelData()
{
    var checkedId = new Array();
    checkedId = getChecked();
    var aCalCode_Id = checkedId[0];
    parent.put(basefrm.ecCalcodeId,aCalCode_Id);
    
    var aCategoryId=top.getData("categoryId",1);
    parent.put(basefrm.ecCategoryId,aCategoryId.toString());
    	
}

function validatePanelData()
{
	checkedId = getChecked();
	if(checkedId=="")
	{
		alertDialog(parent.convertFromTextToHTML(basefrm.discountMissMsg));
		return false;
	}
	if(checkedId.length!=1)
	{
		alertDialog(parent.convertFromTextToHTML(basefrm.discountMoreMsg));
		return false;
	}
	return true;
}

function loadPanelData()
 {
  if (parent.setContentFrameLoaded)
   {
    parent.setContentFrameLoaded(true);
   }
 }
