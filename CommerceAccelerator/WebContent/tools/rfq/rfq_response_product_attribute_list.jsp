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
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.ubf.util.*" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="../common/List.jsp" %>
<%
    String StoreId = "0";
    Locale aLocale = null;
    Integer langId = null;
    boolean wrap = true;
    //***Get storeId from CommandContext
    CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
    String ErrorMessage = request.getParameter(com.ibm.commerce.tools.common.ui.UIProperties.SUBMIT_ERROR_MESSAGE);
    if (ErrorMessage == null) {
    	ErrorMessage = "";
    }
    if( aCommandContext!= null ) {
        StoreId = aCommandContext.getStoreId().toString();
        langId = aCommandContext.getLanguageId();
        aLocale = aCommandContext.getLocale();
    }
    //no wrapping for the asian languages
    if(langId.intValue() <= -7 && langId.intValue() >= -10) { wrap = false; }
    // obtain the resource bundle for display
    Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS",aLocale);      
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale)%>" type="text/css" />
<title></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/rfq/rfqUtile.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script type="text/javascript">
function view(attachment_id, pattrvalue_id) {
	var url = "RFQAttachmentView?<%= com.ibm.commerce.server.ECConstants.EC_ATTACH_ID %>=" + attachment_id + "&<%= com.ibm.commerce.rfq.utils.RFQConstants.EC_PATTRVALUE_ID %>=" + pattrvalue_id;
	var windowTitle = "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_Attachment")) %>";
	var attributes = 'left=0,top=0,width=1014,height=710,scrollbars=no,toolbar=no,directories=no,status=no,menubar=no,copyhistory=no,resizable=yes';
	var attachmentWindow = top.openChildWindow(url, windowTitle, attributes);
}
function onLoad() { 
	parent.loadFrames(); 
}
var anProduct = new Object();
if (top.getData("anProduct") != undefined && top.getData("anProduct") != null) {   
	anProduct = top.getData("anProduct");
	top.saveData(null,"anProduct");
} else {
	anProduct = top.getData("anProduct", 1);
}
var allProducts = new Array();
allProducts = top.getData("allProducts", 1);
function getAttributeByID(tcID) {
	var anTC = new Object();
  	for (var i=0;i < anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>.length ;i++) {
		if(anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%=RFQConstants.EC_PATTRVALUE_ID%> == tcID) {
			anTC = anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i];
			break;
   	    }
  	}
  	return anTC;
}
function getCheckedAttribute() {
  	var theArray = new Array();
	var Ids = new Array();
	var form = document.rfqListForm;
	for (var i=0; i< form.elements.length; i++) {
	    if (form.elements[i].type == 'checkbox' && form.elements[i].checked) {
	        theArray[theArray.length] = form.elements[i].value;
	    }
	}
	if (theArray.length != null && theArray.length == 1) {
	    var checkedEntries = parent.getChecked().toString();
	    temp = checkedEntries.split(",");
	    Ids[0] = new Object();
	    Ids[0].Id = temp[0];
	    Ids[0].changeable = temp[1];
	    Ids[0].mandatory = temp[2];
	    Ids[0].userDefined = temp[3];
	}
  	return Ids;
}
function setSelectDeselectFalse() {
	document.rfqListForm.select_deselect.checked = false;
}
function myRefreshButtons() {
    parent.setChecked();
	var aList=new Array();
	aList = parent.getChecked();
	if (aList.length == 0) {
	    return;
	}	       
	var tmp;
	var tmpArray=new Array();	    
	var changeable = true;
	for (var i = 0;i<aList.length;i++) {
	    tmp = aList[i];
	    tmpArray=aList[i].split(',');	
	    if(tmpArray[1] == 0) {
	  		changeable = false;
			break;
	    }
	}   
	var mandatory = false;
	for (var i=0;i<aList.length;i++) {
	    tmp = aList[i];
	    tmpArray=aList[i].split(',');	    
	    if(tmpArray[2] == 1) {
			mandatory = true;
			break;
	    }
  	}	
	var respondBtn = true;
	var clearBtn =true;
	if(!changeable) {
	    respondBtn=clearBtn=false;
	}
	if(mandatory) {
	    clearBtn= false; 
	}	
	if (parent.buttons.buttonForm.rfqresponseButton && !respondBtn) {
	    parent.buttons.buttonForm.rfqresponseButton.className='disabled';
	    parent.buttons.buttonForm.rfqresponseButton.disabled=true;
	    parent.buttons.buttonForm.rfqresponseButton.id='disabled';
	}	
	if (parent.buttons.buttonForm.rfqclearButton && !clearBtn) {
	    parent.buttons.buttonForm.rfqclearButton.className='disabled';
	    parent.buttons.buttonForm.rfqclearButton.disabled=true;
	    parent.buttons.buttonForm.rfqclearButton.id='disabled';
	}    
	return;
} //end function 
function userInitialButtons() {
	parent.setChecked();
	var aList=new Array();
	aList = parent.getChecked();
	if (aList.length == 0) {
	    return;
	}	       
	var tmp;
	var tmpArray=new Array();	    
	var changeable = true;
	for (var i = 0;i<aList.length;i++) {
	    tmp = aList[i];
	    tmpArray=aList[i].split(',');	
	    if(tmpArray[1] == 0) {
	 		changeable = false;
			break;
	    }
	}   
	var mandatory = false;
	for (var i=0;i<aList.length;i++) {
	    tmp = aList[i];
	    tmpArray=aList[i].split(',');	    
	    if(tmpArray[2] == 1) {
	  		mandatory = true;
			break;
	    }
   	}	
	var respondBtn = true;
	var clearBtn =true;
	if(!changeable) {
	    respondBtn=clearBtn=false;
	}
	if(mandatory) {
	    clearBtn= false; 
	}	
	if (parent.buttons.buttonForm.rfqresponseButton && !respondBtn) {
	    parent.buttons.buttonForm.rfqresponseButton.className='disabled';
	    parent.buttons.buttonForm.rfqresponseButton.disabled=true;
	    parent.buttons.buttonForm.rfqresponseButton.id='disabled';
	}	
	if (parent.buttons.buttonForm.rfqclearButton && !clearBtn) {
	    parent.buttons.buttonForm.rfqclearButton.className='disabled';
	    parent.buttons.buttonForm.rfqclearButton.disabled=true;
	    parent.buttons.buttonForm.rfqclearButton.id='disabled';
	}    
	return;
} //end function 
function selectDeselectAll() {
	for (var i=0; i<document.rfqListForm.elements.length; i++) {
	    var e = document.rfqListForm.elements[i];
	    if (e.name != 'select_deselect') {
			e.checked = document.rfqListForm.select_deselect.checked;
	    }
	}
	myRefreshButtons();
}
function getAnAttribute() { 
 	var anComment = new Object();
	var CommentID;
	var tc = new Array();
	tc = getCheckedAttribute();
	if (tc.length == 1) {
	    CommentID = tc[0].Id;
	    anComment = getAttributeByID(CommentID);  
	}
	return anComment;
}	
function getNewBCT3() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfqresponse")) %>";
}
function newPrdEntry() {
	if(isButtonDisabled(parent.buttons.buttonForm.rfqresponseButton)) {
	    return;
	}
	var anAttribute = new Object;
	anAttribute = getAnAttribute();
	top.saveData(anAttribute,"anAttribute");
	top.saveData(anProduct,"anProduct");	
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqresponseproductrespond";
	if (top.setReturningPanel) 
	    top.setReturningPanel("rfqProducts");			
	if (top.setContent) {
	    top.setContent(getNewBCT3(),url,true);
	} else {
	    parent.parent.location.replace(url);
	} 
}	
function savePanelData() {
	for(var i = 0;i < allProducts.length;i++) {
	    if (allProducts[i].<%=RFQConstants.EC_RFQ_OFFERING_PRODUCTID%> == anProduct.<%=RFQConstants.EC_RFQ_OFFERING_PRODUCTID%>) {
            allProducts[i] = anProduct; 
	        break; 
	    }
	}
	top.sendBackData(allProducts,"allProducts");
}
function isButtonDisabled(b) {
	if (b.className =='disabled') {
		return true;
	}
	return false;
}       
function clearProAttribute() {
	if(isButtonDisabled(parent.buttons.buttonForm.rfqclearButton)) {
	    return;
	}
	var aList = parent.getChecked();
	for (var i=0;i < anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>.length ;i++) {
	    for(var j = 0;j < aList.length;j++) {
			if(anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%=RFQConstants.EC_PATTRVALUE_ID%> == aList[j].split(',')[0]) {
	    	    anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%=RFQConstants.EC_ATTR_VALUE%> = "";
	    	    anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].operatorName = "";
	    	    anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].res_filename = "";
	    	    anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].UnitDsc = "";
	    	}
	    }
	}  
	top.saveData(anProduct,"anProduct");
	parent.document.forms[0].submit();
}
function goBack() {
	top.goBack();
}
function getFormatedValue(value,type) {
	var tempvalue;
	if (value == undefined || value == null || value == "") {
	    return("");
	}
	tempvalue = value;
    switch (type) {
  	    case "D":
    		var values = new Array();
			values =tempvalue.split(' ');
			var tokens = values[0].split('-');
			tempvalue = getFormattedDate(tokens[0], tokens[1], tokens[2], "<%= aLocale.toString() %>");
    		break;
    	default:
   	}
   	return tempvalue;
}

//-->
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

    var listSize = <%= listSize %>;
    var startIndex = <%= startIndex %>;
    var endIndex   = <%= endIndex %>;
    if(startIndex < 0) 
    {
	startIndex = 0;
    }
    if ((anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>!=null)&&( anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>.length > 0) )
    {
    	if (endIndex > anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>.length)
	{
	    endIndex = anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>.length;
	}
    }
		
    if (anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%> == null || anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>.length < 1)
    {
	endIndex = 0;
	parent.set_t_item(0);
	parent.set_t_page(1);
    }
    else 
    {
	numpage  = Math.ceil(anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>.length / listSize);
	parent.set_t_item(anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>.length);
	parent.set_t_page(numpage);
    }
</script>

<%= comm.startDlistTable((String)rfqNLS.get("rfqterms")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true,"selectDeselectAll()") %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("name"),"null",false,"12%", wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("mandatory"),"null",false,"11%", wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqchangeable"),"null",false,"11%", wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqoperator"),"null",false,"11%", wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("resrequestvalue"),"null",false,"11%", wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("resrequestunit"),"null",false,"11%", wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqoperator"),"null",false,"11%", wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("resresponsevalue"),"null",false,"11%", wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("resresponseunit"),"null",false,"11%", wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("userdefined"),"null",false,"11%", wrap )%>
<%= comm.endDlistRow() %>

<script type="text/javascript">
    var checkname;
    var checkvalue;
    var s,changeable,mandatory;
    var rowselect = 1;
    var value;
    s ="";
    changeable="";
    mandatory ="";

    for (var i = startIndex ;i <endIndex;i++)
    { 
   	checkname = "checkname_" + i;
        checkvalue = anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%=RFQConstants.EC_PATTRVALUE_ID%> + "," 
		   + anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%=RFQConstants.EC_ATTR_CHANGEABLE%> + "," 
		   + anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%=RFQConstants.EC_ATTR_MANDATORY%> + "," 
		   + anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].req_userDefined;

	if(anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%=RFQConstants.EC_ATTR_MANDATORY%> == 1)
	{
	    mandatoy = "<%= UIUtil.toJavaScript(rfqNLS.get("yes")) %>";
	}
	else
	{
	    mandatoy = "<%= UIUtil.toJavaScript(rfqNLS.get("no")) %>";
	}

    	if(anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%=RFQConstants.EC_ATTR_CHANGEABLE%> == 1)
	{
	    changeable = "<%= UIUtil.toJavaScript(rfqNLS.get("yes")) %>";
	}
	else
	{
	    changeable = "<%= UIUtil.toJavaScript(rfqNLS.get("no")) %>";
	}
	
        startDlistRow(rowselect);
	addDlistCheck(checkvalue, "setSelectDeselectFalse();myRefreshButtons()", null);
	addDlistColumn(ToHTML(anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%=RFQConstants.EC_ATTR_DESCRIPTION%>));
	addDlistColumn(mandatoy);
	addDlistColumn(changeable);
	addDlistColumn(anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].req_operator);
	
	if ( anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%= RFQConstants.EC_ATTR_TYPE %> == "<%= com.ibm.commerce.utf.utils.UTFConstants.EC_ATTRTYPE_ATTACHMENT %>")
	{
	        value ="<a href=\"javascript:view('"+anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%= RFQConstants.EC_ATTR_REQ_VALUE %>+"','"+anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%= RFQConstants.EC_PATTRVALUE_ID %>+ "');\"> " + anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].req_filename +"</a>";
	}else 
        {
	value = getFormatedValue(ToHTML(anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].req_value),anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%=RFQConstants.EC_ATTR_TYPE%>);
	}
	addDlistColumn(value);
	addDlistColumn(anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].req_unit);
	addDlistColumn(anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].operatorName);
	
	if ( anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%= RFQConstants.EC_ATTR_TYPE %> == "<%= com.ibm.commerce.utf.utils.UTFConstants.EC_ATTRTYPE_ATTACHMENT %>")
	{
	            value ="<a href=\"javascript:view('"+anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%= RFQConstants.EC_ATTR_VALUE %>+"','"+anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%= RFQConstants.EC_PATTRVALUE_ID %>+ "');\"> " + anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].res_filename +"</a>";
	}else 
        {
	value = getFormatedValue(ToHTML(anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%=RFQConstants.EC_ATTR_VALUE%>),anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%=RFQConstants.EC_ATTR_TYPE%>);
	}
	
	addDlistColumn(value);
	addDlistColumn(anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].UnitDsc);

  	if(anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].req_userDefined == "Y")
	{
	    addDlistColumn("<%= UIUtil.toJavaScript(rfqNLS.get("yes")) %>");
	}
	else
	{
	    addDlistColumn("<%= UIUtil.toJavaScript(rfqNLS.get("no")) %>");
	}

    	endDlistRow();
    	
    	if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }
    }
</script>

<%= comm.endDlistTable() %>
</form>

<script type="text/javascript">
parent.afterLoads();
if (anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%> != null) {
 	parent.setResultssize(anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>.length);
} else {
  	parent.setResultssize(0);
}
</script>

</body>
</html>
