//********************************************************************

//*-------------------------------------------------------------------

//* Licensed Materials - Property of IBM

//*

//* 5697-D24

//*

//* (c) Copyright IBM Corp. 2000, 2002

//*

//* US Government Users Restricted Rights - Use, duplication or

//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.

//*

//*-------------------------------------------------------------------

   function submitErrorHandler (errMessage)
   {
     alertDialog(errMessage);
   }

   function submitFinishHandler (finishMessage){
     alertDialog(finishMessage);
     top.goBack();
     location.replace('/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=negotiations.bidruleList&amp;cmd=BidRuleList&amp;listsize=15&amp;startindex=0&amp;orderby=RULENAME&amp;selected=SELECTED&amp;refnum=0');
   }

   function submitCancelHandler()
   {
     top.goBack();
     location.replace('/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=negotiations.bidruleList&amp;cmd=BidRuleList&amp;listsize=15&amp;startindex=0&amp;orderby=RULENAME&amp;selected=SELECTED&amp;refnum=0');
   }
