<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c)  Copyright  IBM Corp.  2000      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or 
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@include file="eCouponCommon.jsp" %>

<%
ECouponDynamicListBean list = new ECouponDynamicListBean();
list.setRequest(request);
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<script language="JavaScript">


function savePanelData()
{
  var products=new Array();
  
  products=parent.get("product","");
  
  var productSKUArray=new Array();
  var qtyProductArray=new Array();

  for(var i=0;i<products.length;i++)
  {
  	
  	productSKUArray[i]=products[i].productSKU;
  	qtyProductArray[i]=products[i].qty;
  }
  
  parent.put("productSKUArray",productSKUArray);
  parent.put("qtyProductArray",qtyProductArray);
}

function validatePanelData()
{
    products=parent.get("product","");
    
    if(products.length==0)
    {
    		  alertDialog('<%= UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponNothingDefined"))%>');
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

function getHelp()
{
   if (defined(this.basefrm.getHelp)==true)
         return this.basefrm.getHelp();
}

var formStr = " <%= list.getForm() %> ";

</script>

<meta name="GENERATOR" content="IBM WebSphere Studio" />
</head>

<%=list.getFrameset()%>

</html>
