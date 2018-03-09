//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*

   function submitErrorHandler (errMessage)
   {
     alertDialog(errMessage);
   }

   function submitFinishHandler (finishMessage)
   {
     alertDialog(finishMessage );
     //There is no command behind this dialog.  submitFinishHandler will never be executed
     top.goBack();
   }


   function submitCancelHandler()
   {
     top.goBack();
   }

   function preSubmitHandler()
   {
     var auctid     = window.CONTENTS.document.DialogForm.aurefnum.value;
     var sku        = window.CONTENTS.document.DialogForm.sku.value;
     var i          = window.CONTENTS.document.DialogForm.autype.selectedIndex;
     var aucttype   = window.CONTENTS.document.DialogForm.autype.options[i].value;
     var searchResultsBCT   = window.CONTENTS.searchResultsBCT;
     var aURL       = " ";        	

          
     if ( !isInputStringEmpty(auctid) ) {
        aURL = "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=negotiations.auctionShortListSC&cmd=AuctionShortList&orderby=AUCT_ID"
                      + "&aucrfn=" + auctid;
	top.setContent(searchResultsBCT,aURL,true);  

     }                 
     else
       if ( !isInputStringEmpty(sku) ) {
          aURL = "/webapp/wcs/tools/servlet/NewDynamicListView";

          var urlPara = new Object();
          urlPara.ActionXMLFile='negotiations.auctionItemResultsListSC';
          urlPara.cmd='AuctionItemResultsList';
          urlPara.listsize='15';
          urlPara.startindex='0';
          urlPara.refnum='0';
          urlPara.orderby='AUCT_ID';
          urlPara.selected='SELECTED';
          urlPara.sku=sku;
                   
	  top.setContent(searchResultsBCT,aURL,true, urlPara);  
       }               
     else
       if ( !isInputStringEmpty(aucttype) ) {
         if (aucttype == "All") {
            aURL =  "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=negotiations.auctionListSC&cmd=AuctionList";
	   top.setContent(searchResultsBCT,aURL,true);  

         }   
         else if (aucttype == "O"){ 
            aURL =  "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=negotiations.auctionOpenCryListSC&cmd=AuctionList"
                      + "&auctType=" + aucttype;
	    top.setContent(searchResultsBCT,aURL,true);  
         }             
         else if (aucttype == "SB"){ 
            aURL =  "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=negotiations.auctionSealedBidListSC&cmd=AuctionList"
                      + "&auctType=" + aucttype;
	    top.setContent(searchResultsBCT,aURL,true);  
         }             
         else if (aucttype == "D"){ 
            aURL =  "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=negotiations.auctionDutchListSC&cmd=AuctionList"
                      + "&auctType=" + aucttype;
	    top.setContent(searchResultsBCT,aURL,true);  
         }             
       }

   }
