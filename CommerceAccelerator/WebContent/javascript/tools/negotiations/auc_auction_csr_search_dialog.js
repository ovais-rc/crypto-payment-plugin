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
        		aURL = "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=negotiations.CSR_auctionShortListSC&cmd=AuctionShortList" + "&aucrfn=" + auctid;
			top.setContent(searchResultsBCT,aURL,true);  
		}                 
		else  if ( !isInputStringEmpty(sku) ) {
			aURL = "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=negotiations.CSR_auctionItemResultsListSC&cmd=AuctionItemResultsList" + "&sku=" + sku;
			top.setContent(searchResultsBCT,aURL,true);  
		}               
		else if ( !isInputStringEmpty(aucttype) ) {
			if (aucttype == "All") {
				aURL =  "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=negotiations.CSR_auctionListSC&cmd=AuctionList";
				top.setContent(searchResultsBCT,aURL,true);  
			}   
			else if (aucttype == "O"){ 
            		aURL =  "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=negotiations.CSR_auctionOpenCryListSC&cmd=AuctionList" + "&auctType=" + aucttype;
				top.setContent(searchResultsBCT,aURL,true);  
			}             
			else if (aucttype == "SB"){ 
				aURL =  "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=negotiations.CSR_auctionSealedBidListSC&cmd=AuctionList" + "&auctType=" + aucttype;
				top.setContent(searchResultsBCT,aURL,true);  
			}             
			else if (aucttype == "D"){ 
				aURL =  "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=negotiations.CSR_auctionDutchListSC&cmd=AuctionList" + "&auctType=" + aucttype;
				top.setContent(searchResultsBCT,aURL,true);  
			}             
		}
   }
