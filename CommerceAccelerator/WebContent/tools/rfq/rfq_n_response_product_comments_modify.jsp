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
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="../common/List.jsp" %>
<%
   Locale   aLocale = null;
   Integer langId = null;
   boolean wrap = true;
   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
   JSPHelper jsphelper = new JSPHelper(request);     
   if( aCommandContext!= null ){
        aLocale = aCommandContext.getLocale();
        langId = aCommandContext.getLanguageId();
   }
   if (aLocale == null) aLocale = new Locale("en","US");
   // obtain the resource bundle for display
   Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS", aLocale);   
   //no wrapping for the asian languages
   if(langId.intValue() <= -7 && langId.intValue() >= -10) { wrap = false; }
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
var commentsObj;
commentsObj = top.getData("<%= RFQConstants.EC_ATTR_PRODUCT_COMMENTS %>",1);	
function doNothing() { 
	; 
}
function onLoad() {
	parent.loadFrames();
}
function getCheckedTCs() {
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
function userInitialButtons() {
	parent.setChecked();
	var objArray = new Array();
	objArray = parent.getChecked();
	if (objArray.length == 0)
       return;
	var tmp;
	var tmpArray=new Array();    
	var changeable = true;
    for (var i = 0; i<objArray.length; i++) {
		tmp = objArray[i];
		tmpArray=objArray[i].split(',');
		if(tmpArray[1] == 0) {
	  		changeable = false;
	  		break;
		}
	} 
    var mandatory = false;
    for (var i=0; i<objArray.length; i++)	{
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
function changeComments(){
	if(isButtonDisabled(parent.buttons.buttonForm.changeButton))
		return;
	var index = getCheckedTCs();
	top.saveModel(parent.parent.model);
	top.saveData(commentsObj[index[0].Id], "commentsData");		
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqresponseproductcommentsmodifydialog";
	top.setReturningPanel("resAttributes");
	top.setContent(getNewBCT(),url,true);
}
function isButtonDisabled(b) {
	if (b.className =='disabled' )
		return true;
	return false;
}  
function cleanComments(){
	if(isButtonDisabled(parent.buttons.buttonForm.rfqclearButton))
             return;	
	index = getCheckedTCs();
	for ( var i =0;i<index.length;i++) {
		commentsObj[index[i].Id].<%= RFQConstants.EC_ATTR_RES_COMMENTS_VALUE %> = ""
		commentsObj[index[i].Id].<%= RFQConstants.EC_ATTR_VALUE %> = ""
		commentsObj[index[i].Id].<%= RFQConstants.EC_RFQ_CHANGE_STATUS %> = "<%= RFQConstants.EC_RFQ_CHANGE_TRUE %>";
		savePanelData();
	}
	parent.document.forms[0].submit();	
}

function goBack(){
	top.goBack();
}

function getNewBCT() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("resmodifyproductcomments")) %>";
}
function savePanelData() {
    
}
function validatePanelData(){
	return true;
}

</script>
</head>

<body class="content">

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
if ((commentsObj!=null)&&( commentsObj.length > 0) ) {
	if (endIndex > commentsObj.length){
		endIndex = commentsObj.length;
	}
}		
if (startIndex < 0) startIndex=0;
if (commentsObj == null || commentsObj.length < 1 ) {
	endIndex = 0;
	parent.set_t_item(0);
	parent.set_t_page(1);
} else {
	numpage  = Math.ceil(commentsObj.length / listSize);
	parent.set_t_item(commentsObj.length);
	parent.set_t_page(numpage);
}
</script>

	<%= comm.startDlistTable((String)rfqNLS.get("rfqlisttitle")) %>
	<%= comm.startDlistRowHeading() %>
	<%= comm.addDlistCheckHeading(true,"selectDeselectAll()") %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("mandatory"),"null",false,"10%",wrap ) %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqchangeable"),"null",false,"10%",wrap ) %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("type"),"null",false,"10%",wrap ) %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqcomments"),"null",false,"30%",wrap ) %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rescomments"),"null",false,"40%",wrap ) %>
	<%= comm.endDlistRow() %>
<script type="text/javascript">
function output() {
	var checkvalue;
	var rowselect = 1;  
	if (commentsObj == null || commentsObj == undefined ) return ;
	for (var i = startIndex ;i <endIndex;i++) { 
    	checkname =  i;
    	checkvalue = i + "," + commentsObj[i].<%=RFQConstants.EC_ATTR_CHANGEABLE%> + "," + commentsObj[i].<%=RFQConstants.EC_ATTR_MANDATORY%>;
    	startDlistRow(rowselect);
    	addDlistCheck(checkvalue, "setSelectDeselectFalse();myRefreshButtons();",null);
    	if(commentsObj[i].<%=RFQConstants.EC_ATTR_MANDATORY%> == 1) {
			mandatoy = "<%= UIUtil.toJavaScript(rfqNLS.get("yes")) %>";
		} else {
			mandatoy = "<%= UIUtil.toJavaScript(rfqNLS.get("no")) %>";
		}
    	addDlistColumn(mandatoy);
    	if(commentsObj[i].<%=RFQConstants.EC_ATTR_CHANGEABLE%> == 1) {
			changeable = "<%= UIUtil.toJavaScript(rfqNLS.get("yes")) %>";
		} else {
			changeable = "<%= UIUtil.toJavaScript(rfqNLS.get("no")) %>";
	  	}
    	addDlistColumn(changeable);
    	addDlistColumn(ToHTML(commentsObj[i].<%= RFQConstants.EC_ATTR_NAME %>));
    	addDlistColumn(ToHTML(commentsObj[i].<%= RFQConstants.EC_ATTR_REQ_COMMENTS_VALUE %>));
    	addDlistColumn(ToHTML(commentsObj[i].<%= RFQConstants.EC_ATTR_RES_COMMENTS_VALUE %>));
   	 	endDlistRow();
    	if ( rowselect == 1 ) rowselect = 2; else rowselect = 1;    
	}
	endDlistTable();
	return ;
}
output();
</script>
</form>
<script type="text/javascript">
parent.afterLoads();
if (commentsObj != null)
	parent.setResultssize(commentsObj.length);
else
	parent.setResultssize(0);
</script>
</body>
</html>
