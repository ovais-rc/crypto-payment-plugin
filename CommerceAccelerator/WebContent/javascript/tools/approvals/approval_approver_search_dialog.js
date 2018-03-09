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
     var searchId              = window.CONTENTS.document.SearchForm.searchId.value;
     var flowtype              = window.CONTENTS.document.SearchForm.searchFlowType.selectedIndex;
     var searchFlowType        = window.CONTENTS.document.SearchForm.searchFlowType.options[flowtype].value;
     var stat                  = window.CONTENTS.document.SearchForm.searchStatus.selectedIndex;
     var searchStatus          = window.CONTENTS.document.SearchForm.searchStatus.options[stat].value;
     var submitter             = window.CONTENTS.document.SearchForm.submitterId.selectedIndex;
     var searchSubmitter       = window.CONTENTS.document.SearchForm.submitterId.options[submitter].value;
     var approver;
     var searchApprover = "";
     if(window.CONTENTS.document.SearchForm.dispApprover.value == "Y")
     {
       approver             = window.CONTENTS.document.SearchForm.approverId.selectedIndex;
       searchApprover       = window.CONTENTS.document.SearchForm.approverId.options[approver].value;
     }
     var ds                    = window.CONTENTS.document.SearchForm.dateSelect.selectedIndex;
     var dateSelect            = window.CONTENTS.document.SearchForm.dateSelect.options[ds].value;
     var year                  = window.CONTENTS.document.SearchForm.YEAR1.value;
     var month                 = window.CONTENTS.document.SearchForm.MONTH1.value;
     var day                   = window.CONTENTS.document.SearchForm.DAY1.value;
     
     var aURL       = top.getWebPath() + "NewDynamicListView?ActionXMLFile=approvals.approvalListFromFind&amp;cmd=AwaitingApprovalListView";
    
     if ( !isInputStringEmpty(searchId) )
     {
        aURL = aURL + "&amp;searchId=" + searchId;
     }
     else
     {
       if ( !isInputStringEmpty(searchFlowType) )
       {
          aURL = aURL + "&amp;searchFlowType=" + searchFlowType;
       }
       if ( !isInputStringEmpty(searchStatus) )
       {
          aURL = aURL + "&amp;searchStatus=" + searchStatus;
       }
       if (!isInputStringEmpty(searchSubmitter) )
       {
          aURL = aURL + "&amp;searchSubmitter=" + searchSubmitter;
       }
       if (!isInputStringEmpty(searchApprover) )
       {
          aURL = aURL + "&amp;searchApprover=" + searchApprover;
       }
       if ( !isInputStringEmpty(dateSelect) )
       {
          if(month.length < 2)
          {
            month = "0" + month;
          }
          if(day.length < 2)
          {
            day = "0" + day;
          }
          aURL = aURL + "&amp;dateSelect=" + dateSelect;
          aURL = aURL + "&amp;searchYear=" + year;
          aURL = aURL + "&amp;searchMonth=" + month;
          aURL = aURL + "&amp;searchDay=" + day;
       }
     }
 
  top.setContent(window.CONTENTS.getApprovalsBCT(),aURL,false);  
}