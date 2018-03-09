/*==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c)  Copyright  IBM Corp.  2000      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or 
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================*/
   function submitErrorHandler (errMessage)
   {
   }

   function submitFinishHandler (finishMessage)
   {
   }

   function submitCancelHandler()
   {
   }

   function preSubmitHandler()
   {
   	top.goBack();// in MC
   	// outside MC parent.parent.location.href='DynamicListView?ActionXMLFile=discount.discountList&selected=SELECTED&cmd=DiscountView&listsize=20&startindex=0&refnum=0&storeId=1&langId=-1';
   }

