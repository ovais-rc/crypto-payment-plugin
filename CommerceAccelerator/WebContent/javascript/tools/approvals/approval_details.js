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

function handleApproval()
{
  top.setContent(get('aBCT'),top.getWebPath() + 'DialogView?XMLFile=approvals.approvalRejectionCommentsDialog&amp;aprv_act=1&aprv_ids=' + get('aprv_ids') +  
           '&amp;viewtask=NewDynamicListView' + '&amp;returnLevel=2&amp;ActionXMLFile=' + 
           get('ActionXMLFile') + '&amp;cmd=' + get('cmd'), true) ;
}

function handleReject()
{
  top.setContent(get('rBCT'),top.getWebPath() + 'DialogView?XMLFile=approvals.approvalRejectionCommentsDialog&amp;aprv_act=2&aprv_ids=' + get('aprv_ids') +  
           '&amp;viewtask=NewDynamicListView' + '&amp;returnLevel=2&amp;ActionXMLFile=' + 
           get('ActionXMLFile') + '&amp;cmd=' + get('cmd'), true) ;
}

function doPrint()
{
   self.CONTENTS.window.focus();
   self.CONTENTS.window.print();
}