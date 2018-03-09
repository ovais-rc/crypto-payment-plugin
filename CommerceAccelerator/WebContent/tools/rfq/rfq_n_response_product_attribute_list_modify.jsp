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
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.rfq.beans.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.utf.utils.*" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="../common/List.jsp" %>
<%@ include file="../common/NumberFormat.jsp" %>
<%
   Locale aLocale = null;
   Integer langId=new Integer(-1);
   String storeId= null;
   //***Get storeId from CommandContext
   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
   JSPHelper jsphelper = new JSPHelper(request);  
   if( aCommandContext!= null ){
       aLocale = aCommandContext.getLocale();
       langId = aCommandContext.getLanguageId();
       storeId = aCommandContext.getStoreId().toString();
   }
   if (aLocale ==null) aLocale = new Locale("en","US");
   if (langId == null) langId = new Integer(-1);
   // obtain the resource bundle for display
   Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS",aLocale); 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale)%>" type="text/css" />
<title></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/rfq/rfqUtile.js"></script>
<script type="text/javascript">
var attributeObj;
attributeObj = top.getData("<%= RFQConstants.EC_OFFERING_PRODATTRLIST %>",1);
function view(attachment_id, pattrvalue_id) {
    var url = "RFQAttachmentView?<%= com.ibm.commerce.server.ECConstants.EC_ATTACH_ID %>=" + attachment_id + "&<%= com.ibm.commerce.rfq.utils.RFQConstants.EC_PATTRVALUE_ID %>=" + pattrvalue_id;
	var windowTitle = "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_Attachment")) %>";
	var attributes = 'left=0,top=0,width=1014,height=710,scrollbars=no,toolbar=no,directories=no,status=no,menubar=no,copyhistory=no,resizable=yes';
	var attachmentWindow = top.openChildWindow(url, windowTitle, attributes);
}
function onLoad() { 
	parent.loadFrames();
}
function getNewBCT3() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfqchangeattrib")) %>";
}
function getCheckedAttributes() {
	var temp;
	var theArray = new Array();
	var objArray = new Array();
	var form = document.rfqListForm;
	for (var i=0;i< form.elements.length;i++) {
    	if (form.elements[i].type == 'checkbox' && form.elements[i].checked && form.elements[i].name != "select_deselect") {
      		theArray[theArray.length] = form.elements[i].name;
      	}
  	}
  	if (theArray.length != null && theArray.length > 0) {
    	for (var j=0;j<theArray.length;j++) {
      		temp = theArray[j].split(",");
      		objArray[j] = new Object;
      		objArray[j].Id = temp[0];
      		objArray[j].changeable = temp[1];
      		objArray[j].mandatory = temp[2]; 
      	}
  	}
	return objArray;
}
function selectDeselectAll() {
	for (var i=0; i<document.rfqListForm.elements.length; i++) {
		var e = document.rfqListForm.elements[i];
		if (e.name != 'select_deselect') {
			e.checked = document.rfqListForm.select_deselect.checked;
		}
	}
	myRefreshButtons();
}
function setSelectDeselectFalse() {
	document.rfqListForm.select_deselect.checked = false;
}
function myRefreshButtons() {
	parent.setChecked();
	var objArray = new Array();
	objArray = parent.getChecked();
	if (objArray.length == 0)
       return;
	var tmp;
	var tmpArray=new Array();    
	var changeable = true;
    for (var i = 0;i<objArray.length;i++) {
		tmp = objArray[i];
		tmpArray=objArray[i].split(',');	
		if(tmpArray[1] == 0) {
	  		changeable = false;
	  		break;
		}
    }  
    var mandatory = false;
    for (var i=0;i<objArray.length;i++)	{
		tmp = objArray[i];
		tmpArray=objArray[i].split(',');	    
		if(tmpArray[2] == 1) {
	  		mandatory = true;
	  		break;
		}
    }
    var respondBtn = true;
    var clearBtn =true;
    if(!changeable) respondBtn=clearBtn=false;
    if(mandatory) clearBtn= false; 
    if (parent.buttons.buttonForm.changeButton && !respondBtn) {
		parent.buttons.buttonForm.changeButton.className='disabled';
		parent.buttons.buttonForm.changeButton.disabled=true;
		parent.buttons.buttonForm.changeButton.id='disabled';
    }
    if (parent.buttons.buttonForm.rfqclearButton && !clearBtn) {
  		parent.buttons.buttonForm.rfqclearButton.className='disabled';
  		parent.buttons.buttonForm.rfqclearButton.disabled=true;
  		parent.buttons.buttonForm.rfqclearButton.id='disabled';
    }    
	return;
}
function userInitialButtons() {
	parent.setChecked();
	var objArray = new Array();
	objArray = parent.getChecked();
	if (objArray.length == 0)
       return;
	var tmp;
	var tmpArray=new Array();    
	var changeable = true;
    for (var i = 0;i<objArray.length;i++) {
		tmp = objArray[i];
		tmpArray=objArray[i].split(',');	
		if(tmpArray[1] == 0) {
			changeable = false;
			break;
		}
    }        
	var mandatory = false;
	for (var i=0;i<objArray.length;i++) {
		tmp = objArray[i];
		tmpArray=objArray[i].split(',');	    
		if(tmpArray[2] == 1) {
	  		mandatory = true;
	  		break;
		}
	}
	var respondBtn = true;
	var clearBtn =true;
	if(!changeable) respondBtn=clearBtn=false;
	if(mandatory) clearBtn= false; 
	if (parent.buttons.buttonForm.changeButton && !respondBtn) {
		parent.buttons.buttonForm.changeButton.className='disabled';
		parent.buttons.buttonForm.changeButton.disabled=true;
		parent.buttons.buttonForm.changeButton.id='disabled';
	}
	if (parent.buttons.buttonForm.rfqclearButton && !clearBtn) {
		parent.buttons.buttonForm.rfqclearButton.className='disabled';
		parent.buttons.buttonForm.rfqclearButton.disabled=true;
		parent.buttons.buttonForm.rfqclearButton.id='disabled';
	}    
	return;
}	
function changeAttribute() {	    
	if(isButtonDisabled(parent.buttons.buttonForm.changeButton))
		return;
	var index = getCheckedAttributes();
	top.saveModel(parent.parent.model);
    top.saveData(attributeObj[index[0].Id],"attributeData");
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqresponseproductmodify";
	top.setReturningPanel("rfqProducts");
	top.setContent(getNewBCT3(), url, true);
}

function isButtonDisabled(b) {
	if (b.className =='disabled' )
		return true;
	return false;
}       
function cleanAttribute(){
	if(isButtonDisabled(parent.buttons.buttonForm.rfqclearButton))
		return;
	var index = getCheckedAttributes();
	for (i=0;i<index.length;i++) {	
		attributeObj[index[i].Id].<%= RFQConstants.EC_ATTR_OPERATOR %> = "";
		attributeObj[index[i].Id].<%= RFQConstants.EC_ATTR_UNIT %> = "";
		attributeObj[index[i].Id].<%= RFQConstants.EC_ATTR_UNIT_DESC %> = "";
		attributeObj[index[i].Id].<%= RFQConstants.EC_ATTR_VALUE %> = "";
		attributeObj[index[i].Id].res_filename = "";
		attributeObj[index[i].Id].<%= RFQConstants.EC_ATTR_OPERATOR_DES %> = "";
		attributeObj[index[i].Id].<%= RFQConstants.EC_RFQ_CHANGE_STATUS %> = "<%= RFQConstants.EC_RFQ_CHANGE_TRUE %>";
		savePanelData();
	}
	parent.document.forms[0].submit();
}
function savePanelData() {
	return true;
}
function doNothing() { 
	; 
}
function goBack() {
	top.goBack();
}
function getFormatedValue(value,type) {
	var tempvalue;
	if (value == undefined || value == null || value == "") 
		return("");
	tempvalue = value;
	switch (type) {
		case "<%= UTFConstants.EC_ATTRTYPE_DATETIME %>":
			tempArray = new Array();
			tempArray = value.split(" ");
			var dateString = tempArray[0];
		 	var timeValues = dateString.split('-');
		 	tempvalue = getFormattedDate(timeValues[0], timeValues[1], timeValues[2], "<%= aLocale.toString() %>");			
			break;
		case "<%= UTFConstants.EC_ATTRTYPE_STRING %>":
    		break;
    	default:
			;
//    		tempvalue = numberToStr(value,<%= langId %>,null);
    }
	return tempvalue;
}
</script>
</head>
<body class="content_list">

<script type="text/javascript">
<!--
//For IE
if (document.all) { onLoad(); }
//-->
</script> 

<form name="rfqListForm" action="">

<script type="text/javascript">
<%
int startIndex = Integer.parseInt(jspHelper.getParameter("startindex"));
int listSize = Integer.parseInt(jspHelper.getParameter("listsize"));
int endIndex = startIndex + listSize;
%>

listSize = <%= listSize %>;
startIndex = <%= startIndex %>;
endIndex   = <%= endIndex %>;
if ((attributeObj!=null)&&( attributeObj.length > 0) ){
	if (endIndex > attributeObj.length){
		endIndex = attributeObj.length;
	}
}		
if (startIndex < 0) startIndex=0;
if (attributeObj == null || attributeObj.length < 1 ){
	endIndex = 0;
	parent.set_t_item(0);
	parent.set_t_page(1);
}
else {
	numpage  = Math.ceil(attributeObj.length / listSize);
	parent.set_t_item(attributeObj.length);
	parent.set_t_page(numpage);
}
</script>

	<%= comm.startDlistTable((String)rfqNLS.get("rfqlisttitle")) %>
	<%= comm.startDlistRowHeading() %>
	<%= comm.addDlistCheckHeading(false) %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("name"),"null",false,"12%" ) %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("mandatory"),"null",false,"11%" ) %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqchangeable"),"null",false,"11%" ) %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqoperator"),"null",false,"11%" ) %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("resrequestvalue"),"null",false,"11%" ) %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("resrequestunit"),"null",false,"11%" ) %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("responseoperator"),"null",false,"11%" ) %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("resresponsevalue"),"null",false,"11%" ) %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("resresponseunit"),"null",false,"11%" ) %>
	<%= comm.endDlistRow() %>
<script type="text/javascript">
function output() {
  var checkvalue;
  var mandatoy;
  var changeable;
  var rowselect;
  var value;
  rowselect = 1;
  if (attributeObj == null || attributeObj == undefined) return ;
  for (var i =startIndex ;i <endIndex;i++)
  { 
   checkvalue = i + "," + attributeObj[i].<%= RFQConstants.EC_ATTR_CHANGEABLE %> + "," + attributeObj[i].<%= RFQConstants.EC_ATTR_MANDATORY %>;
    startDlistRow(rowselect);
    addDlistCheck(checkvalue, "parent.setChecked();myRefreshButtons();",null);
    addDlistColumn(ToHTML(attributeObj[i].<%= RFQConstants.EC_ATTR_NAME %>));
        if(attributeObj[i].<%=RFQConstants.EC_ATTR_MANDATORY%> == 1)
	{
		mandatoy = "<%= UIUtil.toJavaScript(rfqNLS.get("yes")) %>";
	}
	else
	{
		mandatoy = "<%= UIUtil.toJavaScript(rfqNLS.get("no")) %>";
	}
    addDlistColumn(mandatoy);
    if(attributeObj[i].<%=RFQConstants.EC_ATTR_CHANGEABLE%> == 1)
	{
		changeable = "<%= UIUtil.toJavaScript(rfqNLS.get("yes")) %>";
	}
	else
	  {
		changeable = "<%= UIUtil.toJavaScript(rfqNLS.get("no")) %>";
	  }
    addDlistColumn(changeable);
  
    addDlistColumn(ToHTML(attributeObj[i].<%= RFQConstants.EC_ATTR_REQ_OPERATOR_DES %>));
   if ( attributeObj[i].<%= RFQConstants.EC_ATTR_TYPE %> == "<%= com.ibm.commerce.utf.utils.UTFConstants.EC_ATTRTYPE_ATTACHMENT %>")
   {
        value ="<a href=\"javascript:view('"+attributeObj[i].<%= RFQConstants.EC_ATTR_REQ_VALUE %>+"','"+attributeObj[i].<%= RFQConstants.EC_PATTRVALUE_ID %>+ "');\"> " + attributeObj[i].req_filename +"</a>";
   }else 
   {
        value = getFormatedValue(attributeObj[i].<%= RFQConstants.EC_ATTR_REQ_VALUE %>,attributeObj[i].<%= RFQConstants.EC_ATTR_TYPE %>);
        value =ToHTML(value);
    }
    addDlistColumn(value);
    addDlistColumn(attributeObj[i].<%= RFQConstants.EC_ATTR_REQ_UNIT_DESC %>);
    addDlistColumn(attributeObj[i].<%= RFQConstants.EC_ATTR_OPERATOR_DES %>);
   if ( attributeObj[i].<%= RFQConstants.EC_ATTR_TYPE %> == "<%= com.ibm.commerce.utf.utils.UTFConstants.EC_ATTRTYPE_ATTACHMENT %>")
   {
            value ="<a href=\"javascript:view('"+attributeObj[i].<%= RFQConstants.EC_ATTR_VALUE %>+"','"+attributeObj[i].<%= RFQConstants.EC_ATTR_RES_VALUE_ID %>+ "');\"> " + attributeObj[i].res_filename +"</a>";
   }else 
   {
            value = getFormatedValue(attributeObj[i].<%= RFQConstants.EC_ATTR_VALUE %>,attributeObj[i].<%= RFQConstants.EC_ATTR_TYPE %>);
            value = ToHTML(value);
    }
    
    addDlistColumn(value);
    addDlistColumn(attributeObj[i].<%= RFQConstants.EC_ATTR_UNIT_DESC %>);
    endDlistRow(); 
    if (rowselect == 1)
   	rowselect = 2;
    else
   	rowselect =1;
   }
   endDlistTable();
   return;
  
}
output();
</script>
</form>

<script type="text/javascript">
parent.afterLoads();
if (attributeObj != null)
	parent.setResultssize(attributeObj.length);
else
	parent.setResultssize(0);
</script>

</body>
</html>

