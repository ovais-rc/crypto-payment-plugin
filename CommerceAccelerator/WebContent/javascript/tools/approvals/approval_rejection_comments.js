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

function handleOK()
{
  params = new Object();
  var i = CONTENTS.getReturnLevel();
  var j;
  for(j = 0; j < i; j++)
  { 
    top.mccbanner.removebct();
  }
  top.mccbanner.trail[top.mccbanner.counter].location = top.getWebPath() + 'NewDynamicListView?ActionXMLFile=approvals.approvalList&amp;cmd=AwaitingApprovalListView';
  params['aprv_act'] = CONTENTS.document.commentsForm.aprv_act.value;
  params['aprv_ids'] = CONTENTS.document.commentsForm.aprv_ids.value;
  params['viewtask'] = 'NewDynamicListView';
  params['ActionXMLFile'] = CONTENTS.document.commentsForm.ActionXMLFile.value;
  params['cmd'] = CONTENTS.document.commentsForm.cmd.value;
  params['comments'] = CONTENTS.document.commentsForm.comments.value;
  top.showContent(top.getWebPath() + 'HandleApprovals?encoding=UTF-8',params);
}

