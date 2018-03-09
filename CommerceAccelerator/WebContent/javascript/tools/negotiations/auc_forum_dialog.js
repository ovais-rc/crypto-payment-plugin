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
     var aucrfn = window.CONTENTS.document.forms.compose.aucrfn.value;
     if (top.goBack)
     {
        top.goBack();
     }

     location.replace("NewDynamicListView?ActionXMLFile=negotiations.auc_forummsg_sclist&cmd=ForumMsgListView&orderby=SETCNOTE&aucrfn=" 
                       + aucrfn + "&msgstatus=A");
     
     
     //window.close();
   }

   function submitCancelHandler()
   {
      var aucrfn = window.CONTENTS.document.forms.compose.aucrfn.value;

      if (top.goBack)
      {
        top.goBack();
      }

      location.replace("NewDynamicListView?ActionXMLFile=negotiations.auc_forummsg_sclist&cmd=ForumMsgListView&orderby=SETCNOTE&aucrfn=" 
                        + aucrfn + "&msgstatus=A");


   }

   
