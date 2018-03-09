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
  var ranges=new Array();
  
  ranges=parent.get("discountRanges","");
  
  var rangeFromArray=new Array();
  var discountValueArray=new Array();

  for(var i=0;i<ranges.length;i++)
  {
  	
  	rangeFromArray[i]=ranges[i].rangeFrom;
  	discountValueArray[i]=ranges[i].discount;
  }
  
  parent.put("rangeFromArray",rangeFromArray);
  parent.put("discountValueArray",discountValueArray);
}

function validatePanelData()
{
    ranges=parent.get("discountRanges","");
    
    if(ranges.length==0)
    {
    		  parent.alertDialog(basefrm.discountNothingDefinedMsg);
    	return false;
    }
    else
    	return true;
}
function loadPanelData()
 {
  if (parent.setContentFrameLoaded)
   {
    parent.setContentFrameLoaded(true);
   }
 }