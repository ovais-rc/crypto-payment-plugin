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

   
   function preSubmitHandler()
   {

     var stat;
     var deliveryStatus  = "";
     var aURL            = "";
     
     if(window.CONTENTS.document.SearchForm.tableName.value == "MSGSTORE")
     {
       stat            = window.CONTENTS.document.SearchForm.deliveryStatus.selectedIndex;
       deliveryStatus  = window.CONTENTS.document.SearchForm.deliveryStatus.options[stat].value;
       aURL = top.getWebPath() + "NewDynamicListView?ActionXMLFile=adminconsole.MsgStoreListFromFind&amp;cmd=AwaitingMsgStoreDisplayFilterView";
     } else {
       aURL = top.getWebPath() + "NewDynamicListView?ActionXMLFile=adminconsole.MsgArchiveListFromFind&amp;cmd=AwaitingMsgArchiveDisplayFilterView";
     }

     var tran            = window.CONTENTS.document.SearchForm.transportId.selectedIndex;
     var transportId     = window.CONTENTS.document.SearchForm.transportId.options[tran].value;




     if (!isInputStringEmpty(transportId) )
     {
        aURL=aURL+"&amp;transport_id=" + transportId;
     }

     if (!isInputStringEmpty(deliveryStatus) )
     {
        aURL=aURL+"&amp;delivery=" + deliveryStatus;
     }

     top.setContent(window.CONTENTS.getApprovalsBCT(),aURL,true);
}