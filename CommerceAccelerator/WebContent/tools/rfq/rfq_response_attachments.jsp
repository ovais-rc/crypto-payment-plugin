<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- 
========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
========================================================================
--> 
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.contract.beans.*" %>
<%@ page import="com.ibm.commerce.contract.objects.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.ubf.util.*" %>
<%@ include file="../common/common.jsp" %>

<%
    JSPHelper jspHelper = new JSPHelper(request);
    String ErrorMessage = jspHelper.getParameter(com.ibm.commerce.tools.common.ui.UIProperties.SUBMIT_ERROR_MESSAGE);
    if (ErrorMessage == null) {
		ErrorMessage = "";
    }
    // Get storeId from CommandContext
    CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
    Locale aLocale = null;
    if( aCommandContext != null ) {
        aLocale = aCommandContext.getLocale();
    }
    // Get user id from CommandContext
    Long userId = aCommandContext.getUserId();
    // obtain the resource bundle for display
    Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS",aLocale);      
    String rfqId = jspHelper.getParameter("requestId");
    String responseId = jspHelper.getParameter("offerId");
    String strAttachCopyFromRequest = null;
    String strAttachOrigFromResponse = null;
    int startIndex = Integer.parseInt(jspHelper.getParameter("startindex"));
    int listSize = Integer.parseInt(jspHelper.getParameter("listsize"));
    int endIndex = startIndex + listSize;
%>

<!-- RFQ Level Attachments List for RFQ  -->
<jsp:useBean id="attachmentList" class="com.ibm.commerce.rfq.beans.RFQAttachmentListBean" >
<jsp:setProperty property="*" name="attachmentList" />
</jsp:useBean>

<%
    if (responseId != null) {
		attachmentList.setTradingId(Long.valueOf(responseId));
		strAttachCopyFromRequest = RFQConstants.EC_RFQ_ATTACHMENT_COPYFROMREQUEST_NO;
		strAttachOrigFromResponse = RFQConstants.EC_RFQ_ATTACHMENT_ORIGFROMRESPONSE_YES;
    } else {
    	attachmentList.setTradingId(Long.valueOf(rfqId));
		strAttachCopyFromRequest = RFQConstants.EC_RFQ_ATTACHMENT_COPYFROMREQUEST_YES;
		strAttachOrigFromResponse = RFQConstants.EC_RFQ_ATTACHMENT_ORIGFROMRESPONSE_NO;
    }
    com.ibm.commerce.beans.DataBeanManager.activate(attachmentList, request);
    AttachmentDataBean [] attachList = attachmentList.getAttachments();
    int numberOfAttachments = 0;
    if (attachList != null) {
    	numberOfAttachments = attachList.length;
    }
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%= rfqNLS.get("resprdatrrespnd") %></title>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale)%>" type="text/css" />
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/rfq/rfq_skippage.js"></script>
<script type="text/javascript">
    var allAttachmentsArray  = new Array();
    var rfqAttachmentsArray  = new Array();

    var isFirstTimeLogonPanel1;
    isFirstTimeLogonPanel1 = top.getData("isFirstTimeLogonPanel1");
    if (isFirstTimeLogonPanel1 != "0")
    {
        isFirstTimeLogonPanel1="1"; //"1" means first time logon Panel2.
        top.saveData("0","isFirstTimeLogonPanel1");
    }    

    function onLoad() 
    {
    	skipPages(parent.parent.pageArray);
    	parent.parent.reloadFrames();
	parent.loadFrames();
	parent.loadPanelData();
    }

    function isButtonDisabled(b) 
    {
      	if (b.className =='disabled' )
      	{
            return true;
      	}
      	return false;
    }

    function myRefreshButtons()
    {
    	parent.setChecked();
    	var aList = new Array();
    	aList = parent.getChecked();
	return;
    }

    function selectDeselectAll() 
    {
	for (var i=0; i<document.rspAttachListForm.elements.length; i++) 
	{
	    var e = document.rspAttachListForm.elements[i];
	    if (e.name != 'select_deselect') 
	    {
		e.checked = document.rspAttachListForm.select_deselect.checked;
	    }
	}
	myRefreshButtons();
    }

    function setSelectDeselectFalse()
    {
    	document.rspAttachListForm.select_deselect.checked = false;
    }

    function retrievePanelData()
    {
    	if (top.getData("anAttachment") != undefined && top.getData("anAttachment") != null)
    	{
	    parent.parent.model = top.getModel();
        }
    }  

    function savePanelData()
    {
	top.saveData(allAttachmentsArray,"allAttachments");  
	parent.parent.put("allAttachments",allAttachmentsArray );
	return true;
    }

    function validatePanelData()
    {
	return true;
    }

    function getNewBCT() 
    {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("attachment")) %>";
    }

    function newEntry()
    {
	if (isButtonDisabled(parent.buttons.buttonForm.addButton))
	{
       	   return;
	}
      	   
        top.saveData(allAttachmentsArray,"allAttachments");
        top.saveModel(parent.parent.model);

	var rfqId = '<%= rfqId %>';
	var responseId = '<%= responseId %>';
	var url;
    	if (responseId != undefined && responseId != 'null')
	{
	    url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqResponseAttachmentAdd&amp;responseId=" + responseId;
	}
	else
	{
	    url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqResponseAttachmentAdd&amp;requestId=" + rfqId;
	}

	if (top.setReturningPanel) 
	{
	    top.setReturningPanel("attachments");
	}
	if (top.setContent)
	{
	    top.setContent(getNewBCT(),url,true);
	}
	else
	{
	    parent.parent.location.replace(url);
	} 
    }

    function replaceEntry()
    {
	if (isButtonDisabled(parent.buttons.buttonForm.addButton))
	{
       	   return;
	}
      	   
        var anAttachment = new Object();
        anAttachment = getAnAttachment();
        top.saveData(anAttachment,"anAttachment");
        top.saveData(anAttachment.identity,"replaceAttachmentIdentity");

        top.saveData(allAttachmentsArray,"allAttachments");
        top.saveModel(parent.parent.model);

	var rfqId = '<%= rfqId %>';
	var responseId = '<%= responseId %>';
	var url;
    	if (responseId != undefined && responseId != 'null')
	{
            url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqResponseAttachmentReplace&amp;responseId=" + responseId;
	}
	else
	{
            url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqResponseAttachmentReplace&amp;requestId=" + rfqId;
	}

	if (top.setReturningPanel) 
	{
	    top.setReturningPanel("attachments");
	}
	if (top.setContent)
	{
	    top.setContent(getNewBCT(),url,true);
	}
	else
	{
	    parent.parent.location.replace(url);
	} 
    }

    function deleteEntry()
    { 
     	if (isButtonDisabled(parent.buttons.buttonForm.removeButton))
	{
            return;
	} 

     	var aList = parent.getChecked();
     	for (var i = 0;i < allAttachmentsArray.length;i++)
        {
            for (var j = 0;j < aList.length;j++)
            {
                if (allAttachmentsArray[i].identity == aList[j].split(',')[0])
            	{
	  	    allAttachmentsArray[i].attachMarkForDelete = "<%= RFQConstants.EC_RFQ_ATTACHMENT_MARKFORDELETE_YES %>";
            	}
            }
        }

    	var newAttachmentsArray  = new Array();
    	var numberOfAttachments = allAttachmentsArray.length;

	var j = 0;
	for (var i = 0; i < numberOfAttachments; i++)
	{
	    if (allAttachmentsArray[i].attachMarkForDelete == "<%= RFQConstants.EC_RFQ_ATTACHMENT_MARKFORDELETE_NO %>")
	    {
      	   	newAttachmentsArray[j] = allAttachmentsArray[i];
	        j++;
	    }
        }
	rfqAttachmentsArray = newAttachmentsArray;
 
     	top.saveData(allAttachmentsArray,"allAttachments");
     	top.saveModel(parent.parent.model);
	if (top.setReturningPanel) 
	{
	    top.setReturningPanel("attachments");
	}
        top.showContent(top.mccbanner.trail[top.mccbanner.counter].location);
    }		

    function updateDescription(key)
    { 
	var form = document.rspAttachListForm;
	var tmp = key.split(",");

        if (rfqAttachmentsArray.length <= 0 || form.description == undefined) 
	{
	    return;
	}

  	if (form.description.length == undefined || form.description.length == 1) 
	{
    	    rfqAttachmentsArray[tmp[1]].attachDescription = form.description.value;
        }
   	else 
	{
    	    rfqAttachmentsArray[tmp[1]].attachDescription = form.description[tmp[0]].value;
        }

	rfqAttachmentsArray[tmp[1]].attachUpdateDesc = "<%= RFQConstants.EC_RFQ_ATTACHMENT_UPDATEDESC_YES %>";
    }

    function goToAttachment(attachId)
    {
        var anAttachment = new Object();
        anAttachment = getAnAttachment();
        top.saveData(anAttachment,"anAttachment");
        top.saveData(allAttachmentsArray,"allAttachments");
        top.saveModel(parent.parent.model);

	var rfqId = '<%= rfqId %>';
	var responseId = '<%= responseId %>';
	var url;
    	if (responseId != undefined && responseId != 'null')
	{
            url = "RFQAttachmentView?<%= com.ibm.commerce.server.ECConstants.EC_ATTACH_ID %>=" + attachId + "&<%= com.ibm.commerce.rfq.utils.RFQConstants.EC_RFQ_RESPONSE_ID %>=" + responseId;
	}
	else
	{
            url = "RFQAttachmentView?<%= com.ibm.commerce.server.ECConstants.EC_ATTACH_ID %>=" + attachId + "&<%= com.ibm.commerce.rfq.utils.RFQConstants.EC_RFQ_REQUEST_ID %>=" + rfqId;
	}

        var windowTitle = "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_Attachment")) %>";
        var attributes = 'left=0,top=0,width=1014,height=710,scrollbars=no,toolbar=no,directories=no,status=no,menubar=no,copyhistory=no,resizable=yes';
        var attachmentWindow = top.openChildWindow(url, windowTitle, attributes);
    }

    function getAnAttachment()
    {    
  	var anAttachment = new Object();
  	var identity = getCheckedIdentity();
  	anAttachment = getAttachmentbyIdentity(identity);  
  	return anAttachment;
    }

    function getAttachmentbyIdentity(identity)
    {
  	var anAttachment = new Object();
  	for (var i=0; i < rfqAttachmentsArray.length; i++)
  	{
    	    if(rfqAttachmentsArray[i].identity == identity) 
    	    {
      		anAttachment = rfqAttachmentsArray[i];
      		break;
    	    }
  	}
  	return anAttachment;
    }

    function getCheckedIdentity()
    {
    	var checkedEntries = parent.getChecked().toString();
    	var parms = checkedEntries.split(',');
    	var Ids = parms[0];
  	return Ids;
    }

    function setupAttachments() 
    {
   	if (isFirstTimeLogonPanel1 == "0")  //NOT first time log on panel1
    	{   
      	    allAttachmentsArray = top.getData("allAttachments");
    	    var numberOfAttachments = 0;
    	    if (allAttachmentsArray != undefined && allAttachmentsArray != null)
	    {
    	    	numberOfAttachments = allAttachmentsArray.length;
            }

	    var j = 0;
	    for (var i = 0; i < numberOfAttachments; i++)
	    {
	        if (allAttachmentsArray[i].attachMarkForDelete == "<%= RFQConstants.EC_RFQ_ATTACHMENT_MARKFORDELETE_NO %>")
		{
      	    	    rfqAttachmentsArray[j] = allAttachmentsArray[i];
		    j++;
		}
            }
    	}
  	else  //first time log on panel2
    	{
<%   
	    for (int i = 0; i < numberOfAttachments; i++)
	    {
        AttachmentDataBean dbAttachment = attachList[i];
%> 
        rfqAttachmentsArray[<%=i%>] = new Object();
	  	rfqAttachmentsArray[<%=i%>].identity = <%=i%>;
	  	rfqAttachmentsArray[<%=i%>].attachmentId = <%= dbAttachment.getAttachmentId()%>;
	  	rfqAttachmentsArray[<%=i%>].attachOwnerId = <%= dbAttachment.getOwnerId()%>;
        rfqAttachmentsArray[<%=i%>].attachFilename = "<%= UIUtil.toJavaScript(dbAttachment.getFilename()) %>";
        rfqAttachmentsArray[<%=i%>].attachDescription = "<%= UIUtil.toJavaScript(dbAttachment.getDescription()) %>";
	  	rfqAttachmentsArray[<%=i%>].attachFilesize = <%= dbAttachment.getFilesize()%>;
	  	rfqAttachmentsArray[<%=i%>].attachCopyFromRequest = "<%= strAttachCopyFromRequest %>";
	  	rfqAttachmentsArray[<%=i%>].attachOrigFromResponse = "<%= strAttachOrigFromResponse %>";
	  	rfqAttachmentsArray[<%=i%>].attachMarkForDelete = "<%= RFQConstants.EC_RFQ_ATTACHMENT_MARKFORDELETE_NO %>";
	  	rfqAttachmentsArray[<%=i%>].attachUpdateDesc = "<%= RFQConstants.EC_RFQ_ATTACHMENT_UPDATEDESC_NO %>";
<%
        }
%>
      	allAttachmentsArray = rfqAttachmentsArray;
  	    top.saveData(allAttachmentsArray,"allAttachments");
   	}
    }

    setupAttachments();

    listSize = <%= listSize %>;
    startIndex = <%= startIndex %>;
    endIndex   = <%= endIndex %>;
    if ((rfqAttachmentsArray != null) && (rfqAttachmentsArray.length > 0))
    {
	if (endIndex > rfqAttachmentsArray.length)
	{
	    endIndex = rfqAttachmentsArray.length;
	}
    }
    if (startIndex < 0) 
    {
	startIndex=0;
    }
    if (rfqAttachmentsArray == null || rfqAttachmentsArray.length < 1 )
    {
	endIndex = 0;
	parent.set_t_item(0);
	parent.set_t_page(1);
    }
    else 
    {
	numpage  = Math.ceil(rfqAttachmentsArray.length / listSize);
	parent.set_t_item(rfqAttachmentsArray.length);
	parent.set_t_page(numpage);
    }

</script>

</head>

<body class="content_list">

<script type="text/javascript">
<!--
//For IE
if (document.all) {	onLoad(); }
//-->
</script>

<script type="text/javascript">
    if (rfqAttachmentsArray != null && rfqAttachmentsArray.length > 0)
    {
	document.writeln('<%= rfqNLS.get("instruction_Attachment") %>');
    }
</script>

<form name="rspAttachListForm" action="">

    <%= comm.startDlistTable((String)rfqNLS.get("attachmentinfo")) %>
    <%= comm.startDlistRowHeading() %>
    <%= comm.addDlistCheckHeading(true,"selectDeselectAll()") %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("filename"),"none",false,"30%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("description"),"none",false,"50%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("filesize"),"none",false,"20%" ) %>
    <%= comm.endDlistRow() %>

<script type="text/javascript">
    var userId = '<%= userId %>';
    var checkvalue;
    var identity;
    var rowselect = 1;

    var linesonpage = 0;
    // for (var i=startIndex; i<endIndex; i++)
    var i = startIndex;
    while (i < endIndex)
    { 
    	checkvalue = rfqAttachmentsArray[i].identity;

  	startDlistRow(rowselect);
	addDlistCheck(checkvalue, "setSelectDeselectFalse();myRefreshButtons()", null);
	addDlistColumn("<a href=\"javascript:goToAttachment('" + rfqAttachmentsArray[i].attachmentId + "');\"> " + rfqAttachmentsArray[i].attachFilename + "</a>");

	if (rfqAttachmentsArray[i].attachOwnerId == undefined 
	 || userId == rfqAttachmentsArray[i].attachOwnerId)
	{
	    var key = linesonpage + "," + i;
	    document.writeln("<td class='"+list_col_style+"'>");
   	    document.writeln("<label for='attachDesc'><textarea name='description' id='attachDesc' rows='2' cols='55' wrap='virtual' onchange=\"updateDescription('"+key+"')\"></textarea></label>");
   	    document.writeln("</td>");

      	    if (linesonpage == 0)
            	document.rspAttachListForm.description.value = rfqAttachmentsArray[i].attachDescription;
      	    else
            	document.rspAttachListForm.description[linesonpage].value = rfqAttachmentsArray[i].attachDescription;
	    linesonpage++;
	}
	else
	{
    	    addDlistColumn(rfqAttachmentsArray[i].attachDescription);
	}

    	addDlistColumn(rfqAttachmentsArray[i].attachFilesize);
	endDlistRow();
	i++;

        if ( rowselect == 1 ) {
            rowselect = 2;
        } else {
            rowselect = 1;
        }
    }
</script>

    <%= comm.endDlistTable() %>

</form>
<br />
<script type="text/javascript">
    if (rfqAttachmentsArray == null || rfqAttachmentsArray.length == 0)
    {
	document.writeln('<%= rfqNLS.get("msgnoattach") %>');
    }

	retrievePanelData(); 
</script>

<script type="text/javascript">
<!--
parent.afterLoads();
if (rfqAttachmentsArray != null) {
  	parent.setResultssize(rfqAttachmentsArray.length);
} else {
  	parent.setResultssize(0);
}
//-->
</script>

</body>
</html>
