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

   
   function submitCancelHandler()
   {
     top.goBack();
   }

   function preSubmitHandler()
   {
     var searchId              = window.CONTENTS.document.SearchForm.searchId.value;
     var flowtype              = window.CONTENTS.document.SearchForm.searchFlowType.selectedIndex;
     var searchFlowType        = window.CONTENTS.document.SearchForm.searchFlowType.options[flowtype].value;
     var stat                  = window.CONTENTS.document.SearchForm.searchStatus.selectedIndex;
     var searchStatus          = window.CONTENTS.document.SearchForm.searchStatus.options[stat].value;
     var approver              = window.CONTENTS.document.SearchForm.approverId.selectedIndex;
     var searchApprover        = window.CONTENTS.document.SearchForm.approverId.options[approver].value;
     var ds                    = window.CONTENTS.document.SearchForm.dateSelect.selectedIndex;
     var dateSelect            = window.CONTENTS.document.SearchForm.dateSelect.options[ds].value;
     var year                  = window.CONTENTS.document.SearchForm.YEAR1.value;
     var month                 = window.CONTENTS.document.SearchForm.MONTH1.value;
     var day                   = window.CONTENTS.document.SearchForm.DAY1.value;
     
     var aURL       = top.getWebPath() + "NewDynamicListView?ActionXMLFile=approvals.submissionListFromFind&amp;cmd=ApprovalSubmissionListView";
    
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
       if (!isInputStringEmpty(searchApprover) )
       {
          aURL = aURL + "&amp;searchApprover=" + searchApprover;
       }
       if (!isInputStringEmpty(dateSelect) )
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

  top.setContent(window.CONTENTS.getApprovalSubmissionsBCT(),aURL,false);  
}